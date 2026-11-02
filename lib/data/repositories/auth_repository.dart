/// Contrato abstracto para la autenticación municipal.
///
/// TODO(firebase): Reemplazar por FirebaseAuthRepository en Fase 2.
abstract class AuthRepository {
  /// Intenta iniciar sesión con credenciales.
  /// Retorna `true` si es exitoso o `false` si son incorrectas.
  Future<bool> iniciarSesion({
    required String email,
    required String password,
  });

  /// Cierra la sesión activa.
  Future<void> cerrarSesion();

  /// Indica si hay una sesión activa en el dispositivo.
  bool get estaAutenticado;

  /// Correo de la sesión activa si existe.
  String? get usuarioEmail;
}

