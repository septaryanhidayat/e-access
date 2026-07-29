import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/dashboard/presentation/screens/dashboard_admin_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_guru_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_siswa_screen.dart';

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
      ],
    );
  }
}
