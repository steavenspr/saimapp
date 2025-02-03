import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/result_model.dart';

class ResultController with ChangeNotifier {
  final ApiService _apiService;
  List<ResultModel> results = [];  // Liste pour stocker les résultats
  String errorMessage = '';  // Message d'erreur en cas de problème avec l'API
  bool isLoading = false;  // Variable pour indiquer si les résultats sont en cours de chargement

  // Constructeur pour injecter ApiService dans le contrôleur
  ResultController(this._apiService);

  /// Récupère les résultats en fonction du token, des dates et des enseignes spécifiées
  Future<void> fetchResults(String token, DateTime dateFrom, DateTime dateTo, String enseignes) async {
    isLoading = true;  // Début du chargement
    notifyListeners();  // Notifier les listeners pour rafraîchir l'interface

    try {
      // Appel à l'API pour récupérer les résultats
      final response = await _apiService.fetchResults(token, dateFrom, dateTo, enseignes);

      // Log de la réponse brute de l'API pour débogage
      print("Réponse de l'API: $response");

      // Vérification que la réponse n'est pas vide ou nulle
      if (response != null && response.isNotEmpty) {
        // Transformation de la réponse en une liste de ResultModel
        results = response.map<ResultModel>((data) => ResultModel.fromJson(data)).toList();
        errorMessage = '';  // Réinitialisation du message d'erreur en cas de succès

        // Log pour vérifier les résultats extraits
        for (var result in results) {
          print("Enseigne: ${result.title}, Couleur: ${result.color}");
        }
      } else {
        // Si la réponse est vide, on vide les résultats et on réinitialise l'erreur
        results = [];
        errorMessage = '';
      }
    } catch (e) {
      // Gestion des erreurs lors de l'appel API
      print("Erreur lors de la récupération des résultats: $e");
      if (e is Exception) {
        print("Exception: ${e.toString()}");
      }
      results = [];  // Réinitialisation des résultats en cas d'erreur
      errorMessage = 'Une erreur est survenue. Veuillez réessayer.';  // Message d'erreur générique
    } finally {
      isLoading = false;  // Fin du chargement
      notifyListeners();  // Notifier les listeners pour rafraîchir l'interface
    }
  }
}
