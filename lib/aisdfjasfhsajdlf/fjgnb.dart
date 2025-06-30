import 'package:flutter/material.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/color_vd.dart';

class Fjgnb extends StatelessWidget {
  const Fjgnb({super.key});
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
              child: Text(
                'Statistic'.toUpperCase(),
                style: const TextStyle(
                  color: Colordgfajskdnfk.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
