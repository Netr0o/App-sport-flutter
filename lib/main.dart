import 'package:app_1rm_v1/Pages/CalculPage.dart';
import 'package:app_1rm_v1/Pages/SBDPerformances.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  bool _showHomePage = true;
  int _currentIndex = 0;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void hideHomePage() {
    setState(() {
      _showHomePage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _showHomePage
            ? HomePage(onStartPressed: hideHomePage)
            : IndexedStack(
                index: _currentIndex,
                children: [
                  CalculPage(),
                  SBDPerformances(),
                ],
              ),
        bottomNavigationBar: _showHomePage
            ? null
            : BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setCurrentIndex(index),
                selectedItemColor: Colors.blue,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.dumbbell), label: "1rm"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calculate_outlined),
                      label: "SBD performances")
                ],
              ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onStartPressed;

  HomePage({required this.onStartPressed});

  final List<String> _quotes = [
    "\"yeah BUDDY light weight !!\"\n R.Coleman",
    "\"- what's your biggest fear ? \n - Biggest fear ? Dyin skinny.\"\n a guy on internet",
    "\"We're all gonna make it brah !\"\n Zyzz",
    "\"You mirin Brah ?\"\n Zyzz",
  ];

  String _getRandomQuote() {
    final random = Random();
    return _quotes[random.nextInt(_quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[
              Color(0xff214c91),
              Color(0xff154494),
              Color(0xff093c96),
              Color(0xff033297),
              Color(0xff062896),
              Color(0xff111b95),
              Color(0xff1d149b),
              Color(0xff2a16aa),
              Color(0xff3717b9),
              Color(0xff4317c8),
              Color(0xff5117d7),
              Color(0xff5e15e6),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 130),
            Text(
              "MaxTracker",
              style: TextStyle(fontSize: 50, color: Colors.orange[800]),
            ),
            const SizedBox(height: 80),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onStartPressed,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 25.0)),
                    child: Text(
                      'Go to the app the App',
                      style: TextStyle(fontSize: 24, color: Colors.blue[800]),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _getRandomQuote(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
