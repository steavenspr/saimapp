import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../controllers/recherche_controller.dart';
import '../controllers/auth_controller.dart';
import '../views/result_display_screen.dart';

/// Page principale de recherche avec filtrage et sélection de période.
class RecherchePage extends StatefulWidget {
  const RecherchePage({super.key});

  @override
  RecherchePageState createState() => RecherchePageState();
}

class RecherchePageState extends State<RecherchePage> {
  // Liste des états des cases à cocher pour les enseignes
  List<bool> checkboxValues = [];

  // Indicateur pour savoir si toutes les enseignes sont sélectionnées
  bool _toutesSelected = true;

  // Dates de début et de fin sélectionnées
  DateTime _dateDebut = DateTime.now();
  DateTime _dateFin = DateTime.now();

  // Liste des labels pour les enseignes
  List<String> checkboxLabels = [];

  // Indicateur de chargement
  bool isLoading = true;

  // Contrôleur pour la recherche des enseignes
  late RechercheController controller;

  @override
  void initState() {
    super.initState();
    // Initialisation du contrôleur avec le service API
    controller = RechercheController(Provider.of<ApiService>(context, listen: false));

    // Chargement des enseignes après que l'interface soit initialisée
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEnseignes();
    });
  }

  /// Fonction pour charger les enseignes via le contrôleur.
  Future<void> _loadEnseignes() async {
    try {
      final enseignes = await controller.fetchEnseignes(context);

      // Mise à jour de l'état après la récupération des enseignes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          checkboxLabels = enseignes.map((e) => e.name).toList();
          checkboxValues = List.filled(checkboxLabels.length, true);
          isLoading = false;
        });
      });
    } catch (e) {
      // En cas d'erreur, on affiche un message d'erreur
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche et Filtrage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Déconnexion de l'utilisateur
              authController.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Affichage du loader pendant le chargement
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPeriodSelectionCard(),
            const SizedBox(height: 16),
            _buildFilterOptionsCard(),
            const SizedBox(height: 16),
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  // Carte pour la sélection de la période de recherche
  Widget _buildPeriodSelectionCard() {
    return _buildCard(
      title: 'Sélectionnez une période',
      content: Column(
        children: [
          _buildPeriodDescription(),
          SizedBox(height: 16),
          _buildDateSelectors(),
        ],
      ),
    );
  }

  // Description de la période
  Widget _buildPeriodDescription() {
    return Text(
      'Veuillez choisir une date de début et une date de fin pour effectuer la recherche.',
      style: TextStyle(color: Colors.grey),
    );
  }

  // Carte pour les options de filtrage
  Widget _buildFilterOptionsCard() {
    return _buildCard(
      title: 'Options de filtrage',
      content: Column(
        children: [
          _buildFilterDescription(),
          SizedBox(height: 16),
          _buildSwitchToutes(),
          SizedBox(height: 16),
          _buildCheckboxGrid(),
        ],
      ),
    );
  }

  // Description des options de filtrage
  Widget _buildFilterDescription() {
    return Text(
      'Utilisez le switch "Toutes" pour sélectionner ou désélectionner toutes les options.',
      style: TextStyle(color: Colors.grey),
    );
  }

  // Bouton pour lancer la recherche
  Widget _buildSearchButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Vérification des dates avant de lancer la recherche
        if (_dateFin.isBefore(_dateDebut)) {
          _showErrorDialog('La date de fin ne peut pas être antérieure à la date de début.');
        } else {
          // Naviguer vers l'écran des résultats avec les paramètres de recherche
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultDisplayScreen(
                dateDebut: _dateDebut,
                dateFin: _dateFin,
                enseignes: _getSelectedEnseignes(),
              ),
            ),
          );
        }
      },
      icon: Icon(Icons.search, color: Colors.white),
      label: Text('Rechercher', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }

  // Affichage d'un message d'erreur dans une boîte de dialogue
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Carte générique avec titre et contenu
  Widget _buildCard({required String title, required Widget content}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  // Sélecteurs de dates (début et fin)
  Row _buildDateSelectors() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateSelector('Date Début', _dateDebut, true),
        SizedBox(width: 16),
        _buildDateSelector('Date Fin', _dateFin, false),
      ],
    );
  }

  // Sélecteur de date avec étiquette et icône de calendrier
  Expanded _buildDateSelector(String label, DateTime date, bool isStartDate) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(context, isStartDate),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${date.toLocal()}'.split(' ')[0]),
                  Icon(Icons.calendar_today, color: Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Switch pour sélectionner/désélectionner toutes les enseignes
  Row _buildSwitchToutes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Toutes', style: TextStyle(fontWeight: FontWeight.bold)),
        Switch(
          value: _toutesSelected,
          onChanged: (bool value) {
            setState(() {
              _toutesSelected = value;
              checkboxValues = List.filled(checkboxValues.length, _toutesSelected);
            });
          },
          activeColor: Colors.green,
        ),
      ],
    );
  }

  // Grille des cases à cocher pour les enseignes
  Widget _buildCheckboxGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: List.generate(checkboxValues.length, (index) {
        return _buildCheckbox(checkboxLabels[index], checkboxValues[index], index);
      }),
    );
  }

  // Case à cocher pour une enseigne donnée
  Widget _buildCheckbox(String label, bool value, int index) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            setState(() {
              checkboxValues[index] = newValue!;
              // Mise à jour de l'état du switch "Toutes"
              _toutesSelected = checkboxValues.every((val) => val);
            });
          },
          activeColor: Colors.blue,
        ),
        Expanded(child: Text(label, softWrap: true, style: TextStyle(fontSize: 12))),
      ],
    );
  }

  // Récupère les enseignes sélectionnées
  List<String> _getSelectedEnseignes() {
    return List.generate(checkboxLabels.length, (index) {
      return checkboxValues[index] ? checkboxLabels[index] : null;
    }).whereType<String>().toList(); // Évite les valeurs null
  }

  // Sélectionne une date via le picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _dateDebut : _dateFin,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _dateDebut = picked;
        } else {
          _dateFin = picked;
        }
      });
    }
  }
}
