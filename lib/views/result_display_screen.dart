import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/result_controller.dart';
import '../models/result_model.dart';

class ResultDisplayScreen extends StatefulWidget {
  final DateTime dateDebut;
  final DateTime dateFin;
  final List<String> enseignes;

  const ResultDisplayScreen({
    super.key,
    required this.dateDebut,
    required this.dateFin,
    required this.enseignes,
  });

  @override
  ResultDisplayScreenState createState() => ResultDisplayScreenState();
}

class ResultDisplayScreenState extends State<ResultDisplayScreen> {
  @override
  void initState() {
    super.initState();
    final resultController = Provider.of<ResultController>(context, listen: false);
    resultController.fetchResults(
      context.read<AuthController>().token!,
      widget.dateDebut,
      widget.dateFin,
      widget.enseignes.join(','),
    );
  }

@override
Widget build(BuildContext context) {
  final resultController = Provider.of<ResultController>(context);
  final authController = Provider.of<AuthController>(context);

  return Scaffold(
    appBar: AppBar(
      title: const Text("Résultats"),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            authController.logout();  // Log out the user
            Navigator.pushReplacementNamed(context, '/login');  // Navigate to login screen
          },
        ),
      ],
    ),
    body: resultController.errorMessage.isNotEmpty
        ? Center(
            child: Text(
              resultController.errorMessage,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          )
        : resultController.results.isEmpty
            ? const Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 30, 10, 206)),
                ),
              )
            : ListView.builder(
                itemCount: resultController.results.length,
                itemBuilder: (context, index) {
                  final result = resultController.results[index];
                  return _buildResultCard(result);
                },
              ),
  );
}


  Widget _buildResultCard(ResultModel result) {
    return Card(
      color: getColorForEnseigne(result.title),
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn("Lots/ND en cours", result.lotsEnCours),
                _buildColumn("Lots/ND du jour", result.lotsDuJour),
              ],
            ),
            const Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn("Traités", result.traite.toString()),
                _buildColumn("Non Traités", result.nonTraite.toString()),
                _buildColumn("Rejet", result.rejet.toString()),
                _buildColumn("Export", result.export.toString()),
              ],
            ),
            const Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn("Total", result.total.toString()),
                _buildColumn("Reco", result.reco.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Color getColorForEnseigne(String enseigne) {
    switch (enseigne.toUpperCase()) {
      case "REDER":
        return const Color(0xFF9C27B0);
      case "TDP":
        return const Color(0xFF536DFE);
      case "TDP LAD":
        return const Color(0xFFD50000);
      case "TRAD":
        return const Color(0xFFF9A825);
      case "VLM":
        return const Color(0xFF212121);
      case "RVI":
        return const Color(0xFF33691E);
      case "FRL":
        return const Color(0xFF00897B);
      case "FRL LAD":
        return const Color(0xFF006064);
      case "FRL CHQ":
        return const Color(0xFF1A237E);
      case "ALIM":
        return const Color(0xFF4A148C);
      case "LFG":
        return const Color(0xFF263238);
      case "RED LAD":
        return const Color(0xFF6D4C41);
      default:
        return Colors.grey;
    }
  }
}
