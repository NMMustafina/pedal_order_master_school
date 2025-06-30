import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pedal_order_master_school_276_t/aisdfjasfhsajdlf/models/transaction_model.dart';
import 'package:pedal_order_master_school_276_t/provider/transaction_service.dart';
import 'package:provider/provider.dart';

class AddEditTransactionBottomSheet extends StatefulWidget {
  final TransactionModel? initialData;
  final int? index;

  const AddEditTransactionBottomSheet({
    super.key,
    this.initialData,
    this.index,
  });

  @override
  State<AddEditTransactionBottomSheet> createState() =>
      _AddEditTransactionBottomSheetState();
}

class _AddEditTransactionBottomSheetState
    extends State<AddEditTransactionBottomSheet> {
  final _amountController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isIncome = true;
  bool _submitAttempted = false;
  bool _isSaving = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _isIncome = d?.isIncome ?? true;
    _selectedDate = d?.date;
    _amountController.text = d?.amount.toString() ?? '';
    _typeController.text = d?.type ?? '';
    _descriptionController.text = d?.description ?? '';

    _amountController.addListener(() => setState(() {}));
    _typeController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isValid {
    final amount = double.tryParse(_amountController.text.trim());
    return _selectedDate != null &&
        _typeController.text.trim().isNotEmpty &&
        amount != null &&
        amount > 0;
  }

  bool get _isChanged {
    final d = widget.initialData;
    if (d == null) return true;

    final amount = double.tryParse(_amountController.text.trim()) ?? -1;
    final type = _typeController.text.trim();
    final desc = _descriptionController.text.trim();

    return d.amount != amount ||
        d.type != type ||
        (d.description ?? '') != desc ||
        d.isIncome != _isIncome ||
        d.date != _selectedDate;
  }

  Future<void> _save() async {
    if (!_isChanged) return;

    setState(() => _submitAttempted = true);
    if (!_isValid || _isSaving) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 300));

    final model = TransactionModel(
      isIncome: _isIncome,
      date: _selectedDate!,
      amount: double.parse(_amountController.text.trim()),
      type: _typeController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    final service = context.read<TransactionService>();
    if (widget.index != null) {
      service.update(widget.index!, model);
    } else {
      service.add(model);
    }

    Navigator.of(context).pop();
  }

  void _delete() {
    final service = context.read<TransactionService>();
    if (widget.index != null) {
      service.delete(widget.index!);
    }
    Navigator.pop(context);
  }

  Future<void> _confirmExit() async {
    final shouldExit = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('Exit Without Saving?'),
        content: Text('Your recent changes aren’t saved. Leave and lose them?'),
        actions: [
          CupertinoDialogAction(
            child: Text('Stay'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('Leave'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (shouldExit == true) Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('Delete Forever?'),
        content:
            Text('This item will be gone for good.\nDo you want to continue?'),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('Delete'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirm == true) _delete();
  }

  Future<void> _pickDate() async {
    DateTime temp = _selectedDate ?? DateTime.now();
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300.h,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: Text('Done'),
                  onPressed: () {
                    setState(() => _selectedDate = temp);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate ?? DateTime.now(),
                onDateTimeChanged: (d) => temp = d,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _format(DateTime d) => DateFormat.yMMMMd().format(d);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w,
                  MediaQuery.of(context).viewInsets.bottom + 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: Text(
                      widget.initialData == null
                          ? 'Record a new income or expense with date, amount, and description.'
                          : 'Update transaction details like amount, date, or description.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _confirmExit,
                        child: Text('Cancel',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6))),
                      ),
                      const Spacer(),
                      Text(
                        widget.initialData == null
                            ? 'Add Transaction'
                            : 'Edit Transaction',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _save,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: (_isValid && _isChanged)
                                ? const Color(0xFF1A7EF2)
                                : const Color(0xFF1A7EF2).withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(child: _buildRadio('Income', true)),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildRadio('Expense', false)),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: _pickDate,
                    child: _buildContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Payment Date'
                                : _format(_selectedDate!),
                            style: TextStyle(
                              color: _selectedDate == null
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/icons/calendar.svg',
                            height: 20.h,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildInput('Amount', _amountController, true, 'svg:dollar'),
                  SizedBox(height: 12.h),
                  _buildInput('Type', _typeController),
                  SizedBox(height: 12.h),
                  _buildInput('Description (optional)', _descriptionController,
                      false, null, 1),
                  if (widget.index != null) ...[
                    SizedBox(height: 24.h),
                    GestureDetector(
                      onTap: _confirmDelete,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172B).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFFFF3B30),
                              width: 2.w,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delete Transaction',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFF3B30),
                              ),
                            ),
                            SvgPicture.asset('assets/icons/delete.svg'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (_isSaving)
              Positioned.fill(child: Container(color: Colors.black54)),
            if (_isSaving)
              const Center(
                  child: CircularProgressIndicator(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(String label, bool value) {
    final selected = _isIncome == value;
    return GestureDetector(
      onTap: () => setState(() => _isIncome = value),
      child: _buildContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: Colors.white,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController controller,
      [bool numeric = false, String? suffix, int? minLines]) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172B).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF1A7EF2),
            width: 2.w,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: numeric
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              inputFormatters: numeric
                  ? [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ]
                  : [],
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 16.sp,
                ),
              ),
              minLines: minLines ?? 1,
              maxLines: null,
            ),
          ),
          if (suffix != null && suffix.startsWith('svg:'))
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: SvgPicture.asset(
                'assets/icons/${suffix.substring(4)}.svg',
                height: 18.h,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            )
          else if (suffix != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                suffix,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172B).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF1A7EF2),
            width: 2.w,
          ),
        ),
      ),
      child: child,
    );
  }
}
