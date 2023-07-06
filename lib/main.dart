import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:namastethailand/SplashScreen/splashScreen.dart';
import 'package:namastethailand/Utility/sharePrefrences.dart';
import 'package:namastethailand/core/themes/app_themes.dart';
import 'package:namastethailand/routes/routes.dart';
import 'AddShop/add_shop.dart';
import 'CityInformation/cityInformation.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AppPreferences.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(

     child: MyApp(),
  )

  );
}
// new branch>>>
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context,child) {
        return MaterialApp(
          title: 'Namaste Thailand',
          theme:AppThemes.light,
          darkTheme: AppThemes.dark,
          home: const SplashScreen(),

          builder: EasyLoading.init(),

          debugShowCheckedModeBanner: false,




        );
      }
    );
  }
}

