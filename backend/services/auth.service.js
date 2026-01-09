import User from "../models/user.model.js";
import Device from "../models/device.model.js";
import redis from "../utils/redis.js";
import { hashPassword, comparePassword } from "../utils/hash.js";
import { signAccessToken, signRefreshToken } from "../utils/jwt.js";

export const registerUser = async ({ email, password, role }) => {
  const hashed = await hashPassword(password);
  return User.create({ email, password: hashed, role });
};

// export const loginUser = async ({ email, password, deviceId }) => {
//   const user = await User.findOne({ email });
//   if (!user || !(await comparePassword(password, user.password))) {
//     throw new Error("Invalid credentials");
//   }

//   // one user → one device
//   await Device.updateMany({ userId: user._id }, { active: false });
//   await Device.create({ userId: user._id, deviceId, active: true });

//   return {
//     accessToken: signAccessToken({ id: user._id, role: user.role }),
//     refreshToken: signRefreshToken({ id: user._id }),
//   };
// };

export const loginUser = async ({ email, password, deviceId }) => {
  const user = await User.findOne({ email });
  if (!user || !(await comparePassword(password, user.password))) {
    throw new Error("Invalid credentials");
  }

  // Invalidate old device (DB)
  await Device.updateMany({ userId: user._id }, { active: false });

  // Save new device
  await Device.create({ userId: user._id, deviceId, active: true });

  // 🔐 Enforce device in Redis
  await redis.set(`device:${user._id}`, deviceId);

  return {
    accessToken: signAccessToken({ id: user._id, role: user.role }),
    refreshToken: signRefreshToken({ id: user._id }),
    user: { // Add user data here!
      id: user._id,
      email: user.email,
      role: user.role,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    },
  };
};
