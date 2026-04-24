import mongoose from "mongoose";

const symptomSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true
  },
  text: {
    type: String,
    required: true
  },
  keywords: [String],
  detectedIssue: {
    type: String,
    default: "general"
  },
  riskLevel: {
    type: String,
    enum: ["low", "mild", "moderate", "high"],
    default: "low"
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

export default mongoose.model("Symptom", symptomSchema);