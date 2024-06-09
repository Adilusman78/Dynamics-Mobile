page 84025 DYM_SettingsAssignmentOverview
{
    Caption = 'Settings Assignment Overview';
    UsageCategory = Administration;
    ApplicationArea = All;
    DataCaptionExpression = Rec.Code;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = true;
    PageType = List;
    SourceTable = DYM_SettingsAssignment;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                FreezeColumn = "Device Setup Code";

                field("Device Role Code."; Rec."Device Role Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Device Group Code"; Rec."Device Group Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Device Setup Code"; Rec."Device Setup Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Field1; GetSettingValue(1))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[1];
                    visible = MATRIX_CELLDATA_VISIBLE_1;
                }
                field(Field2; GetSettingValue(2))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[2];
                    visible = MATRIX_CELLDATA_VISIBLE_2;
                }
                field(Field3; GetSettingValue(3))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[3];
                    visible = MATRIX_CELLDATA_VISIBLE_3;
                }
                field(Field4; GetSettingValue(4))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[4];
                    visible = MATRIX_CELLDATA_VISIBLE_4;
                }
                field(Field5; GetSettingValue(5))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[5];
                    visible = MATRIX_CELLDATA_VISIBLE_5;
                }
                field(Field6; GetSettingValue(6))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[6];
                    visible = MATRIX_CELLDATA_VISIBLE_6;
                }
                field(Field7; GetSettingValue(7))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[7];
                    visible = MATRIX_CELLDATA_VISIBLE_7;
                }
                field(Field8; GetSettingValue(8))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[8];
                    visible = MATRIX_CELLDATA_VISIBLE_8;
                }
                field(Field9; GetSettingValue(9))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[9];
                    visible = MATRIX_CELLDATA_VISIBLE_9;
                }
                field(Field10; GetSettingValue(10))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[10];
                    visible = MATRIX_CELLDATA_VISIBLE_10;
                }
                field(Field11; GetSettingValue(11))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[11];
                    visible = MATRIX_CELLDATA_VISIBLE_11;
                }
                field(Field12; GetSettingValue(12))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[12];
                    visible = MATRIX_CELLDATA_VISIBLE_12;
                }
                field(Field13; GetSettingValue(13))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[13];
                    visible = MATRIX_CELLDATA_VISIBLE_13;
                }
                field(Field14; GetSettingValue(14))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[14];
                    visible = MATRIX_CELLDATA_VISIBLE_14;
                }
                field(Field15; GetSettingValue(15))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[15];
                    visible = MATRIX_CELLDATA_VISIBLE_15;
                }
                field(Field16; GetSettingValue(16))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[16];
                    visible = MATRIX_CELLDATA_VISIBLE_16;
                }
                field(Field17; GetSettingValue(17))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[17];
                    visible = MATRIX_CELLDATA_VISIBLE_17;
                }
                field(Field18; GetSettingValue(18))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[18];
                    visible = MATRIX_CELLDATA_VISIBLE_18;
                }
                field(Field19; GetSettingValue(19))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[19];
                    visible = MATRIX_CELLDATA_VISIBLE_19;
                }
                field(Field20; GetSettingValue(20))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[20];
                    visible = MATRIX_CELLDATA_VISIBLE_20;
                }
                field(Field21; GetSettingValue(21))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[21];
                    visible = MATRIX_CELLDATA_VISIBLE_21;
                }
                field(Field22; GetSettingValue(22))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[22];
                    visible = MATRIX_CELLDATA_VISIBLE_22;
                }
                field(Field23; GetSettingValue(23))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[23];
                    visible = MATRIX_CELLDATA_VISIBLE_23;
                }
                field(Field24; GetSettingValue(24))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[24];
                    visible = MATRIX_CELLDATA_VISIBLE_24;
                }
                field(Field25; GetSettingValue(25))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[25];
                    visible = MATRIX_CELLDATA_VISIBLE_25;
                }
                field(Field26; GetSettingValue(26))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[26];
                    visible = MATRIX_CELLDATA_VISIBLE_26;
                }
                field(Field27; GetSettingValue(27))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[27];
                    visible = MATRIX_CELLDATA_VISIBLE_27;
                }
                field(Field28; GetSettingValue(28))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[28];
                    visible = MATRIX_CELLDATA_VISIBLE_28;
                }
                field(Field29; GetSettingValue(29))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[29];
                    visible = MATRIX_CELLDATA_VISIBLE_29;
                }
                field(Field30; GetSettingValue(30))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[30];
                    visible = MATRIX_CELLDATA_VISIBLE_30;
                }
                field(Field31; GetSettingValue(31))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[31];
                    visible = MATRIX_CELLDATA_VISIBLE_31;
                }
                field(Field32; GetSettingValue(32))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[32];
                    visible = MATRIX_CELLDATA_VISIBLE_32;
                }
                field(Field33; GetSettingValue(33))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[33];
                    visible = MATRIX_CELLDATA_VISIBLE_33;
                }
                field(Field34; GetSettingValue(34))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[34];
                    visible = MATRIX_CELLDATA_VISIBLE_34;
                }
                field(Field35; GetSettingValue(35))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[35];
                    visible = MATRIX_CELLDATA_VISIBLE_35;
                }
                field(Field36; GetSettingValue(36))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[36];
                    visible = MATRIX_CELLDATA_VISIBLE_36;
                }
                field(Field37; GetSettingValue(37))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[37];
                    visible = MATRIX_CELLDATA_VISIBLE_37;
                }
                field(Field38; GetSettingValue(38))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[38];
                    visible = MATRIX_CELLDATA_VISIBLE_38;
                }
                field(Field39; GetSettingValue(39))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[39];
                    visible = MATRIX_CELLDATA_VISIBLE_39;
                }
                field(Field40; GetSettingValue(40))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[40];
                    visible = MATRIX_CELLDATA_VISIBLE_40;
                }
                field(Field41; GetSettingValue(41))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[41];
                    visible = MATRIX_CELLDATA_VISIBLE_41;
                }
                field(Field42; GetSettingValue(42))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[42];
                    visible = MATRIX_CELLDATA_VISIBLE_42;
                }
                field(Field43; GetSettingValue(43))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[43];
                    visible = MATRIX_CELLDATA_VISIBLE_43;
                }
                field(Field44; GetSettingValue(44))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[44];
                    visible = MATRIX_CELLDATA_VISIBLE_44;
                }
                field(Field45; GetSettingValue(45))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[45];
                    visible = MATRIX_CELLDATA_VISIBLE_45;
                }
                field(Field46; GetSettingValue(46))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[46];
                    visible = MATRIX_CELLDATA_VISIBLE_46;
                }
                field(Field47; GetSettingValue(47))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[47];
                    visible = MATRIX_CELLDATA_VISIBLE_47;
                }
                field(Field48; GetSettingValue(48))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[48];
                    visible = MATRIX_CELLDATA_VISIBLE_48;
                }
                field(Field49; GetSettingValue(49))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[49];
                    visible = MATRIX_CELLDATA_VISIBLE_49;
                }
                field(Field50; GetSettingValue(50))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[50];
                    visible = MATRIX_CELLDATA_VISIBLE_50;
                }
                field(Field51; GetSettingValue(51))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[51];
                    visible = MATRIX_CELLDATA_VISIBLE_51;
                }
                field(Field52; GetSettingValue(52))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[52];
                    visible = MATRIX_CELLDATA_VISIBLE_52;
                }
                field(Field53; GetSettingValue(53))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[53];
                    visible = MATRIX_CELLDATA_VISIBLE_53;
                }
                field(Field54; GetSettingValue(54))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[54];
                    visible = MATRIX_CELLDATA_VISIBLE_54;
                }
                field(Field55; GetSettingValue(55))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[55];
                    visible = MATRIX_CELLDATA_VISIBLE_55;
                }
                field(Field56; GetSettingValue(56))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[56];
                    visible = MATRIX_CELLDATA_VISIBLE_56;
                }
                field(Field57; GetSettingValue(57))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[57];
                    visible = MATRIX_CELLDATA_VISIBLE_57;
                }
                field(Field58; GetSettingValue(58))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[58];
                    visible = MATRIX_CELLDATA_VISIBLE_58;
                }
                field(Field59; GetSettingValue(59))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[59];
                    visible = MATRIX_CELLDATA_VISIBLE_59;
                }
                field(Field60; GetSettingValue(60))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[60];
                    visible = MATRIX_CELLDATA_VISIBLE_60;
                }
                field(Field61; GetSettingValue(61))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[61];
                    visible = MATRIX_CELLDATA_VISIBLE_61;
                }
                field(Field62; GetSettingValue(62))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[62];
                    visible = MATRIX_CELLDATA_VISIBLE_62;
                }
                field(Field63; GetSettingValue(63))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[63];
                    visible = MATRIX_CELLDATA_VISIBLE_63;
                }
                field(Field64; GetSettingValue(64))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[64];
                    visible = MATRIX_CELLDATA_VISIBLE_64;
                }
                field(Field65; GetSettingValue(65))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[65];
                    visible = MATRIX_CELLDATA_VISIBLE_65;
                }
                field(Field66; GetSettingValue(66))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[66];
                    visible = MATRIX_CELLDATA_VISIBLE_66;
                }
                field(Field67; GetSettingValue(67))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[67];
                    visible = MATRIX_CELLDATA_VISIBLE_67;
                }
                field(Field68; GetSettingValue(68))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[68];
                    visible = MATRIX_CELLDATA_VISIBLE_68;
                }
                field(Field69; GetSettingValue(69))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[69];
                    visible = MATRIX_CELLDATA_VISIBLE_69;
                }
                field(Field70; GetSettingValue(70))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[70];
                    visible = MATRIX_CELLDATA_VISIBLE_70;
                }
                field(Field71; GetSettingValue(71))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[71];
                    visible = MATRIX_CELLDATA_VISIBLE_71;
                }
                field(Field72; GetSettingValue(72))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[72];
                    visible = MATRIX_CELLDATA_VISIBLE_72;
                }
                field(Field73; GetSettingValue(73))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[73];
                    visible = MATRIX_CELLDATA_VISIBLE_73;
                }
                field(Field74; GetSettingValue(74))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[74];
                    visible = MATRIX_CELLDATA_VISIBLE_74;
                }
                field(Field75; GetSettingValue(75))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[75];
                    visible = MATRIX_CELLDATA_VISIBLE_75;
                }
                field(Field76; GetSettingValue(76))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[76];
                    visible = MATRIX_CELLDATA_VISIBLE_76;
                }
                field(Field77; GetSettingValue(77))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[77];
                    visible = MATRIX_CELLDATA_VISIBLE_77;
                }
                field(Field78; GetSettingValue(78))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[78];
                    visible = MATRIX_CELLDATA_VISIBLE_78;
                }
                field(Field79; GetSettingValue(79))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[79];
                    visible = MATRIX_CELLDATA_VISIBLE_79;
                }
                field(Field80; GetSettingValue(80))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[80];
                    visible = MATRIX_CELLDATA_VISIBLE_80;
                }
                field(Field81; GetSettingValue(81))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[81];
                    visible = MATRIX_CELLDATA_VISIBLE_81;
                }
                field(Field82; GetSettingValue(82))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[82];
                    visible = MATRIX_CELLDATA_VISIBLE_82;
                }
                field(Field83; GetSettingValue(83))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[83];
                    visible = MATRIX_CELLDATA_VISIBLE_83;
                }
                field(Field84; GetSettingValue(84))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[84];
                    visible = MATRIX_CELLDATA_VISIBLE_84;
                }
                field(Field85; GetSettingValue(85))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[85];
                    visible = MATRIX_CELLDATA_VISIBLE_85;
                }
                field(Field86; GetSettingValue(86))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[86];
                    visible = MATRIX_CELLDATA_VISIBLE_86;
                }
                field(Field87; GetSettingValue(87))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[87];
                    visible = MATRIX_CELLDATA_VISIBLE_87;
                }
                field(Field88; GetSettingValue(88))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[88];
                    visible = MATRIX_CELLDATA_VISIBLE_88;
                }
                field(Field89; GetSettingValue(89))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[89];
                    visible = MATRIX_CELLDATA_VISIBLE_89;
                }
                field(Field90; GetSettingValue(90))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[90];
                    visible = MATRIX_CELLDATA_VISIBLE_90;
                }
                field(Field91; GetSettingValue(91))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[91];
                    visible = MATRIX_CELLDATA_VISIBLE_91;
                }
                field(Field92; GetSettingValue(92))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[92];
                    visible = MATRIX_CELLDATA_VISIBLE_92;
                }
                field(Field93; GetSettingValue(93))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[93];
                    visible = MATRIX_CELLDATA_VISIBLE_93;
                }
                field(Field94; GetSettingValue(94))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[94];
                    visible = MATRIX_CELLDATA_VISIBLE_94;
                }
                field(Field95; GetSettingValue(95))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[95];
                    visible = MATRIX_CELLDATA_VISIBLE_95;
                }
                field(Field96; GetSettingValue(96))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[96];
                    visible = MATRIX_CELLDATA_VISIBLE_96;
                }
                field(Field97; GetSettingValue(97))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[97];
                    visible = MATRIX_CELLDATA_VISIBLE_97;
                }
                field(Field98; GetSettingValue(98))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[98];
                    visible = MATRIX_CELLDATA_VISIBLE_98;
                }
                field(Field99; GetSettingValue(99))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[99];
                    visible = MATRIX_CELLDATA_VISIBLE_99;
                }
                field(Field100; GetSettingValue(100))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[100];
                    visible = MATRIX_CELLDATA_VISIBLE_100;
                }
                field(Field101; GetSettingValue(101))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[101];
                    visible = MATRIX_CELLDATA_VISIBLE_101;
                }
                field(Field102; GetSettingValue(102))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[102];
                    visible = MATRIX_CELLDATA_VISIBLE_102;
                }
                field(Field103; GetSettingValue(103))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[103];
                    visible = MATRIX_CELLDATA_VISIBLE_103;
                }
                field(Field104; GetSettingValue(104))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[104];
                    visible = MATRIX_CELLDATA_VISIBLE_104;
                }
                field(Field105; GetSettingValue(105))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[105];
                    visible = MATRIX_CELLDATA_VISIBLE_105;
                }
                field(Field106; GetSettingValue(106))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[106];
                    visible = MATRIX_CELLDATA_VISIBLE_106;
                }
                field(Field107; GetSettingValue(107))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[107];
                    visible = MATRIX_CELLDATA_VISIBLE_107;
                }
                field(Field108; GetSettingValue(108))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[108];
                    visible = MATRIX_CELLDATA_VISIBLE_108;
                }
                field(Field109; GetSettingValue(109))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[109];
                    visible = MATRIX_CELLDATA_VISIBLE_109;
                }
                field(Field110; GetSettingValue(110))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[110];
                    visible = MATRIX_CELLDATA_VISIBLE_110;
                }
                field(Field111; GetSettingValue(111))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[111];
                    visible = MATRIX_CELLDATA_VISIBLE_111;
                }
                field(Field112; GetSettingValue(112))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[112];
                    visible = MATRIX_CELLDATA_VISIBLE_112;
                }
                field(Field113; GetSettingValue(113))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[113];
                    visible = MATRIX_CELLDATA_VISIBLE_113;
                }
                field(Field114; GetSettingValue(114))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[114];
                    visible = MATRIX_CELLDATA_VISIBLE_114;
                }
                field(Field115; GetSettingValue(115))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[115];
                    visible = MATRIX_CELLDATA_VISIBLE_115;
                }
                field(Field116; GetSettingValue(116))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[116];
                    visible = MATRIX_CELLDATA_VISIBLE_116;
                }
                field(Field117; GetSettingValue(117))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[117];
                    visible = MATRIX_CELLDATA_VISIBLE_117;
                }
                field(Field118; GetSettingValue(118))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[118];
                    visible = MATRIX_CELLDATA_VISIBLE_118;
                }
                field(Field119; GetSettingValue(119))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[119];
                    visible = MATRIX_CELLDATA_VISIBLE_119;
                }
                field(Field120; GetSettingValue(120))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[120];
                    visible = MATRIX_CELLDATA_VISIBLE_120;
                }
                field(Field121; GetSettingValue(121))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[121];
                    visible = MATRIX_CELLDATA_VISIBLE_121;
                }
                field(Field122; GetSettingValue(122))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[122];
                    visible = MATRIX_CELLDATA_VISIBLE_122;
                }
                field(Field123; GetSettingValue(123))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[123];
                    visible = MATRIX_CELLDATA_VISIBLE_123;
                }
                field(Field124; GetSettingValue(124))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[124];
                    visible = MATRIX_CELLDATA_VISIBLE_124;
                }
                field(Field125; GetSettingValue(125))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[125];
                    visible = MATRIX_CELLDATA_VISIBLE_125;
                }
                field(Field126; GetSettingValue(126))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[126];
                    visible = MATRIX_CELLDATA_VISIBLE_126;
                }
                field(Field127; GetSettingValue(127))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[127];
                    visible = MATRIX_CELLDATA_VISIBLE_127;
                }
                field(Field128; GetSettingValue(128))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[128];
                    visible = MATRIX_CELLDATA_VISIBLE_128;
                }
                field(Field129; GetSettingValue(129))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[129];
                    visible = MATRIX_CELLDATA_VISIBLE_129;
                }
                field(Field130; GetSettingValue(130))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[130];
                    visible = MATRIX_CELLDATA_VISIBLE_130;
                }
                field(Field131; GetSettingValue(131))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[131];
                    visible = MATRIX_CELLDATA_VISIBLE_131;
                }
                field(Field132; GetSettingValue(132))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[132];
                    visible = MATRIX_CELLDATA_VISIBLE_132;
                }
                field(Field133; GetSettingValue(133))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[133];
                    visible = MATRIX_CELLDATA_VISIBLE_133;
                }
                field(Field134; GetSettingValue(134))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[134];
                    visible = MATRIX_CELLDATA_VISIBLE_134;
                }
                field(Field135; GetSettingValue(135))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[135];
                    visible = MATRIX_CELLDATA_VISIBLE_135;
                }
                field(Field136; GetSettingValue(136))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[136];
                    visible = MATRIX_CELLDATA_VISIBLE_136;
                }
                field(Field137; GetSettingValue(137))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[137];
                    visible = MATRIX_CELLDATA_VISIBLE_137;
                }
                field(Field138; GetSettingValue(138))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[138];
                    visible = MATRIX_CELLDATA_VISIBLE_138;
                }
                field(Field139; GetSettingValue(139))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[139];
                    visible = MATRIX_CELLDATA_VISIBLE_139;
                }
                field(Field140; GetSettingValue(140))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[140];
                    visible = MATRIX_CELLDATA_VISIBLE_140;
                }
                field(Field141; GetSettingValue(141))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[141];
                    visible = MATRIX_CELLDATA_VISIBLE_141;
                }
                field(Field142; GetSettingValue(142))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[142];
                    visible = MATRIX_CELLDATA_VISIBLE_142;
                }
                field(Field143; GetSettingValue(143))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[143];
                    visible = MATRIX_CELLDATA_VISIBLE_143;
                }
                field(Field144; GetSettingValue(144))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[144];
                    visible = MATRIX_CELLDATA_VISIBLE_144;
                }
                field(Field145; GetSettingValue(145))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[145];
                    visible = MATRIX_CELLDATA_VISIBLE_145;
                }
                field(Field146; GetSettingValue(146))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[146];
                    visible = MATRIX_CELLDATA_VISIBLE_146;
                }
                field(Field147; GetSettingValue(147))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[147];
                    visible = MATRIX_CELLDATA_VISIBLE_147;
                }
                field(Field148; GetSettingValue(148))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[148];
                    visible = MATRIX_CELLDATA_VISIBLE_148;
                }
                field(Field149; GetSettingValue(149))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[149];
                    visible = MATRIX_CELLDATA_VISIBLE_149;
                }
                field(Field150; GetSettingValue(150))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[150];
                    visible = MATRIX_CELLDATA_VISIBLE_150;
                }
                field(Field151; GetSettingValue(151))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[151];
                    visible = MATRIX_CELLDATA_VISIBLE_151;
                }
                field(Field152; GetSettingValue(152))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[152];
                    visible = MATRIX_CELLDATA_VISIBLE_152;
                }
                field(Field153; GetSettingValue(153))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[153];
                    visible = MATRIX_CELLDATA_VISIBLE_153;
                }
                field(Field154; GetSettingValue(154))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[154];
                    visible = MATRIX_CELLDATA_VISIBLE_154;
                }
                field(Field155; GetSettingValue(155))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[155];
                    visible = MATRIX_CELLDATA_VISIBLE_155;
                }
                field(Field156; GetSettingValue(156))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[156];
                    visible = MATRIX_CELLDATA_VISIBLE_156;
                }
                field(Field157; GetSettingValue(157))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[157];
                    visible = MATRIX_CELLDATA_VISIBLE_157;
                }
                field(Field158; GetSettingValue(158))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[158];
                    visible = MATRIX_CELLDATA_VISIBLE_158;
                }
                field(Field159; GetSettingValue(159))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[159];
                    visible = MATRIX_CELLDATA_VISIBLE_159;
                }
                field(Field160; GetSettingValue(160))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[160];
                    visible = MATRIX_CELLDATA_VISIBLE_160;
                }
                field(Field161; GetSettingValue(161))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[161];
                    visible = MATRIX_CELLDATA_VISIBLE_161;
                }
                field(Field162; GetSettingValue(162))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[162];
                    visible = MATRIX_CELLDATA_VISIBLE_162;
                }
                field(Field163; GetSettingValue(163))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[163];
                    visible = MATRIX_CELLDATA_VISIBLE_163;
                }
                field(Field164; GetSettingValue(164))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[164];
                    visible = MATRIX_CELLDATA_VISIBLE_164;
                }
                field(Field165; GetSettingValue(165))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[165];
                    visible = MATRIX_CELLDATA_VISIBLE_165;
                }
                field(Field166; GetSettingValue(166))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[166];
                    visible = MATRIX_CELLDATA_VISIBLE_166;
                }
                field(Field167; GetSettingValue(167))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[167];
                    visible = MATRIX_CELLDATA_VISIBLE_167;
                }
                field(Field168; GetSettingValue(168))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[168];
                    visible = MATRIX_CELLDATA_VISIBLE_168;
                }
                field(Field169; GetSettingValue(169))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[169];
                    visible = MATRIX_CELLDATA_VISIBLE_169;
                }
                field(Field170; GetSettingValue(170))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[170];
                    visible = MATRIX_CELLDATA_VISIBLE_170;
                }
                field(Field171; GetSettingValue(171))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[171];
                    visible = MATRIX_CELLDATA_VISIBLE_171;
                }
                field(Field172; GetSettingValue(172))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[172];
                    visible = MATRIX_CELLDATA_VISIBLE_172;
                }
                field(Field173; GetSettingValue(173))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[173];
                    visible = MATRIX_CELLDATA_VISIBLE_173;
                }
                field(Field174; GetSettingValue(174))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[174];
                    visible = MATRIX_CELLDATA_VISIBLE_174;
                }
                field(Field175; GetSettingValue(175))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[175];
                    visible = MATRIX_CELLDATA_VISIBLE_175;
                }
                field(Field176; GetSettingValue(176))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[176];
                    visible = MATRIX_CELLDATA_VISIBLE_176;
                }
                field(Field177; GetSettingValue(177))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[177];
                    visible = MATRIX_CELLDATA_VISIBLE_177;
                }
                field(Field178; GetSettingValue(178))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[178];
                    visible = MATRIX_CELLDATA_VISIBLE_178;
                }
                field(Field179; GetSettingValue(179))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[179];
                    visible = MATRIX_CELLDATA_VISIBLE_179;
                }
                field(Field180; GetSettingValue(180))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[180];
                    visible = MATRIX_CELLDATA_VISIBLE_180;
                }
                field(Field181; GetSettingValue(181))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[181];
                    visible = MATRIX_CELLDATA_VISIBLE_181;
                }
                field(Field182; GetSettingValue(182))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[182];
                    visible = MATRIX_CELLDATA_VISIBLE_182;
                }
                field(Field183; GetSettingValue(183))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[183];
                    visible = MATRIX_CELLDATA_VISIBLE_183;
                }
                field(Field184; GetSettingValue(184))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[184];
                    visible = MATRIX_CELLDATA_VISIBLE_184;
                }
                field(Field185; GetSettingValue(185))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[185];
                    visible = MATRIX_CELLDATA_VISIBLE_185;
                }
                field(Field186; GetSettingValue(186))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[186];
                    visible = MATRIX_CELLDATA_VISIBLE_186;
                }
                field(Field187; GetSettingValue(187))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[187];
                    visible = MATRIX_CELLDATA_VISIBLE_187;
                }
                field(Field188; GetSettingValue(188))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[188];
                    visible = MATRIX_CELLDATA_VISIBLE_188;
                }
                field(Field189; GetSettingValue(189))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[189];
                    visible = MATRIX_CELLDATA_VISIBLE_189;
                }
                field(Field190; GetSettingValue(190))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[190];
                    visible = MATRIX_CELLDATA_VISIBLE_190;
                }
                field(Field191; GetSettingValue(191))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[191];
                    visible = MATRIX_CELLDATA_VISIBLE_191;
                }
                field(Field192; GetSettingValue(192))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[192];
                    visible = MATRIX_CELLDATA_VISIBLE_192;
                }
                field(Field193; GetSettingValue(193))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[193];
                    visible = MATRIX_CELLDATA_VISIBLE_193;
                }
                field(Field194; GetSettingValue(194))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[194];
                    visible = MATRIX_CELLDATA_VISIBLE_194;
                }
                field(Field195; GetSettingValue(195))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[195];
                    visible = MATRIX_CELLDATA_VISIBLE_195;
                }
                field(Field196; GetSettingValue(196))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[196];
                    visible = MATRIX_CELLDATA_VISIBLE_196;
                }
                field(Field197; GetSettingValue(197))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[197];
                    visible = MATRIX_CELLDATA_VISIBLE_197;
                }
                field(Field198; GetSettingValue(198))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[198];
                    visible = MATRIX_CELLDATA_VISIBLE_198;
                }
                field(Field199; GetSettingValue(199))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[199];
                    visible = MATRIX_CELLDATA_VISIBLE_199;
                }
                field(Field200; GetSettingValue(200))
                {
                    ApplicationArea = All;
                    CaptionClass = MATRIX_Caption[200];
                    visible = MATRIX_CELLDATA_VISIBLE_200;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Assign records")
            {
                ApplicationArea = All;
                Caption = 'Select settings';
                Image = CopyToTask;

                trigger OnAction()
                var
                    Settings: Page DYM_SettingsList;
                begin
                    Settings.RunModal();
                    Settings.SetSelectionFilter(BusinessSettings);
                end;
            }
            action("View Matrix")
            {
                ApplicationArea = All;
                Caption = 'View selected settings';
                Image = View;

                trigger OnAction()
                begin
                    Page.RunModal(Page::DYM_SettingsList, BusinessSettings);
                end;
            }
            action("CreateMatrix")
            {
                ApplicationArea = All;
                Caption = 'Create overview';
                Image = ShowMatrix;

                trigger OnAction()
                begin
                    CreateSettingsMatrix();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        MaxCount:=200;
    end;
    procedure CreateSettingsMatrix()
    var
        DeviceRole: Record DYM_DeviceRole;
        DeviceGroup: Record DYM_DeviceGroup;
        DeviceSetup: Record DYM_DeviceSetup;
        BusinessSettingsAssignment: Record DYM_SettingsAssignment;
        Count: Integer;
    begin
        if Rec.FindSet()then Rec.DeleteAll();
        Count:=0;
        Clear(MATRIX_Caption);
        Clear(MATRIX_CellData);
        //Init the matrix
        //BusinessSettings.Reset();
        if(BusinessSettings.FindSet())then repeat if(Count = MaxCount)then break;
                Count+=1;
                MATRIX_Caption[Count]:=BusinessSettings.Code;
                MATRIX_SettingType[Count]:=Format(BusinessSettings.Type);
            until BusinessSettings.Next() = 0;
        SetVisible();
        DeviceRole.Reset();
        if(DeviceRole.FindSet())then repeat Clear(DeviceGroup);
                Clear(DeviceSetup);
                Rec.Init();
                Rec."Device Role Code":=DeviceRole.Code;
                Rec.Insert();
            until DeviceRole.Next() = 0;
        DeviceGroup.Reset();
        DeviceGroup.SetRange("Device Role Code", DeviceRole.Code);
        if(DeviceGroup.FindSet())then repeat Rec.Init();
                Rec."Device Role Code":=DeviceRole.Code;
                Rec."Device Group Code":=DeviceGroup.Code;
                Rec.Insert();
            until DeviceGroup.Next() = 0;
        DeviceRole.Reset();
        if(DeviceRole.FindSet())then repeat DeviceGroup.Reset();
                DeviceGroup.SetRange("Device Role Code", DeviceRole.Code);
                if(DeviceGroup.FindSet())then repeat Rec.Init();
                        Rec."Device Role Code":=DeviceRole.Code;
                        Rec."Device Group Code":=DeviceGroup.Code;
                        Rec.Insert();
                        DeviceSetup.Reset();
                        DeviceSetup.SetRange("Device Role Code", DeviceRole.Code);
                        DeviceSetup.SetRange("Device Group Code", DeviceGroup.Code);
                        if(DeviceSetup.FindSet())then repeat Rec.Init();
                                Rec."Device Role Code":=DeviceRole.Code;
                                Rec."Device Group Code":=DeviceGroup.Code;
                                Rec."Device Setup Code":=DeviceSetup.Code;
                                Rec.Insert();
                            until DeviceSetup.Next() = 0;
                    until DeviceGroup.Next() = 0;
            until DeviceRole.Next() = 0;
    end;
    local procedure GetSettingValue(ColumnId: Integer): Text var
        BusinessSettingsAssignment: Record DYM_SettingsAssignment;
        BusinessSetting: Text;
    begin
        BusinessSetting:=MATRIX_Caption[ColumnId];
        if(BusinessSetting <> '')then begin
            BusinessSettingsAssignment.Reset();
            BusinessSettingsAssignment.SetRange(Code, BusinessSetting);
            BusinessSettingsAssignment.SetRange(Type, Enum::DYM_SettingsType.FromInteger(DYM_SettingsType.Ordinals.Get(DYM_SettingsType.Names.IndexOf(MATRIX_SettingType[ColumnId]))));
            BusinessSettingsAssignment.SetRange("Device Role Code", Rec."Device Role Code");
            BusinessSettingsAssignment.SetRange("Device Group Code", Rec."Device Group Code");
            BusinessSettingsAssignment.SetRange("Device Setup Code", Rec."Device Setup Code");
            if(BusinessSettingsAssignment.FindFirst())then exit(BusinessSettingsAssignment.Value);
        end;
    end;
    procedure SetVisible()
    begin
        MATRIX_CELLDATA_VISIBLE_1:=MATRIX_Caption[1] <> '';
        MATRIX_CELLDATA_VISIBLE_2:=MATRIX_Caption[2] <> '';
        MATRIX_CELLDATA_VISIBLE_3:=MATRIX_Caption[3] <> '';
        MATRIX_CELLDATA_VISIBLE_4:=MATRIX_Caption[4] <> '';
        MATRIX_CELLDATA_VISIBLE_5:=MATRIX_Caption[5] <> '';
        MATRIX_CELLDATA_VISIBLE_6:=MATRIX_Caption[6] <> '';
        MATRIX_CELLDATA_VISIBLE_7:=MATRIX_Caption[7] <> '';
        MATRIX_CELLDATA_VISIBLE_8:=MATRIX_Caption[8] <> '';
        MATRIX_CELLDATA_VISIBLE_9:=MATRIX_Caption[9] <> '';
        MATRIX_CELLDATA_VISIBLE_10:=MATRIX_Caption[10] <> '';
        MATRIX_CELLDATA_VISIBLE_11:=MATRIX_Caption[11] <> '';
        MATRIX_CELLDATA_VISIBLE_12:=MATRIX_Caption[12] <> '';
        MATRIX_CELLDATA_VISIBLE_13:=MATRIX_Caption[13] <> '';
        MATRIX_CELLDATA_VISIBLE_14:=MATRIX_Caption[14] <> '';
        MATRIX_CELLDATA_VISIBLE_15:=MATRIX_Caption[15] <> '';
        MATRIX_CELLDATA_VISIBLE_16:=MATRIX_Caption[16] <> '';
        MATRIX_CELLDATA_VISIBLE_17:=MATRIX_Caption[17] <> '';
        MATRIX_CELLDATA_VISIBLE_18:=MATRIX_Caption[18] <> '';
        MATRIX_CELLDATA_VISIBLE_19:=MATRIX_Caption[19] <> '';
        MATRIX_CELLDATA_VISIBLE_20:=MATRIX_Caption[20] <> '';
        MATRIX_CELLDATA_VISIBLE_21:=MATRIX_Caption[21] <> '';
        MATRIX_CELLDATA_VISIBLE_22:=MATRIX_Caption[22] <> '';
        MATRIX_CELLDATA_VISIBLE_23:=MATRIX_Caption[23] <> '';
        MATRIX_CELLDATA_VISIBLE_24:=MATRIX_Caption[24] <> '';
        MATRIX_CELLDATA_VISIBLE_25:=MATRIX_Caption[25] <> '';
        MATRIX_CELLDATA_VISIBLE_26:=MATRIX_Caption[26] <> '';
        MATRIX_CELLDATA_VISIBLE_27:=MATRIX_Caption[27] <> '';
        MATRIX_CELLDATA_VISIBLE_28:=MATRIX_Caption[28] <> '';
        MATRIX_CELLDATA_VISIBLE_29:=MATRIX_Caption[29] <> '';
        MATRIX_CELLDATA_VISIBLE_30:=MATRIX_Caption[30] <> '';
        MATRIX_CELLDATA_VISIBLE_31:=MATRIX_Caption[31] <> '';
        MATRIX_CELLDATA_VISIBLE_32:=MATRIX_Caption[32] <> '';
        MATRIX_CELLDATA_VISIBLE_33:=MATRIX_Caption[33] <> '';
        MATRIX_CELLDATA_VISIBLE_34:=MATRIX_Caption[34] <> '';
        MATRIX_CELLDATA_VISIBLE_35:=MATRIX_Caption[35] <> '';
        MATRIX_CELLDATA_VISIBLE_36:=MATRIX_Caption[36] <> '';
        MATRIX_CELLDATA_VISIBLE_37:=MATRIX_Caption[37] <> '';
        MATRIX_CELLDATA_VISIBLE_38:=MATRIX_Caption[38] <> '';
        MATRIX_CELLDATA_VISIBLE_39:=MATRIX_Caption[39] <> '';
        MATRIX_CELLDATA_VISIBLE_40:=MATRIX_Caption[40] <> '';
        MATRIX_CELLDATA_VISIBLE_41:=MATRIX_Caption[41] <> '';
        MATRIX_CELLDATA_VISIBLE_42:=MATRIX_Caption[42] <> '';
        MATRIX_CELLDATA_VISIBLE_43:=MATRIX_Caption[43] <> '';
        MATRIX_CELLDATA_VISIBLE_44:=MATRIX_Caption[44] <> '';
        MATRIX_CELLDATA_VISIBLE_45:=MATRIX_Caption[45] <> '';
        MATRIX_CELLDATA_VISIBLE_46:=MATRIX_Caption[46] <> '';
        MATRIX_CELLDATA_VISIBLE_47:=MATRIX_Caption[47] <> '';
        MATRIX_CELLDATA_VISIBLE_48:=MATRIX_Caption[48] <> '';
        MATRIX_CELLDATA_VISIBLE_49:=MATRIX_Caption[49] <> '';
        MATRIX_CELLDATA_VISIBLE_50:=MATRIX_Caption[50] <> '';
        MATRIX_CELLDATA_VISIBLE_51:=MATRIX_Caption[51] <> '';
        MATRIX_CELLDATA_VISIBLE_52:=MATRIX_Caption[52] <> '';
        MATRIX_CELLDATA_VISIBLE_53:=MATRIX_Caption[53] <> '';
        MATRIX_CELLDATA_VISIBLE_54:=MATRIX_Caption[54] <> '';
        MATRIX_CELLDATA_VISIBLE_55:=MATRIX_Caption[55] <> '';
        MATRIX_CELLDATA_VISIBLE_56:=MATRIX_Caption[56] <> '';
        MATRIX_CELLDATA_VISIBLE_57:=MATRIX_Caption[57] <> '';
        MATRIX_CELLDATA_VISIBLE_58:=MATRIX_Caption[58] <> '';
        MATRIX_CELLDATA_VISIBLE_59:=MATRIX_Caption[59] <> '';
        MATRIX_CELLDATA_VISIBLE_60:=MATRIX_Caption[60] <> '';
        MATRIX_CELLDATA_VISIBLE_61:=MATRIX_Caption[61] <> '';
        MATRIX_CELLDATA_VISIBLE_62:=MATRIX_Caption[62] <> '';
        MATRIX_CELLDATA_VISIBLE_63:=MATRIX_Caption[63] <> '';
        MATRIX_CELLDATA_VISIBLE_64:=MATRIX_Caption[64] <> '';
        MATRIX_CELLDATA_VISIBLE_65:=MATRIX_Caption[65] <> '';
        MATRIX_CELLDATA_VISIBLE_66:=MATRIX_Caption[66] <> '';
        MATRIX_CELLDATA_VISIBLE_67:=MATRIX_Caption[67] <> '';
        MATRIX_CELLDATA_VISIBLE_68:=MATRIX_Caption[68] <> '';
        MATRIX_CELLDATA_VISIBLE_69:=MATRIX_Caption[69] <> '';
        MATRIX_CELLDATA_VISIBLE_70:=MATRIX_Caption[70] <> '';
        MATRIX_CELLDATA_VISIBLE_71:=MATRIX_Caption[71] <> '';
        MATRIX_CELLDATA_VISIBLE_72:=MATRIX_Caption[72] <> '';
        MATRIX_CELLDATA_VISIBLE_73:=MATRIX_Caption[73] <> '';
        MATRIX_CELLDATA_VISIBLE_74:=MATRIX_Caption[74] <> '';
        MATRIX_CELLDATA_VISIBLE_75:=MATRIX_Caption[75] <> '';
        MATRIX_CELLDATA_VISIBLE_76:=MATRIX_Caption[76] <> '';
        MATRIX_CELLDATA_VISIBLE_77:=MATRIX_Caption[77] <> '';
        MATRIX_CELLDATA_VISIBLE_78:=MATRIX_Caption[78] <> '';
        MATRIX_CELLDATA_VISIBLE_79:=MATRIX_Caption[79] <> '';
        MATRIX_CELLDATA_VISIBLE_80:=MATRIX_Caption[80] <> '';
        MATRIX_CELLDATA_VISIBLE_81:=MATRIX_Caption[81] <> '';
        MATRIX_CELLDATA_VISIBLE_82:=MATRIX_Caption[82] <> '';
        MATRIX_CELLDATA_VISIBLE_83:=MATRIX_Caption[83] <> '';
        MATRIX_CELLDATA_VISIBLE_84:=MATRIX_Caption[84] <> '';
        MATRIX_CELLDATA_VISIBLE_85:=MATRIX_Caption[85] <> '';
        MATRIX_CELLDATA_VISIBLE_86:=MATRIX_Caption[86] <> '';
        MATRIX_CELLDATA_VISIBLE_87:=MATRIX_Caption[87] <> '';
        MATRIX_CELLDATA_VISIBLE_88:=MATRIX_Caption[88] <> '';
        MATRIX_CELLDATA_VISIBLE_89:=MATRIX_Caption[89] <> '';
        MATRIX_CELLDATA_VISIBLE_90:=MATRIX_Caption[90] <> '';
        MATRIX_CELLDATA_VISIBLE_91:=MATRIX_Caption[91] <> '';
        MATRIX_CELLDATA_VISIBLE_92:=MATRIX_Caption[92] <> '';
        MATRIX_CELLDATA_VISIBLE_93:=MATRIX_Caption[93] <> '';
        MATRIX_CELLDATA_VISIBLE_94:=MATRIX_Caption[94] <> '';
        MATRIX_CELLDATA_VISIBLE_95:=MATRIX_Caption[95] <> '';
        MATRIX_CELLDATA_VISIBLE_96:=MATRIX_Caption[96] <> '';
        MATRIX_CELLDATA_VISIBLE_97:=MATRIX_Caption[97] <> '';
        MATRIX_CELLDATA_VISIBLE_98:=MATRIX_Caption[98] <> '';
        MATRIX_CELLDATA_VISIBLE_99:=MATRIX_Caption[99] <> '';
        MATRIX_CELLDATA_VISIBLE_100:=MATRIX_Caption[100] <> '';
        MATRIX_CELLDATA_VISIBLE_101:=MATRIX_Caption[101] <> '';
        MATRIX_CELLDATA_VISIBLE_102:=MATRIX_Caption[102] <> '';
        MATRIX_CELLDATA_VISIBLE_103:=MATRIX_Caption[103] <> '';
        MATRIX_CELLDATA_VISIBLE_104:=MATRIX_Caption[104] <> '';
        MATRIX_CELLDATA_VISIBLE_105:=MATRIX_Caption[105] <> '';
        MATRIX_CELLDATA_VISIBLE_106:=MATRIX_Caption[106] <> '';
        MATRIX_CELLDATA_VISIBLE_107:=MATRIX_Caption[107] <> '';
        MATRIX_CELLDATA_VISIBLE_108:=MATRIX_Caption[108] <> '';
        MATRIX_CELLDATA_VISIBLE_109:=MATRIX_Caption[109] <> '';
        MATRIX_CELLDATA_VISIBLE_110:=MATRIX_Caption[110] <> '';
        MATRIX_CELLDATA_VISIBLE_111:=MATRIX_Caption[111] <> '';
        MATRIX_CELLDATA_VISIBLE_112:=MATRIX_Caption[112] <> '';
        MATRIX_CELLDATA_VISIBLE_113:=MATRIX_Caption[113] <> '';
        MATRIX_CELLDATA_VISIBLE_114:=MATRIX_Caption[114] <> '';
        MATRIX_CELLDATA_VISIBLE_115:=MATRIX_Caption[115] <> '';
        MATRIX_CELLDATA_VISIBLE_116:=MATRIX_Caption[116] <> '';
        MATRIX_CELLDATA_VISIBLE_117:=MATRIX_Caption[117] <> '';
        MATRIX_CELLDATA_VISIBLE_118:=MATRIX_Caption[118] <> '';
        MATRIX_CELLDATA_VISIBLE_119:=MATRIX_Caption[119] <> '';
        MATRIX_CELLDATA_VISIBLE_120:=MATRIX_Caption[120] <> '';
        MATRIX_CELLDATA_VISIBLE_121:=MATRIX_Caption[121] <> '';
        MATRIX_CELLDATA_VISIBLE_122:=MATRIX_Caption[122] <> '';
        MATRIX_CELLDATA_VISIBLE_123:=MATRIX_Caption[123] <> '';
        MATRIX_CELLDATA_VISIBLE_124:=MATRIX_Caption[124] <> '';
        MATRIX_CELLDATA_VISIBLE_125:=MATRIX_Caption[125] <> '';
        MATRIX_CELLDATA_VISIBLE_126:=MATRIX_Caption[126] <> '';
        MATRIX_CELLDATA_VISIBLE_127:=MATRIX_Caption[127] <> '';
        MATRIX_CELLDATA_VISIBLE_128:=MATRIX_Caption[128] <> '';
        MATRIX_CELLDATA_VISIBLE_129:=MATRIX_Caption[129] <> '';
        MATRIX_CELLDATA_VISIBLE_130:=MATRIX_Caption[130] <> '';
        MATRIX_CELLDATA_VISIBLE_131:=MATRIX_Caption[131] <> '';
        MATRIX_CELLDATA_VISIBLE_132:=MATRIX_Caption[132] <> '';
        MATRIX_CELLDATA_VISIBLE_133:=MATRIX_Caption[133] <> '';
        MATRIX_CELLDATA_VISIBLE_134:=MATRIX_Caption[134] <> '';
        MATRIX_CELLDATA_VISIBLE_135:=MATRIX_Caption[135] <> '';
        MATRIX_CELLDATA_VISIBLE_136:=MATRIX_Caption[136] <> '';
        MATRIX_CELLDATA_VISIBLE_137:=MATRIX_Caption[137] <> '';
        MATRIX_CELLDATA_VISIBLE_138:=MATRIX_Caption[138] <> '';
        MATRIX_CELLDATA_VISIBLE_139:=MATRIX_Caption[139] <> '';
        MATRIX_CELLDATA_VISIBLE_140:=MATRIX_Caption[140] <> '';
        MATRIX_CELLDATA_VISIBLE_141:=MATRIX_Caption[141] <> '';
        MATRIX_CELLDATA_VISIBLE_142:=MATRIX_Caption[142] <> '';
        MATRIX_CELLDATA_VISIBLE_143:=MATRIX_Caption[143] <> '';
        MATRIX_CELLDATA_VISIBLE_144:=MATRIX_Caption[144] <> '';
        MATRIX_CELLDATA_VISIBLE_145:=MATRIX_Caption[145] <> '';
        MATRIX_CELLDATA_VISIBLE_146:=MATRIX_Caption[146] <> '';
        MATRIX_CELLDATA_VISIBLE_147:=MATRIX_Caption[147] <> '';
        MATRIX_CELLDATA_VISIBLE_148:=MATRIX_Caption[148] <> '';
        MATRIX_CELLDATA_VISIBLE_149:=MATRIX_Caption[149] <> '';
        MATRIX_CELLDATA_VISIBLE_150:=MATRIX_Caption[150] <> '';
        MATRIX_CELLDATA_VISIBLE_151:=MATRIX_Caption[151] <> '';
        MATRIX_CELLDATA_VISIBLE_152:=MATRIX_Caption[152] <> '';
        MATRIX_CELLDATA_VISIBLE_153:=MATRIX_Caption[153] <> '';
        MATRIX_CELLDATA_VISIBLE_154:=MATRIX_Caption[154] <> '';
        MATRIX_CELLDATA_VISIBLE_155:=MATRIX_Caption[155] <> '';
        MATRIX_CELLDATA_VISIBLE_156:=MATRIX_Caption[156] <> '';
        MATRIX_CELLDATA_VISIBLE_157:=MATRIX_Caption[157] <> '';
        MATRIX_CELLDATA_VISIBLE_158:=MATRIX_Caption[158] <> '';
        MATRIX_CELLDATA_VISIBLE_159:=MATRIX_Caption[159] <> '';
        MATRIX_CELLDATA_VISIBLE_160:=MATRIX_Caption[160] <> '';
        MATRIX_CELLDATA_VISIBLE_161:=MATRIX_Caption[161] <> '';
        MATRIX_CELLDATA_VISIBLE_162:=MATRIX_Caption[162] <> '';
        MATRIX_CELLDATA_VISIBLE_163:=MATRIX_Caption[163] <> '';
        MATRIX_CELLDATA_VISIBLE_164:=MATRIX_Caption[164] <> '';
        MATRIX_CELLDATA_VISIBLE_165:=MATRIX_Caption[165] <> '';
        MATRIX_CELLDATA_VISIBLE_166:=MATRIX_Caption[166] <> '';
        MATRIX_CELLDATA_VISIBLE_167:=MATRIX_Caption[167] <> '';
        MATRIX_CELLDATA_VISIBLE_168:=MATRIX_Caption[168] <> '';
        MATRIX_CELLDATA_VISIBLE_169:=MATRIX_Caption[169] <> '';
        MATRIX_CELLDATA_VISIBLE_170:=MATRIX_Caption[170] <> '';
        MATRIX_CELLDATA_VISIBLE_171:=MATRIX_Caption[171] <> '';
        MATRIX_CELLDATA_VISIBLE_172:=MATRIX_Caption[172] <> '';
        MATRIX_CELLDATA_VISIBLE_173:=MATRIX_Caption[173] <> '';
        MATRIX_CELLDATA_VISIBLE_174:=MATRIX_Caption[174] <> '';
        MATRIX_CELLDATA_VISIBLE_175:=MATRIX_Caption[175] <> '';
        MATRIX_CELLDATA_VISIBLE_176:=MATRIX_Caption[176] <> '';
        MATRIX_CELLDATA_VISIBLE_177:=MATRIX_Caption[177] <> '';
        MATRIX_CELLDATA_VISIBLE_178:=MATRIX_Caption[178] <> '';
        MATRIX_CELLDATA_VISIBLE_179:=MATRIX_Caption[179] <> '';
        MATRIX_CELLDATA_VISIBLE_180:=MATRIX_Caption[180] <> '';
        MATRIX_CELLDATA_VISIBLE_181:=MATRIX_Caption[181] <> '';
        MATRIX_CELLDATA_VISIBLE_182:=MATRIX_Caption[182] <> '';
        MATRIX_CELLDATA_VISIBLE_183:=MATRIX_Caption[183] <> '';
        MATRIX_CELLDATA_VISIBLE_184:=MATRIX_Caption[184] <> '';
        MATRIX_CELLDATA_VISIBLE_185:=MATRIX_Caption[185] <> '';
        MATRIX_CELLDATA_VISIBLE_186:=MATRIX_Caption[186] <> '';
        MATRIX_CELLDATA_VISIBLE_187:=MATRIX_Caption[187] <> '';
        MATRIX_CELLDATA_VISIBLE_188:=MATRIX_Caption[188] <> '';
        MATRIX_CELLDATA_VISIBLE_189:=MATRIX_Caption[189] <> '';
        MATRIX_CELLDATA_VISIBLE_190:=MATRIX_Caption[190] <> '';
        MATRIX_CELLDATA_VISIBLE_191:=MATRIX_Caption[191] <> '';
        MATRIX_CELLDATA_VISIBLE_192:=MATRIX_Caption[192] <> '';
        MATRIX_CELLDATA_VISIBLE_193:=MATRIX_Caption[193] <> '';
        MATRIX_CELLDATA_VISIBLE_194:=MATRIX_Caption[194] <> '';
        MATRIX_CELLDATA_VISIBLE_195:=MATRIX_Caption[195] <> '';
        MATRIX_CELLDATA_VISIBLE_196:=MATRIX_Caption[196] <> '';
        MATRIX_CELLDATA_VISIBLE_197:=MATRIX_Caption[197] <> '';
        MATRIX_CELLDATA_VISIBLE_198:=MATRIX_Caption[198] <> '';
        MATRIX_CELLDATA_VISIBLE_199:=MATRIX_Caption[199] <> '';
        MATRIX_CELLDATA_VISIBLE_200:=MATRIX_Caption[200] <> '';
    end;
    var BusinessSettings: Record DYM_Settings;
    MATRIX_CellData: array[200]of Text;
    MATRIX_Caption: array[200]of Text;
    MATRIX_SettingType: array[200]of Text;
    MaxCount: Integer;
    MATRIX_CELLDATA_VISIBLE_1: Boolean;
    MATRIX_CELLDATA_VISIBLE_2: Boolean;
    MATRIX_CELLDATA_VISIBLE_3: Boolean;
    MATRIX_CELLDATA_VISIBLE_4: Boolean;
    MATRIX_CELLDATA_VISIBLE_5: Boolean;
    MATRIX_CELLDATA_VISIBLE_6: Boolean;
    MATRIX_CELLDATA_VISIBLE_7: Boolean;
    MATRIX_CELLDATA_VISIBLE_8: Boolean;
    MATRIX_CELLDATA_VISIBLE_9: Boolean;
    MATRIX_CELLDATA_VISIBLE_10: Boolean;
    MATRIX_CELLDATA_VISIBLE_11: Boolean;
    MATRIX_CELLDATA_VISIBLE_12: Boolean;
    MATRIX_CELLDATA_VISIBLE_13: Boolean;
    MATRIX_CELLDATA_VISIBLE_14: Boolean;
    MATRIX_CELLDATA_VISIBLE_15: Boolean;
    MATRIX_CELLDATA_VISIBLE_16: Boolean;
    MATRIX_CELLDATA_VISIBLE_17: Boolean;
    MATRIX_CELLDATA_VISIBLE_18: Boolean;
    MATRIX_CELLDATA_VISIBLE_19: Boolean;
    MATRIX_CELLDATA_VISIBLE_20: Boolean;
    MATRIX_CELLDATA_VISIBLE_21: Boolean;
    MATRIX_CELLDATA_VISIBLE_22: Boolean;
    MATRIX_CELLDATA_VISIBLE_23: Boolean;
    MATRIX_CELLDATA_VISIBLE_24: Boolean;
    MATRIX_CELLDATA_VISIBLE_25: Boolean;
    MATRIX_CELLDATA_VISIBLE_26: Boolean;
    MATRIX_CELLDATA_VISIBLE_27: Boolean;
    MATRIX_CELLDATA_VISIBLE_28: Boolean;
    MATRIX_CELLDATA_VISIBLE_29: Boolean;
    MATRIX_CELLDATA_VISIBLE_30: Boolean;
    MATRIX_CELLDATA_VISIBLE_31: Boolean;
    MATRIX_CELLDATA_VISIBLE_32: Boolean;
    MATRIX_CELLDATA_VISIBLE_33: Boolean;
    MATRIX_CELLDATA_VISIBLE_34: Boolean;
    MATRIX_CELLDATA_VISIBLE_35: Boolean;
    MATRIX_CELLDATA_VISIBLE_36: Boolean;
    MATRIX_CELLDATA_VISIBLE_37: Boolean;
    MATRIX_CELLDATA_VISIBLE_38: Boolean;
    MATRIX_CELLDATA_VISIBLE_39: Boolean;
    MATRIX_CELLDATA_VISIBLE_40: Boolean;
    MATRIX_CELLDATA_VISIBLE_41: Boolean;
    MATRIX_CELLDATA_VISIBLE_42: Boolean;
    MATRIX_CELLDATA_VISIBLE_43: Boolean;
    MATRIX_CELLDATA_VISIBLE_44: Boolean;
    MATRIX_CELLDATA_VISIBLE_45: Boolean;
    MATRIX_CELLDATA_VISIBLE_46: Boolean;
    MATRIX_CELLDATA_VISIBLE_47: Boolean;
    MATRIX_CELLDATA_VISIBLE_48: Boolean;
    MATRIX_CELLDATA_VISIBLE_49: Boolean;
    MATRIX_CELLDATA_VISIBLE_50: Boolean;
    MATRIX_CELLDATA_VISIBLE_51: Boolean;
    MATRIX_CELLDATA_VISIBLE_52: Boolean;
    MATRIX_CELLDATA_VISIBLE_53: Boolean;
    MATRIX_CELLDATA_VISIBLE_54: Boolean;
    MATRIX_CELLDATA_VISIBLE_55: Boolean;
    MATRIX_CELLDATA_VISIBLE_56: Boolean;
    MATRIX_CELLDATA_VISIBLE_57: Boolean;
    MATRIX_CELLDATA_VISIBLE_58: Boolean;
    MATRIX_CELLDATA_VISIBLE_59: Boolean;
    MATRIX_CELLDATA_VISIBLE_60: Boolean;
    MATRIX_CELLDATA_VISIBLE_61: Boolean;
    MATRIX_CELLDATA_VISIBLE_62: Boolean;
    MATRIX_CELLDATA_VISIBLE_63: Boolean;
    MATRIX_CELLDATA_VISIBLE_64: Boolean;
    MATRIX_CELLDATA_VISIBLE_65: Boolean;
    MATRIX_CELLDATA_VISIBLE_66: Boolean;
    MATRIX_CELLDATA_VISIBLE_67: Boolean;
    MATRIX_CELLDATA_VISIBLE_68: Boolean;
    MATRIX_CELLDATA_VISIBLE_69: Boolean;
    MATRIX_CELLDATA_VISIBLE_70: Boolean;
    MATRIX_CELLDATA_VISIBLE_71: Boolean;
    MATRIX_CELLDATA_VISIBLE_72: Boolean;
    MATRIX_CELLDATA_VISIBLE_73: Boolean;
    MATRIX_CELLDATA_VISIBLE_74: Boolean;
    MATRIX_CELLDATA_VISIBLE_75: Boolean;
    MATRIX_CELLDATA_VISIBLE_76: Boolean;
    MATRIX_CELLDATA_VISIBLE_77: Boolean;
    MATRIX_CELLDATA_VISIBLE_78: Boolean;
    MATRIX_CELLDATA_VISIBLE_79: Boolean;
    MATRIX_CELLDATA_VISIBLE_80: Boolean;
    MATRIX_CELLDATA_VISIBLE_81: Boolean;
    MATRIX_CELLDATA_VISIBLE_82: Boolean;
    MATRIX_CELLDATA_VISIBLE_83: Boolean;
    MATRIX_CELLDATA_VISIBLE_84: Boolean;
    MATRIX_CELLDATA_VISIBLE_85: Boolean;
    MATRIX_CELLDATA_VISIBLE_86: Boolean;
    MATRIX_CELLDATA_VISIBLE_87: Boolean;
    MATRIX_CELLDATA_VISIBLE_88: Boolean;
    MATRIX_CELLDATA_VISIBLE_89: Boolean;
    MATRIX_CELLDATA_VISIBLE_90: Boolean;
    MATRIX_CELLDATA_VISIBLE_91: Boolean;
    MATRIX_CELLDATA_VISIBLE_92: Boolean;
    MATRIX_CELLDATA_VISIBLE_93: Boolean;
    MATRIX_CELLDATA_VISIBLE_94: Boolean;
    MATRIX_CELLDATA_VISIBLE_95: Boolean;
    MATRIX_CELLDATA_VISIBLE_96: Boolean;
    MATRIX_CELLDATA_VISIBLE_97: Boolean;
    MATRIX_CELLDATA_VISIBLE_98: Boolean;
    MATRIX_CELLDATA_VISIBLE_99: Boolean;
    MATRIX_CELLDATA_VISIBLE_100: Boolean;
    MATRIX_CELLDATA_VISIBLE_101: Boolean;
    MATRIX_CELLDATA_VISIBLE_102: Boolean;
    MATRIX_CELLDATA_VISIBLE_103: Boolean;
    MATRIX_CELLDATA_VISIBLE_104: Boolean;
    MATRIX_CELLDATA_VISIBLE_105: Boolean;
    MATRIX_CELLDATA_VISIBLE_106: Boolean;
    MATRIX_CELLDATA_VISIBLE_107: Boolean;
    MATRIX_CELLDATA_VISIBLE_108: Boolean;
    MATRIX_CELLDATA_VISIBLE_109: Boolean;
    MATRIX_CELLDATA_VISIBLE_110: Boolean;
    MATRIX_CELLDATA_VISIBLE_111: Boolean;
    MATRIX_CELLDATA_VISIBLE_112: Boolean;
    MATRIX_CELLDATA_VISIBLE_113: Boolean;
    MATRIX_CELLDATA_VISIBLE_114: Boolean;
    MATRIX_CELLDATA_VISIBLE_115: Boolean;
    MATRIX_CELLDATA_VISIBLE_116: Boolean;
    MATRIX_CELLDATA_VISIBLE_117: Boolean;
    MATRIX_CELLDATA_VISIBLE_118: Boolean;
    MATRIX_CELLDATA_VISIBLE_119: Boolean;
    MATRIX_CELLDATA_VISIBLE_120: Boolean;
    MATRIX_CELLDATA_VISIBLE_121: Boolean;
    MATRIX_CELLDATA_VISIBLE_122: Boolean;
    MATRIX_CELLDATA_VISIBLE_123: Boolean;
    MATRIX_CELLDATA_VISIBLE_124: Boolean;
    MATRIX_CELLDATA_VISIBLE_125: Boolean;
    MATRIX_CELLDATA_VISIBLE_126: Boolean;
    MATRIX_CELLDATA_VISIBLE_127: Boolean;
    MATRIX_CELLDATA_VISIBLE_128: Boolean;
    MATRIX_CELLDATA_VISIBLE_129: Boolean;
    MATRIX_CELLDATA_VISIBLE_130: Boolean;
    MATRIX_CELLDATA_VISIBLE_131: Boolean;
    MATRIX_CELLDATA_VISIBLE_132: Boolean;
    MATRIX_CELLDATA_VISIBLE_133: Boolean;
    MATRIX_CELLDATA_VISIBLE_134: Boolean;
    MATRIX_CELLDATA_VISIBLE_135: Boolean;
    MATRIX_CELLDATA_VISIBLE_136: Boolean;
    MATRIX_CELLDATA_VISIBLE_137: Boolean;
    MATRIX_CELLDATA_VISIBLE_138: Boolean;
    MATRIX_CELLDATA_VISIBLE_139: Boolean;
    MATRIX_CELLDATA_VISIBLE_140: Boolean;
    MATRIX_CELLDATA_VISIBLE_141: Boolean;
    MATRIX_CELLDATA_VISIBLE_142: Boolean;
    MATRIX_CELLDATA_VISIBLE_143: Boolean;
    MATRIX_CELLDATA_VISIBLE_144: Boolean;
    MATRIX_CELLDATA_VISIBLE_145: Boolean;
    MATRIX_CELLDATA_VISIBLE_146: Boolean;
    MATRIX_CELLDATA_VISIBLE_147: Boolean;
    MATRIX_CELLDATA_VISIBLE_148: Boolean;
    MATRIX_CELLDATA_VISIBLE_149: Boolean;
    MATRIX_CELLDATA_VISIBLE_150: Boolean;
    MATRIX_CELLDATA_VISIBLE_151: Boolean;
    MATRIX_CELLDATA_VISIBLE_152: Boolean;
    MATRIX_CELLDATA_VISIBLE_153: Boolean;
    MATRIX_CELLDATA_VISIBLE_154: Boolean;
    MATRIX_CELLDATA_VISIBLE_155: Boolean;
    MATRIX_CELLDATA_VISIBLE_156: Boolean;
    MATRIX_CELLDATA_VISIBLE_157: Boolean;
    MATRIX_CELLDATA_VISIBLE_158: Boolean;
    MATRIX_CELLDATA_VISIBLE_159: Boolean;
    MATRIX_CELLDATA_VISIBLE_160: Boolean;
    MATRIX_CELLDATA_VISIBLE_161: Boolean;
    MATRIX_CELLDATA_VISIBLE_162: Boolean;
    MATRIX_CELLDATA_VISIBLE_163: Boolean;
    MATRIX_CELLDATA_VISIBLE_164: Boolean;
    MATRIX_CELLDATA_VISIBLE_165: Boolean;
    MATRIX_CELLDATA_VISIBLE_166: Boolean;
    MATRIX_CELLDATA_VISIBLE_167: Boolean;
    MATRIX_CELLDATA_VISIBLE_168: Boolean;
    MATRIX_CELLDATA_VISIBLE_169: Boolean;
    MATRIX_CELLDATA_VISIBLE_170: Boolean;
    MATRIX_CELLDATA_VISIBLE_171: Boolean;
    MATRIX_CELLDATA_VISIBLE_172: Boolean;
    MATRIX_CELLDATA_VISIBLE_173: Boolean;
    MATRIX_CELLDATA_VISIBLE_174: Boolean;
    MATRIX_CELLDATA_VISIBLE_175: Boolean;
    MATRIX_CELLDATA_VISIBLE_176: Boolean;
    MATRIX_CELLDATA_VISIBLE_177: Boolean;
    MATRIX_CELLDATA_VISIBLE_178: Boolean;
    MATRIX_CELLDATA_VISIBLE_179: Boolean;
    MATRIX_CELLDATA_VISIBLE_180: Boolean;
    MATRIX_CELLDATA_VISIBLE_181: Boolean;
    MATRIX_CELLDATA_VISIBLE_182: Boolean;
    MATRIX_CELLDATA_VISIBLE_183: Boolean;
    MATRIX_CELLDATA_VISIBLE_184: Boolean;
    MATRIX_CELLDATA_VISIBLE_185: Boolean;
    MATRIX_CELLDATA_VISIBLE_186: Boolean;
    MATRIX_CELLDATA_VISIBLE_187: Boolean;
    MATRIX_CELLDATA_VISIBLE_188: Boolean;
    MATRIX_CELLDATA_VISIBLE_189: Boolean;
    MATRIX_CELLDATA_VISIBLE_190: Boolean;
    MATRIX_CELLDATA_VISIBLE_191: Boolean;
    MATRIX_CELLDATA_VISIBLE_192: Boolean;
    MATRIX_CELLDATA_VISIBLE_193: Boolean;
    MATRIX_CELLDATA_VISIBLE_194: Boolean;
    MATRIX_CELLDATA_VISIBLE_195: Boolean;
    MATRIX_CELLDATA_VISIBLE_196: Boolean;
    MATRIX_CELLDATA_VISIBLE_197: Boolean;
    MATRIX_CELLDATA_VISIBLE_198: Boolean;
    MATRIX_CELLDATA_VISIBLE_199: Boolean;
    MATRIX_CELLDATA_VISIBLE_200: Boolean;
}
