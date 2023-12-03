import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '/widget/note_editor.dart';
import '/widget/notes.dart';
import '/pages/auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _titleControllerNew = TextEditingController();
  final _contentControllerNew = TextEditingController();
  bool _isConnected = FirebaseAuth.instance.currentUser != null;

  Widget _widget() {
    if (FirebaseAuth.instance.currentUser == null) {
      return Center(
          child: ElevatedButton(
        onPressed: () async => {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthPage(),
            ),
          ),
          setState(() {
            _isConnected = FirebaseAuth.instance.currentUser != null;
          }),
        },
        child: const Text("Login page"),
      ));
    } else {
      return const Notes();
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference notes = FirebaseFirestore.instance.collection('notes');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_isConnected
            ? "Connected as : ${FirebaseAuth.instance.currentUser?.email}"
            : "Not connected"),
        actions: [
          if (!_isConnected)
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthPage(),
                  ),
                );
                setState(() {
                  _isConnected = FirebaseAuth.instance.currentUser != null;
                });
              },
              icon: const Icon(Icons.login),
            ),
          if (_isConnected)
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isConnected = FirebaseAuth.instance.currentUser != null;
                });
              },
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: _widget(),
      floatingActionButton: Visibility(
          visible: _isConnected,
          child: FloatingActionButton(
            onPressed: () => {
              showDialog(
                context: context,
                builder: (BuildContext context) => NoteEditorDialog(
                  titleController: _titleControllerNew,
                  contentController: _contentControllerNew,
                  onValidate: (_image) async {
                    late String name;
                    if (_image != null) {
                      File file = File(_image.path);
                      name =
                          "${DateTime.now().millisecondsSinceEpoch}_${_image!.name}";
                      try {
                        String filePath = name;
                        Reference ref =
                            FirebaseStorage.instance.ref().child(filePath);

                        // Téléverser le fichier
                        UploadTask uploadTask = ref.putFile(file);

                        // Attendre la fin du téléversement
                        TaskSnapshot snapshot = await uploadTask;

                        // Obtenir l'URL du fichier téléversé (facultatif)
                        String downloadUrl =
                            await snapshot.ref.getDownloadURL();
                        print('URL du fichier téléversé: $downloadUrl');

                        // Ici, vous pouvez également sauvegarder l'URL avec les autres informations de la note, par exemple dans Firestore.
                      } catch (e) {
                        print('Erreur lors du téléversement de l\'image: $e');
                        // Gérer l'erreur
                      }
                    }
                    DocumentReference docRef = await notes.add({
                      'title': _titleControllerNew.text,
                      'content': _contentControllerNew.text,
                      'user': FirebaseAuth.instance.currentUser?.uid,
                      'image': name,
                    });
                  },
                ),
              )
            },
            child: const Icon(Icons.add),
          )),
    );
  }
}
