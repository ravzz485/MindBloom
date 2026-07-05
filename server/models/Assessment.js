import mongoose from "mongoose";

const assessmentSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true
  },
  type: {
    type: String,
    enum: ["PHQ9", "GAD7", "quick"],
    required: true
  },
  answers: [
    {
      question: String,
      answer: Number 
    }
  ],
  score: {
    type: Number,
    required: true
  },
  riskLevel: {
    type: String,
    enum: ["minimal", "mild", "moderate", "severe"],
    required: true
  },
  possibleIssue: {
    type: String,
    default: ""
  },
  disclaimer: {
    type: String,
    default: "This is not a medical diagnosis. Please consult a professional."
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

export default mongoose.model("Assessment", assessmentSchema);