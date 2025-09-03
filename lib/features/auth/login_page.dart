import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/user_role.dart';
import '../home/client_home_page.dart';
import '../home/delivery_home_page.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  final UserRole role;
  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  bool _loading = false;

  // Email/Password inputs (muy básicos para demo)
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _goHome(UserRole role) {
    final page = role == UserRole.client
        ? const ClientHomePage()
        : const DeliveryHomePage();
    Navigator.of(
      context,
    ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => page), (_) => false);
  }

  Future<void> _handleSignIn(Future<UserCredential> Function() signIn) async {
    setState(() => _loading = true);
    try {
      final cred = await signIn();
      final user = cred.user!;
      // Crea o respeta el rol guardado
      final finalRole = await _auth.ensureUserDoc(user, widget.role);
      if (!mounted) return;
      _goHome(finalRole);
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e));
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe una cuenta con ese correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Ese correo ya está registrado.';
      default:
        return 'Ocurrió un error (${e.code}). Intenta de nuevo.';
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Vas a entrar como ${widget.role == UserRole.client ? 'Cliente' : 'Delivery'}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // --- GOOGLE ---
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () => _handleSignIn(_auth.signInWithGoogle),
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Continuar con Google'),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  SizedBox(width: 8),
                  Text('o'),
                  SizedBox(width: 8),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 12),

              // --- EMAIL / PASSWORD (opcional) ---
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _loading
                          ? null
                          : () => _handleSignIn(
                              () => _auth.signInWithEmail(
                                _emailCtrl.text.trim(),
                                _passCtrl.text,
                              ),
                            ),
                      child: const Text('Entrar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _loading
                          ? null
                          : () => _handleSignIn(
                              () => _auth.registerWithEmail(
                                _emailCtrl.text.trim(),
                                _passCtrl.text,
                              ),
                            ),
                      child: const Text('Crear cuenta'),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (_emailCtrl.text.trim().isEmpty) {
                          _showError(
                            'Ingresá tu email para recuperar la contraseña.',
                          );
                          return;
                        }
                        await _auth.sendPasswordReset(_emailCtrl.text.trim());
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Te enviamos un correo para recuperar tu contraseña.',
                            ),
                          ),
                        );
                      },
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
