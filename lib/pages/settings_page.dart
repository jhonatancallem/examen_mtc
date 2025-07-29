import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_provider.dart';
import 'nombre_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Función para mostrar un diálogo de confirmación
  Future<void> _showConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  // Función para borrar el historial de exámenes
  void _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('exam_history');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Historial de exámenes borrado.')),
    );
  }

  // Función para borrar los datos del usuario y reiniciar la app
  void _clearUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.clearUser();

    // Navegamos a la página de nombre y eliminamos todas las rutas anteriores
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const NombrePage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Borrar historial de exámenes'),
            subtitle: const Text('Se eliminarán todos los resultados guardados.'),
            onTap: () {
              _showConfirmationDialog(
                title: 'Confirmar Acción',
                content: '¿Estás seguro de que deseas borrar todo tu historial de exámenes? Esta acción no se puede deshacer.',
                onConfirm: _clearHistory,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_remove_outlined),
            title: const Text('Borrar datos de usuario'),
            subtitle: const Text('Se eliminará tu nombre y foto de perfil.'),
            onTap: () {
              _showConfirmationDialog(
                title: 'Confirmar Acción',
                content: '¿Estás seguro de que deseas borrar tus datos? La aplicación se reiniciará.',
                onConfirm: _clearUserData,
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Notificaciones de estudio'),
            subtitle: const Text('Recibir recordatorios para practicar.'),
            value: false, // Valor de ejemplo
            onChanged: (bool value) {
              // Lógica para activar/desactivar notificaciones
            },
            secondary: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
    );
  }
}
