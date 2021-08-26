import 'package:my_todo/todoslar.dart';
import 'package:my_todo/veritabaniYardimcisi.dart';

class TodomDao {
  Future<List<Todoslar>> tumTodom() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM todoslar");

    return List.generate(maps.length, (index) {
      var satir = maps[index];

      return Todoslar(
        satir["todo_id"],
        satir["todo_name"],
        satir["todo_day"],
      );
    });
  }

  Future<void> todoEkle(
    String todo_name,
    String todo_day,
  ) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var bilgiler = Map<String, dynamic>();

    bilgiler["todo_name"] = todo_name;
    bilgiler["todo_day"] = todo_day;

    await db.insert("todoslar", bilgiler);
  }

  Future<void> todoSil(int todo_id) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    await db.delete("todoslar", where: "todo_id = ?", whereArgs: [todo_id]);
  }
}
