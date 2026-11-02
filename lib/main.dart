import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/mock_auth_repository.dart';
import 'data/repositories/mock_reporte_repository.dart';
import 'data/repositories/reporte_repository.dart';
import 'data/services/conectividad_service.dart';
import 'providers/auth_provider.dart';
import 'providers/conectividad_provider.dart';
import 'providers/reportes_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de formatos de fecha en español
  await initializeDateFormatting('es', null);

  // Inyección de dependencias abstractas
  // TODO(firebase): Reemplazar MockReporteRepository por FirestoreReporteRepository
  final ReporteRepository reporteRepository = MockReporteRepository();

  // TODO(firebase): Reemplazar MockAuthRepository por FirebaseAuthRepository
  final AuthRepository authRepository = MockAuthRepository();

  // Servicio simulado con interruptor on/off para Fase 1
  final ConectividadService conectividadService = MockConectividadService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ReportesProvider(reporteRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ConectividadProvider(conectividadService),
        ),
      ],
      child: const ReportaTuBarrioApp(),
    ),
  );
}
