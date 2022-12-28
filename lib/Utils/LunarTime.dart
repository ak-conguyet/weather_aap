
import 'dart:math';

const double PI = 3.1415926535897932;

class LunarTime{
   late int day;
   late int month;
   late int year;

   // final List _can = ["Giáp", "Ất", "Bính", "Đinh", "Mậu","Kỷ","Canh", "Tân", "Nhâm", "Quí",];
   // final List _chi = ["Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi", "Thân", "Dậu","Tuất", "Hợi",];
   final List _can = ["甲/Giáp", "乙/Ất", "丙/Bính", "丁/Đinh", "戊/Mậu","己/Kỷ","庚/Canh", "辛/Tân", "壬/Nhâm", "癸/Quí",];
   final List _chi = ["子/Tý", "丑/Sửu", "寅/Dần", "卯/Mão", "辰/Thìn", "巳/Tỵ", "午/Ngọ", "未Mùi", "申/Thân", "酉/Dậu","戌/Tuất", "亥/Hợi",];
   final List _tietKhi = ["春分/Xuân phân", "清明/Thanh minh", "穀雨/Cốc vũ", "立夏/Lập hạ", "小滿/Tiểu mãn", "芒種/Mang chủng", "夏至/Hạ chí", "小暑/Tiểu thử",
     "大暑/Đại thử", "立秋/Lập thu", "處暑/Xử thử", "白露/Bạch lộ", "秋分/Thu phân", "寒露/Hàn lộ", "霜降/Sương giáng", "立冬/Lập đông",
     "小雪/Tiểu tuyết", "大雪/Đại tuyết", "冬至/Đông chí", "小寒/Tiểu hàn", "大寒/Đại hàn", "立春/Lập xuân", "雨水/Vũ thủy", "驚蟄Kinh trập",];

   LunarTime({required this.day, required this.month, required this.year}){
   }

   static LunarTime now(){
     DateTime current = DateTime.now();
     return _convertSolar2Lunar(current.day, current.month, current.year);
   }

   static int _jdFromDate(int dd, int mm, int yy) {
     double a = ((14 - mm) / 12).floorToDouble();
     double y = yy + 4800 - a;
     double m = mm + 12 * a - 3;
     double jd = dd + ((153 * m + 2) / 5).floorToDouble() + 365 * y + (y / 4).floorToDouble() - (y / 100).floorToDouble() + (y / 400).floorToDouble() - 32045;
     if (jd < 2299161) {
       jd = dd + ((153 * m + 2) / 5).floorToDouble() + 365 * y + (y / 4).floorToDouble() - 32083;
     }
     return jd.toInt();
   }

   static double _getLunarMonth11(int yy, int timeZone) {
     int off = _jdFromDate(31, 12, yy) - 2415021;
     int k = (off / 29.530588853).floorToDouble().toInt();
     double nm = _getNewMoonDay(k, timeZone);
     double sunLong = _getSunLongitude(nm, timeZone); // sun longitude at local midnight
     if (sunLong >= 9) {
       nm = _getNewMoonDay(k - 1, timeZone);
     }
     return nm;
   }

   static double _getSunLongitude(double jdn, int timeZone) {
     double T, T2, dr, M, L0, DL, L;
     T = (jdn - 2451545.5 - timeZone / 24) / 36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
     T2 = T * T;
     dr = PI / 180; // degree to radian
     M = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048 * T * T2; // mean anomaly, degree
     L0 = 280.46645 + 36000.76983 * T + 0.0003032 * T2; // mean longitude, degree
     DL = (1.914600 - 0.004817 * T - 0.000014 * T2) * sin(dr * M);
     DL = DL + (0.019993 - 0.000101 * T) * sin(dr * 2 * M) + 0.000290 * sin(dr * 3 * M);
     L = L0 + DL; // true longitude, degree
     double omega = 125.04 - 1934.136 * T;
     L = L - 0.00569 - 0.00478 * sin(omega * dr);
     L = L * dr;
     L = L - PI * 2 * ((L / (PI * 2)).floorToDouble()); // Normalize to (0, 2*PI)
     return (L / PI * 6);
   }

