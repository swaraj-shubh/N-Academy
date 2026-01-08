import User from "../models/user.model.js";
import { ok } from "../utils/response.js";

/**
 * STUDENT DASHBOARD
 */
export const studentDashboardController = async (req, res, next) => {
  try {
    ok(res, {
      message: "Student dashboard data",
      userId: req.user.id,
    });
  } catch (err) {
    next(err);
  }
};

/**
 * TEACHER DASHBOARD
 */
export const teacherDashboardController = async (req, res, next) => {
  try {
    ok(res, {
      message: "Teacher dashboard data",
      teacherId: req.user.id,
    });
  } catch (err) {
    next(err);
  }
};

/**
 * ADMIN – LIST USERS
 */
export const adminUsersController = async (req, res, next) => {
  try {
    const users = await User.find().select("-password");
    ok(res, users, "All users fetched");
  } catch (err) {
    next(err);
  }
};

/**
 * PROFILE – ALL ROLES
 */
export const profileController = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id).select("-password");
    ok(res, user, "Profile fetched");
  } catch (err) {
    next(err);
  }
};
