import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;


class ResponsiveCirclePainter extends CustomPainter {
  final double breatheIn;
  final double hold1;
  final double breatheOut;
  final double hold2;
  final double progress;
  final bool isReset;
  var path =Path();
  double tempRadius=13.0;
  var total = 0.0;
  static const Color centerCircleColor = Colors.black;
  static const Color centerCircleColor2 = Colors.transparent;
  List<Path> pathList=[];
  final String text;

  ResponsiveCirclePainter(
      {required this.text,
        required this.breatheIn,
        required this.breatheOut,
        required this.hold1,
        required this.hold2,
        required this.progress, required this.isReset}); // 1 quadrant = 90 degrees

//
  @override
  void paint(Canvas canvas, Size size) {
    double radius = math.min(size.width / 2, size.height / 2);
//print("@@$progress");
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color=Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;
    final Paint paint2 = Paint()

      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..color=Colors.red
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);


    canvas.drawCircle(center, radius / 0.8, paint..color = const Color(
        0xFF386DC3));
    var r=radius / 0.8;
    //print("radius"+r.toString());
    //3rd outer circle
   canvas.drawCircle(center, radius / 0.9, paint..color = const Color(0xFF264E8F));
    var r1=radius / 0.88;
   // print("radius1"+r1.toString());
    //inner circle

    canvas.drawCircle(center, radius / 1.011, paint..color = const Color(
        0xFF71B9E4));
    var r2=radius / 1.05;
    //print("radius2"+r2.toString());
    // canvas.drawCircle(center, radius / 1.12, paint..color = const Color(
    //     0xFFCADCD8));

    // canvas.drawCircle(center, radius / 1.12, paint..color = const Color(
    //     0xFF264E8F));


    tempRadius=radius;
    // canvas.drawCircle(center, 10, paint..color = Colors.red);
    //
    const textStyle = TextStyle(
        color: const Color(
            0xffffffff), fontSize: 14, fontWeight: FontWeight.bold);
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
        textAlign:TextAlign.center,
      textWidthBasis:TextWidthBasis.parent
    );
    textPainter.layout(
      minWidth: 10,
      maxWidth: size.width,
    );
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
     textPainter.paint(canvas, offset);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  get currentRadius=> tempRadius;
}