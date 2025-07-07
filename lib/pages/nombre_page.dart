import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class NombrePage extends StatefulWidget {
  const NombrePage({super.key});

  @override
  _NombrePageState createState() => _NombrePageState();
}

class _NombrePageState extends State<NombrePage> {
  final _nombreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _guardarNombreYContinuar() async {
    // Valida que el campo de texto no esté vacío.
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;

      // 1. Guardar el nombre en la memoria del dispositivo.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('nombre', nombre);

      // 2. Navegar a HomePage, reemplazando esta pantalla para que no se pueda volver atrás.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userName: nombre),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // El Scaffold se asegura de que la vista se ajuste cuando aparece el teclado.
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        // SingleChildScrollView permite que el contenido se desplace si el teclado lo cubre.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Asegúrate de tener esta imagen en tus assets.
                Image.asset(
                  'lib/assets/imgD/pocoyo.png', // Ruta de tu imagen
                  height: 180,
                  errorBuilder: (context, error, stackTrace) {
                    // Muestra un ícono si la imagen no se encuentra.
                    return const Icon(Icons.image_not_supported, size: 180, color: Colors.grey);
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Simulacro MTC\nPERÚ 2025',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  '¿Cómo te llamas?',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nombreController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Escribe tu nombre aquí',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _guardarNombreYContinuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Empezar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
