import 'dart:io';
import 'package:exchange_it_admin/core/utils/debug_utils.dart';
import 'package:exchange_it_admin/features/home/data/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/common/drawer/common_drawer.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/model/page_arguments_model.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../route_name.dart';
import '../widgets/appbar.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/web_view.dart';

enum Status { buyDollar, sellDollar, exchangeDollar, exchangeBDT }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.arguments});
  final PageRouteArguments? arguments;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appVersion = FirebaseDatabase.instance.ref('appVersion/adminApp');
    appVersion.onValue.listen((event) {
      appVersionCode = event.snapshot.value.toString();
      logView(appVersionCode.toString());
      if (staticVersionCode != appVersionCode) {
        updateDialog(context);
      }
    });
  }

  String appVersionCode = '';
  String staticVersionCode = "0.0.3";
  Future<bool> updateDialog(BuildContext context) async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Update Available!'),
            content: Text('Please update the app.'),
            actions: [
              TextButton(
                //    onPressed: () => Navigator.of(context).pop(true),
                child: Text('Update'),

                onPressed: () async {
                  if (Platform.isAndroid) {
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (_) => WebView()));
                    await launchUrl(
                        Uri.parse(
                          'https://drive.google.com/drive/folders/1yXwzKE-u1kAZKjf6A6LcT9xI_6QkJpKK?usp=sharing',
                        ),
                        mode: LaunchMode.externalApplication);
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

  final history = FirebaseDatabase.instance.ref('Orders');
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  Future<bool> CommonOnWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                //    onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (staticVersionCode != appVersionCode) {
          updateDialog(context);
        }
        return CommonOnWillPop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: HomeAppBar(
          height: 18.0.h,
          title: APP_TITLE,
          leading: GestureDetector(
            onTap: () {
              if (staticVersionCode != appVersionCode) {
                updateDialog(context);
              }
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: SvgPicture.asset(
                AppAssets.featherMenuIcon,
                // height: 16,
                color: Colors.white,
              ),
            ),
          ),
          dollarBuyingRate: widget.arguments!.datas![0],
          dollarSellingRate: widget.arguments!.datas![1],
        ),
        drawer: CommonDrawer(
          dollarBuyingRate: widget.arguments!.datas![0],
          dollarSellingRate: widget.arguments!.datas![1],
        ),
        body: SizedBox(
          // height: 33.0.h,
          child: FirebaseAnimatedList(
            query: history,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              if (snapshot.child("status").value.toString() == "Confirm" ||
                  snapshot.child("status").value.toString() == "Cancel") {
                return SizedBox();
              } else {
                return Column(
                  children: [
                    listCard(
                      id: snapshot.child("id").value.toString(),
                      sendItem: snapshot.child("sendItem").value.toString(),
                      receivedItem:
                          snapshot.child("receiveItem").value.toString(),
                      sendAmount: snapshot.child("sendAmount").value.toString(),
                      receivedAmount:
                          snapshot.child("receiveAmount").value.toString(),
                      dateTime: snapshot.child("createdAt").value.toString(),
                      status: snapshot.child("status").value.toString(),
                      contactNumber:
                          snapshot.child("contactNumber").value.toString(),
                      email: snapshot.child("email").value.toString(),
                      receiveAddress:
                          snapshot.child("receiveAddress").value.toString(),
                      transactionNumber:
                          snapshot.child("transactionNumber").value.toString(),
                      revenueInBDT: double.parse(
                          snapshot.child("revenueInBDT").value.toString()),
                      activeAccount: snapshot
                          .child("activeAccountDetails")
                          .child("accountNumber")
                          .value
                          .toString(),
                      activeAccountName: snapshot
                          .child("activeAccountDetails")
                          .child("accountName")
                          .value
                          .toString(),
                      activeAccountId: snapshot
                          .child("activeAccountDetails")
                          .child("accountId")
                          .value
                          .toString(),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget listCard({
    required String id,
    required String sendItem,
    required String receivedItem,
    required String sendAmount,
    required String contactNumber,
    required String receivedAmount,
    required String email,
    required String dateTime,
    required String status,
    required String receiveAddress,
    required String transactionNumber,
    required double revenueInBDT,
    required String activeAccountName,
    required String activeAccountId,
    required String activeAccount,
  }) {
    String? currencySend;
    String? currencyreceive;
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
    String amountSend;
    String amountReceive;
    amountSend = "$sendAmount $currencySend";
    amountReceive = "$receivedAmount $currencyreceive";

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
              titleText(sendItem),
              const SizedBox(
                child: Icon(Icons.sync_alt),
              ),
              titleText(receivedItem),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: defaultText("Received Account :")),
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
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.ROBOTO),
                ),
              )
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Our Revenue :"),
              defaultText("${revenueInBDT.toStringAsFixed(2)} Tk"),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Amount we received :"),
              defaultText(amountSend),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Amount we send :"),
              defaultText(amountReceive),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("DateTime :"),
              defaultText(
                  "${DateFormat.yMMMMd('en_US').format(DateTime.parse(dateTime))} ${DateFormat.jm().format(DateTime.parse(dateTime))}"),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Contact Phone Number :"),
              defaultText(contactNumber),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Email :"),
              defaultText(email),
            ],
          ),
          commonDivider(),
          SizedBox(height: 1.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   child: Text(
              //     "Status: ",
              //     textScaleFactor: 1.0,
              //     style: TextStyle(
              //         fontSize: 12.0.sp,
              //         fontWeight: FontWeight.w600,
              //         fontFamily: AppFonts.ROBOTO),
              //   ),
              // ),\

              InkWell(
                onTap: () {
                  logView(id);
                  if (staticVersionCode != appVersionCode) {
                    updateDialog(context);
                  }
                  Navigator.pushNamed(
                    context,
                    RouteName.orderDetailsScreen,
                    arguments: PageRouteArguments(
                      postModel: PostModel(
                        id: id,
                        contactNumber: contactNumber,
                        receiveAddress: receiveAddress,
                        receiveAmount: double.parse(receivedAmount),
                        receiveItem: receivedItem,
                        sendAmount: double.parse(sendAmount),
                        sendItem: sendItem,
                        status: status,
                        transactionNumber: transactionNumber,
                        dateTime: dateTime,
                        email: email,
                        revenueInBDT: revenueInBDT,
                        activeAccount: activeAccount,
                        activeAccountName: activeAccountName,
                        activeAccountId: activeAccountId,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 9.1.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                      color: AppColors.googleBlue,
                      borderRadius: BorderRadius.circular(3)),
                  child: Row(
                    children: [
                      // const Icon(
                      //   Icons.timelapse_outlined,
                      //   color: AppColors.white,
                      // ),
                      Text(
                        "Check",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.POPPINS),
                      ),
                    ],
                  ),
                ),
              ),
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
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
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
}
