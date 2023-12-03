# Application de notes avec firebase

Cette application de prise de notes vous permet de créer, modifier et supprimer des notes en utilisant Firebase pour le stockage des données.

## Configuration

### Firebase Setup

1.  Créez un projet Firebase sur [Firebase Console](https://console.firebase.google.com/).
2.  Ajoutez votre application Flutter à votre projet Firebase.
3.  Activez Firebase Authentication dans la console Firebase et configurez les méthodes d'authentification que vous souhaitez utiliser dans votre application (par exemple, e-mail/mot de passe, Google Sign-In, etc.).
4.  Activez Firebase Firestore pour la base de données Cloud Firestore.

### Configuration du projet Flutter

1.  Clonez ce dépôt ou téléchargez les fichiers source dans votre projet Flutter.
2.  Assurez-vous d'avoir ajouté les dépendances Firebase nécessaires dans votre fichier `pubspec.yaml` :
``` yaml
dependencies:
  firebase_core: ^1.10.0
  firebase_auth: ^4.3.0
  cloud_firestore: ^3.3.0
```
3.  Exécutez `flutter pub get` pour installer les dépendances.
  
## Utilisation de l'application

### Authentification

-   L'application nécessite une authentification pour gérer les notes.
-   Lors du lancement de l'application, l'utilisateur est redirigé vers l'écran d'authentification (par exemple, connexion par e-mail/mot de passe, Google Sign-In).
-   Une fois connecté, l'utilisateur peut accéder à ses notes.

### Fonctionnalités de l'application

-   **Liste des notes** : Affiche toutes les notes de l'utilisateur avec la possibilité de les modifier ou de les supprimer.
-   **Ajout de notes** : Permet d'ajouter de nouvelles notes en spécifiant un titre et un contenu.
-   **Modification de notes** : Permet de modifier le titre et le contenu d'une note existante.
-   **Suppression de notes** : Permet de supprimer une note en la faisant glisser ou en appuyant sur un bouton de suppression.
