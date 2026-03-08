import mongoose from "mongoose";

export const connectDB = async () => {
    const maxRetries = 5
    const retryDelayMs = 5000

    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            const conn = await mongoose.connect(process.env.MONGO_URL, {
                serverSelectionTimeoutMS: 15000,
                connectTimeoutMS: 15000,
            })
            console.log(`Database connected :  ${conn.connection.host}`)
            return
        } catch (error) {
            console.log(`Errror connectiong to Database (attempt ${attempt}/${maxRetries}) : ${error.message}`)

            if (attempt === maxRetries) {
                console.log("Database connection failed after maximum retries. Check internet, DNS, and Atlas IP Access List.")
                process.exit(1)
            }

            await new Promise((resolve) => setTimeout(resolve, retryDelayMs))
        }
    }
}

