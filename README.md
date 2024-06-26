# Movie List

## À Propos du Projet

Movie List est une application mobile développée en Flutter, conçue pour interagir avec une API de films. L'application affiche une liste de films provenant d'une API et permet aux utilisateurs de consulter les détails de chaque film (année, description, noms des acteurs proncipaux, note), y compris les bandes-annonces vidéo.

## Fonctionnalités Clés

- **Liste de Films :** Affichage d'une liste de films obtenus via une API.
- **Détails des Films :** Affichage des détails de chaque film, y compris la bande-annonce et les acteurs principaux.
- **Notation des Films :** Note des films avec des étoiles obtenus via l'API.

## Dépendances Externes

- `http` pour effectuer des requêtes HTTP vers l'API des films.
- `youtube_player_flutter` pour afficher les bandes-annonces vidéo des films.
- `flutter_rating_bar` pour les évaluations de films.
- `flutter_dotenv` pour la gestion des variables d'environnement.

Ces dépendances seront automatiquement installées lors de l'exécution de la commande `flutter pub get`.


## Captures d'écran

<p align="center">
  <img src="assets/images/1.png" alt="Capture d'écran 1" width="200"/>
  <img src="assets/images/2.png" alt="Capture d'écran 2" width="200"/>
  <img src="assets/images/3.png" alt="Capture d'écran 3" width="200"/>
</p>

## Technologies Utilisées

- **Framework :** Flutter
- **Langage :** Dart

## Installation

### Prérequis

- Flutter doit être installé sur votre machine. Pour plus d'informations, consultez la documentation officielle de Flutter : [Installation Flutter](https://flutter.dev/docs/get-started/install)


### Cloner le projet depuis GitHub :

```
https://github.com/barseille/movie_list.git
```

### Installer les dépendances :

```
flutter pub get
```

### Exécuter l'application :

Lancez l'application sur un émulateur ou un appareil réel :
```
flutter run
```

