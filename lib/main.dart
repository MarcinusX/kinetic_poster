import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinetic poster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Inter',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool isOnLeft(double rotation) => math.cos(rotation) > 0;

  @override
  Widget build(BuildContext context) {
    final numberOfTexts = 20;
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(
            numberOfTexts,
            (index) {
              return AnimatedBuilder(
                animation: _animationController,
                child: LinearText(),
                builder: (context, child) {
                  final animationRotationValue =
                      _animationController.value * 2 * math.pi / numberOfTexts;
                  double rotation = 2 * math.pi * index / numberOfTexts +
                      math.pi / 2 +
                      animationRotationValue;
                  if (isOnLeft(rotation)) {
                    rotation = -rotation +
                        2 * animationRotationValue -
                        math.pi * 2 / numberOfTexts;
                  }
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(rotation)
                      ..translate(-120.0),
                    child: LinearText(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class LinearText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        child: Text(
          'LINEAR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 110,
          ),
        ),
        foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.9),
              Colors.transparent
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.0, 0.2, 0.8],
          ),
        ),
      ),
    );
  }
}
