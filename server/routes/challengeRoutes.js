import express from 'express';
import {
  createChallenge,
  getAllChallenges,
  joinChallenge,
  updateChallengeProgress,
  getUserChallenges
} from '../controllers/challengeController.js';

const router = express.Router();

router.post('/',                        createChallenge);
router.get('/',                         getAllChallenges);
router.post('/:challengeId/join',       joinChallenge);
router.patch('/:challengeId/progress',  updateChallengeProgress);
router.get('/user/:userId',             getUserChallenges);

export default router;