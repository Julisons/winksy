import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:winksy/request/urls.dart';
import '../../mixin/mixins.dart';
import '../../model/gift.dart';
import '../../model/pet.dart';
import '../../model/response.dart';
import '../../model/spinner.dart';
import '../../request/gets.dart';

class ISpinnerProvider with ChangeNotifier {
  List<Spinner> list = [];
  late String errorMessage;
  bool _loading = false;
  bool _loadingMore = false;
  int _start = 0;
  final int _limit = 200;

  ISpinnerProvider init() {
    if( Mixin.user != null) {
      refresh('', true);
    }
    return this;
  }

  Future<bool> refresh(String search, bool loud) async {
    _start = 0;
    if(loud) {
      list.clear();
    }
    setLoading(true, loud);

    await XRequest().getData({
      'start':_start,
      'limit':_limit
    }, IUrls.SPINNERS()).then((data) {
      if (data.statusCode == 200) {
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(data.body));
          
          var res = jsonResponse.data?['result'] ?? [];

          var items = res.map<Spinner>((json) {
            return  Spinner.fromJson(json);
          }).toList();

          setData(items);
        } catch (e) {
          log(e.toString());
        }
      } else {
        setMessage(data.headers['message']);
      }
    });
    return isLoaded();
  }

  Future<bool> loadMore(search) async {
    _start += _limit;
    setLoadingMore(true);

    await XRequest().getData({
      'start':_start,
      'limit':_limit
    }, IUrls.SPINNERS()).then((data) {
      if (data.statusCode == 200) {
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(data.body));
          
          var res = jsonResponse.data?['result'] ?? [];
          log('---${res}');

          var items = res.map<Spinner>((json) {
            return  Spinner.fromJson(json);
          }).toList();

          setDataMore(items);
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
    return _loading;
  }

  bool isLoadingMore() {
    return _loadingMore;
  }

  void setLoading(bool value,bool loud) {
    if(loud) {
      _loading = value;
    }
    notifyListeners();
  }

  void setLoadingMore(value) {
    _loadingMore = value;
    notifyListeners();
  }

  void setData(value) {
    list.clear();
    list.addAll(value);
    setLoading(false, true);
  }


  void setDataMore(value) {
    list.addAll(value);
    setLoadingMore(false);
  }

  List<Spinner> getHouses() {
    return list;
  }

  List<Spinner> getRecommended() {
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
