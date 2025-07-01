import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user/online_status_provider.dart';
import '../mixin/mixins.dart';

/// Service to manage online status lifecycle and app state changes
class OnlineStatusService with WidgetsBindingObserver {
  static OnlineStatusService? _instance;
  static OnlineStatusService get instance {
    _instance ??= OnlineStatusService._internal();
    return _instance!;
  }
  
  OnlineStatusService._internal();

  OnlineStatusProvider? _provider;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  bool _isInitialized = false;

  void initialize(BuildContext context) {
    if (_isInitialized) return;
    
    _provider = Provider.of<OnlineStatusProvider>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);
    _isInitialized = true;
    
    // Connect to online status
    connect();
    
    // Start heartbeat to maintain connection
    _startHeartbeat();
    
    log('OnlineStatusService: Initialized');
  }

  void connect() {
    if (Mixin.user?.usrId == null) {
      log('OnlineStatusService: Cannot connect - no user logged in');
      return;
    }
    
    _provider?.connect();
    _stopReconnectTimer();
  }

  void disconnect() {
    _provider?.disconnect();
    _stopHeartbeat();
    _stopReconnectTimer();
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    
    // Send heartbeat every 30 seconds to maintain connection
    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_provider?.isConnected == true) {
        log('OnlineStatusService: Heartbeat - connection healthy');
      } else {
        log('OnlineStatusService: Heartbeat - connection lost, attempting reconnect');
        _attemptReconnect();
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _attemptReconnect() {
    if (_reconnectTimer?.isActive == true) return;
    
    _reconnectTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_provider?.isConnected == true) {
        timer.cancel();
        log('OnlineStatusService: Reconnected successfully');
      } else {
        log('OnlineStatusService: Reconnection attempt...');
        connect();
      }
    });
  }

  void _stopReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('OnlineStatusService: App lifecycle changed to ${state.name}');
    
    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground
        if (Mixin.user?.usrId != null) {
          connect();
          _startHeartbeat();
        }
        break;
        
      case AppLifecycleState.paused:
        // App went to background
        _provider?.setUserOffline();
        _stopHeartbeat();
        break;
        
      case AppLifecycleState.detached:
        // App is being terminated
        disconnect();
        break;
        
      case AppLifecycleState.inactive:
        // App is inactive (e.g., during phone call)
        break;
        
      case AppLifecycleState.hidden:
        // App is hidden
        break;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
    _isInitialized = false;
    log('OnlineStatusService: Disposed');
  }

  // Utility methods
  bool get isConnected => _provider?.isConnected ?? false;
  bool get isCurrentUserOnline => _provider?.isCurrentUserOnline ?? false;
  
  void refreshOnlineUsers() {
    _provider?.refreshOnlineUsers();
  }
  
  void getUserStatus(String userId) {
    _provider?.getUserStatus(userId);
  }
  
  bool isUserOnline(String? userId) {
    return _provider?.isUserOnline(userId) ?? false;
  }
}