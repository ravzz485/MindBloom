const authMiddleware = (req, res, next) => {
  // Temporary user for testing
  req.user = {
    _id: '507f1f77bcf86cd799439011',
  };

  next();
};

export default authMiddleware;