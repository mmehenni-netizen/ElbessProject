import {
  setProfile,
  setFavorite,
  rate,
  checkout,
} from "../controllers/userActions.js";

import express from "express";

import { checkAuth } from "../middleware/auth.js";

const router = express.Router();

router.post("/set-profile", checkAuth, setProfile);
router.post("/set-favorite", checkAuth, setFavorite);
router.post("/rate", checkAuth, rate);
router.post("/checkout", checkAuth, checkout);

export default router;
