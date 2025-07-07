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
      // CORRECCIÓN: Ahora decodificamos directamente el mapa de preguntas,
      // sin buscar una llave "preguntas" adicional.
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

  // Este es el método que tus páginas llamarán.
  // Mantiene la misma lógica que tenías con Firebase.
  Future<List<Question>> cargarPreguntas({required String categoria}) async {
    try {
      // 1. Cargar todas las preguntas desde la caché o el archivo.
      final List<Question> allQuestions = await _loadAllQuestions();

      List<Question> preguntasParaJugar = [];

      // 2. Filtrar por la categoría específica que se pide.
      final preguntasCategoria = allQuestions.where((pregunta) {
        return pregunta.categoria.toUpperCase() == categoria.toUpperCase();
      }).toList();

      preguntasParaJugar.addAll(preguntasCategoria);

      // 3. Filtrar por la categoría "Todas" y agregarlas.
      final preguntasGlobales = allQuestions.where((pregunta) {
        return pregunta.categoria.toUpperCase() == "TODAS";
      }).toList();

      preguntasParaJugar.addAll(preguntasGlobales);

      // 4. Mezclar la lista final para que el orden sea aleatorio en cada examen.
      preguntasParaJugar.shuffle();

      return preguntasParaJugar;

    } catch (e) {
      print("Error al filtrar preguntas por categoría: $e");
      return [];
    }
  }
}
