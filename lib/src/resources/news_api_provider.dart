import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:async';

import 'package:news/src/models/item_model.dart';

class NewsApiProvider {
  Client client = Client();

  Future<List<int>> fetchTopIds() async {
    final response = await client.get(Uri.parse(
        'https://hacker-news.firebaseio.com/v0/topstories.json')); // Использование get, нужно добавить Uri парсер. чтобы использовать URL запрос нужен URI
    final ids = json.decode(response.body);
    print(response);
    print(ids);
    return ids.cast<
        int>(); // Cast<type> Указывает на то что ids будет типа List of integers
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client
        .get(Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json'));
    final parsedJson = json.decode(response.body);
    print(response);
    return ItemModel.fromJson(parsedJson);
  }
}
