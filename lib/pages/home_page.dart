import 'package:flutter/material.dart';
import 'study_page.dart';
import 'simulacro_selector_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _nombre = ''; // Variable para almacenar el nombre

  @override
  void initState() {
    super.initState();
    _getNombre(); // Cargar el nombre desde SharedPreferences
  }

  // Método para recuperar el nombre desde SharedPreferences
  void _getNombre() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nombre = prefs.getString('nombre');

    if (nombre != null) {
      setState(() {
        _nombre = nombre;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorias = [
      {
        "nombre": "A-I (A1)",
        "codigo": "AI",
        "color": Colors.blue,
        "img": "lib/assets/img/AI.png"
      },
      {
        "nombre": "A-IIA (A2A)",
        "codigo": "AIIA",
        "color": Colors.teal,
        "img": "lib/assets/img/AIIA.png"
      },
      {
        "nombre": "A-IIB (A2B)",
        "codigo": "AIIB",
        "color": Colors.amber,
        "img": "lib/assets/img/AIIB.png"
      },
      {
        "nombre": "A-IIIA (A3A)",
        "codigo": "AIIIA",
        "color": Colors.deepPurple,
        "img": "lib/assets/img/AIIIA.png"
      },
      {
        "nombre": "A-IIIB (A3B)",
        "codigo": "AIIIB",
        "color": Colors.pink,
        "img": "lib/assets/img/AIIIB.png"
      },
      {
        "nombre": "A-IIIC (A3C)",
        "codigo": "AIIIC",
        "color": Colors.red,
        "img": "lib/assets/img/AIIIC.png"
      },
      {
        "nombre": "B-IIA (B2A)",
        "codigo": "BIIA",
        "color": Colors.green,
        "img": "lib/assets/img/BIIA.png"
      },
      {
        "nombre": "B-IIB (B2B)",
        "codigo": "BIIB",
        "color": Colors.orange,
        "img": "lib/assets/img/BIIB.png"
      },
      {
        "nombre": "B-IIC (B2C)",
        "codigo": "BIIC",
        "color": Colors.lime,
        "img": "lib/assets/img/BIIC.png"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $_nombre'), // Mostrar el nombre aquí
        backgroundColor: Colors.blue,
        actions: const [
          Icon(Icons.menu),
          SizedBox(width: 16),
          Icon(Icons.home),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              'Examen Teórico MTC',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOpcionButton(Icons.book, 'Estudiar', context),
                _buildOpcionButton(Icons.access_time, 'Simulacro', context),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Categorías de Licencias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
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
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionButton(IconData icon, String label, BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        if (label == 'Estudiar') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudyPage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SimulacroSelectorPage()),
          );
        }
      },
      icon: Icon(icon, size: 26),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 3,
      ),
    );
  }
}
