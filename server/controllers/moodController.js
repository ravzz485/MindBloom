export const getMoods = async (req, res) => {
  try {
    res.json({
      success: true,
      message: "Mood controller working!"
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};