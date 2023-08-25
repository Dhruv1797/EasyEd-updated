// To parse this JSON data, do
//
//     final teacher = teacherFromJson(jsonString);

import 'dart:convert';

Teacher teacherFromJson(String str) => Teacher.fromJson(json.decode(str));

String teacherToJson(Teacher data) => json.encode(data.toJson());

class Teacher {
  String id;
  List<Common> commons;
  List<UserDetail> userDetails;
  List<EducationalDetail> educationalDetails;
  List<Task> tasks;
  List<Note> notes;
  List<VideoLecture> videoLecture;
  List<dynamic> students;
  int v;

  Teacher({
    required this.id,
    required this.commons,
    required this.userDetails,
    required this.educationalDetails,
    required this.tasks,
    required this.notes,
    required this.videoLecture,
    required this.students,
    required this.v,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json["_id"],
        commons:
            List<Common>.from(json["commons"].map((x) => Common.fromJson(x))),
        userDetails: List<UserDetail>.from(
            json["userDetails"].map((x) => UserDetail.fromJson(x))),
        educationalDetails: List<EducationalDetail>.from(
            json["educationalDetails"]
                .map((x) => EducationalDetail.fromJson(x))),
        tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
        notes: List<Note>.from(json["notes"].map((x) => Note.fromJson(x))),
        videoLecture: List<VideoLecture>.from(
            json["videoLecture"].map((x) => VideoLecture.fromJson(x))),
        students: List<dynamic>.from(json["students"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "commons": List<dynamic>.from(commons.map((x) => x.toJson())),
        "userDetails": List<dynamic>.from(userDetails.map((x) => x.toJson())),
        "educationalDetails":
            List<dynamic>.from(educationalDetails.map((x) => x.toJson())),
        "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
        "notes": List<dynamic>.from(notes.map((x) => x.toJson())),
        "videoLecture": List<dynamic>.from(videoLecture.map((x) => x.toJson())),
        "students": List<dynamic>.from(students.map((x) => x)),
        "__v": v,
      };

  toMap() {}
}

class Common {
  DateTime createdOn;
  DateTime updatedOn;
  String id;

  Common({
    required this.createdOn,
    required this.updatedOn,
    required this.id,
  });

  factory Common.fromJson(Map<String, dynamic> json) => Common(
        createdOn: DateTime.parse(json["createdOn"]),
        updatedOn: DateTime.parse(json["updatedOn"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "createdOn": createdOn.toIso8601String(),
        "updatedOn": updatedOn.toIso8601String(),
        "_id": id,
      };
}

class EducationalDetail {
  String instituteName;
  String educationalDetailClass;
  String id;

  EducationalDetail({
    required this.instituteName,
    required this.educationalDetailClass,
    required this.id,
  });

  factory EducationalDetail.fromJson(Map<String, dynamic> json) =>
      EducationalDetail(
        instituteName: json["instituteName"],
        educationalDetailClass: json["class"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "instituteName": instituteName,
        "class": educationalDetailClass,
        "_id": id,
      };
}

class Note {
  String creator;
  String noteClass;
  String subject;
  String topic;
  String noteHash;
  bool isFree;
  String price;
  String notesPdfLink;
  String id;

  Note({
    required this.creator,
    required this.noteClass,
    required this.subject,
    required this.topic,
    required this.noteHash,
    required this.isFree,
    required this.price,
    required this.notesPdfLink,
    required this.id,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        creator: json["creator"],
        noteClass: json["class"],
        subject: json["subject"],
        topic: json["topic"],
        noteHash: json["noteHash"],
        isFree: json["isFree"],
        price: json["price"],
        notesPdfLink: json["notesPDFLink"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "creator": creator,
        "class": noteClass,
        "subject": subject,
        "topic": topic,
        "noteHash": noteHash,
        "isFree": isFree,
        "price": price,
        "notesPDFLink": notesPdfLink,
        "_id": id,
      };
}

class Task {
  String creator;
  String taskClass;
  String subject;
  String topic;
  List<Question> questions;
  String id;

  Task({
    required this.creator,
    required this.taskClass,
    required this.subject,
    required this.topic,
    required this.questions,
    required this.id,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        creator: json["creator"],
        taskClass: json["class"],
        subject: json["subject"],
        topic: json["topic"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "creator": creator,
        "class": taskClass,
        "subject": subject,
        "topic": topic,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "_id": id,
      };
}

class Question {
  String question;
  String questionType;
  List<Option> options;
  String id;

  Question({
    required this.question,
    required this.questionType,
    required this.options,
    required this.id,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"],
        questionType: json["questionType"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "questionType": questionType,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "_id": id,
      };
}

class Option {
  String optionNumber;
  String optionText;
  String id;
  bool? answer;

  Option({
    required this.optionNumber,
    required this.optionText,
    required this.id,
    required this.answer,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        optionNumber: json["optionNumber"],
        optionText: json["optionText"],
        id: json["_id"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "optionNumber": optionNumber,
        "optionText": optionText,
        "_id": id,
        "answer": answer,
      };
}

class UserDetail {
  String firstName;
  String lastName;
  String email;
  String mobile;
  String avatar;
  String id;

  UserDetail({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.avatar,
    required this.id,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        mobile: json["mobile"],
        avatar: json["avatar"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "mobile": mobile,
        "avatar": avatar,
        "_id": id,
      };
}

class VideoLecture {
  String subject;
  String topic;
  String videoLink;
  String videoTitle;
  String id;

  VideoLecture({
    required this.subject,
    required this.topic,
    required this.videoLink,
    required this.videoTitle,
    required this.id,
  });

  factory VideoLecture.fromJson(Map<String, dynamic> json) => VideoLecture(
        subject: json["subject"],
        topic: json["topic"],
        videoLink: json["videoLink"],
        videoTitle: json["videoTitle"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "topic": topic,
        "videoLink": videoLink,
        "videoTitle": videoTitle,
        "_id": id,
      };
}
