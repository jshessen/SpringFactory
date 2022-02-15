/*
ISO 262 -- https://www.iso.org/standard/4167.html

This International Standard specifies selected sizes for screws, bolts and nuts in the diameter range from 1 mm to 64 mm of ISO general purpose metric screw threads (M) having basic profile according to ISO 68-1.

These selected sizes are recommended also for general engineering use.

These screw threads are selected from ISO 261.

https://en.wikipedia.org/wiki/ISO_metric_screw_thread#Preferred_sizes
*/


// Name
// Nominal Diameter, D (mm)
// Series (R10/R20)
// Pitch, P (mm)
//      Course
//      Fine
//      Fine Alternate
R10     =   "R10";
R20     =   "R20";

// Preferred Sizes
//  M 1.0
M1_D            =   1.0;
M1_P            =   0.25;
M1_P_C          =   M1_P;
M1_P_F          =   0.20;
M1              =   [str("M ", M1_D,   " x ", M1_P),     M1_D,   M1_P,     R10];
M1C             =   M1;
M1F             =   [str("M ", M1_D,   " x ", M1_P_F),   M1_D,   M1_P_F,   R10];
M1_ISO_262      =   [M1C, M1F];
//  M 1.2
M1_2_D          =   1.2;
M1_2_P          =   0.25;
M1_2_P_C        =   M1_2_P;
M1_2_P_F        =   0.20;
M1_2            =   [str("M ", M1_2_D, " x ", M1_2_P),   M1_2_D, M1_2_P,   R10];
M1_2C           =   M1_2;
M1_2F           =   [str("M ", M1_2_D, " x ", M1_2_P_F), M1_2_D, M1_2_P_F, R10];
M1_2_ISO_262    =   [M1_2C, M1_2F];
//  M 1.4
M1_4_D          =   1.4;
M1_4_P          =   0.30;
M1_4_P_C        =   M1_4_P;
M1_4_P_F        =   0.20;
M1_4            =   [str("M ", M1_4_D, " x ", M1_4_P),   M1_4_D, M1_4_P,   R20];
M1_4C           =   M1_4;
M1_4F           =   [str("M ", M1_4_D, " x ", M1_4_P_F), M1_4_D, M1_4_P_F, R20];
M1_4_ISO_262    =   [M1_4C, M1_4F];
//  M 1.6
M1_6_D          =   1.6;
M1_6_P          =   0.35;
M1_6_P_C        =   M1_6_P;
M1_6_P_F        =   0.20;
M1_6            =   [str("M ", M1_6_D, " x ", M1_6_P),   M1_6_D, M1_6_P,   R10];
M1_6C           =   M1_6;
M1_6F           =   [str("M ", M1_6_D, " x ", M1_6_P_F), M1_6_D, M1_6_P_F, R10];
M1_6_ISO_262    =   [M1_6C, M1_6F];
//  M 1.8
M1_8_D          =   1.8;
M1_8_P          =   0.35;
M1_8_P_C        =   M1_8_P;
M1_8_P_F        =   0.20;
M1_8            =   [str("M ", M1_8_D, " x ", M1_8_P),   M1_8_D, M1_8_P,   R20];
M1_8C           =   M1_8;
M1_8F           =   [str("M ", M1_8_D, " x ", M1_8_P_F), M1_8_D, M1_8_P_F, R20];
M1_8_ISO_262    =   [M1_8C, M1_8F];
//  M 2.0
M2_D            =   2.0;
M2_P            =   0.40;
M2_P_C          =   M2_P;
M2_P_F          =   0.25;
M2              =   [str("M ", M2_D, " x ",   M2_P),     M2_D,   M2_P,     R10];
M2C             =   M2;
M2F             =   [str("M ", M2_D, " x ",   M2_P_F),   M2_D,   M2_P_F,   R10];
M2_ISO_262      =   [M2C, M2F];
//  M 2.5
M2_5_D          =   2.5;
M2_5_P          =   0.45;
M2_5_P_C        =   M2_5_P;
M2_5_P_F        =   0.35;
M2_5            =   [str("M ", M2_5_D, " x ", M2_5_P),   M2_5_D, M2_5_P,   R10];
M2_5C           =   M2_5;
M2_5F           =   [str("M ", M2_5_D, " x ", M2_5_P_F), M2_5_D, M2_5_P_F, R10];
M2_5_ISO_262    =   [M2_5C, M2_5F];
//  M 3.0
M3_D            =   3.0;
M3_P            =   0.50;
M3_P_C          =   M3_P;
M3_P_F          =   0.35;
M3              =   [str("M ", M3_D, " x ",   M3_P),     M3_D,   M3_P,     R10];
M3C             =   M3;
M3F             =   [str("M ", M3_D, " x ",   M3_P_F),   M3_D,   M3_P_F,   R10];
M3_ISO_262      =   [M3C, M3F];
//  M 3.5
M3_5_D          =   3.5;
M3_5_P          =   0.60;
M3_5_P_C        =   M3_5_P;
M3_5_P_F        =   0.35;
M3_5            =   [str("M ", M3_5_D, " x ", M3_5_P),   M3_5_D, M3_5_P,   R20];
M3_5C           =   M3_5;
M3_5F           =   [str("M ", M3_5_D, " x ", M3_5_P_F), M3_5_D, M3_5_P_F, R20];
M3_5_ISO_262    =   [M3_5C, M3_5F];
//  M 4.0
M4_D            =   4.0;
M4_P            =   0.70;
M4_P_C          =   M4_P;
M4_P_F          =   0.50;
M4              =   [str("M ", M4_D, " x ",   M4_P),     M4_D,   M4_P,     R10];
M4C             =   M4;
M4F             =   [str("M ", M4_D, " x ",   M4_P_F),   M4_D,   M4_P_F,   R10];
M4_ISO_262      =   [M4C, M4F];
//  M 5.0
M5_D            =   5.0;
M5_P            =   0.80;
M5_P_C          =   M5_P;
M5_P_F          =   0.50;
M5              =   [str("M ", M5_D, " x ",   M5_P),     M5_D,   M5_P,     R10];
M5C             =   M5;
M5F             =   [str("M ", M5_D, " x ",   M5_P_F),   M5_D,   M5_P_F,   R10];
M5_ISO_262      =   [M5C, M5F];
//  M 5.5
M5_5_D          =   5.5;
M5_5_P          =   0.90;
M5_5_P_C        =   M5_5_P;
M5_5_P_F        =   0.50;
M5_5            =   [str("M ", M5_5_D, " x ", M5_5_P),   M5_5_D, M5_5_P,   R20];
M5_5C           =   M5_5;
M5_5F           =   [str("M ", M5_5_D, " x ", M5_5_P_F), M5_5_D, M5_5_P_F, R20];
M5_5_ISO_262    =   [M5_5C, M5_5F];
//  M 6.0
M6_D            =   6.0;
M6_P            =   1.00;
M6_P_C          =   M6_P;
M6_P_F          =   0.75;
M6              =   [str("M ", M6_D, " x ",   M6_P),     M6_D,   M6_P,     R10];
M6C             =   M6;
M6F             =   [str("M ", M6_D, " x ",   M6_P_F),   M6_D,   M6_P_F,   R10];
M6_ISO_262      =   [M6C, M6F];
//  M 7.0
M7_D            =   7.0;
M7_P            =   1.00;
M7_P_C          =   M7_P;
M7_P_F          =   0.75;
M7              =   [str("M ", M7_D, " x ",   M7_P),     M7_D,   M7_P,     R20];
M7C             =   M7;
M7F             =   [str("M ", M7_D, " x ",   M7_P_F),   M7_D,   M7_P_F,   R20];
M7_ISO_262      =   [M7C, M7F];
//  M 8.0
M8_D            =   8.0;
M8_P            =   1.25;
M8_P_C          =   M8_P;
M8_P_F          =   1.00;
M8_P_SF         =   0.75;
M8              =   [str("M ", M8_D, " x ",   M8_P),     M8_D,   M8_P,     R10];
M8C             =   M8;
M8F             =   [str("M ", M8_D, " x ",   M8_P_F),   M8_D,   M8_P_F,   R10];
M8SF            =   [str("M ", M8_D, " x ",   M8_P_SF),  M8_D,   M8_P_SF,  R10];
M8_ISO_262      =   [M8C, M8F, M8SF];
//  M 10.0
M10_D           =   10.0;
M10_P           =   1.50;
M10_P_C         =   M10_P;
M10_P_F         =   1.20;
M10_P_SF        =   1.00;
M10             =   [str("M ", M10_D, " x ",  M10_P),    M10_D,  M10_P,    R10];
M10C            =   M10;
M10F            =   [str("M ", M10_D, " x ",  M10_P_F),  M10_D,  M10_P_F,  R10];
M10SF           =   [str("M ", M10_D, " x ",  M10_P_SF), M10_D,  M10_P_SF, R10];
M10_ISO_262     =   [M10C, M10F, M10SF];
//  M 12.0
M12_D           =   12.0;
M12_P           =   1.75;
M12_P_C         =   M12_P;
M12_P_F         =   1.50;
M12_P_SF        =   1.25;
M12             =   [str("M ", M12_D, " x ",  M12_P),    M12_D,  M12_P,    R10];
M12C            =   M12;
M12F            =   [str("M ", M12_D, " x ",  M12_P_F),  M12_D,  M12_P_F,  R10];
M12SF           =   [str("M ", M12_D, " x ",  M12_P_SF), M12_D,  M12_P_SF, R10];
M12_ISO_262     =   [M12C, M12F, M12SF];
//  M 14.0
M14_D           =   14.0;
M14_P           =   2.00;
M14_P_C         =   M14_P;
M14_P_F         =   1.50;
M14             =   [str("M ", M14_D, " x ",  M14_P),    M14_D,  M14_P,    R20];
M14C            =   M14;
M14F            =   [str("M ", M14_D, " x ",  M14_P_F),  M14_D,  M14_P_F,  R20];
M14_ISO_262     =   [M14C, M14F];
//  M 16.0
M16_D           =   16.0;
M16_P           =   2.00;
M16_P_C         =   M16_P;
M16_P_F         =   1.50;
M16             =   [str("M ", M16_D, " x ",  M16_P),    M16_D,  M16_P,    R10];
M16C            =   M16;
M16F            =   [str("M ", M16_D, " x ",  M16_P_F),  M16_D,  M16_P_F,  R10];
M16_ISO_262     =   [M16C, M16F];
//  M 18.0
M18_D           =   18.0;
M18_P           =   2.50;
M18_P_C         =   M18_P;
M18_P_F         =   2.00;
M18_P_SF        =   1.50;
M18             =   [str("M ", M18_D, " x ",  M18_P),    M18_D,  M18_P,    R20];
M18C            =   M18;
M18F            =   [str("M ", M18_D, " x ",  M18_P_F),  M18_D,  M18_P_F,  R20];
M18SF           =   [str("M ", M18_D, " x ",  M18_P_SF), M18_D,  M18_P_SF, R20];
M18_ISO_262     =   [M18C, M18F, M18SF];
//  M 20.0
M20_D           =   20.0;
M20_P           =   2.50;
M20_P_C         =   M20_P;
M20_P_F         =   2.00;
M20_P_SF        =   1.50;
M20             =   [str("M ", M20_D, " x ",  M20_P),    M20_D,  M20_P,    R10];
M20C            =   M20;
M20F            =   [str("M ", M20_D, " x ",  M20_P_F),  M20_D,  M20_P_F,  R10];
M20SF           =   [str("M ", M20_D, " x ",  M20_P_SF), M20_D,  M20_P_SF, R10];
M20_ISO_262     =   [M20C, M20F, M20SF];
//  M 22.0
M22_D           =   22.0;
M22_P           =   2.50;
M22_P_C         =   M22_P;
M22_P_F         =   2.00;
M22_P_SF        =   1.50;
M22             =   [str("M ", M22_D, " x ",  M22_P),    M22_D,  M22_P,    R20];
M22C            =   M22;
M22F            =   [str("M ", M22_D, " x ",  M22_P_F),  M22_D,  M22_P_F,  R20];
M22SF           =   [str("M ", M22_D, " x ",  M22_P_SF), M22_D,  M22_P_SF, R20];
M22_ISO_262     =   [M22C, M22F, M22SF];
//  M 24.0
M24_D           =   24.0;
M24_P           =   3.00;
M24_P_C         =   M24_P;
M24_P_F         =   2.00;
M24             =   [str("M ", M24_D, " x ",  M24_P),    M24_D,  M24_P,    R10];
M24C            =   M24;
M24F            =   [str("M ", M24_D, " x ",  M24_P_F),  M24_D,  M24_P_F,  R10];
M24_ISO_262     =   [M24C, M24F];
//  M 27.0
M27_D           =   27.0;
M27_P           =   3.00;
M27_P_C         =   M27_P;
M27_P_F         =   2.00;
M27             =   [str("M ", M27_D, " x ",  M27_P),    M27_D,  M27_P,    R20];
M27C            =   M27;
M27F            =   [str("M ", M27_D, " x ",  M27_P_F),  M27_D,  M27_P_F,  R20];
M27_ISO_262     =   [M27C, M27F];
//  M 30.0
M30_D           =   30.0;
M30_P           =   3.50;
M30_P_C         =   M30_P;
M30_P_F         =   2.00;
M30             =   [str("M ", M30_D, " x ",  M30_P),    M30_D,  M30_P,    R10];
M30C            =   M30;
M30F            =   [str("M ", M30_D, " x ",  M30_P_F),  M30_D,  M30_P_F,  R10];
M30_ISO_262     =   [M30C, M30F];
//  M 33.0
M33_D           =   33.0;
M33_P           =   3.50;
M33_P_C         =   M33_P;
M33_P_F         =   2.00;
M33             =   [str("M ", M33_D, " x ",  M33_P),    M33_D,  M33_P,    R20];
M33C            =   M33;
M33F            =   [str("M ", M33_D, " x ",  M33_P_F),  M33_D,  M33_P_F,  R20];
M33_ISO_262     =   [M33C, M33F];
//  M 36.0
M36_D           =   36.0;
M36_P           =   4.00;
M36_P_C         =   M36_P;
M36_P_F         =   3.00;
M36             =   [str("M ", M36_D, " x ",  M36_P),    M36_D,  M36_P,    R10];
M36C            =   M36;
M36F            =   [str("M ", M36_D, " x ",  M36_P_F),  M36_D,  M36_P_F,  R10];
M36_ISO_262     =   [M36C, M36F];
//  M 39.0
M39_D           =   39.0;
M39_P           =   4.00;
M39_P_C         =   M39_P;
M39_P_F         =   3.00;
M39             =   [str("M ", M39_D, " x ",  M39_P),    M39_D,  M39_P,    R20];
M39C            =   M39;
M39F            =   [str("M ", M39_D, " x ",  M39_P_F),  M39_D,  M39_P_F,  R20];
M39_ISO_262     =   [M39C, M39F];
//  M 42.0
M42_D           =   42.0;
M42_P           =   4.50;
M42_P_C         =   M42_P;
M42_P_F         =   3.00;
M42             =   [str("M ", M42_D, " x ",  M42_P),    M42_D,  M42_P,    R10];
M42C            =   M42;
M42F            =   [str("M ", M42_D, " x ",  M42_P_F),  M42_D,  M42_P_F,  R10];
M42_ISO_262     =   [M42C, M42F];
//  M 45.0
M45_D           =   35.0;
M45_P           =   4.50;
M45_P_C         =   M45_P;
M45_P_F         =   3.00;
M45             =   [str("M ", M45_D, " x ",  M45_P),    M45_D,  M45_P,    R20];
M45C            =   M45;
M45F            =   [str("M ", M45_D, " x ",  M45_P_F),  M45_D,  M45_P_F,  R20];
M45_ISO_262     =   [M45C, M45F];
//  M 48.0
M48_D           =   48.0;
M48_P           =   5.00;
M48_P_C         =   M48_P;
M48_P_F         =   3.00;
M48             =   [str("M ", M48_D, " x ",  M48_P),    M48_D,  M48_P,    R10];
M48C            =   M48;
M48F            =   [str("M ", M48_D, " x ",  M48_P_F),  M48_D,  M48_P_F,  R10];
M48_ISO_262     =   [M48C, M48F];
//  M 52.0
M52_D           =   52.0;
M52_P           =   5.00;
M52_P_C         =   M52_P;
M52_P_F         =   4.00;
M52             =   [str("M ", M52_D, " x ",  M52_P),    M52_D,  M52_P,    R20];
M52C            =   M52;
M52F            =   [str("M ", M52_D, " x ",  M52_P_F),  M52_D,  M52_P_F,  R20];
M52_ISO_262     =   [M52C, M52F];
//  M 56.0
M56_D           =   56.0;
M56_P           =   5.50;
M56_P_C         =   M56_P;
M56_P_F         =   4.00;
M56             =   [str("M ", M56_D, " x ",  M56_P),    M56_D,  M56_P,    R10];
M56C            =   M56;
M56F            =   [str("M ", M56_D, " x ",  M56_P_F),  M56_D,  M56_P_F,  R10];
M56_ISO_262     =   [M56C, M56F];
//  M 60.0
M60_D           =   60.0;
M60_P           =   5.50;
M60_P_C         =   M60_P;
M60_P_F         =   4.00;
M60             =   [str("M ", M60_D, " x ",  M60_P),    M60_D,  M60_P,    R20];
M60C            =   M60;
M60F            =   [str("M ", M60_D, " x ",  M60_P_F),  M60_D,  M60_P_F,  R20];
M60_ISO_262     =   [M60C, M60F];
//  M 64.0
M64_D           =   64.0;
M64_P           =   6.00;
M64_P_C         =   M64_P;
M64_P_F         =   4.00;
M64             =   [str("M ", M64_D, " x ",  M64_P),    M64_D,  M64_P,    R10];
M64C            =   M64;
M64F            =   [str("M ", M64_D, " x ",  M64_P_F),  M64_D,  M64_P_F,  R10];
M64_ISO_262     =   [M64C, M64F];

