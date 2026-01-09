// routes/health.routes.js
import { Router } from "express";
import redis from "../utils/redis.js";
import mongoose from "mongoose";

const router = Router();

router.get("/health", async (req, res) => {
  const health = {
    uptime: process.uptime(),
    timestamp: Date.now(),
    services: {
      database: mongoose.connection.readyState === 1 ? "up" : "down",
      redis: redis.status === "ready" ? "up" : "down",
    }
  };
  
  const isHealthy = health.services.database === "up" && 
                    health.services.redis === "up";
  
  res.status(isHealthy ? 200 : 503).json(health);
});

export default router;

// In index.js
import healthRoutes from "./routes/health.routes.js";
app.use("/api/health", healthRoutes);