import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/categoria_reporte.dart';
import '../../../data/models/estado_reporte.dart';
import '../../../data/models/reporte.dart';
import '../../../providers/conectividad_provider.dart';
import '../../../providers/reportes_provider.dart';
import '../../widgets/categoria_chip.dart';
import '../../widgets/primary_button.dart';

/// Pantalla 4: Formulario para crear un nuevo reporte ciudadano.
class NuevoReporteScreen extends StatefulWidget {
  const NuevoReporteScreen({super.key});

  @override
  State<NuevoReporteScreen> createState() => _NuevoReporteScreenState();
}

class _NuevoReporteScreenState extends State<NuevoReporteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _imagePicker = ImagePicker();
  final MapController _miniMapController = MapController();

  CategoriaReporte _categoriaSeleccionada = CategoriaReporte.bache;
  XFile? _fotoSeleccionada;
  LatLng _ubicacionSeleccionada = AppConstants.centroInicialMapa;
  String _direccionAprox = 'Cerca de Plaza Principal';

  // Control de errores de validación
  bool _mostrarErrorFoto = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descripcionController.dispose();
    _miniMapController.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto(ImageSource origen) async {
    try {
      final XFile? foto = await _imagePicker.pickImage(
        source: origen,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (foto != null) {
        setState(() {
          _fotoSeleccionada = foto;
          _mostrarErrorFoto = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo obtener la imagen: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  void _usarUbicacionActual() {
    // Coordenada simulada cerca del centro del barrio para la prueba piloto
    final latSimulada = AppConstants.centroInicialMapa.latitude + 0.0008;
    final lngSimulada = AppConstants.centroInicialMapa.longitude - 0.0006;
    final nuevaUbicacion = LatLng(latSimulada, lngSimulada);

    setState(() {
      _ubicacionSeleccionada = nuevaUbicacion;
      _direccionAprox = 'Av. Principal y Calle Las Flores (Actual)';
    });

    _miniMapController.move(nuevaUbicacion, 16.0);
  }

  Future<void> _enviarReporte() async {
    final formValido = _formKey.currentState?.validate() ?? false;
    final fotoValida = _fotoSeleccionada != null;

    if (!fotoValida) {
      setState(() {
        _mostrarErrorFoto = true;
      });
    }

    if (!formValido || !fotoValida) {
      return;
    }

    final hayConexion =
        context.read<ConectividadProvider>().hayConexion;
    final reportesProvider = context.read<ReportesProvider>();

    setState(() {
      _isSubmitting = true;
    });

    final nuevoReporte = Reporte(
      id: 'rep-${DateTime.now().millisecondsSinceEpoch}',
      categoria: _categoriaSeleccionada,
      descripcion: _descripcionController.text.trim(),
      fotoPath: _fotoSeleccionada?.path,
      latitud: _ubicacionSeleccionada.latitude,
      longitud: _ubicacionSeleccionada.longitude,
      direccionAprox: _direccionAprox,
      estado: EstadoReporte.pendiente, // Regla: Nace como "pendiente"
      fechaCreacion: DateTime.now(),
    );

    try {
      await reportesProvider.agregarReporte(nuevoReporte);

      if (mounted) {
        // Redirige a la pantalla de confirmación (Variante A u Online / Variante B u Offline)
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.confirmacion,
          arguments: hayConexion,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar el reporte: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Nuevo reporte'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Volver',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 1. ¿Qué problema encontraste?
            const Text(
              '1. ¿Qué problema encontraste?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: CategoriaReporte.values.map((cat) {
                final isSelected = _categoriaSeleccionada == cat;
                return CategoriaChip(
                  categoria: cat,
                  isSelected: isSelected,
                  useShortLabel: true,
                  onSelected: (_) {
                    setState(() {
                      _categoriaSeleccionada = cat;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 2. Describe el problema
            const Text(
              '2. Describe el problema',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descripcionController,
              maxLines: 4,
              maxLength: AppConstants.maxDescripcionChars,
              decoration: const InputDecoration(
                hintText:
                    'Ejemplo: Hay un bache profundo junto al cruce peatonal.',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es obligatoria';
                }
                if (value.trim().length < 8) {
                  return 'Describe con un poco más de detalle (mínimo 8 caracteres)';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // 3. Agrega una foto
            const Text(
              '3. Agrega una foto',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Ayúdanos a identificar mejor el problema.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Cuadro de vista previa de foto
            _buildFotoBox(),

            if (_mostrarErrorFoto) ...[
              const SizedBox(height: 6),
              Row(
                children: const [
                  Icon(Icons.error_outline, size: 16, color: AppColors.danger),
                  SizedBox(width: 6),
                  Text(
                    'La foto es obligatoria',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _tomarFoto(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text('Tomar foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _tomarFoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Elegir de galería'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 4. Ubicación del problema
            const Text(
              '4. Ubicación en el mapa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Toca en el mapa para ajustar la posición exacta.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),

            // Mini mapa interactivo
            _buildMiniMapa(),

            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _direccionAprox,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _usarUbicacionActual,
                  icon: const Icon(Icons.my_location, size: 16),
                  label: const Text(
                    'Mi ubicación',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Botón de Enviar
            PrimaryButton(
              text: 'Enviar reporte',
              isLoading: _isSubmitting,
              onPressed: _enviarReporte,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFotoBox() {
    final tieneFoto = _fotoSeleccionada != null;

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(
          color: _mostrarErrorFoto ? AppColors.danger : AppColors.cardBorder,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: tieneFoto
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(_fotoSeleccionada!.path),
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.6),
                      radius: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 16, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _fotoSeleccionada = null;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: AppColors.textMuted,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'La vista previa aparecerá aquí',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMiniMapa() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: FlutterMap(
          mapController: _miniMapController,
          options: MapOptions(
            initialCenter: _ubicacionSeleccionada,
            initialZoom: 15.5,
            minZoom: 13.0,
            maxZoom: 18.0,
            onTap: (_, latLng) {
              setState(() {
                _ubicacionSeleccionada = latLng;
                _direccionAprox =
                    'Lat: ${latLng.latitude.toStringAsFixed(4)}, Lng: ${latLng.longitude.toStringAsFixed(4)}';
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: AppConstants.userAgentPackageName,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _ubicacionSeleccionada,
                  width: 36,
                  height: 36,
                  child: const Icon(
                    Icons.location_pin,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
