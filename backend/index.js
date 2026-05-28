import express from "express";
import dotenv from "dotenv";
import cors from "cors";

import { connectDB } from "./config/db.js";
import authRoute from "./routes/auth.js";
import actionsRoute from "./routes/actions.js";
import debugRoute from "./routes/debug.js";
import fetchRoute from "./routes/fetch.js";

const app = express();

dotenv.config();

const PORT = process.env.PORT || 5000;
const HOST = process.env.HOST || "0.0.0.0";
app.use(express.json());
// Also accept plain text bodies (some clients may send JSON with text/plain)
app.use(express.text({ type: 'text/*' }));
app.use(cors());
app.use("/uploads", express.static("uploads"));
app.use("/api/auth", authRoute);
app.use("/api/actions", actionsRoute);
app.use("/api/fetch", fetchRoute);
app.use("/api/debug", debugRoute);

const startServer = async () => {
  try {
    await connectDB();

    app.listen(PORT, HOST, () => {
      console.log(`server is running on http://${HOST}:${PORT}`);
    });
  } catch (error) {
    console.log(`Failed to start backend: ${error.message}`);
    process.exit(1);
  }
};

startServer();
