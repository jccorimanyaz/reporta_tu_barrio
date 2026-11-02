import 'package:flutter/material.dart';

/// Categorías oficiales de incidentes ciudadanos.
enum CategoriaReporte {
  bache,
  basura,
  alumbrado,
  fugaAgua,
  otros;

  String get etiqueta {
    switch (this) {
      case CategoriaReporte.bache:
        return 'Bache';
      case CategoriaReporte.basura:
        return 'Basura acumulada';
      case CategoriaReporte.alumbrado:
        return 'Alumbrado dañado';
      case CategoriaReporte.fugaAgua:
        return 'Fuga de agua';
      case CategoriaReporte.otros:
        return 'Otros';
    }
  }

  /// Etiqueta corta para chips pequeños
  String get etiquetaCorta {
    switch (this) {
      case CategoriaReporte.bache:
        return 'Bache';
      case CategoriaReporte.basura:
        return 'Basura';
      case CategoriaReporte.alumbrado:
        return 'Alumbrado';
      case CategoriaReporte.fugaAgua:
        return 'Fuga de agua';
      case CategoriaReporte.otros:
        return 'Otros';
    }
  }

  IconData get icono {
    switch (this) {
      case CategoriaReporte.bache:
        return Icons.car_repair_rounded;
      case CategoriaReporte.basura:
        return Icons.delete_outline_rounded;
      case CategoriaReporte.alumbrado:
        return Icons.lightbulb_outline_rounded;
      case CategoriaReporte.fugaAgua:
        return Icons.water_drop_outlined;
      case CategoriaReporte.otros:
        return Icons.more_horiz_rounded;
    }
  }

  static CategoriaReporte fromString(String valor) {
    return CategoriaReporte.values.firstWhere(
      (c) => c.name.toLowerCase() == valor.toLowerCase(),
      orElse: () => CategoriaReporte.otros,
    );
  }
}

