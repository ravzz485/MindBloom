import mongoose from 'mongoose';

const sleepSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    hours: {
      type: Number,
      required: true,
    },
    quality: {
      type: Number,
      default: 5,
    },
  },
  { timestamps: true }
);

export default mongoose.model('Sleep', sleepSchema);