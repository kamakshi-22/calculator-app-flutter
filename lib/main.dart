import 'package:calculator/colors.dart';
import 'package:flutter/material.dart';

import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calculator',
        home: CalculatorApp());
  }
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  /* variables */
  double firstNum = 0.0;
  double secondNum = 0.0;
  var input = '';
  var output = '';
  var operation = '';
  var hideInput = false;
  var outputSize = 20.0;

  /* functions */
  onButtonClick(value) {
    print(value);

    // reset the output
    if (value == 'AC') {
      input = '';
      output = '';
      firstNum = 0.0;
      secondNum = 0.0;
      operation = '';
    } else if (value == '<') {
      if (input.isNotEmpty) {
// remove the last character from the input
        input = input.substring(0, input.length - 1);
      }
    } else if (value == '=') {
      if (input.isNotEmpty) {
        var userInput = input;
        userInput = input.replaceAll('x', '*');

        // Use math_expressions package to evaluate the expression
        try {
          // parse the expression
          Parser p = Parser();
          Expression exp = p.parse(userInput);

          ContextModel cm = ContextModel();
          output = '${exp.evaluate(EvaluationType.REAL, cm)}';

          // remove the .0 if the result is an integer
          if (output.endsWith('.0')) {
            output = output.substring(0, output.length - 2);
          }
          input = output;
          hideInput = true;
          outputSize = 38.0;
        } catch (e) {
          output = 'Error';
        }
      }
    } else {
      input += value;
      hideInput = false;
      outputSize = 38.0;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: orangeColor,
          title: const Text(
            'Calculator',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            /* Display */
            Expanded(
                child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hideInput ? '' : input,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    output,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: outputSize,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )),

            /* Buttons */

            /* Row 1 */
            Row(
              children: [
                button(
                    text: 'AC',
                    buttonBgColor: operatorColor,
                    tColor: orangeColor),
                button(
                    text: '<',
                    buttonBgColor: operatorColor,
                    tColor: orangeColor),
                button(text: '', buttonBgColor: Colors.transparent),
                button(
                    text: '/',
                    buttonBgColor: operatorColor,
                    tColor: orangeColor)
              ],
            ),

            /* Row 2 */
            Row(
              children: [
                button(text: '7'),
                button(text: '8'),
                button(text: '9'),
                button(
                    text: 'x',
                    buttonBgColor: operatorColor,
                    tColor: orangeColor)
              ],
            ),

            /* Row 3 */
            Row(
              children: [
                button(text: '4'),
                button(text: '5'),
                button(text: '6'),
                button(
                    text: '-',
                    buttonBgColor: operatorColor,
                    tColor: orangeColor)
              ],
            ),

            /* Row 4 */
            Row(
              children: [
                button(text: '1'),
                button(text: '2'),
                button(text: '3'),
                button(
                    text: '+',
                    buttonBgColor: operatorColor,
                    tColor: orangeColor)
              ],
            ),

            /* Row 5 */
            Row(
              children: [
                button(text: '%'),
                button(text: '0'),
                button(text: '.'),
                button(text: '=', buttonBgColor: orangeColor)
              ],
            ),
          ],
        ));
  }

  Widget button({text, tColor = Colors.white, buttonBgColor = buttonColor}) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: buttonBgColor,
              padding: const EdgeInsets.all(22),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: () => onButtonClick(text),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: tColor,
              fontWeight: FontWeight.bold,
            ),
          )),
    ));
  }
}
