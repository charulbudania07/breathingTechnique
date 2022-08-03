import 'package:flutter/cupertino.dart';
import 'package:rhythmicbreathingtechnique/Services.dart';
import 'package:rhythmicbreathingtechnique/model/NetworkResponse.dart';
import 'package:rhythmicbreathingtechnique/model/RhythmicModel.dart';

class RhythmicBreathingProvider extends ChangeNotifier {
  bool _showLoader=false;
  bool _isAnimation = false;
  List<RhythmicModel> _totalData=[];
  List<RhythmicModel> _effectiveData=[];

  postData(RhythmicModel rhythmicModel) async {
    _showLoader = true;
    notifyListeners();
    final value = await RhythmicBreathingService.getInstance()
        .createData(rhythmicModel);
    print("@@@value");
   print(value);
   if(value){
    getAllData(rhythmicModel.techniqueName);
   }
    _showLoader = false;
    notifyListeners();
  }

  getAllData(String? techniqueName) async {
    _showLoader =true;
    NetworkResponse networkResponse  =await RhythmicBreathingService.getInstance()
        .getRecord(techniqueName!);
    if(networkResponse.response){
      print(networkResponse.responseObject.toString());
      _totalData = networkResponse.responseObject as List<RhythmicModel>;
      _effectiveData =_totalData.where((element){
        var result = element.questions!.where((value) => value.id=="2").toList();
       if(result[0].answer.contains("yes")){
         return true;
       }
       else{
         return false;
       }
      }).toList();
    }
    print(_totalData.length);
    print(_effectiveData.length);
    _showLoader = false;
    notifyListeners();
  }

  setAnimation( bool flag){
    _isAnimation=flag;
  }




  bool? get showLoader => _showLoader;
  bool? get isAnimation => _isAnimation;
  List<RhythmicModel>? get totalData => _totalData;
  List<RhythmicModel>? get effectiveData => _effectiveData;


}