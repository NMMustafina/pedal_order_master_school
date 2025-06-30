import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:pedal_order_master_school_276_t/aisdfjasfhsajdlf/models/instructor_model.dart';
import 'package:pedal_order_master_school_276_t/provider/jv_servic.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/color_vd.dart';
import 'package:pedal_order_master_school_276_t/widgets/add_course_bottomSheet.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Gnj extends StatelessWidget {
  const Gnj({Key? key}) : super(key: key);

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

  Widget _buildCourseCard(BuildContext context, CourseModel course, int index) {
    final instructorBox = Hive.box<InstructorModel>('instructors');
    final instructorNames = course.instructorIds
        .map((id) => instructorBox.get(id)?.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    return GestureDetector(
      onTap: () async {
        final initialInstructors = course.instructorIds
            .map((id) => instructorBox.get(id))
            .whereType<InstructorModel>()
            .toList();

        final initialData = CourseData(
          startDate: course.startDate,
          endDate: course.endDate,
          selectedInstructors: initialInstructors,
          courseName: course.courseName,
          vehicleCategory: course.vehicleCategory,
          price: course.price,
        );

        final updated = await showModalBottomSheet<CourseData>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => AddCourseBottomSheet(
            initialData: initialData,
            courseIndex: index,
          ),
        );

        if (updated != null) {
          final newInstructorIds =
              updated.selectedInstructors.map((i) => i.id).toList();

          final updatedModel = CourseModel(
            id: course.id,
            startDate: updated.startDate,
            endDate: updated.endDate,
            instructorIds: newInstructorIds,
            courseName: updated.courseName,
            vehicleCategory: updated.vehicleCategory,
            price: updated.price,
          );
          Provider.of<CourseProvider>(context, listen: false)
              .updateCourse(index, updatedModel);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(12.r),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.courseName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Vehicle Category:',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Text(
                  course.vehicleCategory,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Start Date:',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Text(
                  _formatDate(course.startDate),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'End Date:',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Text(
                  _formatDate(course.endDate),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Price:',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Text(
                  '\$${course.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: const Color(0xFF1D914A),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Instructors:',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              instructorNames.isEmpty ? 'None' : instructorNames.join(', '),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteBlock() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.white.withOpacity(0.3),
                thickness: 1.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Kofi Annan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Divider(
                color: Colors.white.withOpacity(0.3),
                thickness: 1.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          '"Knowledge is power. Information is liberating. '
          'Education is the premise of progress."',
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'COURSES',
          style: TextStyle(
            color: Colordgfajskdnfk.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Consumer<CourseProvider>(
                builder: (context, provider, child) {
                  final courses = provider.courses;
                  if (courses.isEmpty) {
                    return Center(child: _buildQuoteBlock());
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return _buildCourseCard(context, course, index);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        onTap: () async {
          final result = await showModalBottomSheet<CourseData>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddCourseBottomSheet(),
          );

          if (result != null) {
            final newInstructorIds =
                result.selectedInstructors.map((i) => i.id).toList();
            final id = const Uuid().v4();

            final newModel = CourseModel(
              id: id,
              startDate: result.startDate,
              endDate: result.endDate,
              instructorIds: newInstructorIds,
              courseName: result.courseName,
              vehicleCategory: result.vehicleCategory,
              price: result.price,
            );
            Provider.of<CourseProvider>(context, listen: false)
                .addCourse(newModel);
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 86.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1567FF),
                Color(0xFF1F93E6),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Text(
            'Add Course',
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
