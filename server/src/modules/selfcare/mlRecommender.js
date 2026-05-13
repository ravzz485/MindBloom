const Rating = require("../../../models/Rating");
const Activity = require("../../../models/Activity");

// Calculate success rate for each activity based on all user ratings
const calculateSuccessRates = async (riskLevel) => {
  // Get all activities for this risk level
  const activities = await Activity.find({ riskLevel });

  // Get all ratings for these activities
  const activityIds = activities.map((a) => a._id);
  const allRatings = await Rating.find({ activityId: { $in: activityIds } });

  // Calculate success rate for each activity
  const successRates = {};

  activities.forEach((activity) => {
    const id = activity._id.toString();

    // Get all ratings for this specific activity
    const activityRatings = allRatings.filter(
      (r) => r.activityId.toString() === id
    );

    if (activityRatings.length === 0) {
      // No ratings yet - give neutral score of 3
      successRates[id] = {
        activityId: id,
        title: activity.title,
        type: activity.type,
        avgRating: 3,
        totalRatings: 0,
        successRate: 60, // default 60% for new activities
        confidence: "low",
      };
    } else {
      // Calculate average rating
      const sum = activityRatings.reduce((total, r) => total + r.rating, 0);
      const avgRating = sum / activityRatings.length;

      // Convert to success rate (1-5 scale to 0-100%)
      const successRate = (avgRating / 5) * 100;

      // Confidence based on number of ratings
      let confidence = "low";
      if (activityRatings.length >= 10) confidence = "high";
      else if (activityRatings.length >= 5) confidence = "medium";

      successRates[id] = {
        activityId: id,
        title: activity.title,
        type: activity.type,
        avgRating: parseFloat(avgRating.toFixed(2)),
        totalRatings: activityRatings.length,
        successRate: parseFloat(successRate.toFixed(2)),
        confidence,
      };
    }
  });

  return successRates;
};

// Get ML-powered smart recommendations
const getMLRecommendations = async (userId, riskLevel, userRatingMap) => {
  // Get all activities for this risk level
  const activities = await Activity.find({ riskLevel });

  // Get population-level success rates
  const successRates = await calculateSuccessRates(riskLevel);

  // Score each activity using both personal ratings and population data
  const scored = activities.map((activity) => {
    const id = activity._id.toString();

    // Personal score - what THIS user rated this activity
    const personalRating = userRatingMap[id] || 3;

    // Population score - what ALL users rated this activity
    const populationData = successRates[id];
    const populationScore = populationData
      ? (populationData.successRate / 100) * 5
      : 3;

    // Weight: 60% personal preference + 40% population success
    // If user has rated it before, personal preference matters more
    const hasPersonalRating = userRatingMap[id] !== undefined;
    const personalWeight = hasPersonalRating ? 0.7 : 0.3;
    const populationWeight = hasPersonalRating ? 0.3 : 0.7;

    const finalScore =
      personalRating * personalWeight + populationScore * populationWeight;

    return {
      activity,
      finalScore: parseFloat(finalScore.toFixed(2)),
      personalRating,
      populationSuccessRate: populationData
        ? populationData.successRate
        : 60,
      totalRatings: populationData ? populationData.totalRatings : 0,
    };
  });

  // Sort by final score highest first
  scored.sort((a, b) => b.finalScore - a.finalScore);

  return scored;
};

// Get insights about activity performance
const getActivityInsights = async (riskLevel) => {
  const successRates = await calculateSuccessRates(riskLevel);

  const insights = Object.values(successRates).sort(
    (a, b) => b.successRate - a.successRate
  );

  return {
    riskLevel,
    totalActivities: insights.length,
    topActivity: insights[0] || null,
    insights,
    message: getInsightMessage(insights),
  };
};

const getInsightMessage = (insights) => {
  if (insights.length === 0) return "No data available yet.";

  const top = insights[0];
  if (top.totalRatings === 0)
    return "Not enough data yet. Keep using the app to get personalized insights!";
  if (top.successRate >= 80)
    return `${top.title} is working great for users at this level with ${top.successRate}% success rate!`;
  if (top.successRate >= 60)
    return `${top.title} is showing good results with ${top.successRate}% success rate.`;
  return "Keep trying different activities to find what works best for you!";
};

module.exports = {
  calculateSuccessRates,
  getMLRecommendations,
  getActivityInsights,
};