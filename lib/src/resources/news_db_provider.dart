import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';

class NewsDbProvider {
  late Database db; // это и есть SQLite data base

  init() async {
    //Чо бы спользовать SQL нужно запустить init
    // connection with DB
    Directory documentDirectory =
        await getApplicationDocumentsDirectory(); // Функция от PathProvider, для работы с path в мобильных устройствах. Возвращает path куда мы можем ставить данные. path на DB // Доступ к типу Directory мы получает от пакета dart:io
    final path = join(documentDirectory.path,
        "items.db"); // Здесь мы присоеденяем директории и получаем финальную ссылку
    db = await openDatabase(
      // Функция от пакета SQflite
      path, //  Создаст DB по этому пути или же если путь существует то подключаемся к нему
      version: 1, // Когда мы делаем изменение в DB мы можем менять версию базы
      onCreate: (Database newDb, int version) {
        // Запускается при создании DB внутри мы будем настраивать DB. Самый первый запуск
        newDb.execute(// Это TABLE внутри всё column
            """
            CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY, 
              type TEXT,
              by TEXT,
              time TEXT,
              parent ITEGER,
              kids BLOB,
              dead INTEGER, 
              deleted INTEGER, 
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
          """); // Отправляет данные на DB, Это код SQL // PRIMARY KEY Указывает на свойства как ID // BLOB это объект с данными похожий на массив
      },
    ); // если пользователь впервые запускает приложение то мы Создаём Database а если нет то перезапускаем DB
  }

  Future<ItemModel?> fetchItem(int id) async {
    // Здесь будем забирать данные из DB. КОгда работаем с DB всегда указываем что операция ASYNC
    // Внутри будем выдавать запрос на DB и возвращать row

    final maps = await db.query(
      // MAPS, потому что в итоге этот запрос вернёт List с самыми обычными объектами(map) List<Map<String, dynamic>>
      "Items",
      columns:
          null, // Если здесь указать ["title"] он выведет нам значение только title, указывая null мы возвращаем весь table,
      where:
          "id = ?", // Найти id равное чему что мы передадим как аргумент в query
      whereArgs: [
        id
      ], // ? сверху будет заменён тем что мы укажем здесь в качестве id
    );

    if (maps.length > 0) {
      // Если в DB есть какие то данные то будет запущена функция иначе вернёт нулл
      return ItemModel.fromDb(
          maps.first); // MAPS как массив вернёт первый элемент который объект
    }

    return null;
  }

  Future<int> addItem(ItemModel item) {
    // async используем только когда ждём данные из DB
    return db.insert(
        "Items", item.toMapForDb()); // Добавляем в Table один элемент JSON
  }
}
