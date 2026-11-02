import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/conectividad_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

/// Pantalla 1: Inicio y bienvenida.
///
/// Permite al usuario elegir su rol (Ciudadano o Municipalidad) y cuenta con
/// un interruptor discreto de desarrollo para alternar la conectividad simulada.
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conectividad = context.watch<ConectividadProvider>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con Logo y Título
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        AppConstants.appTagline,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Frase explicativa
              const Text(
                AppConstants.appDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Ilustración vectorial del barrio
              Center(
                child: SizedBox(
                  width: 280,
                  height: 200,
                  child: CustomPaint(
                    painter: _BarrioIllustrationPainter(),
                  ),
                ),
              ),

              const Spacer(),

              // Botones de acción
              PrimaryButton(
                text: 'Soy ciudadano',
                icon: Icons.person_outline_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.mapa);
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Soy municipalidad',
                icon: Icons.account_balance_outlined,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.loginMuni);
                },
              ),

              const SizedBox(height: 16),

              // Interruptor discreto de desarrollo para conectividad simulada
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        conectividad.hayConexion
                            ? Icons.wifi
                            : Icons.wifi_off_rounded,
                        size: 16,
                        color: conectividad.hayConexion
                            ? AppColors.success
                            : AppColors.offline,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        conectividad.hayConexion
                            ? 'Conexión: Online'
                            : 'Conexión: Offline (Simulado)',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Transform.scale(
                        scale: 0.75,
                        child: Switch(
                          value: conectividad.hayConexion,
                          activeThumbColor: AppColors.success,
                          onChanged: (_) {
                            context
                                .read<ConectividadProvider>()
                                .alternarConexion();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pintor personalizado para la ilustración del barrio (casas, poste y árbol).
class _BarrioIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Camino curvo inferior
    final pathCamino = Path()
      ..moveTo(0, h * 0.82)
      ..quadraticBezierTo(w * 0.35, h * 0.76, w * 0.65, h * 0.84)
      ..quadraticBezierTo(w * 0.85, h * 0.88, w, h * 0.78)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final paintCamino = Paint()
      ..color = const Color(0xFFC7DEFA)
      ..style = PaintingStyle.fill;
    canvas.drawPath(pathCamino, paintCamino);

    // Líneas punteadas del camino
    final paintLinea = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(w * 0.1, h * 0.88), Offset(w * 0.25, h * 0.87), paintLinea);
    canvas.drawLine(Offset(w * 0.4, h * 0.88), Offset(w * 0.6, h * 0.90), paintLinea);
    canvas.drawLine(Offset(w * 0.75, h * 0.89), Offset(w * 0.9, h * 0.85), paintLinea);

    // Casa Izquierda (Azul / Amarilla)
    final rectCasa1 = Rect.fromLTWH(w * 0.12, h * 0.45, w * 0.32, h * 0.37);
    final paintCasa1 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final paintBorde = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawRect(rectCasa1, paintCasa1);
    canvas.drawRect(rectCasa1, paintBorde);

    // Techo Casa 1
    final pathTecho1 = Path()
      ..moveTo(w * 0.08, h * 0.45)
      ..lineTo(w * 0.28, h * 0.28)
      ..lineTo(w * 0.48, h * 0.45)
      ..close();
    final paintTecho1 = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawPath(pathTecho1, paintTecho1);

    // Puerta Casa 1 (Ocre)
    final rectPuerta1 = Rect.fromLTWH(w * 0.27, h * 0.58, w * 0.11, h * 0.24);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rectPuerta1, const Radius.circular(4)),
      Paint()..color = const Color(0xFFEAA000),
    );

    // Ventana Casa 1
    final rectVentana1 = Rect.fromLTWH(w * 0.16, h * 0.55, w * 0.07, h * 0.09);
    canvas.drawRect(rectVentana1, Paint()..color = const Color(0xFFC7DEFA));
    canvas.drawRect(
      rectVentana1,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Poste de alumbrado central
    final xPoste = w * 0.50;
    final paintPoste = Paint()
      ..color = const Color(0xFF6B7280)
      ..strokeWidth = 3.0;
    canvas.drawLine(Offset(xPoste, h * 0.30), Offset(xPoste, h * 0.82), paintPoste);
    canvas.drawLine(Offset(xPoste - 10, h * 0.36), Offset(xPoste + 10, h * 0.36), paintPoste);
    canvas.drawCircle(Offset(xPoste, h * 0.30), 4, Paint()..color = const Color(0xFFF2A900));

    // Casa Derecha (Techo Naranja)
    final rectCasa2 = Rect.fromLTWH(w * 0.58, h * 0.45, w * 0.26, h * 0.37);
    canvas.drawRect(rectCasa2, paintCasa1);
    canvas.drawRect(rectCasa2, paintBorde);

    // Techo Casa 2
    final pathTecho2 = Path()
      ..moveTo(w * 0.55, h * 0.45)
      ..lineTo(w * 0.71, h * 0.30)
      ..lineTo(w * 0.87, h * 0.45)
      ..close();
    final paintTecho2 = Paint()
      ..color = const Color(0xFFE8590C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawPath(pathTecho2, paintTecho2);

    // Puerta Casa 2 (Azul)
    final rectPuerta2 = Rect.fromLTWH(w * 0.72, h * 0.60, w * 0.08, h * 0.22);
    canvas.drawRect(rectPuerta2, Paint()..color = AppColors.primary);

    // Ventana Casa 2
    final rectVentana2 = Rect.fromLTWH(w * 0.62, h * 0.53, w * 0.06, h * 0.08);
    canvas.drawRect(rectVentana2, Paint()..color = const Color(0xFFC7DEFA));
    canvas.drawRect(
      rectVentana2,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Árbol Derecho
    final xArbol = w * 0.89;
    canvas.drawRect(
      Rect.fromLTWH(xArbol - 3, h * 0.52, 6, h * 0.28),
      Paint()..color = const Color(0xFF8B5A2B),
    );
    canvas.drawCircle(
      Offset(xArbol, h * 0.50),
      22,
      Paint()..color = const Color(0xFF2E9E5B),
    );
    canvas.drawCircle(
      Offset(xArbol - 6, h * 0.52),
      16,
      Paint()..color = const Color(0xFF28854D),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
