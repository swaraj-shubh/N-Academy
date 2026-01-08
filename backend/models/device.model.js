import mongoose from "mongoose";

const deviceSchema = new mongoose.Schema(
  {
    userId: { 
      type: mongoose.Types.ObjectId, 
      ref: "User", 
      required: true 
    },
    deviceId: { 
      type: String, 
      required: true,
      // unique: true 
    },
    active: { 
      type: Boolean, 
      default: true 
    },
  },
  { timestamps: true }
);

export default mongoose.model("Device", deviceSchema);
