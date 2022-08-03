import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashState();
  }

}
class SplashState extends State<SplashScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return SizedBox(
     child:  SvgPicture.asset(
       "assets/splash.svg",
       height: 45,
       color: Colors.greenAccent,
       placeholderBuilder: (BuildContext context) => Container(
         padding: const EdgeInsets.all(30.0),
         child: const CircularProgressIndicator(),
       ),
     ),
   );
  }

}