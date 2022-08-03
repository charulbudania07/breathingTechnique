import 'dart:convert';

RhythmicModel rhythmicModelFromJson(String str) => RhythmicModel.fromJson(json.decode(str));

String rhythmicModelToJson(RhythmicModel data) => json.encode(data.toJson());

class RhythmicModel {
  RhythmicModel({
     this.techniqueId,
     this.techniqueName,
     this.createdAt,
     this.questions,
  });

  String? techniqueId="";
  String? techniqueName="";
  String? createdAt="";
  List<Question>? questions=[];

  factory RhythmicModel.fromJson(Map<String, dynamic> json) => RhythmicModel(
    techniqueId: json["techniqueId"],
    techniqueName: json["techniqueName"],
    createdAt: json["createdAt"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "techniqueId": techniqueId,
    "techniqueName": techniqueName,
    "createdAt": createdAt,
    "questions": List<dynamic>.from(questions!.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'RhythmicModel{techniqueId: $techniqueId, techniqueName: $techniqueName, createdAt: $createdAt, questions: $questions}';
  }
}

class Question {
  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
  });

  String id;
  String question;
  List<String> options;
  List<String> answer;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    question: json["question"],
    options: List<String>.from(json["options"].map((x) => x)),
    answer: List<String>.from(json["answer"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "options": List<dynamic>.from(options.map((x) => x)),
    "answer": List<dynamic>.from(answer.map((x) => x)),
  };

  @override
  String toString() {
    return 'Question{id: $id, question: $question, options: $options, answer: $answer}';
  }
}
