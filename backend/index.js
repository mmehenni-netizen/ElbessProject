import express from "express";
import dotenv from "dotenv";

import { connectDB } from "./config/db.js";
import authRoute from "./routes/auth.js";
import actionsRoute from "./routes/actions.js";
import fetchRoute from "./routes/fetch.js";

const app = express();

dotenv.config();

const PORT = process.env.PORT || 5000;
const HOST = process.env.HOST || "0.0.0.0";

app.use(express.json());
app.use("/uploads", express.static("uploads"));
app.use("/api/auth", authRoute);
app.use("/api/actions", actionsRoute);
app.use("/api/fetch", fetchRoute);

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
