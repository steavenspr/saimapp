import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/result_model.dart';

class ResultController with ChangeNotifier {
  final ApiService _apiService;
  List<ResultModel> results = [];
  String errorMessage = '';  // Ajout d'une propriété pour le message d'erreur

  ResultController(this._apiService);

  Future<void> fetchResults(String token, DateTime dateFrom, DateTime dateTo, String enseignes) async {
    try {
      // Appel à l'API pour récupérer les résultats
      final response = await _apiService.fetchResults(token, dateFrom, dateTo, enseignes);
      
      // Log de la réponse brute de l'API
      print("Réponse de l'API: $response");

      // Vérification que la réponse n'est pas vide
      if (response != null && response.isNotEmpty) {
        // Si la réponse est une liste, nous la transformons en une liste de ResultModel
        results = response.map<ResultModel>((data) => ResultModel.fromJson(data)).toList();
        errorMessage = '';  // Réinitialisation du message d'erreur

        // Log des résultats pour vérifier si les données sont correctes
        for (var result in results) {
          print("Enseigne: ${result.title}, Couleur: ${result.color}");
        }
      } else {
        results = [];
        errorMessage = '';
      }

      // Notifier les observateurs que les résultats ont été mis à jour
      notifyListeners();
    } catch (e) {
      // Log plus détaillé en cas d'erreur dans l'appel API
      print("Erreur lors de la récupération des résultats: $e");
      if (e is Exception) {
        print("Exception: ${e.toString()}");
      }
      results = [];
      errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
      notifyListeners();  // Notifier que l'erreur est survenue
    }
  }
}

/*class ResultController with ChangeNotifier {
  final ApiService _apiService;
  List<ResultModel> results = [];

  ResultController(this._apiService);

  Future<void> fetchResults(String token, DateTime dateFrom, DateTime dateTo, String enseignes) async {
    try {
      // Appel à l'API pour récupérer les résultats
      final response = await _apiService.fetchResults(token, dateFrom, dateTo, enseignes);
      
      // Log de la réponse brute de l'API
      print("Réponse de l'API: $response");

      // Vérification que la réponse n'est pas vide
      if (response != null && response.isNotEmpty) {
        // Si la réponse est une liste, nous la transformons en une liste de ResultModel
        results = response.map<ResultModel>((data) => ResultModel.fromJson(data)).toList();

        // Log des résultats pour vérifier si les données sont correctes
        for (var result in results) {
          print("Enseigne: ${result.title}, Couleur: ${result.color}");
        }

        // Notifier les observateurs que les résultats ont été mis à jour
        notifyListeners();
      } else {
        print("Aucune donnée reçue ou réponse vide.");
      }
    } catch (e) {
      // Log plus détaillé en cas d'erreur dans l'appel API
      print("Erreur lors de la récupération des résultats: $e");
      if (e is Exception) {
        print("Exception: ${e.toString()}");
      }
    }
  }
}*/
