import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:winksy/model/photo.dart';
import 'package:winksy/screen/account/photo/photo_card.dart';

import '../../../mixin/constants.dart';
import '../../../mixin/mixins.dart';
import '../../../provider/photo_provider.dart';
import '../../../request/posts.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import '../../people/people_shimmer.dart';

class IPhotos extends StatefulWidget {
  const IPhotos({super.key});

  @override
  State<IPhotos> createState() => _IPhotosState();
}

class _IPhotosState extends State<IPhotos> {
  // Example item list (e.g., matches, rooms)
  final List<String> _items = [];
  bool _girl = false, _boy = false;
  bool _girlInt = false, _boyInt = false;
  bool _isLoading = false;

  CroppedFile? _croppedFile;
  Timer? _debounce;
  bool _isImage = false;
  XFile? _image;

  Future<void> _addItem() async {
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
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: color.xSecondaryColor,
      body: Consumer<IPhotoProvider>(
          builder: (context, provider, child) {
            return provider.isLoading() ? const IPeopleShimmer() :
            Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                      color: color.xTrailing,
                      backgroundColor: color.xPrimaryColor,
                      onRefresh: () => provider.refresh('', true),
                      child: GridView.builder(
                        padding: const EdgeInsets.only(
                            bottom: 6,
                            top: 6,
                            right: 6,
                            left: 6),
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Mixin.isTab(context) ? 3 : 2, // Number of items per row
                          crossAxisSpacing: .0, // Spacing between columns
                          mainAxisSpacing: 6.0, // Spacing between rows
                          childAspectRatio: .7, // Aspect ratio of each grid item
                        ),
                        itemBuilder: (context, index) {
                          return IPhotoCard(
                            photo: provider.list[index],
                            onRefresh: () {
                              setState(() {

                              });
                            },
                            text: 'View Details',
                          );
                        },
                        itemCount: provider.getCount(),
                      )),
                ),

                if(provider.isLoadingMore())
                  Container(
                      padding: EdgeInsets.all(14.h),
                      child: CircularProgressIndicator(color: color.xTrailing,strokeWidth: 1,))
              ],
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _addItem,
        tooltip: 'Add Photo',
        backgroundColor: color.xTrailingAlt,
        label: Text('Add Photo'),
        icon: FaIcon(FontAwesomeIcons.cameraRetro, color: Colors.white, size: 20,),
      ),
    );
  }

  void _postImage(){
    IPost.postFileCropped([_croppedFile!], (state, res, value) {
      setState(() {
        if (state) {
          Photo image = Photo()
              ..imgImage = (value)
              ..imgUsrId = Mixin.user?.usrId;

          IPost.postData(image, (state, res, value) {
            if (state) {
              Mixin.prefString(pref: value.toString(), key: CURR);
              Mixin.showToast(context, res, INFO);

              Provider.of<IPhotoProvider>(context, listen: false)
                  .refresh('', true);
            } else {
              Mixin.errorDialog(context, 'ERROR', res);
            }
          }, IUrls.PHOTO());
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
