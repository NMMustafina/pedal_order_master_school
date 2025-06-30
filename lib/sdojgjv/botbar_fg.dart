import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pedal_order_master_school_276_t/aisdfjasfhsajdlf/gnj.dart';
import 'package:pedal_order_master_school_276_t/aisdfjasfhsajdlf/nrvnu.dart';
import 'package:pedal_order_master_school_276_t/aisdfjasfhsajdlf/nvjd.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/moti_tyb.dart';

import '../aisdfjasfhsajdlf/statistics_screen.dart';

class BotomBarasdjasnfjk extends StatefulWidget {
  const BotomBarasdjasnfjk({super.key, this.indexScr = 0});
  final int indexScr;

  @override
  State<BotomBarasdjasnfjk> createState() => BotomBarasdjasnfjkState();
}

class BotomBarasdjasnfjkState extends State<BotomBarasdjasnfjk> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexScr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 80.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 53.w),
        // padding: const EdgeInsets.only(
        //   left: 5,
        //   right: 5,
        //   top: 12,
        //   bottom: 12,
        // ),
        decoration: BoxDecoration(
          color: const Color(0xff000718),
          borderRadius: BorderRadius.circular(32),

          border: Border.all(
            color: const Color(0xffFFFFFF).withOpacity(0.1),
          ),
          // border: Border(
          //     top: BorderSide(
          //   color: Color(0xff308AFF),
          // )),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildNavItem(
                0,
                'assets/icons/1.png',
                'assets/icons/11.png',
              ),
            ),
            Expanded(
              child: buildNavItem(
                1,
                'assets/icons/2.png',
                'assets/icons/22.png',
              ),
            ),
            Expanded(
              child: buildNavItem(
                2,
                'assets/icons/3.png',
                'assets/icons/33.png',
              ),
            ),
            Expanded(
              child: buildNavItem(
                3,
                'assets/icons/4.png',
                'assets/icons/44.png',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(int index, String iconPath, String ima2) {
    bool isActive = _currentIndex == index;

    return MotiButsdhfbvaskdf(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        // width: isActive ? 137.w : 60.w,
        color: Colors.transparent,
        // decoration: BoxDecoration(
        //   color: isActive ? Colordgfajskdnfk.blue : Colors.white.withOpacity(0.0),
        //   borderRadius: BorderRadius.circular(14),
        // ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_currentIndex == 0 ? 25 : 0),
              topRight: Radius.circular(_currentIndex == 3 ? 25 : 0),
            ),
            child: Image.asset(
              isActive ? iconPath : ima2,
              width: 64.w,
              height: 90.h,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              // height: 61.h,
            ),
          ),
        ),
      ),
    );
  }

  final _pages = <Widget>[
    const Gnj(),
    const Nrvnu(),
    const StatisticsScreen(),
    const Nvjd(),
  ];
}
