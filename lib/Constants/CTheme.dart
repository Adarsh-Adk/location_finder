import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_finder/Constants/CColor.dart';
class CTheme{

  static ThemeData get lightTheme{
    return ThemeData(scaffoldBackgroundColor: Colors.transparent,appBarTheme: AppBarTheme(elevation:0,backgroundColor: Colors.transparent,brightness: Brightness.dark),primaryColor:CColor.mainColorLight,backgroundColor: CColor.bgColorLight,textTheme: TextTheme(headline1: GoogleFonts.encodeSans(fontSize: 20,color:CColor.mainColorLight,fontWeight: FontWeight.w700)));
  }
  static ThemeData get darkTheme{
    return ThemeData(scaffoldBackgroundColor: Colors.transparent,appBarTheme: AppBarTheme(elevation:0,backgroundColor: Colors.transparent,brightness: Brightness.dark),primaryColor:CColor.mainColorDark,backgroundColor: CColor.bgColorDark,textTheme: TextTheme(headline1: GoogleFonts.play(fontSize: 20,color:CColor.mainColorDark,fontWeight: FontWeight.w700)));
  }
}