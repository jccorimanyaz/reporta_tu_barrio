import '../models/estado_reporte.dart';
import '../models/reporte.dart';

/// Contrato abstracto para el repositorio de reportes ciudadanos.
///
/// Las pantallas y providers dependen exclusivamente de esta abstracción.
/// En la Fase 2, una implementación con Cloud Firestore reemplazará la mock
/// sin modificar la capa de presentación.
abstract class ReporteRepository {
  /// Obtiene todos los reportes del sistema (para uso municipal).
  Future<List<Reporte>> obtenerTodos();

  /// Obtiene únicamente los reportes con estados aprobados visibles al ciudadano.
  Future<List<Reporte>> obtenerAprobados();

  /// Agrega un nuevo reporte (nace en estado pendiente).
  Future<void> agregarReporte(Reporte reporte);

  /// Actualiza el estado de un reporte existente.
  Future<void> actualizarEstado(String id, EstadoReporte nuevoEstado);

  /// Elimina un reporte del sistema (solo permitido si está resuelto).
  Future<void> eliminarReporte(String id);

  /// Stream reactivo de cambios para actualización en tiempo real.
  Stream<List<Reporte>> get reportesStream;
}

