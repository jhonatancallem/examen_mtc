import 'package:flutter/material.dart';
import '../services/question_service.dart';
import 'topic_questions_page.dart';

class StudyByTopicPage extends StatefulWidget {
  const StudyByTopicPage({super.key});

  @override
  _StudyByTopicPageState createState() => _StudyByTopicPageState();
}

class _StudyByTopicPageState extends State<StudyByTopicPage> {
  final QuestionService _questionService = QuestionService();
  late Future<List<String>> _topicsFuture;

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

        final topics = snapshot.data!;

        return ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(topic, style: const TextStyle(fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicQuestionsPage(topic: topic),
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
