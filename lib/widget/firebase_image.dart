import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyImageWidget extends StatelessWidget {
  final String imagePath;

  const MyImageWidget({super.key, required this.imagePath});

  /*Future<String> getImageUrl(String imagePath) async {
    return await FirebaseStorage.instance
        .ref("notes/$imagePath")
        .getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageUrl(imagePath),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Image.network(snapshot.data!);
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return Text('Erreur lors du chargement de l\'image');
      },
    );
  }*/

  Future<String?> getImageUrl(String imagePath) async {
    try {
      String downloadURL =
          await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Il n\'y a pas d\'image associee a cette note: $e');
      return null; // Renvoie null en cas d'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getImageUrl(imagePath),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Image.network(
            snapshot.data!,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const SizedBox(); // Ne rien afficher si l'image ne charge pas
            },
          );
        } else {
          return const SizedBox(); // Affiche un texte si l'image n'existe pas ou en cas d'erreur
        }
      },
    );
  }
}
