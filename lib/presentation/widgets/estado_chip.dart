import 'package:flutter/material.dart';
import '../../data/models/estado_reporte.dart';

/// Chip indicador del estado del reporte con punto de color y etiqueta.
class EstadoChip extends StatelessWidget {
  final EstadoReporte estado;
  final bool compact;

  const EstadoChip({
    super.key,
    required this.estado,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Estado: ${estado.etiqueta}',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 10,
          vertical: compact ? 3 : 5,
        ),
        decoration: BoxDecoration(
          color: estado.colorFondo,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 6 : 8,
              height: compact ? 6 : 8,
              decoration: BoxDecoration(
                color: estado.color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: compact ? 5 : 7),
            Text(
              estado.etiqueta,
              style: TextStyle(
                color: estado.color,
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

