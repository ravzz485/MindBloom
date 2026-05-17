import express from "express";
import dotenv from "dotenv";
import connectDB from "./config/db.js";
import impactRoutes from "./routes/impactRoutes.js";

dotenv.config();

const app = express();

app.use(express.json());

// connect database
connectDB();

// routes
app.use("/api/impact", impactRoutes);

app.get("/", (req, res) => {
  res.send("MindBloom Backend Running");
});

app.listen(5000, () => {
  console.log("Server running on port 5000");
});

