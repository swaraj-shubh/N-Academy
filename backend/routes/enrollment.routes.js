import { Router } from "express";
import { protect } from "../middlewares/auth.middleware.js";
import { allowRoles } from "../middlewares/role.middleware.js";
import { enrollCourse, myCourses } from "../controllers/enrollment.controller.js";

const router = Router();

router.post(
  "/:courseId",
  protect,
  allowRoles("student"),
  enrollCourse
);

router.get(
  "/my-courses",
  protect,
  allowRoles("student"),
  myCourses
);

export default router;
