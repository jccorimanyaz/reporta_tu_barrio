import 'package:flutter/material.dart';

/// Paleta de colores centralizada para Reporta tu Barrio.
///
/// Cumple con las especificaciones de diseño:
/// - Color principal: #1E5AA8
/// - Colores de estado:
///   - Pendiente: #757575
///   - En revisión: #F2A900
///   - En atención: #E8590C
///   - Resuelto: #2E9E5B
///   - Rechazado: #D32F2F
class AppColors {
  AppColors._();

  // Color Principal Institucional
  static const Color primary = Color(0xFF1E5AA8);
  static const Color primaryDark = Color(0xFF143D73);
  static const Color primaryLight = Color(0xFFE8F1FC);
  static const Color onPrimary = Colors.white;

  // Colores de Estados de Reporte
  static const Color estadoPendiente = Color(0xFF757575);
  static const Color estadoEnRevision = Color(0xFFF2A900);
  static const Color estadoEnAtencion = Color(0xFFE8590C);
  static const Color estadoResuelto = Color(0xFF2E9E5B);
  static const Color estadoRechazado = Color(0xFFD32F2F);

  // Fondos suaves para chips de estado
  static const Color estadoPendienteBg = Color(0xFFEEEEEE);
  static const Color estadoEnRevisionBg = Color(0xFFFEF6E6);
  static const Color estadoEnAtencionBg = Color(0xFFFDF0E8);
  static const Color estadoResueltoBg = Color(0xFFEAF6EE);
  static const Color estadoRechazadoBg = Color(0xFFFCEBEB);

  // Colores Neutrales y de Superficie
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F3F5);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE9ECEF);

  // Tipografía
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Feedback y Conectividad
  static const Color success = Color(0xFF2E9E5B);
  static const Color warning = Color(0xFFF2A900);
  static const Color danger = Color(0xFFD32F2F);
  static const Color offline = Color(0xFFE8590C);
}

