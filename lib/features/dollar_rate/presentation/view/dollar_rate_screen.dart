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

class DollarRateScreen extends StatefulWidget {
  const DollarRateScreen({super.key, required this.arguments});
  final PageRouteArguments arguments;

  @override
  State<DollarRateScreen> createState() => _DollarRateScreenState();
}

class _DollarRateScreenState extends State<DollarRateScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    dollarBuyingRateController =
        TextEditingController(text: widget.arguments.datas![0].toString());
    dollarSellingRateController =
        TextEditingController(text: widget.arguments.datas![1].toString());
  }

  TextEditingController? dollarBuyingRateController;
  TextEditingController? dollarSellingRateController;
  bool invalid = false;
  final dollarRateRef = FirebaseDatabase.instance.ref('dollarRate');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarWithNotification(title: APP_TITLE, height: 15.0.h),
      body: Column(
        children: [
          topsection(),
          defaultText("Dollar buying rate."),
          textField(dollarBuyingRateController!),
          defaultText("Dollar selling rate."),
          textField(dollarSellingRateController!),
          SizedBox(height: 6.0.h),
          processExchangeButton()
        ],
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
            "Set Today's Dollar Rate.",
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
          "Update Rate",
          textScaleFactor: 1.0,
          style: TextStyle(
              color: AppColors.white,
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.ROBOTO),
        ),
      ),
      onPressed: () {
        if (dollarBuyingRateController!.text.isNotEmpty &&
            dollarSellingRateController!.text.isNotEmpty) {
          setState(() {
            invalid = false;
            dollarRateRef.update({
              'dollarBuyingRate':
                  double.parse(dollarBuyingRateController!.text),
              'dollarSellingRate':
                  double.parse(dollarSellingRateController!.text)
            }).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Dollar rate update successfull!"),
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
