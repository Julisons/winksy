import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../mixin/mixins.dart';
import '../model/notification.dart' as n;
import '../model/payment.dart';
import '../request/gets.dart';

class IPaymentProvider with ChangeNotifier {
  List<Payment> list = [];
  late String errorMessage;
  bool loading = false;

  IPaymentProvider init() {
    if( Mixin.user == null) {
      Mixin.getUser().then((value) => {
        Mixin.user = value,
        refresh()
      });
    }else{
      refresh();
    }
    return this;
  }

  Future<bool> refresh() async {
    setLoading(true);
    await PaymentRequest().fetchPayments('?transBillRefNumber=${Mixin.user?.usrMobileNumber}').then((data) {
      if (data.statusCode == 200) {
        try {
          var res = jsonDecode(data.body.toString());
          var items = res.map<Payment>((json) {
            return Payment.fromJson(json);
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
    notifyListeners();
  }

  List<Payment> getHouses() {
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
