import 'package:Molhem/blocs/auth_status_bloc/auth_status_bloc.dart';
import 'package:Molhem/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:Molhem/screens/splash_screen.dart';
import 'package:Molhem/wrappers/authentication_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'blocs/register_bloc/register_bloc.dart';
import 'core/helpers/theme_helper.dart';

Future<void> main() async{
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  PermissionStatus status = await Permission.microphone.status;

  if (!status.isGranted) {
  } else {
    await Permission.microphone.request();
  }

  await EasyLocalization.ensureInitialized();
  runApp(
      EasyLocalization(
        child: MyWidget(),
        supportedLocales: [Locale('en', ''), Locale('ar', '')],
        path: "assets/lang",
        fallbackLocale: Locale('en', ''),
      )
  );
}

// Future<void> loadFont() async {
//   await Future.wait([
//     await rootBundle.load('assets/fonts/YourFontFile.ttf'),
//   ]);
// }
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: AuthStatusBloc()),
        BlocProvider.value(value: NotificationsBloc()),
      ],
      child: ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor: Color(0xff7ea5ad),
                  elevation: 0
                ),

                // fontFamily: context.locale.languageCode == 'ar' ? 'Molhem' : 'sans-serif',


              ),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              title: 'Molhem',
//             ),
              home: AuthenticationWrapper(),
            );
          }),
    );
  }
}
