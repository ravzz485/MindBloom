import express from "express";
import {
  submitCheckIn,
  getCheckInHistory,
  getTodayCheckIn,
  getWeeklySummary,
  getMoodTrend
} from "../controllers/checkInController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();
//abc
router.post("/submit", protect, submitCheckIn);
router.get("/history", protect, getCheckInHistory);
router.get("/today", protect, getTodayCheckIn);
router.get("/weekly", protect, getWeeklySummary);
router.get("/trend", protect, getMoodTrend);

export default router;