import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:winksy/screen/account/terms.dart';
import '../../component/app_bar.dart';
import '../../component/button.dart';
import '../../component/popup.dart';
import '../../mixin/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import '../../mixin/constants.dart';
import '../../mixin/mixins.dart';
import '../../model/user.dart';
import '../../request/posts.dart';
import '../../request/urls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/custom_colors.dart';
import '../authenticate/select/intro.dart';
import '../splash/splash_screen.dart';

class ILogout extends StatefulWidget {
  const ILogout({super.key});

  @override
  State<ILogout> createState() => _ILogoutState();
}

class _ILogoutState extends State<ILogout> with TickerProviderStateMixin {
  User? user;
  bool light = true;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  bool isImage = false;
  XFile? image;
  bool isPasswordVisible = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final color = Theme.of(context).extension<CustomColors>()!;

    firstNameController.text = Mixin.user!.usrFirstName;
    lastNameController.text = Mixin.user!.usrLastName;
    emailController.text = Mixin.user!.usrEmail;
    usernameController.text = '@${Mixin.user!.usrUsername}'.toLowerCase();

    return Scaffold(
        backgroundColor: color.xPrimaryColor,
        appBar: AppBar(
            surfaceTintColor: color.xPrimaryColor,
            centerTitle: true,
            backgroundColor: color.xPrimaryColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.tertiary),
              onPressed: () {
                Navigator.pop(context); // Pops the current screen from the stack
              },
            ),
            title: Text("Sign out", style: TextStyle(color: color.xTrailing, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
            actions: <Widget>[
              IPopup()
            ]),
        body: Container(
          padding: EdgeInsets.only(right: 16.h, left: 16.h),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 400.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 250.h,
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 150.w,
                            width: 150.w,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              child: Mixin.user?.usrImage != null  ?
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: '${Mixin.user?.usrImage}'.startsWith('http') ? Mixin.user?.usrImage
                                      : '${IUrls.IMAGE_URL}/file/secured/${Mixin.user?.usrImage}',
                                  fit: BoxFit.cover,
                                  height: 150.w,
                                  width: 150.w,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: color.xPrimaryColor,
                                    highlightColor: color.xPrimaryColor,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              )
                                  : Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.tertiary,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Text('${Mixin.user?.usrFirstName}  ${Mixin.user?.usrLastName}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_APP_BAR),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '${Mixin.user?.usrUsername}'.toLowerCase(),
                        style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              IButton(
                onPress: () async {
                  await Mixin.clear();
                  Mixin.pop(context, ISplashScreen());
                },
                isBlack: false,
                textColor: Colors.white,
                text: "Sign out",
                color: color.xTrailing,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: 300.w,
                child: InkWell(
                  onTap: () {
                    Mixin.navigate(context, const ITerms());
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text:  TextSpan(
                      text: "By signing up, you agree to our",
                      style: TextStyle(color: Colors.white, fontSize: FONT_MEDIUM),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Terms of Use ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONT_MEDIUM, color: Theme.of(context).colorScheme.tertiary,
                                decoration: TextDecoration.underline)),
                        TextSpan(
                            text: 'and to receive Wink emails & updates and acknowledge that you read our ',
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: FONT_MEDIUM, color: Colors.white)),
                        TextSpan(
                            text: ' Privacy Policy.',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONT_MEDIUM, color: Theme.of(context).colorScheme.tertiary, decoration: TextDecoration.underline)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ));
  }
}
