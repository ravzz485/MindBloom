import UserProgress from '../models/UserProgress.js';
import Challenge from '../models/Challenge.js';


// 🔹 Award Points (MVP)
export const awardPoints = async (req, res) => {
  try {
    const { userId, activityType } = req.body;

    let user = await UserProgress.findOne({ userId });

    if (!user) {
      user = new UserProgress({ userId, streak: 1 });
    }

    const pointsMap = {
      mood_checkin: 10,
      daily_task: 20,
      meditation: 15
    };

    const earnedPoints = pointsMap[activityType] || 5;

    user.points += earnedPoints;

    await user.save();

    res.status(200).json({
      message: 'Points awarded',
      data: user
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// 🔹 Get User Progress
export const getUserProgress = async (req, res) => {
  try {
    const { userId } = req.params;

    const user = await UserProgress.findOne({ userId });

    if (!user) {
      return res.status(404).json({
        message: 'User not found'
      });
    }

    res.status(200).json({
      data: user
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// 🔹 Create Challenge
export const createChallenge = async (req, res) => {
  try {
    const { title, description, points, type } = req.body;

    if (!title) {
      return res.status(400).json({ message: 'Title is required' });
    }

    const challenge = new Challenge({
      title,
      description,
      points,
      type
    });

    await challenge.save();

    res.status(201).json({
      message: 'Challenge created',
      data: challenge
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// 🔹 Get Challenges
export const getChallenges = async (req, res) => {
  try {
    const challenges = await Challenge.find({ isActive: true });

    res.status(200).json({
      count: challenges.length,
      data: challenges
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// 🔹 Complete Challenge
export const completeChallenge = async (req, res) => {
  try {
    const { userId, challengeId } = req.body;

    if (!userId || !challengeId) {
      return res.status(400).json({
        message: 'userId and challengeId are required'
      });
    }

    const user = await UserProgress.findOne({ userId });

    if (!user) {
      return res.status(404).json({
        message: 'User not found'
      });
    }

    const challenge = await Challenge.findById(challengeId);

    if (!challenge) {
      return res.status(404).json({
        message: 'Challenge not found'
      });
    }

    const alreadyCompleted = user.completedChallenges?.some(
      c => c.challengeId.toString() === challengeId
    );

    if (alreadyCompleted) {
      return res.status(400).json({
        message: 'Challenge already completed'
      });
    }

    user.points += challenge.points;

    user.completedChallenges.push({
      challengeId
    });

    await user.save();

    res.status(200).json({
      message: 'Challenge completed successfully',
      pointsEarned: challenge.points,
      data: user
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};