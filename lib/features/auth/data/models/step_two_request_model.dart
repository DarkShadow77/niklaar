import 'dart:convert';

StepTwoRequestModel stepTwoRequestModelFromJson(String str) =>
    StepTwoRequestModel.fromJson(json.decode(str));

String stepTwoRequestModelToJson(StepTwoRequestModel data) =>
    json.encode(data.toJson());

class StepTwoRequestModel {
  StepTwoRequestModel({
    required this.password,
    required this.passwordConfirmation,
    required this.username,
    required this.referral,
  });

  final String password;
  final String passwordConfirmation;
  final String username;
  final String referral;

  factory StepTwoRequestModel.fromJson(Map<String, dynamic> json) =>
      StepTwoRequestModel(
        // Handle potential null values
        password: json["password"] ?? "",
        passwordConfirmation: json["password_confirmation"] ?? "",
        username: json["username"] ?? "",
        referral: json["referral"] ?? "",
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["password"] = password;
    data["password_confirmation"] = passwordConfirmation;
    data["username"] = username;
    data["referral"] = referral;

    return data;
  }
}
