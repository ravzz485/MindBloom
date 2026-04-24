import express from 'express';
import gamificationRoutes from './routes/gamificationRoutes.js';

const app = express();

app.use(express.json());

app.use('/api/gamification', gamificationRoutes);

export default app;