import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import '../mixin/constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../mixin/constants.dart';
import '../mixin/mixins.dart';
import '../model/response.dart';

class IPost {
  static Future postData(dynamic data, Function updateUI, String url) async {
    final token = await Mixin.getPrefString(key: TOKEN);
    log(url.toString());
    var body = jsonEncode(data);
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

    var res = jsonDecode(response.body);
    JsonResponse jsonResponse = JsonResponse.fromJson(res);

    bool state = jsonResponse.success;
    String message = jsonResponse.message;
    log('---------------------$state------$message-----$res');
    if (state) {
      Mixin.prefString(pref: jsonResponse.token, key: TOKEN);
    }
    updateUI(state, message, jsonResponse.result);

    } on Exception catch (e) {
      log("Error ---$e");
      updateUI(CONN, CONNECTION, e.toString());
    }
  }

  static postFiles(List<XFile> files,Function updateUI, String url) async {
    try {
      log(url);
      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers.addAll({"Content-Type": "application/json"});

      for(int i=0; i<files.length; i++){
        request.files.add(await http.MultipartFile.fromPath(i == 0 ? "file" : "file$i",  files[i].path));
      }

      request.send().then((response) {
        bool state = response.headers["success"] == True;
        String message = response.headers['message']??'';
        response.stream.bytesToString().then((value){
          updateUI(state, message,value);
        });
      });
    } on Exception catch (e) {
      log("Error ---$e");
      updateUI(CONN, CONNECTION, e.toString());
    }
  }

  static postFileCropped(List<CroppedFile> files,Function updateUI, Uri url) async {

    try {
      final token = await Mixin.getPrefString(key: TOKEN);
      log(url.toString());
      log('Token- : $token');

      var request = http.MultipartRequest("POST",url);
      request.headers.addAll(
          {"Content-Type": "application/json",
            'Authorization': 'Bearer $token',});

      for(int i=0; i<files.length; i++){
        request.files.add(await http.MultipartFile.fromPath(i == 0 ? "file" : "file$i",  files[i].path));
      }

      request.send().then((response) {

        response.stream.bytesToString().then((value){

          log('Response: $value');

          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(value));

          bool state = jsonResponse.success;
          String message =jsonResponse.message;
          updateUI(state, message,jsonResponse.targetUrl);
        });
      });
    } on Exception catch (e) {
      log("Error ---$e");
      updateUI(CONN, CONNECTION, e.toString());
    }
  }

  static Future getData(Function updateUI, String url) async {
    log(url);
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    } on Exception catch (e) {
      log("Error ---$e");
      updateUI(CONN, CONNECTION, e.toString());
    }
    bool state = response?.headers["success"] == True;
    print(response?.headers);
    String message = response?.headers['message']??'';
    updateUI(state, message, response?.body.toString());
  }
}
