import express from "express";
const router = express.Router();

router.get("/", (req, res) => {
  res.json({ message: "Symptom routes working!" });
});

export default router;