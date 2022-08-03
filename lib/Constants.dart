import 'package:intl/intl.dart';

class Constants{
  static String techniqueId ="${DateTime.now().millisecond}";
  static const String techniqueName= "Rhythmic";
  static String createdAt=DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());
  static const String questionId1="1";
  static const String questionId2="2";
  static const String question1="Are you feeling better?  Are you more";
  static const String question2="Was this practice effective?";
  static const List<String> option1 = ['calm','energetic', 'relaxed','focused'];
  static const List<String> option2=["yes","no"];
}