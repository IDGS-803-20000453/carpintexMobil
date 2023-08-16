import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  PageIndicator({required this.controller, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_left),
          SmoothPageIndicator(
            controller: controller,
            count: count,
            effect: WormEffect(),
          ),
          Icon(Icons.arrow_right),
        ],
      ),
    );
  }
}
