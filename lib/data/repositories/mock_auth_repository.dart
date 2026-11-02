import '../../core/constants/app_constants.dart';
import 'auth_repository.dart';

/// Implementación simulada de autenticación municipal en memoria.
///
/// TODO(firebase): Reemplazar por FirebaseAuth.instance.signInWithEmailAndPassword
class MockAuthRepository implements AuthRepository {
  bool _autenticado = false;
  String? _emailActual;

  @override
  bool get estaAutenticado => _autenticado;

  @override
  String? get usuarioEmail => _emailActual;

  @override
  Future<bool> iniciarSesion({
    required String email,
    required String password,
  }) async {
    // Simula latencia de red
    await Future.delayed(const Duration(milliseconds: 300));

    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPass = password.trim();

    // Verificación contra credenciales simuladas
    if (trimmedEmail == AppConstants.credencialMuniEmail &&
        trimmedPass == AppConstants.credencialMuniPassword) {
      _autenticado = true;
      _emailActual = trimmedEmail;
      return true;
    }

    _autenticado = false;
    _emailActual = null;
    return false;
  }

  @override
  Future<void> cerrarSesion() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _autenticado = false;
    _emailActual = null;
  }
}

