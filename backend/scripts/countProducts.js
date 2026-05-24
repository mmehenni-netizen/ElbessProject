import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";
import { connectDB } from "../config/db.js";
import { productModel } from "../model/product.js";

// Resolve __dirname for ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load .env from backend folder
dotenv.config({ path: path.resolve(__dirname, "../.env") });

const run = async () => {
  try {
    await connectDB();

    const count = await productModel.countDocuments();
    console.log(`Products count: ${count}`);

    const products = await productModel.find().limit(50).select("name");
    console.log("Sample products:");
    products.forEach((p) => console.log(`- ${p._id}  ${p.name}`));

    process.exit(0);
  } catch (err) {
    console.error("Error counting products:", err);
    process.exit(1);
  }
};

run();
