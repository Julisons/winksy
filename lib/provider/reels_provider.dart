import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../model/Link.dart';
import '../request/gets.dart';
import '../mixin/constants.dart';
import '../mixin/mixins.dart';

class IReelsProvider with ChangeNotifier {
  final Map<String, List<Link>> _tabData = {}; // Stores data for each tab
  final Map<String, bool> _loadingStatus = {}; // Loading status for each tab
  final Map<String, bool> _loadingStatusMore = {}; // Loading status for each tab
  final Map<String, String> _errorMessages = {}; // Error messages for each tab
  int _start = 0;
  final int _limit = 20;

  // Initialize provider for a specific tab
  void initTab(String tab) {
    if (!_tabData.containsKey(tab)) {
      _tabData[tab] = [];
      _loadingStatus[tab] = false;
      _errorMessages[tab] = '';
      refresh(tab, '');
    }
  }

   refresh(String tab, String search) async {
    _start = 0;

    _tabData[tab]?.clear();
    _setLoading(tab, true);
    try {
      final response = await LinkMainRequest().fetchMainLinks(
          '?search=$search&lnkCatTitle=$tab&lnkUsrId=${Mixin.user?.usrId ?? ''}&start=$_start&limit=$_limit');
          //'?search=$search&lnkCatTitle=$tab&lnkUsrId=');
      if (response.statusCode == 200) {
        final res = jsonDecode(response.body.toString());
        final items = res.map<Link>((json) => Link.fromJson(json)).toList();
        _setTabData(tab, items);
      } else {
        _setErrorMessage(tab, response.headers['message'] ?? 'Error occurred');
      }
    } catch (e) {
      log('Error refreshing data for tab "$tab": $e');
      _setErrorMessage(tab, 'Failed to fetch data');
    } finally {
      _setLoading(tab, false);
    }
  }

  void loadMore(String tab, String search)async {
    _start += _limit;
    _setLoadingMore(tab, true);
    try {
      final response = await LinkMainRequest().fetchMainLinks(
          '?search=$search&lnkCatTitle=$tab&lnkUsrId=${Mixin.user?.usrId ?? ''}&start=$_start&limit=$_limit');
      if (response.statusCode == 200) {
        final res = jsonDecode(response.body.toString());
        final items = res.map<Link>((json) => Link.fromJson(json)).toList();
        _setTabDataMore(tab, items);
      } else {
        _setErrorMessage(tab, response.headers['message'] ?? 'Error occurred');
      }
    } catch (e) {
      log('Error refreshing data for tab "$tab": $e');
      _setErrorMessage(tab, 'Failed to fetch data');
    } finally {
      _setLoadingMore(tab, false);
    }
  }

