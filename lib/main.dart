import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'pages/nombre_page.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  // Asegura que los componentes de Flutter estén listos antes de usarlos.
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // Accede a la memoria del dispositivo para ver si hay un nombre guardado.
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userName = prefs.getString('nombre');

  runApp(
    // Usamos MultiProvider para poder registrar varios providers a la vez.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // Añadimos el UserProvider aquí
      ],
      child: MyApp(userName: userName),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? userName;

  const MyApp({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    // Usamos un 'Consumer' para escuchar los cambios en el ThemeProvider.
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Examen MTC',
          debugShowCheckedModeBanner: false,
          // Definimos los temas para claro y oscuro
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              )),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            // Puedes personalizar más colores para el modo oscuro aquí
          ),
          // El modo del tema se obtiene del provider
          themeMode: themeProvider.themeMode,
          home: (userName != null && userName!.isNotEmpty)
              ? HomePage(userName: userName)
              : const NombrePage(),
        );
      },
    );
  }
}
