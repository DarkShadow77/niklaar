import 'dart:convert';

StepOneRequestModel stepOneRequestModelFromJson(String str) =>
    StepOneRequestModel.fromJson(json.decode(str));

String stepOneRequestModelToJson(StepOneRequestModel data) =>
    json.encode(data.toJson());

class StepOneRequestModel {
  StepOneRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  factory StepOneRequestModel.fromJson(Map<String, dynamic> json) =>
      StepOneRequestModel(
        // Handle potential null values
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        email: json["email"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["first_name"] = firstName;
    data["last_name"] = lastName;
    data["email"] = email;
    data["phone_number"] = phoneNumber;

    return data;
  }
}
