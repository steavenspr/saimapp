class ResultModel {
  final String title;
  final int color; // Couleur au format ARGB
  final String lotsEnCours;
  final String lotsDuJour;
  final int traite;
  final int nonTraite;
  final int rejet;
  final int export;
  final int total;
  final int reco;

  ResultModel({
    required this.title,
    required this.color,
    required this.lotsEnCours,
    required this.lotsDuJour,
    required this.traite,
    required this.nonTraite,
    required this.rejet,
    required this.export,
    required this.total,
    required this.reco,
  });

  // Fonction utilitaire pour éviter les négatifs
  static int _getNonNegativeValue(dynamic value) {
    return (value ?? 0) < 0 ? 0 : value;
  }

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    // Log de la réponse brute (en option, à ajouter si nécessaire)
    // print("Réponse brute : $json");

    // Récupération et correction des valeurs pour éviter les négatifs
    int nbLotencours = _getNonNegativeValue(json['nbLotencours']);
    int plisencours = _getNonNegativeValue(json['plisencours']);
    int lotjour = _getNonNegativeValue(json['lotjour']);
    int plijour = _getNonNegativeValue(json['plijour']);
    int pliTraites = _getNonNegativeValue(json['pliTraites']);
    int nbPlinonTraites = _getNonNegativeValue(json['nbPlinonTraites']);
    int nbPliRejected = _getNonNegativeValue(json['nbPliRejected']);
    int nbpliexporte = _getNonNegativeValue(json['nbpliexporte']);
    int plisavecencours = _getNonNegativeValue(json['plisavecencours']);
    int nbLotsreco = _getNonNegativeValue(json['nbLotsreco']);

    return ResultModel(
      title: json['enseigne'] ?? "Inconnu",
      color: 0xFF000000, // Couleur par défaut
      lotsEnCours: "$nbLotencours / $plisencours",
      lotsDuJour: "$lotjour / $plijour",
      traite: pliTraites,
      nonTraite: nbPlinonTraites,
      rejet: nbPliRejected,
      export: nbpliexporte,
      total: plisavecencours,
      reco: nbLotsreco,
    );
  }
}
