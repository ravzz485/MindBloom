// Simple XP → Level formula

export const calculateLevel = (xp) => {
  return Math.floor(xp / 100) + 1;
};

// XP required for next level
export const xpForNextLevel = (level) => {
  return level * 100;
};