import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/logo.dart';
import '../../component/popup.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../theme/custom_colors.dart';
import '../authenticate/select/intro.dart';
import '../authenticate/sign_up.dart';
import '../home/home.dart';

class IContactUs extends StatefulWidget {
  const IContactUs({Key? key}) : super(key: key);

  @override
  State<IContactUs> createState() => _IContactUsState();
}

class _IContactUsState extends State<IContactUs> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@winksy.net',
      query: 'subject=Contact%20from%20Winksy%20App',
    );
    
    try {
      await launchUrl(emailUri);
    } catch (e) {
      // Try with mode specification if first attempt fails
      try {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open email client')),
        );
      }
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+254700225822',
    );
    
    try {
      await launchUrl(phoneUri);
    } catch (e) {
      // Try with mode specification if first attempt fails
      try {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open phone dialer')),
        );
      }
    }
  }

  Future<void> _launchWebsite() async {
    final Uri websiteUri = Uri.parse('https://www.winksy.net');
    
    try {
      await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Try with different mode if first attempt fails
      try {
        await launchUrl(websiteUri, mode: LaunchMode.inAppWebView);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open website')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
          surfaceTintColor: color.xPrimaryColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: color.xPrimaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: color.xTrailing),
            onPressed: () {
              Navigator.pop(context); // Pops the current screen from the stack
            },
          ),
          title:Text("Contact us", style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
         ),
      backgroundColor: color.xPrimaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: SizedBox.shrink()),
              SizedBox(
                width: 258.w,
                child: Image.asset(
                  'assets/images/icon.png',
                  fit: BoxFit.cover, // Adjust the image's scaling
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: color.xPrimaryColor,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: color.xTrailing.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: color.xTrailing.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Email Card
                    _buildContactCard(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: 'info@winksy.net',
                      onTap: _launchEmail,
                      color: color,
                      iconColor: Colors.blue,
                    ),
                    
                    Divider(
                      color: color.xTrailing.withOpacity(0.1),
                      height: 1,
                      indent: 20.w,
                      endIndent: 20.w,
                    ),
                    
                    // Phone Card
                    _buildContactCard(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: '+254 700-225-822',
                      onTap: _launchPhone,
                      color: color,
                      iconColor: Colors.green,
                    ),
                    
                    Divider(
                      color: color.xTrailing.withOpacity(0.1),
                      height: 1,
                      indent: 20.w,
                      endIndent: 20.w,
                    ),
                    
                    // Website Card
                    _buildContactCard(
                      icon: Icons.language_outlined,
                      label: 'Website',
                      value: 'www.winksy.net',
                      onTap: _launchWebsite,
                      color: color,
                      iconColor: Colors.purple,
                    ),
                    
                    Divider(
                      color: color.xTrailing.withOpacity(0.1),
                      height: 1,
                      indent: 20.w,
                      endIndent: 20.w,
                    ),
                    
                    // Address Card (non-clickable)
                    Container(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Colors.orange,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address',
                                  style: TextStyle(
                                    color: color.xTrailing.withOpacity(0.7),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'P.O. Box 50410-10\nNairobi, Kenya',
                                  style: TextStyle(
                                    color: color.xTrailing,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    required CustomColors color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color.xTrailing.withOpacity(0.7),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextStyle(
                      color: color.xTrailing,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.touch_app_outlined,
              color: color.xTrailing.withOpacity(0.5),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
