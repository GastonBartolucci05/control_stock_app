import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarProductosScreen extends StatefulWidget {
  final String nombre;
  final int cantidad;
  final String id;
  const EditarProductosScreen({
    super.key,
    required this.id,
    required this.nombre,
    required this.cantidad,
  });

  @override
  State<EditarProductosScreen> createState() => _EditarProductosScreenState();
}

class _EditarProductosScreenState extends State<EditarProductosScreen> {
  late TextEditingController nombreController;
  late TextEditingController cantidadController;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(text: widget.nombre);

    cantidadController = TextEditingController(
      text: widget.cantidad.toString(),
    );
  }

  Future<void> editarProducto() async {
    final nombre = nombreController.text.trim();
    final cantidad = int.tryParse(cantidadController.text) ?? 0;

    if (nombre.isEmpty || cantidad <= 0) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('productos')
        .doc(widget.id)
        .update({'nombre': nombre, 'cantidad': cantidad});

    if (!mounted) return;

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
          'Editar Producto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre Producto'),
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
                onPressed: editarProducto,

                child: const Text('Guardar cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
