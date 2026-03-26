// DAM: Ruiz Lopez
// TFS: Viera Quiñonez

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: PantallaApi());
  }
}

class PantallaApi extends StatefulWidget {
  @override
  _PantallaApiState createState() => _PantallaApiState();
}

class _PantallaApiState extends State<PantallaApi> {
  List datos = [];
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  void cargarDatos() async {
    final res = await http.get(Uri.parse('https://dummyjson.com/users'));
    setState(() => datos = jsonDecode(res.body)['users']);
  }

  Future<void> agregarDato() async {
    if (nombreCtrl.text.isEmpty || emailCtrl.text.isEmpty) return;

    final res = await http.post(
      Uri.parse('https://dummyjson.com/users/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'firstName': nombreCtrl.text, 'email': emailCtrl.text}),
    );

    final nuevoUsuario = jsonDecode(res.body);
    setState(() => datos.add(nuevoUsuario));

    nombreCtrl.clear();
    emailCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario agregado exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: 
                      ElevatedButton(
                      onPressed: cargarDatos,
                      child: const Text('Cargar'),
                    )),
                    SizedBox(width: 8),
                    Expanded(child:
                      ElevatedButton(
                      onPressed: agregarDato,
                      child: const Text('Agregar'),
                    )),
                  ],
                )
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: datos.length,
              itemBuilder: (context, i) => ListTile(
                leading: CircleAvatar(child: Text(datos[i]['firstName'] != null ? datos[i]['firstName'][0] : '?')),
                  title: Text(datos[i]['firstName'] ?? 'Sin nombre'),
                  subtitle: Text(datos[i]['email'] ?? 'Sin email'),
                ),
            ),
          ),
        ]
      ),
    );
  }
}
