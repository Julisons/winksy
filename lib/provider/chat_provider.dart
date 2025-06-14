import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../mixin/mixins.dart';
import '../model/chat.dart';
import '../model/invoice_dtl.dart';
import '../model/response.dart';
import '../request/gets.dart';
import '../request/urls.dart';


class IChatProvider with ChangeNotifier {
  List<Chat> list = [];
  late String errorMessage;
  bool loading = false;

  IChatProvider init() {
    if( Mixin.user == null) {
      refresh('');
    }else{
      refresh('');
    }
    return this;
  }

  Future<bool> refresh(search) async {
    list.clear();
    setLoading(true);
    await XRequest().getData({
      'usrId': Mixin.user?.usrId,
    }, IUrls.CHATS()).then((data) {
      if (data.statusCode == 200) {
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(data.body));
          log('${jsonResponse.data}');
          var res = jsonResponse.data['result'] ?? [];
          log('---${res}');

          var items = res.map<Chat>((json) {
            return  Chat.fromJson(json);
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

  Future<bool> reload(search) async {
    list.clear();
    //setLoading(true);
    await XRequest().getData({
      'usrId': Mixin.user?.usrId,
    }, IUrls.CHATS()).then((data) {
      if (data.statusCode == 200) {
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(data.body));
          log('${jsonResponse.data}');
          var res = jsonResponse.data['result'] ?? [];
          log('---${res}');

          var items = res.map<Chat>((json) {
            return  Chat.fromJson(json);
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

  List<Chat> getHouses() {
    return list;
  }

  int getCount() {
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
