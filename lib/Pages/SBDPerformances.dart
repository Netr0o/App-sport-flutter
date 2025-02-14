import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// TODO: - formated date : line 141
// TODO: - delete useless data in the database
// TODO: - add data from the phone csv file to database
// TODO: - connect the database with the chart
// TODO: - (when I will have the time) improve the overall design of the app

class SBDPerformances extends StatefulWidget {
  @override
  _SBDPerformances createState() => _SBDPerformances();
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('perf_database.db'); //perf_database.db
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const id = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const realType = 'REAL';

    await db.execute('''
    CREATE TABLE squat ( 
      id $id,
      date $textType,
      weight $realType
    )
    ''');

    await db.execute('''
    CREATE TABLE bench (
      id $id,
      date $textType,
      weight $realType
    )
    ''');

    await db.execute('''
    CREATE TABLE deadlift (
      id $id,
      date $textType,
      weight $realType
    )
    ''');
  }

  Future<void> insertSquatWeight(String date, double weight) async {
    final db = await instance.database;
    await db.insert('squat', {'date': date, 'weight': weight});
  }

  Future<void> insertBenchWeight(String date, double weight) async {
    final db = await instance.database;
    await db.insert('bench', {'date': date, 'weight': weight});
  }

  Future<void> insertDeadliftWeight(String date, double weight) async {
    final db = await instance.database;
    await db.insert('deadlift', {'date': date, 'weight': weight});
  }

  Future<List<Map<String, dynamic>>> getWeightForMovement(
      String movement) async {
    final db = await instance.database;
    final result = await db.query(movement);
    return result;
  }

  Future<List<Map<String, dynamic>>> queryDatabase(String sqlQuery) async {
    final db = await instance.database;
    return await db.rawQuery(sqlQuery);
  }

  Future<void> deleteAllData(String tableName) async {
    final db = await instance.database;
    await db.delete('deadlift');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

class _SBDPerformances extends State<SBDPerformances> {
  @override
  void initState() {
    super.initState(); // Call the new function
  }

  String? movement;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String queryResult = '';

  List<String> dates = [];
  List<double> weights = [];
  List<double> transformedDates = [];
  List<double> doubleDate = [];

  bool showChart = true;

  // List of dropdown options
  final List<String> _options = ["Squat", "Bench", "Deadlift"];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    // print(now);
    String formattedDate = DateFormat('dd MM yyyy').format(now);
    print("formattedDate : $formattedDate");

    transformation() {
      transformedDates = [];
      for (String row in dates) {
        // date as DateTime format
        DateTime formattedRow = DateFormat('dd MM yyyy').parse(row);
        // years part date as string
        String yyyy = DateFormat('yyyy').format(formattedRow);
        // month part date as string
        String mm = DateFormat('MM').format(formattedRow);
        // day part date as string
        String dd = DateFormat('dd').format(formattedRow);
        // reverse compacted date as string, full numbers
        String stringDate = yyyy + mm + dd;
        // transformation of the before RCD from string to double
        double doubleDate = double.parse(stringDate);
        // check that there isn't 2 same data
        // transformedDates = list of double
        transformedDates.add(doubleDate);
        print("database date : $dates");
        print("date: $transformedDates");
        print(doubleDate);
        print('squat charge : $weights');
      }
    }

    transformation();

    List<FlSpot> chartSpots = [];
    if (dates.isNotEmpty && transformedDates.isNotEmpty && weights.isNotEmpty) {
      chartSpots = List.generate(dates.length, (index) {
        double xValue = transformedDates[index].toDouble();
        return FlSpot(xValue, weights[index]);
      });
    } else {
      print("nothing to show");
    }

    List<String> historicalDates = [
      '11 10 2023',
      '17 10 2023',
      '01 01 2024',
      '01 04 2024',
      // ... add more historical dates here
    ];

    List<double> historicalWeights = [
      120.0,
      130.0,
      135.0,
      140.0
      // ... add corresponding historical weights here
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[
            Color(0xff000000),
            Color(0xff070707),
            Color(0xff0e0e0d),
            Color(0xff131412),
            Color(0xff181816),
            Color(0xff1c1c1a),
            Color(0xff20201d),
            Color(0xff242421),
            Color(0xff282925),
            Color(0xff2c2d28),
            Color(0xff31322c),
            Color(0xff353630),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          SizedBox(
            // button to delete data from selected table
            child: ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteAllData('bench');
                setState(() {});

                print('Clear Squat Data');
                print('squat poids : $weights');
              },
              child: const Text("delete bench value"),
            ),
          ),
          SizedBox(
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 7,
                ),

                // weights input

                SizedBox(
                  width: 80,
                  child: TextField(
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    controller: _weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.all(6),
                        hintText: "your PR :"),
                  ),
                ),

                // movement choice

                const SizedBox(width: 15),
                DropdownButton<String>(
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  value: movement,
                  hint: const Text(
                    "Select an option",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      movement = newValue;
                    });
                  },
                  items: _options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // save button

          SizedBox(
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 7),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.grey[800]),
                  ),
                  onPressed: () async {
                    dates.addAll(historicalDates);
                    weights.addAll(historicalWeights);
                    setState(() {});

                    final date = formattedDate;
                    final weight = double.tryParse(_weightController.text);

                    if (date.isNotEmpty && weight != null) {
                      if (movement == "Squat") {
                        await DatabaseHelper.instance
                            .insertSquatWeight(date, weight);
                      } else if (movement == "Bench") {
                        await DatabaseHelper.instance
                            .insertBenchWeight(date, weight);
                      } else if (movement == "Deadlift") {
                        await DatabaseHelper.instance
                            .insertDeadliftWeight(date, weight);
                      }

                      _dateController.clear();
                      _weightController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Weight successfully saved")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please enter a valid date and weight')),
                      );
                    }
                  },
                  child: const Text(
                    "Save performances",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ),
                const SizedBox(width: 15),

                // display button

                SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.grey[800]),
                    ),
                    onPressed: () async {
                      if (movement != null) {
                        String tableName = movement!.toLowerCase();
                        String query = "SELECT * FROM $tableName";
                        List<Map<String, dynamic>> result =
                            await DatabaseHelper.instance.queryDatabase(query);

                        dates = [];
                        weights = [];

                        for (var row in result) {
                          dates.add(row['date'] as String);
                          weights.add(row['weight'] as double);
                        }

                        setState(() {});
                        print("$queryResult, $dates, $weights");
                      }
                    },
                    child: const Text(
                      "Update the chart",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SizedBox(
          //     child: ElevatedButton(
          //         onPressed: () async {
          //           String tableName = movement!.toLowerCase();
          //           String testWeights = "SELECT * FROM $tableName";
          //
          //           // Await the database query
          //           List<Map<String, dynamic>> result = await DatabaseHelper.instance.queryDatabase(testWeights);
          //
          //           // Update the dates list
          //           dates = result.map((row) => row['date'] as String).toList();
          //
          //           // Now print the query and the updated dates list
          //           print("$testWeights,  $dates");
          //         },
          //         child: const Text("h "))),

          // performances chart

          const SizedBox(height: 10),
          if (showChart)
            SizedBox(
              width: 400,
              height: 300,
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 330,
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 46,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  if (transformedDates.contains(value)) {
                                    int index = transformedDates.indexOf(value);
                                    String dateString = dates[index];
                                    DateTime date = DateFormat('dd MM yy')
                                        .parse(dateString);
                                    String formattedDateSlash =
                                        DateFormat('dd/MM/yy').format(date);

                                    return SizedBox(
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          Transform.rotate(
                                            angle: 60 * pi / 180,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text(
                                                formattedDateSlash,
                                                style: TextStyle(
                                                    color: Colors.blue[800],
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                  Widget bottomTitleWidgets(
                                      double value, TitleMeta meta) {
                                    Widget text;
                                    switch (value.toInt()) {
                                      case 2:
                                        text = const Text('');
                                    }
                                  }
                                }),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              getTitlesWidget: (value, meta) {
                                if (weights.contains(value)) {
                                  return Text(value.toString(),
                                      style:
                                          TextStyle(color: Colors.blue[100]));
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                              interval: 1,
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                              spots: chartSpots,
                              isCurved: false,
                              color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
