import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

/// Raíz de la interfaz de la aplicación.
class ReportaTuBarrioApp extends StatelessWidget {
  const ReportaTuBarrioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.inicio,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

