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

  // Factory constructor más robusto para manejar datos nulos desde el JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      pregunta: json['pregunta'] ?? 'Pregunta no disponible',
      alternativas: Map<String, String>.from(json['alternativas'] ?? {}),
      respuesta: json['respuesta'] ?? '',
      explicacion: json['explicacion'] ?? 'No hay explicación disponible.',
      categoria: json['categoria'] ?? 'Sin categoría',
      imagen: json['imagen'], // Este campo ya puede ser nulo
    );
  }
}
