import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/dashboard/presentation/screens/dashboard_admin_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_guru_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_siswa_screen.dart';
import '../features/users/presentation/screens/user_management_screen.dart';
import '../features/academic/presentation/screens/academic_screen.dart';
import '../features/cbt/presentation/screens/cbt_management_screen.dart';
import '../features/cbt/presentation/screens/cbt_exam_screen.dart';
import '../features/materials/presentation/screens/material_detail_screen.dart';
import '../features/attendance/presentation/screens/attendance_screen.dart';
import '../features/analytics/presentation/screens/analytics_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final authStatus = authProvider.status;
        final isLoggingIn = state.matchedLocation == '/login';

        if (authStatus == AuthStatus.initial || authStatus == AuthStatus.loading) {
          return null; // wait
        }

        if (authStatus == AuthStatus.unauthenticated && !isLoggingIn) {
          return '/login';
        }

        if (authStatus == AuthStatus.authenticated) {
          if (isLoggingIn || state.matchedLocation == '/') {
            final role = authProvider.userRole;
            if (role == 'Super Admin' || role == 'Admin') return '/dashboard_admin';
            if (role == 'Guru') return '/dashboard_guru';
            if (role == 'Siswa') return '/dashboard_siswa';
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard_admin',
          builder: (context, state) => const DashboardAdminScreen(),
        ),
        GoRoute(
          path: '/dashboard_guru',
          builder: (context, state) => const DashboardGuruScreen(),
        ),
        GoRoute(
          path: '/dashboard_siswa',
          builder: (context, state) => const DashboardSiswaScreen(),
        ),
        // User & Academic Routes
        GoRoute(
          path: '/users',
          builder: (context, state) => const UserManagementScreen(),
        ),
        GoRoute(
          path: '/teachers',
          builder: (context, state) => const UserManagementScreen(),
        ),
        GoRoute(
          path: '/students',
          builder: (context, state) => const UserManagementScreen(),
        ),
        GoRoute(
          path: '/academic',
          builder: (context, state) => const AcademicScreen(),
        ),
        GoRoute(
          path: '/classes',
          builder: (context, state) => const AcademicScreen(),
        ),
        GoRoute(
          path: '/subjects',
          builder: (context, state) => const AcademicScreen(),
        ),
        // CBT & Materials Routes
        GoRoute(
          path: '/cbt',
          builder: (context, state) => const CbtManagementScreen(),
        ),
        GoRoute(
          path: '/manage_cbt',
          builder: (context, state) => const CbtManagementScreen(),
        ),
        GoRoute(
          path: '/bank_soal',
          builder: (context, state) => const CbtManagementScreen(),
        ),
        GoRoute(
          path: '/monitor_cbt',
          builder: (context, state) => const CbtManagementScreen(),
        ),
        GoRoute(
          path: '/results',
          builder: (context, state) => const CbtManagementScreen(),
        ),
        GoRoute(
          path: '/grades',
          builder: (context, state) => const CbtManagementScreen(),
        ),
        GoRoute(
          path: '/cbt_exam/:examId',
          builder: (context, state) {
            final examId = state.pathParameters['examId'] ?? 'demo_exam';
            return CbtExamScreen(examId: examId);
          },
        ),
        GoRoute(
          path: '/materials',
          builder: (context, state) => const MaterialDetailScreen(materialId: 'mat_1'),
        ),
        GoRoute(
          path: '/material_detail/:materialId',
          builder: (context, state) {
            final materialId = state.pathParameters['materialId'] ?? 'demo_mat';
            return MaterialDetailScreen(materialId: materialId);
          },
        ),
        // Attendance, Analytics, Settings
        GoRoute(
          path: '/attendance',
          builder: (context, state) => const AttendanceScreen(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/backup',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
  }
}
