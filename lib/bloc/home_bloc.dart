import 'dart:convert';

import 'package:covid19_assistant/model/report_list.dart';
import 'package:covid19_assistant/model/statistic_list.dart';
import 'package:covid19_assistant/service/api_provider.dart';
import 'package:covid19_assistant/service/data_resource.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {

  ApiProvider _apiProvider = ApiProvider();

  static const String LOG_TAG = 'HomeBloc';

  final BehaviorSubject<DataResource<ReportModel>> _reportController = BehaviorSubject.seeded(DataResource.init());
  get reportStream => _reportController.stream;
  DataResource<ReportModel> getReportDataRes() => _reportController.value;
  setReportDataRes(DataResource<ReportModel> dataRes) => _reportController.sink.add(dataRes);

  fetchReport({@required file, onData}) async{
    try {
      setReportDataRes(DataResource.loading());
      var response = await _apiProvider.uploadByteDataFile(file: file, onData: (response) {
        print('$LOG_TAG fetchReport response: $response');
        DataResource<ReportModel> dataRes = DataResource.success(ReportModel.fromJson(json.decode(response)));
        setReportDataRes(dataRes);
      });
    } catch (error) {
      DataResource<ReportModel> dataRes =  DataResource.failure('something_went_wrong');
      setReportDataRes(dataRes);
      print('$LOG_TAG fetchReport Exception: ${error.toString()}');
    }
  }


  final _reportsController = BehaviorSubject<DataResource<List<ReportModel>>>();
  get reportsStream => _reportsController.stream;
  DataResource<List<ReportModel>> getReports() => _reportsController.value;
  setReports(DataResource<List<ReportModel>> dataRes) => _reportsController.sink.add(dataRes);

  fetchReports() async{
    try {
      setReports(DataResource.loading());
      var response = await _apiProvider.getReports();
      List reports = ReportList.fromJson(response).reports;
      DataResource<List<ReportModel>> dataRes = DataResource.noResults();
      if (reports.isNotEmpty) dataRes = DataResource.success(reports);
      setReports(dataRes);
    } on FormatException catch (error) {
      DataResource<List<ReportModel>> dataRes =  DataResource.failure(error.message);
      setReports(dataRes);
    } catch (error) {
      DataResource<List<ReportModel>> dataRes =  DataResource.failure('something_went_wrong');
      setReports(dataRes);
    }
  }

  final _StatisticsController = BehaviorSubject<DataResource<List<StatisticModel>>>();
  get statisticsStream => _StatisticsController.stream;
  DataResource<List<StatisticModel>> getStatistics() => _StatisticsController.value;
  setStatistics(DataResource<List<StatisticModel>> dataRes) => _StatisticsController.sink.add(dataRes);

  fetchStatistics() async{
    try {
      setStatistics(DataResource.loading());
      var response = await _apiProvider.getStatistics();
      List statistics = StatisticList.fromJson(response).statistics;
      DataResource<List<StatisticModel>> dataRes = DataResource.noResults();
      if (statistics.isNotEmpty) dataRes = DataResource.success(statistics);
      setStatistics(dataRes);
    } on FormatException catch (error) {
      DataResource<List<StatisticModel>> dataRes =  DataResource.failure(error.message);
      setStatistics(dataRes);
    } catch (error) {
      DataResource<List<StatisticModel>> dataRes =  DataResource.failure('something_went_wrong');
      setStatistics(dataRes);
    }
  }

}