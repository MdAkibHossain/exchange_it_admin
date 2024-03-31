import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';

class latest_exchanges extends StatefulWidget {
  const latest_exchanges({super.key});

  @override
  State<latest_exchanges> createState() => _latest_exchangesState();
}

class _latest_exchangesState extends State<latest_exchanges> {
  final history = FirebaseDatabase.instance.ref('Orders');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        defaultText(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.5.h),
          child: Divider(
            thickness: 0.3.w,
          ),
        ),
        SizedBox(
          height: 33.0.h,
          child: FirebaseAnimatedList(
            query: history,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return listCard(
                sendItem: snapshot.child("sendItem").value.toString(),
                receivedItem: snapshot.child("receiveItem").value.toString(),
                sendAmount: snapshot.child("sendAmount").value.toString(),
                receivedAmount:
                    snapshot.child("receiveAmount").value.toString(),
                dateTime: snapshot.child("createdAt").value.toString(),
                status: snapshot.child("status").value.toString(),
              );
              // Text(snapshot.child("uid").value.toString());
            },
            // child: ListView.builder(
            //   itemCount: 5,
            //   // shrinkWrap: true,
            //   itemBuilder: (context, index) {},
            // ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
          child: Divider(
            thickness: 0.3.w,
          ),
        ),
      ],
    );
  }

  Widget listCard(
      {required String sendItem,
      required String receivedItem,
      required String sendAmount,
      required String receivedAmount,
      required String dateTime,
      required String status}) {
    return Container(
      margin:
          EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 1.0.h, bottom: 1.0.h),
      padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 4.0.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 120, 117, 117),
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          cardTopItem(sendItem: sendItem, receivedItem: receivedItem),
          SizedBox(height: 1.0.h),
          cardMiddleItem(
              sendAmount: sendAmount, receivedAmount: receivedAmount),
          SizedBox(height: 1.0.h),
          cardBottomItem(dateTime: DateTime.parse(dateTime), status: status),
        ],
      ),
    );
  }

  Widget cardMiddleItem(
      {required String sendAmount, required String receivedAmount}) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.,
      children: [
        Row(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Text(
                "Send Amount: ",
                textScaleFactor: 1.0,
                style: TextStyle(

                    // color: AppColors.secondaryTextColor,
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
            SizedBox(
              child: Text(
                sendAmount,
                textScaleFactor: 1.0,
                style: TextStyle(
                    // color: AppColors.secondaryTextColor,
                    fontSize: 11.0.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.0.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              child: Text(
                "Received Amount: ",
                textScaleFactor: 1.0,
                style: TextStyle(
                    // color: AppColors.secondaryTextColor,
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
            SizedBox(
              child: Text(
                receivedAmount,
                textScaleFactor: 1.0,
                style: TextStyle(
                    // color: AppColors.secondaryTextColor,
                    fontSize: 11.0.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cardBottomItem({required DateTime dateTime, required String status}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  child: Text(
                    "Date: ",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        // color: AppColors.secondaryTextColor,
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.ROBOTO),
                  ),
                ),
                SizedBox(
                  child: Text(
                    DateFormat.yMMMMd('en_US')
                        //('yyyy-MM-dd')
                        //('dd-MM-yyyy')
                        .format(dateTime),
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        // color: AppColors.secondaryTextColor,
                        fontSize: 11.0.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.ROBOTO),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  child: Text(
                    "Time: ",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        // color: AppColors.secondaryTextColor,
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.ROBOTO),
                  ),
                ),
                SizedBox(
                  child: Text(
                    DateFormat.jms()
                        //('dd-MM-yyyy')
                        .format(dateTime),
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        // color: AppColors.secondaryTextColor,
                        fontSize: 11.0.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.ROBOTO),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 1.0.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Text(
                "Status: ",
                textScaleFactor: 1.0,
                style: TextStyle(
                    // color: AppColors.secondaryTextColor,
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1.0.w, vertical: 0.1.h),
              decoration: BoxDecoration(
                  color: AppColors.googleBlue,
                  // AppColors.confirm,
                  borderRadius: BorderRadius.circular(3)),
              child: Row(
                children: [
                  Icon(
                    Icons.timelapse_outlined,
                    color: AppColors.white,
                  ),
                  Text(
                    status,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 11.0.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.POPPINS),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cardTopItem({required String sendItem, required String receivedItem}) {
    return Column(
      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              child: Text(
                "Send: ",
                textScaleFactor: 1.0,
                style: TextStyle(
                    // color: AppColors.secondaryTextColor,
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
            SizedBox(
              child: Text(
                sendItem,
                //     textScaleFactor: 1.0,
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                    // color: AppColors.secondaryTextColor,
                    fontSize: 11.0.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              child: Text(
                "Received: ",
                textScaleFactor: 1.0,
                style: TextStyle(
                    // color: AppColors.secondaryTextColor,
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
            SizedBox(
              child: Text(
                receivedItem,
                //textScaleFactor: 1.0,
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                    // color: AppColors.secondaryTextColor,
                    fontSize: 11.0.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget defaultText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 8.0.h),
      decoration: BoxDecoration(
          border: Border.all(width: 0.7.w, color: AppColors.googleBlue),
          borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        child: Text(
          "Latest Exchanges",
          textScaleFactor: 1.0,
          style: TextStyle(
              color: Color.fromARGB(255, 147, 146, 146),
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w800,
              fontFamily: AppFonts.ROBOTO),
        ),
      ),
    );
  }
}
