import Mood from '../models/Mood.js';
import Sleep from '../models/Sleep.js';
import ScreenTime from '../models/ScreenTime.js';
import AnalysisSummary from '../models/AnalysisSummary.js';

function average(arr, field) {
  if (!arr.length) return 0;
  const total = arr.reduce((sum, item) => sum + (item[field] || 0), 0);
  return Number((total / arr.length).toFixed(2));
}

export const getDashboard = async (req, res) => {
  try {
    const userId = req.user._id;

    const moods = await Mood.find({ user: userId }).sort({ createdAt: -1 }).limit(7);
    const sleeps = await Sleep.find({ user: userId }).sort({ createdAt: -1 }).limit(7);
    const screenTimes = await ScreenTime.find({ user: userId }).sort({ createdAt: -1 }).limit(7);
    res.json({
      averageMood: average(moods, 'moodScore'),
      averageStress: average(moods, 'stressLevel'),
      averageSleep: average(sleeps, 'hours'),
      averageScreenTime: average(screenTimes, 'hours'),
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getHistory = async (req, res) => {
  try {
    const userId = req.user._id;

    const moods = await Mood.find({ user: userId }).sort({ createdAt: -1 });
    const sleeps = await Sleep.find({ user: userId }).sort({ createdAt: -1 });
    const screenTimes = await ScreenTime.find({ user: userId }).sort({ createdAt: -1 });

    res.json({ moods, sleeps, screenTimes });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
  };

export const getCharts = async (req, res) => {
  try {
    const userId = req.user._id;

    const moods = await Mood.find({ user: userId })
      .sort({ createdAt: 1 })
      .limit(30);

    const chartData = moods.map((item) => ({
      date: item.createdAt.toISOString().split('T')[0],
      mood: item.moodScore,
      stress: item.stressLevel,
    }));

    res.json(chartData);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
export const getWeeklySummary = async (req, res) => {
  try {
    const userId = req.user._id;

    const moods = await Mood.find({ user: userId }).sort({ createdAt: -1 }).limit(7);
    const sleeps = await Sleep.find({ user: userId }).sort({ createdAt: -1 }).limit(7);
    const screenTimes = await ScreenTime.find({ user: userId }).sort({ createdAt: -1 }).limit(7);

    const averages = {
      mood: average(moods, 'moodScore'),
      stress: average(moods, 'stressLevel'),
      sleep: average(sleeps, 'hours'),
      screenTime: average(screenTimes, 'hours'),
    };

    let summaryText = `Your average mood was ${averages.mood}/10. `;

    if (averages.sleep < 6) {
      summaryText += 'Low sleep may be affecting your wellbeing. ';
    }
    if (averages.stress > 7) {
      summaryText += 'Stress levels were high this week. ';
    }

    if (averages.screenTime > 8) {
      summaryText += 'High screen time may impact sleep and focus. ';
    }

    const summary = await AnalysisSummary.create({
      user: userId,
      period: 'weekly',
      summaryText,
      averages,
    });

    res.json(summary);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
