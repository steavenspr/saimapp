import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController with ChangeNotifier {
  final ApiService _apiService;
  String? _token;

  AuthController(this._apiService);

  // Getter pour récupérer le token
  String? get token => _token;

  /// Charge le token depuis les préférences partagées
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    print("Token chargé: $_token"); // Log pour vérifier que le token est chargé
    if (_token == null) {
      print("Aucun token trouvé. Utilisateur non authentifié.");
    }
    notifyListeners(); // Notifie les listeners que l'état a changé
  }

  /// Effectue la connexion de l'utilisateur
  /// Sauvegarde le token dans les préférences partagées
  Future<bool> login(String username, String password) async {
    final fetchedToken = await _apiService.authenticate(username, password);
    if (fetchedToken != null) {
      _token = fetchedToken;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', fetchedToken); // Sauvegarde du token dans les préférences
      print("Token sauvegardé: $_token");
      notifyListeners(); // Notifie les listeners du changement d'état
      return true; // Connexion réussie
    }
    return false; // Connexion échouée
  }

  /// Déconnecte l'utilisateur
  /// Supprime le token des préférences partagées
  void logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Suppression du token
    print("Token supprimé");
    notifyListeners(); // Notifie les listeners que l'utilisateur a été déconnecté
  }
}
