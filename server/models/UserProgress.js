import mongoose from 'mongoose';

const userProgressSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
    unique: true
  },

  points: {
    type: Number,
    default: 0
  },

  badges: [{
    type: String
  }],

  streak: {
    type: Number,
    default: 0
  },

  lastActivityDate: {
    type: Date,
    default: null
  }

}, { timestamps: true });


const UserProgress = mongoose.model(
  'UserProgress',
  userProgressSchema
);

export default UserProgress;