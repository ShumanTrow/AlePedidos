import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/theme.dart';
import 'features/auth/role_select_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AlePedidosApp());
}

class AlePedidosApp extends StatelessWidget {
  const AlePedidosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlePedidos',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const RoleSelectPage(),
    );
  }
}
