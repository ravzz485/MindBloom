import express from 'express';
import {
  awardPoints,
  getUserProgress,
  createChallenge,
  getChallenges,
  completeChallenge
} from '../controllers/gamificationController.js';

const router = express.Router();

router.post('/points', awardPoints);
router.get('/progress/:userId', getUserProgress);

router.post('/challenge', createChallenge);
router.get('/challenges', getChallenges);
router.post('/challenge/complete', completeChallenge);

export default router;