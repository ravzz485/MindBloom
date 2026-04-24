import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import connectDB from "./config/db.js";

// Routes
import authRoutes from "./routes/authRoutes.js";
import assessmentRoutes from "./routes/assessmentRoutes.js";
import symptomRoutes from "./routes/symptomRoutes.js";
import checkInRoutes from "./routes/checkInRoutes.js";
import progressRoutes from "./routes/progressRoutes.js";
import chatRoutes from "./routes/chatRoutes.js";
import gamificationRoutes from "./routes/gamificationRoutes.js";

dotenv.config();
connectDB();

const app = express();

app.use(cors());
app.use(express.json());

// Use Routes
app.use("/api/auth", authRoutes);
app.use("/api/assessment", assessmentRoutes);
app.use("/api/symptom", symptomRoutes);
app.use("/api/checkin", checkInRoutes);
app.use("/api/progress", progressRoutes);
app.use("/api/chat", chatRoutes);
app.use("/api/gamification", gamificationRoutes);

// Test route
app.get("/", (req, res) => {
  res.send("🌱 MindBloom API is running!");
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});