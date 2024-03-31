import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'core/constants/app_constants.dart';
import 'core/data/dataproviders/dio_client.dart';
import 'features/splash/presentation/view/logo_initialization.dart';
import 'on_generate_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return MaterialApp(
        title: APP_TITLE,
        onGenerateRoute: appRouter.onGeneratedRoute,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LogoInitialization(),
      );
    });
  }
}
