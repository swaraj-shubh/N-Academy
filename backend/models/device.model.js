import mongoose from "mongoose";

const deviceSchema = new mongoose.Schema(
  {
    userId: mongoose.Types.ObjectId,
    deviceId: String,
    active: Boolean,
  },
  { timestamps: true }
);

export default mongoose.model("Device", deviceSchema);
