import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import cookieParser from "cookie-parser";
import helmet from "helmet";
import mongoose from "mongoose";

import authRoutes from "./routes/auth.routes.js";
import testRoutes from "./routes/test.routes.js";
import dashboardRoutes from "./routes/dashboard.routes.js";
import courseRoutes from "./routes/course.routes.js"; 
import enrollmentRoutes from "./routes/enrollment.routes.js";
import { errorHandler } from "./middlewares/error.middleware.js";
import { rateLimiter } from "./middlewares/rateLimit.middleware.js";

dotenv.config();

const app = express();

// security
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(cookieParser());
app.use(rateLimiter);

// routes
app.use("/api/auth", authRoutes);
app.use("/api/test", testRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/courses", courseRoutes);
app.use("/api/enrollments", enrollmentRoutes);  

app.get('/', (req, res) => res.send('✅ API is running...hehe'));

// error handler
app.use(errorHandler);

// db + server
mongoose.connect(process.env.MONGO_URI).then(() => {
  console.log("✅ MongoDB connected successfully!!");
  app.listen(process.env.PORT, () =>
    console.log(`Server running on http://localhost:${process.env.PORT}`)
  );
})
.catch((err) => {
    console.error("❌ MongoDB  connection failed:", err);
    process.exit(1);
});
