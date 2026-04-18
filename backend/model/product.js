import mongoose from "mongoose";

import { connectDB } from "../config/db.js";
import { rate } from "../controllers/userActions.js";

const { Schema } = mongoose;

const ProductSchema = new Schema({
  name: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  rating: {
    type: Number,
    min: 0,
    max: 5,
    default: 0,
  },
  rates: [
    {
      user: {
        type: Schema.Types.ObjectId,
        ref: "User",
      },
      rate: {
        type: Number,
        min: 0,
        max: 5,
        default: 0,
      },
    },
  ],
  totalQuantity: {
    type: Number,
    required: true,
  },
  sizeQuantities: [
    {
      size: {
        type: String,
        required: true,
        enum: ["S", "M", "L", "XL"],
      },
      quantity: {
        type: Number,
        required: true,
        min: 0,
      },
    },
  ],
  store: {
    type: Schema.Types.ObjectId,
    ref: "Store",
  },
  imageUrl: [
    {
      type: String,
      default: "",
    }
  ],
  category: {
    type: String,
    required: true,
  },
  gender: {
    type: String,
    required: true,
    enum: ["male", "female", "unisex"],
  },
});

export const productModel = mongoose.model("Product", ProductSchema);
