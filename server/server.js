import dotenv from 'dotenv';
import mongoose from 'mongoose';
import express from 'express';
import gamificationRoutes from './routes/gamificationRoutes.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI;

// Middleware
app.use(express.json());

// Test route
app.get('/', (req, res) => {
  res.send('API is running...');
});

// Routes
app.use('/api/gamification', gamificationRoutes);

// Check Mongo URI
if (!MONGO_URI) {
  console.error('❌ MONGO_URI missing in .env');
  process.exit(1);
}

// Connect DB
mongoose.connect(MONGO_URI)
  .then(() => {
    console.log('✅ MongoDB Connected');

    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
    });
  })
  .catch(err => {
    console.error('❌ DB Error:', err.message);
    process.exit(1);
  });