import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reporta_tu_barrio/app.dart';
import 'package:reporta_tu_barrio/data/repositories/mock_auth_repository.dart';
import 'package:reporta_tu_barrio/data/repositories/mock_reporte_repository.dart';
import 'package:reporta_tu_barrio/data/services/conectividad_service.dart';
import 'package:reporta_tu_barrio/providers/auth_provider.dart';
import 'package:reporta_tu_barrio/providers/conectividad_provider.dart';
import 'package:reporta_tu_barrio/providers/reportes_provider.dart';

void main() {
  testWidgets('Smoke test inicial de la aplicacion', (WidgetTester tester) async {
    final mockRepo = MockReporteRepository();
    final mockAuth = MockAuthRepository();
    final mockConectividad = MockConectividadService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ReportesProvider(mockRepo)),
          ChangeNotifierProvider(create: (_) => AuthProvider(mockAuth)),
          ChangeNotifierProvider(create: (_) => ConectividadProvider(mockConectividad)),
        ],
        child: const ReportaTuBarrioApp(),
      ),
    );

    // Espera a que se renderice el frame inicial
    await tester.pumpAndSettle();

    // Verifica que se encuentren los elementos de la pantalla de inicio
    expect(find.text('Reporta tu Barrio'), findsOneWidget);
    expect(find.text('Soy ciudadano'), findsOneWidget);
    expect(find.text('Soy municipalidad'), findsOneWidget);
  });
}
