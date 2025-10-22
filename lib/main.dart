import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // for expression evaluation

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terran Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        _evaluateExpression();
      } else if (value == 'x²') {
        // Square the last result or current input
        try {
          final target = _result.isNotEmpty ? _result : _expression;
          if (target.isEmpty) return;
          final numVal = double.parse(target);
          final squared = numVal * numVal;
          _expression = '$target²';
          _result = squared.toString();
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _expression += value;
      }
    });
  }

  void _evaluateExpression() {
    try {
      // Replace 'x' with '*' for multiplication
      final sanitized = _expression.replaceAll('x', '*');
      final expression = Expression.parse(sanitized);
      const evaluator = ExpressionEvaluator();
      final eval = evaluator.eval(expression, {});
      setState(() {
        _result = eval.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildButton(String text,
      {Color? color, double fontSize = 24, bool flex = false}) {
    return Expanded(
      flex: flex ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.deepPurple[200],
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terran's Calculator"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _result.isNotEmpty ? '= $_result' : '',
                    style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('/', color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('x', color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('-', color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('0', flex: true),
                      _buildButton('.', color: Colors.grey[400]),
                      _buildButton('+', color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('C', color: Colors.redAccent),
                      _buildButton('=', color: Colors.green),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('x²', color: Colors.blueAccent),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
