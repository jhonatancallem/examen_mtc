import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/question.dart';
import '../services/ad_service.dart';

class ResultadosPage extends StatefulWidget {
  final List<Question> preguntas;
  final Map<int, String> respuestasUsuario;
  final int tiempoUsado;
  final DateTime fecha;

  const ResultadosPage({
    super.key,
    required this.preguntas,
    required this.respuestasUsuario,
    required this.tiempoUsado,
    required this.fecha,
  });

  @override
  State<ResultadosPage> createState() => _ResultadosPageState();
}

class _ResultadosPageState extends State<ResultadosPage> {
  final AdService _adService = AdService();
  bool _explicacionesDesbloqueadas = false;

  @override
  void initState() {
    super.initState();
    // CORRECCIÓN: En esta página, solo necesitamos precargar el anuncio recompensado.
    // El anuncio intersticial ya se mostró al finalizar el examen.
    _adService.loadRewardedInterstitialAd();
  }

  void _desbloquearExplicaciones() {
    // CORRECCIÓN: Llamamos a la función correcta para el anuncio recompensado.
    _adService.showRewardedInterstitialAd(

      onAdDismissed: () {
        print("El usuario cerró el anuncio sin obtener la recompensa.");
      },
      onUserEarnedReward: () {
        print("Recompensa obtenida. Desbloqueando explicaciones.");
        setState(() {
          _explicacionesDesbloqueadas = true;
        });
      },
    );
  }

  String _formatearTiempo(int segundos) {
    final minutos = segundos ~/ 60;
    final resto = segundos % 60;
    return "${minutos.toString().padLeft(2, '0')}:${resto.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    int correctas = 0;
    int sinResponder = 0;

    for (int i = 0; i < widget.preguntas.length; i++) {
      final respuesta = widget.respuestasUsuario[i];
      if (respuesta == null) {
        sinResponder++;
      } else if (respuesta == widget.preguntas[i].respuesta) {
        correctas++;
      }
    }

    final incorrectas = widget.preguntas.length - correctas - sinResponder;
    final aprobado = correctas >= 35;

    return Scaffold(
      appBar: AppBar(title: const Text("Resultados del Examen")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(aprobado, correctas, incorrectas),
          const Divider(height: 40),
          _buildReviewSection(),
        ],
      ),
    );
  }

  Widget _buildHeader(bool aprobado, int correctas, int incorrectas) {
    final puntaje = widget.preguntas.isNotEmpty ? (correctas / widget.preguntas.length * 100) : 0.0;

    return Center(
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
          Text("Has obtenido un ${puntaje.toStringAsFixed(1)}%. Necesitas al menos un 87.5% para aprobar."),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: widget.preguntas.isNotEmpty ? correctas / widget.preguntas.length : 0,
            minHeight: 16,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              aprobado ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${puntaje.toStringAsFixed(1)}% completado",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          if (widget.preguntas.isNotEmpty)
            Chip(label: Text("Categoría ${widget.preguntas.first.categoria}")),
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
          Text("Tiempo utilizado: ${_formatearTiempo(widget.tiempoUsado)}"),
          Text("Fecha: ${DateFormat('dd/MM/yyyy').format(widget.fecha)}"),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            icon: const Icon(Icons.refresh),
            label: const Text("Nuevo examen"),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Revisión de preguntas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        if (!_explicacionesDesbloqueadas)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.lock_open),
              label: const Text('Desbloquear Explicaciones Detalladas'),
              onPressed: _desbloquearExplicaciones,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ),
        const SizedBox(height: 16),
        ...List.generate(widget.preguntas.length, (i) {
          final pregunta = widget.preguntas[i];
          final seleccion = widget.respuestasUsuario[i];
          final correcta = pregunta.respuesta;

          Color getColor(String? key) {
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
                      child: Center(
                        child: Image.asset(
                          pregunta.imagen!,
                          height: 160,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(Icons.error_outline, color: Colors.red),
                        ),
                      ),
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
                  if (_explicacionesDesbloqueadas) ...[
                    const SizedBox(height: 10),
                    const Text("Explicación:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(pregunta.explicacion),
                  ]
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
