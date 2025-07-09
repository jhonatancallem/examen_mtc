import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesitarás añadir 'intl' a tu pubspec.yaml
import '../models/exam_result.dart';
import '../services/history_service.dart';
import 'resultados_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService _historyService = HistoryService();
  late Future<List<ExamResult>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _historyService.getExamHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Simulacros'),
      ),
      body: FutureBuilder<List<ExamResult>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aún no has completado ningún simulacro.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          final history = snapshot.data!;
          // Ordenamos para mostrar los más recientes primero
          history.sort((a, b) => b.fecha.compareTo(a.fecha));

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final result = history[index];
              final isApproved = (result.puntaje / result.totalPreguntas) >= 0.8;
              final scoreString = '${result.puntaje}/${result.totalPreguntas}';
              final dateString = DateFormat('dd/MM/yyyy - hh:mm a').format(result.fecha);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(
                    isApproved ? Icons.check_circle : Icons.cancel,
                    color: isApproved ? Colors.green : Colors.red,
                    size: 40,
                  ),
                  title: Text(
                    'Simulacro Licencia ${result.categoria}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Fecha: $dateString\nPuntaje: $scoreString'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultadosPage(
                          preguntas: result.preguntas,
                          respuestasUsuario: result.respuestasUsuario,
                          tiempoUsado: result.tiempoUsado,
                          fecha: result.fecha,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
