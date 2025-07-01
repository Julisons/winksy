import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../mixin/constants.dart';
import '../../../provider/friend_request_provider.dart';
import '../../../provider/friends_provider.dart';
import '../../../theme/custom_colors.dart';
import 'friend_requests.dart';
import 'my_friend.dart';

class IFriendsWithRequests extends StatefulWidget {
  const IFriendsWithRequests({super.key});

  @override
  State<IFriendsWithRequests> createState() => _IFriendsWithRequestsState();
}

class _IFriendsWithRequestsState extends State<IFriendsWithRequests> 
    with SingleTickerProviderStateMixin {
  late TabController _friendsTabController;

  @override
  void initState() {
    super.initState();
    _friendsTabController = TabController(length: 2, vsync: this);
    
    _friendsTabController.addListener(() {
      switch(_friendsTabController.index) {
        case 0:
          Provider.of<IFriendsProvider>(context, listen: false).refresh('', false);
          break;
        case 1:
          Provider.of<IFriendRequestProvider>(context, listen: false).refresh('', false);
          break;
      }
    });
  }

  @override
  void dispose() {
    _friendsTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Column(
      children: [
        // Sub-tab bar for Friends
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: color.xPrimaryColor,
            borderRadius: BorderRadius.circular(CORNER),
          ),
          margin: EdgeInsets.all(16.r),
          child: TabBar(
            controller: _friendsTabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(CORNER),
              color: color.xTrailing,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(4.r),
            labelColor: Colors.white,
            unselectedLabelColor: color.xTextColor,
            dividerHeight: 0,
            tabs: [
              Tab(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people, size: 18.r),
                    SizedBox(width: 6.w),
                    Text(
                      "My Friends",
                      style: TextStyle(
                        fontSize: FONT_13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Consumer<IFriendRequestProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Icon(Icons.notifications, size: 18.r),
                            if (provider.getCount() > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.all(2.r),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 14.w,
                                    minHeight: 14.h,
                                  ),
                                  child: Text(
                                    provider.getCount() > 99 ? '99+' : '${provider.getCount()}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "Requests",
                          style: TextStyle(
                            fontSize: FONT_13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 12.h),
        
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _friendsTabController,
            children: [
              IMyFriend(),
              IFriendRequests(),
            ],
          ),
        ),
      ],
    );
  }
}