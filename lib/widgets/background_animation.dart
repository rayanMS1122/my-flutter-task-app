import 'dart:math';

import 'package:flutter/material.dart';

class BackgroundAnimations extends StatelessWidget {
  const BackgroundAnimations({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: const [
        Positioned.fill(
          child: BackgroundAnimation(color: Color(0xFF005ACD), top: 500),
        ),
        Positioned.fill(
          child:
              BackgroundAnimation(color: Color(0xFF0093CB), top: 0, left: 150),
        ),
        Positioned.fill(
          left: 200,
          top: 200,
          child: BackgroundAnimation(color: Color(0xFF6DD7FD)),
        ),
        Positioned.fill(
          left: 300,
          top: 600,
          child: BackgroundAnimation(color: Colors.yellow, top: 600, left: 350),
        ),
        Positioned.fill(
          left: 100,
          top: 400,
          child: BackgroundAnimation(color: Colors.green, top: 600, left: 350),
        ),
        Positioned.fill(
          left: 500,
          top: 450,
          child: BackgroundAnimation(
              color: Colors.amberAccent, top: 600, left: 350),
        ),
        Positioned.fill(
          left: 100,
          top: 720,
          child: BackgroundAnimation(
              color: Color.fromARGB(255, 252, 115, 115), top: 300, left: 150),
        ),
        Positioned.fill(
          left: 550,
          top: 0,
          child: BackgroundAnimation(
              color: Color.fromARGB(255, 129, 252, 115), top: 300, left: 150),
        ),
      ],
    );
  }
}

class BackgroundAnimation extends StatefulWidget {
  final Color color;
  final double? top;
  final double? left;

  const BackgroundAnimation({
    Key? key,
    required this.color,
    this.top,
    this.left,
  }) : super(key: key);

  @override
  _BackgroundAnimationState createState() => _BackgroundAnimationState();
}

class _BackgroundAnimationState extends State<BackgroundAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Offset> _positions;
  late double screenHeight = 0.0;
  late double screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _positions = List.generate(5, (index) => _randomOffset());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
  }

  Offset _randomOffset() {
    final random = Random();
    return Offset(
      random.nextDouble() * screenWidth,
      random.nextDouble() * screenHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: _positions.map((offset) {
          return AnimatedPositioned(
            left: offset.dx,
            top: offset.dy,
            duration: const Duration(seconds: 5),
            curve: Curves.easeInOut,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.scale(
                  scale: 2.5 + sin(_controller.value * 2.5 * pi),
                  child: child,
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
