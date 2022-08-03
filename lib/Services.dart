import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythmicbreathingtechnique/model/NetworkResponse.dart';
import 'package:rhythmicbreathingtechnique/model/RhythmicModel.dart';

class RhythmicBreathingService {
  int _total=0;
  int _effective=0;
  FirebaseFirestore? fireStoreInstance;
  static RhythmicBreathingService? _rhythmicBreathingService;


  static RhythmicBreathingService getInstance() {
    if (_rhythmicBreathingService == null)
      _rhythmicBreathingService = RhythmicBreathingService._internal();

    return _rhythmicBreathingService!;
  }

  RhythmicBreathingService._internal() {
    fireStoreInstance = FirebaseFirestore.instance;
  }

  @override
  Future<NetworkResponse> getRecord(String techniqueName) async {
    try {
      List<DocumentSnapshot>? docs;
      await fireStoreInstance!
          .collection("breathingtechnique").where(
          "techniqueName", isEqualTo: techniqueName)
          .get()
          .then((query) {
        docs = query.docs;
      });
      if (docs != null) {
        List<RhythmicModel> rhythmicModel = docs!.map((e){
          List<Question> questionData =[];
          e['questions'].forEach((v){
           questionData.add(Question.fromJson(v));
          });
          return RhythmicModel(
              questions: questionData,techniqueName: e['techniqueName'],techniqueId: e['techniqueId'],createdAt: e['createdAt']);
        }).toList();
        return NetworkResponse(true, 'Success!', rhythmicModel);
      } else {
        return NetworkResponse(false, 'No template found!', Null);
      }
    } catch (e) {
      return NetworkResponse(false, e.toString(), Null);
    }
  }


  @override
  Future<bool> createData(RhythmicModel rhythmicModel) async {
    try {
      print("Template Data :: ${rhythmicModel.toString()}");
      await fireStoreInstance!
          .collection("breathingtechnique")
          .doc(rhythmicModel.techniqueId)
          .set(rhythmicModel.toJson());
      return true;
    } catch (e) {
      print("Error in creating new template ${e.toString()}");
      return false;
    }
  }

  int? get total => _total;
  int? get effective => _effective;
}