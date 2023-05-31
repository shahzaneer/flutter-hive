import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models/notes_model.dart';

class Utils {
// For Adding the Note
  static Future<void> showMyDialog(
      {required BuildContext context,
      required TextEditingController titleController,
      required TextEditingController descriptionController}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Note"),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final note = NotesModel(
                    title: titleController.text,
                    description: descriptionController.text);
                final box = Hive.box<NotesModel>('notes');
                box.add(note);
                Navigator.pop(context);

                //! It stores the data in the box persistently
                // note.save();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

// For Deleting the Note
  static void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

// For Editing the Note
  static Future<void> showMyEditDialog(
      {required BuildContext context,
      required NotesModel notesModel,
      required String title,
      required String description}) async {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);

    print("title: $title, description: $description");
    print(
        "titleController: ${titleController.text}, descriptionController: ${descriptionController.text}");
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Note"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  // initialValue: titleController.text,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  // initialValue: descriptionController.text,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                notesModel.title = titleController.text;
                notesModel.description = descriptionController.text;
                notesModel.save();
                Navigator.pop(context);
              },
              child: const Text("Edit"),
            ),
          ],
        );
      },
    );
  }
}
