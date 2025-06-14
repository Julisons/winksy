import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:winksy/request/urls.dart';
import '../../mixin/mixins.dart';
import '../../model/pet.dart';
import '../../model/response.dart';
import '../../request/gets.dart';

class IPetProvider with ChangeNotifier {
  List<Pet> list = [];
  late Pet pet = Pet();
  late String errorMessage;
  bool _loading = false;
  bool _loadingMore = false;
  int _start = 0;
  final int _limit = 20;

  IPetProvider init() {
    if( Mixin.user == null) {
      Mixin.getUser().then((value) => {
        Mixin.user = value,
        refresh('', false)
      });
    }else{
      refresh('', false);
    }
    return this;
  }

  Future<bool> refresh(search, silently) async {
    _start = 0;
    list.clear();

    if(!silently) {
      setLoading(true);
    }

    await XRequest().getData({
      'petUsrId': Mixin.user?.usrId,
      'start':_start,
      'limit':_limit
    }, IUrls.PETS()).then((data) {
      if (data.statusCode == 200) {
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(data.body));
          log('${jsonResponse.data}');
          var res = jsonResponse.data['result'];
          pet = Pet.fromJson((jsonResponse.result));

          var items = res.map<Pet>((json) {
            return  Pet.fromJson(json);
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
      'petUsrId': Mixin.user?.usrId,
      'start':_start,
      'limit':_limit
    }, IUrls.PETS()).then((data) {
      if (data.statusCode == 200) {
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(data.body));
          log('${jsonResponse.data}');
          var res = jsonResponse.data['result'];
          log('---${res}');

          var items = res.map<Pet>((json) {
            return  Pet.fromJson(json);
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

  void setLoading(value) {
    _loading = value;
    notifyListeners();
  }

  void setLoadingMore(value) {
    _loadingMore = value;
    notifyListeners();
  }

  void setData(value) {
    list.clear();
    list.addAll(value);
    setLoading(false);
  }


  void setDataMore(value) {
    list.addAll(value);
    setLoadingMore(false);
  }

  List<Pet> getHouses() {
    return list;
  }

  List<Pet> getRecommended() {
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

  Pet getPet() {
    return pet;
  }
}
