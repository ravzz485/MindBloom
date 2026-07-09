/// Content for the MindFeed wall: affirmations, TED talks, wellness tips.

class TedTalk {
  final String title;
  final String speaker;
  final String url; // ← PASTE the real YouTube link for each talk
  const TedTalk(this.title, this.speaker, this.url);
}

class TedCategory {
  final String name;
  final String emoji;
  final List<TedTalk> talks;
  const TedCategory(this.name, this.emoji, this.talks);
}

const List<String> selfLoveAffirmations = [
  'Be kind to yourself today. 💚',
  'You are good enough, exactly as you are.',
  'Your feelings are valid.',
  'Progress, not perfection.',
  'You have survived 100% of your hardest days.',
  'Rest is productive too.',
  'You are allowed to say no.',
  'Small steps still move you forward.',
  'You deserve the same kindness you give others.',
  'It\'s okay to ask for help.',
  'Your worth is not measured by your productivity.',
  'You are growing, even on the slow days.',
  'Breathe. You are doing better than you think.',
  'Comparison steals joy — your path is yours.',
  'Today, choose yourself.',
];

const List<TedCategory> tedCategories = [
  TedCategory('Stress & Anxiety', '🧠', [
    TedTalk('How to make stress your friend', 'Kelly McGonigal', ''),
    TedTalk('Why we all need emotional first aid', 'Guy Winch', ''),
    TedTalk('How to cope with anxiety', 'Olivia Remes', ''),
  ]),
  TedCategory('Mindfulness', '🧘', [
    TedTalk('All it takes is 10 mindful minutes', 'Andy Puddicombe', ''),
    TedTalk('The art of stillness', 'Pico Iyer', ''),
    TedTalk('Want to be happier? Stay in the moment', 'Matt Killingsworth', ''),
  ]),
  TedCategory('Self-Worth', '💚', [
    TedTalk('The power of vulnerability', 'Brené Brown', ''),
    TedTalk(
      'The space between self-esteem and self-compassion',
      'Kristin Neff',
      '',
    ),
    TedTalk('Your body language may shape who you are', 'Amy Cuddy', ''),
  ]),
  TedCategory('Sleep & Rest', '😴', [
    TedTalk('Sleep is your superpower', 'Matt Walker', ''),
    TedTalk('How to succeed? Get more sleep', 'Arianna Huffington', ''),
    TedTalk('The benefits of a good night\'s sleep', 'Shai Marcu', ''),
  ]),
  TedCategory('Happiness & Growth', '🌞', [
    TedTalk('The habits of happiness', 'Matthieu Ricard', ''),
    TedTalk('What makes a good life?', 'Robert Waldinger', ''),
    TedTalk('The happy secret to better work', 'Shawn Achor', ''),
  ]),
];

const List<String> wellnessTips = [
  '💧 Drink 5–8 glasses of water every day.',
  '🛏 Make your bed right after waking up — a small win to start the day.',
  '📵 No screens for the first 30 minutes after waking.',
  '🚶 Walk at least 20 minutes daily, ideally in daylight.',
  '😴 Try to sleep before 11 PM and keep a consistent schedule.',
  '🥗 Add one fruit or vegetable to every meal.',
  '🌬 When stressed, pause for 5 slow, deep breaths.',
  '📖 Write down 3 things you\'re grateful for each night.',
  '🧘 Meditate for 5–10 minutes daily — consistency beats duration.',
  '🌞 Get sunlight within an hour of waking to set your body clock.',
  '☕ Avoid caffeine after 2 PM for better sleep.',
  '🤝 Talk to at least one person you care about every day.',
  '📵 Take a 30-minute social media break daily.',
  '🧹 Tidy one small space — a clear space calms the mind.',
  '💪 Stretch for 5 minutes after waking or before bed.',
  '🎵 Create a calm-down playlist for tough moments.',
  '📝 Break big tasks into 3 smaller steps.',
  '🙅 Practice saying no to one unnecessary commitment.',
  '🛁 Wind down with a warm shower before bed.',
  '💚 Celebrate one small win every single day.',
];
