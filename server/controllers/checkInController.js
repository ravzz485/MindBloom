import DailyCheckIn from "../models/DailyCheckIn.js";

// ─── Submit Daily CheckIn ────────────────────────
export const submitCheckIn = async (req, res) => {
  try {
    const {
      mood,
      sleepHours,
      screenTime,
      stressLevel,
      exercised,
      meditated,
      notes
    } = req.body;

    const userId = req.user._id;

    // Check if already checked in today
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const existingCheckIn = await DailyCheckIn.findOne({
      userId,
      date: { $gte: today }
    });

    if (existingCheckIn) {
      return res.status(400).json({
        message: "You have already checked in today!"
      });
    }

    const checkIn = await DailyCheckIn.create({
      userId,
      mood,
      sleepHours,
      screenTime,
      stressLevel,
      exercised,
      meditated,
      notes
    });

    // Generate feedback
    let feedback = [];
    if (sleepHours < 6) feedback.push(" You slept less than 6 hours!");
    if (stressLevel >= 7) feedback.push(" Your stress level is high!");
    if (screenTime > 6) feedback.push(" High screen time detected!");
    if (exercised) feedback.push(" Great job exercising today!");
    if (meditated) feedback.push(" Great job meditating today!");

    res.status(201).json({
      success: true,
      checkInId: checkIn._id,
      mood,
      sleepHours,
      screenTime,
      stressLevel,
      exercised,
      meditated,
      feedback
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get CheckIn History ─────────────────────────
export const getCheckInHistory = async (req, res) => {
  try {
    const userId = req.user._id;

    const checkIns = await DailyCheckIn.find({ userId })
      .sort({ date: -1 })
      .limit(30);

    res.json({
      success: true,
      count: checkIns.length,
      checkIns
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Today's CheckIn ─────────────────────────
export const getTodayCheckIn = async (req, res) => {
  try {
    const userId = req.user._id;

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const checkIn = await DailyCheckIn.findOne({
      userId,
      date: { $gte: today }
    });

    if (!checkIn) {
      return res.status(404).json({
        message: "No check in found for today"
      });
    }

    res.json({
      success: true,
      checkIn
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Weekly Summary ──────────────────────────
export const getWeeklySummary = async (req, res) => {
  try {
    const userId = req.user._id;

    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const checkIns = await DailyCheckIn.find({
      userId,
      date: { $gte: sevenDaysAgo }
    }).sort({ date: -1 });

    if (checkIns.length === 0) {
      return res.status(404).json({
        message: "No check ins found for this week"
      });
    }

    const avgSleep = checkIns.reduce(
      (a, b) => a + b.sleepHours, 0) / checkIns.length;

    const avgStress = checkIns.reduce(
      (a, b) => a + b.stressLevel, 0) / checkIns.length;

    const avgScreenTime = checkIns.reduce(
      (a, b) => a + b.screenTime, 0) / checkIns.length;

    const moodCount = {};
    checkIns.forEach(c => {
      moodCount[c.mood] = (moodCount[c.mood] || 0) + 1;
    });
    const dominantMood = Object.keys(moodCount).reduce(
      (a, b) => moodCount[a] > moodCount[b] ? a : b
    );

    const exerciseDays = checkIns.filter(c => c.exercised).length;
    const meditationDays = checkIns.filter(c => c.meditated).length;

    res.json({
      success: true,
      totalDays: checkIns.length,
      dominantMood,
      averages: {
        sleep: avgSleep.toFixed(1),
        stress: avgStress.toFixed(1),
        screenTime: avgScreenTime.toFixed(1)
      },
      exerciseDays,
      meditationDays,
      checkIns
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Mood Trend ──────────────────────────────
export const getMoodTrend = async (req, res) => {
  try {
    const userId = req.user._id;

    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const checkIns = await DailyCheckIn.find({
      userId,
      date: { $gte: sevenDaysAgo }
    }).sort({ date: 1 });

    const stressLevels = checkIns.map(c => c.stressLevel);
    const recentStress = stressLevels.slice(-3);
    const avgRecent = recentStress.reduce(
      (a, b) => a + b, 0) / recentStress.length;
    const avgAll = stressLevels.reduce(
      (a, b) => a + b, 0) / stressLevels.length;

    let trend = "stable";
    let trendMessage = "Your stress is stable ";

    if (avgRecent > avgAll + 1) {
      trend = "worsening";
      trendMessage = " Your stress has been increasing!";
    } else if (avgRecent < avgAll - 1) {
      trend = "improving";
      trendMessage = " Your stress is improving!";
    }

    res.json({
      success: true,
      trend,
      trendMessage,
      stressLevels,
      averageStress: avgAll.toFixed(1),
      checkIns
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};