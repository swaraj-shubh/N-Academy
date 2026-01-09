import User from "../models/user.model.js";
import { ok } from "../utils/response.js";
import Enrollment from "../models/enrollment.model.js";
import Course from "../models/course.model.js";

/**
 * STUDENT DASHBOARD
 * - All enrolled courses with course + enrollment data
 */
export const studentDashboardController = async (req, res, next) => {
  try {
    const studentId = req.user.id;

    const enrollments = await Enrollment.find({
      studentId,
      status: "active",
    })
      .populate({
        path: "courseId",
        select: "title description price currency teacherId createdAt",
        populate: {
          path: "teacherId",
          select: "email",
        },
      })
      .select("purchase progress status createdAt");

    ok(res, {
      totalEnrolledCourses: enrollments.length,
      courses: enrollments,
    });
  } catch (err) {
    next(err);
  }
};


/**
 * TEACHER DASHBOARD
 * - Courses created by teacher
 * - Students enrolled per course
 */
export const teacherDashboardController = async (req, res, next) => {
  try {
    const teacherId = req.user.id;

    const courses = await Course.find({ teacherId })
      .select("title description price currency createdAt");

    const courseIds = courses.map((c) => c._id);

    const enrollments = await Enrollment.find({
      courseId: { $in: courseIds },
      status: "active",
    })
      .populate("studentId", "email createdAt")
      .select("courseId studentId purchase progress createdAt");

    // Group enrollments by courseId (MongoDB-efficient usage)
    const enrollmentMap = {};

    enrollments.forEach((enroll) => {
      const cid = enroll.courseId.toString();
      if (!enrollmentMap[cid]) enrollmentMap[cid] = [];
      enrollmentMap[cid].push(enroll);
    });

    const response = courses.map((course) => ({
      course,
      totalStudents: enrollmentMap[course._id]?.length || 0,
      students: enrollmentMap[course._id] || [],
    }));

    ok(res, {
      totalCourses: courses.length,
      courses: response,
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
