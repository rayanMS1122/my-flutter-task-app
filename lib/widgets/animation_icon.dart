
// Define the AnimationIcon class
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationIcon extends StatefulWidget {
  const AnimationIcon({super.key});

  @override
  State<AnimationIcon> createState() => _AnimationIconState();
}

class _AnimationIconState extends State<AnimationIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool bookmarked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          bookmarked ? _controller.reverse() : _controller.forward();
          bookmarked = !bookmarked;
        });
      },
      child: SizedBox(
        width: 50,
        height: 50,
        child: Lottie.network(
          fit: BoxFit.cover,
          controller: _controller,
          "https://lottie.host/b6e12758-f9c4-4b8a-906b-6191db644d32/AVpLmxc8xx.json",
        ),
      ),
    );
  }
}
