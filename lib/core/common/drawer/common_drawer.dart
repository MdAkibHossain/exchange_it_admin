import 'package:exchange_it_admin/core/model/page_arguments_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../route_name.dart';
import '../../constants/app_constants.dart';
import '../../services/firebase_services.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer(
      {Key? key,
      required this.dollarBuyingRate,
      required this.dollarSellingRate})
      : super(key: key);
  final double? dollarBuyingRate;
  final double? dollarSellingRate;

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userName = FirebaseAuth.instance.currentUser!.displayName.toString();
    email = FirebaseAuth.instance.currentUser!.email.toString();
    image = FirebaseAuth.instance.currentUser!.email.toString();
  }

  late String userName;
  late String email;
  late String image;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Stack(
              children: [
                ClipPath(
                  clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Container(
                    height: 18.6.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            // Color(0xFF000000),
                            // Color(0xFF196E55),
                            // Color(0xFF196E55),
                            // Color(0xFF196E55),

                            AppColors.googleBlue,
                            AppColors.googleBlue,

                            Color.fromARGB(255, 121, 170, 245),
                            Color.fromARGB(255, 121, 170, 245),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.5, 0.4, .8],
                          tileMode: TileMode.clamp),
                    ),
                    child:
                        // Container(),
                        Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        // height: 46,
                        child: Text(APP_TITLE,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontFamily: AppFonts.ROBOTO,
                                fontWeight: FontWeight.w700)),
                        //  SvgPicture.asset(
                        //   AppAssets.youtube,
                        //   color: AppColors.white,
                        // ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: ListView(
              shrinkWrap: true,
              children: [
                _titleItem(
                  title: "Home",
                  iconName: Icons.home,
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.home);
                  },
                ),
                _titleItem(
                  title: "Order History",
                  iconName: Icons.history,
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.orderHistoryScreen);
                  },
                ),
                _titleItem(
                  title: "Dollar Rate",
                  iconName: Icons.attach_money,
                  onTap: () {
                    Navigator.pushNamed(
                        context, RouteName.dollarRateInputScreen,
                        arguments: PageRouteArguments(
                          datas: [
                            widget.dollarBuyingRate,
                            widget.dollarSellingRate
                          ],
                        ));
                  },
                ),
                _titleItem(
                  title: "Revenue",
                  iconName: Icons.money,
                  onTap: () {
                    final totalRef = FirebaseDatabase.instance.ref('total');
                    final totalForCalculateRef =
                        FirebaseDatabase.instance.ref('totalForCalculate');
                    double? totalBdt;
                    double? totalUsd;
                    double? totalForCalculateBdt;
                    double? totalForCalculateUsd;

                    totalRef.child('bdt').onValue.listen((event) {
                      totalBdt = double.parse(event.snapshot.value.toString());
                      totalRef.child('usd').onValue.listen((event) {
                        totalUsd =
                            double.parse(event.snapshot.value.toString());
                        totalForCalculateRef
                            .child('bdt')
                            .onValue
                            .listen((event) {
                          totalForCalculateBdt =
                              double.parse(event.snapshot.value.toString());
                          totalForCalculateRef
                              .child('usd')
                              .onValue
                              .listen((event) {
                            totalForCalculateUsd =
                                double.parse(event.snapshot.value.toString());
                            //
                            Navigator.pushNamed(
                              context,
                              RouteName.revenueScreen,
                              arguments: PageRouteArguments(
                                datas: [
                                  totalBdt,
                                  totalUsd,
                                  totalForCalculateBdt,
                                  totalForCalculateUsd,
                                ],
                              ),
                            );
                          });
                        });
                      });
                    });
                  },
                ),
                _titleItem(
                  title: "Active Account",
                  iconName: Icons.account_tree,
                  onTap: () {
                    Navigator.pushNamed(
                      context, RouteName.activeAccount,
                      // arguments: PageRouteArguments(
                      //   datas: [
                      //     widget.dollarBuyingRate,
                      //     widget.dollarSellingRate
                      //   ],
                      // )
                    );
                  },
                ),
                _titleItem(
                  title: "Exit",
                  iconName: Icons.exit_to_app,
                  onTap: () async {
                    // final prefs = await SharedPreferences.getInstance();
                    // await FirebaseServices().googleSignOut();
                    // prefs.clear();
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            margin: EdgeInsets.only(left: .0.w, right: 0.0.w, bottom: 1.0.h),
            padding: EdgeInsets.only(
                left: 4.0.w, right: 0.0.w, bottom: 1.0.h, top: 1.0.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, .2),
                  blurRadius: 1.0,
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 11.0.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.ROBOTO),
                    ),
                    SizedBox(height: 1.0.h),
                    Text(
                      email,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 10.0.sp,
                          color: AppColors.color707070,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppFonts.ROBOTO),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleItem(
      {required String title,
      required IconData iconName,
      required Function() onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Card(
                  elevation: 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                        //    onTap: () {},
                        child: Icon(iconName)
                        //  SvgPicture.asset(
                        //   iconName,
                        //   // color: AppColors.primaryColor,
                        // ),
                        ),
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Text(
                title,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 12.0.sp,
                    color: AppColors.color525252,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.ROBOTO),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.black,
                size: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
