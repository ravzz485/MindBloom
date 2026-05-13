const { Activity, Recommendation, Journal } = require("./selfcare.model");
const Rating = require("../../../models/Rating");
const { getMLRecommendations, getActivityInsights } = require("./mlRecommender");

// Get personalized recommendations using ML
const getRecommendations = async (userId, riskLevel) => {
  // Get user's personal ratings
  const ratings = await Rating.find({ userId });
  const userRatingMap = {};
  ratings.forEach((r) => {
    userRatingMap[r.activityId.toString()] = r.rating;
  });

  // Get recently recommended activities
  const threeDaysAgo = new Date(Date.now() - 3 * 24 * 60 * 60 * 1000);
  const recentRec = await Recommendation.findOne({
    userId,
    generatedAt: { $gte: threeDaysAgo },
  }).populate("activities");

  const recentIds = recentRec
    ? recentRec.activities.map((a) => a._id.toString())
    : [];

  // Use ML recommender to score activities
  const scoredActivities = await getMLRecommendations(
    userId,
    riskLevel,
    userRatingMap
  );

  // Separate fresh and recently recommended
  const fresh = scoredActivities.filter(
    (s) => !recentIds.includes(s.activity._id.toString())
  );
  const repeated = scoredActivities.filter((s) =>
    recentIds.includes(s.activity._id.toString())
  );

  // Fresh activities first then repeated
  const finalList = [...fresh, ...repeated].slice(0, 5);
  const recommended = finalList.map((s) => s.activity);

  // Save recommendation
  await Recommendation.create({
    userId,
    riskLevel,
    activities: recommended.map((a) => a._id),
  });

  return {
    recommendations: recommended,
    mlScores: finalList.map((s) => ({
      title: s.activity.title,
      finalScore: s.finalScore,
      populationSuccessRate: s.populationSuccessRate,
      totalRatings: s.totalRatings,
    })),
  };
};

// Rate an activity
const rateActivity = async (userId, activityId, rating, comment) => {
  const existing = await Rating.findOne({ userId, activityId });
  if (existing) {
    existing.rating = rating;
    existing.comment = comment;
    await existing.save();
    return existing;
  }
  const newRating = await Rating.create({ userId, activityId, rating, comment });
  return newRating;
};

// Get ratings for an activity
const getActivityRatings = async (activityId) => {
  const ratings = await Rating.find({ activityId });
  const total = ratings.length;
  const average =
    total > 0
      ? (ratings.reduce((sum, r) => sum + r.rating, 0) / total).toFixed(1)
      : 0;
  return { average, total, ratings };
};

// Get emergency support activities
const getEmergencySupport = async () => {
  const activities = await Activity.find({
    riskLevel: "high",
    isEmergency: true,
  });
  return activities;
};

// Save journal entry
const saveJournalEntry = async (userId, entry, mood, prompt) => {
  const journal = await Journal.create({ userId, entry, mood, prompt });
  return journal;
};

// Get user journal entries
const getJournalEntries = async (userId) => {
  const entries = await Journal.find({ userId }).sort({ createdAt: -1 });
  return entries;
};

// Get breathing patterns
const getBreathingPatterns = async (riskLevel) => {
  const patterns = {
    low: {
      name: "Deep Breathing",
      description: "Best for everyday stress relief",
      steps: [
        { action: "Inhale", duration: 4, instruction: "Breathe in deeply through your nose" },
        { action: "Hold", duration: 2, instruction: "Hold briefly" },
        { action: "Exhale", duration: 6, instruction: "Breathe out slowly through your mouth" }
      ],
      cycles: 6
    },
    moderate: {
      name: "4-7-8 Breathing",
      description: "Best for anxiety and sleep",
      steps: [
        { action: "Inhale", duration: 4, instruction: "Breathe in quietly through your nose" },
        { action: "Hold", duration: 7, instruction: "Hold your breath" },
        { action: "Exhale", duration: 8, instruction: "Exhale completely through your mouth" }
      ],
      cycles: 4
    },
    high: {
      name: "Box Breathing",
      description: "Best for panic and high stress",
      steps: [
        { action: "Inhale", duration: 4, instruction: "Breathe in slowly through your nose" },
        { action: "Hold", duration: 4, instruction: "Hold your breath gently" },
        { action: "Exhale", duration: 4, instruction: "Breathe out slowly through your mouth" },
        { action: "Hold", duration: 4, instruction: "Hold before next breath" }
      ],
      cycles: 5
    }
  };
  return riskLevel ? patterns[riskLevel] : patterns;
};

// Get journal prompts based on mood
const getJournalPrompts = async (mood) => {
  const prompts = {
    stressed: [
      "What is making you feel overwhelmed right now?",
      "Write down 3 things you can control in this situation.",
      "What would you tell a friend who feels the same way?"
    ],
    anxious: [
      "What is one thing you are worried about today?",
      "Write about a time you overcame a difficult situation.",
      "What is one small step you can take to feel better?"
    ],
    sad: [
      "Write about a happy memory that makes you smile.",
      "What are 3 things you are grateful for today?",
      "Who is someone that makes you feel better? Write about them."
    ],
    angry: [
      "What triggered your anger today?",
      "How can you express your feelings in a healthy way?",
      "Write about what you need right now to feel calm."
    ],
    neutral: [
      "How are you feeling today? Describe it in detail.",
      "What is one thing you want to achieve this week?",
      "Write about something that made you smile recently."
    ],
    happy: [
      "What made you feel happy today?",
      "How can you share this positive energy with others?",
      "Write about your goals and how you plan to achieve them."
    ],
    calm: [
      "What helped you feel calm today?",
      "Write about something you are looking forward to.",
      "How can you maintain this feeling of peace?"
    ]
  };
  return prompts[mood] || prompts.neutral;
};

// Get ML insights
const getMLInsights = async (riskLevel) => {
  const insights = await getActivityInsights(riskLevel);
  return insights;
};

module.exports = {
  getRecommendations,
  rateActivity,
  getActivityRatings,
  getEmergencySupport,
  saveJournalEntry,
  getJournalEntries,
  getBreathingPatterns,
  getJournalPrompts,
  getMLInsights,
};