import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../component/empty_state_widget.dart';
import '../../../component/loader.dart';
import '../../../provider/friend_request_provider.dart';
import '../../../theme/custom_colors.dart';
import 'friend_request_card.dart';

class IFriendRequests extends StatefulWidget {
  const IFriendRequests({super.key});

  @override
  State<IFriendRequests> createState() => _IFriendRequestsState();
}

class _IFriendRequestsState extends State<IFriendRequests> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          Provider.of<IFriendRequestProvider>(context, listen: false).loadMore('');
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
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.h),
      child: Consumer<IFriendRequestProvider>(
        builder: (context, provider, child) {
          return provider.isLoading()
              ? Center(
                  child: Loading(
                    dotColor: color.xTrailing,
                  ),
                )
              : provider.list.isEmpty
                  ? EmptyStateWidget(
                      type: EmptyStateType.users,
                      showCreate: false,
                      description: 'No friend requests at the moment. When someone sends you a friend request, it will appear here.',
                      title: '👋 No Friend Requests',
                      onReload: () async {
                        provider.refresh('', true);
                      },
                    )
                  : Column(
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
                                left: 6,
                              ),
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return IFriendRequestCard(
                                  friendRequest: provider.list[index],
                                  onRefresh: () {
                                    setState(() {});
                                  },
                                );
                              },
                              itemCount: provider.getCount(),
                            ),
                          ),
                        ),
                        if (provider.isLoadingMore())
                          Container(
                            padding: EdgeInsets.all(14.h),
                            child: Loading(dotColor: color.xTrailing),
                          )
                      ],
                    );
        },
      ),
    );
  }
}