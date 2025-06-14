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
    Mixin.getUser().then((value) => {
      Mixin.user = value,
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          centerTitle: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
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
                      _postImage();
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
                    imageUrl: '${IUrls.IMAGE_URL}${Mixin.user?.usrImage.toString().replaceFirst('.', '')}',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
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
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                )
                    : Icon(Icons.person, size: 100, color: color.xPrimaryColor),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(child: SizedBox.shrink()),
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
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: 90.h,
            ),
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
                    });
                  },
                )
              ],
            ),
            Expanded(child: SizedBox.shrink()),
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

                    _postImage();

                    if(1 == 1) return;

                    if(Mixin.user?.usrImage == null){
                      Mixin.showToast(context, "Profile picture is required", ERROR);
                      return;
                    }

                    if(_girl == false && _boy == false){
                      Mixin.showToast(context, "Kindly select the categories", ERROR);
                      return;
                    }

                    Mixin.user?.usrGender = _girl ? 'FEMALE' : 'MALE';
                    Mixin.user?.usrOsType = _girlInt ? 'FEMALE' : 'MALE';

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
                            Mixin.pop(context, const IHome())});
                        } else {
                          Mixin.errorDialog(context, 'ERROR', res);
                        }
                        _isLoading = false;
                      });
                    }, IUrls.SIGN_UP());
                  },
                  isBlack: true,
                  text: "Get Started",
                  width: 150,
                  textColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 100,)
          ],
        ));
  }

  void _postImage(){
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
