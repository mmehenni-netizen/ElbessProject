// backend/scripts/seedStore.js
import mongoose from "mongoose";
import dotenv from "dotenv";
import { fileURLToPath } from "url";
import path from "path";
import { productModel } from "../model/product.js";
import { storeModel } from "../model/store.js";
import { connectDB } from "../config/db.js";

// Get current directory
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ✅ Load .env from backend folder (one level up from scripts)
dotenv.config({ path: path.resolve(__dirname, "../.env") });

const seedProduct = async () => {
  try {
    await connectDB();

    // Create product using Mongoose (auto-applies defaults)
    const product = await productModel.create({
      name: "Product A",
      description: "This is Product A",
      price: 19.99,
      totalQuantity: 100,
      sizeQuantities: [
        { size: "S", quantity: 5 },
        { size: "M", quantity: 5 },
        { size: "L", quantity: 10 },
        { size: "XL", quantity: 15 },
      ],
      store: "69e0288775bd65622393d6d9",
      category: "pants",
      gender: "male",
    });

    await storeModel.findByIdAndUpdate("69e0288775bd65622393d6d9", {
      $push: { products: product._id },
    });

    console.log("✅ Product created:", product._id);

    process.exit(0);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
};

seedProduct();
