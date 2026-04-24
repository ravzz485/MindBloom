import UserProgress from '../models/UserProgress.js';
import calculatePoints from '../utils/pointCalculator.js';

export const awardPoints = async (req, res) => {
 try {
   const { userId, activityType } = req.body;

   const earnedPoints = calculatePoints(activityType);

   let user = await UserProgress.findOne({ userId });

   if (!user) {
      user = new UserProgress({
        userId,
        streak: 1
      });
   }

   const today = new Date();
   today.setHours(0,0,0,0);

   if (user.lastActivityDate) {

      const lastDate = new Date(user.lastActivityDate);
      lastDate.setHours(0,0,0,0);

      const yesterday = new Date(today);
      yesterday.setDate(yesterday.getDate()-1);

      if (lastDate.getTime() === yesterday.getTime()) {
         user.streak += 1;
      }

      else if (lastDate.getTime() !== today.getTime()) {
         user.streak = 1;
      }
   }

   user.lastActivityDate = today;

   user.points += earnedPoints;

   if (user.points >= 100 &&
      !user.badges.includes('Bronze Badge')) {

      user.badges.push('Bronze Badge');
   }

   if (user.streak >= 7 &&
      !user.badges.includes('7-Day Streak Badge')) {

      user.badges.push('7-Day Streak Badge');
   }

   await user.save();

   res.status(200).json({
      message: 'Points and streak updated',
      data: user
   });

 } catch(error) {

   res.status(500).json({
      error: error.message
   });

 }
};


export const getUserProgress = async (req, res) => {

 try {

   const user = await UserProgress.findOne({
      userId: req.params.userId
   });

   res.status(200).json(user);

 } catch(error) {

   res.status(500).json({
      error: error.message
   });

 }

};