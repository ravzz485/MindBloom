import ChatLog from "../models/ChatLog.js";

// ─── Rule Based Responses ────────────────────────
const getBotResponse = (message) => {
  const msg = message.toLowerCase();

  // Greetings
  if (msg.includes("hello") || msg.includes("hi") ||
    msg.includes("hey")) {
    return "Hello!  I'm MindBloom assistant. How are you feeling today?";
  }

  // Stress responses
  if (msg.includes("stress") || msg.includes("stressed") ||
    msg.includes("pressure")) {
    return "I understand you're feeling stressed  Try this: Take 5 deep breaths. Inhale for 4 counts, hold for 4, exhale for 4. You've got this! ";
  }

  // Anxiety responses
  if (msg.includes("anxious") || msg.includes("anxiety") ||
    msg.includes("panic") || msg.includes("worried")) {
    return "I hear you. Anxiety can be overwhelming  Try grounding yourself: Name 5 things you can see, 4 you can touch, 3 you can hear. This helps calm your mind! 🌿";
  }

  // Depression responses
  if (msg.includes("depressed") || msg.includes("depression") ||
    msg.includes("hopeless") || msg.includes("worthless")) {
    return "I'm sorry you're feeling this way  Remember, you are not alone. Please consider talking to a mental health professional. You deserve support and care! 🌸";
  }

  // Sad responses
  if (msg.includes("sad") || msg.includes("cry") ||
    msg.includes("unhappy") || msg.includes("miserable")) {
    return "It's okay to feel sad sometimes  Try journaling your thoughts or talking to someone you trust. Small steps matter! ";
  }

  // Sleep responses
  if (msg.includes("sleep") || msg.includes("insomnia") ||
    msg.includes("tired") || msg.includes("exhausted")) {
    return "Poor sleep affects mental health greatly  Try: No screens 1 hour before bed, keep a consistent sleep schedule, and try relaxing music or meditation! ";
  }

  // Happy responses
  if (msg.includes("happy") || msg.includes("great") ||
    msg.includes("good") || msg.includes("amazing")) {
    return "That's wonderful to hear!  Keep nurturing your positive energy. Maybe journal this feeling to remember it on harder days! ";
  }

  // Lonely responses
  if (msg.includes("lonely") || msg.includes("alone") ||
    msg.includes("isolated")) {
    return "Feeling lonely is hard  Try reaching out to a friend or family member today. Even a small message can make a big difference! ";
  }

  // Angry responses
  if (msg.includes("angry") || msg.includes("anger") ||
    msg.includes("frustrated") || msg.includes("mad")) {
    return "It's okay to feel angry Try taking a short walk or doing some physical activity to release that energy. Deep breathing helps too! ";
  }

  // Help responses
  if (msg.includes("help") || msg.includes("support") ||
    msg.includes("need someone")) {
    return "I'm here for you!  For immediate support please contact a mental health helpline. You can also try our assessment to understand your feelings better! ";
  }

  // Meditation responses
  if (msg.includes("meditat") || msg.includes("calm") ||
    msg.includes("relax")) {
    return "Meditation is great for mental health!  Try this: Sit comfortably, close your eyes, focus on your breath for 5 minutes. Even 5 minutes daily makes a difference! 🌿";
  }

  // Exercise responses
  if (msg.includes("exercise") || msg.includes("workout") ||
    msg.includes("walk")) {
    return "Exercise is amazing for mental health!  Even a 20 minute walk can boost your mood significantly. Keep it up! ";
  }

  // Breathing responses
  if (msg.includes("breath") || msg.includes("breathing")) {
    return "Try box breathing!  Inhale for 4 counts → Hold for 4 → Exhale for 4 → Hold for 4. Repeat 4 times. This calms your nervous system! ";
  }

  // Suicide/self harm - emergency
  if (msg.includes("suicide") || msg.includes("kill myself") ||
    msg.includes("self harm") || msg.includes("hurt myself")) {
    return " I'm very concerned about you. Please reach out to a crisis helpline immediately. You matter and help is available! Please call emergency services or a trusted person RIGHT NOW! ";
  }

  // Default response
  return "Thank you for sharing with me  I'm here to listen. Could you tell me more about how you're feeling? Or try our Mental Health Assessment for a deeper understanding! ";
};

// ─── Send Message ────────────────────────────────
// @route POST /api/chat/message
export const sendMessage = async (req, res) => {
  try {
    const { message } = req.body;
    const userId = req.user._id;

    // Get bot response
    const botResponse = getBotResponse(message);

    // Find existing chat log or create new one
    let chatLog = await ChatLog.findOne({ userId });

    if (!chatLog) {
      chatLog = await ChatLog.create({
        userId,
        messages: []
      });
    }

    // Add user message and bot response
    chatLog.messages.push({
      sender: "user",
      message,
      timestamp: new Date()
    });

    chatLog.messages.push({
      sender: "bot",
      message: botResponse,
      timestamp: new Date()
    });

    await chatLog.save();

    res.json({
      success: true,
      userMessage: message,
      botResponse,
      timestamp: new Date()
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Get Chat History ────────────────────────────
// @route GET /api/chat/history
export const getChatHistory = async (req, res) => {
  try {
    const userId = req.user._id;

    const chatLog = await ChatLog.findOne({ userId });

    if (!chatLog) {
      return res.json({
        success: true,
        messages: []
      });
    }

    // Get last 50 messages
    const messages = chatLog.messages.slice(-50);

    res.json({
      success: true,
      count: messages.length,
      messages
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ─── Clear Chat History ──────────────────────────
// @route DELETE /api/chat/clear
export const clearChatHistory = async (req, res) => {
  try {
    const userId = req.user._id;

    await ChatLog.findOneAndUpdate(
      { userId },
      { messages: [] }
    );

    res.json({
      success: true,
      message: "Chat history cleared!"
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};