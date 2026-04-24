const calculatePoints = (activityType) => {
 const pointsMap = {
   mood_checkin: 10,
   daily_task: 20,
   meditation: 15
 };

 return pointsMap[activityType] || 5;
};

export default calculatePoints;