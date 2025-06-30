import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pedal_order_master_school_276_t/aisdfjasfhsajdlf/models/transaction_model.dart';
import 'package:pedal_order_master_school_276_t/widgets/add_edit_transaction_bottom_sheet.dart';

class TransactionListView extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionListView({super.key, required this.transactions});

  String _formatFullDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Center(
          child: Text(
            'No transactions this month',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isIncome = tx.isIncome;

        return GestureDetector(
          onTap: () async {
            final key = tx.key;
            if (key != null) {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => AddEditTransactionBottomSheet(
                  initialData: tx,
                  index: key,
                ),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16.r),
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: Colors.blue.withOpacity(0.6),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isIncome ? 'Income' : 'Expense',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildRow('Date:', _formatFullDate(tx.date)),
                SizedBox(height: 6.h),
                _buildRow(
                  'Amount:',
                  '\$${tx.amount % 1 == 0 ? tx.amount.toInt() : tx.amount}',
                  valueColor: isIncome
                      ? const Color(0xFF1D914A)
                      : const Color(0xFFFF3B30),
                  valueWeight: FontWeight.bold,
                ),
                SizedBox(height: 6.h),
                _buildRow('Type:', tx.type),
                if (tx.description != null &&
                    tx.description!.trim().isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  SvgPicture.asset(
                    'assets/icons/line.svg',
                    height: 1.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    tx.description!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    Color? valueColor,
    FontWeight? valueWeight,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13.sp,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 13.sp,
              fontWeight: valueWeight ?? FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
