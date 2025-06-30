
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pedal_order_master_school_276_t/aisdfjasfhsajdlf/models/instructor_model.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/color_vd.dart';
import 'package:pedal_order_master_school_276_t/widgets/select_instructor_sheet.dart';
import 'package:pedal_order_master_school_276_t/provider/jv_servic.dart'; 
import 'package:provider/provider.dart';

class CourseData {
  final DateTime startDate;
  final DateTime endDate;
  final List<InstructorModel> selectedInstructors;
  final String courseName;
  final String vehicleCategory;
  final double price;

  CourseData({
    required this.startDate,
    required this.endDate,
    required this.selectedInstructors,
    required this.courseName,
    required this.vehicleCategory,
    required this.price,
  });
}

class AddCourseBottomSheet extends StatefulWidget {
  final CourseData? initialData;

  final int? courseIndex;

  const AddCourseBottomSheet({
    Key? key,
    this.initialData,
    this.courseIndex,
  }) : super(key: key);

  @override
  _AddCourseBottomSheetState createState() => _AddCourseBottomSheetState();
}

class _AddCourseBottomSheetState extends State<AddCourseBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  List<InstructorModel> _selectedInstructors = [];

  bool _submitAttempted = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final d = widget.initialData!;
      _startDate = d.startDate;
      _endDate = d.endDate;
      _selectedInstructors = List.from(d.selectedInstructors);
      _nameController.text = d.courseName;
      _categoryController.text = d.vehicleCategory;
      _priceController.text = d.price.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  bool get _allFieldsValid {
    if (_startDate == null || _endDate == null) return false;
    if (_selectedInstructors.isEmpty) return false;
    if (_nameController.text.trim().isEmpty) return false;
    if (_categoryController.text.trim().isEmpty) return false;
    final priceValue = double.tryParse(_priceController.text.trim());
    if (priceValue == null || priceValue <= 0) return false;
    if (_endDate!.isBefore(_startDate!)) return false;
    return true;
  }

  void _markSubmitAttempted() {
    if (!_submitAttempted) {
      setState(() => _submitAttempted = true);
    }
  }

  Future<void> _onSavePressed() async {
    _markSubmitAttempted();
    if (!_allFieldsValid || _isSaving) return;

    setState(() => _isSaving = true);

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    final priceVal = double.parse(_priceController.text.trim());
    final result = CourseData(
      startDate: _startDate!,
      endDate: _endDate!,
      selectedInstructors: List.from(_selectedInstructors),
      courseName: _nameController.text.trim(),
      vehicleCategory: _categoryController.text.trim(),
      price: priceVal,
    );
    Navigator.of(context).pop(result);
  }

  Future<void> _showCupertinoDatePicker({
    required DateTime initialDate,
    required ValueChanged<DateTime> onConfirm,
  }) async {
    DateTime tempPicked = initialDate;
    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 300.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onConfirm(tempPicked);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  minimumYear: 2000,
                  maximumYear: 2100,
                  onDateTimeChanged: (dt) => tempPicked = dt,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final monthNames = <String>[
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
    final m = monthNames[date.month - 1];
    return '$m ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  Widget _buildFieldContainer({
    required Widget child,
    required bool isError,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(100.r),
        border: Border(
          bottom: BorderSide(
            color: isError ? Colors.redAccent : const Color(0xFF1A7EF2),
            width: 2, 
          ),
        ),
      ),
      child: Stack(
        children: [
          child,
        ],
      ),
    );
  }

  Future<void> _confirmAndDelete() async {
    final shouldDelete = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) {
        return CupertinoAlertDialog(
          title: Text(
            'Delete Forever?',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: Text(
            'This item will be gone for good.\nDo you want to continue?',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.sp,
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16.sp,
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && widget.courseIndex != null) {
      Provider.of<CourseProvider>(context, listen: false)
          .deleteCourse(widget.courseIndex!);
      Navigator.of(context).pop(null); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

    return WillPopScope(
      onWillPop: () async {
        if (!_submitAttempted) return true;
        final discard = await showCupertinoDialog<bool>(
          context: context,
          builder: (ctx) {
            return CupertinoAlertDialog(
              title: Text(
                'Unsaved Changes Detected',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              content: Text(
                'You have unsaved changes. Are you sure you want to discard?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    'Stay',
                    style: TextStyle(
                      color: Colordgfajskdnfk.blue,
                      fontSize: 16.sp,
                    ),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(false),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text(
                    'Discard',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16.sp,
                    ),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(true),
                ),
              ],
            );
          },
        );
        return discard == true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
              ),

              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 12.h,
                  left: 16.w,
                  right: 16.w,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        widget.initialData == null
                            ? 'Create a new driving course with vehicle category, instructors, and price.'
                            : 'Edit a driving course with vehicle category, instructors, and price.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (!_submitAttempted) {
                              Navigator.of(context).pop(null);
                            } else {
                              final canPop = await showCupertinoDialog<bool>(
                                context: context,
                                builder: (ctx) {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                      'Exit Without Saving?',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    content: Text(
                                      'Your recent changes aren’t saved. Leave and lose them?',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text(
                                          'Stay',
                                          style: TextStyle(
                                            color: Colordgfajskdnfk.blue,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(false),
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        child: Text(
                                          'Leave',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(true),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (canPop == true)
                                Navigator.of(context).pop(null);
                            }
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.initialData == null
                              ? 'Add Course'
                              : 'Edit Course',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _onSavePressed,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: _allFieldsValid
                                  ? Colordgfajskdnfk.blue
                                  : Colordgfajskdnfk.blue.withOpacity(0.5),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final now = _startDate ?? DateTime.now();
                              _showCupertinoDatePicker(
                                initialDate: now,
                                onConfirm: (picked) {
                                  setState(() {
                                    _startDate = picked;
                                  });
                                },
                              );
                            },
                            child: _buildFieldContainer(
                              isError: _submitAttempted && _startDate == null,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _startDate == null
                                          ? 'Start Date'
                                          : _formatDate(_startDate!),
                                      style: TextStyle(
                                        color: _startDate == null
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    CupertinoIcons.calendar,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final now = _endDate ?? DateTime.now();
                              _showCupertinoDatePicker(
                                initialDate: now,
                                onConfirm: (picked) {
                                  setState(() {
                                    _endDate = picked;
                                  });
                                },
                              );
                            },
                            child: _buildFieldContainer(
                              isError: _submitAttempted &&
                                  (_endDate == null ||
                                      (_startDate != null &&
                                          _endDate!.isBefore(_startDate!))),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _endDate == null
                                          ? 'End Date'
                                          : _formatDate(_endDate!),
                                      style: TextStyle(
                                        color: _endDate == null
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    CupertinoIcons.calendar,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_submitAttempted &&
                        (_startDate == null || _endDate == null))
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          'Both start and end dates are required',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12.sp,
                          ),
                        ),
                      )
                    else if (_submitAttempted &&
                        _startDate != null &&
                        _endDate != null &&
                        _endDate!.isBefore(_startDate!))
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          'End date cannot be before start date',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),

                    SizedBox(height: 16.h),

                    GestureDetector(
                      onTap: () async {
                        final result =
                            await showModalBottomSheet<List<InstructorModel>>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) {
                            return SelectInstructorsSheet(
                              initiallySelected: _selectedInstructors,
                            );
                          },
                        );
                        if (result != null) {
                          setState(() {
                            _selectedInstructors = result;
                          });
                        }
                      },
                      child: _buildFieldContainer(
                        isError:
                            _submitAttempted && _selectedInstructors.isEmpty,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedInstructors.isEmpty
                                    ? 'Select instructors'
                                    : _selectedInstructors
                                        .map((e) => e.name)
                                        .join(', '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _selectedInstructors.isEmpty
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              CupertinoIcons.chevron_right,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_submitAttempted && _selectedInstructors.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          'Please select at least one instructor',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),

                    SizedBox(height: 16.h),

                    _buildFieldContainer(
                      isError: _submitAttempted &&
                          _nameController.text.trim().isEmpty,
                      child: TextField(
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          hintText: 'Course name',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_submitAttempted && _nameController.text.trim().isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          'Course name is required',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),

                    SizedBox(height: 16.h),

                    _buildFieldContainer(
                      isError: _submitAttempted &&
                          _categoryController.text.trim().isEmpty,
                      child: TextField(
                        controller: _categoryController,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          hintText: 'Vehicle category',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_submitAttempted &&
                        _categoryController.text.trim().isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          'Vehicle category is required',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),

                    SizedBox(height: 16.h),

                    _buildFieldContainer(
                      isError: _submitAttempted &&
                          (_priceController.text.trim().isEmpty ||
                              (double.tryParse(_priceController.text.trim()) ==
                                  null) ||
                              (double.tryParse(_priceController.text.trim())! <=
                                  0)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: 'Price',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  fontSize: 16.sp,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '\$',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_submitAttempted &&
                        (_priceController.text.trim().isEmpty ||
                            (double.tryParse(_priceController.text.trim()) ==
                                null) ||
                            (double.tryParse(_priceController.text.trim())! <=
                                0)))
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          'Enter a valid price (> 0)',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),

                    SizedBox(height: 24.h),

                    if (widget.courseIndex != null) ...[
                      Divider(color: Colors.white.withOpacity(0.2)),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: _confirmAndDelete,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Delete Course',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Icon(
                                CupertinoIcons.trash,
                                color: Colors.redAccent,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: 16.h),
                  ],
                ),
              ),

              if (_isSaving) ...[
                Positioned.fill(child: Container(color: Colors.black54)),
                Center(child: CircularProgressIndicator(color: Colors.white)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
