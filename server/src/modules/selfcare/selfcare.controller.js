const {
  getRecommendations,
  rateActivity,
  getActivityRatings,
  getEmergencySupport,
  saveJournalEntry,
  getJournalEntries,
  getBreathingPatterns,
  getJournalPrompts,
  getMLInsights,
} = require("./selfcare.service");
const { Activity } = require("./selfcare.model");

exports.getAllActivities = async (req, res) => {
  try {
    const { type, riskLevel } = req.query;
    const filter = {};
    if (type) filter.type = type;
    if (riskLevel) filter.riskLevel = riskLevel;
    const activities = await Activity.find(filter);
    res.json({ success: true, data: activities });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getRecommendations = async (req, res) => {
  try {
    const { userId, riskLevel } = req.body;
    if (!userId || !riskLevel) {
      return res.status(400).json({ success: false, message: "userId and riskLevel are required" });
    }
    const recommendations = await getRecommendations(userId, riskLevel);
    res.json({ success: true, data: recommendations });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.rateActivity = async (req, res) => {
  try {
    const { userId, activityId, rating, comment } = req.body;
    if (!userId || !activityId || !rating) {
      return res.status(400).json({ success: false, message: "userId, activityId and rating are required" });
    }
    if (rating < 1 || rating > 5) {
      return res.status(400).json({ success: false, message: "Rating must be between 1 and 5" });
    }
    const result = await rateActivity(userId, activityId, rating, comment);
    res.json({ success: true, data: result });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getActivityRatings = async (req, res) => {
  try {
    const { activityId } = req.params;
    const result = await getActivityRatings(activityId);
    res.json({ success: true, data: result });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getEmergencySupport = async (req, res) => {
  try {
    const activities = await getEmergencySupport();
    res.json({ success: true, data: activities });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.saveJournalEntry = async (req, res) => {
  try {
    const { userId, entry, mood, prompt } = req.body;
    if (!userId || !entry) {
      return res.status(400).json({ success: false, message: "userId and entry are required" });
    }
    const journal = await saveJournalEntry(userId, entry, mood, prompt);
    res.json({ success: true, data: journal });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getJournalEntries = async (req, res) => {
  try {
    const { userId } = req.params;
    if (!userId) {
      return res.status(400).json({ success: false, message: "userId is required" });
    }
    const entries = await getJournalEntries(userId);
    res.json({ success: true, data: entries });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getBreathingPatterns = async (req, res) => {
  try {
    const { riskLevel } = req.query;
    const patterns = await getBreathingPatterns(riskLevel);
    res.json({ success: true, data: patterns });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getJournalPrompts = async (req, res) => {
  try {
    const { mood } = req.query;
    const prompts = await getJournalPrompts(mood);
    res.json({ success: true, data: prompts });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getMLInsights = async (req, res) => {
  try {
    const { riskLevel } = req.query;
    if (!riskLevel) {
      return res.status(400).json({
        success: false,
        message: "riskLevel is required",
      });
    }
    const insights = await getMLInsights(riskLevel);
    res.json({ success: true, data: insights });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};