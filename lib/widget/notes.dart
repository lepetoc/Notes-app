import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import './firebase_image.dart';
import '/widget/note_editor.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late XFile? _image;

  @override
  Widget build(BuildContext context) {
    dynamic notes = FirebaseFirestore.instance
        .collection('notes')
        .where("user", isEqualTo: FirebaseAuth.instance.currentUser?.uid);
    return StreamBuilder<QuerySnapshot>(
      stream: notes.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Dismissible(
                background: Container(
                  color: Colors.red,
                ),
                key: Key(document.id),
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('notes')
                        .doc(document.id)
                        .delete();
                  });
                },
                child: ListTile(
                  title: Text(data['title']),
                  subtitle: Column(
                    children: [
                      Text(data['content']),
                      MyImageWidget(imagePath: data['image'] ?? "",),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      _titleController.text = data['title'];
                      _contentController.text = data['content'];
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => NoteEditorDialog(
                          titleController: _titleController,
                          contentController: _contentController,
                          onValidate: (_image) async {
                            await FirebaseFirestore.instance
                                .collection('notes')
                                .doc(document.id)
                                .update({
                              'title': _titleController.text,
                              'content': _contentController.text,
                            });
                            
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ));
          }).toList(),
        );
      },
    );
  }
}
