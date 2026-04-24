import mongoose from "mongoose";

const progressSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true
  },
  week: {
    type: Number,
    required: true
  },
  averageMood: {
    type: String,
    required: true
  },
  averageStress: {
    type: Number,
    required: true
  },
  averageSleep: {
    type: Number,
    required: true
  },
  averageScreenTime: {
    type: Number,
    default: 0
  },
  assessmentScore: {
    type: Number,
    default: 0
  },
  trend: {
    type: String,
    enum: ["improving", "stable", "worsening"],
    default: "stable"
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

export default mongoose.model("Progress", progressSchema);