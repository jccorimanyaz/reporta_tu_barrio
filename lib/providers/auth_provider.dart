import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';

/// Provider que gestiona la autenticación del panel municipal.
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  bool _isLoading = false;
  String? _error;

  AuthProvider(this._repository);

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _repository.estaAutenticado;
  String? get email => _repository.usuarioEmail;

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final ok = await _repository.iniciarSesion(
        email: email,
        password: password,
      );

      if (!ok) {
        _error = 'Correo o contraseña incorrectos';
      }
      return ok;
    } catch (e) {
      _error = 'Error de autenticación: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.cerrarSesion();
      _error = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

