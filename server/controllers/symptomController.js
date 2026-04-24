import Symptom from "../models/Symptom.js";
import {
  extractKeywords,
  detectIssue
} from "../utils/keywordExtractor.js";

// ─── Analyze Symptoms ────────────────────────────
// @route POST /api/symptom/analyze
export const analyzeSymptom = async (req, res) => {
  try {
    const { text } = req.body;
    const userId = req.user._id;

    // Extract keywords from text
    const keywords = extractKeywords(text);

    // Detect main issue
    const detectedIssue = detectIssue(keywords);

    // Calculate risk level based on keywords
    let riskLevel = "low";
    if (keywords.length >= 5) riskLevel = "high";
    else if (keywords.length >= 3) riskLevel = "moderate";
    else if (keywords.length >= 1) riskLevel = "mild";

    // Save to database
    const symptom = await Symptom.create({
      userId,
      text,
      keywords: keywords.map(k => k.keyword),
      detectedIssue,
      riskLevel
    });

    res.status(201).json({
      success: true,
      symptomId: symptom._id,
      text,
      keywords,
      detectedIssue,
      riskLevel,
      disclaimer: "This is not a medical diagnosis. Please consult a professional."
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Symptom History ─────────────────────────
// @route GET /api/symptom/history
export const getSymptomHistory = async (req, res) => {
  try {
    const userId = req.user._id;

    const symptoms = await Symptom.find({ userId })
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: symptoms.length,
      symptoms
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Single Symptom ──────────────────────────
// @route GET /api/symptom/:id
export const getSymptomById = async (req, res) => {
  try {
    const symptom = await Symptom.findById(req.params.id);

    if (!symptom) {
      return res.status(404).json({ message: "Symptom not found" });
    }

    res.json({
      success: true,
      symptom
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Delete Symptom ──────────────────────────────
// @route DELETE /api/symptom/:id
export const deleteSymptom = async (req, res) => {
  try {
    const symptom = await Symptom.findById(req.params.id);

    if (!symptom) {
      return res.status(404).json({ message: "Symptom not found" });
    }

    await symptom.deleteOne();

    res.json({
      success: true,
      message: "Symptom deleted successfully"
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};