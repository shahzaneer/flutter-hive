import 'package:hive/hive.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject{
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String description;

  NotesModel({required this.title, required this.description});

  @override
  String toString() {
    return "title: $title, description: $description";
  }
}

//  Hive type for class
// hive field for each property

// for generation of adapter
// pehle yeh banayen
// part 'notes_model.g.dart'
//! flutter packages pub run build_runner build