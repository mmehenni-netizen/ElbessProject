import mongoose from "mongoose";
import dns from "node:dns";

const dnsServers = (process.env.DNS_SERVERS || "8.8.8.8,1.1.1.1")
    .split(",")
    .map((server) => server.trim())
    .filter(Boolean)

dns.setServers(dnsServers)

const connectionOptions = {
    serverSelectionTimeoutMS: 15000,
    connectTimeoutMS: 15000,
}

const buildSeedListUriFromSrv = async (mongoSrvUrl) => {
    const parsed = new URL(mongoSrvUrl)

    if (parsed.protocol !== "mongodb+srv:") {
        return null
    }

    const srvRecords = await dns.promises.resolveSrv(`_mongodb._tcp.${parsed.hostname}`)

    if (!srvRecords.length) {
        return null
    }

    const hosts = srvRecords.map((record) => `${record.name}:${record.port}`).join(",")
    const queryParams = new URLSearchParams(parsed.searchParams)

    if (!queryParams.has("tls")) queryParams.set("tls", "true")
    if (!queryParams.has("authSource")) queryParams.set("authSource", "admin")
    if (!queryParams.has("retryWrites")) queryParams.set("retryWrites", "true")
    if (!queryParams.has("w")) queryParams.set("w", "majority")

    const databaseName = parsed.pathname && parsed.pathname !== "/" ? parsed.pathname.slice(1) : "test"
    const hasCredentials = parsed.username || parsed.password
    const credentials = hasCredentials
        ? `${encodeURIComponent(parsed.username)}:${encodeURIComponent(parsed.password)}@`
        : ""

    return `mongodb://${credentials}${hosts}/${databaseName}?${queryParams.toString()}`
}

export const connectDB = async () => {
    const maxRetries = 5
    const retryDelayMs = 5000
    const mongoUrl = process.env.MONGO_URL

    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            const conn = await mongoose.connect(mongoUrl, connectionOptions)
            console.log(`Database connected :  ${conn.connection.host}`)
            return
        } catch (error) {
            console.log(`Errror connectiong to Database (attempt ${attempt}/${maxRetries}) : ${error.message}`)

            if (error.message.includes("queryTxt ETIMEOUT") && mongoUrl?.startsWith("mongodb+srv://")) {
                console.log(`DNS TXT lookup timed out. Active DNS servers: ${dns.getServers().join(", ")}`)

                try {
                    const fallbackSeedListUrl = await buildSeedListUriFromSrv(mongoUrl)

                    if (fallbackSeedListUrl) {
                        console.log("Trying Atlas seed-list fallback (mongodb://host1,host2,host3...) to bypass TXT lookup.")
                        const fallbackConn = await mongoose.connect(fallbackSeedListUrl, connectionOptions)
                        console.log(`Database connected with fallback :  ${fallbackConn.connection.host}`)
                        return
                    }
                } catch (fallbackError) {
                    console.log(`Fallback seed-list connect failed: ${fallbackError.message}`)
                }
            }

            if (attempt === maxRetries) {
                throw new Error("Database connection failed after maximum retries. Check internet, DNS, and Atlas IP Access List.")
            }

            await new Promise((resolve) => setTimeout(resolve, retryDelayMs))
        }
    }
}