  void _setTabData(String tab, List<Link> data) {
    List<Link> list = [];

    for (int i = 0; i < data.length; i++) {
      Link link = data[i];
      if(link.lnkId >= 0) {
        try {

        link.lnkCode = '${Mixin.convertUrlToId(link.lnkUrl)}';
        link.htmlWidget = '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                overflow: hidden;
                position: fixed;
                height: 100%;
                width: 100%;
            }
        </style>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
    </head>
    <body>
    
        <div id="player"></div>
        <script>
            var tag = document.createElement('script');
            tag.src = "https://www.youtube.com/iframe_api";
            var firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
            var player;
            var timerId;
            function onYouTubeIframeAPIReady() {
                player = new YT.Player('player', {
                    height: '100%',
                    width: '100%',
                    videoId: '${link.lnkCode}',
                    playerVars: {
                        'controls': 1,
                        'playsinline': 1,
                        'enablejsapi': 1,
                        'fs': 0,
                        'rel': 1,
                        'showinfo': 1,
                        'iv_load_policy': 3,
                        'modestbranding': 1,                
                        'autoplay': 1,
                        'start': 0,
                        'vq': 'small'
                    },
                      events: {
                        onAutoplayBlocked: function (event) { sendMessageToDart(event.data); },
                        onReady: function (event) { 
                              event.target.setPlaybackQuality('small');
                              sendMessageToDart('Ready');
                              play();
                             },
                        onStateChange: function (event) { 
                            event.target.setPlaybackQuality('small');
                            sendPlayerStateChange(event.data);
                         },
                        onPlaybackQualityChange: function (event) { sendMessageToDart('PlaybackQualityChange', { 'playbackQuality': event.data }); },
                        onPlaybackRateChange: function (event) { sendMessageToDart('PlaybackRateChange', { 'playbackRate': event.data }); },
                        onError: function (error) { sendMessageToDart('Errors', { 'errorCode': error.data }); }
                    },
                });
            }
          function sendMessageToDart(methodName, argsObject = {}) {
            var message = {
                'method': methodName,
                'args': argsObject
            };
            Webviewtube.postMessage(JSON.stringify(message));
        }

        function sendPlayerStateChange(playerState) {
            clearTimeout(timerId);
            sendMessageToDart('StateChange', { 'state': playerState });
            if (playerState == 1) {
                startSendCurrentTimeInterval();
                sendVideoData(player);
            }
        }

        function sendVideoData(player) {
            var videoData = {
                'duration': player.getDuration(),
                'title': player.getVideoData().title,
                'author': player.getVideoData().author,
                'videoId': player.getVideoData().video_id
            };
            sendMessageToDart('VideoData', videoData);
        }

        function startSendCurrentTimeInterval() {
            timerId = setInterval(function () {
                sendMessageToDart('CurrentTime',
                    {
                        'position': player.getCurrentTime(),
                        'buffered': player.getVideoLoadedFraction()
                    });
            }, 0);
        }


        function play() {
            player.setPlaybackQuality('small');
            player.playVideo();
            player.setPlaybackQuality('small');
        }

        function pause() {
            player.pauseVideo();
        }

        function loadById(loadSettings) {
            player.loadVideoById(loadSettings);
        }

        function cueById(cueSettings) {
            player.cueVideoById(cueSettings);
        }

        function loadPlaylist(playlist, index, startAt) {
            player.loadPlaylist(playlist, index, startAt);
        }

        function cuePlaylist(playlist, index, startAt) {
            player.cuePlaylist(playlist, index, startAt);
        }

        function nextVideo() {
          player.nextVideo();
        }

        function previousVideo() {
          player.previousVideo();
        }

        function playVideoAt(index) {
          player.playVideoAt(index);
        }

        function mute() {
            player.mute();
        }

        function unMute() {
            player.unMute();
        }

        function seekTo(seconds, allowSeekAhead) {
            player.seekTo(seconds, allowSeekAhead);
        }

        function setSize(width, height) {
            player.setSize(width, height);
        }

        function setPlaybackRate(rate) {
            player.setPlaybackRate(rate);
        }
        </script>
    </body>
    </html>
  ''';
      } on Exception catch (e) {
        log(e.toString());
      }
      }

        if (link.lnkId >= 0) {
          list.add(link);
        }
    }

    _tabData[tab] = list;
    notifyListeners();
  }

  void _setTabDataMore(String tab, List<Link> data) {
    List<Link> list = [];
    list.addAll(_tabData[tab]!);

    for (int i = 0; i < data.length; i++) {
      Link link = data[i];
      if(link.lnkId >= 0) {
      try {
        link.lnkCode = '${Mixin.convertUrlToId(link.lnkUrl)}';
        link.htmlWidget = '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                overflow: hidden;
                position: fixed;
                height: 100%;
                width: 100%;
            }
        </style>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
    </head>
    <body>
    
        <div id="player"></div>
        <script>
            var tag = document.createElement('script');
            tag.src = "https://www.youtube.com/iframe_api";
            var firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
            var player;
            var timerId;
            function onYouTubeIframeAPIReady() {
                player = new YT.Player('player', {
                    height: '100%',
                    width: '100%',
                    videoId: '${link.lnkCode}',
                    playerVars: {
                        'controls': 1,
                        'playsinline': 1,
                        'enablejsapi': 1,
                        'fs': 0,
                        'rel': 1,
                        'showinfo': 1,
                        'iv_load_policy': 3,
                        'modestbranding': 1,                
                        'autoplay': 0,
                        'start': 0,
                        'vq': 'small'
                    },
                      events: {
                        onAutoplayBlocked: function (event) { sendMessageToDart(event.data); },
                        onReady: function (event) { event.target.setPlaybackQuality('small');   player.playVideo();   sendMessageToDart('Ready'); },
                        onStateChange: function (event) { sendPlayerStateChange(event.data);
                            if (event.data == YT.PlayerState.BUFFERING) {
                                 event.target.setPlaybackQuality('small');
                             }
                         },
                        onPlaybackQualityChange: function (event) { sendMessageToDart('PlaybackQualityChange', { 'playbackQuality': event.data }); },
                        onPlaybackRateChange: function (event) { sendMessageToDart('PlaybackRateChange', { 'playbackRate': event.data }); },
                        onError: function (error) { sendMessageToDart('Errors', { 'errorCode': error.data }); }
                    },
                });
            }
          function sendMessageToDart(methodName, argsObject = {}) {
            var message = {
                'method': methodName,
                'args': argsObject
            };
            Webviewtube.postMessage(JSON.stringify(message));
        }

        function sendPlayerStateChange(playerState) {
            clearTimeout(timerId);
            sendMessageToDart('StateChange', { 'state': playerState });
            if (playerState == 1) {
                startSendCurrentTimeInterval();
                sendVideoData(player);
            }
        }

        function sendVideoData(player) {
            var videoData = {
                'duration': player.getDuration(),
                'title': player.getVideoData().title,
                'author': player.getVideoData().author,
                'videoId': player.getVideoData().video_id
            };
            sendMessageToDart('VideoData', videoData);
        }

        function startSendCurrentTimeInterval() {
            timerId = setInterval(function () {
                sendMessageToDart('CurrentTime',
                    {
                        'position': player.getCurrentTime(),
                        'buffered': player.getVideoLoadedFraction()
                    });
            }, 0);
        }


        function play() {
            player.playVideo();
        }

        function pause() {
            player.pauseVideo();
        }

        function loadById(loadSettings) {
            player.loadVideoById(loadSettings);
        }

        function cueById(cueSettings) {
            player.cueVideoById(cueSettings);
        }

        function loadPlaylist(playlist, index, startAt) {
            player.loadPlaylist(playlist, index, startAt);
        }

        function cuePlaylist(playlist, index, startAt) {
            player.cuePlaylist(playlist, index, startAt);
        }

        function nextVideo() {
          player.nextVideo();
        }

        function previousVideo() {
          player.previousVideo();
        }

        function playVideoAt(index) {
          player.playVideoAt(index);
        }

        function mute() {
            player.mute();
        }

        function unMute() {
            player.unMute();
        }

        function seekTo(seconds, allowSeekAhead) {
            player.seekTo(seconds, allowSeekAhead);
        }

        function setSize(width, height) {
            player.setSize(width, height);
        }

        function setPlaybackRate(rate) {
            player.setPlaybackRate(rate);
        }
        </script>
    </body>
    </html>
  ''';
      } on Exception catch (e) {
        log(e.toString());
      }}

        if (link.lnkId >= 0) {
          list.add(link);
        }
    }

    _tabData[tab] = list;
    notifyListeners();
  }

  void _setLoading(String tab, bool value) {
    _loadingStatus[tab] = value;
    notifyListeners();
  }

  void _setLoadingMore(String tab, bool value) {
   _loadingStatusMore[tab] = value;
    notifyListeners();
  }

  void _setErrorMessage(String tab, String message) {
    _errorMessages[tab] = message;
    notifyListeners();
  }

  // Public getters
  List<Link> getLinks(String tab) => _tabData[tab] ?? [];
  bool isLoading(String tab) => _loadingStatus[tab] ?? false;
  bool isLoadingMore(String tab) => _loadingStatusMore[tab] ?? false;
  String getErrorMessage(String tab) => _errorMessages[tab] ?? '';

  // Utility methods
  int getCount(String tab) => getLinks(tab).length;
  bool isLoaded(String tab) => getLinks(tab).isNotEmpty;
  String boolean({required bool value}) => value == true ? "'1'" : "'0'";

}