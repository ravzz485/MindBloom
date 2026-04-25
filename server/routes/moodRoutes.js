import express from "express";
import { getMoods } from "../controllers/moodController.js";

const router = express.Router();

router.get("/", getMoods);

export default router;