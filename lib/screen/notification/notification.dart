import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../component/app_bar.dart';
import '../../component/empty_state_widget.dart';
import '../../component/loader.dart';
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
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          Provider.of<INotificationProvider>(context, listen: false).loadMore('');
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar:  IAppBar(title: 'Notifications', leading: true,),
      body:Consumer<INotificationProvider>(
          builder: (context, provider, child) {
            return provider.isLoading()
                ? Center(child:  Loading(dotColor: color.xTrailing,))
                : provider.list.isEmpty ?
            EmptyStateWidget(
              type: EmptyStateType.notification,
              showCreate: false,
              tagline: 'We\'ll notify you when there\'s something new.',
              description: 'Notifications will show up as they happen.',
              title: '🔔 No Notifications Yet',
              onReload: () async {
                provider.refresh('', true);
              },
            ) : Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: color.xTrailing,
                      backgroundColor: color.xPrimaryColor,
                      onRefresh: () => provider.refresh('', true),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(
                            bottom: 60,
                            top: 6,
                            right: 6,
                            left: 6),
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        addAutomaticKeepAlives: false,
                        itemBuilder: (context, index) {
                          return INotificationsCard(notification: provider.list[index]);
                        },
                        itemCount: provider.getCount(),
                      ),
                    ),
                  ),
                  if (provider.isLoadingMore())
                    Container(
                      padding: EdgeInsets.all(14),
                      child: Loading(dotColor: color.xTrailing),
                    ),
                ],
              );
          }),
    );
  }
}
