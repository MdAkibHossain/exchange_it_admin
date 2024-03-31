import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/common/common_app_bar.dart';
import '../../../../core/common/custom_text_form_field.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/model/page_arguments_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../core/utils/debug_utils.dart';
import '../../../../route_name.dart';
import '../../../home/data/post_model.dart';
import '../../../home/presentation/widgets/appbar.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key, required this.arguments});
  final PageRouteArguments arguments;

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    totalBdt = widget.arguments.datas![0];
    totalUsd = widget.arguments.datas![1];
    totalForCalculateBdt = widget.arguments.datas![2];
    totalForCalculateUsd = widget.arguments.datas![3];

    // dollarBuyingRateController =
    //     TextEditingController(text: widget.arguments.datas![0].toString());
    // dollarSellingRateController =
    //     TextEditingController(text: widget.arguments.datas![1].toString());
  }

  double? totalBdt;
  double? totalUsd;
  double? totalForCalculateBdt;
  double? totalForCalculateUsd;
  TextEditingController? percentage = TextEditingController(text: '');
  bool invalid = false;
  final dollarRateRef = FirebaseDatabase.instance.ref('dollarRate');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarWithNotification(title: APP_TITLE, height: 15.0.h),
      body: SingleChildScrollView(
        child: Column(
          children: [
            topsection("Total Exchange"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    defaultText("Dollar: "),
                    defaultBoldText(totalUsd!.toStringAsFixed(2)),
                    defaultText(" usd"),
                  ],
                ),
                Row(
                  children: [
                    defaultText("BDT: "),
                    defaultBoldText(totalBdt!.toStringAsFixed(2)),
                    defaultText(" Tk"),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
              child: Divider(
                thickness: 0.3.w,
              ),
            ),
            SizedBox(height: 3.0.h),
            topsection("Calculate Revenue"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    defaultText("Dollar: "),
                    defaultBoldText(totalForCalculateUsd!.toStringAsFixed(2)),
                    defaultText(" usd"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    defaultText("BDT: "),
                    defaultBoldText(totalForCalculateBdt!.toStringAsFixed(2)),
                    defaultText(" Tk"),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
              child: Divider(
                thickness: 0.3.w,
              ),
            ),
            SizedBox(height: 1.0.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                defaultText("Total to Clear: "),
                defaultBoldText((totalForCalculateUsd! + totalForCalculateBdt!)
                    .toStringAsFixed(2)),
                defaultText(" Tk"),
              ],
            ),
            //  SizedBox(height: 2.5.h),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     defaultText("Available for Clear: "),
            //     defaultBoldText(
            //         ((totalForCalculateUsd! * 2) * .4).toStringAsFixed(2)),
            //     defaultText(" Tk"),
            //     defaultText(" & "),
            //     defaultBoldText(
            //         ((totalForCalculateUsd! * 2) * .6).toStringAsFixed(2)),
            //     defaultText(" Tk"),
            //   ],
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 4.0.w, top: 3.0.h),
            //   child: defaultText("Enter clear %"),
            // ),
            //  textField(percentage!),
            SizedBox(height: 6.0.h),
            processExchangeButton()
          ],
        ),
      ),
    );
  }

  Widget topsection(String title) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 4.0.w, top: 1.0.h),
          //  alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: AppColors.color2C2D30,
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ],
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
          "Confirm Clear",
          textScaleFactor: 1.0,
          style: TextStyle(
              color: AppColors.white,
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.ROBOTO),
        ),
      ),
      onPressed: () {
        if (percentage!.text.isNotEmpty &&
            double.parse(percentage!.text) <= 100 &&
            double.parse(percentage!.text) > 0) {
          setState(() {
            invalid = false;
          });
          var ii = ((totalForCalculateUsd! * 2) * .4);
          var ee = (ii * double.parse(percentage!.text) / 100);
          logView(ee.toString());
          // setState(() {
          //   invalid = false;
          //   dollarRateRef.update({
          //     'dollarBuyingRate':
          //         double.parse(dollarBuyingRateController!.text),
          //     'dollarSellingRate':
          //         double.parse(dollarSellingRateController!.text)
          //   }).then((value) {
          //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //       content: Text("Dollar rate update successfull!"),
          //       duration: Duration(seconds: 2),
          //       backgroundColor: AppColors.confirm,
          //     ));
          //   });
          // });
        } else {
          setState(() {
            invalid = true;
          });
        }
      },
    );
  }

  Widget defaultText(String text) {
    return Container(
      //   margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textScaleFactor: 1.0,
        style: TextStyle(
            color: AppColors.color2C2D30,
            fontSize: 13.0.sp,
            //  fontWeight: FontWeight.w500,
            fontFamily: AppFonts.ROBOTO),
      ),
    );
  }

  Widget defaultBoldText(String text) {
    return Container(
      //   margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textScaleFactor: 1.0,
        style: TextStyle(
            color: AppColors.color2C2D30,
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.POPPINS),
      ),
    );
  }

  Widget textField(TextEditingController controller) {
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
        textInputType: TextInputType.number,
      ),
    );
  }
}
