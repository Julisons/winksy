import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:socket_io_client/socket_io_client.dart' as IO;
//https://www.youtube.com/watch?v=_nTGniudiNg&list=RDGMEMXgf4aZ1jiRpvQxoF1ssvBg&index=5
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:winksy/component/app_bar.dart';
import 'package:winksy/model/message.dart';
import '../../../../mixin/constants.dart';
import '../../../../mixin/mixins.dart';
import '../../../../theme/custom_colors.dart';
import '../../../component/empty_state_widget.dart';
import '../../../component/loader.dart';
import '../../../model/chat.dart';
import '../../../model/user.dart';
import '../../../provider/chat_provider.dart';
import '../../../request/urls.dart';
import '../../home/home.dart';
import 'chat_card.dart';

class IChat extends StatefulWidget {
  const IChat({super.key, required this.user});
  final User? user;

  @override
  State<IChat> createState() => _IChatState();
}

class _IChatState extends State<IChat> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
        backgroundColor: color.xPrimaryColor,
        appBar: IAppBar(leading: false,title: 'Messages',),
        body: VisibilityDetector(
          key: Key('my-widget-key'),
          onVisibilityChanged: (visibilityInfo) {
            var visiblePercentage = visibilityInfo.visibleFraction * 100;

            if(visiblePercentage > 90) {
              _initSocket();
              Provider.of<IChatProvider>(context, listen: false).reload('');
            }
          },
          child: Container(
            color: color.xPrimaryColor,
            padding: EdgeInsets.only(top: 10.h),
            child: Consumer<IChatProvider>(builder: (context, provider, child) {
              return (provider.loading)
                  ? Center(child: Loading(dotColor: color.xTrailing,size: LOADER))
                  : provider.list.isEmpty ?
                  EmptyStateWidget(
                    type: EmptyStateType.sms,
                    showCreate: true,
                    createButtonText: 'Message',
                    onCreate: (){
                      Mixin.navigate(context, IHome());
                    },
                    tagline: 'Tap on someone to start a conversation.',
                    description: 'Start a conversation to see your chats here.',
                    title: '🤫 It\'s Quiet in Here',
                    onReload: () async {
                      provider.refresh('');
                    },
                  ) :
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: RefreshIndicator(
                          color: color.xTrailing,
                          backgroundColor: color.xPrimaryColor,
                          onRefresh: () => provider.refresh(''),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 6, top: 6, right: 6, left: 6),
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            addAutomaticKeepAlives: false,
                            itemBuilder: (context, index) {
                              return IChatCard(
                                chat: provider.list[index],
                                text: 'View Details',
                                onClick: (){
                                  _socket?.emit(CHAT_CLICKED,jsonEncode(provider.list[index]));
                                },
                              );
                            },
                            itemCount: provider.list.length
                          )),
                    );
            }),
          ),
        ));
  }

  @override
  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _debounce?.cancel();
    super.dispose();
  }
  IO.Socket? _socket;

  Future<void> _initSocket() async {
    if (_socket != null) {
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
    }

    _socket = IO.io(IUrls.NODE_ONLINE(), <String, dynamic>{
      'timeout': 5000,
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'query': {
        'name': Mixin.user?.usrFullNames
      },
    });

    _socket?.connect();

    _socket?.on('connect_error', (c) {
      log(c.toString());
    });

    _socket?.onConnect((_) {
      _socket?.emit(USER_IS_ONLINE, {
        'name': Mixin.user?.usrFullNames,
        'usrId': Mixin.user?.usrId,
      });
    });

    _socket?.on(MESSAGE_TO_ALL, (data) {
        if(Message.fromJson(jsonDecode(data)).msgReceiverId == Mixin.user?.usrId) {
          Provider.of<IChatProvider>(context, listen: false).reload('');
        }
    });

    _socket?.on(CHAT_CLICKED, (data) {
      Chat chat = Chat.fromJson(jsonDecode(data));
        if(chat.chatReceiverId == Mixin.user?.usrId || chat.chatSenderId == Mixin.user?.usrId)
        {
          Future.delayed(Duration(seconds: 5), () {
            Provider.of<IChatProvider>(context, listen: false).reload('');});
        }
    });
  }
}
