// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'dart:convert';

List<Student> studentFromJson(String str) =>
    List<Student>.from(json.decode(str).map((x) => Student.fromJson(x)));

String studentToJson(List<Student> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Student {
  String id;
  List<Common> commons;
  List<UserDetail> userDetails;
  List<EducationalDetail> educationalDetails;
  List<dynamic> teacher;
  int v;

  Student({
    required this.id,
    required this.commons,
    required this.userDetails,
    required this.educationalDetails,
    required this.teacher,
    required this.v,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["_id"],
        commons:
            List<Common>.from(json["commons"].map((x) => Common.fromJson(x))),
        userDetails: List<UserDetail>.from(
            json["userDetails"].map((x) => UserDetail.fromJson(x))),
        educationalDetails: List<EducationalDetail>.from(
            json["educationalDetails"]
                .map((x) => EducationalDetail.fromJson(x))),
        teacher: List<dynamic>.from(json["teacher"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "commons": List<dynamic>.from(commons.map((x) => x.toJson())),
        "userDetails": List<dynamic>.from(userDetails.map((x) => x.toJson())),
        "educationalDetails":
            List<dynamic>.from(educationalDetails.map((x) => x.toJson())),
        "teacher": List<dynamic>.from(teacher.map((x) => x)),
        "__v": v,
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
