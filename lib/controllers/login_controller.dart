import '../services/api_service.dart';

class LoginController {
  final ApiService _apiService;

  // Injecter ApiService dans le constructeur pour une gestion centralisée des requêtes API
  LoginController(this._apiService);

  /// Effectue la connexion de l'utilisateur en vérifiant les identifiants
  /// Retourne un message en fonction du résultat de la tentative de connexion
  Future<String> login({required String username, required String password}) async {
    // Vérifier si les champs sont vides
    if (username.isEmpty || password.isEmpty) {
      return "Veuillez remplir tous les champs"; // Message d'erreur pour champs vides
    }

    try {
      // Appel à la méthode authenticate pour récupérer le token
      final token = await _apiService.authenticate(username, password);

      if (token != null) {
        return "success"; // Connexion réussie si un token est retourné
      } else {
        return "Identifiant ou mot de passe incorrect"; // Authentification échouée
      }
    } catch (e) {
      // Gérer les erreurs survenues durant l'appel API
      return "Erreur : ${e.toString()}"; // Retourner l'exception sous forme de message
    }
  }
}
