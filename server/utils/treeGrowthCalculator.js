export const calculateTreeStage = (xp) => {

  if (xp >= 1000) {
    return 'Big Tree';
  }

  if (xp >= 500) {
    return 'Young Tree';
  }

  if (xp >= 250) {
    return 'Small Plant';
  }

  if (xp >= 100) {
    return 'Sprout';
  }

  return 'Seed';
};