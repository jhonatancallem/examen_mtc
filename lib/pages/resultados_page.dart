import 'package:flutter/material.dart';
import '../models/question.dart';

class ResultadosPage extends StatelessWidget {
  final List<Question> preguntas;
  final Map<int, String> respuestasUsuario;
  final int tiempoUsado; // en segundos
  final DateTime fecha;

  const ResultadosPage({
    super.key,
    required this.preguntas,
    required this.respuestasUsuario,
    required this.tiempoUsado,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    int correctas = 0;
    int sinResponder = 0;

    for (int i = 0; i < preguntas.length; i++) {
      final respuesta = respuestasUsuario[i];
      if (respuesta == null) {
        sinResponder++;
      } else if (respuesta == preguntas[i].respuesta) {
        correctas++;
      }
    }

    final incorrectas = preguntas.length - correctas - sinResponder;
    final puntaje = ((correctas / preguntas.length) * 100).toStringAsFixed(1);
    final aprobado = correctas >= 35;

    String _formatearTiempo(int segundos) {
      final minutos = segundos ~/ 60;
      final resto = segundos % 60;
      return "${minutos.toString().padLeft(2, '0')}:${resto.toString().padLeft(2, '0')}";
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Resultados del Examen")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Icon(
                  aprobado ? Icons.check_circle : Icons.cancel,
                  size: 80,
                  color: aprobado ? Colors.green : Colors.red,
                ),
              Text(
                aprobado ? "Examen Aprobado" : "Examen No Aprobado",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text("Has obtenido un $puntaje%. Necesitas al menos un 60% para aprobar."),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: correctas / preguntas.length,
                minHeight: 16,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  aprobado ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${(correctas / preguntas.length * 100).toStringAsFixed(1)}% completado",
                style: const TextStyle(fontSize: 16),
              ),
                const SizedBox(height: 10),
                Chip(label: Text("Categoría ${preguntas.first.categoria}")),
                const SizedBox(height: 20),
                Card(
                  color: Colors.green[50],
                  child: ListTile(
                    leading: const Icon(Icons.check, color: Colors.green),
                    title: Text("$correctas Correctas"),
                  ),
                ),
                Card(
                  color: Colors.red[50],
                  child: ListTile(
                    leading: const Icon(Icons.close, color: Colors.red),
                    title: Text("$incorrectas Incorrectas"),
                  ),
                ),
                const SizedBox(height: 10),
                Text("Tiempo utilizado: ${_formatearTiempo(tiempoUsado)}"),
                Text("Fecha: ${fecha.day}/${fecha.month}/${fecha.year}"),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Nuevo examen"),
                ),
              ],
            ),
          ),
          const Divider(height: 40),
          const Text("Revisión de preguntas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...List.generate(preguntas.length, (i) {
            final pregunta = preguntas[i];
            final seleccion = respuestasUsuario[i];
            final correcta = pregunta.respuesta;

            Color getColor(String key) {
              if (seleccion == null) return Colors.grey[300]!;
              if (key == correcta) return Colors.green[100]!;
              if (key == seleccion && seleccion != correcta) return Colors.red[100]!;
              return Colors.white;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 24),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (pregunta.imagen != null && pregunta.imagen!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Image.network(pregunta.imagen!, height: 160),
                      ),
                    Text("Pregunta ${i + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(pregunta.pregunta),
                    const SizedBox(height: 12),
                    ...pregunta.alternativas.entries.map((entry) {
                      final key = entry.key;
                      final value = entry.value;
                      final esCorrecta = key == correcta;
                      final fueSeleccionada = key == seleccion;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: getColor(key),
                          border: Border.all(
                            color: esCorrecta
                                ? Colors.green
                                : (fueSeleccionada ? Colors.red : Colors.grey[300]!),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(value),
                          trailing: esCorrecta
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : fueSeleccionada
                              ? const Icon(Icons.cancel, color: Colors.red)
                              : null,
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    const Text("Explicación:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(pregunta.explicacion),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
