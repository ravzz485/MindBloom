import mongoose from 'mongoose';

const challengeSchema = new mongoose.Schema({

  title: {
    type: String,
    required: true
  },

  description: {
    type: String
  },

  points: {
    type: Number,
    default: 10
  },

  type: {
    type: String, // daily / weekly
    enum: ['daily', 'weekly'],
    default: 'daily'
  },

  isActive: {
    type: Boolean,
    default: true
  }

}, { timestamps: true });

const Challenge = mongoose.model('Challenge', challengeSchema);

export default Challenge;