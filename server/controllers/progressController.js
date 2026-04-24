import Progress from "../models/Progress.js";
import DailyCheckIn from "../models/DailyCheckIn.js";
import Assessment from "../models/Assessment.js";

// ─── Generate Weekly Progress ────────────────────
// @route POST /api/progress/generate
export const generateWeeklyProgress = async (req, res) => {
  try {
    const userId = req.user._id;

    // Get last 7 days checkins
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const checkIns = await DailyCheckIn.find({
      userId,
      date: { $gte: sevenDaysAgo }
    });

    if (checkIns.length === 0) {
      return res.status(404).json({
        message: "No check ins found! Please do daily check ins first!"
      });
    }

    // Calculate averages
    const avgSleep = checkIns.reduce(
      (a, b) => a + b.sleepHours, 0) / checkIns.length;

    const avgStress = checkIns.reduce(
      (a, b) => a + b.stressLevel, 0) / checkIns.length;

    const avgScreenTime = checkIns.reduce(
      (a, b) => a + b.screenTime, 0) / checkIns.length;

    // Most common mood
    const moodCount = {};
    checkIns.forEach(c => {
      moodCount[c.mood] = (moodCount[c.mood] || 0) + 1;
    });
    const averageMood = Object.keys(moodCount).reduce(
      (a, b) => moodCount[a] > moodCount[b] ? a : b
    );

    // Get latest assessment score
    const latestAssessment = await Assessment.findOne({ userId })
      .sort({ createdAt: -1 });

    const assessmentScore = latestAssessment ? latestAssessment.score : 0;

    // Calculate trend
    const stressLevels = checkIns.map(c => c.stressLevel);
    const recentStress = stressLevels.slice(-3);
    const avgRecentStress = recentStress.reduce(
      (a, b) => a + b, 0) / recentStress.length;

    let trend = "stable";
    if (avgRecentStress > avgStress + 1) trend = "worsening";
    else if (avgRecentStress < avgStress - 1) trend = "improving";

    // Get current week number
    const weekNumber = Math.ceil(
      (new Date() - new Date(new Date().getFullYear(), 0, 1)) /
      (7 * 24 * 60 * 60 * 1000)
    );

    // Save progress
    const progress = await Progress.create({
      userId,
      week: weekNumber,
      averageMood,
      averageStress: avgStress,
      averageSleep: avgSleep,
      averageScreenTime: avgScreenTime,
      assessmentScore,
      trend
    });

    res.status(201).json({
      success: true,
      progressId: progress._id,
      week: weekNumber,
      averageMood,
      averages: {
        sleep: avgSleep.toFixed(1),
        stress: avgStress.toFixed(1),
        screenTime: avgScreenTime.toFixed(1)
      },
      assessmentScore,
      trend,
      totalCheckIns: checkIns.length
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Progress History ────────────────────────
// @route GET /api/progress/history
export const getProgressHistory = async (req, res) => {
  try {
    const userId = req.user._id;

    const progressList = await Progress.find({ userId })
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: progressList.length,
      progressList
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Latest Progress ─────────────────────────
// @route GET /api/progress/latest
export const getLatestProgress = async (req, res) => {
  try {
    const userId = req.user._id;

    const progress = await Progress.findOne({ userId })
      .sort({ createdAt: -1 });

    if (!progress) {
      return res.status(404).json({
        message: "No progress found! Generate weekly progress first!"
      });
    }

    res.json({
      success: true,
      progress
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Full Report ─────────────────────────────
// @route GET /api/progress/report
export const getFullReport = async (req, res) => {
  try {
    const userId = req.user._id;

    // Get all checkins
    const checkIns = await DailyCheckIn.find({ userId })
      .sort({ date: -1 })
      .limit(30);

    // Get all assessments
    const assessments = await Assessment.find({ userId })
      .sort({ createdAt: -1 });

    // Get all progress
    const progressList = await Progress.find({ userId })
      .sort({ createdAt: -1 });

    // Overall stats
    const totalCheckIns = checkIns.length;
    const totalAssessments = assessments.length;

    // Average stress all time
    const overallAvgStress = checkIns.length > 0
      ? (checkIns.reduce((a, b) => a + b.stressLevel, 0) /
        checkIns.length).toFixed(1)
      : 0;

    // Average sleep all time
    const overallAvgSleep = checkIns.length > 0
      ? (checkIns.reduce((a, b) => a + b.sleepHours, 0) /
        checkIns.length).toFixed(1)
      : 0;

    // Latest risk level
    const latestAssessment = assessments[0];
    const currentRiskLevel = latestAssessment
      ? latestAssessment.riskLevel
      : "unknown";

    res.json({
      success: true,
      summary: {
        totalCheckIns,
        totalAssessments,
        overallAvgStress,
        overallAvgSleep,
        currentRiskLevel
      },
      checkIns,
      assessments,
      progressList
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Stress Trend Data ───────────────────────
// @route GET /api/progress/stress-trend
export const getStressTrend = async (req, res) => {
  try {
    const userId = req.user._id;

    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const checkIns = await DailyCheckIn.find({
      userId,
      date: { $gte: thirtyDaysAgo }
    }).sort({ date: 1 });

    const stressTrend = checkIns.map(c => ({
      date: c.date,
      stress: c.stressLevel,
      mood: c.mood,
      sleep: c.sleepHours
    }));

    res.json({
      success: true,
      stressTrend
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};