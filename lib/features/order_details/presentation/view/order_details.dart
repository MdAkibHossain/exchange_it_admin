import 'dart:io';

import 'package:exchange_it_admin/core/utils/debug_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/common/common_app_bar.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/model/page_arguments_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../route_name.dart';
import '../../../home/data/post_model.dart';
import '../../../home/presentation/widgets/appbar.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.arguments});
  final PageRouteArguments arguments;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void didChangeDependencies() {
    final sellRef =
        FirebaseDatabase.instance.ref('dollarRate/dollarSellingRate');
    final buyRef = FirebaseDatabase.instance.ref('dollarRate/dollarBuyingRate');
    sellRef.onValue.listen((event) {
      dollarSellingRate = double.parse(event.snapshot.value.toString());
      buyRef.onValue.listen((event) {
        dollarBuyingRate = double.parse(event.snapshot.value.toString());
      });
    });
    super.didChangeDependencies();
    sendItem = widget.arguments.postModel!.sendItem;
    receivedItem = widget.arguments.postModel!.receiveItem;
    if (sendItem == "বিকাশ BDT" || sendItem == "নগদ BDT") {
      currencySend = "BDT";
    } else {
      currencySend = "USD";
    }
    if (receivedItem == "বিকাশ Personal BDT" ||
        receivedItem == "নগদ Personal BDT") {
      currencyreceive = "BDT";
    } else {
      currencyreceive = "USD";
    }
    amountSend = "${widget.arguments.postModel!.sendAmount} $currencySend";
    amountReceive =
        "${widget.arguments.postModel!.receiveAmount} $currencyreceive";
    receiveDetail = widget.arguments.postModel!.receiveAddress;
    contactPhoneNumber = widget.arguments.postModel!.contactNumber;
    logView(widget.arguments.postModel!.status.toString());
    dropDownValue = widget.arguments.postModel!.status;
    //  =
    total.child("bdt").onValue.listen((event) {
      getTotalBdt = double.parse(event.snapshot.value.toString());
    });
    total.child("usd").onValue.listen((event) {
      getTotalUsd = double.parse(event.snapshot.value.toString());
    });
    //
    totalForCalculate.child("bdt").onValue.listen((event) {
      getTotalBdtForCalculate = double.parse(event.snapshot.value.toString());
    });
    totalForCalculate.child("usd").onValue.listen((event) {
      getTotalUsdForCalculate = double.parse(event.snapshot.value.toString());
    });
    revenueInBDT = widget.arguments.postModel!.revenueInBDT;

    activeAccount = widget.arguments.postModel!.activeAccount;
    activeAccountName = widget.arguments.postModel!.activeAccountName;
    activeAccountId = widget.arguments.postModel!.activeAccountId;
    //

    //
    if (sendItem == "বিকাশ BDT") {
      activeAccBkashRef
          .child(widget.arguments.postModel!.activeAccountId.toString())
          .child('total')
          .onValue
          .listen((event) {
        getActiveBkashTotal = double.parse(event.snapshot.value.toString());
      });
    }
    if (sendItem == "নগদ BDT") {
      activeAccNagadRef
          .child(widget.arguments.postModel!.activeAccountId.toString())
          .child('total')
          .onValue
          .listen((event) {
        getActiveNagadTotal = double.parse(event.snapshot.value.toString());
      });
    }
  }

  double? getActiveBkashTotal = 0;
  double? getActiveNagadTotal = 0;
  double? dollarBuyingRate;
  double? dollarSellingRate;
  double? revenueInBDT = 0;
  String? currencySend;
  String? currencyreceive;
  String? sendItem;
  String? receivedItem;
  String? amountSend;
  String? amountReceive;
  String? receiveDetail;
  String? contactPhoneNumber;
  double? getTotalBdt = 0;
  double? getTotalUsd = 0;
  double? getTotalBdtForCalculate = 0;
  double? getTotalUsdForCalculate = 0;

  String? activeAccount;
  String? activeAccountName;
  String? activeAccountId;

  var dropDownValue;
  List<String> dropDownList = ["Processing", "Confirm", "Cancel"];
  final history = FirebaseDatabase.instance.ref('Orders');
  final total = FirebaseDatabase.instance.ref('total');
  final totalForCalculate = FirebaseDatabase.instance.ref('totalForCalculate');

  final activeAccBkashRef = FirebaseDatabase.instance.ref('/accounts/bkash');
  final activeAccNagadRef = FirebaseDatabase.instance.ref('/accounts/nagad');

  Future updateTotal(String type, double amount) async {
    if (type == 'BDT') {
      /// logView(total.child("bdt").onValue.toString());
      total.update({"bdt": getTotalBdt! + revenueInBDT!});
      totalForCalculate
          .update({"bdt": getTotalBdtForCalculate! + revenueInBDT!});

      //       total.update({"usd": getTotalUsd! + amount});
      // totalForCalculate.update({"usd": getTotalUsdForCalculate! + amount});
    } else if (type == 'USD') {
      total.update({"usd": getTotalUsd! + amount});
      totalForCalculate.update({"usd": getTotalUsdForCalculate! + amount});
    }
  }

  Future<bool> confirmDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Update Status!'),
            //     content: Text('Please update the app.'),
            actions: [
              TextButton(
                //    onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 13.sp),
                ),

                onPressed: () async {
                  if (Platform.isAndroid) {
                    history
                        .child(widget.arguments.postModel!.id.toString())
                        .update({'status': dropDownValue}).then((value) async {
                      if (dropDownValue == "Confirm") {
                        total.update({"bdt": getTotalBdt! + revenueInBDT!});
                        totalForCalculate.update(
                            {"bdt": getTotalBdtForCalculate! + revenueInBDT!});

                        total.update({
                          "usd": getTotalUsd! +
                              widget.arguments.postModel!.sendAmount!
                        });
                        totalForCalculate.update({
                          "usd": getTotalUsdForCalculate! +
                              widget.arguments.postModel!.sendAmount!
                        });
                        if (sendItem == "বিকাশ BDT") {
                          activeAccBkashRef
                              .child(widget.arguments.postModel!.activeAccountId
                                  .toString())
                              .update({
                            'total': getActiveBkashTotal! +
                                widget.arguments.postModel!.revenueInBDT!
                          });
                          String id =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          activeAccBkashRef
                              .child(widget.arguments.postModel!.activeAccountId
                                  .toString())
                              .child('history')
                              .child(id)
                              .set({
                            'amount': widget.arguments.postModel!.revenueInBDT!,
                            'dateTime': DateTime.now().toIso8601String()
                          });
                        }
                        if (sendItem == "নগদ BDT") {
                          activeAccNagadRef
                              .child(widget.arguments.postModel!.activeAccountId
                                  .toString())
                              .update({
                            'total': getActiveBkashTotal! +
                                widget.arguments.postModel!.revenueInBDT!
                          });
                          String id =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          activeAccNagadRef
                              .child(widget.arguments.postModel!.activeAccountId
                                  .toString())
                              .child('history')
                              .child(id)
                              .set({
                            'amount': widget.arguments.postModel!.revenueInBDT!,
                            'dateTime': DateTime.now().toIso8601String()
                          });
                        }
                      }

                      Navigator.pushNamed(context, RouteName.home,
                          arguments: PageRouteArguments(
                              datas: [dollarBuyingRate, dollarSellingRate]));
                    });
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonAppBarWithNotification(title: "Order Details", height: 12.0.h),
      bottomSheet: confirmOrderButton(),
      body: SingleChildScrollView(
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            topSection(),
            // SizedBox(height: 0.0.h),
            //   bottomSection(),
            //  defaultText("Update status"),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 1.0.h),
              alignment: Alignment.centerLeft,
              child: Text(
                "Update status",
                textScaleFactor: 1.0,
                style: TextStyle(
                    // color: AppColors.color2C2D30,
                    color: AppColors.black,
                    fontSize: 11.0.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
            dropDown(),
            SizedBox(height: 8.0.h),
            // confirmOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget confirmOrderButton() {
    logView(widget.arguments.postModel!.id.toString());
    return InkWell(
      onTap: () async {
        confirmDialog(context);
      },
      child: Container(
        height: 7.0.h,
        margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
        //   padding: EdgeInsets.symmetric(vertical: 1.0.h),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.confirm, width: 1.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: AppColors.confirm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Icon(
            //   Icons.check,
            //   color: AppColors.white,
            // ),
            SizedBox(
              width: 1.0.w,
            ),
            Text(
              "Update Order Status",
              textScaleFactor: 1.0,
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.POPPINS),
            ),
          ],
        ),
      ),
    );
  }

  Widget topSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
      padding: EdgeInsets.symmetric(vertical: 1.0.h),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 120, 117, 117), width: 1.0),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 1.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              titleText(sendItem!),
              SizedBox(
                child: Icon(Icons.sync_alt),
              ),
              titleText(receivedItem!),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Received Account :"),
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.5.h),
                alignment: Alignment.centerLeft,
                child: SelectableText(
                  "$activeAccount ($activeAccountName)",
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: Color.fromARGB(255, 190, 7, 231),
                      fontSize: 11.0.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.ROBOTO),
                ),
              )
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("We received :"),
              defaultText(amountSend!),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Transaction Number :"),
              defaultText(
                  widget.arguments.postModel!.transactionNumber.toString()),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("We have to send :"),
              defaultText(amountReceive!),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (receivedItem == "বিকাশ Personal BDT")
                defaultText("User বিকাশ Personal Number :")
              else if (receivedItem == "নগদ Personal BDT")
                defaultText("User নগদ Personal Number :")
              else if (receivedItem == "BinancePay USD")
                defaultText("User Binance Pay ID :"),
              defaultText(receiveDetail!),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Contact Phone Number :"),
              defaultText(contactPhoneNumber!),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Email :"),
              defaultText(widget.arguments.postModel!.email.toString()),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("DateTime :"),
              defaultText(
                  "${DateFormat.yMMMMd('en_US').format(DateTime.parse(widget.arguments.postModel!.dateTime.toString()))} ${DateFormat.jm().format(DateTime.parse(widget.arguments.postModel!.dateTime.toString()))}"),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Our Revenue :"),
              defaultText("${revenueInBDT!.toStringAsFixed(2)} Tk"),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                  "Status: ",
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.ROBOTO),
                ),
              ),
              if (dropDownValue == "Processing")
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppColors.googleBlue,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.timelapse_outlined,
                        color: AppColors.white,
                      ),
                      Text(
                        widget.arguments.postModel!.status.toString(),
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.POPPINS),
                      )
                    ],
                  ),
                )
              else if (dropDownValue == "Confirm")
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppColors.confirm,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check,
                        color: AppColors.white,
                      ),
                      Text(
                        "Confirm",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.POPPINS),
                      )
                    ],
                  ),
                )
              else if (dropDownValue == "Cancel")
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cancel,
                        color: AppColors.white,
                      ),
                      Text(
                        "Cancel",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.POPPINS),
                      )
                    ],
                  ),
                )
            ],
          ),
          SizedBox(height: 1.0.h),
        ],
      ),
    );
  }

  Widget commonDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.1.h),
      child: Divider(
        thickness: 0.3.w,
      ),
    );
  }

  Widget titleText(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.5.h),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textScaleFactor: 1.0,
        style: TextStyle(
            // color: AppColors.color2C2D30,
            color: AppColors.color525252,
            fontSize: 12.0.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.ROBOTO),
      ),
    );
  }

  Widget defaultText(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.5.h),
      alignment: Alignment.centerLeft,
      child: SelectableText(
        text,
        textScaleFactor: 1.0,
        style: TextStyle(
            // color: AppColors.color2C2D30,
            color: AppColors.color525252,
            fontSize: 11.0.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.ROBOTO),
      ),
    );
  }

  Widget dropDown() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.0.w),
      child: Container(
        height: 6.0.h,
        decoration: BoxDecoration(
          // color: AppColors.borderColor,
          border:
              Border.all(color: Color.fromARGB(255, 120, 117, 117), width: 1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.only(left: 4.0.w, right: 2.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 83.0.w,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  alignment: Alignment.topCenter,
                  value: dropDownValue,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.black,
                    size: 2.5.h,
                  ),
                  //    elevation: 16,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[800]),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropDownValue = newValue!;
                    });
                  },
                  items: dropDownList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.0.w),
                        child: Text(
                          items,
                          style: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
