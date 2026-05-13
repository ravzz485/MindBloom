require("dotenv").config();
const mongoose = require("mongoose");
const Activity = require("./models/Activity");

mongoose.connect(process.env.MONGO_URI).then(async () => {
  
  // Clear old activities
  await Activity.deleteMany({});

  // Add new activities
  await Activity.insertMany([
    {
      title: "Deep Breathing",
      type: "breathing",
      riskLevel: "low",
      content: "Inhale for 4 seconds, hold for 4, exhale for 4. Repeat 5 times.",
      duration: 5,
      isEmergency: false,
    },
    {
      title: "Body Scan Meditation",
      type: "meditation",
      riskLevel: "low",
      content: "Close your eyes and slowly focus on each part of your body from head to toe.",
      duration: 10,
      isEmergency: false,
    },
    {
      title: "Gratitude Journal",
      type: "journaling",
      riskLevel: "low",
      content: "Write 3 things you are grateful for today.",
      duration: 10,
      isEmergency: false,
    },
    {
      title: "Progressive Muscle Relaxation",
      type: "meditation",
      riskLevel: "moderate",
      content: "Tense and release each muscle group starting from your feet up to your face.",
      duration: 15,
      isEmergency: false,
    },
    {
      title: "Sleep Hygiene Tips",
      type: "sleep_tips",
      riskLevel: "moderate",
      content: "Avoid screens 1 hour before bed. Keep a consistent sleep schedule every day.",
      duration: 5,
      isEmergency: false,
    },
    {
      title: "Mood Journal",
      type: "journaling",
      riskLevel: "moderate",
      content: "Write about how you are feeling today and what triggered those feelings.",
      duration: 10,
      isEmergency: false,
    },
    {
      title: "Box Breathing",
      type: "breathing",
      riskLevel: "high",
      content: "Inhale 4 seconds, hold 4, exhale 4, hold 4. Repeat until calm.",
      duration: 5,
      isEmergency: true,
    },
    {
      title: "Calming Audio",
      type: "audio",
      riskLevel: "high",
      content: "Listen to calming nature sounds. Focus only on the sounds around you.",
      duration: 15,
      isEmergency: true,
    },
    {
      title: "Emergency Grounding",
      type: "meditation",
      riskLevel: "high",
      content: "Name 5 things you see, 4 you hear, 3 you can touch, 2 you smell, 1 you taste.",
      duration: 5,
      isEmergency: true,
    },
  ]);

  console.log("Activities seeded successfully!");
  process.exit(0);
}).catch((err) => {
  console.log("Error:", err.message);
  process.exit(1);
});