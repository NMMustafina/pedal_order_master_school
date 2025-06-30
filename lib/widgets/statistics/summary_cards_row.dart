import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryCardsRow extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final DateTime month;
  final bool showIncome;
  final void Function(bool) onToggle;

  const SummaryCardsRow({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.month,
    required this.showIncome,
    required this.onToggle,
  });

  String _formatMonthYear(DateTime date) {
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${monthNames[date.month - 1]}, ${date.year}';
  }

  Widget _buildCard(String title, double amount, bool isActive) {
    return GestureDetector(
      onTap: () => onToggle(title == 'Income'),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16.r),
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF1A7EF2) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$title for ${_formatMonthYear(month)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.white),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              '\$${amount.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCard('Income', totalIncome, showIncome),
        _buildCard('Expense', totalExpense, !showIncome),
      ],
    );
  }
}
