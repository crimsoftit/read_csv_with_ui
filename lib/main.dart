import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_csv/currency_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Read CSV file content',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<dynamic>> csvContent = [];
  List<CurrencyModel> foundCsvContent = [];

  List<CurrencyModel> singleItem = [];

  String fK = '';

  void loadCSV() async {
    final rawData = await rootBundle.loadString("assets/currencyTings.csv");

    List<List<dynamic>> listData = const CsvToListConverter(
            fieldDelimiter: ",",
            textDelimiter: '"',
            allowInvalid: true,
            convertEmptyTo: String,
            eol: '\n')
        .convert(rawData);

    setState(
      () {
        csvContent = listData;

        for (var element in csvContent) {
          //var values = element.indexed;
          foundCsvContent.add(
            CurrencyModel(
              country: element[0],
              curCode: element[3],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                      top: 7,
                    ),
                    child: Icon(
                      Iconsax.search_favorite,
                      color: Colors.brown.withOpacity(0.6),
                      size: 20,
                    ),
                  ),
                  hintText: 'search currency by country',
                  hintStyle: TextStyle(
                    color: Colors.brown.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  loadCSV();
                  setState(() {
                    foundCsvContent = foundCsvContent
                        .where((item) => item.country.contains(value))
                        .toList();
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  loadCSV;
                  var country = 'Uganda';
                  setState(() {
                    singleItem = foundCsvContent
                        .where((item) => item.country == country)
                        .toList();
                    fK = '${singleItem.first.curCode.toString()}';
                  });
                },
                child: Text(
                  fK,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
          itemCount: csvContent.length,
          itemBuilder: (_, index) {
            return Card(
              margin: const EdgeInsets.all(3.0),
              color: index == 0 ? Colors.amber : Colors.white,
              child: ListTile(
                leading: Text(
                  foundCsvContent[index].country.toString(),
                  //csvContent[index][0].toString(),
                ),
                title: Text(foundCsvContent[index].curCode.toString()
                    //csvContent[index][1].toString(),
                    ),
                // trailing: Text(
                //   csvContent[index][2].toString(),
                // ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadCSV,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
