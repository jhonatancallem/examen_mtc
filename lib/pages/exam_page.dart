import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';
import 'resultados_page.dart';

class ExamPage extends StatefulWidget {
  final String categoria;

  const ExamPage({super.key, required this.categoria});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final QuestionService _service = QuestionService();
  List<Question> _preguntas = [];
  int _preguntaActual = 0;
  Map<int, String> _respuestasUsuario = {};
  late Timer _timer;
  int _tiempoRestante = 40 * 60; // 40 minutos

  @override
  void initState() {
    super.initState();
    _iniciarExamen();
  }

  void _iniciarExamen() async {
    final todas = await _service.cargarPreguntas(categoria: widget.categoria);
    todas.shuffle();
    setState(() {
      _preguntas = todas.take(40).toList();
    });
    _iniciarTemporizador();
  }

  void _iniciarTemporizador() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tiempoRestante == 0) {
        _finalizarExamen();
      } else {
        setState(() {
          _tiempoRestante--;
        });
      }
    });
  }

  void _guardarRespuesta(String respuesta) {
    setState(() {
      _respuestasUsuario[_preguntaActual] = respuesta;
    });
  }

  void _siguientePregunta() {
    if (_preguntaActual < _preguntas.length - 1) {
      setState(() {
        _preguntaActual++;
      });
    } else {
      _finalizarExamen();
    }
  }

  void _anteriorPregunta() {
    if (_preguntaActual > 0) {
      setState(() {
        _preguntaActual--;
      });
    }
  }

  void _finalizarExamen() {
    _timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadosPage(
          preguntas: _preguntas,
          respuestasUsuario: _respuestasUsuario,
          tiempoUsado: 40 * 60 - _tiempoRestante,
          fecha: DateTime.now(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatearTiempo(int segundos) {
    final minutos = segundos ~/ 60;
    final resto = segundos % 60;
    return '${minutos.toString().padLeft(2, '0')}:${resto.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_preguntas.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pregunta = _preguntas[_preguntaActual];

    return Scaffold(
      appBar: AppBar(
        title: Text("Pregunta ${_preguntaActual + 1}/40"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _formatearTiempo(_tiempoRestante),
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // ✅ Barra de progreso verde
          LinearProgressIndicator(
            value: _respuestasUsuario.length / _preguntas.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 6,
          ),

          // Pregunta y opciones
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pregunta.imagen != null && pregunta.imagen!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Image.network(pregunta.imagen!, height: 160),
                    ),
                  Text(
                    pregunta.pregunta,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...pregunta.alternativas.entries.map((entry) {
                    final seleccionada = _respuestasUsuario[_preguntaActual] == entry.key;
                    return GestureDetector(
                      onTap: () => _guardarRespuesta(entry.key),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: seleccionada ? Colors.blue.shade100 : Colors.white,
                          border: Border.all(
                            color: seleccionada ? Colors.blue : Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              seleccionada
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: seleccionada ? Colors.blue : Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: seleccionada ? Colors.black : Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const Spacer(),

                  // ✅ Botones de navegación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _preguntaActual > 0 ? _anteriorPregunta : null,
                        child: const Text("Anterior"),
                      ),
                      ElevatedButton(
                        onPressed: _respuestasUsuario.containsKey(_preguntaActual)
                            ? (_preguntaActual == _preguntas.length - 1
                            ? _finalizarExamen
                            : _siguientePregunta)
                            : null,
                        child: Text(_preguntaActual == _preguntas.length - 1
                            ? "Finalizar"
                            : "Siguiente"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
