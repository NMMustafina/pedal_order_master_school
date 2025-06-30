import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pedal_order_master_school_276_t/provider/jv_servic.dart';
import 'package:pedal_order_master_school_276_t/provider/transaction_service.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/botbar_fg.dart';
import 'package:pedal_order_master_school_276_t/sdojgjv/color_vd.dart';
import 'package:provider/provider.dart';

import 'aisdfjasfhsajdlf/models/instructor_model.dart';
import 'aisdfjasfhsajdlf/models/transaction_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(InstructorModelAdapter());
  await Hive.openBox<InstructorModel>('instructors');

  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<TransactionModel>('transactions');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    _requestInAppReview();
  }

  Future<void> _requestInAppReview() async {
    if (await _inAppReview.isAvailable()) {
      try {
        await _inAppReview.requestReview();
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CourseProvider()),
            ChangeNotifierProvider(create: (_) => TransactionService()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pedal',
            theme: ThemeData(
              fontFamily: 'SulphurPoint',
              appBarTheme: const AppBarTheme(
                backgroundColor: Colordgfajskdnfk.background,
              ),
              scaffoldBackgroundColor: Colordgfajskdnfk.background,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            home: const BotomBarasdjasnfjk(),
          ),
        );
      },
    );
  }
}
