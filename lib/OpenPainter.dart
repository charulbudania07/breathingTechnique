
import 'dart:math' as math;
import 'package:flutter/material.dart';

class OpenPainter extends CustomPainter {
  // final learned;
  // final notLearned;
  // final range;
  // final range2;
  // final totalQuestions;
  double pi = math.pi;
  final height;
  final width;

  OpenPainter({this.height, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 15;
   // Rect myRect = const Offset(-50.0, -50.0) & const Size(200.0, 200.0);
    double radius = math.min(size.width / 2, size.height / 2);
    var paint1 = Paint()
      ..color = const Color(0xFF264E8F)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    var paint2 = Paint()
      ..color = const Color(0xFF386DC3)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;
    var paint3 = Paint()
      ..color = Colors.yellow
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;

    var mList=[0,4,2,4,2];
    var total=0+4+2+4+2.0;


    colors: [
      const Color(0xff1065b2),
      const Color(0xffcfefff),
      const Color(0xff2a9ef5),
      const Color(0xffcfefff),
    ];

    var sx=14*9.5 * math.cos(0.0 + 3 * math.pi / 2);
    var sy=14* 9.5 * math.sin(0.0 +3 * math.pi / 2);

   canvas.drawCircle(Offset(size.width/2,size.height/2), height/2.08 , paint2 );
     canvas.drawArc(Rect.fromCenter(center: Offset(size.width/2,size.height/2),
         width: width, height: height),
    0.0, 7.0,false,  paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}