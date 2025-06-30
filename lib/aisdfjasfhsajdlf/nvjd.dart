import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/color_vd.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/dok_gb.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/moti_tyb.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/pro_ie.dart';

class Nvjd extends StatelessWidget {
  const Nvjd({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Text(
                'Settings'.toUpperCase(),
                style: const TextStyle(
                  color: Colordgfajskdnfk.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(),
                MotiButsdhfbvaskdf(
                  onPressed: () {
                    lauchUrl(context, Doknsdkasdkf.priPoli);
                  },
                  child: Image.asset(
                    'assets/images/1.png',
                    width: 155.w,
                    height: 84.h,
                  ),
                ),
                const Spacer(),
                MotiButsdhfbvaskdf(
                  onPressed: () {
                    lauchUrl(context, Doknsdkasdkf.terOfUse);
                  },
                  child: Image.asset(
                    'assets/images/2.png',
                    width: 155.5.w,
                    height: 84.h,
                  ),
                ),
                const Spacer(),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(),
                MotiButsdhfbvaskdf(
                  onPressed: () {
                    lauchUrl(context, Doknsdkasdkf.suprF);
                  },
                  child: Image.asset(
                    'assets/images/3.png',
                    width: 155.5.w,
                    height: 84.h,
                  ),
                ),
                const Spacer(),
                Opacity(
                  opacity: 0,
                  child: Image.asset(
                    'assets/images/3.png',
                    width: 155.5.w,
                    height: 84.h,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
