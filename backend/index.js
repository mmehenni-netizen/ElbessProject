import express from "express"
import dotenv from "dotenv"

import {connectDB} from "./config/db.js"
import authRoute from './routes/auth.js'

const app = express()
const PORT = process.env.PORT || 5000
const HOST = process.env.HOST || "0.0.0.0"

dotenv.config()

app.use(express.json())
app.use("/api/auth", authRoute)

const startServer = async () => {
    try {
        await connectDB()
        app.listen(PORT, HOST, () => {
            console.log(`server is running on http://${HOST}:${PORT}`)
        })
    } catch (error) {
        console.error("Server startup failed:", error.message)
        process.exit(1)
    }
}

startServer()