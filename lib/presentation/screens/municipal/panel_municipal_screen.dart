import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/categoria_reporte.dart';
import '../../../data/models/reporte.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/reportes_provider.dart';
import '../../widgets/categoria_chip.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/reporte_card.dart';
import '../ciudadano/detalle_reporte_sheet.dart';

/// Pantalla 7: Panel principal de gestión municipal con pestañas y filtros.
class PanelMunicipalScreen extends StatefulWidget {
  const PanelMunicipalScreen({super.key});

  @override
  State<PanelMunicipalScreen> createState() => _PanelMunicipalScreenState();
}

class _PanelMunicipalScreenState extends State<PanelMunicipalScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _confirmarCerrarSesion() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text(
          '¿Estás seguro de que deseas salir del panel municipal?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<AuthProvider>().logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.inicio);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportesProvider = context.watch<ReportesProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Panel Municipal'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar sesión',
            onPressed: _confirmarCerrarSesion,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              tabs: [
                _buildTab('Pendientes', reportesProvider.conteoPendientes),
                _buildTab('Aprobados', reportesProvider.conteoAprobados),
                _buildTab('Rechazados', reportesProvider.conteoRechazados),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filtro horizontal por categoría
          _buildCategoryFilter(reportesProvider),

          // Contenido de las pestañas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pestaña 1: Pendientes
                _buildListTab(
                  reportes: reportesProvider.reportesPendientes,
                  emptyTitle: 'No hay reportes pendientes',
                  emptySubtitle:
                      'Los nuevos reportes de los vecinos aparecerán aquí.',
                  onItemTap: (reporte) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.revisarReporte,
                      arguments: reporte,
                    );
                  },
                ),

                // Pestaña 2: Aprobados
                _buildListTab(
                  reportes: reportesProvider.reportesAprobados,
                  emptyTitle: 'No hay reportes aprobados',
                  emptySubtitle:
                      'Los reportes que apruebes para el mapa aparecerán aquí.',
                  onItemTap: (reporte) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.gestionarReporte,
                      arguments: reporte,
                    );
                  },
                ),

                // Pestaña 3: Rechazados
                _buildListTab(
                  reportes: reportesProvider.reportesRechazados,
                  emptyTitle: 'No hay reportes rechazados',
                  emptySubtitle:
                      'Los reportes desestimados se archivan en esta sección.',
                  onItemTap: (reporte) {
                    DetalleReporteSheet.show(context, reporte);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Tab _buildTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(ReportesProvider provider) {
    final catActual = provider.filtroCategoriaMuni;

    return Container(
      height: 52,
      color: AppColors.surface,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          ChoiceChip(
            label: const Text('Todas'),
            selected: catActual == null,
            onSelected: (_) => provider.setFiltroCategoriaMuni(null),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: catActual == null ? FontWeight.bold : FontWeight.w500,
              color: catActual == null ? AppColors.onPrimary : AppColors.textPrimary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: catActual == null ? AppColors.primary : AppColors.cardBorder,
              ),
            ),
            showCheckmark: false,
          ),
          const SizedBox(width: 8),
          ...CategoriaReporte.values.map((cat) {
            final isSelected = catActual == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CategoriaChip(
                categoria: cat,
                isSelected: isSelected,
                useShortLabel: true,
                onSelected: (_) {
                  provider.setFiltroCategoriaMuni(isSelected ? null : cat);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildListTab({
    required List<Reporte> reportes,
    required String emptyTitle,
    required String emptySubtitle,
    required ValueChanged<Reporte> onItemTap,
  }) {
    if (reportes.isEmpty) {
      return EmptyStateView(
        title: emptyTitle,
        subtitle: emptySubtitle,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reportes.length,
      itemBuilder: (context, index) {
        final reporte = reportes[index];
        return ReporteCard(
          reporte: reporte,
          onTap: () => onItemTap(reporte),
        );
      },
    );
  }
}

