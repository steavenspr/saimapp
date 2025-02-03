import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/result_controller.dart';
import 'controllers/recherche_controller.dart'; // Ajout
import 'services/api_service.dart';
import 'views/login_page.dart';
import 'views/recherche_view.dart';
import 'views/result_display_screen.dart';

void main() {
  runApp(const MyApp());
}

/// La classe qui est le point d'entrée de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Création d'une instance unique d'ApiService pour être utilisée dans toute l'application
    final ApiService apiService = ApiService('http://192.168.230.13:93/api');

    return MultiProvider(
      providers: [
        // Fournit ApiService en tant que service unique
        Provider<ApiService>.value(value: apiService),

        // Fournit les contrôleurs dépendant d'ApiService
        ChangeNotifierProvider(create: (_) => AuthController(apiService)),
        ChangeNotifierProvider(create: (_) => ResultController(apiService)),
        Provider(create: (_) => RechercheController(apiService)), // Ajout du RechercheController
      ],
      child: MaterialApp(
        title: 'Application Résultats',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/recherche': (context) => const RecherchePage(),
          '/result': (context) {
            // Récupération des arguments passés à la route
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

            // Vérification des arguments avant de les utiliser pour éviter les erreurs
            return ResultDisplayScreen(
              dateDebut: args?['dateDebut'] ?? '',
              dateFin: args?['dateFin'] ?? '',
              enseignes: List<String>.from(args?['enseignes'] ?? []),
            );
          },
        },
      ),
    );
  }
}
