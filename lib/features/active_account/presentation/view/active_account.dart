import 'package:exchange_it_admin/core/utils/debug_utils.dart';
import 'package:exchange_it_admin/features/active_account/presentation/widgets/add_bkash.dart';
import 'package:exchange_it_admin/features/active_account/presentation/widgets/add_nagad.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/common/common_app_bar.dart';
import '../../../../core/common/custom_text_form_field.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../widgets/bkas_list.dart';
import '../widgets/bkash_card_list.dart';
import '../widgets/nagad_card_list.dart';

class ActiveAccount extends StatefulWidget {
  const ActiveAccount({
    super.key,
    // required this.arguments
  });
  //final PageRouteArguments arguments;

  @override
  State<ActiveAccount> createState() => _ActiveAccountState();
}

class _ActiveAccountState extends State<ActiveAccount> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // dollarBuyingRateController =
    //     TextEditingController(text: widget.arguments.datas![0].toString());
    // dollarSellingRateController =
    //     TextEditingController(text: widget.arguments.datas![1].toString());
  }

  Future _showSheet() {
    return showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
          cornerRadius: 22,
          snapSpec: const SnapSpec(
            snappings: [.4, .7],
          ),
          builder: buildSheet);
    });
  }

  Widget buildSheet(context, state) {
    return isNew
        ? Material(child: Add_Bkash_widget())
        : Material(child: Add_Nagad_Widget());
  }

  bool isNew = true;

  final nagadRef = FirebaseDatabase.instance.ref('/accounts/nagad');

  @override
  Widget build(BuildContext context) {
    logView(isNew.toString());
    return Scaffold(
      appBar: CommonAppBarWithNotification(title: APP_TITLE, height: 15.0.h),
      bottomSheet: _addAccountButton(),
      body: Column(
        children: [
          // defaultText("Account Name."),
          selectionSection(),
          isNew
              ? BkashList()
              : SizedBox(
                  height: 72.0.h,
                  child: FirebaseAnimatedList(
                    query: nagadRef,
                    reverse: false,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      return Column(
                        children: [
                          Nagad_Card_List_Widget(
                            name:
                                snapshot.child("accountName").value.toString(),
                            number: snapshot
                                .child("accountNumber")
                                .value
                                .toString(),
                            id: snapshot.child("id").value.toString(),
                            isactive: snapshot.child("isActive").value as bool,
                            total: snapshot.child("total").value.toString(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
          SizedBox(height: 0.0.h),
        ],
      ),
    );
  }

  Widget selectionSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MaterialButton(
            minWidth: 25.w,
            color: isNew ? Color(0XFF37BE71) : AppColors.white,
            onPressed: () {
              setState(() {
                isNew = true;
              });
            },
            child: Text(
              "Bkash",
              style: TextStyle(
                  fontSize: 14, color: isNew ? AppColors.white : Colors.black),
            ),
          ),
          MaterialButton(
            minWidth: 25.w,
            color: isNew ? AppColors.white : Color(0XFF37BE71),
            onPressed: () {
              setState(() {
                isNew = false;
              });
            },
            child: Text(
              "Nagad",
              style: TextStyle(
                  fontSize: 14, color: isNew ? Colors.black : AppColors.white),
            ),
          )
        ],
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

  Widget _addAccountButton() {
    return GestureDetector(
      onVerticalDragStart: (details) {
        _showSheet();
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 1.0.h, left: 4.0.w, right: 4.0.w),
        height: 8.0.h,
        child: Column(
          children: [
            Container(
              width: 12.0.w,
              height: 0.3.h,
              margin: EdgeInsets.all(0.5.h),
              decoration: const BoxDecoration(
                  color: AppColors.appBackground,
                  borderRadius: BorderRadius.all(Radius.circular(1))),
            ),
            SizedBox(height: 0.1.h),
            Container(
              height: 5.4.h,
              decoration: const BoxDecoration(
                  color: AppColors.googleBlue,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: AppColors.white,
                  ),
                  SizedBox(width: 2.0.w),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Add Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.ROBOTO),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
