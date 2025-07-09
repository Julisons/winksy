import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
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
    if( Mixin.user != null) {
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
          var res = jsonResponse.data?['result'] ?? [];

          var items = res.map<Chat>((json) {
            return  Chat.fromJson(json);
          }).toList();

          setHouses(items);
        } catch (e) {
          log(e.toString());
          setLoading(false);
        }
      } else {
        setMessage(data.headers['message']);
        setLoading(false);
      }
    });
    return isLoaded();
  }

  Future<bool> reload(search) async {
    // DON'T clear the list here - do it atomically in setHouses
    // list.clear(); // REMOVE THIS LINE

    await XRequest().getData({
      'usrId': Mixin.user?.usrId,
    }, IUrls.CHATS()).then((data) {
      if (data.statusCode == 200) {
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(data.body));
          var res = jsonResponse.data?['result'] ?? [];
          var items = res.map<Chat>((json) {
            return  Chat.fromJson(json);
          }).toList();

          setHouses(items);
        } catch (e) {
          log(e.toString());
          setLoading(false);
        }
      } else {
        setMessage(data.headers['message']);
        setLoading(false);
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
    // Atomic operation - clear and add in one go to prevent race conditions
    list.clear();
    list.addAll(value);
    setLoading(false);
    // Only notify listeners after the list is fully updated
    notifyListeners();
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