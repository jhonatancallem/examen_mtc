import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '...';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  // Función para abrir el enlace de la Play Store
  void _launchURL() async {
    // Reemplaza con el enlace real de tu app cuando la publiques
    final url = Uri.parse('https://play.google.com/store/apps/details?id=com.jhonatandev.examenmtc');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Manejo de error si no se puede abrir el enlace
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/mtc.png', height: 100),
              const SizedBox(height: 16),
              const Text(
                'Simulacro Examen MTC Perú',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text('Versión $_version'),
              const SizedBox(height: 24),
              const Text(
                'Desarrollado por Jhonatan Hasael',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '© 2025 - Todos los derechos reservados',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              const Text(
                'Esta aplicación utiliza el balotario de preguntas oficial proporcionado por el Ministerio de Transportes y Comunicaciones del Perú (MTC) como material de estudio.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.star_border),
                label: const Text('Calificar la aplicación'),
                onPressed: _launchURL,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
