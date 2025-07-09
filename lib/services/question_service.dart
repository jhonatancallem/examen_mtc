import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question.dart'; // Asegúrate que la ruta a tu modelo sea la correcta

class QuestionService {
  // Variable para guardar las preguntas en caché y no leer el archivo cada vez.
  List<Question>? _allQuestionsCache;

  // Método privado para cargar y procesar el archivo JSON una sola vez.
  Future<List<Question>> _loadAllQuestions() async {
    // Si ya hemos cargado las preguntas antes, las devolvemos directamente desde la caché.
    if (_allQuestionsCache != null) {
      return _allQuestionsCache!;
    }

    // Si es la primera vez, cargamos el archivo JSON desde los assets.
    try {
      final jsonString = await rootBundle.loadString('lib/assets/db/preguntas.json');
      // La estructura de tu JSON es un mapa de preguntas, no una lista.
      final preguntasMap = json.decode(jsonString) as Map<String, dynamic>;

      // Convertimos cada entrada del mapa en un objeto Question usando tu factory.
      final List<Question> loadedQuestions = preguntasMap.values.map((data) {
        return Question.fromJson(data as Map<String, dynamic>);
      }).toList();

      // Guardamos la lista completa de preguntas en nuestra variable de caché.
      _allQuestionsCache = loadedQuestions;

      return _allQuestionsCache!;

    } catch (e) {
      // Si hay un error al leer o procesar el archivo, imprimimos el error
      // y devolvemos una lista vacía para evitar que la app se caiga.
      print('Error al cargar o procesar el archivo preguntas.json: $e');
      return [];
    }
  }

  // Este es el método que tus páginas de examen llamarán.
  Future<List<Question>> cargarPreguntas({required String categoria}) async {
    try {
      final List<Question> allQuestions = await _loadAllQuestions();

      List<Question> preguntasParaJugar = [];

      // Filtrar por la categoría específica que se pide.
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

  // --- MÉTODO AÑADIDO ---
  // Obtiene una lista de TODAS las preguntas sin filtrar por categoría.
  // Es necesario para que el servicio de historial funcione.
  Future<List<Question>> getAllQuestions() async {
    final allQuestions = await _loadAllQuestions();
    // Devolvemos una copia para evitar que la lista original en caché sea modificada.
    return List<Question>.from(allQuestions);
  }
}
