import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = openDatabase(
    join(await getDatabasesPath(), 'person.db'),
    onCreate: (db, version) {
      String sqlCreate = """
        Create Table person (
          id INTEGER PRIMARY KEY,
          name TEXT,
          age INTEGER
         );
      """;
      return db.execute(sqlCreate);
    },
    version: 1,
  );

  // (await db).insert('student', Person(12, 'name', 23).toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
      ),
      body: const Center(
        child: MyBody(),
      ),
    );
  }
}

class MyBody extends StatefulWidget {
  const MyBody({super.key});

  @override
  State<MyBody> createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  final idEditingController = TextEditingController();
  final nameEditingController = TextEditingController();
  final ageEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: idEditingController,
          decoration: const InputDecoration(
            labelText: 'id',
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: nameEditingController,
          decoration: const InputDecoration(
            labelText: 'name',
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: ageEditingController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'age',
            border: OutlineInputBorder(),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString(
                  'name',
                  nameEditingController.text,
                );
                await prefs.setInt(
                  'age',
                  int.parse(ageEditingController.text),
                );
              },
              child: const Text(
                'save',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                nameEditingController.text = prefs.getString('name')!;
                ageEditingController.text = prefs.getInt('age')!.toString();
              },
              child: const Text(
                'reLoad',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
