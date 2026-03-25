//DAM - Cortez
//TFS - Jonathan

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carrusel App',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const Carrusel(),
    );
  }
}

class Carrusel extends StatefulWidget {
  const Carrusel({super.key});

  @override
  State<Carrusel> createState() => _CarruselState();
}

class _CarruselState extends State<Carrusel> {
  int currentIndex = 0;
  final List<String> images = [
    'assets/imagenes/1.png',
    'assets/imagenes/2.png',
    'assets/imagenes/3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        title: const Text(
          'CARRUSEL DE IMÁGENES',
          style: TextStyle(color: Colors.red, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            child: Column(
              children: [
                Text('CARRUSEL DE IMÁGENES'),
                const SizedBox(height: 10),
                Image.asset(
                  images[currentIndex],
                  width: 400,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LinearProgressIndicator(
                    value: (currentIndex + 1) / images.length,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 145),
            child: Row(
              children: [
                TextButton(
                  onPressed: retrocederCarrusel,
                  child: const Text("RETROCEDER"),
                ),
                TextButton(
                  onPressed: avanzarCarrusel,
                  child: const Text("AVANZAR"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void retrocederCarrusel() {
    setState(() {
      currentIndex = (currentIndex - 1) % images.length;
    });
  }

  void avanzarCarrusel() {
    setState(() {
      currentIndex = (currentIndex + 1) % images.length;
    });
  }
}
