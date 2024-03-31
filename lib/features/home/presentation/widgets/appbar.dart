import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/model/page_arguments_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../core/utils/debug_utils.dart';
import '../../../../route_name.dart';

// ignore: must_be_immutable
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  HomeAppBar({
    required this.height,
    this.onPressed,
    Key? key,
    required this.title,
    this.leading,
    required this.dollarBuyingRate,
    required this.dollarSellingRate,
  }) : super(key: key);

  final Widget? leading;
  final double height;
  void Function()? onPressed;
  final String title;
  final double dollarBuyingRate;

  final double dollarSellingRate;

  @override
  Size get preferredSize => Size.fromHeight(height);

  // final sellRef = FirebaseDatabase.instance.ref('dollarRate/dollarSellingRate');

  // final buyRef = FirebaseDatabase.instance.ref('dollarRate/dollarBuyingRate');

  // double? dollarBuyingRate;

  // double? dollarSellingRate;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _appbar(context);
  }

  Widget _appbar(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        // Color(0XFF0D372B),
        // Color(0XFF196E55),
        AppColors.googleBlue,
        Color.fromARGB(255, 121, 170, 245),
      ])),
      child: Center(
        child: Column(
          children: [
            AppBar(
              // foregroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(title,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: leading ??
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dollarRate(
                  type: "Buying at ",
                  rate: dollarBuyingRate,
                  color: Color.fromARGB(255, 7, 231, 22),
                ),
                dollarRate(
                  type: "Selling at ",
                  rate: dollarSellingRate,
                  color: AppColors.colorDD0000,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget dollarRate(
      {required String type, required double rate, required Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(
            type,
            textScaleFactor: 1.0,
            style: TextStyle(
                color: AppColors.white,
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.ROBOTO),
          ),
          Text(
            rate.toString(),
            textScaleFactor: 1.0,
            style: TextStyle(
                color: color,
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.ROBOTO),
          ),
          Text(
            " Tk",
            textScaleFactor: 1.0,
            style: TextStyle(
                color: AppColors.white,
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.ROBOTO),
          ),
        ],
      ),
    );
  }
}
