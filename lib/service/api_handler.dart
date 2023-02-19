import 'package:covid19_assistant/model/errors_model.dart';
import 'package:covid19_assistant/service/server_errors_handler.dart';
import 'package:dio/dio.dart';
import '../storage/data_store.dart';
import 'package:flutter/material.dart';

abstract class ApiHandler {

  Map<String, String> _headers = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String LOG_TAG = 'ApiHandler';

  Dio _createDioInstance(){
    // final dataStore = GetIt.I<DataStore>();
    // if (dataStore.user?.id != null) {
    //   print("$LOG_TAG: user's token is : " + dataStore.user.id);
    //   _headers['Authorization'] = dataStore.user.id;
    // } else {
    //   _headers['Authorization'] = "";
    // }
    // _headers['Authorization'] = "oeaZEgqzdWb07y4l7GVBqI4Qx323LK1AG8d7p7F1fDgIIsXzTuuRNr8pEJBGMPYY"; //TODO

    Dio dio = new Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true, error: true, request: true, requestBody: true, requestHeader: true,));
    return dio;
  }

  Future<dynamic> getMultiPartCallApi({@required url,}) async {
    Dio dio = _createDioInstance();
    return await makeHttpRequest(
        dio.get(url, options: Options(headers: _headers,)),
        // onData,
        // onError
    );
  }

  Future<dynamic> postMultiPartCallApi({@required url, body,}) async {
    Dio dio = _createDioInstance();
    return await makeHttpRequest(
        dio.post(url, data: body, options: Options(headers: _headers)),
        // onData,
        // onError
    );
  }

  // deleteMultiPartCallApi(String url, dynamic body,) async {
  //   ErrorsModel v;
  //   print(url);
  //
  //   if (DataStore.instance.user.id != null) {
  //     print(" is : " + DataStore.instance.user.id);
  //     _headers['Authorization'] = DataStore.instance.user.id;
  //   } else {
  //     _headers['Authorization'] = "";
  //   }
  //   Dio dio = Dio();
  //   var data;
  //   await dio.delete(url, options: Options(headers: _headers), data: body).then((Response val) {
  //     print(val.data);
  //     data = val.data;
  //   }).catchError((e) {
  //     print(e.response.statusCode);
  //     print(e.response.data);
  //     print(e);
  //
  //     v = ErrorsModel.fromJson(e.response.data);
  //
  //     data = ServerErrors.instance.getError(v.error);
  //   });
  //   return data;
  // }
  //
  // putMultiPartCallApi(url, body,) async {
  //   ErrorsModel v;
  //   print(url);
  //
  //   if (DataStore.instance.user.id != null) {
  //     print(" is : " + DataStore.instance.user.id);
  //     _headers['Authorization'] = DataStore.instance.user.id;
  //   } else {
  //     _headers['Authorization'] = "";
  //   }
  //   print(body);
  //   Dio dio = new Dio();
  //   var data;
  //   await dio.put(url, data: body, options: Options(headers: _headers)).then((val) {
  //     print("______________________ response");
  //     print(val.data);
  //     data = val.data;
  //   }).catchError((e) {
  //     print("______________________ error");
  //     print(e.response.statusCode);
  //     print(e.response.data);
  //     print(e);
  //
  //     v = ErrorsModel.fromJson(e.response.data);
  //     data = ServerErrors.instance.getError(v.error);
  //   });
  //   return data;
  // }
  //
  // putFormDataCallApi(url, dataToSend,) async {
  //   Map<String, String> formDataHeaders = {
  //     'content-type': 'multipart/form-data',
  //     'Accept': 'application/json',
  //   };
  //   ErrorsModel v;
  //   print(url);
  //
  //   if (DataStore.instance.user.id != null) {
  //     print(" is : " + DataStore.instance.user.id);
  //     _headers['Authorization'] = DataStore.instance.user.id;
  //   } else {
  //     _headers['Authorization'] = "";
  //   }
  //   dataToSend.removeWhere((key, value) => key == null || value == null);
  //   FormData body = FormData.fromMap(dataToSend);
  //   print(body.fields);
  //   Dio dio = new Dio();
  //   var data;
  //   await dio.put(url, data: body, options: Options(headers: formDataHeaders)).then((val) {
  //     print("______________________ response");
  //     print(val.data);
  //     data = val.data;
  //   }).catchError((e) {
  //     print("______________________ error");
  //     print(e.response.statusCode);
  //     print(e.response.data);
  //     print(e);
  //
  //     v = ErrorsModel.fromJson(e.response.data);
  //     data = ServerErrors.instance.getError(v.error);
  //   });
  //   return data;
  // }

  Future<dynamic> makeHttpRequest(Future<Response<dynamic>> httpReq,/* onData, onError*/) async{
    try{
      final response = await httpReq;
      // onData(response.data);
      return response.data;
    } on DioError catch (e) {
      String message = _handleDioError(e);
      // onError(message);
      throw FormatException(message = message);
    } catch (e){
      // onError('something_went_wrong');
      throw Exception('something_went_wrong');
    }
  }

  String _handleDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.CANCEL:
        return "request_canceled";
      case DioErrorType.CONNECT_TIMEOUT:
        return "connection_timeout";
      case DioErrorType.DEFAULT:
        return "internet_connection_error";
      case DioErrorType.RECEIVE_TIMEOUT:
        return "receive_timeout";
      case DioErrorType.RESPONSE:
        ErrorsModel v = ErrorsModel.fromJson(dioError.response.data);
        return ServerErrors.instance.getError(v.error).message;
      case DioErrorType.SEND_TIMEOUT:
        return "send_timeout";

      default:
        return "something_went_wrong";
    }
  }

}

