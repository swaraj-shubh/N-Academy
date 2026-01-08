import { Router } from "express";
import { protect } from "../middlewares/auth.middleware.js";
import { allowRoles } from "../middlewares/role.middleware.js";
import { createCourse, listCourses } from "../controllers/course.controller.js";

const router = Router();

router.post(
  "/",
  protect,
  allowRoles("teacher"),
  createCourse
);

router.get(
  "/",
  protect,
  allowRoles("student"),
  listCourses
);

export default router;
