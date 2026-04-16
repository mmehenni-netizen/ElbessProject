// backend/scripts/seedStore.js
import mongoose from "mongoose";
import dotenv from "dotenv";
import { fileURLToPath } from "url";
import path from "path";
import { storeModel } from "../model/store.js";
import { connectDB } from "../config/db.js";

// Get current directory
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ✅ Load .env from backend folder (one level up from scripts)
dotenv.config({ path: path.resolve(__dirname, "../.env") });

const seedStore = async () => {
  try {
    await connectDB();

    // Delete existing (optional)
    await storeModel.deleteMany({ name: "Store B" });

    // Create store using Mongoose (auto-applies defaults)
    const store = await storeModel.create({
      name: "Store B",
      description: "This is Store B",
      location: "Location B",
      address: "Address B",
      password: "passwordB", // Should hash this in real code
    });

    console.log("✅ Store created:", store._id);

    process.exit(0);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
};

seedStore();
