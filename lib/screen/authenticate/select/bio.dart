import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../component/button.dart';
import '../../../../component/loading.dart';
import '../../../../component/no_result.dart';
import '../../../../mixin/constants.dart';
import '../../../../mixin/mixins.dart';
import '../../../../model/user.dart';
import '../../../../request/posts.dart';
import '../../../../request/urls.dart';
import '../../../../theme/custom_colors.dart';
import '../../home/home.dart';


class IBio extends StatefulWidget {
  const IBio({super.key});

  @override
  State<IBio> createState() => _IBioState();
}

class _IBioState extends State<IBio> with TickerProviderStateMixin {
  bool _girl = false, _boy = false;
  bool _girlInt = false, _boyInt = false;
  bool _isLoading = false;
  final TextEditingController _bioController = TextEditingController();
  CroppedFile? _croppedFile;
  Timer? _debounce;
  bool _isImage = false;
  XFile? _image;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    _girl = Mixin.user?.usrGender == 'FEMALE';
    _boy = Mixin.user?.usrGender == 'MALE';
    _boyInt = Mixin.user?.usrOsType == 'MALE';
    _girlInt = Mixin.user?.usrOsType == 'FEMALE';
    _bioController.text = Mixin.user?.usrDesc;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: color.xPrimaryColor,
          centerTitle: false,
          backgroundColor: color.xPrimaryColor,
        ),
        backgroundColor: color.xPrimaryColor,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: " Please fill below ",
                    style: TextStyle(
                      color: color.xTextColor,
                      fontWeight: FontWeight.normal,
                      fontSize: FONT_APP_BAR,
                    ),
                    children: [
                      TextSpan(
                        text: "information",
                        style: TextStyle(
                          color: color.xTrailing,
                          fontWeight: FontWeight.bold,
                          fontSize: FONT_APP_BAR,
                        ),
                      ),
                      TextSpan(
                        text: "\nTo get started .",
                        style: TextStyle(
                          color: color.xTextColor,
                          fontWeight: FontWeight.normal,
                          fontSize: FONT_APP_BAR,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40,),
                Container(
                  height: MediaQuery.of(context).size.width/3,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                    color: color.xSecondaryColor, // Background color
                    borderRadius: BorderRadius.circular(16.0), // Rounded corners
                  ),
                  child: InkWell(
                    onTap: () async {
                      await ImagePicker()
                          .pickImage(source: ImageSource.gallery)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            _image = value;
                            _cropImage();
                          });
                        }
                      });
                    },
                    child: _isImage ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(_croppedFile?.path ?? ''),
                        height: MediaQuery.of(context).size.width/3,
                        width: MediaQuery.of(context).size.width/2,
                        fit: BoxFit.cover,
                      ),
                    ) :  Mixin.user?.usrImage != null  ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: Mixin.user?.usrImage.startsWith('http') ? Mixin.user?.usrImage
                       : '${IUrls.IMAGE_URL}/file/secured/${Mixin.user?.usrImage}',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
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
                        : Icon(Icons.person, size: 100, color: color.xPrimaryColor),
                  ),
                ),
                SizedBox(height: 34.h),
                Text(
                  " I am a",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color.xTextColor,
                      fontWeight: FontWeight.normal,
                      fontSize: FONT_13),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Card(
                        shape: _girl
                            ? RoundedRectangleBorder(
                                side: BorderSide(color: color.xTrailing, width: 2),
                                borderRadius: BorderRadius.circular(16))
                            : RoundedRectangleBorder(
                                side: BorderSide(
                                    color: color.xPrimaryColor, width: .6),
                                borderRadius: BorderRadius.circular(16)),
                        color: color.xSecondaryColor,
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.girl,
                              color: Colors.pink,
                              size: 70,
                            )),
                      ),
                      onTap: () {
                        setState(() {
                          _girl = true;
                          _boy = false;
                          _boyInt = true;
                          _girlInt = false;

                          Mixin.user?.usrGender = _girl ? 'FEMALE' : 'MALE';
                          Mixin.user?.usrOsType = _girlInt ? 'FEMALE' : 'MALE';
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Card(
                        shape: _boy
                            ? RoundedRectangleBorder(
                                side: BorderSide(color: color.xTrailing, width: 2),
                                borderRadius: BorderRadius.circular(16))
                            : RoundedRectangleBorder(
                                side: BorderSide(
                                    color: color.xPrimaryColor, width: .6),
                                borderRadius: BorderRadius.circular(16)),
                        color: color.xSecondaryColor,
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.boy,
                              color: Colors.blue,
                              size: 70,
                            )),
                      ),
                      onTap: () {
                        setState(() {
                          _boy = true;
                          _girl = false;
                          _girlInt = true;
                          _boyInt = false;

                          Mixin.user?.usrGender = _girl ? 'FEMALE' : 'MALE';
                          Mixin.user?.usrOsType = _girlInt ? 'FEMALE' : 'MALE';
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 34.h),
                Text(
                  " I am looking for a",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color.xTextColor,
                      fontWeight: FontWeight.normal,
                      fontSize: FONT_13),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Card(
                        shape: _girlInt
                            ? RoundedRectangleBorder(
                                side: BorderSide(color: color.xTrailing, width: 2),
                                borderRadius: BorderRadius.circular(16))
                            : RoundedRectangleBorder(
                                side: BorderSide(
                                    color: color.xPrimaryColor, width: .6),
                                borderRadius: BorderRadius.circular(16)),
                        color: color.xSecondaryColor,
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.girl,
                              color: Colors.pink,
                              size: 70,
                            )),
                      ),
                      onTap: () {
                        setState(() {
                          _girlInt = true;
                          _boyInt = false;

                          Mixin.user?.usrGender = _girl ? 'FEMALE' : 'MALE';
                          Mixin.user?.usrOsType = _girlInt ? 'FEMALE' : 'MALE';
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Card(
                        shape: _boyInt
                            ? RoundedRectangleBorder(
                                side: BorderSide(color: color.xTrailing, width: 2),
                                borderRadius: BorderRadius.circular(16))
                            : RoundedRectangleBorder(
                                side: BorderSide(
                                    color: color.xPrimaryColor, width: .6),
                                borderRadius: BorderRadius.circular(16)),
                        color: color.xSecondaryColor,
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.boy,
                              color: Colors.blue,
                              size: 70,
                            )),
                      ),
                      onTap: () {
                        setState(() {
                          _boyInt = true;
                          _girlInt = false;

                          Mixin.user?.usrGender = _girl ? 'FEMALE' : 'MALE';
                          Mixin.user?.usrOsType = _girlInt ? 'FEMALE' : 'MALE';
                        });
                      },
                    )
                  ],
                ),

                Padding(
                  padding:  EdgeInsets.only(top: 64.h, left: 16.w, right: 16.w),
                  child: TextFormField(
                    controller: _bioController,
                    keyboardType: TextInputType.text,
                    maxLines: 6,
                    style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color.xTrailing),
                        ),
                        hintText: 'About me',
                        labelText: 'About me',
                        labelStyle: TextStyle(
                          color: color.xTextColor,
                          fontSize: FONT_13,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: color.xTrailing),
                        ),
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                          color: color.xTextColor,
                          fontSize: FONT_13,
                        ),
                        suffixIcon: Icon(Icons.star,color: color.xTrailing, size: 1,),
                        fillColor: color.xSecondaryColor,
                        filled: true
                    ),
                    onChanged: (value) {
                      Mixin.user?.usrDesc = _bioController.text;
                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                _isLoading
                    ?  Center(
                  child: CircularProgressIndicator(
                    color:  color.xTrailing,
                  ),
                )
                    :
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IButton(
                      color:  color.xTrailing,
                      onPress: () {

                        if(_bioController.text.isEmpty){
                          Mixin.showToast(context, "Please write something about you", ERROR);
                          return;
                        }

                        if(Mixin.user?.usrImage == null){
                          Mixin.showToast(context, "Profile picture is required", ERROR);
                          return;
                        }

                        if(_girl == false && _boy == false){
                          Mixin.showToast(context, "Kindly select the categories", ERROR);
                          return;
                        }

                        Mixin.user?.usrDesc = _bioController.text;

                        Mixin.user?.usrGender = _girl ? 'FEMALE' : 'MALE';
                        Mixin.user?.usrOsType = _girlInt ? 'FEMALE' : 'MALE';

                        setState(() {
                          _isLoading = true;
                        });

                        IPost.postData(Mixin.user, (state, res, value) {
                          setState(() {
                            if (state) {
                                Mixin.showToast(context, res, INFO);
                                Mixin.prefString(pref:jsonEncode(Mixin.user), key: CURR);
                                Mixin.pop(context, const IHome());
                            } else {
                              Mixin.errorDialog(context, 'ERROR', res);
                            }
                            _isLoading = false;
                          });
                        }, IUrls.UPDATE_USER());
                      },
                      isBlack: true,
                      text: "Get Started",
                      width: 150,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _postImage(){
    IPost.postFileCropped([_croppedFile!], (state, res, value) {
      setState(() {
        if (state) {
          Mixin.user?.usrImage = value;
          IPost.postData(Mixin.user, (state, res, value) {
            if (state) {
              Mixin.showToast(context, res, INFO);
            } else {
              Mixin.errorDialog(context, 'ERROR', res);
            }
          }, IUrls.UPDATE_USER());
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
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
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
