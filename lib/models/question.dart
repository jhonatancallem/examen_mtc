class Question {
  final String pregunta;
  final Map<String, String> alternativas;
  final String respuesta;
  final String explicacion;
  final String categoria;
  final String? imagen;

  Question({
    required this.pregunta,
    required this.alternativas,
    required this.respuesta,
    required this.explicacion,
    required this.categoria,
    this.imagen,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      pregunta: json['pregunta'],
      alternativas: Map<String, String>.from(json['alternativas']),
      respuesta: json['respuesta'],
      explicacion: json['explicacion'] ?? '',
      categoria: json['categoria'],
      imagen: json['imagen'],
    );
  }
}
