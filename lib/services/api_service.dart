import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/enseigne.dart'; // Modèle Enseigne
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  /// Authentifie l'utilisateur et retourne un token
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
        return data["token"];
      } else {
        print("Erreur de connexion : ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erreur lors de l'authentification : $e");
      return null;
    }
  }

  /// Récupère les résultats entre deux dates pour une enseigne donnée
Future<List<dynamic>?> fetchResults(String token, DateTime dateFrom, DateTime dateTo, String enseignes) async {
  final url = Uri.parse('$baseUrl/Preview/previews').replace(queryParameters: {
    "Datefrom": DateFormat("dd/MM/yyyy").format(dateFrom), // Formatage ici
    "Dateto": DateFormat("dd/MM/yyyy").format(dateTo),     // Formatage ici
    "Enseignes": enseignes,
  });

  try {
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      print("Erreur API : ${response.body}");
      return null;
    }
  } catch (e) {
    print("Erreur lors de la récupération des résultats : $e");
    return null;
  }
}

  /// Récupère la liste des enseignes
  Future<List<Enseigne>> fetchEnseignes(String token) async {
    final url = Uri.parse('$baseUrl/Preview/enseigneList');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
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
                return Enseigne(name: item);
              } else if (item is Map<String, dynamic>) {
                // Si l'item est un objet complexe, ajustez ce mapping selon votre modèle
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
