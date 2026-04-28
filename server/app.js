import express from 'express';
import gamificationRoutes from './routes/gamificationRoutes.js';
import challengeRoutes from './routes/challengeRoutes.js';        

const app = express();

app.use(express.json());

app.use('/api/gamification', gamificationRoutes);
app.use('/api/challenges',   challengeRoutes);                    

export default app;