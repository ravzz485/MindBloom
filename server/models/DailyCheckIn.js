import mongoose from "mongoose";

const dailyCheckInSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true
  },
  mood: {
    type: String,
    enum: ["happy", "sad", "anxious", "angry", "calm", "stressed"],
    required: true
  },
  sleepHours: {
    type: Number,
    required: true
  },
  screenTime: {
    type: Number,
    required: true
  },
  stressLevel: {
    type: Number,
    min: 1,
    max: 10,
    required: true
  },
  exercised: {
    type: Boolean,
    default: false
  },
  meditated: {
    type: Boolean,
    default: false
  },
  notes: {
    type: String,
    default: ""
  },
  date: {
    type: Date,
    default: Date.now
  }
});

export default mongoose.model("DailyCheckIn", dailyCheckInSchema);