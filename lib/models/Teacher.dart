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
  int v;
  List<Sharedlecture>? sharedlectures;
  List<Sharednote>? sharednotes;
  List<Sharedtask>? sharedtasks;

  Teacher({
    required this.id,
    required this.commons,
    required this.userDetails,
    required this.educationalDetails,
    required this.tasks,
    required this.notes,
    required this.videoLecture,
    required this.v,
    this.sharedlectures,
    this.sharednotes,
    this.sharedtasks,
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
        v: json["__v"],
        sharedlectures: List<Sharedlecture>.from(
            json["sharedlectures"].map((x) => Sharedlecture.fromJson(x))),
        sharednotes: List<Sharednote>.from(
            json["sharednotes"].map((x) => Sharednote.fromJson(x))),
        sharedtasks: List<Sharedtask>.from(
            json["sharedtasks"].map((x) => Sharedtask.fromJson(x))),
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
        "__v": v,
        "sharedlectures":
            List<dynamic>.from(sharedlectures!.map((x) => x.toJson())),
        "sharednotes": List<dynamic>.from(sharednotes!.map((x) => x.toJson())),
        "sharedtasks": List<dynamic>.from(sharedtasks!.map((x) => x.toJson())),
      };
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
  String id;
  String creator;
  String noteClass;
  String subject;
  String topic;
  bool isFree;
  String price;
  String notesPdfLink;
  int v;

  Note({
    required this.id,
    required this.creator,
    required this.noteClass,
    required this.subject,
    required this.topic,
    required this.isFree,
    required this.price,
    required this.notesPdfLink,
    required this.v,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["_id"],
        creator: json["creator"],
        noteClass: json["class"],
        subject: json["subject"],
        topic: json["topic"],
        isFree: json["isFree"],
        price: json["price"],
        notesPdfLink: json["notesPDFLink"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "creator": creator,
        "class": noteClass,
        "subject": subject,
        "topic": topic,
        "isFree": isFree,
        "price": price,
        "notesPDFLink": notesPdfLink,
        "__v": v,
      };
}

class Sharedlecture {
  String sharedBy;
  VideoLecture lectureId;
  String id;

  Sharedlecture({
    required this.sharedBy,
    required this.lectureId,
    required this.id,
  });

  factory Sharedlecture.fromJson(Map<String, dynamic> json) => Sharedlecture(
        sharedBy: json["sharedBy"],
        lectureId: VideoLecture.fromJson(json["lectureID"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "sharedBy": sharedBy,
        "lectureID": lectureId.toJson(),
        "_id": id,
      };
}

class VideoLecture {
  String id;
  String subject;
  String topic;
  String videoLink;
  String videoTitle;
  int v;

  VideoLecture({
    required this.id,
    required this.subject,
    required this.topic,
    required this.videoLink,
    required this.videoTitle,
    required this.v,
  });

  factory VideoLecture.fromJson(Map<String, dynamic> json) => VideoLecture(
        id: json["_id"],
        subject: json["subject"],
        topic: json["topic"],
        videoLink: json["videoLink"],
        videoTitle: json["videoTitle"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "subject": subject,
        "topic": topic,
        "videoLink": videoLink,
        "videoTitle": videoTitle,
        "__v": v,
      };
}

class Sharednote {
  String sharedBy;
  String id;
  Note? notesId;

  Sharednote({
    required this.sharedBy,
    required this.id,
    this.notesId,
  });

  factory Sharednote.fromJson(Map<String, dynamic> json) => Sharednote(
        sharedBy: json["sharedBy"],
        id: json["_id"],
        notesId:
            json["notesID"] == null ? null : Note.fromJson(json["notesID"]),
      );

  Map<String, dynamic> toJson() => {
        "sharedBy": sharedBy,
        "_id": id,
        "notesID": notesId?.toJson(),
      };
}

class Sharedtask {
  String sharedBy;
  String id;
  Task? tasksId;

  Sharedtask({
    required this.sharedBy,
    required this.id,
    this.tasksId,
  });

  factory Sharedtask.fromJson(Map<String, dynamic> json) => Sharedtask(
        sharedBy: json["sharedBy"],
        id: json["_id"],
        tasksId:
            json["tasksID"] == null ? null : Task.fromJson(json["tasksID"]),
      );

  Map<String, dynamic> toJson() => {
        "sharedBy": sharedBy,
        "_id": id,
        "tasksID": tasksId?.toJson(),
      };
}

class Task {
  String id;
  String creator;
  String taskClass;
  String subject;
  String topic;
  List<Question> questions;
  int v;

  Task({
    required this.id,
    required this.creator,
    required this.taskClass,
    required this.subject,
    required this.topic,
    required this.questions,
    required this.v,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["_id"],
        creator: json["creator"],
        taskClass: json["class"],
        subject: json["subject"],
        topic: json["topic"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "creator": creator,
        "class": taskClass,
        "subject": subject,
        "topic": topic,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "__v": v,
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
  bool answer;
  String id;

  Option({
    required this.optionNumber,
    required this.optionText,
    required this.answer,
    required this.id,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        optionNumber: json["optionNumber"],
        optionText: json["optionText"],
        answer: json["answer"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "optionNumber": optionNumber,
        "optionText": optionText,
        "answer": answer,
        "_id": id,
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
