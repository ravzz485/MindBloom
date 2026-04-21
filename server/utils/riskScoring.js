// PHQ9 Risk Scoring (Depression)
export const calculatePHQ9Risk = (score) => {
  if (score <= 4) return { level: "minimal", color: "green", message: "Minimal depression" };
  if (score <= 9) return { level: "mild", color: "yellow", message: "Mild depression" };
  if (score <= 14) return { level: "moderate", color: "orange", message: "Moderate depression" };
  return { level: "severe", color: "red", message: "Severe depression" };
};

// GAD7 Risk Scoring (Anxiety)
export const calculateGAD7Risk = (score) => {
  if (score <= 4) return { level: "minimal", color: "green", message: "Minimal anxiety" };
  if (score <= 9) return { level: "mild", color: "yellow", message: "Mild anxiety" };
  if (score <= 14) return { level: "moderate", color: "orange", message: "Moderate anxiety" };
  return { level: "severe", color: "red", message: "Severe anxiety" };
};

// Quick Check Risk Scoring
export const calculateQuickRisk = (score) => {
  if (score <= 3) return { level: "minimal", color: "green", message: "You seem to be doing well!" };
  if (score <= 6) return { level: "mild", color: "yellow", message: "You may be experiencing some stress" };
  if (score <= 9) return { level: "moderate", color: "orange", message: "You may need some support" };
  return { level: "severe", color: "red", message: "Please seek professional help" };
};

// Combined Risk Score
export const calculateCombinedRisk = (phq9Score, gad7Score) => {
  const total = phq9Score + gad7Score;
  if (total <= 8) return "minimal";
  if (total <= 18) return "mild";
  if (total <= 28) return "moderate";
  return "severe";
};