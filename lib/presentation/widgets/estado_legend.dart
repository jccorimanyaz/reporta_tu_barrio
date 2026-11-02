import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/estado_reporte.dart';

/// Leyenda flotante de estados para el mapa ciudadano.
class EstadoLegend extends StatelessWidget {
  const EstadoLegend({super.key});

  @override
  Widget build(BuildContext context) {
    // Solo los estados visibles al ciudadano
    final estadosVisibles = [
      EstadoReporte.enRevision,
      EstadoReporte.enAtencion,
      EstadoReporte.resuelto,
    ];

    return Semantics(
      label: 'Leyenda de estados del mapa',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ESTADOS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            ...estadosVisibles.map(
              (estado) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: estado.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      estado.etiqueta,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