   static LunarTime _convertSolar2Lunar(int day, int month, int year,{int timeZone:7}) {
     int dayNumber = _jdFromDate(day, month, year);
     int k = ((dayNumber - 2415021.076998695) / 29.530588853).floorToDouble().toInt();
     double monthStart = _getNewMoonDay(k + 1, timeZone);
     if (monthStart > dayNumber) {
       monthStart = _getNewMoonDay(k, timeZone);
     }
     double a11 = _getLunarMonth11(year, timeZone);
     double b11 = a11;
     int lunarYear = 0;
     if (a11 >= monthStart) {
       lunarYear = year;
       a11 = _getLunarMonth11(year - 1, timeZone);
     } else {
       lunarYear = year + 1;
       b11 = _getLunarMonth11(year + 1, timeZone);
     }
     int lunarDay = (dayNumber - monthStart + 1).toInt();
     int diff = ((monthStart - a11) / 29).floorToDouble().toInt();
     int lunarLeap = 0;
     int lunarMonth = diff + 11;
     if (b11 - a11 > 365) {
       int leapMonthDiff = _getLeapMonthOffset(a11, timeZone);
       if (diff >= leapMonthDiff) {
         lunarMonth = diff + 10;
         if (diff == leapMonthDiff) {
           lunarLeap = 1;
         }
       }
     }
     if (lunarMonth > 12) {
       lunarMonth = lunarMonth - 12;
     }
     if (lunarMonth >= 11 && diff < 4) {
       lunarYear -= 1;
     }

     return  LunarTime(day: lunarDay, month: lunarMonth, year: lunarYear);  //date.getTime();
   }

   static int _getLeapMonthOffset(double a11, int timeZone) {
     int k = ((a11 - 2415021.076998695) / 29.530588853 + 0.5).floor();
     double last = 0;
     int i = 1; // We start with the month following lunar month 11
     double arc = _getSunLongitude(_getNewMoonDay(k + i, timeZone), timeZone);
     do {
       last = arc;
       i = i + 1;
       arc = _getSunLongitude(_getNewMoonDay(k + i, timeZone), timeZone);
     } while (arc != last && i < 14);
     return i - 1;
   }

   static double _getNewMoonDay(int k, int timeZone) {
     double T, T2, T3, dr, Jd1, M, Mpr, F, C1, deltat, JdNew;
     T = k / 1236.85; // Time in Julian centuries from 1900 January 0.5
     T2 = T * T;
     T3 = T2 * T;
     dr = PI / 180;
     Jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * T2 - 0.000000155 * T3;
     Jd1 = Jd1 + 0.00033 * sin((166.56 + 132.87 * T - 0.009173 * T2) * dr); // Mean new moon
     M = 359.2242 + 29.10535608 * k - 0.0000333 * T2 - 0.00000347 * T3; // Sun"s mean anomaly
     Mpr = 306.0253 + 385.81691806 * k + 0.0107306 * T2 + 0.00001236 * T3; // Moon"s mean anomaly
     F = 21.2964 + 390.67050646 * k - 0.0016528 * T2 - 0.00000239 * T3; // Moon"s argument of latitude
     C1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M);
     C1 = C1 - 0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr);
     C1 = C1 - 0.0004 * sin(dr * 3 * Mpr);
     C1 = C1 + 0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + Mpr));
     C1 = C1 - 0.0074 * sin(dr * (M - Mpr)) + 0.0004 * sin(dr * (2 * F + M));
     C1 = C1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006 * sin(dr * (2 * F + Mpr));
     C1 = C1 + 0.0010 * sin(dr * (2 * F - Mpr)) + 0.0005 * sin(dr * (2 * Mpr + M));
     if (T < -11) {
       deltat = 0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3 - 0.000000081 * T * T3;
     } else {
       deltat = -0.000278 + 0.000265 * T + 0.000262 * T2;
     }
     JdNew = Jd1 + C1 - deltat;
     return (JdNew + 0.5 + timeZone / 24).floorToDouble();
   }

   String toString(){
     return '$day/$month/$year';
   }

   String toStringVi(){
     return '$day 日/$month 月/$year 年';
   }

   String canChiNgay(){
     DateTime current = DateTime.now();
     int jd = _jdFromDate(current.day, current.month, current.year);
     return '${_can[((jd + 9.5).toInt() % 10)]} ${_chi[((jd + 1.5).toInt() % 12)]}';
   }

   String tietKhi(){
     DateTime current = DateTime.now();
     int jd = _jdFromDate(current.day, current.month, current.year);
     return _tietKhi[(_getSunLongitude(jd.toDouble() ,7) * 2 ).floor()];
   }

   String canChiNam() {
     int can = (year + 6) % 10;
     int chi = (year + 8) % 12;
     return _can[can] + " " + _chi[chi];
   }

   String canChiThang() {
     int can = ((year * 12) + month + 3) % 10;
     int chi = (month + 1) % 12;
     String canchithang = _can[can] + " " + _chi[chi];
     return canchithang;
   }

}