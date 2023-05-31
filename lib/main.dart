import 'package:flutter/material.dart';
import 'package:hive_app/utils.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'models/notes_model.dart';

void main() async {
  // Initialize flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  // Make a directory for hive Data
  var directory = await getApplicationDocumentsDirectory();
  // Initialize hive
  Hive.init(directory.path);
  // You have to register that generated adapter
  Hive.registerAdapter(NotesModelAdapter());
  // Open a box (yeh aik database hai)
  await Hive.openBox<NotesModel>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var box = Hive.box<NotesModel>('notes');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive"),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: box.listenable(),
          builder: (context, box, _) {
            // box aik database hai uski values ko list main convert kr k un sbko case krna hai NotesModel main
            final data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Row(children: [
                          Text(data[index].title),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Utils.delete(data[index]);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Utils.showMyEditDialog(
                                  context: context,
                                  notesModel: data[index],
                                  title: data[index].title.toString(),
                                  description:
                                      data[index].description.toString());

                              titleController.clear();
                              descriptionController.clear();
                            },
                            icon: const Icon(Icons.edit),
                          )
                        ]),
                        Text(data[index].description),
                      ],
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Utils.showMyDialog(
              context: context,
              titleController: titleController,
              descriptionController: descriptionController);
          titleController.clear();
          descriptionController.clear();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
