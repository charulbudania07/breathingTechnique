import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppBreatheInAnimation extends StatefulWidget{

  List<String> textList= [];
  List<int> durationList= [];
 int total;
  var height;
  var width;
  bool isCircleAnimation=false;
  int timerMaxSeconds = 96;
  int currentSeconds = 0;
  int iteration = 0;
  late List<double> sizes;
  late double progress;
int totalDuration=1;
double dotRadius=14.0;
  late Animation<double> animationRotation;

  AppBreatheInAnimation(

       this.textList,
     this.durationList,
    this.total,
      this.height,
      this.width,
       this.isCircleAnimation,
       this.timerMaxSeconds,
      this.currentSeconds,
      this.iteration,
    this.sizes,
      this.progress,this.totalDuration,
      this.animationRotation);

  @override
  State<StatefulWidget> createState() {

    return AppBreatheInAnimationState();
  }

}
class AppBreatheInAnimationState extends State<AppBreatheInAnimation>{


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // for (int i = 0; i < widget.durationList.length; i++) {
    //   sum = sum + widget.durationList[i];
    // }
    // widget.controller = AnimationController(
    //     lowerBound: 0.0,
    //     upperBound: 1.0,
    //     duration: Duration(seconds: sum),
    //     vsync: this);

  }
  @override
  Widget build(BuildContext context) {

  return Scaffold(
    backgroundColor: Colors.transparent,
    body:Stack(
      children: [
        Positioned(
            top: 350,
            left: 50,
            right: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You have ${((widget.timerMaxSeconds - widget.currentSeconds)).toString().padLeft(2, '0')} seconds remaining",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),


        Center(child: AnimatedContainer(
            duration: Duration(seconds: widget.durationList[widget.iteration]),
            width: widget.sizes[widget.iteration],
            height: widget.sizes[widget.iteration],
            child: CustomPaint(
              painter: CircleRedPainter(
                  text: widget.textList[widget.iteration],
                  breatheIn: double.parse(widget.durationList[1].toString()),
                  breatheOut: double.parse(widget.durationList[3].toString()),
                  hold1: double.parse(widget.durationList[2].toString()),
                  hold2: double.parse(widget.durationList[4].toString()),
                  progress: widget.progress),
            ),


          ),







          // Center(
          //     child:
          //     AnimatedContainer(
          //         duration: Duration(seconds: timerMaxSeconds),
          //         width: sizes[iteration],
          //         height: sizes[iteration],
          //         child:RotationTransition(
          //
          //       turns: animationRotation,
          //       child: Transform.translate(
          //           child:
          //           // Dot(
          //           //   radius: dotRadius,
          //           //   color: Colors.red,
          //           // ),
          //           CustomPaint(
          //               painter:  _circleRedPainter= CircleRedPainter(
          //                   text: textArray[iteration],
          //                   breatheIn: double.parse(duration[1].toString()),
          //                   breatheOut: double.parse(duration[3].toString()),
          //                   hold1: double.parse(duration[2].toString()),
          //                   hold2: double.parse(duration[4].toString()),
          //               progress: controller.value)),
          //           offset: Offset(
          //            sizes[iteration]/2,0
          //             //_circleRedPainter.tempRadius,_circleRedPainter.tempRadius
          //             // dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
          //             // //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
          //             // dotRadius * 9.5 * math.sin(0.0 +3 * math.pi / 2),
          //           )),
          //
          //     ))),

          // Expanded(
          //   child: AnimatedBuilder(
          //       animation: controller,
          //       builder: (context, snapshot) {
          //         return Center(
          //           child: CustomPaint(
          //             painter: CirclesPainter2(
          //               circles: 1.0,
          //               progress: controller.value,
          //               showDots: true,
          //               showPath: true,
          //             ),
          //           ),
          //         );
          //       }),
          // ),



        ),





        /*
          RotationTransition(
            turns: animationRotation,
            child: Transform.translate(
                child: Dot(
                  radius: dotRadius,
                  color: Colors.red,
                ),
                offset: Offset(
                  dotRadius * 9.5 * math.cos(0.0 + 2.5 * math.pi / 2),
                  //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                  dotRadius * 9.5 * math.sin(0.0 +2.5 * math.pi / 2),
                )),

          ),*/
      ],
    ),
    // AnimatedOpacity(
    //   opacity: widget.isCircleAnimation ? 1 : 0,
    //   duration: const Duration(seconds: 1),
    //   child:
    //
    //   Stack(
    //     children: [
    //       Positioned(
    //           top: 350,
    //           left: 50,
    //           right: 50,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Row(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   "You have ${((widget.timerMaxSeconds - widget.currentSeconds)).toString().padLeft(2, '0')} seconds remaining",
    //                   textAlign: TextAlign.center,
    //                   style: const TextStyle(
    //                       color: Colors.amber,
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //               ],
    //             ),
    //           )),
    //
    //
    //       Center(child: Container(
    //               decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.red),
    //               padding: EdgeInsets.all(10.0),
    //               child: AnimatedContainer(
    //                 duration: Duration(seconds: widget.durationList[widget.iteration]),
    //                 width: widget.sizes[widget.iteration],
    //                 height: widget.sizes[widget.iteration],
    //                 child: CustomPaint(
    //                   painter: CircleRedPainter(
    //                       text: widget.textList[widget.iteration],
    //                       breatheIn: double.parse(widget.durationList[1].toString()),
    //                       breatheOut: double.parse(widget.durationList[3].toString()),
    //                       hold1: double.parse(widget.durationList[2].toString()),
    //                       hold2: double.parse(widget.durationList[4].toString()),
    //                       progress: widget.progress),
    //                 ),
    //
    //
    //               ),)
    //
    //
    //
    //
    //
    //             // Center(
    //             //     child:
    //             //     AnimatedContainer(
    //             //         duration: Duration(seconds: timerMaxSeconds),
    //             //         width: sizes[iteration],
    //             //         height: sizes[iteration],
    //             //         child:RotationTransition(
    //             //
    //             //       turns: animationRotation,
    //             //       child: Transform.translate(
    //             //           child:
    //             //           // Dot(
    //             //           //   radius: dotRadius,
    //             //           //   color: Colors.red,
    //             //           // ),
    //             //           CustomPaint(
    //             //               painter:  _circleRedPainter= CircleRedPainter(
    //             //                   text: textArray[iteration],
    //             //                   breatheIn: double.parse(duration[1].toString()),
    //             //                   breatheOut: double.parse(duration[3].toString()),
    //             //                   hold1: double.parse(duration[2].toString()),
    //             //                   hold2: double.parse(duration[4].toString()),
    //             //               progress: controller.value)),
    //             //           offset: Offset(
    //             //            sizes[iteration]/2,0
    //             //             //_circleRedPainter.tempRadius,_circleRedPainter.tempRadius
    //             //             // dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
    //             //             // //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
    //             //             // dotRadius * 9.5 * math.sin(0.0 +3 * math.pi / 2),
    //             //           )),
    //             //
    //             //     ))),
    //
    //             // Expanded(
    //             //   child: AnimatedBuilder(
    //             //       animation: controller,
    //             //       builder: (context, snapshot) {
    //             //         return Center(
    //             //           child: CustomPaint(
    //             //             painter: CirclesPainter2(
    //             //               circles: 1.0,
    //             //               progress: controller.value,
    //             //               showDots: true,
    //             //               showPath: true,
    //             //             ),
    //             //           ),
    //             //         );
    //             //       }),
    //             // ),
    //
    //
    //
    //       ),
    //
    //       // RotationTransition(
    //       //   turns: animationRotation,
    //       //   child: Transform.translate(
    //       //       child: Dot(
    //       //         radius: dotRadius,
    //       //         color: Colors.red,
    //       //       ),
    //       //       offset: Offset(
    //       //         dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
    //       //         //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
    //       //         dotRadius * 9.5 * math.sin(0.0 +3 * math.pi / 2),
    //       //       )),
    //       //
    //       // )
    //
    //
    //
    //       /*
    //       RotationTransition(
    //         turns: animationRotation,
    //         child: Transform.translate(
    //             child: Dot(
    //               radius: dotRadius,
    //               color: Colors.red,
    //             ),
    //             offset: Offset(
    //               dotRadius * 9.5 * math.cos(0.0 + 2.5 * math.pi / 2),
    //               //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
    //               dotRadius * 9.5 * math.sin(0.0 +2.5 * math.pi / 2),
    //             )),
    //
    //       ),*/
    //     ],
    //   ),
    // )
  );
  }

}
class Dot extends StatelessWidget {
  final double? radius;
  final Color? color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}


