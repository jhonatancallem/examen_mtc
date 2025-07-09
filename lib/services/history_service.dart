import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exam_result.dart';
import '../models/question.dart';
import 'question_service.dart';

class HistoryService {
  static const _key = 'exam_history';
  final QuestionService _questionService = QuestionService();

  Future<void> saveExamResult(ExamResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getExamHistory();
    history.add(result);

    // Convertimos la lista de resultados a una lista de JSONs, y luego a un string
    final List<String> historyJson = history.map((res) => json.encode(res.toJson())).toList();
    await prefs.setStringList(_key, historyJson);
  }

  Future<List<ExamResult>> getExamHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_key) ?? [];

    // Para reconstruir, necesitamos todas las preguntas posibles
    final allQuestions = await _questionService.getAllQuestions();

    // Convertimos de vuelta de string a JSON, y luego a objetos ExamResult
    return historyJson.map((res) => ExamResult.fromJson(json.decode(res), allQuestions)).toList();
  }
}
