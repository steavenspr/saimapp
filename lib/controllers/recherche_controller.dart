import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/enseigne.dart';
import '../services/api_service.dart';
import '../controllers/auth_controller.dart';

class RechercheController {
  final ApiService apiService;

  RechercheController(this.apiService);

  Future<List<Enseigne>> fetchEnseignes(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final token = authController.token;

    if (token == null) {
      throw Exception("Utilisateur non authentifié.");
    }

    return await apiService.fetchEnseignes(token);
  }
}
