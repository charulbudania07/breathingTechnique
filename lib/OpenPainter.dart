
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
    // double firstLineRadianStart = 0;
    // double _unAnswered = 2*4 / total;
    // double firstLineRadianEnd = getPercentage(4, 12)* pi / 180;
    // canvas.drawArc(
    //     myRect, firstLineRadianStart, firstLineRadianEnd, false, paint1..color= const Color(0xff1065b2));
    //
    // double _learned = 2*4 / total;
    // double secondLineRadianEnd = getPercentage(2, 12) * pi / 180;
    // canvas.drawArc(myRect, firstLineRadianEnd, secondLineRadianEnd, false, paint1..color= const Color(0xffcfefff),);
    // double _notLearned = 1/ total;
    // double thirdLineRadianEnd = getPercentage(4, 12) * pi / 180;
    // print("values"+_unAnswered.toString()+""+ _learned.toString()+ " "+_notLearned.toString());
    // canvas.drawArc(myRect, firstLineRadianEnd + secondLineRadianEnd, thirdLineRadianEnd, false, paint1..color = const Color(0xff2a9ef5));
    //
    // double forthLineRadianEnd = getPercentage(2, 12) * pi / 180;
    // print("values"+_unAnswered.toString()+""+ _learned.toString()+ " "+_notLearned.toString());
    // canvas.drawArc(myRect, firstLineRadianEnd + secondLineRadianEnd+ thirdLineRadianEnd, forthLineRadianEnd,false, paint1..color =  const Color(0xffcfefff));
    // // double _unAnswered = (totalQuestions - notLearned - learned) * range / totalQuestions;
    // // double firstLineRadianEnd = (360 * _unAnswered) * math.pi / 180;
    // // canvas.drawArc(
    // //     myRect, firstLineRadianStart, firstLineRadianEnd, false, paint1);
    // //
    // // double _learned = (learned) * range / totalQuestions;
    // // double secondLineRadianEnd = getRadians(_learned);
    // // canvas.drawArc(myRect, firstLineRadianEnd, secondLineRadianEnd, false, paint2);
    // // double _notLearned = (notLearned) * range / totalQuestions;
    // // double thirdLineRadianEnd = getRadians(_notLearned);
    // // canvas.drawArc(myRect, firstLineRadianEnd + secondLineRadianEnd, thirdLineRadianEnd, false, paint3);c
    var sx=14*9.5 * math.cos(0.0 + 3 * math.pi / 2);
    var sy=14* 9.5 * math.sin(0.0 +3 * math.pi / 2);
   // canvas.drawArc(Rect.
    //fromCircle(center: Offset(size.width/2,size.height/2), radius: radius/1.10),
    //
   canvas.drawCircle(Offset(size.width/2,size.height/2), height/2.08 , paint2 );
    //canvas.drawCircle(Offset(size.width/2,size.height/2), height/2.5 , paint1..strokeWidth=5);
   // canvas.drawCircle(Offset(size.width/2,size.height/2), height/2.9 , paint1..strokeWidth=5..color=const Color(0xffcfefff)  );
   // canvas.drawCircle(Offset(size.width/2,size.height/2), height/3.2 , paint1..strokeWidth=5 );
     canvas.drawArc(Rect.fromCenter(center: Offset(size.width/2,size.height/2),
         width: width, height: height),
    0.0, 7.0,false,  paint1);


 //   canvas.drawOval(Rect.fromCenter(center:Offset(sx ,sy) , width: 10, height: 10),  paint2);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}