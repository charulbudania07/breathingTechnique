import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'OpenPainter.dart';

class MyTestingAnimation extends StatefulWidget {
  final List<double> sizes = [150, 250, 250, 150, 150];
  final List<double> centerCircleSizes = [40, 90, 90, 40, 40];
  final List<int> duration = [0, 4, 2, 4, 2];

  int total = 0;
  int effective = 0;
  int notEffective = 0;
  int timerMaxSeconds = 96;
  int currentSeconds = 0;
  bool isAnimation = false;
  bool isCircleAnimation = true;

  @override
  State<StatefulWidget> createState() {
    return MyTestingAnimationState();
  }
}

class MyTestingAnimationState extends State<MyTestingAnimation> with SingleTickerProviderStateMixin {
late AnimationController animationController;
late Animation<double> animation;
double progress=0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(duration: Duration(seconds: 20), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {
          progress = animation.value;
        });
      });

    animationController.forward();


    // animationController = AnimationController(
    //     lowerBound: 0.0,
    //     upperBound: 1.0,
    //     duration: Duration(seconds: 5),
    //     vsync: this);
    // animationController.forward();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white70,
        body: Container(
          height: 400.0,
      width: 400.0,
     // alignment: Alignment.center,

          child: CustomPaint(
            painter: SquarePainter(animationController.value),
          ),
          // AnimatedContainer(
          //   duration: Duration(seconds: 3),
          //   child: CustomPaint(
          //     painter: SquarePainter(animationController.value),
          //   ),
          // ),
    ));
  }
}
class SquarePainter extends CustomPainter{
  final double progress;
  SquarePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint=Paint();
    paint.style=PaintingStyle.stroke;
    paint.strokeWidth=2;
    Path path=new Path();
    Rect rect=Rect.fromCenter(center: Offset(size.width/2-size.width/2*progress,size.height/2-size.height/2*progress), width: 20, height: 20);
    Rect rect1 =Rect.fromPoints(Offset(0,0),Offset(200,200));
    path.addRect(Rect.fromPoints(Offset(size.width/3,size.height/4),
        Offset(size.width/2,size.height/2) ));
    path.addOval(Rect.fromCircle(center: Offset(size.width/2 -size.width/5*progress,
        size.height/2.5-size.height/6),
        radius: 10));
  // canvas.drawRect(rect1, paint..color=Colors.red);
   canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}
