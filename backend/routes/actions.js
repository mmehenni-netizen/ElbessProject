import {
  setProfile,
  setFavorite,
  rate,
  getRate,
  getProfile,
  checkout,
} from "../controllers/userActions.js";

import express from "express";

import { checkAuth } from "../middleware/auth.js";

const router = express.Router();

router.post("/set-profile", checkAuth, setProfile);
router.post("/set-favorite", checkAuth, setFavorite);
router.post("/rate", checkAuth, rate);
router.get("/rate", checkAuth, getRate);
router.get("/get-profile",   checkAuth, getProfile);
router.post("/checkout", checkAuth, checkout);

export default router;
