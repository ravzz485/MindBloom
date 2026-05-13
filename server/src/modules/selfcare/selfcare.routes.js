const express = require("express");
const router = express.Router();
const controller = require("./selfcare.controller");

// Activity routes
router.get("/activities", controller.getAllActivities);

// Recommendation routes
router.post("/recommendations", controller.getRecommendations);

// Rating routes
router.post("/rate", controller.rateActivity);
router.get("/ratings/:activityId", controller.getActivityRatings);

// Emergency support route
router.get("/emergency", controller.getEmergencySupport);

// Journal routes
router.post("/journal", controller.saveJournalEntry);
router.get("/journal/:userId", controller.getJournalEntries);

// Breathing exercise routes
router.get("/breathing", controller.getBreathingPatterns);

// Journal prompts route
router.get("/prompts", controller.getJournalPrompts);

// ML insights route
router.get("/ml-insights", controller.getMLInsights);
module.exports = router;