import mongoose from "mongoose";

const therapySchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  type: {
    type: String,
    enum: ["breathing", "meditation", "exercise", "journaling"],
    required: true
  },
  duration: {
    type: Number,
    default: 5
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

export default mongoose.model("Therapy", therapySchema);