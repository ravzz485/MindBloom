import Assessment from "../models/Assessment.js";
import {
  calculatePHQ9Risk,
  calculateGAD7Risk,
  calculateQuickRisk
} from "../utils/riskScoring.js";
import {
  extractKeywords,
  detectIssue
} from "../utils/keywordExtractor.js";

// ─── PHQ9 Assessment ────────────────────────────
// @route POST /api/assessment/phq9
export const submitPHQ9 = async (req, res) => {
  try {
    const { answers } = req.body;
    const userId = req.user._id;

    // Calculate score
    const score = answers.reduce((a, b) => a + b, 0);
    const risk = calculatePHQ9Risk(score);

    // Save to database
    const assessment = await Assessment.create({
      userId,
      type: "PHQ9",
      answers: answers.map((answer, index) => ({
        question: `Q${index + 1}`,
        answer
      })),
      score,
      riskLevel: risk.level,
      possibleIssue: "depression"
    });

    res.status(201).json({
      success: true,
      assessmentId: assessment._id,
      score,
      maxScore: 27,
      riskLevel: risk.level,
      color: risk.color,
      message: risk.message,
      disclaimer: "This is not a medical diagnosis. Please consult a professional."
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── GAD7 Assessment ────────────────────────────
// @route POST /api/assessment/gad7
export const submitGAD7 = async (req, res) => {
  try {
    const { answers } = req.body;
    const userId = req.user._id;

    const score = answers.reduce((a, b) => a + b, 0);
    const risk = calculateGAD7Risk(score);

    const assessment = await Assessment.create({
      userId,
      type: "GAD7",
      answers: answers.map((answer, index) => ({
        question: `Q${index + 1}`,
        answer
      })),
      score,
      riskLevel: risk.level,
      possibleIssue: "anxiety"
    });

    res.status(201).json({
      success: true,
      assessmentId: assessment._id,
      score,
      maxScore: 21,
      riskLevel: risk.level,
      color: risk.color,
      message: risk.message,
      disclaimer: "This is not a medical diagnosis. Please consult a professional."
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Quick Check Assessment ─────────────────────
// @route POST /api/assessment/quick
export const submitQuickCheck = async (req, res) => {
  try {
    const { answers } = req.body;
    const userId = req.user._id;

    const score = answers.reduce((a, b) => a + b, 0);
    const risk = calculateQuickRisk(score);

    const assessment = await Assessment.create({
      userId,
      type: "quick",
      answers: answers.map((answer, index) => ({
        question: `Q${index + 1}`,
        answer
      })),
      score,
      riskLevel: risk.level,
      possibleIssue: "general"
    });

    res.status(201).json({
      success: true,
      assessmentId: assessment._id,
      score,
      riskLevel: risk.level,
      color: risk.color,
      message: risk.message,
      disclaimer: "This is not a medical diagnosis. Please consult a professional."
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Assessment History ──────────────────────
// @route GET /api/assessment/history
export const getAssessmentHistory = async (req, res) => {
  try {
    const userId = req.user._id;

    const assessments = await Assessment.find({ userId })
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: assessments.length,
      assessments
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Single Assessment ───────────────────────
// @route GET /api/assessment/:id
export const getAssessmentById = async (req, res) => {
  try {
    const assessment = await Assessment.findById(req.params.id);

    if (!assessment) {
      return res.status(404).json({ message: "Assessment not found" });
    }

    res.json({
      success: true,
      assessment
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Latest Assessment ───────────────────────
// @route GET /api/assessment/latest
export const getLatestAssessment = async (req, res) => {
  try {
    const userId = req.user._id;

    const assessment = await Assessment.findOne({ userId })
      .sort({ createdAt: -1 });

    if (!assessment) {
      return res.status(404).json({ message: "No assessments found" });
    }

    res.json({
      success: true,
      assessment
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};