import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/categoria_reporte.dart';

/// Chip para seleccionar o filtrar categorías con ícono descriptivo.
class CategoriaChip extends StatelessWidget {
  final CategoriaReporte categoria;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final bool useShortLabel;

  const CategoriaChip({
    super.key,
    required this.categoria,
    this.isSelected = false,
    this.onSelected,
    this.useShortLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = useShortLabel ? categoria.etiquetaCorta : categoria.etiqueta;

    return Semantics(
      selected: isSelected,
      button: onSelected != null,
      label: 'Categoría $label',
      child: FilterChip(
        selected: isSelected,
        onSelected: onSelected,
        avatar: Icon(
          categoria.icono,
          size: 18,
          color: isSelected ? AppColors.onPrimary : AppColors.primary,
        ),
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
        ),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        checkmarkColor: AppColors.onPrimary,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

