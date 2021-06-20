import 'package:flutter/material.dart';
import 'package:flutter_budget_tracker/budget_reposetory.dart';
import 'package:flutter_budget_tracker/failure_model.dart';
import 'package:flutter_budget_tracker/item_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notion Budget Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: BudgetScreen(),
    );
  }
}

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureItems = BudgetReposetory().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Budget Tracker')),
      ),
      body: FutureBuilder<List<Item>>(
          future: _futureItems,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //show pie chart
              final items = snapshot.data!;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 2.0,
                        color: getCatogeryColor(item.category),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        item.name,
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
//Show failer error msg
              final failure = snapshot.error as Failure;
              return Center(
                child: Text(failure.message),
              );
            }
            //Show loading spinner
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

Color getCatogeryColor(String category) {
  switch (category) {
    case 'Entertaitment':
      return Colors.red[400]!;
    case 'Food':
      return Colors.green[400]!;

    case 'Personal':
      return Colors.blue[400]!;

    case 'Transportation':
      return Colors.purple[400]!;

    default:
      return Colors.orange[400]!;
  }
}
