import 'dart:async';
import 'package:flutter/material.dart';

import '../data/models/categoria_reporte.dart';
import '../data/models/estado_reporte.dart';
import '../data/models/reporte.dart';
import '../data/repositories/reporte_repository.dart';

/// Provider encargado del estado de los reportes en la aplicación.
///
/// Cumple con la regla de depender exclusivamente de la interfaz abstracta
/// [ReporteRepository] para desacoplar las pantallas de la persistencia.
class ReportesProvider extends ChangeNotifier {
  final ReporteRepository _repository;
  StreamSubscription<List<Reporte>>? _subscription;

  List<Reporte> _todos = [];
  bool _isLoading = false;
  String? _error;

  // Filtros de mapa ciudadano
  EstadoReporte? _filtroEstadoCiudadano; // null = Todos

  // Filtros de panel municipal
  CategoriaReporte? _filtroCategoriaMuni; // null = Todas

  ReportesProvider(this._repository) {
    _iniciarEscucha();
    cargarReportes();
  }

  // Getters generales
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Reporte> get todos => _todos;

  // Filtros activos
  EstadoReporte? get filtroEstadoCiudadano => _filtroEstadoCiudadano;
  CategoriaReporte? get filtroCategoriaMuni => _filtroCategoriaMuni;

  // ===========================================================================
  // REPORTES PARA EL PANEL CIUDADANO
  // Regla: Solo estados aprobados (En revisión, En atención, Resuelto).
  // ===========================================================================
  List<Reporte> get reportesCiudadano {
    final aprobados = _todos.where((r) => r.estado.esVisibleCiudadano).toList();
    if (_filtroEstadoCiudadano == null) {
      return aprobados;
    }
    return aprobados.where((r) => r.estado == _filtroEstadoCiudadano).toList();
  }

  // ===========================================================================
  // REPORTES PARA EL PANEL MUNICIPAL
  // Divididos por pestañas con filtro opcional de categoría
  // ===========================================================================
  List<Reporte> get reportesPendientes {
    final list = _todos.where((r) => r.estado == EstadoReporte.pendiente);
    return _aplicarFiltroCategoria(list);
  }

  List<Reporte> get reportesAprobados {
    final list = _todos.where((r) => r.estado.esVisibleCiudadano);
    return _aplicarFiltroCategoria(list);
  }

  List<Reporte> get reportesRechazados {
    final list = _todos.where((r) => r.estado == EstadoReporte.rechazado);
    return _aplicarFiltroCategoria(list);
  }

  // Contadores para insignias en pestañas
  int get conteoPendientes =>
      _todos.where((r) => r.estado == EstadoReporte.pendiente).length;

  int get conteoAprobados =>
      _todos.where((r) => r.estado.esVisibleCiudadano).length;

  int get conteoRechazados =>
      _todos.where((r) => r.estado == EstadoReporte.rechazado).length;

  List<Reporte> _aplicarFiltroCategoria(Iterable<Reporte> iterable) {
    if (_filtroCategoriaMuni == null) {
      return iterable.toList();
    }
    return iterable.where((r) => r.categoria == _filtroCategoriaMuni).toList();
  }

  // ===========================================================================
  // MÉTODOS DE FILTRADO
  // ===========================================================================
  void setFiltroEstadoCiudadano(EstadoReporte? estado) {
    _filtroEstadoCiudadano = estado;
    notifyListeners();
  }

  void setFiltroCategoriaMuni(CategoriaReporte? categoria) {
    _filtroCategoriaMuni = categoria;
    notifyListeners();
  }

  // ===========================================================================
  // OPERACIONES CRUD REACTIVAS
  // ===========================================================================
  void _iniciarEscucha() {
    _subscription = _repository.reportesStream.listen((nuevosReportes) {
      _todos = nuevosReportes;
      notifyListeners();
    });
  }

  Future<void> cargarReportes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todos = await _repository.obtenerTodos();
    } catch (e) {
      _error = 'Error al cargar reportes: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crea un nuevo reporte ciudadano en estado 'pendiente'
  Future<void> agregarReporte(Reporte reporte) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.agregarReporte(reporte);
    } catch (e) {
      _error = 'Error al crear reporte: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Aprueba un reporte: Pasa a 'En revisión' y se hace visible en el mapa.
  Future<void> aprobarReporte(String id) async {
    await actualizarEstado(id, EstadoReporte.enRevision);
  }

  /// Rechaza un reporte: Pasa a 'Rechazado' y permanece oculto al ciudadano.
  Future<void> rechazarReporte(String id) async {
    await actualizarEstado(id, EstadoReporte.rechazado);
  }

  /// Actualiza el estado de un reporte
  Future<void> actualizarEstado(String id, EstadoReporte nuevoEstado) async {
    _error = null;
    try {
      await _repository.actualizarEstado(id, nuevoEstado);
    } catch (e) {
      _error = 'Error al actualizar estado: $e';
      rethrow;
    }
  }

  /// Elimina un reporte resuelto
  Future<void> eliminarReporte(String id) async {
    _error = null;
    try {
      await _repository.eliminarReporte(id);
    } catch (e) {
      _error = 'Error al eliminar reporte: $e';
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

