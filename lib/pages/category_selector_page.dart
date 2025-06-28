import 'package:flutter/material.dart';
import 'exam_page.dart';

class CategorySelectorPage extends StatelessWidget {
  const CategorySelectorPage({super.key});

  final List<String> categorias = const [
    "A-I", "A-IIA", "A-IIB", "A-IIIA", "A-IIIB", "A-IIIC",
    "B-IIA", "B-IIB", "B-IIC"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecciona tu categoría")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // dos columnas
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final cat = categorias[index];
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExamPage(categoria: cat),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(24),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              cat,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
