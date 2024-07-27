import 'package:flutter/material.dart';

class RouteManager {
    Route createRoute(Widget nextPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Start from the right
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var slideAnimation = animation.drive(tween);

      return SlideTransition(
        position: slideAnimation,
        child: child,
      );
    },
  );
}
}