import Enrollment from "../models/enrollment.model.js";
import Course from "../models/course.model.js";
import { ok } from "../utils/response.js";

/**
 * Student buys/enrolls in a course
 */
export const enrollCourse = async (req, res, next) => {
  try {
    const studentId = req.user.id;
    const { courseId } = req.params;

    const course = await Course.findById(courseId);
    if (!course) {
      return res.status(404).json({ message: "Course not found" });
    }

    const enrollment = await Enrollment.create({
      studentId,
      courseId,
      teacherId: course.teacherId,
      purchase: {
        pricePaid: course.price,
        currency: course.currency,
        paymentProvider: "manual", // payment gateway later
      },
    });

    ok(res, enrollment, "Course enrolled successfully");
  } catch (err) {
    next(err);
  }
};

/**
 * Student's enrolled courses
 */
export const myCourses = async (req, res, next) => {
  try {
    const enrollments = await Enrollment.find({
      studentId: req.user.id,
      status: "active",
    }).populate("courseId");

    ok(res, enrollments);
  } catch (err) {
    next(err);
  }
};
