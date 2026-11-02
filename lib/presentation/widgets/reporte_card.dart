import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/reporte.dart';
import 'estado_chip.dart';

/// Tarjeta de reporte para los listados del panel municipal.
class ReporteCard extends StatelessWidget {
  final Reporte reporte;
  final VoidCallback onTap;

  const ReporteCard({
    super.key,
    required this.reporte,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatoFecha = DateFormat("d 'de' MMMM 'de' yyyy", 'es');
    final fechaTexto = formatoFecha.format(reporte.fechaCreacion);

    final tieneFotoLocal = reporte.fotoPath != null &&
        reporte.fotoPath!.isNotEmpty &&
        File(reporte.fotoPath!).existsSync();

    return Semantics(
      button: true,
      label:
          'Reporte de ${reporte.categoria.etiqueta}, estado: ${reporte.estado.etiqueta}',
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Miniatura o Placeholder con ícono de categoría
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 64,
                    height: 64,
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
                const SizedBox(width: 12),

                // Contenido textual
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              reporte.categoria.etiqueta,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          EstadoChip(estado: reporte.estado, compact: true),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reporte.descripcion,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              fechaTexto,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        reporte.categoria.icono,
        size: 30,
        color: AppColors.primary,
      ),
    );
  }
}
