import express from "express";
import {
  getProducts,
  getStores,
  getProductById,
  getStoreById,
  getOrders,
  getFavorites,
} from "../controllers/fetch.js";

import { checkAuth } from "../middleware/auth.js";

const router = express.Router();

router.get("/get-stores", checkAuth, getStores);
router.get("/get-products", checkAuth, getProducts);

router.get("/get-store/:id", checkAuth, getStoreById);
router.get("/get-product/:id", checkAuth, getProductById);

router.get("/get-orders", checkAuth, getOrders);
router.get("/get-favorites", checkAuth, getFavorites);

export default router;
