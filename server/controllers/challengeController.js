import Challenge from '../models/Challenge.js';
import UserProgress from '../models/UserProgress.js';

// ─── CREATE a new challenge ───────────────────────────────────────
export const createChallenge = async (req, res) => {
  try {
    const { title, description, type, targetCount, rewardPoints, rewardBadge, expiresAt } = req.body;

    if (!title || !description) {
      return res.status(400).json({ error: 'title and description are required' });
    }

    const challenge = new Challenge({
      title,
      description,
      type:         type         || 'daily',
      targetCount:  targetCount  || 1,
      rewardPoints: rewardPoints || 50,
      rewardBadge:  rewardBadge  || null,
      expiresAt:    expiresAt    || null
    });

    await challenge.save();

    res.status(201).json({
      message: 'Challenge created successfully',
      data: challenge
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// ─── GET all active challenges ────────────────────────────────────
export const getAllChallenges = async (req, res) => {
  try {
    const now = new Date();

    const challenges = await Challenge.find({
      $or: [
        { expiresAt: null },
        { expiresAt: { $gt: now } }
      ]
    });

    res.status(200).json(challenges);

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// ─── JOIN a challenge ─────────────────────────────────────────────
export const joinChallenge = async (req, res) => {
  try {
    const { challengeId } = req.params;
    const { userId } = req.body;

    if (!userId) {
      return res.status(400).json({ error: 'userId is required' });
    }

    const challenge = await Challenge.findById(challengeId);

    if (!challenge) {
      return res.status(404).json({ error: 'Challenge not found' });
    }

    const alreadyJoined = challenge.participants.find(p => p.userId === userId);

    if (alreadyJoined) {
      return res.status(400).json({ error: 'User already joined this challenge' });
    }

    challenge.participants.push({ userId, progress: 0, completed: false });
    await challenge.save();

    res.status(200).json({
      message: 'Joined challenge successfully',
      data: challenge
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// ─── UPDATE progress on a challenge ──────────────────────────────
export const updateChallengeProgress = async (req, res) => {
  try {
    const { challengeId } = req.params;
    const { userId } = req.body;

    if (!userId) {
      return res.status(400).json({ error: 'userId is required' });
    }

    const challenge = await Challenge.findById(challengeId);

    if (!challenge) {
      return res.status(404).json({ error: 'Challenge not found' });
    }

    const participant = challenge.participants.find(p => p.userId === userId);

    if (!participant) {
      return res.status(400).json({ error: 'User has not joined this challenge. Join first.' });
    }

    if (participant.completed) {
      return res.status(400).json({ error: 'Challenge already completed by this user' });
    }

    participant.progress += 1;
    let rewardGranted = false;

    if (participant.progress >= challenge.targetCount) {
      participant.completed   = true;
      participant.completedAt = new Date();

      let userProgress = await UserProgress.findOne({ userId });

      if (!userProgress) {
        userProgress = new UserProgress({ userId });
      }

      userProgress.points += challenge.rewardPoints;

      if (challenge.rewardBadge && !userProgress.badges.includes(challenge.rewardBadge)) {
        userProgress.badges.push(challenge.rewardBadge);
      }

      await userProgress.save();
      rewardGranted = true;
    }

    await challenge.save();

    res.status(200).json({
      message:      rewardGranted
        ? `Challenge completed! You earned ${challenge.rewardPoints} points.`
        : 'Progress updated',
      progress:     participant.progress,
      targetCount:  challenge.targetCount,
      completed:    participant.completed,
      rewardGranted
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// ─── GET user's challenges ────────────────────────────────────────
export const getUserChallenges = async (req, res) => {
  try {
    const { userId } = req.params;

    const challenges = await Challenge.find({
      'participants.userId': userId
    });

    const result = challenges.map(c => {
      const participant = c.participants.find(p => p.userId === userId);
      return {
        challengeId:  c._id,
        title:        c.title,
        description:  c.description,
        type:         c.type,
        targetCount:  c.targetCount,
        rewardPoints: c.rewardPoints,
        rewardBadge:  c.rewardBadge,
        progress:     participant.progress,
        completed:    participant.completed,
        completedAt:  participant.completedAt
      };
    });

    res.status(200).json(result);

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};