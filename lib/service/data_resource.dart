
import 'package:flutter/material.dart';

class DataResource<T extends dynamic> {
  Status status;
  T data;
  String message;
  DataResource({@required this.status, this.data, this.message});

  static DataResource<T> init<T extends dynamic>() {
    return DataResource(status: Status.INIT,);
  }

  static DataResource<T> success<T extends dynamic>(T data) {
    return DataResource(status: Status.SUCCESS, data: data,);
  }

  static DataResource<T> failure<T extends dynamic>(String message) {
    return DataResource(status: Status.FAILURE, message: message);
  }

  static DataResource<T> loading<T extends dynamic>() {
    return DataResource(status: Status.LOADING,);
  }

  static DataResource<T> noResults<T extends dynamic>() {
    return DataResource(status: Status.NO_RESULTS,);
  }

  static DataResource<T> loadingMore<T extends dynamic>(T data) {
    return DataResource(status: Status.LOADING_MORE, data: data,);
  }

  static DataResource<T> noMoreResults<T extends dynamic>(T data) {
    return DataResource(status: Status.NO_MORE_RESULTS, data: data,);
  }

}

enum Status { INIT, SUCCESS, FAILURE, LOADING, NO_RESULTS, LOADING_MORE, NO_MORE_RESULTS }