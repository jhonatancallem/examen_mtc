import 'package:flutter/material.dart';
import 'study_category_page.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estudio'),
          backgroundColor: Colors.blue,
          actions: const [
            Icon(Icons.home),
            SizedBox(width: 16),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Por Temas'),
              Tab(text: 'Por Categorías'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TemasTab(),
            _CategoriasTab(),
          ],
        ),
      ),
    );
  }
}

class _TemasTab extends StatelessWidget {
  const _TemasTab();

  @override
  Widget build(BuildContext context) {
    final temas = [
      {
        'titulo': 'Normas de Tránsito',
        'descripcion': 'Reglamento y leyes sobre circulación vial',
      },
      {
        'titulo': 'Señales de Tránsito',
        'descripcion': 'Interpretación de las diferentes señales viales',
      },
      {
        'titulo': 'Seguridad Vial',
        'descripcion': 'Medidas para una conducción segura',
      },
      {
        'titulo': 'Límites de Velocidad',
        'descripcion': 'Límites de velocidad según las vías y vehículos',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: temas.length,
      itemBuilder: (context, index) {
        final tema = temas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            title: Text(
              tema['titulo']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(tema['descripcion']!),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Acción futura
            },
          ),
        );
      },
    );
  }
}

class _CategoriasTab extends StatelessWidget {
  const _CategoriasTab();

  @override
  Widget build(BuildContext context) {
    final categorias = [
      {"codigo": "A-I", "nombre": "Categoría A-I", "detalle": "A-I (A1)", "color": Colors.blue},
      {"codigo": "A-IIA", "nombre": "Categoría A-IIA", "detalle": "A-IIA (A2A)", "color": Colors.teal},
      {"codigo": "A-IIB", "nombre": "Categoría A-IIB", "detalle": "A-IIB (A2B)", "color": Colors.amber},
      {"codigo": "A-IIIA", "nombre": "Categoría A-IIIA", "detalle": "A-IIIA (A3A)", "color": Colors.deepPurple},
      {"codigo": "A-IIIB", "nombre": "Categoría A-IIIB", "detalle": "A-IIIB (A3B)", "color": Colors.pink},
      {"codigo": "A-IIIC", "nombre": "Categoría A-IIIC", "detalle": "A-IIIC (A3C)", "color": Colors.red},
      {"codigo": "B-IIA", "nombre": "Categoría B-IIA", "detalle": "B-IIA (B2A)", "color": Colors.green},
      {"codigo": "B-IIB", "nombre": "Categoría B-IIB", "detalle": "B-IIB (B2B)", "color": Colors.orange},
      {"codigo": "B-IIC", "nombre": "Categoría B-IIC", "detalle": "B-IIC (B2C)", "color": Colors.lime},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final cat = categorias[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: cat["color"] as Color,
              child: Text(
                cat["codigo"] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(cat["nombre"] as String),
            subtitle: Text(cat["detalle"] as String),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyCategoryPage(
                      categoriaCodigo: cat["codigo"] as String,
                      categoriaNombre: cat["nombre"] as String,
                    ),
                  ),
                );// Acción al seleccionar categoría
            },
          ),
        );
      },
    );
  }
}
