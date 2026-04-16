import express from "express";
import {
  forgotPassword,
  login,
  logout,
  resetPassword,
  signup,
  verifyEmail,
} from "../controllers/auth.js";

const router = express.Router();

router.post("/signup", signup);
router.post("/logout", logout);
router.post("/login", login);

router.post("/verify-email", verifyEmail);
router.post("/forgot-password", forgotPassword);

router.post("/forgot-password/:token", resetPassword);

export default router;
