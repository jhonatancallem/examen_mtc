import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';

class TopicQuestionsPage extends StatefulWidget {
  final String topic;

  const TopicQuestionsPage({super.key, required this.topic});

  @override
  _TopicQuestionsPageState createState() => _TopicQuestionsPageState();
}

class _TopicQuestionsPageState extends State<TopicQuestionsPage> {
  final QuestionService _questionService = QuestionService();
  late Future<List<Question>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _questionService.getQuestionsByTopic(widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron preguntas para este tema.'));
          }

          final questions = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  title: Text(
                    '${index + 1}. ${question.pregunta}',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.grey.shade50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (question.imagen != null && question.imagen!.isNotEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Image.asset(
                                  question.imagen!,
                                  height: 150,
                                  fit: BoxFit.contain,
                                  errorBuilder: (c, e, s) => const Icon(Icons.error_outline, color: Colors.red),
                                ),
                              ),
                            ),
                          ...question.alternativas.entries.map((entry) {
                            final isCorrect = entry.key == question.respuesta;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isCorrect ? Colors.green : Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.radio_button_off,
                                    color: isCorrect ? Colors.green : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(entry.value)),
                                ],
                              ),
                            );
                          }).toList(),
                          if (question.explicacion.isNotEmpty) ...[
                            const Divider(height: 24, thickness: 1),
                            const Text(
                                'Explicación:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                            ),
                            const SizedBox(height: 4),
                            Text(
                                question.explicacion,
                                style: TextStyle(color: Colors.grey.shade800, height: 1.4)
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
