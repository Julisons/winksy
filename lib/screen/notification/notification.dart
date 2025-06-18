import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../component/app_bar.dart';
import '../../component/loading.dart';
import '../../component/no_result.dart';
import '../../component/popup.dart';
import '../../mixin/constants.dart';
import 'package:provider/provider.dart';

import '../../provider/notification_provider.dart';
import '../../theme/custom_colors.dart';
import 'notifications_card.dart';

class INotifications extends StatefulWidget {
  const INotifications({Key? key}) : super(key: key);

  @override
  State<INotifications> createState() => _INotificationsState();
}

class _INotificationsState extends State<INotifications> {
  @override
  Widget build(context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar:  IAppBar(title: 'Notifications', leading: true,),
      body:Consumer<INotificationProvider>(
          builder: (context, provider, child) {
            return provider.isLoading()
                ? const ILoading()
                : provider.getCount() > 0
                ? RefreshIndicator(
              color: color.xTrailing,
                onRefresh: () => provider.refresh('', true),
                child:  ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: 6,
                      top: 6,
                      right: 6,
                      left: 6),
                  scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  itemBuilder: (context, index) {
                    return INotificationsCard(notification: provider.list[index]);
                  },
                  itemCount: provider.getCount(),
                )) :
            IZeroResult(
              onRefresh: () {
                provider.refresh('', true);
              },
              message: EMPTY,
            );
          }),
    );
  }
}
