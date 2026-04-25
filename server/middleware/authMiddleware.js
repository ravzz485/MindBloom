import jwt from "jsonwebtoken";
import User from "../models/User.js";

export const protect = async (req, res, next) => {
  let token;

  try {
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith("Bearer")
    ) {
      token = req.headers.authorization.split(" ")[1];

      console.log("Token received:", token);

      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      console.log("Decoded:", decoded);

      req.user = await User.findById(decoded.id).select("-password");

      console.log("User found:", req.user);

      return next();
    }

    if (!token) {
      return res.status(401).json({
        message: "Not authorized, no token"
      });
    }

  } catch (error) {
    console.log("Auth error:", error.message);
    return res.status(401).json({
      message: "Not authorized, token failed"
    });
  }
};