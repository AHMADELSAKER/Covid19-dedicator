import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as permissionHandler;

class Utils{

  static loadAssets({onError, onData}) async {
    if (await permissionHandler.Permission.storage.request().isGranted) {
      if (await permissionHandler.Permission.camera.request().isGranted) {
        try {
          List<Asset> resultList = await MultiImagePicker.pickImages(
            maxImages: 1,
            enableCamera: true,
            cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
            materialOptions: MaterialOptions(
              actionBarColor: "#FF633087",
              statusBarColor: "#ff7d5ab3",
              actionBarTitle: "Covid19 Assistant",
              allViewTitle: "All Photos",
              useDetailsView: false,
              selectCircleStrokeColor: "#FF633087",
            ),
          );
          onData(resultList.first);
        } on Exception catch (e) {
          print(e);
          onError();
        }
      }
    }
  }

  static Widget buildImage({@required String url, @required double width , @required double height, BoxFit fit=BoxFit.contain}) {

    Widget assetImage(resPath,){
      return Image.asset(
        resPath,
        fit: fit,
        width: width,
        height: width,
      );
    }

    if (url == null || url == '') {
      return assetImage('assets/images/course_cover_placeholder.jpg',);
    }

    if (url.startsWith("http")) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        placeholder:(context, url) {
          return assetImage('assets/images/course_cover_placeholder.jpg');
        },
        errorWidget: (context, url, error) {
          return assetImage('assets/images/course_cover_error.jpg');
        },
        // progressIndicatorBuilder:(context , url ,DownloadProgress progress){
        //   return CircularProgressIndicator();
        // },
        fadeInCurve: Curves.bounceIn,
        fadeOutCurve: Curves.bounceOut,
      );
    } else {
      return assetImage(url);
    }
  }

  static String getDateTimeValue(Locale local, String timeStamp) {
    final dateTime = DateTime.parse(timeStamp);
    final format = DateFormat.yMMMMd(local.languageCode);
    return format.format(dateTime);
  }

  static String getFormattedCount(var count){
    if (count < 9999) return count.toString();
    else if (count >= 9999 && count < 99999) return count.toString().substring(0, 2) + ' K';
    else return count.toString().substring(0, 2) + ' K';
  }

  static showToast(text, context) {
    Fluttertoast.showToast(
      msg: text,
    );
  }

  static getMyLocation({onGetLocation}) async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();

    onGetLocation(_locationData);
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

}