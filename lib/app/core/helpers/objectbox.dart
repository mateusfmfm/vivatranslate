import 'package:vivatranslate_mateus/app/features/ui/home/data/models/todo_model.dart';
import 'package:vivatranslate_mateus/objectbox.g.dart';

class ObjectBox {
  late final Store _store;
  late final Box<Todo> _todoBox;

  ObjectBox._init(this._store) {
    _todoBox = Box<Todo>(_store);
  }

  static Future<ObjectBox> init() async {
    final store = await openStore();
    return ObjectBox._init(store);
  }

  Todo? getTodo(int id) => _todoBox.get(id);
  int insertTodo(Todo todo) => _todoBox.put(todo);
  int deleteTodo(String id) =>
      _todoBox.query(Todo_.id.equals(id)).build().remove();
  int updateTodo(Todo todo) => _todoBox.put(todo, mode: PutMode.update);
  int finishTodo(Todo todo) => _todoBox.put(todo, mode: PutMode.update);

  Stream<List<Todo>> getTodos() => _todoBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find().toList());

  Stream<List<Todo>> getFinishedTodos() =>
      _todoBox.query().watch(triggerImmediately: true).map((query) => query
          .find()
          .where((element) => element.isCompleted == true)
          .toList());
}
