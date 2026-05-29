import mongoose from "mongoose";

const { Schema } = mongoose;

const normalizeProductGender = (value) => {
  if (typeof value !== "string") {
    return value;
  }

  const normalized = value.trim().toLowerCase();

  if (normalized === "men") {
    return "male";
  }

  if (normalized === "women") {
    return "female";
  }

  return normalized;
};

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
  imageUrl: {
    type: [String],
    default: [],
  },
  
  category: {
    type: String,
    required: true,
  },
  gender: {
    type: String,
    required: true,
    set: normalizeProductGender,
    enum: ["male", "female", "unisex"],
  },
});

ProductSchema.pre("validate", function normalizeLegacyGender() {
  this.gender = normalizeProductGender(this.gender);
});

export const productModel = mongoose.model("Product", ProductSchema);
