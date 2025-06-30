import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/color_vd.dart';
import 'package:provider/provider.dart';

import '../provider/jv_servic.dart';
import 'models/instructor_model.dart';

class Nrvnu extends StatefulWidget {
  const Nrvnu({super.key});

  @override
  State<Nrvnu> createState() => _NrvnuState();
}

class _NrvnuState extends State<Nrvnu> {
  bool showAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable:
              Hive.box<InstructorModel>('instructors').listenable(),
          builder: (context, Box<InstructorModel> box, _) {
            final instructors = box.values.toList();

            final courseProvider = Provider.of<CourseProvider>(context);
            final Set<String> assignedIds = {
              for (var course in courseProvider.courses) ...course.instructorIds
            };

            final availableList = instructors
                .where((ins) => !assignedIds.contains(ins.id))
                .toList();
            final inClassList = instructors
                .where((ins) => assignedIds.contains(ins.id))
                .toList();

            final displayList = showAvailable ? availableList : inClassList;
            return Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                    child: Text(
                      'INSTRUCTORS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showAvailable = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: showAvailable
                                ? Color(0xFF1D914A)
                                : Color(0xFF0F172B).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF1D914A),
                                width: 2.w,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Available',
                                style: TextStyle(
                                  color: showAvailable
                                      ? Colors.white
                                      : Color(0xFF1D914A),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.circle,
                                size: 12.sp,
                                color: showAvailable
                                    ? Colors.white
                                    : Color(0xFF1D914A),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showAvailable = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: !showAvailable
                                ? Color(0xFFFF3B30)
                                : Color(0xFF0F172B).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFFF3B30),
                                width: 2.w,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'In Class',
                                style: TextStyle(
                                  color: !showAvailable
                                      ? Colors.white
                                      : Color(0xFFFF3B30),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.circle,
                                size: 12.sp,
                                color: !showAvailable
                                    ? Colors.white
                                    : Color(0xFFFF3B30),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final ins = displayList[index];
                      return GestureDetector(
                        onTap: () {
                          showAddInstructorSheet(context, instructor: ins);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF0F172B).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border(
                                  bottom: BorderSide(
                                color: Color(0xFF1A7EF2),
                                width: 2.w,
                              )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ins.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Icon(
                                        Icons.circle,
                                        size: 12.sp,
                                        color: ins.isAvailable
                                            ? Color(0xFF1D914A)
                                            : Color(0xFFFF3B30),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Text(
                                        'Vehicle Category: ',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        ins.category,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Weekly Schedule:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  for (var entry in ins.weekly.entries)
                                    if (entry.value != null) ...[
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 2.h),
                                        child: Text(
                                          '${entry.key}: ${entry.value!['start']} - ${entry.value!['end']}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 2.h),
                                        child: Text(
                                          '${entry.key}: No schedule available',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          showAddInstructorSheet(context);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 86.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colordgfajskdnfk.blue,
            borderRadius: BorderRadius.circular(30.r),
            gradient: LinearGradient(
              colors: [
                Color(0xFF1567FF),
                Color(0xFF1F93E6),
              ],
            ),
          ),
          child: Text(
            'Add Instructor',
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

  void showAddInstructorSheet(BuildContext context,
      {InstructorModel? instructor}) {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final TextEditingController nameController =
        TextEditingController(text: instructor?.name ?? '');
    final TextEditingController categoryController =
        TextEditingController(text: instructor?.category ?? '');

    final List<DaySchedule> schedules = List.generate(
      days.length,
      (index) {
        if (instructor != null && instructor.weekly.containsKey(days[index])) {
          final startTime = instructor.weekly[days[index]]?['start'];
          final endTime = instructor.weekly[days[index]]?['end'];

          return DaySchedule(
            start: startTime != null
                ? TimeOfDay(
                    hour: int.parse(startTime.split(":")[0]),
                    minute: int.parse(startTime.split(":")[1]),
                  )
                : null,
            end: endTime != null
                ? TimeOfDay(
                    hour: int.parse(endTime.split(":")[0]),
                    minute: int.parse(endTime.split(":")[1]),
                  )
                : null,
            enabled: true,
          );
        }
        return DaySchedule();
      },
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scrollController) {
          return StatefulBuilder(
            builder: (context, setState) {
              bool isFormValid() {
                if (nameController.text.trim().isEmpty ||
                    categoryController.text.trim().isEmpty) return false;
                for (var sch in schedules) {
                  if (sch.enabled) {
                    if (sch.start == null || sch.end == null) return false;
                  }
                }
                return true;
              }

              return Container(
                margin: EdgeInsets.only(top: 24.h),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        instructor != null
                            ? 'Edit Instructor'
                            : 'Add a new instructor with weekly schedule.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            instructor != null
                                ? 'Edit Instructor'
                                : 'Add Instructor',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: isFormValid()
                                ? () async {
                                    final enteredName =
                                        nameController.text.trim();
                                    final enteredCategory =
                                        categoryController.text.trim();
                                    final selectedSchedules =
                                        <String, Map<String, String>>{};
                                    for (int i = 0; i < days.length; i++) {
                                      final sch = schedules[i];
                                      if (sch.enabled) {
                                        final startStr =
                                            sch.start!.format(context);
                                        final endStr = sch.end!.format(context);
                                        selectedSchedules[days[i]] = {
                                          'start': startStr,
                                          'end': endStr,
                                        };
                                      }
                                    }

                                    final id = instructor?.id ??
                                        DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString();
                                    final instructorData = InstructorModel(
                                      id: id,
                                      name: enteredName,
                                      category: enteredCategory,
                                      weekly: selectedSchedules,
                                    );

                                    final box =
                                        await Hive.openBox<InstructorModel>(
                                            'instructors');
                                    await box.put(id, instructorData);

                                    Navigator.of(context).pop({
                                      'name': enteredName,
                                      'category': enteredCategory,
                                      'weekly': selectedSchedules,
                                    });
                                  }
                                : null,
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: isFormValid()
                                    ? const Color(0xFF1A7EF2)
                                    : Colors.white.withOpacity(0.3),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Color(0xFF0F172B).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF1A7EF2),
                                    width: 2.w,
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: nameController,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 16.sp,
                                  ),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Color(0xFF0F172B).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF1A7EF2),
                                    width: 2.w,
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: categoryController,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Vehicle category',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 16.sp,
                                  ),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Weekly Schedule:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            for (int i = 0; i < days.length; i++) ...[
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        schedules[i].enabled =
                                            !schedules[i].enabled;
                                        if (!schedules[i].enabled) {
                                          schedules[i].start = null;
                                          schedules[i].end = null;
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      schedules[i].enabled
                                          ? 'assets/icons/checkbox_checked.svg'
                                          : 'assets/icons/checkbox_unchecked.svg',
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  SizedBox(
                                    width: 40.w,
                                    child: Text(
                                      days[i],
                                      style: TextStyle(
                                        color: schedules[i].enabled
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.6),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: schedules[i].enabled
                                        ? () async {
                                            final initial =
                                                schedules[i].start ??
                                                    TimeOfDay.now();
                                            final picked =
                                                await showCustomTimePicker(
                                              context: context,
                                              initialTime: initial,
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                schedules[i].start = picked;
                                                if (schedules[i].end != null &&
                                                    (schedules[i].end!.hour <
                                                            picked.hour ||
                                                        (schedules[i]
                                                                    .end!
                                                                    .hour ==
                                                                picked.hour &&
                                                            schedules[i]
                                                                    .end!
                                                                    .minute <
                                                                picked
                                                                    .minute))) {
                                                  schedules[i].end = null;
                                                }
                                              });
                                            }
                                          }
                                        : null,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                      child: Text(
                                        schedules[i].start != null
                                            ? schedules[i]
                                                .start!
                                                .format(context)
                                            : 'Start Time',
                                        style: TextStyle(
                                          color: schedules[i].enabled
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.6),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 24.w),
                                  Text(
                                    '—',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(width: 24.w),
                                  GestureDetector(
                                    onTap: schedules[i].enabled
                                        ? () async {
                                            final initialEnd =
                                                schedules[i].end ??
                                                    TimeOfDay.now();
                                            final pickedEnd =
                                                await showCustomTimePicker(
                                              context: context,
                                              initialTime: initialEnd,
                                            );
                                            if (pickedEnd != null) {
                                              setState(() {
                                                // Если новый end раньше start — сброс обоих:
                                                if (schedules[i].start !=
                                                        null &&
                                                    (pickedEnd.hour <
                                                            schedules[i]
                                                                .start!
                                                                .hour ||
                                                        (pickedEnd.hour ==
                                                                schedules[i]
                                                                    .start!
                                                                    .hour &&
                                                            pickedEnd.minute <
                                                                schedules[i]
                                                                    .start!
                                                                    .minute))) {
                                                  schedules[i].start = null;
                                                  schedules[i].end = null;
                                                } else {
                                                  schedules[i].end = pickedEnd;
                                                }
                                              });
                                            }
                                          }
                                        : null,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                      child: Text(
                                        schedules[i].end != null
                                            ? schedules[i].end!.format(context)
                                            : 'End Time',
                                        style: TextStyle(
                                          color: schedules[i].enabled
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.6),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                            ],
                            if (instructor != null)
                              GestureDetector(
                                onTap: () async {
                                  final shouldDelete =
                                      await showCupertinoDialog<bool>(
                                    context: context,
                                    builder: (ctx) => CupertinoTheme(
                                      data: CupertinoThemeData(
                                          brightness: Brightness.dark),
                                      child: CupertinoAlertDialog(
                                        title: Text('Delete Forever?'),
                                        content: Text(
                                          "This item will be gone for good.Do you want to continue?",
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text('Cancel'),
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(false),
                                          ),
                                          CupertinoDialogAction(
                                            isDestructiveAction: true,
                                            child: Text('Delete'),
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(true),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );

                                  if (shouldDelete == true) {
                                    final box = Hive.box<InstructorModel>(
                                        'instructors');
                                    await box.delete(instructor?.id);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0F172B).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: const Color(0xFFFF3B30),
                                        width: 2.w,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Delete Instructor',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFFF3B30),
                                        ),
                                      ),
                                      SvgPicture.asset(
                                          'assets/icons/delete.svg'),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<TimeOfDay?> showCustomTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) {
    TimeOfDay selectedTime = initialTime;

    return showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Center(
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 8.h),
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2.h),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      height: 200.h,
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: DateTime(
                            0,
                            0,
                            0,
                            initialTime.hour,
                            initialTime.minute,
                          ),
                          use24hFormat: true,
                          backgroundColor: Colors.transparent,
                          onDateTimeChanged: (DateTime newDateTime) {
                            selectedTime = TimeOfDay(
                              hour: newDateTime.hour,
                              minute: newDateTime.minute,
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                      child: Row(
                        children: [
                          // Кнопка «Cancel»
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(ctx).pop(null);
                              },
                              child: Container(
                                height: 56.h,
                                alignment: Alignment.center,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(ctx).pop(selectedTime);
                              },
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2185F3),
                                  borderRadius: BorderRadius.circular(28.r),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Instructor {
  final String name;
  final String category;
  final Map<String, String> schedule;
  final bool isAvailable;

  Instructor({
    required this.name,
    required this.category,
    required this.schedule,
    required this.isAvailable,
  });
}

class DaySchedule {
  bool enabled;
  TimeOfDay? start;
  TimeOfDay? end;

  DaySchedule({this.enabled = false, this.start, this.end});
}
