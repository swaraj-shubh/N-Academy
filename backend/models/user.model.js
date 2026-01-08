import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    email: { 
      type: String,
      required: true,
      trim: true,
      lowercase: true, 
      unique: true 
    },
    password: { 
      type: String, 
      required: true 
    },
    role: { 
      type: String, 
      enum: ["admin", "teacher", "student"], 
      default: "student",
      index: true
    },
  },
  { timestamps: true }
);

export default mongoose.model("User", userSchema);
