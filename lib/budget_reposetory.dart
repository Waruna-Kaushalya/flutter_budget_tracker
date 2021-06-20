import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'item_model.dart';

class BudgetReposetory {
  final http.Client _client;

  BudgetReposetory({http.Client? client}) : _client = client ?? http.Client();


  
}
