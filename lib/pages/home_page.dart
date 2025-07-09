import 'dart:io';
import 'package:examen_mtc/pages/exam_page.dart';
import 'package:examen_mtc/pages/profile_page.dart';
import 'package:examen_mtc/pages/study_category_page.dart';
import 'package:examen_mtc/pages/simulacro_selector_page.dart';
import 'package:examen_mtc/pages/study_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import 'history_page.dart';
import '../services/ad_service.dart';

class HomePage extends StatefulWidget {
  final String? userName;

  const HomePage({super.key, this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    _adService.loadPreExamInterstitialAd(); // <-- Precarga el primer anuncio al iniciar la página
  }

  final categorias = [
    {
      "nombre": "A-I (A1)",
      "codigo": "A1",
      "color": Colors.blue,
      "img": "lib/assets/img/AI.png",
      "descripcion": "Es la licencia más común para manejar vehículos particulares como sedanes, coupé, hatchback, convertibles, station wagon, areneros, pickup y furgones. Es básica para las demás licencias de clase A."
    },
    {
      "nombre": "A-IIA (A2A)",
      "codigo": "A2A",
      "color": Colors.teal,
      "img": "lib/assets/img/AIIA.png",
      "descripcion": "Autoriza a conducir los vehículos de la categoría A1 y, adicionalmente, vehículos de transporte de pasajeros como taxis, buses, ambulancias y transporte interprovincial."
    },
    {
      "nombre": "A-IIB (A2B)",
      "codigo": "A2B",
      "color": Colors.amber,
      "img": "lib/assets/img/AIIB.png",
      "descripcion": "Autoriza a conducir los vehículos de las categorías A1 y A2A y, adicionalmente, vehículos de carga como furgones y camiones de hasta 12 toneladas."
    },
    {
      "nombre": "A-IIIA (A3A)",
      "codigo": "A3A",
      "color": Colors.deepPurple,
      "img": "lib/assets/img/AIIIA.png",
      "descripcion": "Autoriza a conducir los vehículos de las categorías A1, A2A y A2B y, adicionalmente, vehículos de transporte de pasajeros sin límite de asientos."
    },
    {
      "nombre": "A-IIIB (A3B)",
      "codigo": "A3B",
      "color": Colors.pink,
      "img": "lib/assets/img/AIIIB.png",
      "descripcion": "Autoriza a conducir los vehículos de las categorías A1, A2A, A2B y, adicionalmente, vehículos de carga sin límite de peso."
    },
    {
      "nombre": "A-IIIC (A3C)",
      "codigo": "A3C",
      "color": Colors.red,
      "img": "lib/assets/img/AIIIC.png",
      "descripcion": "Autoriza a conducir los vehículos de todas las categorías anteriores (A1, A2A, A2B, A3A, A3B) de forma irrestricta."
    },
    {
      "nombre": "B-IIA (B2A)",
      "codigo": "B2A",
      "color": Colors.green,
      "img": "lib/assets/img/BIIA.png",
      "descripcion": "Autoriza a conducir bicimotos, para transportar pasajeros o mercancías."
    },
    {
      "nombre": "B-IIB (B2B)",
      "codigo": "B2B",
      "color": Colors.orange,
      "img": "lib/assets/img/BIIB.png",
      "descripcion": "Autoriza a conducir los mismos vehículos que una licencia B-IIa y también motocicletas (2 ruedas) o motocicletas con sidecar (3 ruedas)."
    },
    {
      "nombre": "B-IIC (B2C)",
      "codigo": "B2C",
      "color": Colors.lime,
      "img": "lib/assets/img/BIIC.png",
      "descripcion": "Autoriza a conducir los mismos vehículos que una licencia B-IIb y también mototaxis y trimotos con fines comerciales."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Escuchamos al UserProvider para que la AppBar se actualice si cambia el nombre
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${userProvider.userName ?? widget.userName ?? ''}'),
        backgroundColor: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
        foregroundColor: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onPrimary,
        elevation: 1,
      ),
      drawer: _buildDrawer(context),
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
                mainAxisExtent: 170,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return GestureDetector(
                  onTap: () {
                    _showLicenseDialog(
                      context,
                      categoria['nombre'] as String,
                      categoria['codigo'] as String,
                      categoria['descripcion'] as String,
                      categoria['img'] as String,
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              categoria["img"] as String,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported, color: Colors.grey, size: 40);
                              },
                            ),
                          ),
                        ),
                        Container(
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
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // Usamos Consumer para que el header del Drawer se actualice automáticamente
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  userProvider.userName ?? 'Usuario',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                accountEmail: const Text(''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: userProvider.profileImagePath != null
                      ? FileImage(File(userProvider.profileImagePath!))
                      : null,
                  child: userProvider.profileImagePath == null
                      ? const Icon(Icons.person, size: 50, color: Colors.blue)
                      : null,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Perfil'),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  // Navega a la nueva página de perfil
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.history_outlined),
                title: const Text('Historial'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time_outlined),
                title: const Text('Simulacro'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SimulacroSelectorPage()));
                },
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Modo Oscuro'),
                value: themeProvider.themeMode == ThemeMode.dark,
                secondary: const Icon(Icons.dark_mode_outlined),
                onChanged: (bool value) {
                  themeProvider.setTheme(value);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Configuraciones'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Acerca de'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLicenseDialog(BuildContext context, String name, String code,
      String description, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                  Image.asset(imagePath, height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, color: Colors.grey, size: 80);
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExamPage(categoria: code)),
                      );
                    },
                    child: const Text('Examen Simulacro',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudyCategoryPage(
                                categoriaCodigo: code, categoriaNombre: name)),
                      );
                    },
                    child: const Text('Estudiar Preguntas',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
