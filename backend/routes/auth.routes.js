import { Router } from "express";
import { register, login, refreshToken } from "../controllers/auth.controller.js";
import { protect } from "../middlewares/auth.middleware.js";
import { logout } from "../controllers/auth.controller.js";

const router = Router();

router.post("/register", register);
router.post("/login", login);
router.post("/logout", protect, logout);
router.post("/refresh", refreshToken);


export default router;
