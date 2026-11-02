import 'package:flutter/material.dart';

import '../../data/models/reporte.dart';
import '../../presentation/screens/ciudadano/confirmacion_envio_screen.dart';
import '../../presentation/screens/ciudadano/mapa_ciudadano_screen.dart';
import '../../presentation/screens/ciudadano/nuevo_reporte_screen.dart';
import '../../presentation/screens/inicio/inicio_screen.dart';
import '../../presentation/screens/municipal/gestion_reporte_screen.dart';
import '../../presentation/screens/municipal/login_municipal_screen.dart';
import '../../presentation/screens/municipal/panel_municipal_screen.dart';
import '../../presentation/screens/municipal/revision_reporte_screen.dart';

/// Centralización de rutas nombradas de la aplicación.
class AppRoutes {
  AppRoutes._();

  static const String inicio = '/';
  static const String mapa = '/mapa';
  static const String nuevoReporte = '/nuevo-reporte';
  static const String confirmacion = '/confirmacion';
  static const String loginMuni = '/login-muni';
  static const String panelMuni = '/panel-muni';
  static const String revisarReporte = '/revisar-reporte';
  static const String gestionarReporte = '/gestionar-reporte';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case inicio:
        return MaterialPageRoute(builder: (_) => const InicioScreen());
      case mapa:
        return MaterialPageRoute(builder: (_) => const MapaCiudadanoScreen());
      case nuevoReporte:
        return MaterialPageRoute(builder: (_) => const NuevoReporteScreen());
      case confirmacion:
        final bool enviadoOnline = (settings.arguments as bool?) ?? true;
        return MaterialPageRoute(
          builder: (_) => ConfirmacionEnvioScreen(enviadoOnline: enviadoOnline),
        );
      case loginMuni:
        return MaterialPageRoute(builder: (_) => const LoginMunicipalScreen());
      case panelMuni:
        return MaterialPageRoute(builder: (_) => const PanelMunicipalScreen());
      case revisarReporte:
        final reporte = settings.arguments as Reporte;
        return MaterialPageRoute(
          builder: (_) => RevisionReporteScreen(reporte: reporte),
        );
      case gestionarReporte:
        final reporte = settings.arguments as Reporte;
        return MaterialPageRoute(
          builder: (_) => GestionReporteScreen(reporte: reporte),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}

