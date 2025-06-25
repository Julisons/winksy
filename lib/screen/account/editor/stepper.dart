import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/screen/authenticate/select/bio.dart';

import '../../../component/app_bar.dart';
import '../../../component/button.dart';
import '../../../mixin/mixins.dart';
import '../../../request/posts.dart';
import '../../../request/urls.dart';
import '../../../theme/custom_colors.dart';
import 'account.dart';
import 'alignment.dart';


class IStepper extends StatefulWidget {
  const IStepper({super.key});

  @override
  State<IStepper> createState() => _IStepperState();
}


class _IStepperState extends State<IStepper> {
  int _index = 0;

  @override
  void initState() {
    super.initState();

    Mixin.getUser().then((value) => {
      if(value != null){
        Mixin.user = value,
      }});
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: IAppBar(title: 'Edit account', leading: true,),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stepper(
                elevation: ELEVATION,
                currentStep: _index,
                onStepCancel: () {
                  if (_index > 0) {
                    setState(() {
                      _index -= 1;
                    });
                  }
                },
                onStepContinue: () {
                  if (_index < 1) {
                    setState(() {
                      _index += 1;
                    });
                    IPost.postData(Mixin.user, (state, res, value) {
                      setState(() {
                        if (state) {
                          Mixin.showToast(context, res, INFO);
                          Mixin.prefString(pref:jsonEncode(value), key: CURR);
                        } else {
                          Mixin.errorDialog(context, 'ERROR', res);
                        }
                      });
                    }, IUrls.UPDATE_USER());
                  }
                },
                onStepTapped: (int index) {
                  setState(() {
                    _index = index;
                  });
                },
                steps: <Step>[
                  Step(
                    title: Text('Bio Information',style: TextStyle(fontSize: FONT_TITLE,color: color.xTextColorSecondary, fontWeight: FontWeight.bold)),
                    subtitle: Text('Add personal touch to your profile.',
                      style: TextStyle(
                        fontSize: FONT_13,
                        color: color.xTextColorSecondary,
                      ),
                    ),
                    stepStyle: StepStyle(
                      color: color.xPrimaryColor,
                      errorColor: Colors.red,
                      connectorColor: color.xTrailing,
                      connectorThickness: 2.0,
                      border: Border.all(color: color.xTrailingAlt),
                      boxShadow: BoxShadow(
                        color:color.xTrailingAlt,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                      gradient: LinearGradient(
                        colors: [color.xTrailingAlt, color.xTrailingAlt],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      indexStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: FONT_13
                      ),
                  ),
                    content: IAccount(),
                  ),
                  Step(
                    title: Text('Interest alignment',style: TextStyle(fontSize: FONT_TITLE,color: color.xTextColorSecondary, fontWeight: FontWeight.bold)),
                    subtitle: Text('Interest alignment information to your profile.',
                      style: TextStyle(
                        fontSize: FONT_13,
                        color: color.xTextColorSecondary,
                      ),
                    ),
                    stepStyle: StepStyle(
                      color: color.xPrimaryColor,
                      errorColor: Colors.red,
                      connectorColor: color.xTrailing,
                      connectorThickness: 2.0,
                      border: Border.all(color: color.xTrailingAlt),
                      boxShadow: BoxShadow(
                        color:color.xTrailingAlt,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                      gradient: LinearGradient(
                        colors: [color.xTrailingAlt, color.xTrailingAlt],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      indexStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: FONT_13
                      ),
                    ),
                    content: IAlignment(),
                  ),
                ],
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IButton(
                        onPress: details.onStepCancel,
                        text: 'Cancel',
                        textColor: Colors.white,
                        color: color.xSecondaryColor,
                        width: MediaQuery.of(context).size.width/3.5,
                      ),
                      const SizedBox(width: 10),
                      IButton(
                        onPress: details.onStepContinue,
                        text: 'Continue',
                        textColor: Colors.white,
                        color: color.xTrailing,
                        width: MediaQuery.of(context).size.width/3.5,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
    );
  }
}