import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/estado_reporte.dart';
import '../../../data/models/reporte.dart';
import '../../../providers/reportes_provider.dart';
import '../../widgets/estado_legend.dart';
import 'detalle_reporte_sheet.dart';

/// Pantalla 2: Mapa interactivo ciudadano con reportes aprobados.
class MapaCiudadanoScreen extends StatefulWidget {
  const MapaCiudadanoScreen({super.key});

  @override
  State<MapaCiudadanoScreen> createState() => _MapaCiudadanoScreenState();
}

class _MapaCiudadanoScreenState extends State<MapaCiudadanoScreen> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportesProvider = context.watch<ReportesProvider>();
    final reportes = reportesProvider.reportesCiudadano;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reportes del barrio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Volver',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _buildFilterChips(reportesProvider),
        ),
      ),
      body: Stack(
        children: [
          // Mapa interactivo con FlutterMap y OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: AppConstants.centroInicialMapa,
              initialZoom: AppConstants.zoomInicialMapa,
              minZoom: AppConstants.minZoomMapa,
              maxZoom: AppConstants.maxZoomMapa,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: AppConstants.userAgentPackageName,
              ),
              MarkerLayer(
                markers: reportes.map((r) => _buildMarker(r)).toList(),
              ),
            ],
          ),

          // Leyenda de estados en la esquina inferior izquierda
          const Positioned(
            left: 16,
            bottom: 24,
            child: EstadoLegend(),
          ),

          // Botón flotante "+ Reportar" en la esquina inferior derecha
          Positioned(
            right: 16,
            bottom: 24,
            child: Semantics(
              button: true,
              label: 'Reportar nuevo problema',
              child: FloatingActionButton.extended(
                heroTag: 'fab_nuevo_reporte',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.nuevoReporte);
                },
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 3,
                icon: const Icon(Icons.add, size: 22),
                label: const Text(
                  'Reportar',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              ),
            ),
          ),

          // Indicador si está cargando
          if (reportesProvider.isLoading)
            const Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text('Actualizando mapa...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Barra horizontal de chips de filtrado
  Widget _buildFilterChips(ReportesProvider provider) {
    final filtroActual = provider.filtroEstadoCiudadano;

    final opciones = [
      {'label': 'Todos', 'estado': null},
      {'label': 'En revisión', 'estado': EstadoReporte.enRevision},
      {'label': 'En atención', 'estado': EstadoReporte.enAtencion},
      {'label': 'Resuelto', 'estado': EstadoReporte.resuelto},
    ];

    return Container(
      height: 56,
      color: AppColors.surface,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: opciones.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = opciones[index];
          final EstadoReporte? estado = item['estado'] as EstadoReporte?;
          final isSelected = filtroActual == estado;

          return ChoiceChip(
            label: Text(item['label'] as String),
            selected: isSelected,
            onSelected: (_) => provider.setFiltroEstadoCiudadano(estado),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.cardBorder,
              ),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  /// Construye el marcador visual para el reporte en el mapa
  Marker _buildMarker(Reporte reporte) {
    return Marker(
      point: LatLng(reporte.latitud, reporte.longitud),
      width: 44,
      height: 44,
      child: GestureDetector(
        onTap: () => DetalleReporteSheet.show(context, reporte),
        child: Semantics(
          button: true,
          label:
              'Marcador de ${reporte.categoria.etiqueta}, estado ${reporte.estado.etiqueta}',
          child: _PinMarcador(estado: reporte.estado),
        ),
      ),
    );
  }
}

/// Pin de marcador estilizado con color de estado y punto interior.
class _PinMarcador extends StatelessWidget {
  final EstadoReporte estado;

  const _PinMarcador({required this.estado});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Sombra exterior
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: estado.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
