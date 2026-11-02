import 'dart:async';

/// Contrato abstracto para el servicio de conectividad a internet.
abstract class ConectividadService {
  /// Verifica si hay conexión disponible actualmente.
  bool get hayConexion;

  /// Stream reactivo de cambios de conectividad.
  Stream<bool> get conectividadStream;

  /// Alterna el estado simulado (para pruebas de desarrollo).
  void alternarConexion();

  /// Establece manualmente el estado de conexión.
  void setConexion(bool conectado);
}

/// Implementación simulada de conectividad en memoria con interruptor.
class MockConectividadService implements ConectividadService {
  bool _conectado = true;
  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  MockConectividadService({bool conexionInicial = true})
      : _conectado = conexionInicial;

  @override
  bool get hayConexion => _conectado;

  @override
  Stream<bool> get conectividadStream => _controller.stream;

  @override
  void alternarConexion() {
    _conectado = !_conectado;
    _controller.add(_conectado);
  }

  @override
  void setConexion(bool conectado) {
    if (_conectado != conectado) {
      _conectado = conectado;
      _controller.add(_conectado);
    }
  }

  void dispose() {
    _controller.close();
  }
}

