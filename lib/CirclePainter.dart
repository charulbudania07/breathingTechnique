import 'package:flutter/material.dart';
import 'dart:math' as math;

class QuadrantCirclePainter extends CustomPainter {
  final double breatheIn;
  final double hold1;
  final double breatheOut;
  final double hold2;

  static const Color centerCircleColor = Colors.black;
  static const Color centerCircleColor2 = Colors.transparent;

  final String text;

  QuadrantCirclePainter(
      {required this.text,
        required this.breatheIn,
        required this.breatheOut,
        required this.hold1,
        required this.hold2}); // 1 quadrant = 90 degrees

  void _drawCircle(Canvas canvas, Paint paint,
      {Offset? center,
        double? radius,
        List<double>? sources,
        List<Color>? colors,
        double? startRadian}) {
   // Offset center_min = Offset(size.width / 2, size.height / 2);
    var total = 0.0;
    for (var d in sources!) {
      total += d;
    }
    List<double> radians = [];
    for (var data in sources) {
      radians.add(data * 2 * math.pi / total);
    }
    print("startRadian "+startRadian.toString());

    for (int i = 0; i < radians.length; i++) {
      paint.color = colors![i % colors.length];

     // paint.color = colors![i % colors.length];
      canvas.drawArc(Rect.fromCircle(center: center!, radius: radius!),
          startRadian!, radians[i], true, paint);



      // canvas.drawArc(Rect.fromCircle(center: center!, radius: radius!+10),
      //     startRadian!, radians[i], true, paint2);

      startRadian += radians[i];
      print("startRadian2 "+startRadian.toString());
      print("radians "+radians[i].toString());
    }
  }


  Path getCirclePath(double radius, Size size) => Path()
    ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius));

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;
    final Paint paint2 = Paint()

      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..color=Colors.red
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = math.min(size.width / 2, size.height / 2);
    print("center"+center.toString());

    _drawCircle(
      canvas,
      paint,
      sources: [breatheIn, hold1, breatheOut, hold2],
      colors: [
        const Color(0xff1065b2),
        const Color(0xffcfefff),
        const Color(0xff2a9ef5),
        const Color(0xffcfefff),
      ],
      center: center,
      radius: radius,
      startRadian: (3 * math.pi / 2),
    );

  //  canvas.drawCircle(center, 10, paint..color = centerCircleColor2);
    canvas.drawCircle(center, radius / 1.12, paint..color = centerCircleColor);

    const textStyle = TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
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
}