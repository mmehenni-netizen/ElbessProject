import express from "express";
import dotenv from "dotenv";

import { connectDB } from "./config/db.js";
import authRoute from "./routes/auth.js";
import actionsRoute from "./routes/actions.js";
import fetchRoute from "./routes/fetch.js";

const app = express();
const PORT = process.env.PORT || 5000;
const HOST = process.env.HOST || "0.0.0.0";

dotenv.config();

app.use(express.json());
app.use("/api/auth", authRoute);
app.use("/api/actions", actionsRoute);
app.use("/api/fetch", fetchRoute);

app.listen(PORT, HOST, () => {
  connectDB();
  console.log(`server is running on http://${HOST}:${PORT}`);
});
