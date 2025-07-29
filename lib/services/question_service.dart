import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question.dart';

class QuestionService {
  List<Question>? _allQuestionsCache;

  // Método privado para cargar y procesar el archivo JSON una sola vez.
  Future<List<Question>> _loadAllQuestions() async {
    if (_allQuestionsCache != null) {
      return _allQuestionsCache!;
    }
    try {
      final jsonString = await rootBundle.loadString('lib/assets/db/preguntas.json');
      final preguntasMap = json.decode(jsonString) as Map<String, dynamic>;
      final List<Question> loadedQuestions = preguntasMap.values.map((data) {
        return Question.fromJson(data as Map<String, dynamic>);
      }).toList();
      _allQuestionsCache = loadedQuestions;

      return _allQuestionsCache!;

    } catch (e) {
      print('Error al cargar o procesar el archivo preguntas.json: $e');
      return [];
    }
  }
  Future<List<Question>> cargarPreguntas({required String categoria}) async {
    try {
      final List<Question> allQuestions = await _loadAllQuestions();

      List<Question> preguntasParaJugar = [];

      final preguntasCategoria = allQuestions.where((pregunta) {
        return pregunta.categoria.toUpperCase() == categoria.toUpperCase();
      }).toList();

      preguntasParaJugar.addAll(preguntasCategoria);

      // Filtrar por la categoría "Todas" y agregarlas.
      final preguntasGlobales = allQuestions.where((pregunta) {
        return pregunta.categoria.toUpperCase() == "TODAS";
      }).toList();

      preguntasParaJugar.addAll(preguntasGlobales);

      // Mezclar la lista final para que el orden sea aleatorio en cada examen.
      preguntasParaJugar.shuffle();
      return preguntasParaJugar;

    } catch (e) {
      print("Error al filtrar preguntas por categoría: $e");
      return [];
    }
  }
  Future<List<String>> getUniqueTopics() async {
    final allQuestions = await _loadAllQuestions();
    final topics = allQuestions.map((q) => q.tema).where ((t) => t != null).toSet();
    return topics.whereType<String>().toList()..sort();
  }
  Future<List<Question>> getQuestionsByTopic(String topic) async {
    final allQuestions = await _loadAllQuestions();
    return allQuestions.where((q) => q.tema == topic).toList();
  }
  Future<List<Question>> getAllQuestions() async {
    final allQuestions = await _loadAllQuestions();
    return List<Question>.from(allQuestions);
  }
}
