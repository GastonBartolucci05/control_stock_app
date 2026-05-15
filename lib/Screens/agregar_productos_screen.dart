import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgregarProductosScreen extends StatefulWidget {
  const AgregarProductosScreen({super.key});

  @override
  State<AgregarProductosScreen> createState() => _AgregarProductosScreenState();
}

class _AgregarProductosScreenState extends State<AgregarProductosScreen> {
  final nombreController = TextEditingController();
  final cantidadController = TextEditingController();

  Future<void> guardarProducto() async {
    final nombre = nombreController.text.trim();

    final cantidad = int.tryParse(cantidadController.text) ?? 0;

    if (nombre.isEmpty || cantidad <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Completar los campos')));

      return;
    }

    FirebaseFirestore.instance.collection('productos').add({
      'nombre': nombre,
      'cantidad': cantidad,
      'fecha': Timestamp.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,

        title: const Text(
          'Agregar Producto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: guardarProducto,
                child: const Text('Guardar Producto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
