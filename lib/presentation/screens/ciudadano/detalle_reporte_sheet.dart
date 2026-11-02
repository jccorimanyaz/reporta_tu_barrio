import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/reporte.dart';
import '../../widgets/estado_chip.dart';

/// Modal Bottom Sheet de solo lectura para visualizar el detalle de un reporte.
class DetalleReporteSheet extends StatelessWidget {
  final Reporte reporte;

  const DetalleReporteSheet({
    super.key,
    required this.reporte,
  });

  static Future<void> show(BuildContext context, Reporte reporte) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DetalleReporteSheet(reporte: reporte),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tieneFotoLocal = reporte.fotoPath != null &&
        reporte.fotoPath!.isNotEmpty &&
        File(reporte.fotoPath!).existsSync();

    final formatoFecha = DateFormat("d 'de' MMMM 'de' yyyy", 'es');
    final fechaTexto = formatoFecha.format(reporte.fechaCreacion);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.40,
      maxChildSize: 0.90,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de arrastre superior
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Imagen del reporte o Placeholder con ícono de categoría
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                child: Container(
                  width: double.infinity,
                  height: 190,
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
              const SizedBox(height: 16),

              // Fila de Categoría y Chip de Estado
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          'Categoría',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          reporte.categoria.etiqueta,
                          style: const TextStyle(
                            fontSize: 16,
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
              const SizedBox(height: 16),

              // Descripción
              Text(
                reporte.descripcion,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              const Divider(),
              const SizedBox(height: 14),

              // Ubicación aproximada
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ubicación aproximada',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          reporte.direccionAprox,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Fecha del reporte
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fecha del reporte',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fechaTexto,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            reporte.categoria.icono,
            size: 54,
            color: AppColors.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 8),
          Text(
            'Sin foto adjunta (Simulación)',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primaryDark.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
