import express from 'express';
import {
  awardPoints,
  getUserProgress,
  createChallenge,
  getChallenges,
  completeChallenge,
  createReward,     
  getRewards,       
  claimReward,
  getLevelInfo   
} from '../controllers/gamificationController.js';

const router = express.Router();


// 🔹 Points
router.post('/points', awardPoints);
router.get('/progress/:userId', getUserProgress);


// 🔹 Challenges
router.post('/challenge', createChallenge);
router.get('/challenges', getChallenges);
router.post('/challenge/complete', completeChallenge);


// 🔥 Rewards
router.post('/reward', createReward);
router.get('/rewards', getRewards);
router.post('/reward/claim', claimReward);


// 🚀 XP LEVEL SYSTEM (NEW)
router.get('/level/:userId', getLevelInfo); 


export default router;