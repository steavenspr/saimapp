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

  factory ResultModel.fromJson(Map<String, dynamic> json) {
      // Log de la réponse brute

  
    // Récupération et correction des valeurs pour éviter les négatifs
    int nbLotencours = (json['nbLotencours'] ?? 0) < 0 ? 0 : json['nbLotencours'];
    int plisencours = (json['plisencours'] ?? 0) < 0 ? 0 : json['plisencours'];
    int lotjour = (json['lotjour'] ?? 0) < 0 ? 0 : json['lotjour'];
    int plijour = (json['plijour'] ?? 0) < 0 ? 0 : json['plijour'];

    return ResultModel(
      title: json['enseigne'] ?? "Inconnu",
      color: 0xFF000000, // Couleur par défaut
      lotsEnCours: "$nbLotencours / $plisencours",
      lotsDuJour: "$lotjour / $plijour",
      traite: (json['pliTraites'] ?? 0) < 0 ? 0 : json['pliTraites'],
      nonTraite: (json['nbPlinonTraites'] ?? 0) < 0 ? 0 : json['nbPlinonTraites'],
      rejet: (json['nbPliRejected'] ?? 0) < 0 ? 0 : json['nbPliRejected'],
      export: (json['nbpliexporte'] ?? 0) < 0 ? 0 : json['nbpliexporte'],
      total: (json['plisavecencours'] ?? 0) < 0 ? 0 : json['plisavecencours'],
      reco: (json['nbLotsreco'] ?? 0) < 0 ? 0 : json['nbLotsreco'],
    );
  }
}
