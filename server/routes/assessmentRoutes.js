import express from "express";
import {
  submitPHQ9,
  submitGAD7,
  submitQuickCheck,
  getAssessmentHistory,
  getAssessmentById,
  getLatestAssessment,
  analyzeWithML // ✅ added
} from "../controllers/assessmentController.js";

import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

// ─── Assessment Routes ───────────────────────────

// PHQ9
router.post("/phq9", protect, submitPHQ9);

// GAD7
router.post("/gad7", protect, submitGAD7);

// Quick Check
router.post("/quick", protect, submitQuickCheck);

// ML Text Analysis (🔥 new feature)
router.post("/ml-analyze", protect, analyzeWithML);

// History
router.get("/history", protect, getAssessmentHistory);

// Latest
router.get("/latest", protect, getLatestAssessment);

// Get by ID
router.get("/:id", protect, getAssessmentById);

export default router;