
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:pedal_order_master_school_276_t/aisdfjasfhsajdlf/models/instructor_model.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/color_vd.dart';

class SelectInstructorsSheet extends StatefulWidget {
  final List<InstructorModel> initiallySelected;

  const SelectInstructorsSheet({
    Key? key,
    this.initiallySelected = const [],
  }) : super(key: key);

  @override
  _SelectInstructorsSheetState createState() => _SelectInstructorsSheetState();
}

class _SelectInstructorsSheetState extends State<SelectInstructorsSheet> {
  List<InstructorModel> _allInstructors = [];
  final Set<String> _selectedIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    for (var inst in widget.initiallySelected) {
      _selectedIds.add(inst.id);
    }
    _loadInstructorsFromHive();
  }

  Future<void> _loadInstructorsFromHive() async {
    setState(() => _isLoading = true);

    final box = Hive.box<InstructorModel>('instructors');
    final list = box.values.toList();

    setState(() {
      _allInstructors = list;
      _isLoading = false;
    });
  }

  void _onInstructorTap(InstructorModel instructor) {
    setState(() {
      if (_selectedIds.contains(instructor.id)) {
        _selectedIds.remove(instructor.id);
      } else {
        _selectedIds.add(instructor.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png', 
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                child: Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pop(<InstructorModel>[]),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Select Instructors',
                      style: TextStyle(
                        color: Colordgfajskdnfk.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              else if (_allInstructors.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Oops… No Instructors',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 24.h),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _allInstructors.length,
                    itemBuilder: (ctx, idx) {
                      final inst = _allInstructors[idx];
                      final isChecked = _selectedIds.contains(inst.id);

                      return Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 8.h),
                        child: GestureDetector(
                          onTap: () => _onInstructorTap(inst),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(15, 23, 43, 0.2),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border(
                                bottom: BorderSide(
                                  color: const Color(0xFF1A7EF2),
                                  width: 2.r,
                                ),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        inst.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),

                                      Text(
                                        'Vehicle Category: ${inst.category}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),

                                      Text(
                                        'Weekly Schedule:',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),

                                      for (final entry
                                          in inst.weekly.entries) ...[
                                        Text(
                                          '${entry.key}: ${entry.value['start']}–${entry.value['end']}',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 4.h),
                                    ],
                                  ),
                                ),

                                Positioned(
                                  top: 12.h,
                                  right: 12.w,
                                  child: Container(
                                    width: 24.w,
                                    height: 24.h,
                                    decoration: BoxDecoration(
                                      color: isChecked
                                          ? Colordgfajskdnfk.blue
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.6),
                                        width: 1.sp,
                                      ),
                                    ),
                                    child: isChecked
                                        ? Icon(
                                            Icons.check,
                                            size: 16.sp,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colordgfajskdnfk.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    minimumSize: Size(double.infinity, 48.h),
                  ),
                  onPressed: () {
                    final selectedModels = _allInstructors
                        .where((inst) => _selectedIds.contains(inst.id))
                        .toList();
                    Navigator.of(context).pop(selectedModels);
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
