import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_stock_app/Screens/agregar_productos_screen.dart';
import 'package:control_stock_app/Screens/editar_productos_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,

        title: const Text(
          'Control de Stock',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('productos')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Ocurrio un error'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final productos = snapshot.data!.docs;

          if (productos.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];

              final cantidad = producto['cantidad'];

              final stockBajo = cantidad < 5;

              return Dismissible(
                key: Key(producto.id),

                direction: DismissDirection.endToStart,

                background: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),

                  padding: const EdgeInsets.only(right: 20),

                  alignment: Alignment.centerRight,

                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                onDismissed: (_) {
                  FirebaseFirestore.instance
                      .collection('productos')
                      .doc(producto.id)
                      .delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Producto eliminado')),
                  );
                },

                child: Card(
                  elevation: 2,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditarProductosScreen(
                            id: producto.id,
                            nombre: producto['nombre'],
                            cantidad: producto['cantidad'],
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: stockBajo ? Colors.red : Colors.green,

                      child: Icon(
                        stockBajo ? Icons.warning : Icons.inventory,

                        color: Colors.white,
                      ),
                    ),

                    title: Text(
                      producto['nombre'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Text(
                      stockBajo ? 'Stock bajo' : 'Stock disponible',
                    ),

                    trailing: Text(
                      '$cantidad unidades',

                      style: TextStyle(
                        color: stockBajo ? Colors.red : Colors.black,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarProductosScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
