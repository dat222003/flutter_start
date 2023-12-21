// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      json['name'] as String,
      json['gender'] as String,
      json['homeTown'] as String,
      hobbies: (json['hobbies'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'name': instance.name,
      'gender': instance.gender,
      'hobbies': instance.hobbies,
      'homeTown': instance.homeTown,
    };
