import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'pages/home_page.dart';
import 'pages/nombre_page.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  // Usamos un bloque try-catch para capturar cualquier error durante la inicialización.
  try {
    // Asegura que los componentes de Flutter estén listos.
    WidgetsFlutterBinding.ensureInitialized();

    // Inicializa el SDK de anuncios.
    MobileAds.instance.initialize();

    // Accede a la memoria del dispositivo para ver si hay un nombre guardado.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('nombre');

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MyApp(userName: userName),
      ),
    );
  } catch (e) {
    // Si ocurre un error durante el arranque, lo imprimiremos en la consola.
    print('Error fatal durante la inicialización: $e');
  }
}

class MyApp extends StatelessWidget {
  final String? userName;

  const MyApp({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Examen MTC',
          debugShowCheckedModeBanner: false,
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
          ),
          themeMode: themeProvider.themeMode,
          home: (userName != null && userName!.isNotEmpty)
              ? HomePage(userName: userName)
              : const NombrePage(),
        );
      },
    );
  }
}
