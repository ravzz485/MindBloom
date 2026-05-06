import mongoose from 'mongoose';

const userProgressSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
    unique: true
  },

  points: {
    type: Number,
    default: 0
  },

  // 🔥 XP SYSTEM (ADDED)
  xp: {
    type: Number,
    default: 0
  },

  level: {
    type: Number,
    default: 1
  },

  badges: [{
    type: String,
    default: []
  }],

  streak: {
    type: Number,
    default: 0
  },

  lastActivityDate: {
    type: Date,
    default: null
  },

  // ✅ Challenge Tracking new
  completedChallenges: [{
    challengeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Challenge',
      required: true
    },
    completedAt: {
      type: Date,
      default: Date.now
    }
  }],

  // ✅ Reward Claim Tracking
  claimedRewards: [{
    rewardId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Reward',
      required: true
    },
    claimedAt: {
      type: Date,
      default: Date.now
    }
  }]

}, { timestamps: true });

const UserProgress = mongoose.model('UserProgress', userProgressSchema);

export default UserProgress;