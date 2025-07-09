import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:winksy/request/urls.dart';
import '../mixin/mixins.dart';
import '../model/friend.dart';
import '../model/response.dart';
import '../request/gets.dart';
import '../request/posts.dart';

class IFriendRequestProvider with ChangeNotifier {
  List<Friend> list = [];
  late String errorMessage;
  bool _loading = false;
  bool _loadingMore = false;
  int _start = 0;
  final int _limit = 20;

  IFriendRequestProvider init() {
    if(Mixin.user != null) {
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
      'usrId': Mixin.user?.usrId,
      'start': _start,
      'limit': _limit
    }, IUrls.FRIEND_REQUESTS()).then((data) {
      if (data.statusCode == 200) {
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(data.body));
          
          var res = jsonResponse.data?['result'] ?? [];

          var items = res.map<Friend>((json) {
            return Friend.fromJson(json);
          }).toList();

          setData(items);
        } catch (e) {
          log(e.toString());
        }
      } else {
        setMessage('Error getting data');
      }
    });
    return isLoaded();
  }

  Future<bool> loadMore(search) async {
    _start += _limit;
    setLoadingMore(true);

    await XRequest().getData({
      'usrId': Mixin.user?.usrId,
      'start': _start,
      'limit': _limit
    }, IUrls.FRIEND_REQUESTS()).then((data) {
      if (data.statusCode == 200) {
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(jsonDecode(data.body));
          
          var res = jsonResponse.data?['result'] ?? [];

          var items = res.map<Friend>((json) {
            return Friend.fromJson(json);
          }).toList();

          setDataMore(items);
        } catch (e) {
          log(e.toString());
        }
      } else {
        setMessage('');
      }
    });
    return isLoaded();
  }

  Future<bool> acceptRequest(String friendId) async {
    await XRequest().getData({
      'frndId': friendId,
      'frndStatus': 'accepted',
      'usrId': Mixin.user?.usrId,
    }, IUrls.ACCEPT_FRIEND_REQUEST()).then((data) {
      if (data.statusCode == 200) {
        // Remove from list after accepting
        list.removeWhere((friend) => friend.frndId == friendId);
        notifyListeners();
      } else {
        setMessage(data.headers['message']);
      }
    });
    return true;
  }

  Future<bool> rejectRequest(String friendId) async {
    await XRequest().getData({
      'frndId': friendId,
      'frndStatus': 'rejected',
      'usrId': Mixin.user?.usrId,
    }, IUrls.REJECT_FRIEND_REQUEST()).then((data) {
      if (data.statusCode == 200) {
        // Remove from list after rejecting
        list.removeWhere((friend) => friend.frndId == friendId);
        notifyListeners();
      } else {
        setMessage(data.headers['message']);
      }
    });
    return true;
  }

  bool isLoading() {
    return _loading;
  }

  bool isLoadingMore() {
    return _loadingMore;
  }

  void setLoading(bool value, bool loud) {
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

  int getCount() {
    return list.length;
  }

  void setMessage(value) {
    _loading = false;
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