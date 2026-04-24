import express from "express";
import {
  generateWeeklyProgress,
  getProgressHistory,
  getLatestProgress,
  getFullReport,
  getStressTrend
} from "../controllers/progressController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

router.post("/generate", protect, generateWeeklyProgress);
router.get("/history", protect, getProgressHistory);
router.get("/latest", protect, getLatestProgress);
router.get("/report", protect, getFullReport);
router.get("/stress-trend", protect, getStressTrend);

export default router;//fgfhfhf