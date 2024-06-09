import 'package:flutter/material.dart'; // Package pour créer des interfaces utilisateur.
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Package pour charger des variables d'environnement.
import 'package:firebasetest/views/home_page.dart'; // Importation de la page d'accueil de l'application.

// Fonction principale de l'application.
void main() async {
  // Chargement des variables d'environnement à partir d'un fichier ".env".
  await dotenv.load(fileName: ".env");

  // Lancement de l'application en créant une instance de MyApp.
  runApp(const MyApp());
}

// Classe principale de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Méthode build qui définit l'interface utilisateur de l'application.
  @override
  Widget build(BuildContext context) {
    // Retourne un MaterialApp, qui est la structure de base de l'application.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Titre de l'application.
      title: 'Movies List',
      // Thème de l'application avec une couleur de base teal (bleu-vert).
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // Page d'accueil de l'application.
      home: const HomePage(),
    );
  }
}


