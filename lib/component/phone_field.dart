import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../mixin/constants.dart';
import '../mixin/mixins.dart';
import '../theme/custom_colors.dart';

class PhoneField extends StatelessWidget {
  PhoneField({Key? key, this.textEditingController, this.onCodeChange})
      : super(key: key);

  TextEditingController? textEditingController;
  Function? onCodeChange;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return SizedBox(
      // width: 100,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CountryCodePicker(
            dialogBackgroundColor: color.xTextColor,
            padding: EdgeInsets.symmetric(
              horizontal: 7.w,
            ),
            textStyle: TextStyle(
              fontSize: FONT_13,
              color: color.xTextColorSecondary,
            ),

            onChanged: (val) {
              if (onCodeChange != null) {
                onCodeChange!(val.dialCode.toString().replaceFirst("+", ''));
              }
            },
            backgroundColor: color.xTextColor,
            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
            initialSelection: 'KE',
            favorite: const ['+254', 'KE'],
            // optional. Shows only country name and flag
            showCountryOnly: false,
            // optional. Shows only country name and flag when popup is closed.
            showOnlyCountryWhenClosed: false,
            // optional. aligns the flag and the Text left
            alignLeft: false,

          ),
          const SizedBox(width: 10,),
          Expanded(
              child: TextFormField(
                style: TextStyle(fontSize: FONT_13,  color: color.xTextColorSecondary),
                controller: textEditingController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: color.xTrailing),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lime),
                  ),
                  labelText: 'Phone number',
                  labelStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  border: InputBorder.none,
                  hintText: 'Phone number',
                  hintStyle: TextStyle(
                    color: color.xTextColor,
                    fontSize: FONT_13,
                  ),
                  fillColor: color.xPrimaryColor,
                  filled: true,
                ),
                onChanged: (value){
                  Mixin.user?.usrEmail = value;
                },
              )),
        ],
      ),
    );
  }
}
