import 'dart:convert';
import 'package:covid19_assistant/helper/utils.dart';
import 'package:covid19_assistant/local/app_local.dart';


class ReportList{
  final List<ReportModel> reports;
  ReportList({
    this.reports,
  });

  factory ReportList.fromJson(List<dynamic> parsedJson) {
    List<ReportModel> reports = new List<ReportModel>();
    reports = parsedJson.map((i) => ReportModel.fromJson(i)).toList();
    return ReportList(reports: reports);
  }
}

List<ReportModel> reportModelFromJson(String str) => List<ReportModel>.from(json.decode(str).map((x) => ReportModel.fromJson(x)));

String reportModelToJson(List<ReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportModel {
  ReportModel({
    this.accuracy,
    this.createdAt,
    this.id,
    this.result,
    this.url,
  });

  String accuracy;
  DateTime createdAt;
  int id;
  String result;
  String url;

  String getCreatedAtDate(context){
    return Utils.getDateTimeValue(AppLocalizations.of(context).locale, createdAt.toString());
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    accuracy: json["accuracy"] == null ? null : json["accuracy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    id: json["id"] == null ? null : json["id"],
    result: json["result"] == null ? null : json["result"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "accuracy": accuracy == null ? null : accuracy,
    "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
    "id": id == null ? null : id,
    "result": result == null ? null : result,
    "url": url == null ? null : url,
  };
}
