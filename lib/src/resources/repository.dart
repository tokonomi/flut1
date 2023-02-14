import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  // Этот класс нужен для посредичества DB и NewsApi(Запросов)
  final apiProvider = NewsApiProvider();
  final dbProvider = NewsDbProvider();

  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopIds();
  }

  fetchItem(int id) async {
    var item = await dbProvider.fetchItem(id);
    if (item != null) {
      return null;
    }

    item = await apiProvider.fetchItem(id);
    return item;
  }
}
