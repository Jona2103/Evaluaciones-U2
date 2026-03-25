//DAM - Loza Figueroa
//TFS - Viera Quiñonez

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const PantallaLogin(),
    );
  }
}

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final correoCtrl = TextEditingController();
  final contraCtrl = TextEditingController();

  bool login = true;
  bool cargando = false;

  @override
  void dispose() {
    correoCtrl.dispose();
    contraCtrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final correo = correoCtrl.text.trim();
    final contra = contraCtrl.text;

    if (correo.isEmpty || contra.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa correo y contrasena.')),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      final conexion = FirebaseAuth.instance;
      if (login) {
        await conexion.signInWithEmailAndPassword(
          email: correo,
          password: contra,
        );
      } else {
        await conexion.createUserWithEmailAndPassword(
          email: correo,
          password: contra,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(login ? 'Inicio de sesion exitoso.' : 'Cuenta creada.')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PantallaPrincipal()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de autenticacion: ${e.message ?? e.code}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.people, size: 80, color: Colors.indigo),
                Text( login ? 'Bienvenido, inicia sesion' : 'Registro', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold) ),
                SizedBox(height: 20),
                TextField(
                  controller: correoCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: contraCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: cargando ? null : submit,
                    child: Text(cargando ? 'Cargando...' : (login ? 'Iniciar Sesion' : 'Registrarse')),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      login = !login;
                    });
                  },
                  child: Text(login ? '¿No tienes cuenta? Regístrate' : '¿Ya tienes cuenta? Inicia sesión'),
                )
              ]

            ),
          ),
        ),
      ),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla Principal')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bienvenido a la pantalla principal'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const PantallaLogin()),
                  );
                }
              },
              child: const Text('Cerrar sesion'),
            ),
          ],
        ),
      ),
    );
  }
}
