import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'router/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await initializeDateFormatting('id_ID', null);
  } catch (e) {
    debugPrint('DateFormatting initialization warning: $e');
  }

  try {
    await Supabase.initialize(
      url: 'https://lyovbqiatuekoxqwspko.supabase.co',
      publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx5b3ZicWlhdHVla294cXdzcGtvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUyMjM3MzEsImV4cCI6MjEwMDc5OTczMX0.bqp2YMnzY21JDOPHL5D0EoWX9nGKjP7BqaT7JD8iKik',
    );
  } catch (e) {
    debugPrint('Supabase initialization warning: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const EAccessApp(),
    ),
  );
}

class EAccessApp extends StatelessWidget {
  const EAccessApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: 'E-ACCESS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      routerConfig: AppRouter.createRouter(authProvider),
    );
  }
}
