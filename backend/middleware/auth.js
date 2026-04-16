import jwt from "jsonwebtoken";
import { userModel } from "../model/user.js";

export const checkAuth = async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({
      success: false,
      message: "Unauthorized - No token provided",
    });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    if (!decoded) {
      return res.status(400).json({
        success: false,
        message: "Unauthorized - Invalid token",
      });
    }

    const user = await userModel.findById(decoded.userId).select("-password");

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "User not found !",
      });
    }

    req.user = user;

    next();
  } catch (error) {
    console.log("Error in CheckAuth : ", error);

    if (error.name === "TokenExpiredError") {
      return res.status(401).json({
        success: false,
        message: "Session expired",
        code: "TOKEN_EXPIRED",
      });
    }

    if (error.name === "JsonWebTokenError") {
      return res.status(401).json({
        success: false,
        message: "Invalid token",
        code: "INVALID_TOKEN",
      });
    }

    res.status(500).json({
      success: false,
      message: "Authorization failed",
      code: "SERVER_ERROR",
    });
  }
};