class CircleRedPainter extends CustomPainter {
  final double breatheIn;
  final double hold1;
  final double breatheOut;
  final double hold2;
  final double progress;
  var path =Path();
  double tempRadius=13.0;
  var total = 0.0;
  static const Color centerCircleColor = Colors.white;
  static const Color centerCircleColor2 = Colors.transparent;
  List<Path> pathList=[];
  final String text;

  CircleRedPainter(
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

    for (int i = 0; i < radians.length; i++) {
    //  paint.color = colors![i % colors.length];

      // paint.color = colors![i % colors.length];
      // canvas.drawArc(Rect.fromCircle(center: center!, radius: radius!+10),
      //     startRadian!, radians[i], true, paint..color=Colors.white);

      print("startRadian2 "+startRadian.toString());
      print("radians "+radians[i].toString());


      //path = Path()..addArc(Rect.fromCircle(center: center!, radius: radius!+5),startRadian!,radians[i]);
     // startRadian += radians[i];
     


    }

  }
  Path createPath(var radius,var size,var center,var sweepAngle, var radian) {
    //  Path path = Path()..arcTo(Rect.fromLTWH(0.0, 0.0, size.width, size.height), 0.0, -pi / 2, true);
    var path = Path()..addArc(Rect.fromCircle(center: center!, radius: radius!+5),sweepAngle,radian);
    int n = 1;
    var range = List<int>.generate(n, (i) => i + 1);
    print("list generate"+range.toString());
    double angle = 2 * math.pi / n;
    for (int i in range) {
      double x = radius*math.cos(3  *angle);
      double y = radius* math.sin(3  *angle);
      path.addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
    }
    return path;
  }

