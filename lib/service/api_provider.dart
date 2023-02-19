import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'api_handler.dart';

class ApiProvider extends ApiHandler{
  static const String LOG_TAG = 'ApiProvider';

  static String baseUrl = "http://192.168.1.5:5000";
  static String _postImageURL = "$baseUrl/upload";
  static String _getReportsURL = "$baseUrl/images";

  static String _getVirusStatisticsPerCountryURL = "https://corona.lmao.ninja/v2/countries";
  static String _getAllVirusStatisticsURL = "https://corona.lmao.ninja/v2/all";

  Future<dynamic> uploadByteDataFile({Asset file, onData}) async {
    try{
      Uri uri = Uri.parse(_postImageURL);
      http.MultipartRequest request = http.MultipartRequest("POST", uri);
      ByteData byteData = await file.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
        'file',
        imageData,
        filename: file.name,
        contentType: MediaType("image", file.name.split(".").last),
      );
      request.files.add(multipartFile);
      await request.send().then((v) async {
        await http.Response.fromStream(v).then((val) {
          onData(val.body);
          // return val.body;
          // onFinish(PredictionModel.fromJson(json.decode(val.body)));
        }).catchError((e) {
          print('$LOG_TAG uploadByteDataFile : '  + e.toString());
          throw Exception('something_went_wrong');
        });
      }).catchError((e) {
        print('$LOG_TAG uploadByteDataFile : '  + e.toString());
        throw Exception('something_went_wrong');
      });
    } catch (e){
      print('$LOG_TAG uploadByteDataFile : '  + e.toString());
      throw Exception('something_went_wrong');
    }
  }

  Future<dynamic> getReports() async => await getMultiPartCallApi(url : _getReportsURL,);

  Future<dynamic> getStatistics() async => await getMultiPartCallApi(url : _getVirusStatisticsPerCountryURL,);
}

ApiProvider apiProvider = ApiProvider();