import mongoose from 'mongoose';

const rewardSchema = new mongoose.Schema({

  title: {
    type: String,
    required: true
  },

  description: {
    type: String
  },

  cost: {
    type: Number, // points required
    required: true
  },

  isActive: {
    type: Boolean,
    default: true
  }

}, { timestamps: true });

const Reward = mongoose.model('Reward', rewardSchema);

export default Reward;