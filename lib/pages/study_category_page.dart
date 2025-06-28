import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';

class StudyCategoryPage extends StatefulWidget {
  final String categoriaCodigo;
  final String categoriaNombre;

  const StudyCategoryPage({
    super.key,
    required this.categoriaCodigo,
    required this.categoriaNombre,
  });

  @override
  State<StudyCategoryPage> createState() => _StudyCategoryPageState();
}

class _StudyCategoryPageState extends State<StudyCategoryPage> {
  final QuestionService _service = QuestionService();
  List<Question> _preguntas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPreguntas();
  }

  Future<void> _cargarPreguntas() async {
    final preguntas = await _service.cargarPreguntas(categoria: widget.categoriaCodigo);
    setState(() {
      _preguntas = preguntas;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estudio: ${widget.categoriaNombre}"),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _preguntas.length,
        itemBuilder: (context, index) {
          final pregunta = _preguntas[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(pregunta.pregunta),
              subtitle: Text("Respuesta correcta: ${pregunta.respuesta}"),
            ),
          );
        },
      ),
    );
  }
}
