import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../component/app_bar.dart';
import '../../component/button.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../request/posts.dart';
import '../../request/urls.dart';
import '../../theme/custom_colors.dart';
import '../splash/splash_screen.dart';

class IDeleteAccount extends StatefulWidget {
  const IDeleteAccount({super.key});

  @override
  State<IDeleteAccount> createState() => _IDeleteAccountState();
}

class _IDeleteAccountState extends State<IDeleteAccount> {
  bool _isLoading = false;
  final TextEditingController _confirmController = TextEditingController();
  final String _confirmText = "DELETE";

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    if (_confirmController.text.trim() != _confirmText) {
      _showMessage('Please type "DELETE" to confirm account deletion.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await IPost.postData(Mixin.user, (bool success, String message, dynamic result) async {
          setState(() {
            _isLoading = false;
          });

          if (success) {
            await Mixin.clear();
            if (mounted) {
              _showMessage(message, isSuccess: true);
              await Future.delayed(const Duration(seconds: 2));
              if (mounted) {
                Mixin.pop(context, ISplashScreen());
              }
            }
          } else {
            if (mounted) {
              _showMessage(message.isNotEmpty ? message : message);
            }
          }
        },
        IUrls.DELETE_ACCOUNT(),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showMessage('An error occurred. Please try again.');
    }
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    final color = Theme.of(context).extension<CustomColors>()!;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message,style: TextStyle(color: Colors.white),),
          backgroundColor: isSuccess ? Colors.green :color.xTrailing,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar: IAppBar (leading: true,title: 'Delete Account',),
      body: Container(
        padding: EdgeInsets.all(16.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50.h),
                    // User Profile Section
                    Container(
                      height: 120.w,
                      width: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color:color.xTrailing, width: 3),
                      ),
                      child: CircleAvatar(
                        backgroundColor: color.xSecondaryColor,
                        child: Mixin.user?.usrImage != null
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: '${Mixin.user?.usrImage}'.startsWith('http')
                                      ? Mixin.user?.usrImage ?? ''
                                      : '${IUrls.IMAGE_URL}/file/secured/${Mixin.user?.usrImage}',
                                  fit: BoxFit.cover,
                                  height: 120.w,
                                  width: 120.w,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: color.xPrimaryColor,
                                    highlightColor: color.xSecondaryColor,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.person,
                                    size: 50.r,
                                    color: color.xTextColor,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 50.r,
                                color: color.xTextColor,
                              ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    Text(
                      '${Mixin.user?.usrFirstName} ${Mixin.user?.usrLastName}',
                      style: TextStyle(
                        color: color.xTextColorSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: FONT_TITLE,
                      ),
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    Text(
                      '@${Mixin.user?.usrUsername}'.toLowerCase(),
                      style: TextStyle(
                        color: color.xTextColor,
                        fontSize: FONT_MEDIUM,
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Warning Section
                    Container(
                      padding: EdgeInsets.all(16.h),
                      decoration: BoxDecoration(
                        color:color.xTrailing.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color:color.xTrailing.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color:color.xTrailing,
                                size: 24.r,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Warning!',
                                style: TextStyle(
                                  color:color.xTrailing,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FONT_TITLE,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'This action cannot be undone. Deleting your account will permanently remove:',
                            style: TextStyle(
                              color: color.xTextColorSecondary,
                              fontSize: FONT_MEDIUM,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ...{
                            '• Your profile and personal information',
                            '• All your photos and memories',
                            '• Chat history and messages',
                            '• Friends and connections',
                            '• Game progress and achievements',
                            '• Virtual pets and zoo collection',
                            '• All account data and settings',
                          }.map((item) => Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: color.xTextColor,
                                fontSize: FONT_SMALL,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Confirmation Input
                    Text(
                      'To confirm, type "DELETE" in the box below:',
                      style: TextStyle(
                        color: color.xTextColorSecondary,
                        fontSize: FONT_MEDIUM,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    TextField(
                      controller: _confirmController,
                      decoration: InputDecoration(
                        hintText: 'Type DELETE to confirm',
                        hintStyle: TextStyle(color: color.xTextColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color:color.xTrailing),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color:color.xTrailing, width: 2),
                        ),
                        filled: true,
                        fillColor: color.xSecondaryColor,
                      ),
                      style: TextStyle(
                        color: color.xTextColorSecondary,
                        fontSize: FONT_MEDIUM,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
            
            // Buttons
            Column(
              children: [
                IButton(
                  onPress: _isLoading ? null : _deleteAccount,
                  isBlack: false,
                  textColor: Colors.white,
                  text: _isLoading ? "Deleting..." : "Delete Account",
                  color: _confirmController.text.trim() == _confirmText && !_isLoading
                      ? color.xTrailing
                      :color.xTrailing.withValues(alpha: 0.5),
                  width: MediaQuery.of(context).size.width,
                ),
                
                SizedBox(height: 16.h),
                
                IButton(
                  onPress: _isLoading ? null : () => Navigator.pop(context),
                  isBlack: true,
                  textColor: color.xTextColorSecondary,
                  text: "Cancel",
                  color: color.xSecondaryColor,
                  width: MediaQuery.of(context).size.width,
                ),
                
                SizedBox(height: 40.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}