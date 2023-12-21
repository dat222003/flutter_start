import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_start/model/person.dart';
import 'package:flutter_start/person_helper.dart';

const padding = EdgeInsets.all(16.0);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person'),
        backgroundColor: Colors.greenAccent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.green.shade200,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                );
              },
              child: const Text(
                'Persons List',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonCreateScreen(),
                  ),
                );
                if (result != null) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Person with id = $result created',
                      ),
                      action: SnackBarAction(
                        label: 'close',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Create Persons',
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PersonsList();
  }
}

class PersonsList extends StatefulWidget {
  const PersonsList({Key? key}) : super(key: key);

  @override
  _PersonsListState createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  late List<Person> persons = [];
  late PersonHelperSqlite personProvider;
  int idCounter = 2;

  @override
  void initState() {
    super.initState();
    personProvider = PersonHelperSqlite();
    loadPersons();
  }

  Future<void> loadPersons() async {
    final loadedPersons = await personProvider.getPersons();
    setState(() {
      persons = loadedPersons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persons List'),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonDetailsScreen(
                    person: persons[index],
                  ),
                ),
              );
              if (result != null) {
                loadPersons();
              }
            },
            child: Card(
              elevation: 5,
              child: Padding(
                padding: padding,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${persons[index].id}',
                        style: PersonCardStyles.idNameStyle,
                      ),
                      Text(
                        'Code: ${persons[index].code}',
                        style: PersonCardStyles.personNameStyle,
                      ),
                      Text(
                        'Name: ${persons[index].name}',
                        style: PersonCardStyles.personNameStyle,
                      ),
                      Text(
                        'Gender: ${persons[index].gender ? 'male' : 'female'}',
                        style: PersonCardStyles.personNameStyle,
                      ),
                      Text(
                        'Mark: ${persons[index].mark}',
                        style: PersonCardStyles.personNameStyle,
                      ),
                      Text(
                        'HomeTown: ${persons[index].homeTown}',
                        style: PersonCardStyles.personNameStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PersonCreateScreen extends StatefulWidget {
  const PersonCreateScreen({super.key});

  @override
  State<PersonCreateScreen> createState() => _PersonCreateScreenState();
}

class _PersonCreateScreenState extends State<PersonCreateScreen> {
  final TextEditingController idController = TextEditingController();

  final TextEditingController codeController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController homeTownController = TextEditingController();

  final TextEditingController markController = TextEditingController();

  bool _gender = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Person',
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'code',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'name',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownMenu<String>(
                    controller: homeTownController,
                    initialSelection: Person.homeTownList.first,
                    dropdownMenuEntries: Person.homeTownList
                        .map<DropdownMenuEntry<String>>((String str) {
                      return DropdownMenuEntry<String>(
                        value: str,
                        label: str,
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: markController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'(^\d*\.?\d{0,2})',
                        ),
                      ),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'mark',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Male'),
                    value: true,
                    groupValue: _gender,
                    onChanged: (bool? value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Female'),
                    value: false,
                    groupValue: _gender,
                    onChanged: (bool? value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  PersonHelperSqlite personProvider = PersonHelperSqlite();
                  int personId = 0;
                  await personProvider
                      .insertPerson(
                        Person(
                          code: codeController.text,
                          name: nameController.text,
                          gender: _gender,
                          mark: double.parse(markController.text),
                          homeTown: homeTownController.text,
                        ),
                      )
                      .then(
                        (value) => personId = value,
                      );
                  if (!context.mounted) return;
                  Navigator.pop(context, personId);
                },
                child: const Text(
                  'save',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonCardStyles {
  static const idNameStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const personNameStyle = TextStyle(
    fontSize: 20,
  );
  static const personAgeStyle = TextStyle(
    fontSize: 16,
  );
}

class PersonDetailsScreen extends StatefulWidget {
  final Person person;

  const PersonDetailsScreen({Key? key, required this.person}) : super(key: key);

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController homeTownController;
  late TextEditingController codeController;
  late TextEditingController markController;
  late bool gender;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.person.name);
    codeController = TextEditingController(text: widget.person.code);
    homeTownController = TextEditingController(text: widget.person.homeTown);
    markController = TextEditingController(text: widget.person.mark.toString());
    gender = widget.person.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Person',
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownMenu<String>(
                    controller: homeTownController,
                    initialSelection: homeTownController.text,
                    dropdownMenuEntries: Person.homeTownList
                        .map<DropdownMenuEntry<String>>((String str) {
                      return DropdownMenuEntry<String>(
                        value: str,
                        label: str,
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: markController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(
                        ',',
                        replacementString: '.',
                      ),
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'(^\d*\.?\d{0,2})',
                        ),
                      ),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'mark',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Male'),
                    value: true,
                    groupValue: gender,
                    onChanged: (bool? value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Female'),
                    value: false,
                    groupValue: gender,
                    onChanged: (bool? value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final person = Person(
                        code: codeController.text,
                        name: nameController.text,
                        gender: gender,
                        homeTown: homeTownController.text,
                        mark: double.parse(markController.text),
                        id: widget.person.id,
                      );
                      await PersonHelperSqlite().updatePerson(person);
                      if (!context.mounted) return;
                      Navigator.pop(context, true);
                    },
                    child: const Text('Update'),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await PersonHelperSqlite()
                          .deletePerson(widget.person.id!);
                      if (!context.mounted) return;
                      Navigator.pop(context, true);
                    },
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
