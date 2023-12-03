/*import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NoteEditorDialog extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final XFile? image;
  final Function onValidate;

  const NoteEditorDialog({
    Key? key,
    required this.titleController,
    required this.contentController,
    this.image,
    required this.onValidate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a note'),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Ajouté pour éviter les débordements
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: contentController,
            decoration: const InputDecoration(
              labelText: 'Content',
            ),
          ),
          TextButton(onPressed: () => {}, child: const Text("Choose an image"))
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await onValidate();
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NoteEditorDialog extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final Function(XFile? image) onValidate;

  const NoteEditorDialog({
    Key? key,
    required this.titleController,
    required this.contentController,
    required this.onValidate,
  }) : super(key: key);

  @override
  _NoteEditorDialogState createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<NoteEditorDialog> {
  XFile? _image;

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a note'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajouté pour éviter les débordements
          children: [
            TextField(
              controller: widget.titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: widget.contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
              ),
            ),
            TextButton(
              onPressed: pickImage,
              child: const Text("Choose an image"),
            ),
            if (_image != null) Image.file(File(_image!.path), height: 150),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await widget.onValidate(_image);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
