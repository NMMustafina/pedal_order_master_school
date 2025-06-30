import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionChart extends StatelessWidget {
  final List<double> dailyAmounts;
  final bool isIncome;

  const TransactionChart({
    super.key,
    required this.dailyAmounts,
    required this.isIncome,
  });

  double _getMaxRounded(double maxY) {
    if (maxY <= 0) return 5;
    const scale = 5;
    return ((maxY / scale).ceil() * scale).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final maxY = dailyAmounts.fold<double>(0, (prev, e) => e > prev ? e : prev);
    final maxRounded = _getMaxRounded(maxY);
    final lineColor = Colors.white.withOpacity(0.3);

    return SizedBox(
      height: 200.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 8.w),
        child: SizedBox(
          width: dailyAmounts.length * 24.w,
          child: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxRounded,
                barTouchData: const BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40.w,
                      interval: maxRounded / 5,
                      getTitlesWidget: (value, meta) => Text(
                        '\$${value.toInt()}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          '${value.toInt()}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxRounded / 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: lineColor,
                    strokeWidth: 1,
                    dashArray: [4, 3],
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 0,
                      color: lineColor,
                      strokeWidth: 1,
                      dashArray: [4, 3],
                    ),
                    HorizontalLine(
                      y: maxRounded,
                      color: lineColor,
                      strokeWidth: 1,
                      dashArray: [4, 3],
                    ),
                  ],
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(dailyAmounts.length, (i) {
                  return BarChartGroupData(
                    x: i + 1,
                    barRods: [
                      BarChartRodData(
                        toY: dailyAmounts[i],
                        color: isIncome
                            ? const Color(0xFF1ADA65)
                            : const Color(0xFFFF3B30),
                        width: 12.w,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
