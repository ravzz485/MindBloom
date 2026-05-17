import mongoose from 'mongoose';

const screenTimeSchema = new mongoose.Schema(
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
  },
  { timestamps: true }
);

export default mongoose.model('ScreenTime', screenTimeSchema);