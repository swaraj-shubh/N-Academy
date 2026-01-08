import jwt from "jsonwebtoken";
import redis from "../utils/redis.js";

export const protect = async (req, res, next) => {
  const token =
    req.cookies?.accessToken ||
    req.header("Authorization")?.replace("Bearer ", "");

  if (!token) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  const decoded = jwt.verify(token, process.env.JWT_SECRET);

  // device sent from frontend (header)
  const deviceId = req.header("x-device-id");
  const activeDevice = await redis.get(`device:${decoded.id}`);

  if (!activeDevice || activeDevice !== deviceId) {
    return res.status(401).json({ message: "Device session expired" });
  }

  req.user = decoded;
  next();
};

// export const protect = (req, res, next) => {
//   const token = req.cookies?.accessToken;
//   if (!token) return res.status(401).json({ message: "Unauthorized" });

//   req.user = jwt.verify(token, process.env.JWT_SECRET);
//   next();
// };

// options: restrictTo('admin'), restrictTo('user', 'admin')
// Usage: restrictTo('admin', 'moderator')
// roles: array of allowed roles
export const restrictTo = (...roles) => (req, res, next) => {
  if (!roles.includes(req.user.role)) {
    return res.status(403).json({ message: "Forbidden" });
  }
  next();
};