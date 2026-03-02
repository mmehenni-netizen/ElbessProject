import express from "express"
import dotenv from "dotenv"

import {connectDB} from "./config/db.js"
import authRoute from './routes/auth.js'

const app = express()
const PORT = process.env.PORT || 5000

dotenv.config()

app.use(express.json())
app.use("/api/auth", authRoute)

app.listen(PORT, () => {
    connectDB();
    console.log("server is running on port 5000")
})