import mongoose from "mongoose";

export const errorHandler = (err, req, res, next) => {
  let statusCode = err.statusCode || 500;
  let message = err.message || "Internal Server Error";

  // 🔐 JWT errors
  if (err.name === "JsonWebTokenError") {
    statusCode = 401;
    message = "Invalid token";
  }

  if (err.name === "TokenExpiredError") {
    statusCode = 401;
    message = "Token expired";
  }

  // 🧾 Mongoose validation error
  if (err instanceof mongoose.Error.ValidationError) {
    statusCode = 400;
    message = Object.values(err.errors)
      .map((el) => el.message)
      .join(", ");
  }

  // 🧩 Mongoose cast error (invalid ObjectId)
  if (err instanceof mongoose.Error.CastError) {
    statusCode = 400;
    message = `Invalid ${err.path}: ${err.value}`;
  }

  // 🔁 Duplicate key error
  if (err.code === 11000) {
    statusCode = 409;
    const field = Object.keys(err.keyValue)[0];
    message = `${field} already exists`;
  }

  // 🧠 Default fallback
  res.status(statusCode).json({
    success: false,
    statusCode,
    message,
  });
};
