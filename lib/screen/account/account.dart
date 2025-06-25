import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
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

import '../splash/splash_screen.dart';

class IAccount extends StatefulWidget {
  const IAccount({super.key});

  @override
  State<IAccount> createState() => _IAccountState();
}

class _IAccountState extends State<IAccount> with TickerProviderStateMixin {
  bool light = true;
  var _isLoading = false;
  bool _isImage = false;
  XFile? _image;
  CroppedFile? _croppedFile;
  bool isPasswordVisible = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    firstNameController.text = Mixin.user!.usrFirstName;
    lastNameController.text = Mixin.user!.usrLastName;
    phoneController.text = Mixin.user!.usrMobileNumber;
    emailController.text = Mixin.user!.usrEmail;
    usernameController.text = '${Mixin.user!.usrUsername}'.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
            surfaceTintColor: Theme.of(context).colorScheme.surface,
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.tertiary),
              onPressed: () {
                Navigator.pop(context); // Pops the current screen from the stack
              },
            ),
            title: Text("Edit Profile", style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
            actions: <Widget>[
              IPopup()
            ]),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          height: 150.w,
                          width: 150.w,
                          child: InkWell(
                            hoverColor: Theme.of(context).colorScheme.surface,
                            focusColor: Theme.of(context).colorScheme.surface,
                            highlightColor: Theme.of(context).colorScheme.surface,
                            splashColor: Theme.of(context).colorScheme.surface,
                            onTap: () async {
                              await ImagePicker()
                                  .pickImage(source: ImageSource.gallery)
                                  .then((value) {
                                if (value != null) {
                                  _image = value;
                                  _cropImage();
                                }
                              });
                            },
                            child: _isImage ? ClipOval(
                              child: Image.file(
                                File(_croppedFile?.path ?? ''),
                                width: 70.h,
                                height: 70.h,
                                fit: BoxFit.cover,
                              ),
                            ) :  CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              child: Mixin.user?.usrImage != null  ?
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: '${IUrls.IMAGE_URL}${Mixin.user?.usrImage.toString().replaceFirst('.', '')}',
                                  fit: BoxFit.cover,
                                  height: 150.w,
                                  width: 150.w,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: Theme.of(context).colorScheme.surface,
                                    highlightColor: Theme.of(context).colorScheme.surface,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>  CircleAvatar(
                                      backgroundColor: Theme.of(context).colorScheme.secondary,
                                      child: Icon(Icons.person, size: 50,color:Theme.of(context).colorScheme.tertiary,)),
                                ),
                              )
                                  : Icon(Icons.person, size: 50,color:Theme.of(context).colorScheme.tertiary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '${Mixin.user?.usrFirstName}  ${Mixin.user?.usrLastName}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: FONT_APP_BAR),
                    ),
                    SizedBox(height: 10.h),
                    IButton(
                      onPress: () {},
                      isBlack: false,
                      textColor: Colors.white,
                      text: "Edit",
                      color: Theme.of(context).colorScheme.secondary,
                      width: 80,
                      height: 35,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 34.h),
                child: Column(
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: FONT_13,  color:  Color.fromRGBO(153, 153, 153, 1)),
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                          ),
                          focusedBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                          ),
                          border: InputBorder.none,
                          hintText: 'First name',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: FONT_13,
                          ),
                          suffixIcon: Icon(Icons.star,color: Theme.of(context).colorScheme.tertiary, size: 1,),
                          fillColor: Theme.of(context).colorScheme.surface,
                          filled: true
                      ),
                    ),
                    SizedBox(height: 24.h),
                    TextFormField(
                      controller: lastNameController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: FONT_13,  color:  Color.fromRGBO(153, 153, 153, 1)),
                      decoration:  InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        border: InputBorder.none,
                        hintText: 'Last name',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: FONT_13,
                        ),
                        suffixIcon: Icon(Icons.star,color: Theme.of(context).colorScheme.tertiary, size: 1,),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: FONT_13,  color:  Color.fromRGBO(153, 153, 153, 1)),
                      decoration:  InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        border: InputBorder.none,
                        hintText: 'Email address',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: FONT_13,
                        ),
                        suffixIcon: Icon(Icons.star,color: Theme.of(context).colorScheme.tertiary, size: 1,),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: pinController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: FONT_13,  color:  Color.fromRGBO(153, 153, 153, 1)),
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: FONT_13,
                        ),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    TextFormField(
                      readOnly: true,
                      style: TextStyle(fontSize: FONT_13,  color:  Color.fromRGBO(153, 153, 153, 1)),
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        border: InputBorder.none,
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: FONT_13,
                        ),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 34.h),
                child:  _isLoading
                    ?  Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                )
                    :Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IButton(
                        onPress: () {
                          if (firstNameController.text.isEmpty) {
                            Mixin.showToast(
                                context, "First name cannot be empty!", ERROR);
                            return;
                          }

                          if (lastNameController.text.isEmpty) {
                            Mixin.showToast(context, "Last name cannot be empty!", ERROR);
                            return;
                          }

                          if (phoneController.text.isEmpty) {
                            Mixin.showToast(context, "Phone cannot be empty!", ERROR);
                            return;
                          }

                          if (emailController.text.isEmpty) {
                            Mixin.showToast(context, "Email cannot be empty!", ERROR);
                            return;
                          }

                          if (pinController.text.isEmpty) {
                            Mixin.showToast(context, "Password cannot be empty!", ERROR);
                            return;
                          }

                          if (usernameController.text.isEmpty) {
                            Mixin.showToast(
                                context, "Username cannot be empty!", ERROR);
                            return;
                          }

                          Mixin.user?.usrFirstName = firstNameController.text.trim();
                          Mixin.user?.usrLastName = lastNameController.text.trim();
                          Mixin.user?.usrEmail = emailController.text.trim();
                          Mixin.user?.usrEncryptedPassword = pinController.text.trim();
                          Mixin.user?.usrMobileNumber = phoneController.text.trim();
                          Mixin.user?.usrUsername = usernameController.text.trim();

                          setState(() {
                            _isLoading = true;
                          });

                          IPost.postData(Mixin.user, (state, res, value) {
                            setState(() {
                              if (state) {
                                Mixin.prefString(pref: value.toString(), key: CURR);
                                Mixin.showToast(context, res, INFO);
                                Mixin.getUser().then((value) => {
                                  Mixin.user = value,
                                });
                              } else {
                                Mixin.errorDialog(context, 'ERROR', res);
                              }
                              _isLoading = false;
                            });
                          }, IUrls.SIGN_UP());
                        },
                        isBlack: false,
                        text: "Done",
                        color: Theme.of(context).colorScheme.tertiary,
                        width: MediaQuery.of(context).size.width/2.2
                    ),
                    IButton(
                        onPress: () {

                        },
                        isBlack: false,
                        text: "Cancel",
                        color: Theme.of(context).colorScheme.secondary,
                        textColor: Colors.white,
                        width: MediaQuery.of(context).size.width/2.2
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h)
            ],
          ),
        ));
  }

  _postImage(){
    IPost.postFileCropped([_croppedFile!], (state, res, value) {
      setState(() {
        if (state) {
          Mixin.user?.usrImage = value;
          IPost.postData(Mixin.user, (state, res, value) {
            if (state) {
              Mixin.prefString(pref: value.toString(), key: CURR);
              Mixin.showToast(context, res, INFO);
            } else {
              Mixin.errorDialog(context, 'ERROR', res);
            }
          }, IUrls.SIGN_UP());
        } else {
          Mixin.errorDialog(context, 'ERROR', res);
        }
        _isLoading = false;
      });
    }, IUrls.IMAGE());
  }

  Future<void> _cropImage() async {
    if (_image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(context).colorScheme.surface,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            aspectRatioPresets: [
              //  CropAspectRatioPreset.original,
              //  CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              //CropAspectRatioPresetCustom(),
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _isImage = true;
          _croppedFile = croppedFile;
          _postImage();
        });
      }
    }
  }

}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
