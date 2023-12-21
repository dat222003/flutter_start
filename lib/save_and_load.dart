import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
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
  final nameEditingController = TextEditingController();
  final ageEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: nameEditingController,
        ),
        TextField(
          controller: ageEditingController,
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                Directory folder = await getTemporaryDirectory();
                File file = File('${folder.path}/text.json');
                file.writeAsStringSync(
                  '{"name": "${nameEditingController.text}", "age": "${ageEditingController.text}" }',
                );
              },
              child: const Text(
                'save',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Directory folder = await getTemporaryDirectory();
                File file = File('${folder.path}/text.json');
                String readFile = file.readAsStringSync();
                Map<String, dynamic> jsonData = jsonDecode(readFile);
                setState(() {
                  nameEditingController.text = jsonData['name'];
                  ageEditingController.text = jsonData['age'];
                });
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
