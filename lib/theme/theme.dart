import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
part 'extention.dart';
part 'text_styles.dart';
// [icon]
part 'app_icons.dart';
// [color]
part 'color/app_color.dart';

class AppTheme {
  static final ThemeData apptheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey.shade50,
      backgroundColor: HongsiColor.white,
      brightness: Brightness.light,
      //primaryColor: AppColor.primary,
      cardColor: AppColor.white,
      unselectedWidgetColor: Colors.grey,
      bottomAppBarColor: Colors.white,
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: AppColor.white),
      appBarTheme: AppBarTheme(
        backgroundColor: HongsiColor.white,
        iconTheme: IconThemeData(
          color: HongsiColor.persimmon,
        ),
        elevation: 0,
        titleTextStyle: GoogleFonts.gothicA1(
          fontSize: 17,
          fontWeight: FontWeight.w300,
          color: HongsiColor.woodsmoke,
        ),
        // ignore: deprecated_member_use
        toolbarTextStyle: const TextStyle(
            color: Colors.black, fontSize: 26, fontStyle: FontStyle.normal),
      ),
      textTheme: TextTheme(),
      tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 2.5,
            color: HongsiColor.persimmon,
          ),
          insets: EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
        ),
        labelStyle:
            TextStyles.titleStyle.copyWith(color: HongsiColor.persimmon),
        unselectedLabelColor: AppColor.darkGrey,
        unselectedLabelStyle:
            TextStyles.titleStyle.copyWith(color: AppColor.darkGrey),
        labelColor: HongsiColor.persimmon,
        labelPadding: const EdgeInsets.symmetric(vertical: 2.0),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: HongsiColor.dodgetBlue,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textStyle: MaterialStateProperty.all(TextStyles.persimmon16Bold),
        side: MaterialStateProperty.all(
            BorderSide(width: 0.5, color: HongsiColor.persimmon)),
      )),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.all(10),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: AppColor.white,
        collapsedTextColor: AppColor.darkGrey,
        iconColor: AppColor.persimmon,
        textColor: AppColor.darkGrey,
      ),
      iconTheme: IconThemeData(color: HongsiColor.persimmon),
      // inputDecorationTheme : textField Theme
      inputDecorationTheme: InputDecorationTheme(),
      colorScheme: const ColorScheme(
          background: Colors.white,
          onPrimary: Colors.white,
          onBackground: Colors.black,
          onError: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          primary: AppColor.primary,
          secondary: AppColor.secondary,
          surface: Colors.white,
          brightness: Brightness.light));

  /*
  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(
        blurRadius: 10,
        offset: const Offset(5, 5),
        color: AppTheme.apptheme.colorScheme.secondary,
        spreadRadius: 1)
  ];

  */
  static BoxDecoration softDecoration =
      const BoxDecoration(boxShadow: <BoxShadow>[
    BoxShadow(
        blurRadius: 8,
        offset: Offset(5, 5),
        color: Color(0xffe2e5ed),
        spreadRadius: 5),
    BoxShadow(
        blurRadius: 8,
        offset: Offset(-5, -5),
        color: Color(0xffffffff),
        spreadRadius: 5)
  ], color: Color(0xfff1f3f6));
}

String get description {
  return '';
}
