const mongoose = require("mongoose");

const activitySchema = new mongoose.Schema(
  {
    title: { 
      type: String, 
      required: true 
    },
    type: {
      type: String,
      enum: ["breathing", "meditation", "journaling", "sleep_tips", "audio"],
      required: true,
    },
    riskLevel: {
      type: String,
      enum: ["low", "moderate", "high"],
      required: true,
    },
    content: { 
      type: String 
    },
    duration: { 
      type: Number 
    },
    isEmergency: { 
      type: Boolean, 
      default: false 
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Activity", activitySchema);