import mongoose from 'mongoose';

const analysisSummarySchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    period: {
      type: String,
      enum: ['weekly', 'monthly'],
      required: true,
    },
    summaryText: {
      type: String,
      required: true,
    },
    averages: {
      mood: Number,
      stress: Number,
      sleep: Number,
      screenTime: Number,
      },
  },
  { timestamps: true }
);

export default mongoose.model('AnalysisSummary', analysisSummarySchema);