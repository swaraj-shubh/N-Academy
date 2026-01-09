import { registerUser, loginUser } from "../services/auth.service.js";
import { ok } from "../utils/response.js";
import redis from "../utils/redis.js";
import jwt from "jsonwebtoken";
import { signAccessToken } from "../utils/jwt.js";

export const refreshToken = async (req, res, next) => {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) throw new Error("Missing refresh token");

    const decoded = jwt.verify(
      refreshToken,
      process.env.JWT_REFRESH_SECRET
    );

    const newAccessToken = signAccessToken({ id: decoded.id });

    res.json({
      success: true,
      accessToken: newAccessToken,
    });
  } catch (e) {
    next(e);
  }
};

export const register = async (req, res, next) => {
  try {
    const user = await registerUser(req.body);
    
    // Return user data along with success message
    res.json({
      success: true,
      message: "User registered",
      data: {
        id: user._id,
        email: user.email,
        role: user.role,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      }
    });
  } catch (e) {
    next(e);
  }
};

export const login = async (req, res, next) => {
  try {
    const tokens = await loginUser(req.body);
    ok(res, tokens, "Login successful");
  } catch (e) {
    next(e);
  }
};

export const logout = async (req, res, next) => {
  try {
    await redis.del(`device:${req.user.id}`);
    res.json({ success: true, message: "Logged out" });
  } catch (e) {
    next(e);
  }
};
