export const getUsers = async (req, res) => {
  try {
    res.json({
      success: true,
      message: "User controller working!"
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};