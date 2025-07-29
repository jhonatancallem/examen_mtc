class Question {
  final String pregunta;
  final Map<String, String> alternativas;
  final String respuesta;
  final String explicacion;
  final String categoria;
  final String? tema;
  final String? imagen;

  Question({
    required this.pregunta,
    required this.alternativas,
    required this.respuesta,
    required this.explicacion,
    required this.categoria,
    this.tema,
    this.imagen,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      pregunta: json['pregunta'] ?? 'Pregunta no disponible',
      alternativas: Map<String, String>.from(json['alternativas'] ?? {}),
      respuesta: json['respuesta'] ?? '',
      explicacion: json['explicacion'] ?? 'No hay explicación disponible.',
      categoria: json['categoria'] ?? 'Sin categoría',
      tema: json['tema'],
      imagen: json['imagen'],
    );
  }
}