ISO_262         =   [M1_ISO_262,M1_2_ISO_262,M1_4_ISO_262,M1_6_ISO_262,M1_8_ISO_262,M2_ISO_262,M2_5_ISO_262,M3_ISO_262,M3_5_ISO_262,M4_ISO_262,M5_ISO_262,M5_5_ISO_262,M6_ISO_262,M7_ISO_262,M8_ISO_262,M10_ISO_262,M12_ISO_262,M14_ISO_262,M16_ISO_262,M18_ISO_262,M20_ISO_262,M22_ISO_262,M24_ISO_262,M27_ISO_262,M30_ISO_262,M33_ISO_262,M36_ISO_262,M39_ISO_262,M42_ISO_262,M45_ISO_262,M48_ISO_262,M52_ISO_262,M56_ISO_262,M60_ISO_262,M64_ISO_262];

ISO_262_R10     =   [M1_ISO_262,M1_2_ISO_262,M1_6_ISO_262,M2_ISO_262,M2_5_ISO_262,M3_ISO_262,M4_ISO_262,M5_ISO_262,M6_ISO_262,M8_ISO_262,M10_ISO_262,M12_ISO_262,M16_ISO_262,M20_ISO_262,M24_ISO_262,M30_ISO_262,M36_ISO_262,M42_ISO_262,M48_ISO_262,M56_ISO_262,M64_ISO_262];
ISO_262_R20     =  [M1_4_ISO_262,M1_8_ISO_262,M3_5_ISO_262,M5_5_ISO_262,M7_ISO_262,M14_ISO_262,M18_ISO_262,M22_ISO_262,M27_ISO_262,M33_ISO_262,M39_ISO_262,M45_ISO_262,M52_ISO_262,M60_ISO_262];

//echo(ISO_262);