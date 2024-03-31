import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sizer/sizer.dart';

import 'bkash_card_list.dart';

class BkashList extends StatefulWidget {
  const BkashList({super.key});

  @override
  State<BkashList> createState() => _BkashListState();
}

class _BkashListState extends State<BkashList> {
  final bkashRef = FirebaseDatabase.instance.ref('/accounts/bkash');
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 72.0.h,
        child: FirebaseAnimatedList(
          query: bkashRef,
          reverse: false,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return Column(
              children: [
                Bkash_Card_List(
                  name: snapshot.child("accountName").value.toString(),
                  number: snapshot.child("accountNumber").value.toString(),
                  id: snapshot.child("id").value.toString(),
                  isactive: snapshot.child("isActive").value as bool,
                  total: snapshot.child("total").value.toString(),
                ),
              ],
            );
          },
        ));
  }
}
