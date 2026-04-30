import express from 'express';
import {
  awardPoints,
  getUserProgress,
  createChallenge,
  getChallenges,
  completeChallenge,
  createReward,     // ✅ added
  getRewards,       // ✅ added
  claimReward       // ✅ added
} from '../controllers/gamificationController.js';

const router = express.Router();


// 🔹 Points
router.post('/points', awardPoints);
router.get('/progress/:userId', getUserProgress);


// 🔹 Challenges
router.post('/challenge', createChallenge);
router.get('/challenges', getChallenges);
router.post('/challenge/complete', completeChallenge);


// 🔥 Rewards (NEW)
router.post('/reward', createReward);
router.get('/rewards', getRewards);
router.post('/reward/claim', claimReward);


export default router;