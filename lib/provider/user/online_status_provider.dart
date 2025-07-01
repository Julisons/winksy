import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../mixin/mixins.dart';
import '../../model/user.dart';
import '../../model/user_status.dart';
import '../../request/urls.dart';

class OnlineStatusProvider with ChangeNotifier {
  IO.Socket? _socket;
  Map<String, UserStatus> _userStatuses = {};
  List<UserStatus> _onlineUsers = [];
  bool _isConnected = false;
  bool _isCurrentUserOnline = false;

  // Getters
  Map<String, UserStatus> get userStatuses => _userStatuses;
  List<UserStatus> get onlineUsers => _onlineUsers;
  bool get isConnected => _isConnected;
  bool get isCurrentUserOnline => _isCurrentUserOnline;
  
  UserStatus? getUserStatus(String? userId) {
    if (userId == null) return null;
    return _userStatuses[userId];
  }

  bool isUserOnline(String? userId) {
    if (userId == null) return false;
    final status = _userStatuses[userId];
    return status?.isOnline ?? false;
  }

  int get onlineUsersCount => _onlineUsers.length;

  void connect() {
    if (_socket?.connected == true) {
      log('OnlineStatusProvider: Already connected');
      return;
    }

    try {
      final socketUrl = IUrls.NODE_ONLINE();
      log('OnlineStatusProvider: Connecting to $socketUrl');
      
      _socket = IO.io(socketUrl, <String, dynamic>{
        'timeout': 5000,
        'transports': ['websocket'],
        'autoConnect': true,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 2000,
      });

      _setupEventListeners();
      _socket!.connect();
    } catch (e) {
      log('OnlineStatusProvider: Connection error: $e');
    }
  }

  void _setupEventListeners() {
    _socket!.onConnect((_) {
      log('OnlineStatusProvider: Connected to server');
      _isConnected = true;
      _setUserOnline();
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      log('OnlineStatusProvider: Disconnected from server');
      _isConnected = false;
      _isCurrentUserOnline = false;
      notifyListeners();
    });

    _socket!.onConnectError((error) {
      log('OnlineStatusProvider: Connection error: $error');
      _isConnected = false;
      notifyListeners();
    });

    _socket!.onReconnect((_) {
      log('OnlineStatusProvider: Reconnected to server');
      _setUserOnline();
    });

    // Listen for user status changes
    _socket!.on('userStatusChanged', (data) {
      try {
        final userStatus = UserStatus.fromJson(data);
        _userStatuses[userStatus.usrId!] = userStatus;
        _updateOnlineUsersList();
        notifyListeners();
        log('OnlineStatusProvider: User status changed: ${userStatus.usrId} - ${userStatus.status}');
      } catch (e) {
        log('OnlineStatusProvider: Error parsing userStatusChanged: $e');
      }
    });

    // Confirmation that current user is online
    _socket!.on('onlineStatusConfirmed', (data) {
      try {
        final userStatus = UserStatus.fromJson(data);
        _isCurrentUserOnline = true;
        _userStatuses[userStatus.usrId!] = userStatus;
        notifyListeners();
        log('OnlineStatusProvider: Online status confirmed for current user');
      } catch (e) {
        log('OnlineStatusProvider: Error parsing onlineStatusConfirmed: $e');
      }
    });

    // List of all online users
    _socket!.on('onlineUsersList', (data) {
      try {
        _onlineUsers.clear();
        if (data is List) {
          for (var userData in data) {
            final userStatus = UserStatus.fromJson(userData);
            _onlineUsers.add(userStatus);
            _userStatuses[userStatus.usrId!] = userStatus;
          }
        }
        notifyListeners();
        log('OnlineStatusProvider: Received online users list: ${_onlineUsers.length} users');
      } catch (e) {
        log('OnlineStatusProvider: Error parsing onlineUsersList: $e');
      }
    });

    // Response to specific user status query
    _socket!.on('userStatusResponse', (data) {
      try {
        final userStatus = UserStatus.fromJson(data);
        _userStatuses[userStatus.usrId!] = userStatus;
        notifyListeners();
        log('OnlineStatusProvider: User status response: ${userStatus.usrId} - ${userStatus.status}');
      } catch (e) {
        log('OnlineStatusProvider: Error parsing userStatusResponse: $e');
      }
    });
  }

  void _setUserOnline() {
    if (Mixin.user?.usrId == null || _socket?.connected != true) return;

    final user = User()
      ..usrId = Mixin.user!.usrId
      ..usrFullNames = Mixin.user!.usrFullNames;

    _socket!.emit('userOnline', user.toJson());
    log('OnlineStatusProvider: Set user online: ${user.usrId}');
  }

  void setUserOffline() {
    if (Mixin.user?.usrId == null || _socket?.connected != true) return;

    final user = User()
      ..usrId = Mixin.user!.usrId
      ..usrFullNames = Mixin.user!.usrFullNames;

    _socket!.emit('userOffline', user.toJson());
    _isCurrentUserOnline = false;
    notifyListeners();
    log('OnlineStatusProvider: Set user offline: ${user.usrId}');
  }

  void getOnlineUsers() {
    if (_socket?.connected != true) return;
    
    _socket!.emit('getOnlineUsers', '');
    log('OnlineStatusProvider: Requested online users list');
  }

  void requestUserStatus(String userId) {
    if (_socket?.connected != true) return;

    final user = User()..usrId = userId;
    _socket!.emit('getUserStatus', user.toJson());
    log('OnlineStatusProvider: Requested status for user: $userId');
  }

  void _updateOnlineUsersList() {
    _onlineUsers = _userStatuses.values
        .where((status) => status.isOnline)
        .toList();
  }

  void disconnect() {
    if (_socket?.connected == true) {
      setUserOffline();
      _socket!.disconnect();
    }
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    _isCurrentUserOnline = false;
    _userStatuses.clear();
    _onlineUsers.clear();
    notifyListeners();
    log('OnlineStatusProvider: Disconnected and cleaned up');
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  // Utility methods
  void refreshUserStatus(String userId) {
    requestUserStatus(userId);
  }

  void refreshOnlineUsers() {
    getOnlineUsers();
  }

  // For debugging
  void printStatus() {
    log('OnlineStatusProvider Status:');
    log('- Connected: $_isConnected');
    log('- Current user online: $_isCurrentUserOnline');
    log('- Tracked users: ${_userStatuses.length}');
    log('- Online users: ${_onlineUsers.length}');
  }
}