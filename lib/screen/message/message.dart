// Copyright 2017, 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/mixin/extentions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:visibility_detector/visibility_detector.dart';
import 'package:winksy/screen/account/winkser.dart';
import '../../../component/debouncer.dart';
import '../../../component/popup.dart';
import '../../../mixin/mixins.dart';
import '../../../model/message.dart';
import '../../../model/user.dart';
import '../../../request/posts.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import '../../mixin/constants.dart' as color;
import '../../model/chat.dart';
import '../../model/response.dart';
import 'message_card.dart';
import 'package:http/http.dart' as http;

class IMessage extends StatefulWidget {
  const IMessage({Key? key, required this.chat, required this.showTitle})
    : super(key: key);
  final Chat chat;
  final bool showTitle;

  @override
  _IMessageState createState() => _IMessageState();
}

class _IMessageState extends State<IMessage> with TickerProviderStateMixin {
  final List<IMessageCard> _messages = [];
  final List<Message> _sms = [];
  final _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;
  bool _isTyping = false;
  bool _init = true;

  final _debouncer = Debouncer(milliseconds: 500);
  late Icon icon = Icon(
    Icons.search,
    color: Theme.of(context).extension<CustomColors>()!.xTextColor,
  );

  final _searchController = TextEditingController();
  late Widget search = Row(
    children: [
      ?widget.showTitle
          ? InkWell(
              onTap: () {
                Mixin.navigate(context, IWinkser());
              },
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: '${Mixin.winkser?.usrImage}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: xShimmerBase,
                    highlightColor: xShimmerHighlight,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      //  height: MediaQuery.of(context).size.width/2,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: color.xSecondaryColor,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: color.xPrimaryColor,
                    ),
                  ),
                ),
              ),
            )
          : null,
      SizedBox(width: 10),
      ?widget.showTitle
          ? Text(
              '${widget.chat.usrReceiver ?? Mixin.winkser?.usrFullNames}',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).extension<CustomColors>()!.xTextColor,
                fontSize: FONT_TITLE,
              ),
            )
          : null,
    ],
  );

  IO.Socket? _socket;
  String query = "";
  String? _room = '';
  String? senderId = '';
  String? receiverId = '';
  Message message = Message();
  String chatId = "3fa85f64-5717-4562-b3fc-2c963f66afa6";
  bool isDoc = false;

  @override
  void initState() {
    super.initState();
    _initSms();
  }

  Future _prepMessages() async {
    if (_sms.isNotEmpty) {
      return;
    }

    if (mounted) {
      final token = await Mixin.getPrefString(key: TOKEN);
      Uri url = IUrls.MESSAGES();
      log(url.path);

      log(jsonEncode({'msgChatId': widget.chat.chatId ?? chatId}));
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'msgChatId': widget.chat.chatId ?? chatId}),
      );

      if (response.statusCode == 200) {
        _messages.clear();
        _sms.clear();
        try {
          JsonResponse jsonResponse = JsonResponse.fromJson(
            jsonDecode(response.body),
          );
          log('${jsonResponse.data}');
          var res = jsonResponse.data['result'] ?? [];

          var items = res.map<Message>((json) {
            return Message.fromJson(json);
          }).toList();
          _sms.addAll(items);
        } catch (e) {
          log(e.toString());
        }

        if (mounted) {
          setState(() {
            if (_sms.isNotEmpty) {
              for (int i = 0; i < _sms.length; i++) {
                var message = IMessageCard(
                  animationController: AnimationController(
                    duration: const Duration(milliseconds: 700),
                    vsync: this,
                  ),
                  message: _sms[i],
                  isSender: _sms[i].msgSenderId == Mixin.user?.usrId,
                );
                _messages.add(message);
                message.animationController.forward();

                if (_init) {
                  _init = false;
                  senderId = Mixin.user?.usrId.toString();
                  receiverId = Mixin.winkser?.usrId.toString();
                }
              }
            } else {
              /**
                 * First time chat
                 */
              // _initSms();
            }
          });
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load sms');
      }
    }
  }

  void _initSms() {
    Chat chat = Chat.fromJson(widget.chat.toJson());
    IPost.postData(chat, (state, res, value) {
      setState(() {
        chat = Chat.fromJson(value);
        chatId = chat.chatId;
        _prepMessages();
        senderId = Mixin.user?.usrId.toString();
        receiverId = Mixin.winkser?.usrId.toString();
        _room = chatId.toString();
        _initSocket();
      });
    }, IUrls.CHAT());
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: widget.showTitle,
        backgroundColor: color.xPrimaryColor,
        surfaceTintColor: color.xPrimaryColor,
        title: search,
        elevation: 4.0,
        actions: <Widget>[
          IconButton(
            icon: icon,
            tooltip: 'Search',
            onPressed: () {
              setState(() {
                if (icon.icon == Icons.search) {
                  icon = const Icon(Icons.clear);
                  search = Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        fillColor: color.xSecondaryColor,
                        filled: true,
                        hintStyle: TextStyle(
                          color: color.xTextColor,
                          fontSize: FONT_13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: color.xSecondaryColor,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: color.xSecondaryColor,
                            width: .0,
                            strokeAlign: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: color.xSecondaryColor,
                            width: .0,
                            strokeAlign: 0,
                          ),
                        ),
                      ),
                      style: TextStyle(color: color.xTextColor),
                      onChanged: (value) {
                        setState(() {
                          log(value);
                        });
                      },
                    ),
                  );
                } else {
                  icon = Icon(Icons.search, color: color.xTextColor);
                  search = Row(
                    children: [
                      ?widget.showTitle
                          ? InkWell(
                              onTap: () {
                                Mixin.navigate(context, IWinkser());
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: '${Mixin.winkser?.usrImage}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fitHeight,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: xShimmerBase,
                                    highlightColor: xShimmerHighlight,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      //  height: MediaQuery.of(context).size.width/2,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                        backgroundColor: color.xSecondaryColor,
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                          color: color.xPrimaryColor,
                                        ),
                                      ),
                                ),
                              ),
                            )
                          : null,
                      SizedBox(width: 10),
                      ?widget.showTitle
                          ? Text(
                              '${widget.chat.usrReceiver ?? Mixin.winkser?.usrFullNames}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).extension<CustomColors>()!.xTextColor,
                                fontSize: FONT_TITLE,
                              ),
                            )
                          : null,
                    ],
                  );
                }
              });
            },
          ),
        ],
      ),
      body: VisibilityDetector(
        key: const Key('my-widget-key'),
        onVisibilityChanged: (visibilityInfo) {
          _prepMessages();

          log('Widget is ${visibilityInfo.visibleFraction * 100}% visible');
        },
        child: Container(
          decoration:
              Theme.of(context).platform ==
                  TargetPlatform
                      .iOS //new
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200]!)),
                )
              : null,
          child: Column(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _messages.isNotEmpty
                        ? Flexible(
                            child: RefreshIndicator(
                              color: xGreenPrimary,
                              backgroundColor: color.xPrimaryColor,
                              onRefresh: () => _prepMessages(),
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics(),
                                ),
                                reverse: true,
                                itemBuilder: (_, index) => _messages[index],
                                itemCount: _messages.length,
                              ),
                            ),
                          )
                        : _hello(),
                  ],
                ),
              ),
              _isTyping
                  ? const SizedBox(
                      height: 25,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'typing...',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(height: 25),

              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    final color = Theme.of(context).extension<CustomColors>()!;

    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: TextField(
                controller: _messageController,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                    _socket?.emit('typing', Mixin.user?.usrId);
                    log('typing...${_messageController.text}');
                  });
                  _debouncer.run(() => _socket?.emit('finish typing'));
                },
                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration: InputDecoration(
                  labelText: 'Send a message',
                  hintText: 'Send a message',
                  helperText: 'Messaging ${Mixin.winkser?.usrFullNames ?? widget.chat.usrReceiver} ',
                  fillColor: color.xSecondaryColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: color.xSecondaryColor,
                      width: .0,
                      strokeAlign: 0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: color.xSecondaryColor,
                      width: .0,
                      strokeAlign: 0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: color.xSecondaryColor,
                      width: .0,
                      strokeAlign: 0,
                    ),
                  ),
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20, left: 10),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_messageController.text)
                          : null,
                      child: const Text('Send'),
                    )
                  : CircleAvatar(
                      backgroundColor: color.xTrailing,
                      radius: 24,
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          size: 24,
                          color: Colors.white,
                        ),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_messageController.text)
                            : null,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    Message message = Message();
    message.msgText = text;
    message.msgSenderId = Mixin.user?.usrId;
    message.msgReceiverId =
        Mixin.winkser?.usrId ??
        (widget.chat.chatSenderId == Mixin.user?.usrId
            ? widget.chat.chatReceiverId
            : widget.chat.chatSenderId);
    message.msgChatId = widget.chat.chatId ?? chatId;

    _messageController.clear();
    setState(() {
      _isComposing = false;
    });
    var messageCard = IMessageCard(
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
      message: message,
      isSender: true,
    );
    setState(() {
      _messages.insert(0, messageCard);
    });
    _focusNode.requestFocus();
    messageCard.animationController.forward();
    _sendMessage(message);
  }

  void _sendMessage(Message message) {
    // socket?.emit('add user', '$room#$senderId#$receiverId');
    _socket?.emit('chat message', jsonEncode(message.toJson()));

   /* IPost.postData(message, (state, res, value) {
      setState(() {
        if (state) {
        } else {
          Mixin.errorDialog(context, 'ERROR', res);
        }
      });
    }, IUrls.SAVE_MESSAGE());*/
  }

  @override
  void dispose() {
    _socket?.emit('leave', {'room': _room});
    _debouncer.dispose();
    _messageController.dispose();

    _socket?.disconnect();
    _socket?.dispose();
    _socket =
        null; // ✅ Reset the socket so a new one is created in _initSocket()

    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  Future<void> _initSocket() async {
    if (_socket != null) {
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
    }

    log('..room....$_room');
    _socket = IO.io(IUrls.NODE(), <String, dynamic>{
      'timeout': 5000,
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'query': {
        'name': Mixin.user?.usrFullNames ?? 'Guest',
        // You can include other query params if needed, but 'room' is no longer needed here
        'senderId': senderId,
        'receiverId': receiverId,
      },
    });

    _socket?.on('connect_error', (c) {
      log(c.toString());
    });

    _socket?.connect();

    _socket?.onConnect((_) {
      log('connected to server');
      // Send both name and room when joining
      _socket?.emit('join', {
        'name': Mixin.user?.usrFullNames ?? 'Guest',
        'room': _room,
      });
    });

    _socket?.on('chat message', (message) {
      log(message.toString());
      var res = jsonDecode(message.toString());

      if( res['msgSenderId'] == Mixin.user?.usrId.toString()) {
        return; // Ignore messages sent by the current user
      }
      _receiveSubmitted(Message.fromJson(res));
    });

    _socket?.on('typing', (data) {
      if (Mixin.user?.usrId.toString() != data.toString()) {
        if (mounted) {
          setState(() {
            _isTyping = true;
          });
        }
      }
    });

    _socket?.on('finish typing', (_) {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
      }
    });
  }

  void _receiveSubmitted(sms) {
    _messageController.clear();
    var message = IMessageCard(
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
      message: sms,
      isSender: false,
    );

    if (mounted) {
      setState(() {
        _messages.insert(0, message);
        _focusNode.requestFocus();
        message.animationController.forward();
      });
    }
  }

  Widget _hello() {
    return Center(
      child: Column(
        children: [
          ?widget.showTitle
              ? InkWell(
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: '${Mixin.winkser?.usrImage}',
                      width: 90,
                      height: 90,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: xShimmerBase,
                        highlightColor: xShimmerHighlight,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          //  height: MediaQuery.of(context).size.width/2,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: color.xSecondaryColor,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: color.xPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Mixin.navigate(context, IWinkser());
                  },
                )
              : null,
          SizedBox(height: 10),
          Text(
            'Say Hello',
            style: TextStyle(
              fontSize: FONT_APP_BAR,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).extension<CustomColors>()!.xTextColor,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: 'Make the first move with ',
              style: TextStyle(
                fontSize: FONT_TITLE,
                color: Theme.of(context).extension<CustomColors>()!.xTextColor,
              ),
              children: [
                TextSpan(
                  text:
                      '${Mixin.winkser?.usrFullNames ?? widget.chat.usrReceiver}',
                  style: TextStyle(
                    fontSize: FONT_TITLE,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(
                      context,
                    ).extension<CustomColors>()!.xTrailing,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
