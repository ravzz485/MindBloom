// Keywords for each category
const depressionKeywords = [
  "hopeless", "worthless", "empty", "sad",
  "depressed", "crying", "lonely", "miserable",
  "failure", "guilty", "helpless", "numb",
  "meaningless", "tired", "exhausted"
];

const anxietyKeywords = [
  "panic", "anxious", "worried", "fear",
  "nervous", "stress", "overwhelmed", "tense",
  "restless", "dread", "scared", "uneasy",
  "phobia", "trembling", "racing"
];

const sleepKeywords = [
  "sleep", "insomnia", "tired", "exhausted",
  "fatigue", "nightmare", "awake", "restless",
  "oversleeping", "cant sleep"
];

const stressKeywords = [
  "stress", "pressure", "burden", "overloaded",
  "deadline", "overwhelmed", "tense", "irritable",
  "frustrated", "angry", "burnout"
];

// Extract keywords from text
export const extractKeywords = (text) => {
  const textLower = text.toLowerCase();
  const found = [];

  depressionKeywords.forEach(word => {
    if (textLower.includes(word)) {
      found.push({ keyword: word, category: "depression" });
    }
  });

  anxietyKeywords.forEach(word => {
    if (textLower.includes(word)) {
      found.push({ keyword: word, category: "anxiety" });
    }
  });

  sleepKeywords.forEach(word => {
    if (textLower.includes(word)) {
      found.push({ keyword: word, category: "sleep" });
    }
  });

  stressKeywords.forEach(word => {
    if (textLower.includes(word)) {
      found.push({ keyword: word, category: "stress" });
    }
  });

  return found;
};

// Detect main issue from keywords
export const detectIssue = (keywords) => {
  const counts = {
    depression: 0,
    anxiety: 0,
    sleep: 0,
    stress: 0
  };

  keywords.forEach(k => {
    counts[k.category]++;
  });

  // Find category with most keywords
  const maxCategory = Object.keys(counts).reduce(
    (a, b) => counts[a] > counts[b] ? a : b
  );

  if (counts[maxCategory] === 0) return "general";
  return maxCategory;
};