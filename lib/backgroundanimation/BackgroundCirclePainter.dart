import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;


class BackgroundCirclePainter extends CustomPainter {
  final double breatheIn;
  final double hold1;
  final double breatheOut;
  final double hold2;
  final double progress;
  var path =Path();
  double tempRadius=13.0;
  var total = 0.0;
  static const Color centerCircleColor = Colors.black;
  static const Color centerCircleColor2 = Colors.transparent;
  List<Path> pathList=[];
  final String text;

  BackgroundCirclePainter(
      {required this.text,
        required this.breatheIn,
        required this.breatheOut,
        required this.hold1,
        required this.hold2,
        required this.progress}); // 1 quadrant = 90 degrees

  void _drawCircle(Canvas canvas, Paint paint,Size size,
      {Offset? center,
        double? radius,
        List<double>? sources,
        List<Color>? colors,
        double? startRadian}) {
    final Paint paint2 = Paint()

      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..color=Colors.red
      ..style = PaintingStyle.stroke;

    // Offset center_min = Offset(size.width / 2, size.height / 2);
    var total = 0.0; Path extractPath;
    for (var d in sources!) {
      total += d;
    }
    List<double> radians = [];
    for (var data in sources) {
      radians.add(data*2 * math.pi / total);
    }
    print("startRadian "+startRadian.toString());

    // for (int i = 0; i < radians.length; i++) {
    //   paint.color = colors![i % colors.length];
    //
    //   // paint.color = colors![i % colors.length];
    //   canvas.drawArc(Rect.fromCircle(center: center!, radius: radius!),
    //       startRadian!, radians[i], true, paint);
//       // canvas.drawArc(Rect.fromCircle(center: center!, radius:10),
//       //     startRadian!, radians[i], true, paint);
//       // canvas.drawArc(Rect.fromCircle(center: center!, radius: 5),
//       //     startRadian!, radians[i], true, paint2);
//       // canvas.drawArc(Rect.fromCircle(center: center!, radius: radius!),
//       //     startRadian!, radians[i], true, paint);
//
//
//       print("startRadian2 "+startRadian.toString());
//       print("radians "+radians[i].toString());
//
//
//       //path = Path()..addArc(Rect.fromCircle(center: center!, radius: radius!+5),startRadian!,radians[i]);
//       startRadian += radians[i];
//       int n = 1;
//       //  var range = List<int>.generate(n, (i) => i + 1);
//       // print("list generate"+range.toString());
//       double angle = 2 * math.pi ;
//       //  for (int i in range) {
//       double x = (radius!+5)*  math.cos(1 *angle);
//       double y = (radius+5) * math.sin(1  *angle);
//       //path.addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
// //    var path = createPath(radius,size,center,startRadian,radians[0]);


  //  }





    // double angle = 2 * math.pi ;
    // //  for (int i in range) {
    // double x = (radius!+5)  math.cos(1  angle);
    // double y = (radius+5)  math.sin(1  angle);
    // path.addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
//   var path = createPath(radius,size,center,startRadian,radians[0]);
//     PathMetrics pathMetrics = path.computeMetrics();
//     for (PathMetric pathMetric in pathMetrics) {
//       Path extractPath = pathMetric.extractPath(
//         0.0,
//         pathMetric.length * progress,
//       );
//       canvas.drawPath(path, paint2);
//       try {
//         var metric = extractPath.computeMetrics().first;
//         final offset = metric.getTangentForOffset(metric.length)?.position;
//         canvas.drawCircle(offset!, 5.0, paint2);
//       } catch (e) {}
//     }
  }



  Path createPath(var radius,var size,var center,var sweepAngle, var radian) {
    //  Path path = Path()..arcTo(Rect.fromLTWH(0.0, 0.0, size.width, size.height), 0.0, -pi / 2, true);
    var path = Path()..addArc(Rect.fromCircle(center: center!, radius: radius!+5),sweepAngle,radian);
    int n = 1;
    var range = List<int>.generate(n, (i) => i + 1);
    print("list generate"+range.toString());
    double angle = 2 * math.pi / n;
    for (int i in range) {
      double x = radius*math.cos(i  *angle);
      double y = radius* math.sin(i  *angle);
      path.addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
    }
    return path;
  }

  Path getCirclePath(double radius, Size size) => Path()
    ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius));

  @override
  void paint(Canvas canvas, Size size) {
    double radius = math.min(size.width / 2, size.height / 2);

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

    _drawCircle(
      canvas,
      paint,
      size,
      sources: [breatheIn, hold1, breatheOut, hold2],
      colors: [
      const Color(0xffffffff)
        //const Color(0xff1065b2),
        // const Color(0xffcfefff),
        // const Color(0xff2a9ef5),
        // const Color(0xffcfefff),
      ],
      center: center,
      radius: radius,
      startRadian: (3 * math.pi / 2),
    );


    final paint11 = Paint()
      ..shader = RadialGradient(
        colors: [

            Colors.lightBlueAccent,
          Colors.deepPurple,

        ],
      ).createShader(Rect.fromCircle(
        center: const Offset(10,60),
        radius: radius,
      ));

   // canvas.drawPaint(paint11);
    canvas.drawCircle(center, radius / 1.12, paint11,);
    tempRadius=radius;
    // canvas.drawCircle(center, 10, paint..color = Colors.red);
    //
    const textStyle = TextStyle(
        color: const Color(
            0xffffffff), fontSize: 16, fontWeight: FontWeight.bold);
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

  get currentRadius=> tempRadius;
}