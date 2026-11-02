import 'categoria_reporte.dart';
import 'estado_reporte.dart';

/// Modelo de dominio que representa un reporte ciudadano.
///
/// Diseñado con soporte de serialización para facilitar la migración
/// a Cloud Firestore en la Fase 2.
class Reporte {
  final String id;
  final CategoriaReporte categoria;
  final String descripcion;
  final String? fotoPath; // Ruta local en memoria o URL futura
  final double latitud;
  final double longitud;
  final String direccionAprox;
  final EstadoReporte estado;
  final DateTime fechaCreacion;

  const Reporte({
    required this.id,
    required this.categoria,
    required this.descripcion,
    this.fotoPath,
    required this.latitud,
    required this.longitud,
    required this.direccionAprox,
    required this.estado,
    required this.fechaCreacion,
  });

  Reporte copyWith({
    String? id,
    CategoriaReporte? categoria,
    String? descripcion,
    String? fotoPath,
    double? latitud,
    double? longitud,
    String? direccionAprox,
    EstadoReporte? estado,
    DateTime? fechaCreacion,
  }) {
    return Reporte(
      id: id ?? this.id,
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
      fotoPath: fotoPath ?? this.fotoPath,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      direccionAprox: direccionAprox ?? this.direccionAprox,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  // TODO(firebase): Mapeo directo para colecciones en Cloud Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoria': categoria.name,
      'descripcion': descripcion,
      'fotoPath': fotoPath,
      'latitud': latitud,
      'longitud': longitud,
      'direccionAprox': direccionAprox,
      'estado': estado.name,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  // TODO(firebase): Deserialización de DocumentSnapshot de Cloud Firestore
  factory Reporte.fromMap(Map<String, dynamic> map, [String? docId]) {
    return Reporte(
      id: docId ?? (map['id'] as String? ?? ''),
      categoria: CategoriaReporte.fromString(map['categoria'] as String? ?? ''),
      descripcion: map['descripcion'] as String? ?? '',
      fotoPath: map['fotoPath'] as String?,
      latitud: (map['latitud'] as num?)?.toDouble() ?? 0.0,
      longitud: (map['longitud'] as num?)?.toDouble() ?? 0.0,
      direccionAprox: map['direccionAprox'] as String? ?? '',
      estado: EstadoReporte.fromString(map['estado'] as String? ?? ''),
      fechaCreacion: map['fechaCreacion'] != null
          ? DateTime.tryParse(map['fechaCreacion'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reporte && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

