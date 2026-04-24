import express from 'express';
import {
  awardPoints,
  getUserProgress
} from '../controllers/gamificationController.js';

const router = express.Router();

router.post('/points', awardPoints);

router.get('/progress/:userId', getUserProgress);

export default router;