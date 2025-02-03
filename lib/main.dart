import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/result_controller.dart';
import 'services/api_service.dart';
import 'views/login_page.dart';
import 'views/recherche_view.dart';
import 'views/result_display_screen.dart';
import 'controllers/recherche_controller.dart'; // Ajout

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService('http://192.168.230.13:93/api'); // Instance unique

    return MultiProvider(
      providers: [
        // Fournit ApiService (unique)
        Provider<ApiService>.value(value: apiService),

        // Fournit les contrôleurs dépendants d'ApiService
        ChangeNotifierProvider(create: (_) => AuthController(apiService)),
        ChangeNotifierProvider(create: (_) => ResultController(apiService)),

        // Ajoute RechercheController
        Provider(create: (_) => RechercheController(apiService)),
      ],
      child: MaterialApp(
        title: 'Application Résultats',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/recherche': (context) => const RecherchePage(),
          '/result': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
            return ResultDisplayScreen(
              dateDebut: args['dateDebut'],
              dateFin: args['dateFin'],
              enseignes: List<String>.from(args['enseignes'] ?? []),
            );
          },
        },
      ),
    );
  }
}
