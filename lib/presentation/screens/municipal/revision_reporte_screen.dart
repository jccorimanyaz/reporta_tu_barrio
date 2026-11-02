import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/reporte.dart';
import '../../../providers/reportes_provider.dart';
import '../../widgets/estado_chip.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

/// Pantalla 8: Revisión de reporte pendiente por parte de la municipalidad.
///
/// Permite aprobar el reporte (pasándolo a 'En revisión' para que sea visible
/// en el mapa ciudadano) o rechazarlo mediante diálogo de confirmación.
class RevisionReporteScreen extends StatelessWidget {
  final Reporte reporte;

  const RevisionReporteScreen({
    super.key,
    required this.reporte,
  });

  void _confirmarRechazo(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Rechazar este reporte?'),
        content: const Text(
          'El reporte pasará a la lista de Rechazados y NO se mostrará en el mapa público de los ciudadanos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<ReportesProvider>().rechazarReporte(reporte.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reporte rechazado correctamente'),
                    backgroundColor: AppColors.estadoRechazado,
                  ),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }

  Future<void> _aprobarReporte(BuildContext context) async {
    await context.read<ReportesProvider>().aprobarReporte(reporte.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Reporte aprobado! Ahora es visible en el mapa ciudadano.'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tieneFotoLocal = reporte.fotoPath != null &&
        reporte.fotoPath!.isNotEmpty &&
        File(reporte.fotoPath!).existsSync();

    final formatoFecha = DateFormat("d 'de' MMMM 'de' yyyy, HH:mm", 'es');
    final fechaTexto = formatoFecha.format(reporte.fechaCreacion);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Revisión de reporte'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Volver',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Foto grande o placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            child: Container(
              width: double.infinity,
              height: 220,
              color: AppColors.primaryLight,
              child: tieneFotoLocal
                  ? Image.file(
                      File(reporte.fotoPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
          const SizedBox(height: 18),

          // Categoría y Chip de Estado
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  reporte.categoria.icono,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categoría del incidente',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      reporte.categoria.etiqueta,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              EstadoChip(estado: reporte.estado),
            ],
          ),
          const SizedBox(height: 18),

          // Descripción completa
          const Text(
            'Descripción del ciudadano',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Text(
              reporte.descripcion,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Datos de fecha y ubicación
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fechaTexto,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  reporte.direccionAprox,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Mini mapa de ubicación
          const Text(
            'Ubicación en el mapa',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(reporte.latitud, reporte.longitud),
                  initialZoom: 16.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: AppConstants.userAgentPackageName,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(reporte.latitud, reporte.longitud),
                        width: 36,
                        height: 36,
                        child: const Icon(
                          Icons.location_pin,
                          size: 36,
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Botones de acción: Rechazar y Aprobar
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Rechazar',
                  icon: Icons.close_rounded,
                  textColor: AppColors.danger,
                  borderColor: AppColors.danger,
                  onPressed: () => _confirmarRechazo(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Aprobar',
                  icon: Icons.check_rounded,
                  backgroundColor: AppColors.success,
                  onPressed: () => _aprobarReporte(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            reporte.categoria.icono,
            size: 56,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 8),
          const Text(
            'Foto simulada del reporte',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
