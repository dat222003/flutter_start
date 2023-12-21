import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';

@JsonSerializable()
class Student {
  String name;
  String gender;
  Map<String, bool>? hobbies = {
    'sothich 1': false,
    'sothich 2': false,
    'sothich 3': false,
  };

  String homeTown;

  Student(this.name, this.gender, this.homeTown, {this.hobbies});

  void updateHobby(String hobbyName, bool value) {
    hobbies?[hobbyName] = value;
  }

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  @override
  String toString() {
    return 'Student{name: $name, gender: $gender, hobby: $hobbies, homeTown: $homeTown}';
  }
}
