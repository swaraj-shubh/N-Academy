import { Router } from "express";
import { protect } from "../middlewares/auth.middleware.js";
import { allowRoles } from "../middlewares/role.middleware.js";

import {
  studentDashboardController,
  teacherDashboardController,
  adminUsersController,
  profileController,
} from "../controllers/dashboard.controller.js";

const router = Router();

/**
 * STUDENT DASHBOARD
 */
router.get(
  "/student/dashboard",
  protect,
  allowRoles("student"),
  studentDashboardController
);

/**
 * TEACHER DASHBOARD
 */
router.get(
  "/teacher/dashboard",
  protect,
  allowRoles("teacher"),
  teacherDashboardController
);

/**
 * ADMIN – LIST ALL USERS
 */
router.get(
  "/admin/users",
  protect,
  allowRoles("admin"),
  adminUsersController
);

/**
 * PROFILE (ALL ROLES)
 */
router.get(
  "/profile",
  protect,
  allowRoles("student", "teacher", "admin"),
  profileController
);

export default router;
