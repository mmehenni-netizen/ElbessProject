import express from "express";

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
