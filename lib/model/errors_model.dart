// To parse this JSON data, do
//
//     final errorsModel = errorsModelFromJson(jsonString);

import 'dart:convert';

ErrorsModel errorsModelFromJson(String str) => ErrorsModel.fromJson(json.decode(str));

String errorsModelToJson(ErrorsModel data) => json.encode(data.toJson());

class ErrorsModel {
  ErrorsItem error;

  ErrorsModel({
    this.error,
  });

  factory ErrorsModel.fromJson(Map<String, dynamic> json) => ErrorsModel(
        error: json["error"] == null ? null : ErrorsItem.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error.toJson(),
      };
}

class ErrorsItem {
  String message;
  int statusCode;
  Details details;

  ErrorsItem({
    this.message,
    this.statusCode,
    this.details,
  });

  factory ErrorsItem.fromJson(Map<String, dynamic> json) => ErrorsItem(
        message: json["message"] == null ? null : json["message"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        details: json["details"] == null ? null : Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "statusCode": statusCode == null ? null : statusCode,
        "details": details == null ? null : details.toJson(),
      };
}

class Details {
  Details();

  factory Details.fromJson(Map<String, dynamic> json) => Details();

  Map<String, dynamic> toJson() => {};
}
