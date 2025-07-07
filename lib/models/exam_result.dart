import 'question.dart';

class ExamResult {
  final String categoria;
  final DateTime fecha;
  final int puntaje;
  final int totalPreguntas;
  final int tiempoUsado;
  final List<Question> preguntas;
  final Map<int, String> respuestasUsuario;

  ExamResult({
    required this.categoria,
    required this.fecha,
    required this.puntaje,
    required this.totalPreguntas,
    required this.tiempoUsado,
    required this.preguntas,
    required this.respuestasUsuario,
  });

  // Métodos para convertir a y desde JSON (para guardar en SharedPreferences)
  Map<String, dynamic> toJson() {
    // Nota: No podemos guardar List<Question> directamente, así que la omitimos.
    // La recuperaremos al re-navegar a la página de resultados.
    return {
      'categoria': categoria,
      'fecha': fecha.toIso8601String(),
      'puntaje': puntaje,
      'totalPreguntas': totalPreguntas,
      'tiempoUsado': tiempoUsado,
      // Convertimos el mapa de respuestas a un formato compatible con JSON
      'respuestasUsuario': respuestasUsuario.map((key, value) => MapEntry(key.toString(), value)),
    };
  }

  factory ExamResult.fromJson(Map<String, dynamic> json, List<Question> allQuestions) {
    final respuestasMap = (json['respuestasUsuario'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), value as String),
    );

    // Reconstruimos la lista de preguntas del examen a partir de las respuestas guardadas
    // Esto es una simplificación. Para una reconstrucción exacta, necesitaríamos IDs únicos por pregunta.
    // Por ahora, asumiremos que las primeras 'n' preguntas son las del examen.
    final examQuestions = allQuestions.take(json['totalPreguntas']).toList();

    return ExamResult(
      categoria: json['categoria'],
      fecha: DateTime.parse(json['fecha']),
      puntaje: json['puntaje'],
      totalPreguntas: json['totalPreguntas'],
      tiempoUsado: json['tiempoUsado'],
      preguntas: examQuestions,
      respuestasUsuario: respuestasMap,
    );
  }
}
