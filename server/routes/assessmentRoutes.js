import express from "express";
const router = express.Router();

// placeholder route
router.get("/", (req, res) => {
  res.json({ message: "Assessment routes working!" });
});

export default router;