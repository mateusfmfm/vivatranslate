
import 'package:vivatranslate_mateus/app/features/ui/home/data/todo_model.dart';
import 'package:vivatranslate_mateus/objectbox.g.dart';

class ObjectBox {
  late final Store _store;
  late final Box<Todo> _todoBox;

  ObjectBox._init(this._store) {
    _todoBox = Box<Todo>(_store);
  }

  static Future<ObjectBox> init() async {
    final store = await openStore();
    SyncClient syncClient = Sync.client(
      store,
      'ws://127.0.0.1:9999',
      SyncCredentials.none(),
    );
    syncClient.start();

    return ObjectBox._init(store);
  }

  Todo? getTodo(int id) => _todoBox.get(id);
  int insertTodo(Todo todo) => _todoBox.put(todo, mode: PutMode.insert);
  bool deleteTodo(int id) => _todoBox.remove(id);
  Stream<List<Todo>> getTodos() => _todoBox.query().watch(triggerImmediately: true).map((query) => query.find());
}
