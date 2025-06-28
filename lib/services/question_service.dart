import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';

class QuestionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Question>> cargarPreguntas({required String categoria}) async {
    try {
      List<Question> todasLasPreguntas = [];

      // 1. Preguntas de la categoría específica
      final snapshotCategoria = await _db
          .collection("preguntas")
          .where("categoria", isEqualTo: categoria)
          .get();

      final preguntasCategoria = snapshotCategoria.docs
          .map((doc) => Question.fromJson(doc.data()))
          .toList();

      todasLasPreguntas.addAll(preguntasCategoria);

      // 2. Preguntas de la categoría "todas"
      final snapshotGlobal = await _db
          .collection("preguntas")
          .where("categoria", isEqualTo: "todas")
          .get();

      final preguntasGlobales = snapshotGlobal.docs
          .map((doc) => Question.fromJson(doc.data()))
          .toList();

      todasLasPreguntas.addAll(preguntasGlobales);

      return todasLasPreguntas;
    } catch (e) {
      print("Error al cargar preguntas: $e");
      return [];
    }
  }
}
