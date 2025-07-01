import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../component/button.dart';
import '../../../component/online_status_indicator.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/friend.dart';
import '../../../provider/friend_request_provider.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';

class IFriendRequestCard extends StatefulWidget {
  final Friend friendRequest;
  final VoidCallback? onRefresh;

  const IFriendRequestCard({
    Key? key,
    required this.friendRequest,
    this.onRefresh,
  }) : super(key: key);

  @override
  State<IFriendRequestCard> createState() => _IFriendRequestCardState();
}

class _IFriendRequestCardState extends State<IFriendRequestCard> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      child: Card(
        elevation: ELEVATION,
        color: color.xSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CORNER * 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              // Profile Image
              OnlineStatusBadge(
                userId: widget.friendRequest.frndUsrId,
                badgeSize: 14.0,
                alignment: Alignment.topRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: CachedNetworkImage(
                    imageUrl: widget.friendRequest.frndUsrId?.toString().startsWith('http') == true
                        ? widget.friendRequest.frndUsrId.toString()
                        : '${IUrls.IMAGE_URL}/file/secured/${widget.friendRequest.frndUsrId}',
                    width: 60.w,
                    height: 60.w,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: color.xSecondaryColor,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 30.r,
                        color: color.xTextColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: color.xSecondaryColor,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 30.r,
                        color: color.xTextColor,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 12.w),
              
              // Friend Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.friendRequest.frndDesc ?? 'Unknown User',
                      style: TextStyle(
                        fontSize: FONT_TITLE,
                        fontWeight: FontWeight.w600,
                        color: color.xTextColorSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Wants to be your friend',
                      style: TextStyle(
                        fontSize: FONT_13,
                        color: color.xTextColor,
                      ),
                    ),
                    if (widget.friendRequest.frndType != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          widget.friendRequest.frndType.toString(),
                          style: TextStyle(
                            fontSize: FONT_SMALL,
                            color: color.xTextColorTertiary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Action Buttons
              if (!_isProcessing) ...[
                Column(
                  children: [
                    IButton(
                      onPress: () => _acceptRequest(),
                      text: 'Accept',
                      color: color.xTrailing,
                      textColor: Colors.white,
                      width: 80.w,
                      height: 35.h,
                      font: FONT_13,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 8.h),
                    IButton(
                      onPress: () => _rejectRequest(),
                      text: 'Reject',
                      color: color.xTextColorTertiary,
                      textColor: Colors.white,
                      width: 80.w,
                      height: 35.h,
                      font: FONT_13,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ] else ...[
                Container(
                  width: 80.w,
                  height: 78.h,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(color.xTrailing),
                    strokeWidth: 2.0,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _acceptRequest() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await Provider.of<IFriendRequestProvider>(context, listen: false)
          .acceptRequest(widget.friendRequest.frndId.toString());
      
      Mixin.showToast(context, 'Friend request accepted!', SUCCESS);
      
      if (widget.onRefresh != null) {
        widget.onRefresh!();
      }
    } catch (e) {
      Mixin.showToast(context, 'Failed to accept friend request', ERROR);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _rejectRequest() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await Provider.of<IFriendRequestProvider>(context, listen: false)
          .rejectRequest(widget.friendRequest.frndId.toString());
      
      Mixin.showToast(context, 'Friend request rejected', SUCCESS);
      
      if (widget.onRefresh != null) {
        widget.onRefresh!();
      }
    } catch (e) {
      Mixin.showToast(context, 'Failed to reject friend request', ERROR);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}