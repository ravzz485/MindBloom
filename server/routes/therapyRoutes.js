import express from "express";
import { getTherapies } from "../controllers/therapyController.js";

const router = express.Router();

router.get("/", getTherapies);

export default router;