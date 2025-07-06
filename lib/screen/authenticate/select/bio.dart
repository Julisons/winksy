import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
import '../../../component/face_detector.dart';
import '../../../component/loader.dart';
import '../../home/home.dart';

class ParticlePainter extends CustomPainter {
  final double animationValue;
  
  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent particles
    
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      
      // Create floating motion
      final y = baseY + math.sin((animationValue * 2 * math.pi) + (i * 0.5)) * 10;
      
      final radius = 2 + random.nextDouble() * 3;
      final opacity = 0.05 + (math.sin(animationValue * 2 * math.pi + i) * 0.05);
      
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AnimatedGradientBackground extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const AnimatedGradientBackground({
    Key? key,
    required this.child,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).extension<CustomColors>()!.xPrimaryColor,
                Theme.of(context).extension<CustomColors>()!.xPrimaryColor.withOpacity(0.8),
                Theme.of(context).extension<CustomColors>()!.xSecondaryColor.withOpacity(0.1),
              ],
              stops: [
                0.0,
                0.5 + math.sin(animation.value * 2 * math.pi) * 0.3,
                1.0,
              ],
            ),
          ),
          child: child,
        );
      },
    );
  }
}

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
  final TextEditingController _birthdayController = TextEditingController();
  CroppedFile? _croppedFile;
  Timer? _debounce;
  bool _isImage = false;
  XFile? _image;
  DateTime? selectedDate;

  // Animation Controllers
  late AnimationController _headerAnimationController;
  late AnimationController _imageAnimationController;
  late AnimationController _cardsAnimationController;
  late AnimationController _fieldsAnimationController;
  late AnimationController _buttonAnimationController;
  late AnimationController _particleAnimationController;
  late AnimationController _loadingAnimationController;

  // Animations
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _imagePulseAnimation;
  late Animation<Offset> _girlCardSlideAnimation;
  late Animation<Offset> _boyCardSlideAnimation;
  late Animation<double> _cardsOpacityAnimation;
  late Animation<Offset> _fieldsSlideAnimation;
  late Animation<double> _fieldsOpacityAnimation;
  late Animation<double> _buttonBounceAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _loadingRotationAnimation;

  // Selection animations
  late AnimationController _girlSelectionController;
  late AnimationController _boySelectionController;
  late AnimationController _girlIntSelectionController;
  late AnimationController _boyIntSelectionController;
  
  late Animation<double> _girlSelectionScale;
  late Animation<double> _boySelectionScale;
  late Animation<double> _girlIntSelectionScale;
  late Animation<double> _boyIntSelectionScale;

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _imageAnimationController.dispose();
    _cardsAnimationController.dispose();
    _fieldsAnimationController.dispose();
    _buttonAnimationController.dispose();
    _particleAnimationController.dispose();
    _loadingAnimationController.dispose();
    _girlSelectionController.dispose();
    _boySelectionController.dispose();
    _girlIntSelectionController.dispose();
    _boyIntSelectionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _initializeAnimations();
    
    // Initialize birthday if user already has date of birth
    if (Mixin.user?.usrDob != null) {
      try {
        selectedDate = DateTime.parse(Mixin.user!.usrDob);
        _birthdayController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      } catch (e) {
        print('Error parsing birthday: $e');
      }
    }
    
    // Start entrance animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startEntranceAnimations();
      
      // Schedule Google profile image validation after animations
      if (Mixin.user?.usrType == 'GOOGLE' && Mixin.user?.usrImage != null) {
        log('-------------usrType------bot-null-----usrImage-----${Mixin.user?.usrImage}------');
        Future.delayed(Duration(milliseconds: 800), () {
          _validateGoogleProfileImage();
        });
      } else {
        log('-------------usrType-------null-----usrImage-----------');
      }
    });
  }

  void _initializeAnimations() {
    // Main animation controllers
    _headerAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _imageAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _cardsAnimationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fieldsAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _particleAnimationController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _loadingAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Selection controllers
    _girlSelectionController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _boySelectionController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _girlIntSelectionController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _boyIntSelectionController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // Header animations
    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _headerSlideAnimation = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    // Image animations
    _imageScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _imagePulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.easeInOut,
    ));

    // Card animations
    _girlCardSlideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardsAnimationController,
      curve: Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));
    
    _boyCardSlideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardsAnimationController,
      curve: Interval(0.2, 0.9, curve: Curves.elasticOut),
    ));
    
    _cardsOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardsAnimationController,
      curve: Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Fields animations
    _fieldsSlideAnimation = Tween<Offset>(
      begin: Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fieldsAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _fieldsOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fieldsAnimationController,
      curve: Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Button animations
    _buttonBounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _buttonScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeOut,
    ));

    // Particle animation
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleAnimationController);

    // Loading animation
    _loadingRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(_loadingAnimationController);

    // Selection animations
    _girlSelectionScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _girlSelectionController,
      curve: Curves.elasticOut,
    ));
    
    _boySelectionScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _boySelectionController,
      curve: Curves.elasticOut,
    ));
    
    _girlIntSelectionScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _girlIntSelectionController,
      curve: Curves.elasticOut,
    ));
    
    _boyIntSelectionScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _boyIntSelectionController,
      curve: Curves.elasticOut,
    ));
  }

  void _startEntranceAnimations() async {
    // Staggered entrance animations
    _headerAnimationController.forward();
    
    await Future.delayed(Duration(milliseconds: 200));
    _imageAnimationController.forward();
    
    await Future.delayed(Duration(milliseconds: 300));
    _cardsAnimationController.forward();
    
    await Future.delayed(Duration(milliseconds: 400));
    _fieldsAnimationController.forward();
    
    await Future.delayed(Duration(milliseconds: 200));
    _buttonAnimationController.forward();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime latestAllowedDate = DateTime(now.year - 18, now.month, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? latestAllowedDate,
      firstDate: DateTime(1950),
      lastDate: latestAllowedDate,
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _birthdayController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _validateGoogleProfileImage() async {
    try {
      // Automatically start scanning the Google profile image
      _useGoogleImage();
    } catch (e) {
      print('Error validating Google profile image: $e');
    }
  }

  void _useGoogleImage() {
    // Download and validate Google image using FaceDetectionScanner
    _downloadAndValidateGoogleImage();
  }

  Future<void> _downloadAndValidateGoogleImage() async {
    try {
      // Download Google profile image to temporary file
      final tempFile = await _downloadGoogleImage();
      
      if (tempFile == null) {
        _handleInvalidGoogleImage();
        return;
      }

      // Create CroppedFile from downloaded image
      final CroppedFile googleImageFile = CroppedFile(tempFile.path);

      // Show face detection scanner
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Validating Google Profile Image',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).extension<CustomColors>()!.xTextColorSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: FaceDetectionScanner(
                    croppedFile: googleImageFile,
                    onFaceDetected: (hasFace) {
                      Navigator.pop(context);
                      if (hasFace) {
                        // Face detected - accept Google image
                        setState(() {
                          _isImage = true;
                        });
                        Mixin.showToast(context, 'Google profile image validated successfully!', INFO);
                        
                        // After successful image validation, automatically check other fields and proceed
                        Future.delayed(Duration(milliseconds: 500), () {
                          _validateAndSubmit(fromImageValidation: true);
                        });
                      } else {
                        // No face detected - show error
                        _handleInvalidGoogleImage();
                      }
                    },
                    scanColor: Theme.of(context).extension<CustomColors>()!.xTrailing,
                    showDetectionDetails: true,
                    height: Mixin.isTab(context) ? 500 : 400,
                  ),
                ),
              ],
            ),
          );
        },
      );

    } catch (e) {
      print('Error downloading/validating Google image: $e');
      _handleInvalidGoogleImage();
    }
  }

  Future<File?> _downloadGoogleImage() async {
    try {
      final String imageUrl = Mixin.user!.usrImage!;
      
      // Show downloading progress
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).extension<CustomColors>()!.xSecondaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).extension<CustomColors>()!.xTrailing,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Downloading Profile Image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).extension<CustomColors>()!.xTextColorSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Download the image from URL
      final response = await http.get(Uri.parse(imageUrl));
      Navigator.pop(context); // Close download dialog

      if (response.statusCode == 200) {
        // Save to temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/google_profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await tempFile.writeAsBytes(response.bodyBytes);
        return tempFile;
      } else {
        return null;
      }
    } catch (e) {
      Navigator.pop(context); // Close download dialog if open
      print('Error downloading Google image: $e');
      return null;
    }
  }

  void _handleInvalidGoogleImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).extension<CustomColors>()!.xSecondaryColor,
          title: Text(
            'No Face Detected',
            style: TextStyle(
              color: Theme.of(context).extension<CustomColors>()!.xTrailing,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'We couldn\'t detect a clear face in your Google profile image. Please upload a new photo with a clear face.',
            style: TextStyle(
              color: Theme.of(context).extension<CustomColors>()!.xTextColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _skipGoogleImageValidation();
              },
              child: Text(
                'Upload new photo',
                style: TextStyle(
                  color: Theme.of(context).extension<CustomColors>()!.xTrailing,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _skipGoogleImageValidation() async {
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

  Future<void> _validateAndSubmit({bool fromImageValidation = false}) async {
    // If called from image validation, skip image checks
    if (!fromImageValidation) {
      // Validate profile image exists
      if(Mixin.user?.usrImage == null && !_isImage){
        Mixin.showToast(context, "Profile picture is required", ERROR);
        return;
      }

      // Validate image has been processed/validated (face detected)
      if(!_isImage && Mixin.user?.usrType == 'GOOGLE'){
        Mixin.showToast(context, "Please wait for profile image validation to complete", ERROR);
        return;
      }
    }

    // Validate bio field
    if(_bioController.text.isEmpty){
      Mixin.showToast(context, "Please write something about you", ERROR);
      return;
    }

    // Validate gender selection
    if(_girl == false && _boy == false){
      Mixin.showToast(context, "Kindly select your gender", ERROR);
      return;
    }

    // Validate interest selection
    if(_girlInt == false && _boyInt == false){
      Mixin.showToast(context, "Kindly select who you're looking for", ERROR);
      return;
    }

    // Validate date of birth
    if(_birthdayController.text.isEmpty || selectedDate == null){
      Mixin.showToast(context, "Date of birth is required", ERROR);
      return;
    }

    // Check if user is at least 18 years old
    if (selectedDate != null) {
      final DateTime now = DateTime.now();
      final DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
      if (selectedDate!.isAfter(eighteenYearsAgo)) {
        Mixin.showToast(context, "You must be at least 18 years old to use this app!", ERROR);
        return;
      }
    }

    // All validations passed, proceed with submission
    _submitUserData();
  }

  Future<void> _submitUserData() async {
    // Update user data
    Mixin.user?.usrDesc = _bioController.text;
    Mixin.user?.usrGender = _girl ? 'FEMALE' : 'MALE';
    Mixin.user?.usrOsType = _girlInt ? 'FEMALE' : 'MALE';
    Mixin.user?.usrDob = DateFormat('yyyy-MM-dd').format(selectedDate!);

    setState(() {
      _isLoading = true;
    });

    IPost.postData(Mixin.user, (state, res, value) async {
      setState(() {
        if (state) {
          Mixin.showToast(context, res, INFO);
          Mixin.prefString(pref:jsonEncode(Mixin.user), key: CURR);
          
          // Add 2 second delay before navigation
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) {
              Mixin.pop(context, const IHome());
            }
          });
        } else {
          Mixin.errorDialog(context, 'ERROR', res);
        }
        _isLoading = false;
      });
    }, IUrls.UPDATE_USER());
  }

  Widget _buildAnimatedParticles() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(_particleAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildTypewriterText(String text, TextStyle style, {Duration delay = Duration.zero}) {
    return AnimatedBuilder(
      animation: _headerAnimationController,
      builder: (context, child) {
        final progress = _headerAnimationController.value;
        final visibleCharacters = (text.length * progress).round();
        final visibleText = text.substring(0, visibleCharacters);
        
        return Text(
          visibleText,
          style: style,
          textAlign: TextAlign.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    _girl = Mixin.user?.usrGender == 'FEMALE';
    _boy = Mixin.user?.usrGender == 'MALE';
    _boyInt = Mixin.user?.usrOsType == 'MALE';
    _girlInt = Mixin.user?.usrOsType == 'FEMALE';
    _bioController.text = Mixin.user?.usrDesc ?? '';

    // Update selection animations
    if (_girl) _girlSelectionController.forward(); else _girlSelectionController.reverse();
    if (_boy) _boySelectionController.forward(); else _boySelectionController.reverse();
    if (_girlInt) _girlIntSelectionController.forward(); else _girlIntSelectionController.reverse();
    if (_boyInt) _boyIntSelectionController.forward(); else _boyIntSelectionController.reverse();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: AnimatedGradientBackground(
          animation: _particleAnimation,
          child: Stack(
            children: [
              // Particle background
              Positioned.fill(child: _buildAnimatedParticles()),
              
              // Main content
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    right: 24.w,
                    left: 24.w,
                    bottom: 34.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                // Animated Header
                SlideTransition(
                  position: _headerSlideAnimation,
                  child: FadeTransition(
                    opacity: _headerFadeAnimation,
                    child: Column(
                      children: [
                        _buildTypewriterText(
                          "Please fill below ",
                          TextStyle(
                            color: color.xTextColorSecondary,
                            fontWeight: FontWeight.normal,
                            fontSize: FONT_APP_BAR,
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _headerAnimationController,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  color.xTrailing,
                                  color.xTrailing.withOpacity(0.7),
                                  color.xTrailing,
                                ],
                                stops: [
                                  0.0,
                                  0.5 + math.sin(_headerAnimationController.value * 4 * math.pi) * 0.3,
                                  1.0,
                                ],
                              ).createShader(bounds),
                              child: Text(
                                "information",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FONT_APP_BAR,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                        _buildTypewriterText(
                          "\nTo get started.",
                          TextStyle(
                            color: color.xTextColorSecondary,
                            fontWeight: FontWeight.normal,
                            fontSize: FONT_APP_BAR,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Mixin.isTab(context) ? 20.h : 40.h),
                // Animated Profile Image Container
                ScaleTransition(
                  scale: _imageScaleAnimation,
                  child: AnimatedBuilder(
                    animation: _imagePulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: !_isImage && Mixin.user?.usrImage == null ? _imagePulseAnimation.value : 1.0,
                        child: Container(
                          height: MediaQuery.of(context).size.width/3,
                          width: MediaQuery.of(context).size.width/2,
                          decoration: BoxDecoration(
                            color: color.xSecondaryColor,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: color.xTrailing.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () async {
                                // Add haptic feedback
                                HapticFeedback.lightImpact();
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
                    child: _isImage && _croppedFile?.path != null ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(_croppedFile!.path),
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
                        : AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Icon(
                              Icons.person, 
                              size: 100.h, 
                              color: color.xTrailing.withOpacity(0.5),
                              key: ValueKey('person_icon'),
                            ),
                          ),
                            ),
                          ),
                        ),
                      );
                    },
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
                            width: Mixin.isTab(context) ? 80.h : 100.h,
                            height: Mixin.isTab(context) ? 80.h : 100.h,
                            child: Icon(
                              Icons.girl,
                              color: Colors.pink,
                              size: Mixin.isTab(context) ? 50 : 70,
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

                          log('${Mixin.user}');
                        });
                      },
                    ),
                    SizedBox(
                      width: Mixin.isTab(context) ? 20 : 10,
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
                            width: Mixin.isTab(context) ? 80.h : 100.h,
                            height: Mixin.isTab(context) ? 80.h : 100.h,
                            child: Icon(
                              Icons.boy,
                              color: Colors.blue,
                              size: Mixin.isTab(context) ? 50 : 70,
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
                            width: Mixin.isTab(context) ? 80.h : 100.h,
                            height: Mixin.isTab(context) ? 80.h : 100.h,
                            child: Icon(
                              Icons.girl,
                              color: Colors.pink,
                              size: Mixin.isTab(context) ? 50 : 70,
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
                      width: Mixin.isTab(context) ? 20 : 10,
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
                            width: Mixin.isTab(context) ? 80.h : 100.h,
                            height: Mixin.isTab(context) ? 80.h : 100.h,
                            child: Icon(
                              Icons.boy,
                              color: Colors.blue,
                              size: Mixin.isTab(context) ? 50 : 70,
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
                
                SizedBox(height: 34.h),
                TextFormField(
                  controller: _birthdayController,
                  readOnly: true,
                  style: TextStyle(
                    fontSize: Mixin.isTab(context) ? FONT_13 * 1.2 : FONT_13,
                    color: color.xTextColorSecondary
                  ),
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.xTrailing),
                    ),
                    border: InputBorder.none,
                    labelText: 'Date of Birth',
                    labelStyle: TextStyle(
                      color: color.xTextColor,
                      fontSize: Mixin.isTab(context) ? FONT_13 * 1.2 : FONT_13,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: color.xTrailing),
                    ),
                    hintText: 'Select your birthday (18+ required)',
                    hintStyle: TextStyle(
                      color: color.xTextColor,
                      fontSize: Mixin.isTab(context) ? FONT_13 * 1.2 : FONT_13,
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: color.xTrailing,
                      size: Mixin.isTab(context) ? 24 : 20
                    ),
                    fillColor: color.xSecondaryColor,
                    filled: true,
                  ),
                ),
                SizedBox(height: 34.h),
                TextFormField(
                  controller: _bioController,
                  keyboardType: TextInputType.text,
                  maxLines: Mixin.isTab(context) ? 4 : 6,
                  style: TextStyle(
                    fontSize: Mixin.isTab(context) ? FONT_13 * 1.2 : FONT_13,
                    color: color.xTextColorSecondary
                  ),
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color.xTrailing),
                      ),
                      hintText: 'About me',
                      labelText: 'About me',
                      labelStyle: TextStyle(
                        color: color.xTextColor,
                        fontSize: Mixin.isTab(context) ? FONT_13 * 1.2 : FONT_13,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color.xTrailing),
                      ),
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                        color: color.xTextColor,
                        fontSize: Mixin.isTab(context) ? FONT_13 * 1.2 : FONT_13,
                      ),
                      suffixIcon: Icon(
                        Icons.star,
                        color: color.xTrailing,
                        size: 1,
                      ),
                      fillColor: color.xSecondaryColor,
                      filled: true
                  ),
                  onChanged: (value) {
                    Mixin.user?.usrDesc = _bioController.text;
                  },
                ),
                SizedBox(height: Mixin.isTab(context) ? 30.h : 20.h),
                _isLoading ?  Center(child: Loading(dotColor:  color.xTrailing)) :
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(Mixin.isTab(context) ? 16.0 : 8.0),
                    child: IButton(
                      color:  color.xTrailing,
                      onPress: () {
                        _validateAndSubmit();
                      },
                      isBlack: true,
                      text: "Get Started",
                      width: Mixin.isTab(context) ? 200.h : 150.h,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )])));
  }

  void _postImage(){
    setState(() {
      _isLoading = true;
    });
    
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

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
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
              scanColor: Theme.of(context).extension<CustomColors>()!.xTrailing,
              showDetectionDetails: true,
              height: Mixin.isTab(context) ? 500 : 400,
            ),
          );
        },
      );
    }
  }
}