  Path getCirclePath(double radius, Size size) => Path()
    ..addOval(Rect.fromCircle(
        center: Offset(size.width, size.height), radius: radius));

  @override
  void paint(Canvas canvas, Size size) {
    double radius = math.min(size.width / 2, size.height / 2);

    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color=Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;
    // final Paint paint2 = Paint()
    //
    //   ..isAntiAlias = true
    //   ..strokeWidth = 2.0
    //   ..color=Colors.red
    //   ..style = PaintingStyle.fill;

    Offset center = Offset(size.width / 2, size.height / 2);
    //   double radius = math.min(size.width / 2, size.height / 2);
    print("center"+center.toString());
    var sources =[breatheIn, hold1, breatheOut, hold2];
    var startRadian=3 * math.pi / 2;
    List<double> radians = [];
    for (var data in sources) {
      radians.add(data*3* math.pi / total);
    }


    for (int i = 0; i < radians.length; i++) {

      path = Path()
        ..addArc(Rect.fromCenter(
            center: center, width: size.width + 12, height: size.height + 12),
            startRadian, radians[i]);

      pathList.add(path);
      print("@@startRadian "+startRadian.toString()+" "+radians[i].toString()+ "  "+radians.length.toString());
      //startRadian+=radians[i];
    }
    //   for(int i=0;i<pathList.length;i++) {

    _drawCircle(
      canvas,
      paint,
      size,
      sources: [breatheIn, hold1, breatheOut, hold2],
      colors: [
        const Color(0xff1065b2),
        //
        // const Color(0xff2a9ef5),
        // const Color(0xffcfefff),
      ],
      center: center,
      radius: radius,
      startRadian: (3 * math.pi / 2),
    );
    canvas.drawCircle(center, radius / 1.12, paint..color = centerCircleColor);
  //  canvas.drawPath(getCirclePath(radius, size), paint..color= const Color(0xff1065b2));
   // canvas.drawCircle(center, radius / 1.12, paint..color = centerCircleColor);


    // _drawOuterCircle(
    //   canvas,
    //   paint,paint2,size,
    //   sources: [breatheIn, hold1, breatheOut, hold2],
    //   colors: [
    //     Colors.black54,
    //   ],
    //   center: center,
    //   radius: radius,
    //   startRadian: (3 * math.pi / 2),
    // );
    //  canvas.drawCircle(center, 10, paint..color = centerCircleColor2);
    tempRadius=radius;
    // canvas.drawCircle(center, 10, paint..color = Colors.red);
    //
    const textStyle = TextStyle(
        color: const Color(0xff00BBA9), fontSize: 16, fontWeight: FontWeight.bold);
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