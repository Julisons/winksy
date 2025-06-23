import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:winksy/request/urls.dart';
import '../mixin/mixins.dart';
import '../model/interest.dart';
import '../model/response.dart';
import '../request/gets.dart';

class ILikeProvider with ChangeNotifier {
  List<Interest> list = [];
  late String errorMessage;
  bool loading = false;

  ILikeProvider init() {
    if( Mixin.user != null) {
      refresh('');
    }
    return this;
  }

  Future<bool> refresh(search) async {
    list.clear();
    setLoading(true);

    await XRequest().getData({
      'intFolId': Mixin.winkser?.usrId,
      'intUsrId': Mixin.user?.usrId
    }, IUrls.INTERESTS('')).then((data) {
      if (data.statusCode == 200) {
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(data.body));
          log('${jsonResponse.data}');
          var res = jsonResponse.data['result'];
          log('---${res}');

          var items = res.map<Interest>((json) {
            return  Interest.fromJson(json);
          }).toList();

          setHouses(items);
        } catch (e) {
          log(e.toString());
        }
      } else {
        setMessage(data.headers['message']);
      }
    });
    return isLoaded();
  }

  bool isLoading() {
    return loading;
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setHouses(value) {
    list.clear();
    list.addAll(value);
    setLoading(false);
  }

  List<Interest> getHouses() {
    return list;
  }

  List<Interest> getRecommended() {
    return list;
  }

  int getCount() {
    return list.length;
  }

  int getRecommendedCount() {
    return list.length;
  }

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool isLoaded() {
    return list.isNotEmpty;
  }
}
