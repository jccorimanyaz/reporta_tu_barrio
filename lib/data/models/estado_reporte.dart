import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Estados posibles de un reporte en el sistema.
enum EstadoReporte {
  pendiente,
  enRevision,
  enAtencion,
  resuelto,
  rechazado;

  String get etiqueta {
    switch (this) {
      case EstadoReporte.pendiente:
        return 'Pendiente';
      case EstadoReporte.enRevision:
        return 'En revisión';
      case EstadoReporte.enAtencion:
        return 'En atención';
      case EstadoReporte.resuelto:
        return 'Resuelto';
      case EstadoReporte.rechazado:
        return 'Rechazado';
    }
  }

  Color get color {
    switch (this) {
      case EstadoReporte.pendiente:
        return AppColors.estadoPendiente;
      case EstadoReporte.enRevision:
        return AppColors.estadoEnRevision;
      case EstadoReporte.enAtencion:
        return AppColors.estadoEnAtencion;
      case EstadoReporte.resuelto:
        return AppColors.estadoResuelto;
      case EstadoReporte.rechazado:
        return AppColors.estadoRechazado;
    }
  }

  Color get colorFondo {
    switch (this) {
      case EstadoReporte.pendiente:
        return AppColors.estadoPendienteBg;
      case EstadoReporte.enRevision:
        return AppColors.estadoEnRevisionBg;
      case EstadoReporte.enAtencion:
        return AppColors.estadoEnAtencionBg;
      case EstadoReporte.resuelto:
        return AppColors.estadoResueltoBg;
      case EstadoReporte.rechazado:
        return AppColors.estadoRechazadoBg;
    }
  }

  /// Indica si este estado es visible en el mapa ciudadano.
  /// Regla: Solo 'En revisión', 'En atención' y 'Resuelto' son visibles.
  bool get esVisibleCiudadano {
    return this == EstadoReporte.enRevision ||
        this == EstadoReporte.enAtencion ||
        this == EstadoReporte.resuelto;
  }

  static EstadoReporte fromString(String valor) {
    return EstadoReporte.values.firstWhere(
      (e) => e.name.toLowerCase() == valor.toLowerCase(),
      orElse: () => EstadoReporte.pendiente,
    );
  }
}

