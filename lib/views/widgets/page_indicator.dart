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
          GestureDetector(
            onTap: () {
              // Verifica si no estamos en la primera página
              if (controller.page! > 0) {
                controller.previousPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
            child: Icon(Icons.arrow_left),
          ),
          SmoothPageIndicator(
            controller: controller,
            count: count,
            effect: WormEffect(),
          ),
          GestureDetector(
            onTap: () {
              // Verifica si no estamos en la última página
              if (controller.page! < count - 1) {
                controller.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
            child: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}
