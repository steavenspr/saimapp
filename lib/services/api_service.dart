import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/enseigne.dart';
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // --- Authentification ---
  // Cette méthode envoie les informations de connexion (nom d'utilisateur et mot de passe)
  // pour obtenir un token d'authentification.
  Future<String?> authenticate(String username, String password) async {
    final url = Uri.parse('$baseUrl/AuthManagement/Login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["token"];  // Retourne le token en cas de succès
      } else {
        print("Erreur de connexion : ${response.body}");
        return null;  // Retourne null en cas d'erreur
      }
    } catch (e) {
      print("Erreur lors de l'authentification : $e");
      return null;  // Retourne null en cas d'exception
    }
  }

  // --- Récupération des résultats ---
  // Cette méthode récupère les résultats entre deux dates pour une ou plusieurs enseignes.
  // Elle prend en paramètre un token d'authentification et formate les dates selon un format spécifique.
  Future<List<dynamic>?> fetchResults(String token, DateTime dateFrom, DateTime dateTo, String enseignes) async {
    final url = Uri.parse('$baseUrl/Preview/previews').replace(queryParameters: {
      "Datefrom": DateFormat("dd/MM/yyyy").format(dateFrom),  // Formatage de la date de début
      "Dateto": DateFormat("dd/MM/yyyy").format(dateTo),      // Formatage de la date de fin
      "Enseignes": enseignes,  // Liste des enseignes filtrées
    });

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},  // Envoi du token dans l'en-tête
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];  // Retourne les résultats sous forme de liste
      } else {
        print("Erreur API : ${response.body}");
        return null;  // Retourne null en cas d'erreur
      }
    } catch (e) {
      print("Erreur lors de la récupération des résultats : $e");
      return null;  // Retourne null en cas d'exception
    }
  }

  // --- Récupération de la liste des enseignes ---
  // Cette méthode récupère la liste des enseignes disponibles et les retourne sous forme de liste d'objets Enseigne.
  // Elle prend un token pour l'authentification.
  Future<List<Enseigne>> fetchEnseignes(String token) async {
    final url = Uri.parse('$baseUrl/Preview/enseigneList');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',  // Envoi du token dans l'en-tête
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
          final data = decodedResponse['data'];
          if (data is List) {
            // Mapping des données en objets Enseigne
            return data.map((item) {
              if (item is String) {
                return Enseigne(name: item);  // Si l'élément est une chaîne, on crée un objet Enseigne
              } else if (item is Map<String, dynamic>) {
                // Si l'élément est un objet complexe, on mappe les propriétés en objet Enseigne
                return Enseigne(name: item['name'] ?? 'Nom inconnu');
              }
              throw Exception('Format inattendu pour un item de la liste des enseignes');
            }).toList();
          } else {
            throw Exception('La clé "data" ne contient pas une liste.');
          }
        } else {
          throw Exception('Réponse malformée : clé "data" manquante.');
        }
      } else {
        throw Exception('Erreur API : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur lors de la récupération des enseignes : $e");
      rethrow; // Relance l'exception pour la gestion côté appelant
    }
  }
}
