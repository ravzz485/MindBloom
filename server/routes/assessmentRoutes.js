import express from "express";
import {
  submitPHQ9,
  submitGAD7,
  submitQuickCheck,
  getAssessmentHistory,
  getAssessmentById,
  getLatestAssessment
} from "../controllers/assessmentController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

// All routes protected
router.post("/phq9", protect, submitPHQ9);
router.post("/gad7", protect, submitGAD7);
router.post("/quick", protect, submitQuickCheck);
router.get("/history", protect, getAssessmentHistory);
router.get("/latest", protect, getLatestAssessment);
router.get("/:id", protect, getAssessmentById);

export default router;