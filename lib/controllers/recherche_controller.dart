import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/enseigne.dart';
import '../services/api_service.dart';
import '../controllers/auth_controller.dart';

class RechercheController {
  final ApiService apiService;

  // Injecter ApiService dans le constructeur pour une gestion centralisée des requêtes API
  RechercheController(this.apiService);

  /// Récupère la liste des enseignes en utilisant le token de l'utilisateur authentifié
  /// Lance une exception si l'utilisateur n'est pas authentifié
  Future<List<Enseigne>> fetchEnseignes(BuildContext context) async {
    // Récupérer le controller AuthController via Provider
    final authController = Provider.of<AuthController>(context, listen: false);

    // Vérifier si le token est null (non authentifié)
    final token = authController.token;
    if (token == null) {
      throw Exception("Utilisateur non authentifié."); // Exception si non authentifié
    }

    // Retourner la liste des enseignes via ApiService
    return await apiService.fetchEnseignes(token);
  }
}
