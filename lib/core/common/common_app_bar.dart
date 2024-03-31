import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/model/page_arguments_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/debug_utils.dart';
import '../../../../route_name.dart';

// ignore: must_be_immutable
class CommonAppBarWithNotification extends StatelessWidget
    implements PreferredSizeWidget {
  CommonAppBarWithNotification({
    required this.height,
    this.onPressed,
    Key? key,
    required this.title,
    this.leading,
    this.showNotificationIcon = false,
    this.isGotoHome = false,
  }) : super(key: key);

  final Widget? leading;
  final double height;
  void Function()? onPressed;
  final String title;
  final bool showNotificationIcon;
  final bool isGotoHome;

  @override
  Size get preferredSize => Size.fromHeight(height);

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
        child: AppBar(
          // foregroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(title,
              style: TextStyle(color: Colors.white, fontSize: 16.sp)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: showNotificationIcon
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: SizedBox(
                      child: Icon(
                        Icons.notifications,
                        color: AppColors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(width: 1.0.w),
                ]
              : null,
          leading: leading ??
              GestureDetector(
                  onTap: () {
                    final sellRef = FirebaseDatabase.instance
                        .ref('dollarRate/dollarSellingRate');
                    final buyRef = FirebaseDatabase.instance
                        .ref('dollarRate/dollarBuyingRate');

                    double? dollarBuyingRate;
                    double? dollarSellingRate;

                    isGotoHome
                        ? sellRef.onValue.listen((event) {
                            dollarSellingRate =
                                double.parse(event.snapshot.value.toString());
                            buyRef.onValue.listen((event) {
                              dollarBuyingRate =
                                  double.parse(event.snapshot.value.toString());
                              logView(isGotoHome.toString());
                              Navigator.pushReplacementNamed(
                                  context, RouteName.home,
                                  arguments: PageRouteArguments(datas: [
                                    dollarBuyingRate,
                                    dollarSellingRate
                                  ]));
                            });
                          })
                        : Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 30,
                  )),
        ),
      ),
    );
  }
}
