import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/estado_reporte.dart';
import '../../../data/models/reporte.dart';
import '../../../providers/reportes_provider.dart';
import '../../widgets/estado_chip.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

/// Pantalla 9: Gestión de reporte aprobado.
///
/// Permite cambiar su estado entre 'En revisión', 'En atención' y 'Resuelto',
/// y eliminarlo únicamente si su estado es 'Resuelto'.
class GestionReporteScreen extends StatefulWidget {
  final Reporte reporte;

  const GestionReporteScreen({
    super.key,
    required this.reporte,
  });

  @override
  State<GestionReporteScreen> createState() => _GestionReporteScreenState();
}

class _GestionReporteScreenState extends State<GestionReporteScreen> {
  late EstadoReporte _estadoSeleccionado;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _estadoSeleccionado = widget.reporte.estado;
  }

  bool get _puedeEliminar => _estadoSeleccionado == EstadoReporte.resuelto;

  Future<void> _guardarCambios() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await context
          .read<ReportesProvider>()
          .actualizarEstado(widget.reporte.id, _estadoSeleccionado);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Estado actualizado a: ${_estadoSeleccionado.etiqueta}',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _confirmarEliminacion() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Eliminar reporte resuelto?'),
        content: const Text(
          'Esta acción borrará el reporte definitivamente de la base de datos municipal y ya no aparecerá en el mapa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context
                  .read<ReportesProvider>()
                  .eliminarReporte(widget.reporte.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reporte eliminado con éxito.'),
                    backgroundColor: AppColors.textPrimary,
                  ),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar definitivamente'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tieneFotoLocal = widget.reporte.fotoPath != null &&
        widget.reporte.fotoPath!.isNotEmpty &&
        File(widget.reporte.fotoPath!).existsSync();

    final formatoFecha = DateFormat("d 'de' MMMM 'de' yyyy, HH:mm", 'es');
    final fechaTexto = formatoFecha.format(widget.reporte.fechaCreacion);

    final estadosPermitidos = [
      EstadoReporte.enRevision,
      EstadoReporte.enAtencion,
      EstadoReporte.resuelto,
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Gestión de reporte'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Volver',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Foto o placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            child: Container(
              width: double.infinity,
              height: 190,
              color: AppColors.primaryLight,
              child: tieneFotoLocal
                  ? Image.file(
                      File(widget.reporte.fotoPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
          const SizedBox(height: 16),

          // Categoría y Chip de Estado actual
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.reporte.categoria.icono,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.reporte.categoria.etiqueta,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              EstadoChip(estado: widget.reporte.estado),
            ],
          ),
          const SizedBox(height: 14),

          // Descripción
          Text(
            widget.reporte.descripcion,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Ubicación y Fecha
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.reporte.direccionAprox,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
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
          const SizedBox(height: 20),

          // Mini mapa
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter:
                      LatLng(widget.reporte.latitud, widget.reporte.longitud),
                  initialZoom: 16.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: AppConstants.userAgentPackageName,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          widget.reporte.latitud,
                          widget.reporte.longitud,
                        ),
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.location_pin,
                          size: 36,
                          color: _estadoSeleccionado.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Selector de estado
          const Text(
            'Actualizar estado del reporte',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),

          // Opciones de estado con contenedor accesible e interactivo
          Column(
            children: estadosPermitidos.map((estado) {
              final isSelected = _estadoSeleccionado == estado;
              return Semantics(
                button: true,
                selected: isSelected,
                label: 'Seleccionar estado ${estado.etiqueta}',
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? estado.colorFondo : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    border: Border.all(
                      color: isSelected ? estado.color : AppColors.cardBorder,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    onTap: () {
                      setState(() {
                        _estadoSeleccionado = estado;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? estado.color
                                    : AppColors.cardBorder,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: estado.color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: estado.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            estado.etiqueta,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Botón Guardar cambios
          PrimaryButton(
            text: 'Guardar cambios',
            icon: Icons.save_outlined,
            isLoading: _isSaving,
            onPressed: _guardarCambios,
          ),
          const SizedBox(height: 20),

          const Divider(),
          const SizedBox(height: 16),

          // Botón Eliminar reporte (condicional)
          SecondaryButton(
            text: 'Eliminar reporte',
            icon: Icons.delete_outline_rounded,
            textColor: _puedeEliminar ? AppColors.danger : AppColors.textMuted,
            borderColor:
                _puedeEliminar ? AppColors.danger : AppColors.cardBorder,
            onPressed: _puedeEliminar ? _confirmarEliminacion : null,
          ),
          const SizedBox(height: 6),

          // Mensaje de ayuda explicativo sobre la regla de eliminación
          Center(
            child: Text(
              _puedeEliminar
                  ? 'El reporte está resuelto y puede ser eliminado del sistema.'
                  : 'Solo se pueden eliminar reportes cuyo estado sea "Resuelto".',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: _puedeEliminar
                    ? AppColors.textSecondary
                    : AppColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
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
            widget.reporte.categoria.icono,
            size: 54,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sin foto adjunta (Simulación)',
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
