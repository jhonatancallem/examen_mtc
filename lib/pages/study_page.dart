import 'package:flutter/material.dart';
import '../services/question_service.dart';
import 'study_category_page.dart';
import 'topic_questions_page.dart';

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
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
            tabs: [
              Tab(text: 'Por Temas'),
              Tab(text: 'Por Categorías'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TemasTab(),
            _CategoriasTab(), // Tu widget de categorías se mantiene intacto
          ],
        ),
      ),
    );
  }
}

// Widget para la pestaña "Por Temas", ahora con un diseño mejorado
class _TemasTab extends StatefulWidget {
  const _TemasTab();

  @override
  State<_TemasTab> createState() => _TemasTabState();
}

class _TemasTabState extends State<_TemasTab> {
  final QuestionService _questionService = QuestionService();
  late Future<List<String>> _topicsFuture;

  // Mapa para añadir descripciones e íconos a los temas del JSON
  final Map<String, Map<String, dynamic>> topicDetails = {
    'Reglamento de Tránsito y Manual de Dispositivos de Control de Tránsito': {
      'descripcion': 'Leyes, reglas y señales de circulación vial.',
      'icon': Icons.traffic_outlined,
    },
    'Mecánica para la conducción': {
      'descripcion': 'Conocimientos básicos del vehículo.',
      'icon': Icons.build_outlined,
    },
    'Primeros Auxilios': {
      'descripcion': 'Actuación en caso de accidentes.',
      'icon': Icons.medical_services_outlined,
    },
    // Puedes añadir más temas de tu JSON aquí
  };

  @override
  void initState() {
    super.initState();
    _topicsFuture = _questionService.getUniqueTopics();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _topicsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron temas.'));
        }

        final temas = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: temas.length,
          itemBuilder: (context, index) {
            final tema = temas[index];
            final details = topicDetails[tema] ?? {'descripcion': 'Estudia las preguntas de este tema.', 'icon': Icons.book_outlined};

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.2),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                leading: Icon(details['icon'] as IconData, color: Colors.blue.shade700, size: 30),
                title: Text(
                  tema,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                subtitle: Text(details['descripcion'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicQuestionsPage(topic: tema),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

// Tu widget para la pestaña "Por Categorías", con un diseño refinado
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
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
            title: Text(cat["nombre"] as String, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(cat["detalle"] as String),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudyCategoryPage(
                    categoriaCodigo: cat["codigo"] as String,
                    categoriaNombre: cat["nombre"] as String,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
