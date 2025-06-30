import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pedal_order_master_school_276_t/aisdfjasfhsajdlf/models/transaction_model.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/color_vd.dart';
import 'package:pedal_order_master_school_276_t/widgets/add_edit_transaction_bottom_sheet.dart';
import 'package:pedal_order_master_school_276_t/widgets/statistics/month_picker.dart';
import 'package:pedal_order_master_school_276_t/widgets/statistics/summary_cards_row.dart';
import 'package:pedal_order_master_school_276_t/widgets/statistics/transaction_chart.dart';
import 'package:pedal_order_master_school_276_t/widgets/statistics/transaction_list_view.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _isIncomeSelected = true;
  DateTime _selectedMonth = DateTime.now();

  void _changeMonth(int direction, List<DateTime> months) {
    final index = months.indexOf(_selectedMonth);
    final newIndex = index + direction;
    if (newIndex >= 0 && newIndex < months.length) {
      setState(() => _selectedMonth = months[newIndex]);
    }
  }

  Widget _buildQuoteBlock() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
                child: Divider(
                    color: Colors.white.withOpacity(0.3), thickness: 1.sp)),
            SizedBox(width: 8.w),
            Text(
              'Kofi Annan',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8.w),
            Expanded(
                child: Divider(
                    color: Colors.white.withOpacity(0.3), thickness: 1.sp)),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          '"Knowledge is power. Information is liberating.\nEducation is the premise of progress."',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            height: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TransactionModel>('transactions');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'STATISTIC',
          style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/images/bg.png', fit: BoxFit.cover)),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box<TransactionModel> box, _) {
                  final allTxs = box.values.toList();
                  final months = allTxs
                      .map((e) => DateTime(e.date.year, e.date.month))
                      .toSet()
                      .toList()
                    ..sort();

                  if (!months.contains(_selectedMonth) && months.isNotEmpty) {
                    _selectedMonth = months.last;
                  }

                  final monthTxs = allTxs
                      .where((t) =>
                          t.date.year == _selectedMonth.year &&
                          t.date.month == _selectedMonth.month)
                      .toList();

                  if (monthTxs.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        _buildQuoteBlock(),
                        const Spacer(),
                      ],
                    );
                  }

                  final income = monthTxs
                      .where((t) => t.isIncome)
                      .fold(0.0, (sum, t) => sum + t.amount);

                  final expense = monthTxs
                      .where((t) => !t.isIncome)
                      .fold(0.0, (sum, t) => sum + t.amount);

                  final days = DateUtils.getDaysInMonth(
                      _selectedMonth.year, _selectedMonth.month);
                  final filtered = _isIncomeSelected
                      ? monthTxs.where((t) => t.isIncome).toList()
                      : monthTxs.where((t) => !t.isIncome).toList();
                  final daily = List.generate(days, (_) => 0.0);
                  for (var tx in filtered) {
                    daily[tx.date.day - 1] += tx.amount;
                  }

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 160.h),
                    children: [
                      SummaryCardsRow(
                        totalIncome: income,
                        totalExpense: expense,
                        month: _selectedMonth,
                        showIncome: _isIncomeSelected,
                        onToggle: (val) =>
                            setState(() => _isIncomeSelected = val),
                      ),
                      SizedBox(height: 8.h),
                      TransactionChart(
                        dailyAmounts: daily,
                        isIncome: _isIncomeSelected,
                      ),
                      SizedBox(height: 20.h),
                      MonthPicker(
                        months: months,
                        selected: _selectedMonth,
                        onSelect: (m) => setState(() => _selectedMonth = m),
                      ),
                      SizedBox(height: 20.h),
                      TransactionListView(
                        transactions: [...monthTxs]
                          ..sort((a, b) => a.date.compareTo(b.date)),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddEditTransactionBottomSheet(),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 86.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF1567FF), Color(0xFF1F93E6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Text(
            'Add transaction',
            style: TextStyle(
              color: Colordgfajskdnfk.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
