import '../services/api_service.dart';

class LoginController {
  final ApiService _apiService;

  // Injecter ApiService
  LoginController(this._apiService);

  Future<String> login({required String username, required String password}) async {
    if (username.isEmpty || password.isEmpty) {
      return "Veuillez remplir tous les champs";
    }

    try {
      // Appel de la méthode authenticate
      final token = await _apiService.authenticate(username, password);

      if (token != null) {
        return "success"; // Connexion réussie
      } else {
        return "Identifiant ou mot de passe incorrect"; // Authentification échouée
      }
    } catch (e) {
      return "Erreur : ${e.toString()}"; // Gérer les exceptions
    }
  }

}
