import Course from "../models/course.model.js";
import { ok } from "../utils/response.js";

/**
 * Teacher creates course
 */
export const createCourse = async (req, res, next) => {
  try {
    const course = await Course.create({
      title: req.body.title,
      description: req.body.description,
      price: req.body.price,
      currency: req.body.currency || "INR",
      teacherId: req.user.id,
    });

    ok(res, course, "Course created");
  } catch (err) {
    next(err);
  }
};

/**
 * Student fetches all courses
 */
export const listCourses = async (req, res, next) => {
  try {
    const courses = await Course.find({ status: "published" })
      .populate("teacherId", "email");

    ok(res, courses);
  } catch (err) {
    next(err);
  }
};
