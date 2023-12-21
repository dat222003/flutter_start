import 'package:flutter/material.dart';
import 'package:flutter_start/student.dart';

class MyForm extends StatefulWidget {
  final String feedBack;

  const MyForm({super.key, this.feedBack = ''});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  List<String> homeTownList = ['hanoi', 'haiphong'];

  late Student student;

  late String _feedBack;

  @override
  void initState() {
    super.initState();
    _feedBack = widget.feedBack;
    student = Student('name', 'male', 'homeTown');
  }

  void _handleGenderChange(Gender gender) {
    setState(() {
      student.gender = gender.toString().split('.').last;
    });
  }

  void _handleHobbyChange(String hobbyName, bool? value) {
    setState(() {
      student.hobbies![hobbyName] = value!;
      student.updateHobby(hobbyName, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$student',
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                student.name = value;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'name',
            ),
          ),
          const Text(
            'Gender',
          ),
          RadioExample(onChanged: _handleGenderChange),
          const Text(
            'Hobby',
          ),
          ...student.hobbies!.keys.map((String key) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(key),
              value: student.hobbies![key],
              onChanged: (bool? value) {
                _handleHobbyChange(key, value);
              },
            );
          }).toList(),
          DropdownMenu<String>(
            onSelected: (String? homeTown) {
              setState(() {
                student.homeTown = homeTown!;
              });
            },
            initialSelection: homeTownList[0],
            hintText: 'HomeTown',
            dropdownMenuEntries:
                homeTownList.map<DropdownMenuEntry<String>>((String str) {
              return DropdownMenuEntry<String>(
                value: str,
                label: str,
              );
            }).toList(),
          ),
          Row(
            children: [
              Text(
                'feedBack $_feedBack ',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    student: student,
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  _feedBack = result;
                });
              }
            },
            child: const Text(
              'Submit',
            ),
          ),
        ],
      ),
    );
  }
}

enum Gender { male, female }

class RadioExample extends StatefulWidget {
  final ValueChanged<Gender> onChanged;
  const RadioExample({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  Gender _gender = Gender.male;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<Gender>(
            title: const Text(
              'Male',
            ),
            value: Gender.male,
            groupValue: _gender,
            onChanged: (Gender? value) {
              setState(() {
                _gender = value!;
                widget.onChanged(_gender);
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile<Gender>(
            title: const Text('Female'),
            value: Gender.female,
            groupValue: _gender,
            onChanged: (Gender? value) {
              setState(() {
                _gender = value!;
                widget.onChanged(_gender);
              });
            },
          ),
        ),
      ],
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Student student;
  static const double detailFontSize = 20;
  DetailScreen({super.key, required this.student});
  final TextEditingController feedBackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${student.name}',
              style: const TextStyle(fontSize: detailFontSize),
            ),
            Text(
              'Gender: ${student.gender}',
              style: const TextStyle(fontSize: detailFontSize),
            ),
            Text(
              'Hometown: ${student.homeTown}',
              style: const TextStyle(fontSize: detailFontSize),
            ),
            const Text(
              'Hobbies:',
              style: TextStyle(fontSize: detailFontSize),
            ),
            ...student.hobbies!.keys.map((String key) {
              return Text(
                '$key: ${(student.hobbies![key] ?? false) ? 'Yes' : 'No'}',
                style: const TextStyle(fontSize: detailFontSize),
              );
            }).toList(),
            TextField(
              controller: feedBackController,
              decoration: const InputDecoration(
                labelText: 'Feed Back',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, feedBackController.text);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
