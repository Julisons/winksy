import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../mixin/mixins.dart';
import '../model/notification.dart' as n;
import '../request/gets.dart';

class INotificationsProvider with ChangeNotifier {
  List<n.Notification> list = [];
  late String errorMessage;
  bool loading = false;

  INotificationsProvider init() {

    return this;
  }

  Future<bool> refresh() async {
    setLoading(true);
    await NotificationsRequest().fetchNotifications(Mixin.user?.usrId).then((data) {
      setLoading(false);
      if (data.statusCode == 200) {
        try {
          var res = jsonDecode(data.body.toString());
          var items = res.map<n.Notification>((json) {
            return n.Notification.fromJson(json);
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
    notifyListeners();
  }

  List<n.Notification> getHouses() {
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
