// Classe représentant une enseigne
class Enseigne {
  final String name; // Nom de l'enseigne

  // Constructeur qui permet d'initialiser le nom de l'enseigne
  Enseigne({required this.name});

  @override
  // Redéfinition de la méthode toString pour afficher le nom de l'enseigne
  String toString() {
    return name; // Retourne le nom de l'enseigne en tant que chaîne de caractères
  }
}
