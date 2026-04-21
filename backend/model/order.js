import mongoose from "mongoose";

import { connectDB } from "../config/db.js";

const { Schema } = mongoose;

const orderSchema = new Schema({
  user: {
    type: Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  store: {
    type: Schema.Types.ObjectId,
    ref: "Store",
    required: true,
  },

  product: {
    type: Schema.Types.ObjectId,
    ref: "Product",
    required: true,
  },

  quantity: {
    type: Number,
    required: true,
  },

  price: {
    type: Number,
    default: 0,
  },

  size: {
    type: String,
    required: true,
    trim: true,
  },

  name: {
    type: String,
    default: "",
    trim: true,
  },

  location: {
    type: String,
    default: "",
    trim: true,
  },

  numero: {
    type: String,
    default: "",
    trim: true,
  },

  office: {
    type: Boolean,
    required: true,
  },

  domicile: {
    type: Boolean,
    required: true,
  },

  confirmed: {
    type: Boolean,
    default: false,
  },

  rejected: {
    type: Boolean,
    default: false,
  },

  prepared: {
    type: Boolean,
    default: false,
  },

  shipped: {
    type: Boolean,
    default: false,
  },

  delivered: {
    type: Boolean,
    default: false,
  },

  canceled: {
    type: Boolean,
    default: false,
  },

  confirmationDate: {
    type: Date,
    default: null,
  },

  preparationDate: {
    type: Date,
    default: null,
  },

  shippingDate: {
    type: Date,
    default: null,
  },

  deliveryDate: {
    type: Date,
    default: null,
  },

  cancellationDate: {
    type: Date,
    default: null,
  },
});
export const orderModel = mongoose.model("Order", orderSchema);
