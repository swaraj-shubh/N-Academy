import mongoose from "mongoose";

const enrollmentSchema = new mongoose.Schema(
  {
    studentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },

    courseId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Course",
      required: true,
      index: true,
    },

    teacherId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },

    purchase: {
      pricePaid: Number,
      currency: String,
      purchasedAt: { type: Date, default: Date.now },
      paymentProvider: String,
      paymentRef: String,
    },

    status: {
      type: String,
      enum: ["active", "expired", "refunded", "revoked"],
      default: "active",
    },

    access: {
      expiryDate: Date,
      isLifetime: { type: Boolean, default: true },
    },

    progress: {
      completedVideos: [String],
      lastWatchedVideo: String,
      completionPercentage: { type: Number, default: 0 },
    },
  },
  { timestamps: true }
);

// Prevent duplicate enrollment
enrollmentSchema.index(
  { studentId: 1, courseId: 1 },
  { unique: true }
);

export default mongoose.model("Enrollment", enrollmentSchema);
