
import 'dart:async';
import 'dart:ui';

import 'package:elbess/features/Auth/Presentation/Pages/fill_profile_view.dart';
import 'package:elbess/features/Auth/Presentation/Pages/signup_view.dart';
import 'package:elbess/features/Splashview/Presentation/splashview.dart';
import 'package:elbess/features/chat/views/chat_veiw.dart';
import 'package:elbess/features/productdetail/presentation/product_detail_view.dart';
import 'package:elbess/features/store_page/presentation/store_view.dart';
import 'package:elbess/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // ignore: avoid_print
    print('Flutter error: ${details.exceptionAsString()}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    // ignore: avoid_print
    print('Uncaught async error: $error');
    
    print(stack);
    return true;
  };

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stack) {
    // ignore: avoid_print
    print('Zoned error: $error');
    // ignore: avoid_print
    print(stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
     debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const Splashview(),
    );
  }
}
