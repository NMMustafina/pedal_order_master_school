import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class MonthPicker extends StatelessWidget {
  final List<DateTime> months;
  final DateTime selected;
  final void Function(DateTime) onSelect;

  const MonthPicker({
    super.key,
    required this.months,
    required this.selected,
    required this.onSelect,
  });

  String _format(DateTime date) {
    return DateFormat("MMM, yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final separator = 12.w;
    final itemWidth = 90.w;

    final isSingle = months.length == 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40.h,
          child: isSingle
              ? Center(
                  child: GestureDetector(
                    onTap: () => onSelect(months.first),
                    child: Text(
                      _format(months.first),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : _ScrollableMonthList(
                  months: months,
                  selected: selected,
                  onSelect: onSelect,
                  itemWidth: itemWidth,
                  separator: separator,
                ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 1.h,
          child: SvgPicture.asset(
            'assets/icons/line.svg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class _ScrollableMonthList extends StatefulWidget {
  final List<DateTime> months;
  final DateTime selected;
  final void Function(DateTime) onSelect;
  final double itemWidth;
  final double separator;

  const _ScrollableMonthList({
    required this.months,
    required this.selected,
    required this.onSelect,
    required this.itemWidth,
    required this.separator,
  });

  @override
  State<_ScrollableMonthList> createState() => _ScrollableMonthListState();
}

class _ScrollableMonthListState extends State<_ScrollableMonthList> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(covariant _ScrollableMonthList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  void _scrollToSelected() {
    final index = widget.months.indexWhere(
      (m) => m.year == widget.selected.year && m.month == widget.selected.month,
    );
    if (index == -1 || !_controller.hasClients) return;

    final totalItemWidth = widget.itemWidth + widget.separator;
    final screenWidth = MediaQuery.of(context).size.width;
    final offset =
        (index * totalItemWidth + widget.itemWidth / 2) - screenWidth / 2;

    _controller.animateTo(
      offset.clamp(0, _controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String _format(DateTime date) {
    return DateFormat("MMM, yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: widget.months.length,
      separatorBuilder: (_, __) => SizedBox(width: widget.separator),
      itemBuilder: (context, index) {
        final date = widget.months[index];
        final isSelected = date.year == widget.selected.year &&
            date.month == widget.selected.month;

        return SizedBox(
          width: widget.itemWidth,
          child: GestureDetector(
            onTap: () => widget.onSelect(date),
            child: Center(
              child: Text(
                _format(date),
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
