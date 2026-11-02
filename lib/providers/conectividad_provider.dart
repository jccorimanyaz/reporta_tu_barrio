import 'dart:async';
import 'package:flutter/material.dart';

import '../data/services/conectividad_service.dart';

/// Provider que expone el estado de conectividad a la aplicación.
class ConectividadProvider extends ChangeNotifier {
  final ConectividadService _service;
  StreamSubscription<bool>? _subscription;
  bool _hayConexion = true;

  ConectividadProvider(this._service) {
    _hayConexion = _service.hayConexion;
    _subscription = _service.conectividadStream.listen((conectado) {
      _hayConexion = conectado;
      notifyListeners();
    });
  }

  bool get hayConexion => _hayConexion;

  /// Alterna el estado simulado para pruebas de la variante B de confirmación.
  void alternarConexion() {
    _service.alternarConexion();
    _hayConexion = _service.hayConexion;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

