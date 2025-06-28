import 'package:flutter/material.dart';
import 'exam_page.dart';


class SimulacroSelectorPage extends StatelessWidget {
  const SimulacroSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categorias = [
      {"nombre": "A-I (A1)", "codigo": "AI", "color": Colors.blue, "img": "lib/assets/img/AI.png"},
      {"nombre": "A-IIA (A2A)", "codigo": "AIIA", "color": Colors.teal, "img": "lib/assets/img/AIIA.png"},
      {"nombre": "A-IIB (A2B)", "codigo": "AIIB", "color": Colors.amber, "img": "lib/assets/img/AIIB.png"},
      {"nombre": "A-IIIA (A3A)", "codigo": "AIIIA", "color": Colors.deepPurple, "img": "lib/assets/img/AIIIA.png"},
      {"nombre": "A-IIIB (A3B)", "codigo": "AIIIB", "color": Colors.pink, "img": "lib/assets/img/AIIIB.png"},
      {"nombre": "A-IIIC (A3C)", "codigo": "AIIIC", "color": Colors.red, "img": "lib/assets/img/AIIIC.png"},
      {"nombre": "B-IIA (B2A)", "codigo": "BIIA", "color": Colors.green, "img": "lib/assets/img/BIIA.png"},
      {"nombre": "B-IIB (B2B)", "codigo": "BIIB", "color": Colors.orange, "img": "lib/assets/img/BIIB.png"},
      {"nombre": "B-IIC (B2C)", "codigo": "BIIC", "color": Colors.lime, "img": "lib/assets/img/BIIC.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Elegir Categoría"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              "Selecciona una categoría",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              "Elige la categoría para la que deseas practicar.\nEl examen constará de 40 preguntas aleatorias.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: categorias.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 130,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExamPage(categoria: categoria["codigo"] as String),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: Image.asset(
                              categoria["img"] as String,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: categoria["color"] as Color,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            categoria["nombre"] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
