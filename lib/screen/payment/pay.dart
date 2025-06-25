import 'dart:developer';

import 'package:winksy/mixin/constants.dart';
import 'package:winksy/mixin/mixins.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../component/button.dart';
import '../../../request/posts.dart';
import '../../../request/urls.dart';
import '../../component/loader.dart';
import '../../component/popup.dart';

class IPay extends StatefulWidget {
  const IPay({super.key});

  @override
  State<IPay> createState() => _IPayState();
}

class _IPayState extends State<IPay> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _phoneController.text = Mixin.user?.usrMobileNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: Text("Payment", style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: FONT_APP_BAR),),
          actions: <Widget>[
            IPopup()
          ]),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.all(16.h),
        child: Center(
          child: InkWell(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(16.h),
                height: 450.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0.h),
                      child: Container(color: mpesa),
                    ),
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Image.asset(
                        'assets/images/mpesa.png',
                        width: 100,
                        height: 40,
                        fit: BoxFit.cover, // Adjust the image's scaling
                      ),
                    ),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text('Monthly',
                            style: TextStyle(
                                color: greenLand,
                                fontSize: FONT_APP_BAR,
                                fontWeight:
                                FontWeight.bold)),
                        Text('20. kshs',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: FONT_APP_BAR,
                                fontWeight:
                                FontWeight.normal)),
                      ],
                    ),
                    Positioned(
                      bottom: 60,
                      width: MediaQuery.of(context).size.width-60.h,
                      height: 100.h,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: FONT_13, color: Theme.of(context).colorScheme.tertiary),
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                            ),
                            labelText: 'Mpesa Phone number',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: FONT_13,
                            ),
                            border: InputBorder.none,
                            hintText: 'Phone number',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: FONT_13,
                            ),
                            fillColor: Theme.of(context).colorScheme.secondary,
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                    _isLoading ? Positioned(
                      bottom: 16,
                      width: 50,
                      height: 50,
                            child: Loading(
                              dotColor: Colors.red,
                            ),
                          ) : Positioned(
                      bottom: 10,
                      width: MediaQuery.of(context).size.width-60.h,
                            child:  Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: IButton(
                                color: greenLand,
                                onPress: () {
                                  if (_phoneController.text.isEmpty) {
                                    Mixin.showToast(context,
                                        "Username cannot be empty!", ERROR);
                                    return;
                                  }
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  IPost.getData((state, res, value) {
                                    setState(() {
                                      if (state) {
                                        Mixin.showToast(context, res, INFO);
                                      } else {
                                        Mixin.errorDialog(context, 'ERROR', res);
                                      }
                                      _isLoading = false;
                                    });
                                  }, IUrls.PUSH_STK(_phoneController.text,Mixin.user?.usrMobileNumber, '60'));
                                },
                                isBlack: true,
                                text: "Pay Now",
                                textColor: Colors.white,
                              ),
                            ),
                          )
                  ],
                ),
              ),
              onTap: () {
                //Mixin.navigate(context, IPay());
              },
            ),
            onTap: () {
             // Mixin.navigate(context, IPay());
            },
          ),
        ),
      ),
    );
  }
}
