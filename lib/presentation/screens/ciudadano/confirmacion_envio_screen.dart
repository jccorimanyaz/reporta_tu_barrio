import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/primary_button.dart';

/// Pantalla 5: Confirmación de envío con soporte para Variante A (online)
/// y Variante B (sin conexión simulada).
class ConfirmacionEnvioScreen extends StatelessWidget {
  final bool enviadoOnline;

  const ConfirmacionEnvioScreen({
    super.key,
    required this.enviadoOnline,
  });

  @override
  Widget build(BuildContext context) {
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
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Confirmación de reporte',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Círculo central con ícono ilustrativo
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: enviadoOnline
                        ? AppColors.estadoResueltoBg
                        : AppColors.estadoEnAtencionBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      enviadoOnline
                          ? Icons.check_rounded
                          : Icons.cloud_off_rounded,
                      size: 64,
                      color: enviadoOnline
                          ? AppColors.success
                          : AppColors.offline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Badge de estado
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: enviadoOnline
                        ? AppColors.estadoResueltoBg
                        : AppColors.estadoEnAtencionBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    enviadoOnline
                        ? 'ENVIADO CORRECTAMENTE'
                        : 'PENDIENTE DE ENVÍO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: enviadoOnline
                          ? AppColors.success
                          : AppColors.offline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Título principal
              Center(
                child: Text(
                  enviadoOnline
                      ? '¡Reporte enviado!'
                      : 'Reporte guardado en tu teléfono',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Subtítulo explicativo
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    enviadoOnline
                        ? 'La municipalidad lo revisará antes de publicarlo en el mapa'
                        : 'Se enviará automáticamente cuando tengas internet',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Barra acento decorativa
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: enviadoOnline
                        ? AppColors.success
                        : AppColors.offline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Botón inferior "Volver al mapa"
              PrimaryButton(
                text: 'Volver al mapa',
                icon: Icons.map_outlined,
                onPressed: () {
                  // Regresa al mapa ciudadano limpiando la pila de formularios
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(AppRoutes.mapa),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
