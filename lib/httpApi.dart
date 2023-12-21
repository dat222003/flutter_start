import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/post.dart';

const padding = EdgeInsets.all(16.0);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'person.db'),
    onCreate: (database, version) {
      String sqlCreate = """
        Create Table person (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          code TEXT,
          name TEXT,
          gender INTEGER,
          homeTown TEXT
         );
      """;
      return database.execute(sqlCreate);
    },
    version: 1,
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Home(
          database: database,
        ),
      ),
    ),
  );
}

Future<http.Response> fetchPost() {
  Post post = Post(1, 1, 'title', 'body');
  return http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: <String, String>{
      'content-Type': 'Application/json',
    },
    body: jsonEncode({}),
  );
}

class Home extends StatelessWidget {
  final Future<Database> database;

  const Home({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Api'),
          backgroundColor: Colors.greenAccent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  var result = await fetchPost();
                  if (result.statusCode == 200) {
                    print(
                      Post.fromJson(
                        jsonDecode(result.body),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Http',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
