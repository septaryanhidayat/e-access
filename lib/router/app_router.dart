import 'package:flutter/material.dart';
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
import '../features/materials/presentation/screens/student_materials_screen.dart';
import '../features/materials/presentation/screens/material_detail_screen.dart';
import '../features/attendance/presentation/screens/attendance_screen.dart';
import '../features/analytics/presentation/screens/analytics_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/profile/presentation/screens/student_profile_screen.dart';
import '../features/grades/presentation/screens/student_grades_screen.dart';

class AppRouter {
  static Page<dynamic> _buildPageWithTransition(BuildContext context, GoRouterState state, Widget child) {
    final isMobile = MediaQuery.of(context).size.width < 1000;
    
    if (!isMobile) {
      // Normal web desktop transition (No slide animation, standard instant web navigation)
      return NoTransitionPage(
        key: state.pageKey,
        child: child,
      );
    }

    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCubic).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

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
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const LoginScreen()),
        ),
        GoRoute(
          path: '/dashboard_admin',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const DashboardAdminScreen()),
        ),
        GoRoute(
          path: '/dashboard_guru',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const DashboardGuruScreen()),
        ),
        GoRoute(
          path: '/dashboard_siswa',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const DashboardSiswaScreen()),
        ),
        // User & Academic Routes
        GoRoute(
          path: '/users',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const UserManagementScreen()),
        ),
        GoRoute(
          path: '/teachers',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const UserManagementScreen()),
        ),
        GoRoute(
          path: '/students',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const UserManagementScreen()),
        ),
        GoRoute(
          path: '/academic',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const AcademicScreen()),
        ),
        GoRoute(
          path: '/classes',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const AcademicScreen()),
        ),
        GoRoute(
          path: '/subjects',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const AcademicScreen()),
        ),
        // CBT & Materials Routes
        GoRoute(
          path: '/cbt',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const CbtManagementScreen()),
        ),
        GoRoute(
          path: '/manage_cbt',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const CbtManagementScreen()),
        ),
        GoRoute(
          path: '/bank_soal',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const CbtManagementScreen()),
        ),
        GoRoute(
          path: '/monitor_cbt',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const CbtManagementScreen()),
        ),
        GoRoute(
          path: '/results',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const CbtManagementScreen()),
        ),
        GoRoute(
          path: '/grades',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const StudentGradesScreen()),
        ),
        GoRoute(
          path: '/cbt_exam/:examId',
          pageBuilder: (context, state) {
            final examId = state.pathParameters['examId'] ?? 'demo_exam';
            return _buildPageWithTransition(context, state, CbtExamScreen(examId: examId));
          },
        ),
        GoRoute(
          path: '/materials',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const StudentMaterialsScreen()),
        ),
        GoRoute(
          path: '/material_detail/:materialId',
          pageBuilder: (context, state) {
            final materialId = state.pathParameters['materialId'] ?? 'demo_mat';
            return _buildPageWithTransition(context, state, MaterialDetailScreen(materialId: materialId));
          },
        ),
        // Attendance, Analytics, Settings & Profile
        GoRoute(
          path: '/attendance',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const AttendanceScreen()),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const AnalyticsScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const SettingsScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const StudentProfileScreen()),
        ),
        GoRoute(
          path: '/backup',
          pageBuilder: (context, state) => _buildPageWithTransition(context, state, const SettingsScreen()),
        ),
      ],
    );
  }
}
