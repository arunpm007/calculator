import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grid demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Grid layout'),
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
  double fnum = 0.0;
  double snum = 0.0;
  var input = '';
  var output = '0';
  var textIOColorIP = Colors.black;
  var textIOColorOP = Colors.black;
  var operatorList = ['^', '÷', '*', '-', '+', '!'];

  var operation = '';
  var outputSize = 52.0;
  var inputSize = 52.0;
  var hideInput = false;
  var calculationComplete = false;

  List<calculationHistoryItem> history = [];

onButtonClick(value) {
  const int maxInputLength = 23; // Set your desired maximum input length

  if (input.length < maxInputLength + 1) {
    if (value == 'C') {
      input = '';
      output = '0';
      outputSize = 52.0;
      textIOColorOP = Colors.black;
      history = [];
      calculationComplete = false;
    } else if (value == '<') {
      if (calculationComplete == false) {
        hideInput = false;
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
          // output = input.substring(0, output.length -1 );
          evaluateExpression(input);
          textIOColorIP = Colors.black;
          textIOColorOP = Colors.black.withOpacity(0.6);
          if (input.length > 10) {
            inputSize = 30;
            outputSize = 25;
          } else {
            inputSize = 52;
            outputSize = 34.0;
          }

          if(input.isEmpty){
            output = '';
          }
          
        }
      }
    } else if (value == '=') {
      evaluateExpression(input);
      history.add(calculationHistoryItem(input, output));
      calculationComplete = true;
    } else {
      if (calculationComplete) {
        if (value == '^' ||
            value == '÷' ||
            value == 'x' ||
            value == '-' ||
            value == '!' ||
            value == '+') {
          operatorAsInput(value);
          input = output.replaceAll('=', "");
        } else {
          input = '';
          output = '';
        }
      }
      calculationComplete = false;
      try {
        if (value == '^' ||
            value == '÷' ||
            value == 'x' ||
            value == '-' ||
            value == '!' ||
            value == '+') {
          operatorAsInput(value);
        } else {
          input = input + value;
        }
        evaluateExpression(input);
      } catch (e) {
        // Handle any potential errors here
      }
      hideInput = false;
      outputSize = 30;
      textIOColorIP = Colors.black;
      textIOColorOP = Colors.black.withOpacity(0.6);
      if (input.length > 10) {
        inputSize = 30;
        outputSize = 25;
      } else {
        inputSize = 52;
      }
    }
    // Check if the input length exceeds the maximum limit
    if (input.length > maxInputLength) {
      // Truncate the input to the maximum limit
      input = input.substring(0, maxInputLength);
    }

    setState(() {});
  }
}


  evaluateExpression(String input) {
    if (input.isNotEmpty) {
      var userInput = input;
      userInput = userInput.replaceAll('x', '*');
      userInput = userInput.replaceAll('÷', '/');
      userInput = userInput.replaceAll(RegExp('[X=,]'), '');
      if (operatorList.any((op) => userInput.endsWith(op))) {
        userInput = userInput.substring(0, userInput.length - 1);
      }

      Parser p = Parser();
      Expression expression = p.parse(userInput);
      ContextModel cm = ContextModel();
      var finalValue = expression.evaluate(EvaluationType.REAL, cm);
      output = '=${_formatOutput(finalValue.toString())}';
      if (output.endsWith('.0')) {
        output = output.substring(0, output.length - 2);
      }

      //input = output;
      inputSize = 32;
      textIOColorIP = Colors.black.withOpacity(0.6);
      textIOColorOP = Colors.black;
      outputSize = 52;

      if (output.length > 9) {
        outputSize = 32;
      }

      //input = output.replaceFirst('=', "");
      //hideInput = true;
    }
  }

  operatorAsInput(String value) {
    if (input.isNotEmpty) {
      bool lastCharIsOperator = input.endsWith('^') ||
          input.endsWith('÷') ||
          input.endsWith('x') ||
          input.endsWith('-') ||
          input.endsWith('!') ||
          input.endsWith('+');

      if (lastCharIsOperator) {
        input = input.substring(0, input.length - 1) + value;
      } else {
        input = input + value;
      }
    }
  }

  String _formatOutput(String value) {
    // Add commas after every three digits
    var parts = value.split('.');
    parts[0] = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return parts.join('.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: ListView(
                          reverse:
                              true, // Display the latest history at the bottom
                          padding: EdgeInsets.zero,
                          children: history.reversed.map((item) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item.expression,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  Text(
                                    item.result,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            _formatOutput(input),
                            style: TextStyle(
                              fontSize: inputSize,
                              color: hideInput
                                  ? Colors.transparent
                                  : textIOColorIP,
                              // or TextOverflow.fade
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          _formatOutput(output),
                          style: TextStyle(
                            fontSize: outputSize,
                            color: textIOColorOP,
                            // or TextOverflow.fade
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.2),
                    ),
                  ),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: <Widget>[
                      button(text: 'C', tcolor: Colors.deepOrange),
                      button(
                          text: '<',
                          tcolor: Colors.transparent,
                          icon: Icons.backspace_outlined),
                      button(text: '^', tcolor: Colors.deepOrange),
                      button(text: '÷', tcolor: Colors.deepOrange),
                      button(text: '7'),
                      button(text: '8'),
                      button(text: '9'),
                      button(text: 'x', tcolor: Colors.deepOrange),
                      button(text: '4'),
                      button(text: '5'),
                      button(text: '6'),
                      button(text: '-', tcolor: Colors.deepOrange),
                      button(text: '1'),
                      button(text: '2'),
                      button(text: '3'),
                      button(text: '+', tcolor: Colors.deepOrange),
                      button(text: '!', tcolor: Colors.deepOrange),
                      button(text: '0'),
                      button(text: '.'),
                      button(
                        text: '=',
                        tcolor: Colors.white,
                        bgcolor: Colors.deepOrange,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button({
    text,
    tcolor = Colors.black,
    bgcolor = Colors.white,
    icon,
  }) {
    return TextButton(
      onPressed: () => onButtonClick(text),
      style: TextButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: bgcolor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Colors.deepOrange,
            ),
          Text(
            text,
            style: TextStyle(
              color: tcolor,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class calculationHistoryItem {
  final String expression;
  final String result;

  calculationHistoryItem(this.expression, this.result);
}
