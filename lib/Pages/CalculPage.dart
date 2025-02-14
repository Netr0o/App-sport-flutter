import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalculPage extends StatefulWidget {
  @override
  CalculPageState createState() => CalculPageState();
}

// truc des variables

class CalculPageState extends State<CalculPage> {
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  double? _result;
  double? resultPercent1;
  double? resultPercent2;
  double? resultPercent3;
  double? resultPercent4;
  double? resultPercent5;
  final bw = TextEditingController();
  double? _ratio;

// main calculation function

  _calculate1RM() {
    final double? weight = double.tryParse(myController1.text);
    final int? reps = int.tryParse(myController2.text);

    if (weight != null && reps != null && reps > 0) {
      setState(() {
        _result = weight / (1.0278 - 0.0278 * reps);
        resultPercent1 = _result! * 0.95;
        resultPercent2 = _result! * 0.90;
        resultPercent3 = _result! * 0.85;
        resultPercent4 = _result! * 0.80;
        resultPercent5 = _result! * 0.70;
      });
    } else {
      setState(() {
        _result = null;
        resultPercent1 = null;
        resultPercent2 = null;
        resultPercent3 = null;
        resultPercent4 = null;
        resultPercent5 = null;
      });
    }
    return _result;
  }

  // ratio between body weight and 1rm calculated before function

  _ratiobw() {
    final double? bwweight = double.tryParse(bw.text);
    if (bwweight != null && bwweight > 0) {
      setState(() {
        _ratio = _result! / bwweight;
      });
    } else {
      setState(() {
        _ratio = null;
      });
    }
    return _ratio;
  }

  void _showHelpDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
              title: Text("Aide à l'utilisation de l'app"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                        "Cette app a été créée pour trouver son 1rm (charge maximale pour une seule rep = son record) automatiquement en fonction d'une charge et d'un nombre de reps donnés. "
                        "Par exemple si vous poussez 50kg pour 10 répétitions, votre 1rm va être approximativement 67kg. (Le resultat peut "
                        "varier en fonction de la personne. L'estimation devient de moins en moins précis avec un trop grand nombre "
                        "de répétitions, au-delà de 14, en raison de la formule utlisée. "
                        "L'application permet aussi de calculer le ratio entre son poids de corps et le 1rm estimé, ce "
                        "est surtout utile pour les mouvements de SBD (Squat, Bench, Deadlift) afin d'évaluer sa force générale. "
                        "L'autre fonctionnalité de l'app est le suivi de performances (squat, bench et deadlift, d'autres possibilités "
                        "seront ajoutées dans une prochaine  maj) "),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[
            Color(0xff01001f),
            Color(0xff020321),
            Color(0xff030723),
            Color(0xff050b24),
            Color(0xff091026),
            Color(0xff0e1427),
            Color(0xff131929),
            Color(0xff181d2a),
            Color(0xff1d212b),
            Color(0xff23252c),
            Color(0xff282a2d),
            Color(0xff2e2e2e),
          ], //background: linear-gradient(45deg, #, #, #, #, #, #, #, #, #, #, #, #);
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                SizedBox(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 120,
                        // weight entry selection
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: myController1,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(6),
                            icon: Icon(FontAwesomeIcons.dumbbell),
                            hintText: "Weight : ",
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      SizedBox(
                        width: 120,
                        // repetitions entry selection
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: myController2,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(6),
                            icon: Icon(Icons.loop),
                            hintText: "Reps :",
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      // calculation button
                      ElevatedButton(
                        onPressed: _calculate1RM,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                        ),
                        child: const Text(
                          "1RM Calculation",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      const SizedBox(height: 1.0),
                      SizedBox(
                        width: 100,
                        // ratio entry
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: bw,
                          maxLength: 5,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(6),
                            icon: Icon(FontAwesomeIcons.person),
                            hintText: "Bw : ",
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF4682b4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ratio calculation button
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.grey[800]),
                            textStyle: const WidgetStatePropertyAll(
                                TextStyle(fontSize: 14, color: Colors.white))),
                        onPressed: _ratiobw,
                        child: const Text(
                          "Ratio Calculation",
                          style: TextStyle(
                            fontSize: 14,
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
          // help icon button + result and percentage
          Positioned(
            top: 24,
            right: 0,
            child: SizedBox(
              width: 180,
              child: Column(
                children: [
                  Container(
                    width: 170,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: _result == null
                        ? const Text(
                            "Estimate 1RM:\n"
                            "95% du 1rm:\n"
                            "90% du 1rm:\n"
                            "85% du 1rm:\n"
                            "80% du 1rm:\n"
                            "70% du 1rm:\n",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          )
                        : Text(
                            "Estimate 1RM: ${_result!.toStringAsFixed(1)} \n"
                            "95% du 1rm: ${resultPercent1!.toStringAsFixed(1)}\n"
                            "90% du 1rm: ${resultPercent2!.toStringAsFixed(1)}\n"
                            "85% du 1rm: ${resultPercent3!.toStringAsFixed(1)}\n"
                            "80% du 1rm: ${resultPercent4!.toStringAsFixed(1)}\n"
                            "70% du 1rm: ${resultPercent5!.toStringAsFixed(1)}\n",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                  ),
                  SizedBox(
                    width: 170,
                    height: 60,
                    child: _ratio == null
                        ? const Text(
                            "Your ratio bw/1rm :",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          )
                        : Text(
                            "Your ratio bw/1rm :\n ${_ratio!.toStringAsFixed(1)}",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 290),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      child: IconButton(
                        icon: const Icon(Icons.help,
                            color: Colors.white, size: 40),
                        onPressed: _showHelpDialog,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
