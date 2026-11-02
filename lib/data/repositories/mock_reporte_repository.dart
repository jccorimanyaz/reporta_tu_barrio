import 'dart:async';

import '../../core/constants/app_constants.dart';
import '../models/categoria_reporte.dart';
import '../models/estado_reporte.dart';
import '../models/reporte.dart';
import 'reporte_repository.dart';

/// Implementación en memoria del repositorio de reportes con datos semilla.
///
/// TODO(firebase): Reemplazar esta implementación por FirestoreReporteRepository
/// utilizando FirebaseFirestore.instance.collection('reportes').
class MockReporteRepository implements ReporteRepository {
  final List<Reporte> _reportes = [];
  final StreamController<List<Reporte>> _streamController =
      StreamController<List<Reporte>>.broadcast();

  MockReporteRepository() {
    _inicializarDatosSemilla();
  }

  void _inicializarDatosSemilla() {
    final centro = AppConstants.centroInicialMapa;
    final now = DateTime.now();

    _reportes.addAll([
      // 1. Aprobado - En revisión
      Reporte(
        id: 'rep-001',
        categoria: CategoriaReporte.bache,
        descripcion:
            'Bache profundo junto al cruce peatonal; dificulta el paso de vehículos y ciclistas.',
        latitud: centro.latitude + 0.0021,
        longitud: centro.longitude - 0.0018,
        direccionAprox: 'Av. Reforma y Calle Central',
        estado: EstadoReporte.enRevision,
        fechaCreacion: now.subtract(const Duration(days: 3)),
      ),

      // 2. Aprobado - En atención
      Reporte(
        id: 'rep-002',
        categoria: CategoriaReporte.basura,
        descripcion:
            'Acumulación excesiva de bolsas plásticas y escombros cerca del contenedor vecinal.',
        latitud: centro.latitude + 0.0035,
        longitud: centro.longitude + 0.0015,
        direccionAprox: 'Paseo del Parque N° 340',
        estado: EstadoReporte.enAtencion,
        fechaCreacion: now.subtract(const Duration(days: 5)),
      ),

      // 3. Aprobado - Resuelto
      Reporte(
        id: 'rep-003',
        categoria: CategoriaReporte.alumbrado,
        descripcion:
            'Farola con foco parpadeante e intermitente en la esquina de la plaza vecinal.',
        latitud: centro.latitude - 0.0019,
        longitud: centro.longitude + 0.0032,
        direccionAprox: 'Calle Los Álamos con San Martín',
        estado: EstadoReporte.resuelto,
        fechaCreacion: now.subtract(const Duration(days: 8)),
      ),

      // 4. Aprobado - En atención
      Reporte(
        id: 'rep-004',
        categoria: CategoriaReporte.fugaAgua,
        descripcion:
            'Tubería de matriz rota que expulsa agua limpia inundando la acera desde temprano.',
        latitud: centro.latitude - 0.0028,
        longitud: centro.longitude - 0.0012,
        direccionAprox: 'Jr. Bolognesi N° 120',
        estado: EstadoReporte.enAtencion,
        fechaCreacion: now.subtract(const Duration(days: 1)),
      ),

      // 5. Aprobado - En revisión
      Reporte(
        id: 'rep-005',
        categoria: CategoriaReporte.otros,
        descripcion:
            'Rejilla de drenaje pluvial desnivelada que genera ruidos fuertes y riesgo de caída.',
        latitud: centro.latitude + 0.0012,
        longitud: centro.longitude + 0.0024,
        direccionAprox: 'Av. Independencia cuadra 4',
        estado: EstadoReporte.enRevision,
        fechaCreacion: now.subtract(const Duration(hours: 18)),
      ),

      // 6. Aprobado - Resuelto
      Reporte(
        id: 'rep-006',
        categoria: CategoriaReporte.bache,
        descripcion:
            'Hundimiento del asfalto frente a la entrada del colegio primario del barrio.',
        latitud: centro.latitude - 0.0032,
        longitud: centro.longitude + 0.0018,
        direccionAprox: 'Calle Melgar N° 550',
        estado: EstadoReporte.resuelto,
        fechaCreacion: now.subtract(const Duration(days: 12)),
      ),

      // 7. Pendiente (NO debe verse en mapa ciudadano)
      Reporte(
        id: 'rep-007',
        categoria: CategoriaReporte.alumbrado,
        descripcion:
            'Dos postes de luz apagados por completo; la cuadra queda a oscuras al anochecer.',
        latitud: centro.latitude + 0.0041,
        longitud: centro.longitude - 0.0029,
        direccionAprox: 'Calle Santa Marta N° 210',
        estado: EstadoReporte.pendiente,
        fechaCreacion: now.subtract(const Duration(hours: 4)),
      ),

      // 8. Pendiente (NO debe verse en mapa ciudadano)
      Reporte(
        id: 'rep-008',
        categoria: CategoriaReporte.basura,
        descripcion:
            'Restos de poda y ramas secas arrojadas en la berma central obstaculizando la vista.',
        latitud: centro.latitude - 0.0015,
        longitud: centro.longitude - 0.0035,
        direccionAprox: 'Av. Dolores con Los Pinos',
        estado: EstadoReporte.pendiente,
        fechaCreacion: now.subtract(const Duration(hours: 2)),
      ),

      // 9. Rechazado (NO debe verse en mapa ciudadano)
      Reporte(
        id: 'rep-009',
        categoria: CategoriaReporte.otros,
        descripcion:
            'Propiedad privada con fachada descuidada (no corresponde a espacio público municipal).',
        latitud: centro.latitude + 0.0018,
        longitud: centro.longitude - 0.0042,
        direccionAprox: 'Calle Jerusalén N° 890',
        estado: EstadoReporte.rechazado,
        fechaCreacion: now.subtract(const Duration(days: 6)),
      ),
    ]);

    _streamController.add(List.unmodifiable(_reportes));
  }

  @override
  Stream<List<Reporte>> get reportesStream => _streamController.stream;

  @override
  Future<List<Reporte>> obtenerTodos() async {
    // Simula una breve latencia asíncrona
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_reportes);
  }

  @override
  Future<List<Reporte>> obtenerAprobados() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(
      _reportes.where((r) => r.estado.esVisibleCiudadano).toList(),
    );
  }

  @override
  Future<void> agregarReporte(Reporte reporte) async {
    // Regla: Todo reporte nuevo nace con estado "pendiente"
    final reportePendiente = reporte.copyWith(estado: EstadoReporte.pendiente);
    _reportes.insert(0, reportePendiente);
    _streamController.add(List.unmodifiable(_reportes));
  }

  @override
  Future<void> actualizarEstado(String id, EstadoReporte nuevoEstado) async {
    final index = _reportes.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reportes[index] = _reportes[index].copyWith(estado: nuevoEstado);
      _streamController.add(List.unmodifiable(_reportes));
    }
  }

  @override
  Future<void> eliminarReporte(String id) async {
    final index = _reportes.indexWhere((r) => r.id == id);
    if (index != -1) {
      // Regla: Solo se puede eliminar un reporte en estado resuelto
      if (_reportes[index].estado == EstadoReporte.resuelto) {
        _reportes.removeAt(index);
        _streamController.add(List.unmodifiable(_reportes));
      } else {
        throw StateError('Solo se pueden eliminar reportes con estado Resuelto');
      }
    }
  }

  void dispose() {
    _streamController.close();
  }
}

