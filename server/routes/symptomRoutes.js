import express from "express";
import {
  analyzeSymptom,
  getSymptomHistory,
  getSymptomById,
  deleteSymptom
} from "../controllers/symptomController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

router.post("/analyze", protect, analyzeSymptom);
router.get("/history", protect, getSymptomHistory);
router.get("/:id", protect, getSymptomById);
router.delete("/:id", protect, deleteSymptom);

export default router;