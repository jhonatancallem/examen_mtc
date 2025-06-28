import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NombrePage extends StatefulWidget {
  const NombrePage({super.key});

  @override
  State<NombrePage> createState() => _NombrePageState();
}

class _NombrePageState extends State<NombrePage> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  void _onEmpezar() async {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) {
      setState(() {
        _error = "Por favor, ingresa tu nombre";
      });
      return;
    }

    // Guardar nombre en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', nombre);

    // Navegar a la página de inicio
    Navigator.pushReplacementNamed(context, '/home', arguments: nombre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF8FF), // color suave
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/imgD/pocoyo.png'),
              const SizedBox(height: 24),
              const Text(
                "Simulacro MTC\nPERÚ 2025",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "¿Cómo te llamas?",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Escribe tu nombre aquí',
                  errorText: _error,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onEmpezar,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Empezar', style: TextStyle(fontSize: 18)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
