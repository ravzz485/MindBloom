export const getTherapies = async (req, res) => {
  try {
    res.json({
      success: true,
      message: "Therapy controller working!"
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};