import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import 'exam_page.dart';

class SimulacroSelectorPage extends StatefulWidget {
  const SimulacroSelectorPage({super.key});

  @override
  _SimulacroSelectorPageState createState() => _SimulacroSelectorPageState();
}

class _SimulacroSelectorPageState extends State<SimulacroSelectorPage> {
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    // Precargamos el anuncio para que esté listo cuando se necesite.
    _adService.loadPreExamInterstitialAd();
  }

  final List<Map<String, dynamic>> categorias = [
    {
      "nombre": "A-I (A1)",
      "codigo": "A1",
      "color": Colors.blue,
      "img": "lib/assets/img/AI.png",
    },
    {
      "nombre": "A-IIA (A2A)",
      "codigo": "A2A",
      "color": Colors.teal,
      "img": "lib/assets/img/AIIA.png",
    },
    {
      "nombre": "A-IIB (A2B)",
      "codigo": "A2B",
      "color": Colors.amber,
      "img": "lib/assets/img/AIIB.png",
    },
    {
      "nombre": "A-IIIA (A3A)",
      "codigo": "A3A",
      "color": Colors.deepPurple,
      "img": "lib/assets/img/AIIIA.png",
    },
    {
      "nombre": "A-IIIB (A3B)",
      "codigo": "A3B",
      "color": Colors.pink,
      "img": "lib/assets/img/AIIIB.png",
    },
    {
      "nombre": "A-IIIC (A3C)",
      "codigo": "A3C",
      "color": Colors.red,
      "img": "lib/assets/img/AIIIC.png",
    },
    {
      "nombre": "B-IIA (B2A)",
      "codigo": "B2A",
      "color": Colors.green,
      "img": "lib/assets/img/BIIA.png",
    },
    {
      "nombre": "B-IIB (B2B)",
      "codigo": "B2B",
      "color": Colors.orange,
      "img": "lib/assets/img/BIIB.png",
    },
    {
      "nombre": "B-IIC (B2C)",
      "codigo": "B2C",
      "color": Colors.lime,
      "img": "lib/assets/img/BIIC.png",
    },
  ];

  // Función que se llama al tocar una categoría.
  void _onCategorySelected(String categoria) {
    // Muestra el anuncio. Cuando el usuario lo cierre, navega a la página del examen.
    _adService.showPreExamInterstitialAd(onAdDismissed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExamPage(categoria: categoria),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elegir Categoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona una categoría',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Elige la categoría para la que deseas practicar. El examen constará de 40 preguntas aleatorias.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.9, // Ajusta esta relación si es necesario
                ),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  return GestureDetector(
                    onTap: () => _onCategorySelected(categoria['codigo'] as String),
                    child: Card(
                      elevation: 4,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                categoria['img'] as String,
                                // CORRECCIÓN: BoxFit.contain asegura que toda la imagen sea visible.
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 50,
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: categoria['color'] as Color,
                              child: Center(
                                child: Text(
                                  categoria['nombre'] as String,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
