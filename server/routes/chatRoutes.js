import express from "express";
import {
  sendMessage,
  getChatHistory,
  clearChatHistory
} from "../controllers/chatController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

router.post("/message", protect, sendMessage);
router.get("/history", protect, getChatHistory);
router.delete("/clear", protect, clearChatHistory);

export default router;