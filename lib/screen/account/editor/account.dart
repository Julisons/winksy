import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../component/button.dart';
import '../../../component/face_detector.dart';
import '../../../component/phone_field.dart';
import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../model/user.dart';
import '../../../request/posts.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import '../../authenticate/select/bio.dart';
import '../terms.dart';


class IAccount extends StatefulWidget {
  const IAccount({super.key});

  @override
  State<IAccount> createState() => _IAccountState();
}

class _IAccountState extends State<IAccount> with TickerProviderStateMixin {
  bool light = true;
  bool _isImage = false,_isLoading = false;
  XFile? _image;
  CroppedFile? _croppedFile;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime latestAllowedDate = DateTime(now.year - 12, now.month, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: latestAllowedDate, // safe default
      firstDate: DateTime(1900),
      lastDate: latestAllowedDate,
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _ageController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        Mixin.user?.usrDob = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.text = Mixin.user!.usrFirstName;
    _lastNameController.text = Mixin.user!.usrLastName;
    _phoneController.text = Mixin.user!.usrMobileNumber;
    _emailController.text = Mixin.user!.usrEmail;
    _ageController.text = Mixin.user!.usrDob != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse('${Mixin.user!.usrDob}')) : '';
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 760.h,
      padding: EdgeInsets.all(6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 330.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 7.h,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 163.w,
                      height: 163.w,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 0.75),
                        duration: Duration(milliseconds: 3000),
                        builder: (context, value, _) => CircularProgressIndicator(
                          value: value,
                          strokeWidth: 3.r,
                          backgroundColor: color.xSecondaryColor,
                          color: color.xTrailingAlt, // blue accent color
                        ),
                      ),
                    ),
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
                              imageUrl: Mixin.user?.usrImage.startsWith('http') ? Mixin.user?.usrImage
                                  : '${IUrls.IMAGE_URL}/file/secured/${Mixin.user?.usrImage}',
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
                IButton(
                  onPress: () async {
                    await ImagePicker()
                        .pickImage(source: ImageSource.gallery)
                        .then((value) {
                      if (value != null) {
                        _image = value;
                        _cropImage();
                      }});
                  },
                  isBlack: false,
                  textColor: Colors.white,
                  text: "Edit",
                  icon: Icon(Icons.edit, color: Colors.white, size: 16.r),
                  color: color.xTrailing,
                  width: 95.h,
                  height: 35.h,
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
              ],
            ),
          ),

          TextFormField(
            controller: _firstNameController,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: color.xTrailing),
                ),
                border: InputBorder.none,
                hintText: 'First name',
                labelText: 'First name',
                labelStyle: TextStyle(
                  color: color.xTextColor,
                  fontSize: FONT_13,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: color.xTrailing),
                ),
                hintStyle: TextStyle(
                  color: color.xTextColor,
                  fontSize: FONT_13,
                ),
                suffixIcon: Icon(Icons.star,color: color.xTrailing, size: 1,),
                fillColor: color.xPrimaryColor,
                filled: true
            ),
            onChanged: (value){
              Mixin.user?.usrFirstName = value;
            },
          ),
          SizedBox(height: 24.h),
          TextFormField(
            controller: _lastNameController,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
            decoration:  InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color.xTrailing),
              ),
              border: InputBorder.none,
              hintText: 'Last name',
              labelText: 'Last name',
              labelStyle: TextStyle(
                color: color.xTextColor,
                fontSize: FONT_13,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color.xTrailing),
              ),
              hintStyle: TextStyle(
                color: color.xTextColor,
                fontSize: FONT_13,
              ),
              suffixIcon: Icon(Icons.star,color: color.xTrailing, size: 1,),
              fillColor: color.xPrimaryColor,
              filled: true,
            ),
            onChanged: (value){
              Mixin.user?.usrLastName = value;
            },
          ),
          SizedBox(height: 24.h),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
            decoration:  InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color.xTrailing),
              ),
              border: InputBorder.none,
              labelText: 'Email address',
              labelStyle: TextStyle(
                color: color.xTextColor,
                fontSize: FONT_13,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color.xTrailing),
              ),
              hintText: 'Email address',
              hintStyle: TextStyle(
                color: color.xTextColor,
                fontSize: FONT_13,
              ),

              suffixIcon: Icon(Icons.star,color: color.xTrailing, size: 1,),
              fillColor: color.xPrimaryColor,
              filled: true,
              enabled: false
            ),
            onChanged: (value){
              Mixin.user?.usrEmail = value;
            },
          ),
          const SizedBox(height: 24),
          PhoneField(
            textEditingController: _phoneController,
            onCodeChange: (code) {},
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _ageController,
            style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
            onTap: () {
              _selectDate(context);
            },
            decoration:  InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color.xTrailing),
              ),
              border: InputBorder.none,
              labelText: 'Date of Birth',
              labelStyle: TextStyle(
                color: color.xTextColor,
                fontSize: FONT_13,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color.xTrailing),
              ),
              hintText: 'Date of Birth',
              hintStyle: TextStyle(
                color: color.xTextColor,
                fontSize: FONT_13,
              ),
              suffixIcon: Icon(Icons.star,color: color.xTrailing, size: 1,),
              fillColor: color.xPrimaryColor,
              filled: true,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
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

      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return  Container(
            height: MediaQuery.of(context).size.height/1.2,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: 10),
            child: FaceDetectionScanner(
              croppedFile: croppedFile, // Your CroppedFile from image_cropper
              onFaceDetected: (hasFace) {
                if(hasFace){
                  if (croppedFile != null) {
                    setState(() {
                      Navigator.pop(context);
                      _isImage = true;
                      _croppedFile = croppedFile;
                      _postImage();
                    });
                  }
                }else{
                  Navigator.pop(context);
                  Mixin.showToast(context, 'We couldn’t detect a face in this photo. Please upload a clear photo of yourself.', ERROR);
                }
              },
              scanColor: Theme.of(context).extension<CustomColors>()!.xTrailingAlt,
              showDetectionDetails: true,
              height: 400,
            ),
          );
        },
      );
    }
  }

}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
