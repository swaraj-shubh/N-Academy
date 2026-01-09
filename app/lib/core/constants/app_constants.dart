class AppConstants {
  static const String appName = "N academy";
  
  // API Endpoints
  static const String baseUrl = "https://n-academy.onrender.com/api"; // For Android emulator
  // static const String baseUrl = "http://localhost:5000/api"; // For iOS simulator
  
  static const String loginEndpoint = "/auth/login";
  static const String registerEndpoint = "/auth/register";
  static const String logoutEndpoint = "/auth/logout";
  static const String refreshEndpoint = "/auth/refresh";
  static const String profileEndpoint = "/dashboard/profile";
  static const String coursesEndpoint = "/courses";
  static const String enrollEndpoint = "/enrollments";
  static const String myCoursesEndpoint = "/enrollments/my-courses";
  
  // Storage Keys
  static const String accessTokenKey = "access_token";
  static const String refreshTokenKey = "refresh_token";
  static const String userDataKey = "user_data";
  static const String deviceIdKey = "device_id";
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int itemsPerPage = 10;
}

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String courses = '/courses';
  static const String myCourses = '/my-courses';
  static const String dashboard = '/dashboard';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String adminDashboard = '/admin-dashboard';
}