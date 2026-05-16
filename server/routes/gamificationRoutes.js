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

  getLevelInfo,

  //  Tree System
  getTreeStatus

} from '../controllers/gamificationController.js';

const router = express.Router();


//  POINTS SYSTEM
router.post('/points', awardPoints);
router.get('/progress/:userId', getUserProgress);


//  CHALLENGE SYSTEM
router.post('/challenge', createChallenge);
router.get('/challenges', getChallenges);
router.post('/challenge/complete', completeChallenge);


//  REWARD SYSTEM
router.post('/reward', createReward);
router.get('/rewards', getRewards);
router.post('/reward/claim', claimReward);


//  XP LEVEL SYSTEM
router.get('/level/:userId', getLevelInfo);


//  TREE GROWTH SYSTEM
router.get('/tree/:userId', getTreeStatus);


export default router;