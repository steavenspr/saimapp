import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

/// Page de connexion de l'application

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Contrôleur pour gérer la saisie de l'identifiant
  final TextEditingController _usernameController = TextEditingController();

  // Contrôleur pour gérer la saisie du mot de passe
  final TextEditingController _passwordController = TextEditingController();

  // Indicateur d'état pour savoir si une connexion est en cours
  bool _isLoading = false;

  /// Fonction pour gérer la connexion de l'utilisateur
  // Vérifie les identifiants, affiche un indicateur de chargement et redirige en cas de succès
  void _login() async {
    setState(() => _isLoading = true);

    // Récupération de l'instance d'AuthController via Provider
    final authController = Provider.of<AuthController>(context, listen: false);

    // Tentative de connexion avec les identifiants saisis
    final success = await authController.login(
      _usernameController.text,
      _passwordController.text,
    );

    // Vérifie si le widget est toujours monté avant de modifier l'état
    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      // Redirection vers la page de recherche en cas de succès
      Navigator.pushReplacementNamed(context, '/recherche');
    } else {
      // Affiche un message d'erreur si la connexion échoue
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Identifiant ou mot de passe incorrect")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Affichage du logo de l'entreprise
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'SAIM Ltd',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),

          // Contenu principal de la page
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Affichage du logo
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 20),

                // Titre de l'application
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Suivi des lots',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Champs de saisie pour l'identifiant et le mot de passe
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      // Champ de saisie pour l'identifiant
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Identifiant',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Champ de saisie pour le mot de passe
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Bouton de connexion avec indicateur de chargement
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: _login,
                  child: const Text(
                    'S\'identifier',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
