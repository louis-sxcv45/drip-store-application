import 'package:drip_store/model/api/api_service.dart';
import 'package:drip_store/model/sqlite/local_database_service.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/provider/bottom_navigation_provider.dart';
import 'package:drip_store/provider/greeting_time_provider.dart';
import 'package:drip_store/provider/history_provider.dart';
import 'package:drip_store/provider/list_cart_provider.dart';
import 'package:drip_store/provider/payment_provider.dart';
import 'package:drip_store/provider/product_list_provider.dart';
import 'package:drip_store/provider/profile_user_provider.dart';
import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:drip_store/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await initializeDateFormatting('id_ID', 'symbols');
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiService()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (context) => GreetingTimeProvider()),
        ChangeNotifierProvider(
          create: (context) => ProfileUserProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductListProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(create: (context)=>ListCartProvider(
          LocalDatabaseService()
        )),
        ChangeNotifierProvider(create: (context) => PaymentProvider(
          context.read<ApiService>()
        )),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(context.read<ApiService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: ColorsManager.seasalt,
        textTheme: GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(backgroundColor: ColorsManager.seasalt),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.ubuntuTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
