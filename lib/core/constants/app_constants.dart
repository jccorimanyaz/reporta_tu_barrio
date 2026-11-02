import 'package:latlong2/latlong.dart';

/// Constantes globales de la aplicación Reporta tu Barrio.
class AppConstants {
  AppConstants._();

  // ===========================================================================
  // CONFIGURACIÓN DEL MAPA
  // ===========================================================================
  // Para cambiar el centro del mapa a otra ciudad o barrio, modifica las
  // coordenadas de [centroInicialMapa] aquí mismo:
  // Ejemplo Lima: LatLng(-12.046374, -77.042793)
  // Ejemplo Arequipa (por defecto): LatLng(-16.409047, -71.537451)
  static const LatLng centroInicialMapa = LatLng(-16.409047, -71.537451);
  static const double zoomInicialMapa = 15.0;
  static const double minZoomMapa = 11.0;
  static const double maxZoomMapa = 18.0;

  /// User-Agent obligatorio para las peticiones de teselas de OpenStreetMap.
  static const String userAgentPackageName = 'com.unsa.reporta_tu_barrio';

  // ===========================================================================
  // CREDENCIALES SIMULADAS DEL PANEL MUNICIPAL
  // ===========================================================================
  // TODO(firebase): Reemplazar credenciales estáticas por Firebase Authentication
  static const String credencialMuniEmail = 'muni@demo.com';
  static const String credencialMuniPassword = '123456';

  // ===========================================================================
  // TEXTOS DE LA APLICACIÓN
  // ===========================================================================
  static const String appName = 'Reporta tu Barrio';
  static const String appTagline = 'Tu comunidad, más cerca';
  static const String appDescription =
      'Reporta problemas de tu entorno y mira cómo se atienden';

  // Límites de formularios
  static const int maxDescripcionChars = 300;
}

