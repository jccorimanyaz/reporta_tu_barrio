import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/error_banner.dart';
import '../../widgets/primary_button.dart';

/// Pantalla 6: Inicio de sesión del personal municipal.
class LoginMunicipalScreen extends StatefulWidget {
  const LoginMunicipalScreen({super.key});

  @override
  State<LoginMunicipalScreen> createState() => _LoginMunicipalScreenState();
}

class _LoginMunicipalScreenState extends State<LoginMunicipalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Limpia errores previos al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final exito = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (exito && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.panelMuni);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícono institucional
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Subtítulo y Título
                  const Text(
                    'REPORTA TU BARRIO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Acceso municipal',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ingresa con la cuenta autorizada para gestionar los reportes del barrio.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Banner de error (si las credenciales fallan)
                  if (authProvider.error != null) ...[
                    ErrorBanner(
                      message: authProvider.error!,
                      onDismiss: () => authProvider.clearError(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Campo Correo Electrónico
                  const Text(
                    'Correo electrónico',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'nombre@municipio.gob',
                      prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa tu correo institucional';
                      }
                      if (!value.contains('@')) {
                        return 'Ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Campo Contraseña
                  const Text(
                    'Contraseña',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu contraseña',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Sugerencia para demo
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Demo: ${AppConstants.credencialMuniEmail} / ${AppConstants.credencialMuniPassword}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Botón Iniciar sesión
                  PrimaryButton(
                    text: 'Iniciar sesión',
                    isLoading: authProvider.isLoading,
                    onPressed: _iniciarSesion,
                  ),
                  const SizedBox(height: 16),

                  // Enlace "Volver al inicio"
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.inicio);
                      },
                      child: const Text('Volver al inicio'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

