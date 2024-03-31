import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';

class Bkash_Card_List extends StatefulWidget {
  const Bkash_Card_List(
      {super.key,
      required this.name,
      required this.number,
      required this.id,
      required this.isactive,
      required this.total});
  final String name;
  final String number;
  final String id;
  final bool isactive;
  final String total;

  @override
  State<Bkash_Card_List> createState() => _Bkash_Card_ListState();
}

class _Bkash_Card_ListState extends State<Bkash_Card_List> {
  @override
  void initState() {
    super.initState();
    if (widget.isactive) {
      _radioSelected = 1;
      genderType = 'Active';
    } else {
      _radioSelected = 2;
      genderType = 'Inactive';
    }
  }

  int _radioSelected = 2;
  String genderType = 'Inactive';
  final bkashRef = FirebaseDatabase.instance.ref('/accounts/bkash');
  final bkashStatusRef = FirebaseDatabase.instance.ref('/activeAccount/bkash');

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Account Name :"),
              defaultText(widget.name),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Account Number :"),
              defaultText(widget.number),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Total :"),
              defaultText("${widget.total} Tk"),
            ],
          ),
          commonDivider(),
          _genderSelectWidget()
        ],
      ),
    );
  }

  Widget _genderSelectWidget() {
    return Container(
      //  width: 38.0.w,
      child: Padding(
        padding: EdgeInsets.only(left: 6.0.w, right: 6.0.w, top: 0.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Radio(
                    value: 1,
                    groupValue: _radioSelected,
                    activeColor: AppColors.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _radioSelected = value!;
                        genderType = "Active";
                        bkashRef
                            .child(widget.id.toString())
                            .update({'isActive': true}).then((value) {
                          bkashStatusRef.update({
                            "number": widget.number,
                            "name": widget.name,
                            "id": widget.id,
                          }).then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Account active successful!"),
                              duration: Duration(seconds: 2),
                              backgroundColor: AppColors.confirm,
                            ));
                          });
                        });
                      });
                    }),
                Text("Active")
              ],
            ),
            Row(
              children: [
                Radio(
                    value: 2,
                    groupValue: _radioSelected,
                    activeColor: AppColors.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _radioSelected = value!;
                        genderType = "Inactive";
                        bkashRef
                            .child(widget.id.toString())
                            .update({'isActive': false}).then((value) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Account Inactive successful!"),
                            duration: Duration(seconds: 2),
                            backgroundColor: AppColors.colorDD0000,
                          ));
                        });
                      });
                    }),
                Text("Inactive")
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget defaultText(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
      alignment: Alignment.centerLeft,
      child: Text(
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

  Widget commonDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.1.h),
      child: Divider(
        thickness: 0.3.w,
      ),
    );
  }
}
