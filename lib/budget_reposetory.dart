import 'dart:convert';
import 'dart:io';

import 'package:flutter_budget_tracker/failure_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'item_model.dart';

class BudgetReposetory {
  static const String _baseUrl = 'https://api.notion.com/v1/';
  final http.Client _client;

  BudgetReposetory({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

// https://api.notion.com/v1/databases/8dd1627c65a0420991bcdc254a22f691/query
// Future<List<Item>>
  Future<List<Item>> getItems() async {
    try {
      final url =
          '${_baseUrl}databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2021-5-13',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['results'] as List).map((e) => Item.forMap(e)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      } else {
        throw const Failure(message: 'Something went wrong!');
      }
    } catch (_) {
      throw const Failure(message: 'Something went wrong!');
    }
  }
}
