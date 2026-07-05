import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import connectDB from "./config/db.js";

import authRoutes from "./routes/authRoutes.js";
import assessmentRoutes from "./routes/assessmentRoutes.js";
import symptomRoutes from "./routes/symptomRoutes.js";
import checkInRoutes from "./routes/checkInRoutes.js";
import progressRoutes from "./routes/progressRoutes.js";
import chatRoutes from "./routes/chatRoutes.js";
import moodRoutes from "./routes/moodRoutes.js";
import therapyRoutes from "./routes/therapyRoutes.js";
import userRoutes from "./routes/userRoutes.js";

dotenv.config();
connectDB();

const app = express();

app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  next();
});

app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/assessment", assessmentRoutes);
app.use("/api/symptom", symptomRoutes);
app.use("/api/checkin", checkInRoutes);
app.use("/api/progress", progressRoutes);
app.use("/api/chat", chatRoutes);
app.use("/api/mood", moodRoutes);
app.use("/api/therapy", therapyRoutes);
app.use("/api/user", userRoutes);

app.get("/", (req, res) => {
  res.send("🌱 MindBloom API is running!");
});

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: err.message });
});

// ✅ This was missing!
const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Server running on port ${PORT}`);
});