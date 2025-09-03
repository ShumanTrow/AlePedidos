import 'package:flutter/material.dart';
import '../../shared/user_role.dart';
import 'login_page.dart';

class RoleSelectPage extends StatelessWidget {
  const RoleSelectPage({super.key});

  void _goToLogin(BuildContext context, UserRole role) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => LoginPage(role: role)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Logo / título
              Row(
                children: [
                  const Icon(Icons.pedal_bike_rounded, size: 48),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ALE',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text('PEDIDOS', style: TextStyle(letterSpacing: 3)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Bienvenido',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text('¿Qué tipo de usuario serás?'),
              const SizedBox(height: 24),

              // Botones grandes
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  onPressed: () => _goToLogin(context, UserRole.client),
                  child: const Text('Cliente'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: size.width,
                child: OutlinedButton(
                  onPressed: () => _goToLogin(context, UserRole.delivery),
                  child: const Text('Delivery'),
                ),
              ),
              const Spacer(),
              const Text(
                'Podrás cambiar esto luego en tu perfil.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
