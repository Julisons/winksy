import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/model/gift.dart';
import 'package:winksy/model/treat.dart';
import 'package:confetti/confetti.dart';
import '../../../../component/google.dart';
import '../../../../component/mpesa_pay.dart';
import '../../../../component/payment_configurations.dart';
import '../../../../mixin/mixins.dart';
import '../../../../provider/gift/gift_provider.dart';
import '../../../../request/posts.dart';
import '../../../../request/urls.dart';
import '../../../../theme/custom_colors.dart';

class ITreatCard extends StatefulWidget {
  final Treat treat;

  const ITreatCard({
    super.key, required this.treat,
  });

  @override
  State<ITreatCard> createState() => _ITreatCardState();
}

class _ITreatCardState extends State<ITreatCard> {
  bool _isLoading = false;
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return InkWell(
      child: Card(
        elevation: 4,
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
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                  true, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  createParticlePath: drawStar, // define a custom shape/path.
                  child: CachedNetworkImage(
                    imageUrl: widget.treat.giftPath.startsWith('http')
                        ? widget.treat.giftPath
                        : '${IUrls.IMAGE_URL}/file/secured/${widget.treat.giftPath}',
                    fit: BoxFit.contain,
                    width: 60.r,
                    height: 60.r,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Text(
                widget.treat.giftDesc,
                style: TextStyle(fontSize: FONT_13, fontWeight: FontWeight.bold, color: color.xTextColor,),
              ),
              RichText(
                text: TextSpan(
                  style:  TextStyle( color: color.xTextColorSecondary, fontSize: FONT_13, fontWeight: FontWeight.bold,),
                  children: [
                    TextSpan(
                      text: dollar(widget.treat.giftAmount).toString(),
                    ),
                    TextSpan(
                      text: '',
                      style:  TextStyle(color: color.xTrailingAlt, fontSize: FONT_13), // Blue color for Wnks
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Gift gift = Gift()
        ..ugiftUsrId = Mixin.winkser?.usrId
        ..ugiftGiftId = widget.treat.giftId
        ..ugiftGifterId = Mixin.user?.usrId;
        
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {

            return Container(
              padding: EdgeInsets.all(26.r),
                height: MediaQuery.of(context).size.height/1.2,
                width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.treat.giftPath.startsWith('http')
                        ? widget.treat.giftPath
                        : '${IUrls.IMAGE_URL}/file/secured/${widget.treat.giftPath}',
                    fit: BoxFit.contain,
                    width: 160.r,
                    height: 160.r,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.treat.giftDesc,
                    style: TextStyle(fontSize: FONT_13, fontWeight: FontWeight.bold, color: color.xTextColor,),
                  ),
                  RichText(
                    text: TextSpan(
                      style:  TextStyle( color: color.xTextColorSecondary, fontSize: FONT_13, fontWeight: FontWeight.bold,),
                      children: [
                        TextSpan(
                          text: dollar(widget.treat.giftAmount),
                        ),
                        TextSpan(
                          text: '',
                          style:  TextStyle(color: color.xTrailingAlt, fontSize: FONT_13), // Blue color for Wnks
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 44.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GooglePayButton(
                        paymentConfiguration: defaultGooglePayConfig,
                        paymentItems: [
                          PaymentItem(
                            label: 'Total',
                            amount: widget.treat.giftAmount.toString(),
                            status: PaymentItemStatus.final_price,
                          )
                        ],
                        type: GooglePayButtonType.buy,
                        margin: const EdgeInsets.only(top: 15.0),
                        onPaymentResult: onGooglePayResult,
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      IMpesaPay(onPress: (){

                      }, width: MediaQuery.of(context).size.width/2.4,textColor: color.xTextColor,
                        color: color.xSecondaryColor,isBlack: false,),
                    ],
                  )
                ],
              )
            );
          },
        );


        /*setState(() {
          _isLoading = false;
        });

        IPost.postData(gift, (state, res, value) {
          setState(() {
           // Mixin.playerSound.play(AssetSource('sound/clapping.wav')); // Your sound file
            Mixin.playerSound.play(AssetSource('sound/thank_you.wav')); // Your sound file
            _isLoading = false;
              _controllerCenter.play();
              Provider.of<IGiftProvider>(context, listen: false).refresh('', false);
            if (state) {
              Mixin.showToast(context, res, INFO);
            } else {
              Mixin.errorDialog(context, 'ERROR', res);
            }
          });
        }, IUrls.GIFT());*/
      },
    );
  }

  void onGooglePayResult(paymentResult) {
    // Send the resulting Google Pay token to your server / PSP
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}


String dollar(num amount) {
  final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$ ');
  return formatter.format(amount);
}
