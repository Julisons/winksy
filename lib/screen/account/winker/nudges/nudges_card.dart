import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/model/nudge_sound.dart';
import 'package:confetti/confetti.dart';
import '../../../../component/loader.dart';
import '../../../../mixin/mixins.dart';
import '../../../../request/posts.dart';
import '../../../../request/urls.dart';
import '../../../../theme/custom_colors.dart';

class INudgeCard extends StatefulWidget {
  final NudgeSound nudgeSound;

  const INudgeCard({
    super.key, 
    required this.nudgeSound,
  });

  @override
  State<INudgeCard> createState() => _INudgeCardState();
}

class _INudgeCardState extends State<INudgeCard> {
  bool _isLoading = false;
  bool _isPlaying = false;
  late ConfettiController _controllerCenter;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 3));
    
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    
    return InkWell(
      child: Card(
        elevation: ELEVATION,
        color: color.xSecondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 60.r,
                        height: 60.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.xTrailing.withOpacity(0.1),
                          border: Border.all(
                            color: color.xTrailing.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          _isPlaying ? Icons.volume_up : Icons.notifications_active,
                          color: color.xTrailing,
                          size: 30.r,
                        ),
                      ),
                      if (_isPlaying)
                        Container(
                          width: 70.r,
                          height: 70.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color.xTrailing,
                              width: 2,
                            ),
                          ),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(color.xTrailing),
                            strokeWidth: 2,
                          ),
                        ),
                    ],
                  ),

              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note,
                    color: color.xTrailingAlt,
                    size: 16.r,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${widget.nudgeSound.nudgesName ?? 'Audio'}',
                    style: TextStyle(
                      fontSize: FONT_13,
                      fontWeight: FontWeight.bold,
                      color: color.xTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Preview button
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _previewSound,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.xPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          minimumSize: Size(0, 32.h),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isPlaying ? Icons.stop : Icons.play_arrow,
                              color: Colors.white,
                              size: 16.r,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _isPlaying ? 'Stop' : 'Listen',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: FONT_SMALL,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Send button
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => _sendNudge(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.xTrailing,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          minimumSize: Size(0, 32.h),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isLoading)
                              SizedBox(
                                width: 12.r,
                                height: 12.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            else
                              Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 16.r,
                              ),
                            SizedBox(width: 4.w),
                            Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: FONT_SMALL,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _previewSound() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    } else {
      try {
        final soundUrl = widget.nudgeSound.nudgesPath.startsWith('http')
            ? widget.nudgeSound.nudgesPath
            : '${IUrls.IMAGE_URL}/file/sounds/${widget.nudgeSound.nudgesPath}';
        
        await _audioPlayer.play(UrlSource(soundUrl));
      } catch (e) {
        if (mounted) {
          Mixin.showToast(context, 'Error playing sound', ERROR);
        }
      }
    }
  }

  void _sendNudge(BuildContext context) {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> nudgeData = {
      'nudgeIntId': Mixin.winkser?.usrId,
      'nudgeNudgesId': widget.nudgeSound.nudgesId,
      'nudgeDesc': widget.nudgeSound.nudgesName,
      'nudgeUsrId': Mixin.user?.usrId,
      'nudgeSound': widget.nudgeSound.nudgesPath};

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final color = Theme.of(context).extension<CustomColors>()!;
        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.xSecondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(color.xTrailing),
                ),
                SizedBox(height: 16),
                Text(
                  'Sending nudge...',
                  style: TextStyle(
                    color: color.xTextColorSecondary,
                    fontSize: FONT_13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Actual API call implementation:
    IPost.postData(nudgeData, (state, res, value) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        if (state) {
          _controllerCenter.play();
          Mixin.showToast(context, res, SUCCESS);
        } else {
          Mixin.errorDialog(context, 'ERROR', res);
        }
      }
    }, IUrls.NUDGE());
  }
}