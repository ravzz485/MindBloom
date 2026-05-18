import express from "express";
import authMiddleware from "../middleware/authMiddleware.js";
import Mood from "../models/Mood.js";

const router = express.Router()


router.get("/monthly-report", authMiddleware, async (req, res) => {
  try {
    const data = await Mood.find();

    // If no records exist
    if (data.length === 0) {
      return res.json({
        success: true,
        message: "No data available for monthly report",
        data: {
          totalRecords: 0,
          avgMood: 0,
          avgStress: 0,
          avgSleep: 0,
          summary: "No records available yet",
          generatedAt: new Date(),
        },
      });
    }

    // Calculate averages
    const avgMood =
      data.reduce((sum, item) => sum + item.moodScore, 0) / data.length;

    const avgStress =
      data.reduce((sum, item) => sum + item.stressLevel, 0) / data.length;

    const avgSleep =
      data.reduce((sum, item) => sum + item.sleepHours, 0) / data.length;

    // Generate summary
    let summary = "Overall mental condition appears stable";

    if (avgSleep < 5) {
      summary = "Sleep patterns indicate potential negative impact on mental health";
    } else if (avgStress > avgMood) {
      summary = "Stress levels are higher than mood and may require attention";
    } else if (avgMood >= 7 && avgStress <= 5) {
      summary = "Mental health indicators show a positive trend";
    }

    // Send report
    res.json({
      success: true,
      message: "Monthly report generated successfully",
      data: {
        totalRecords: data.length,
        avgMood: avgMood.toFixed(2),
        avgStress: avgStress.toFixed(2),
        avgSleep: avgSleep.toFixed(2),
        summary,
        generatedAt: new Date(),
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
})
export default router;