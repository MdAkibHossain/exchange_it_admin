import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/common/custom_text_form_field.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';

class Add_Bkash_widget extends StatefulWidget {
  const Add_Bkash_widget({super.key});

  @override
  State<Add_Bkash_widget> createState() => _Add_Bkash_widgetState();
}

class _Add_Bkash_widgetState extends State<Add_Bkash_widget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // dollarBuyingRateController =
    //     TextEditingController(text: widget.arguments.datas![0].toString());
    // dollarSellingRateController =
    //     TextEditingController(text: widget.arguments.datas![1].toString());
    accountNameController = TextEditingController(text: "");
    accountNumberController = TextEditingController(text: "");
  }

  TextEditingController? accountNameController;
  TextEditingController? accountNumberController;
  bool invalid = false;
  final bkashRef = FirebaseDatabase.instance.ref('/accounts/bkash');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topsection(),
        defaultText("Bkash Account Name."),
        textField(accountNameController!, TextInputType.name),
        defaultText("Bkash Account Number."),
        textField(accountNumberController!, TextInputType.number),
        SizedBox(height: 3.0.h),
        processExchangeButton(),
        SizedBox(height: 2.0.h),
      ],
    );
  }

  Widget processExchangeButton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.googleBlue),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      icon: Container(
        margin: EdgeInsets.only(left: 5.0.w),
        child: const Icon(Icons.currency_exchange),
      ),
      label: Container(
        margin: EdgeInsets.only(right: 5.0.w, top: 1.5.h, bottom: 1.5.h),
        child: Text(
          "Update Now",
          textScaleFactor: 1.0,
          style: TextStyle(
              color: AppColors.white,
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.ROBOTO),
        ),
      ),
      onPressed: () {
        String id = DateTime.now().millisecondsSinceEpoch.toString();
        if (accountNameController!.text.isNotEmpty &&
            accountNumberController!.text.isNotEmpty) {
          setState(() {
            invalid = false;
            bkashRef.child(id).set({
              'id': id,
              'accountName': accountNameController!.text,
              'accountNumber': accountNumberController!.text,
              'createdAt': DateTime.now().toIso8601String(),
              'isActive': false,
              // 'history': [
              //   {
              //     'amount': 0,
              //     'dateTime': DateTime.now().toIso8601String(),
              //   }
              // ],
            }).then((value) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Account update successful!"),
                duration: Duration(seconds: 2),
                backgroundColor: AppColors.confirm,
              ));
            });
          });
        } else {
          setState(() {
            invalid = true;
          });
        }
      },
    );
  }

  Widget textField(TextEditingController controller, TextInputType inputType) {
    return Container(
      height: 6.0.h,
      margin: EdgeInsets.only(left: 4.0.w, right: 4.0.w),
      padding: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
      decoration: BoxDecoration(
        border: Border.all(
            color: invalid
                ? AppColors.red
                : const Color.fromARGB(255, 120, 117, 117),
            width: 1.0),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: custom_text_form_field(
        controller: controller,
        textInputType: inputType,
      ),
    );
  }

  Widget defaultText(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textScaleFactor: 1.0,
        style: TextStyle(
            color: AppColors.color2C2D30,
            fontSize: 11.0.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.ROBOTO),
      ),
    );
  }

  Widget topsection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
          alignment: Alignment.centerLeft,
          child: Text(
            "Add Bkash Personal Account.",
            textScaleFactor: 1.0,
            style: TextStyle(
                color: AppColors.color2C2D30,
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.ROBOTO),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w),
          child: Divider(
            thickness: 0.3.w,
          ),
        ),
      ],
    );
  }
}
