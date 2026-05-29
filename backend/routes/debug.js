import express from "express";
import { userModel } from "../model/user.js";

const router = express.Router();

// Echo endpoint for debugging incoming requests (do not keep in production)
router.post("/echo", (req, res) => {
  try {
    return res.status(200).json({
      success: true,
      body: req.body,
      headers: req.headers,
    });
  } catch (err) {
    return res.status(500).json({ success: false, message: err?.message || String(err) });
  }
});

export default router;

// Temporary debug endpoint: lookup user by email
// WARNING: remove or protect this in production.
router.get('/user', async (req, res) => {
  try {
    const email = (req.query.email || '').toString().trim();
    if (!email) return res.status(400).json({ success: false, message: 'email query required' });
    const user = await userModel.findOne({ email }).lean();
    if (!user) return res.status(404).json({ success: false, message: 'User not found' });
    // remove sensitive fields
    if (user.password) delete user.password;
    return res.status(200).json({ success: true, user });
  } catch (err) {
    return res.status(500).json({ success: false, message: err?.message || String(err) });
  }
});
