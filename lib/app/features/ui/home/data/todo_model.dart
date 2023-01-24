// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:objectbox/objectbox.dart';
import 'package:vivatranslate_mateus/app/core/helpers/id_util.dart';

@Entity()
class Todo {
  @Id()
  int objid;

  @Unique()
  String? id;

  String? description;
  String? location;
  bool? isCompleted;
  DateTime? createdAt;
  DateTime? todoDate;
  String? audioBase64;
  String? audioPath;

  Todo({
    this.objid = 0,
    required this.id,
    required this.description,
    this.location,
    this.isCompleted = false,
    required this.createdAt,
    this.todoDate,
    this.audioBase64,
    this.audioPath,
  });
}
