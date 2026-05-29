import dotenv from "dotenv";
dotenv.config(); // ✅ Must be first

import express from "express";
import cors from "cors";
import { connectDB } from "./config/db.js";
import authRoute from "./routes/auth.js";
import actionsRoute from "./routes/actions.js";
import debugRoute from "./routes/debug.js";
import fetchRoute from "./routes/fetch.js";

const app = express();

const PORT = process.env.PORT || 5000;
const HOST = process.env.HOST || "0.0.0.0";

app.use(cors());
app.use(express.json()); // ✅ Only this, no express.text()
app.use("/uploads", express.static("uploads"));
app.use("/api/auth", authRoute);
app.use("/api/actions", actionsRoute);
app.use("/api/fetch", fetchRoute);
app.use("/api/debug", debugRoute);

const startServer = async () => {
  try {
    await connectDB();
  } catch (error) {
    console.log(`Database connection failed: ${error.message}`);
  }

  app.listen(PORT, HOST, () => {
    console.log(`Server running on http://${HOST}:${PORT}`);
  });
};

startServer();
