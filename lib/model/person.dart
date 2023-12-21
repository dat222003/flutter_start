class Person {
  int? id;
  String code;
  String name;
  bool gender;
  String homeTown;
  double mark;
  static const List<String> homeTownList = ['hanoi', 'haiphong'];

  Person({
    required this.code,
    required this.name,
    this.gender = true,
    this.homeTown = 'hanoi',
    this.mark = 3.0,
    this.id,
  });

  Person.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        code = json['code'] as String,
        name = json['name'] as String,
        gender = json['gender'] as bool,
        homeTown = json['homeTown'] as String,
        mark = json['mark'] as double;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'code': code,
        'name': name,
        'gender': gender,
        'homeTown': homeTown,
        'mark': mark
      };

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'gender': gender ? 1 : 0,
      'homeTown': homeTown,
      'mark': mark
    };
  }
}
