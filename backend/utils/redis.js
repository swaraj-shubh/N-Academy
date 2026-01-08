import Redis from "ioredis";

let redis;

if (process.env.REDIS_URL) {
  // Scenario 1: Production (Deployment)
  // If a REDIS_URL exists, we use it directly. 
  // Cloud providers give you one long string like "rediss://user:pass@host:port"
  console.log("Redis connecting via URL...", process.env.REDIS_URL);
  redis = new Redis(process.env.REDIS_URL);
} else {
  // Scenario 2: Localhost (Your Kali Laptop)
  // If no URL is found, we assume we are running locally
  console.log("Redis connecting via Host/Port...");
  redis = new Redis({
    host: process.env.REDIS_HOST || "127.0.0.1",
    port: process.env.REDIS_PORT || 6379,
  });
}

export default redis;
