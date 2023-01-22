// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:objectbox/objectbox.dart';

@Entity()
class Todo {
  int id;

  String? description;
  String? location;
  bool? isCompleted;
  DateTime? createdAt;
  DateTime? todoDate;
  String? audioBase64;
  String? audioPath;

  Todo({
    this.id = 0,
    required this.description,
    this.location,
    this.isCompleted = false,
    required this.createdAt,
    this.todoDate,
    this.audioBase64,
    this.audioPath,
  });
}
