; ===========================================================================
; Segment type: Regular
; segment "RAM"
	rsset	$FF0000
			rs.b $580
byte_FF0580:	rs.b 1						; DATA XREF: ROM:002011EE↑r
										; ROM:loc_209088↑r
			rs.b $A7F
unk_FF1000: rs.b 1						; DATA XREF: ROM:loc_200136↑o
			rs.b $201
word_FF1202:	rs.b 2						; DATA XREF: ROM:0020121A↑r
										; ROM:00201222↑w ...
word_FF1204:	rs.b 2						; DATA XREF: ROM:002013D2↑w
										; ROM:00201428↑w ...
byte_FF1206:	rs.b 1						; DATA XREF: ROM:00206A1E↑r
										; ROM:loc_206A2E↑w ...
			rs.b 1
word_FF1208:	rs.b 2						; DATA XREF: ROM:002013C6↑w
										; ROM:00201444↑r ...
			rs.b 2
dword_FF120C:	rs.b 4						; DATA XREF: ROM:002016B2↑w
										; sub_203D60+1C↑r ...
zone:		rs.b 2						; DATA XREF: sub_200252+1C↑r
										; sub_20037A+1C↑r ...
byte_FF1212:	rs.b 1						; DATA XREF: ROM:002011E6↑w
										; ROM:002011F6↑w ...
			rs.b 1
play_air:	rs.b 2						; DATA XREF: ROM:002012E2↑w
										; sub_203D60+46↑r ...
			rs.b 3
byte_FF1219:	rs.b 1						; DATA XREF: sub_20147C+6↑r
										; sub_2023EA+4↑r ...
byte_FF121A:	rs.b 1						; DATA XREF: ROM:loc_2013A8↑w
										; sub_204D76+32↑r ...
byte_FF121B:	rs.b 1						; DATA XREF: ROM:002013A2↑w
										; sub_205EE4+30↑w ...
byte_FF121C:	rs.b 1						; DATA XREF: ROM:002013F0↑w
										; sub_204D76+20↑w ...
byte_FF121D:	rs.b 1						; DATA XREF: ROM:002013E0↑w
										; sub_208B7C+6↑w ...
byte_FF121E:	rs.b 1						; DATA XREF: ROM:002013E8↑w
										; sub_204D76+1A↑w ...
byte_FF121F:	rs.b 1						; DATA XREF: ROM:002013D8↑w
										; sub_209810↑w ...
word_FF1220:	rs.b 2						; DATA XREF: ROM:00201396↑w
										; sub_205EE4+26↑w ...
byte_FF1222:	rs.b 1						; DATA XREF: ROM:0020139C↑w
										; sub_205EE4+46↑w ...
byte_FF1223:	rs.b 1						; DATA XREF: sub_209830+B6↑r
byte_FF1224:	rs.b 1						; DATA XREF: sub_205EE4+58↑w
										; sub_209830+C8↑r
byte_FF1225:	rs.b 1						; DATA XREF: sub_205EE4+50↑w
										; sub_209830+DA↑r
dword_FF1226:	rs.b 4						; DATA XREF: sub_209810+8↑o
										; sub_209830+36↑r
byte_FF122A:	rs.b 1						; DATA XREF: ROM:level↑w
										; ROM:0020124C↑w ...
			rs.b 1
byte_FF122C:	rs.b 1						; DATA XREF: ROM:002013AE↑w
										; ROM:00203666↑w ...
byte_FF122D:	rs.b 1						; DATA XREF: ROM:002013B4↑w
										; sub_203D60:loc_203D8C↑r ...
byte_FF122E:	rs.b 1						; DATA XREF: ROM:002013BA↑w
										; sub_203D60:loc_203DDC↑r ...
byte_FF122F:	rs.b 1						; DATA XREF: ROM:002013C0↑w
										; sub_203F00-87E↑w ...
byte_FF1230:	rs.b 1						; DATA XREF: ROM:0020138E↑r
										; sub_2023FC:loc_20247C↑r ...
byte_FF1231:	rs.b 1						; DATA XREF: sub_205EE4+C↑r
word_FF1232:	rs.b 2						; DATA XREF: sub_205EE4+16↑r
										; sub_205EE4+E8↑r
word_FF1234:	rs.b 2						; DATA XREF: sub_205EE4+1E↑r
word_FF1236:	rs.b 2						; DATA XREF: sub_205EE4+26↑r
dword_FF1238:	rs.b 4						; DATA XREF: sub_205EE4+46↑r
byte_FF123C:	rs.b 1						; DATA XREF: sub_205EE4+5E↑r
byte_FF123D:	rs.b 1						; DATA XREF: ROM:00201208↑r
										; ROM:00201404↑w ...
word_FF123E:	rs.b 2						; DATA XREF: sub_205EE4+6E↑r
										; sub_205EE4+76↑r
word_FF1240:	rs.b 2						; DATA XREF: sub_205EE4+7E↑r
word_FF1242:	rs.b 2						; DATA XREF: sub_205EE4+86↑r
word_FF1244:	rs.b 2						; DATA XREF: sub_205EE4+8E↑r
word_FF1246:	rs.b 2						; DATA XREF: sub_205EE4+96↑r
word_FF1248:	rs.b 2						; DATA XREF: sub_205EE4+9E↑r
word_FF124A:	rs.b 2						; DATA XREF: sub_205EE4+A6↑r
word_FF124C:	rs.b 2						; DATA XREF: sub_205EE4+AE↑r
word_FF124E:	rs.b 2						; DATA XREF: sub_205EE4+B6↑r
word_FF1250:	rs.b 2						; DATA XREF: sub_205EE4+C8↑r
byte_FF1252:	rs.b 1						; DATA XREF: sub_205EE4+66↑r
										; sub_205EE4+D0↑r
byte_FF1253:	rs.b 1						; DATA XREF: sub_205EE4+D8↑r
byte_FF1254:	rs.b 1						; DATA XREF: sub_205EE4+30↑r
byte_FF1255:	rs.b 1						; DATA XREF: sub_203E74↑w
										; sub_205EE4:loc_205E30↑r
word_FF1256:	rs.b 2						; DATA XREF: sub_203E74+A↑w
										; sub_205EE4-AA↑r ...
word_FF1258:	rs.b 2						; DATA XREF: sub_203E74+12↑w
										; sub_205EE4-A2↑r
byte_FF125A:	rs.b 1						; DATA XREF: sub_203E74+1A↑w
										; sub_205EE4-9A↑r
			rs.b 1
word_FF125C:	rs.b 2						; DATA XREF: sub_203E74+2A↑w
										; sub_205EE4-8A↑r ...
word_FF125E:	rs.b 2						; DATA XREF: sub_203E74+32↑w
										; sub_205EE4-7A↑r
word_FF1260:	rs.b 2						; DATA XREF: sub_203E74+3A↑w
										; sub_205EE4-72↑r
word_FF1262:	rs.b 2						; DATA XREF: sub_203E74+42↑w
										; sub_205EE4-6A↑r
word_FF1264:	rs.b 2						; DATA XREF: sub_203E74+4A↑w
										; sub_205EE4-62↑r
word_FF1266:	rs.b 2						; DATA XREF: sub_203E74+52↑w
										; sub_205EE4-5A↑r
word_FF1268:	rs.b 2						; DATA XREF: sub_203E74+5A↑w
										; sub_205EE4-52↑r
word_FF126A:	rs.b 2						; DATA XREF: sub_203E74+62↑w
										; sub_205EE4-4A↑r
word_FF126C:	rs.b 2						; DATA XREF: sub_203E74+6A↑w
										; sub_205EE4-42↑r
word_FF126E:	rs.b 2						; DATA XREF: sub_203E74+72↑w
										; sub_205EE4-30↑r
byte_FF1270:	rs.b 1						; DATA XREF: sub_203E74+22↑w
										; sub_203E74+7A↑w ...
byte_FF1271:	rs.b 1						; DATA XREF: sub_203E74+82↑w
										; sub_205EE4-20↑r
			rs.b 6
word_FF1278:	rs.b 2						; DATA XREF: ROM:0020145E↑r
										; ROM:loc_2018CA↑r ...
byte_FF127A:	rs.b 1						; DATA XREF: sub_2015B6+12↑r
										; sub_203954+1E↑r
byte_FF127B:	rs.b 1						; DATA XREF: ROM:00201272↑w
										; ROM:loc_205992↑r ...
			rs.b $44
byte_FF12C0:	rs.b 1						; DATA XREF: sub_201522↑w
										; sub_201522+8↑w
byte_FF12C1:	rs.b 1						; DATA XREF: sub_201522+10↑w
										; sub_201522+16↑w
byte_FF12C2:	rs.b 1						; DATA XREF: sub_201522:loc_201540↑w
										; sub_201522+26↑w
byte_FF12C3:	rs.b 1						; DATA XREF: sub_201522+2E↑w
										; sub_201522+34↑w ...
byte_FF12C4:	rs.b 1						; DATA XREF: sub_201522:loc_20155E↑w
										; sub_201522+44↑w
byte_FF12C5:	rs.b 1						; DATA XREF: sub_201522+4C↑w
										; sub_201522+52↑r ...
byte_FF12C6:	rs.b 1						; DATA XREF: sub_201522:loc_201586↑r
										; sub_201522+6E↑r ...
byte_FF12C7:	rs.b 1						; DATA XREF: sub_201522+86↑w
										; ROM:loc_208CB0↑r
word_FF12C8:	rs.b 2						; DATA XREF: sub_201522+74↑r
										; sub_201522+7A↑w
			rs.b $2A
word_FF12F4:	rs.b 2						; DATA XREF: ROM:00204E0C↑w
										; sub_202F90:loc_20DBEA↑w ...
			rs.b $1A
dword_FF1310:	rs.b 4						; DATA XREF: ROM:002018E4↑w
										; ROM:00201A16↑w ...
			rs.b 4
dword_FF1318:	rs.b 4						; DATA XREF: sub_202AA2+12↑o
										; sub_202B60:off_202BF6↑o ...
			rs.b 4
byte_FF1320:	rs.b 8						; DATA XREF: sub_202AA2+2A↑o
										; sub_202B60+9E↑o
byte_FF1328:	rs.b 8						; DATA XREF: sub_202AA2+3A↑o
										; sub_202B60+A2↑o
dword_FF1330:	rs.b 4						; DATA XREF: ROM:002018F2↑w
										; ROM:00201A24↑w ...
word_FF1334:	rs.b 2						; DATA XREF: sub_202AA2+24↑o
word_FF1336:	rs.b 2						; DATA XREF: sub_202AA2+34↑o
			rs.b $B4
byte_FF13EC:	rs.b 1						; DATA XREF: sub_204A8C+E↑w
byte_FF13ED:	rs.b 1						; DATA XREF: sub_204A8C+18↑w
byte_FF13EE:	rs.b 1						; DATA XREF: sub_204A8C+22↑w
byte_FF13EF:	rs.b 1						; DATA XREF: sub_204A8C+68↑w
word_FF13F0:	rs.b 2						; DATA XREF: sub_2023FC+A2↑r
										; sub_2023FC:loc_2024BA↑r
			rs.b 2
word_FF13F4:	rs.b 2						; DATA XREF: sub_2023FC+AA↑r
			rs.b 2
byte_FF13F8:	rs.b 1						; DATA XREF: ROM:00200152↑w
										; ROM:00201676↑r ...
			rs.b 1
word_FF13FA:	rs.b 2						; DATA XREF: ROM:00203CBC↑r
										; sub_2063B8:loc_20665E↑r ...
dword_FF13FC:	rs.b 4						; DATA XREF: ROM:00200128↑r
										; ROM:00200158↑w
unk_FF1400: rs.b $180						; DATA XREF: ROM:loc_20067A↑o
										; sub_205666+1A↑o ...
unk_FF1400_end:	rs.b 0
byte_FF1580:	rs.b $300					; DATA XREF: ROM:002014D2↑o
										; sub_20568C+18↑o
dword_FF1880:	rs.b 4						; DATA XREF: ROM:00201278↑w
										; ROM:00201496↑o ...
word_FF1884:	rs.b 2						; DATA XREF: ROM:00206A08↑w
byte_FF1886:	rs.b 1						; DATA XREF: sub_203954:loc_203A0C↑w
										; sub_203954+C8↑r ...
			rs.b 3
byte_FF188A:	rs.b 1						; DATA XREF: ROM:00206A78↑w
										; sub_209830+14↑r
			rs.b $75
byte_FF1900:	rs.b $300					; DATA XREF: sub_2059B8+1A↑o
byte_FF1900_end:	rs.b 0
			rs.b $6400
	rsreset

byte_FF0580_ext:	equ	byte_FF0580+$FF<<24

	rsset	$FFFF8000
			rs.b $2400
byte_FFA400:	rs.b $400					; DATA XREF: sub_200E0C+18↑o
										; sub_202AA2+50↑o ...
byte_FFA800:	rs.b $200					; DATA XREF: sub_202518+2A↑o
										; sub_202550+94↑o ...
bitdevwk:	rs.b $200					; DATA XREF: bitdevwkr:loc_201F0A↑o
										; sub_20209A+16↑o ...
byte_FFAC00:	rs.b $400					; DATA XREF: displaysprite:loc_203204↑o
										; ROM:00203222↑o ...
blkwk:		rs.b $1800					; DATA XREF: sub_202D4C:loc_202D50↑o
										; sub_202DD2+3C↑o ...
byte_FFC800:	rs.b $300					; DATA XREF: sub_20532E+30↑o
byte_FFCB00:	rs.b $100					; DATA XREF: sub_203E5A+4↑o
										; ROM:0020596A↑o
byte_FFCC00:	rs.b $400					; DATA XREF: sub_201D76+74↑o
										; sub_202550+128↑o
actwk:		rs.b $40					; DATA XREF: ROM:0020127E↑o
										; sub_20147C↑o ...
byte_FFD040:	rs.b $40					; DATA XREF: sub_20147C+E↑o
										; ROM:loc_201892↑o ...
byte_FFD080:	rs.b $40					; DATA XREF: ROM:00201358↑w
byte_FFD0C0:	rs.b $40					; DATA XREF: ROM:0020135E↑w
			rs.b $40
			rs.b $40
byte_FFD180:	rs.b $40					; DATA XREF: ROM:0020366E↑w
										; sub_2093D8+8↑w
			rs.b $40
byte_FFD200:	rs.b $40					; DATA XREF: sub_2093F6+E↑w
byte_FFD240:	rs.b $40					; DATA XREF: sub_2093F6+1A↑w
byte_FFD280:	rs.b $40					; DATA XREF: sub_2093F6+26↑w
byte_FFD2C0:	rs.b $40					; DATA XREF: sub_2093F6+32↑w
byte_FFD300:	rs.b $40					; DATA XREF: sub_203F00:loc_203676↑r
										; sub_203F00-876↑w
byte_FFD340:	rs.b $40					; DATA XREF: sub_203F00-86A↑w
byte_FFD380:	rs.b $40					; DATA XREF: sub_203F00-85E↑w
byte_FFD3C0:	rs.b $40					; DATA XREF: sub_203F00-852↑w
unk_FFD400: rs.b $400						; DATA XREF: sub_20B4D8↑o
byte_FFD800:	rs.b $1800					; DATA XREF: ROM:002014B0↑o
										; sub_2063B8+2A↑o ...
byte_FFD800_end:	rs.b 0
			rs.b $B
byte_FFF00B:	rs.b 1						; DATA XREF: queuesound2↑w
										; sub_201E98+6↑r ...
byte_FFF00C:	rs.b 1						; DATA XREF: ROM:queuesound3↑w
										; sub_201E98:loc_201EB4↑r ...
			rs.b $5F3
gamemode:	rs.b 1						; DATA XREF: ROM:0020016A↑w
										; ROM:00200170↑r ...
			rs.b 1
word_FFF602:	rs.b 2						; DATA XREF: ROM:0020136E↑w
										; ROM:00203CDC↑w ...
word_FFF604:	rs.b 2						; DATA XREF: ROM:00201374↑w
										; readjoypads↑o ...
word_FFF606:	rs.b 2						; DATA XREF: ROM:0020137A↑w
										; sub_2035B0↑r ...
			rs.b 4
word_FFF60C:	rs.b 2						; DATA XREF: ROM:002012FA↑r
										; sub_201CD4+20↑w
			rs.b 6
word_FFF614:	rs.b 2						; DATA XREF: ROM:vint14↑r
										; ROM:00201784↑w ...
dword_FFF616:	rs.b 4						; DATA XREF: ROM:0020166E↑r
										; sub_201CD4+40↑w ...
dword_FFF61A:	rs.b 4						; DATA XREF: sub_201CD4+44↑w
										; sub_201D76+60↑w
			rs.b 6
word_FFF624:	rs.b 2						; DATA XREF: ROM:002012D8↑w
										; ROM:002012DE↑r ...
word_FFF626:	rs.b 2						; DATA XREF: sub_200220+6↑r
										; sub_200252+A↑r ...
byte_FFF628:	rs.b 1						; DATA XREF: ROM:0020128E↑o
										; ROM:00201A40↑w
			rs.b 1
vint_mode:	rs.b 1						; DATA XREF: sub_200220:loc_20023C↑w
										; sub_2002C2:loc_2002CC↑w ...
			rs.b 1
byte_FFF62C:	rs.b 1						; DATA XREF: sub_20325E+AC↑w
			rs.b 5
byte_FFF632:	rs.b 1						; DATA XREF: sub_200180+14↑r
										; sub_200180:loc_2001A4↑w
byte_FFF633:	rs.b 1						; DATA XREF: sub_200180+48↑r
										; sub_200180:loc_2001D8↑w
			rs.b 2
dword_FFF636:	rs.b 4						; DATA XREF: ROM:0020B5D8↑r
										; ROM:0020B5F8↑w
word_FFF63A:	rs.b 2						; DATA XREF: sub_209830+78↑r
			rs.b 4
word_FFF640:	rs.b 2						; DATA XREF: ROM:0020173A↑w
										; ROM:00201740↑r ...
			rs.b 2
word_FFF644:	rs.b 2						; DATA XREF: ROM:00201692↑w
										; ROM:loc_20170E↑w ...
			rs.b 2
word_FFF648:	rs.b 2						; DATA XREF: sub_203E74+72↑r
										; sub_205EE4-30↑w ...
			rs.b 3
byte_FFF64D:	rs.b 1						; DATA XREF: sub_203E74+22↑r
										; sub_203E74+7A↑r ...
byte_FFF64E:	rs.b 1						; DATA XREF: ROM:0020171A↑r
										; ROM:002017BE↑r ...
byte_FFF64F:	rs.b 1						; DATA XREF: ROM:00201902↑w
										; ROM:00201C32↑r ...
			rs.b $C
byte_FFF65C:	rs.b 1						; DATA XREF: sub_200180+6↑w
										; sub_200180+C↑w
byte_FFF65D:	rs.b 1						; DATA XREF: sub_200180+3A↑w
										; sub_200180+40↑w
			rs.b $22
dword_FFF680:	rs.b 4						; DATA XREF: ROM:00201318↑r
										; ROM:0020134E↑r ...
word_FFF684:	rs.b 2						; DATA XREF: sub_2020F0+10↑r
										; sub_2020F0+14↑w ...
			rs.b $5A
dword_FFF6E0:	rs.b 4						; DATA XREF: sub_20209A+3C↑w
										; sub_20210C+30↑r ...
dword_FFF6E4:	rs.b 4						; DATA XREF: sub_20209A+40↑w
										; sub_20210C+34↑r ...
dword_FFF6E8:	rs.b 4						; DATA XREF: sub_20209A+44↑w
										; sub_20210C+38↑r ...
dword_FFF6EC:	rs.b 4						; DATA XREF: sub_20209A+48↑w
										; sub_20210C+3C↑r ...
dword_FFF6F0:	rs.b 4						; DATA XREF: sub_20209A+4C↑w
										; sub_20210C+40↑r ...
dword_FFF6F4:	rs.b 4						; DATA XREF: sub_20209A+50↑w
										; sub_20210C+44↑r ...
word_FFF6F8:	rs.b 2						; DATA XREF: sub_20209A+6↑r
										; sub_20209A+26↑w ...
word_FFF6FA:	rs.b 2						; DATA XREF: sub_2020F0+8↑w
										; sub_20210C+6↑w ...
			rs.b 4
dword_FFF700:	rs.b 4						; DATA XREF: ROM:00200660↑r
										; ROM:0020129E↑o ...
dword_FFF704:	rs.b 4						; DATA XREF: sub_2023FC:loc_2024FC↑w
										; sub_202550+28↑r ...
dword_FFF708:	rs.b 4						; DATA XREF: sub_202518+1A↑w
										; sub_20290A↑r ...
dword_FFF70C:	rs.b 4						; DATA XREF: sub_202518+A↑w
										; sub_202550+2E↑r ...
dword_FFF710:	rs.b 4						; DATA XREF: sub_202518+20↑w
										; sub_202550+11C↑r ...
word_FFF714:	rs.b 2						; DATA XREF: sub_202518+10↑w
										; sub_202550+74↑w ...
			rs.b 2
dword_FFF718:	rs.b 4						; DATA XREF: sub_202518+26↑w
										; sub_202550+BC↑r ...
word_FFF71C:	rs.b 2						; DATA XREF: sub_202518+14↑w
										; sub_202550+7A↑w ...
			rs.b 2
dword_FFF720:	rs.b 4						; DATA XREF: sub_2023FC+2A↑w
dword_FFF724:	rs.b 4						; DATA XREF: sub_2023FC+34↑w
										; sub_203030+18↑r ...
dword_FFF728:	rs.b 4						; DATA XREF: sub_2023FC+26↑w
										; sub_2023FC+38↑r ...
dword_FFF72C:	rs.b 4						; DATA XREF: sub_2023FC+30↑w
										; sub_2027B8:loc_20286E↑r ...
word_FFF730:	rs.b 2						; DATA XREF: sub_2023FC+20↑w
word_FFF732:	rs.b 2						; DATA XREF: sub_2023FC+40↑w
			rs.b 6
word_FFF73A:	rs.b 2						; DATA XREF: sub_202550+34↑r
										; sub_202550+42↑r ...
word_FFF73C:	rs.b 2						; DATA XREF: sub_202550+5C↑r
										; sub_2027B8:loc_2027F8↑w ...
word_FFF73E:	rs.b 2						; DATA XREF: sub_2023FC+4C↑w
										; sub_2027B8+20↑r ...
byte_FFF740:	rs.b 1						; DATA XREF: sub_2023FC+4↑w
byte_FFF741:	rs.b 1						; DATA XREF: sub_2023FC+8↑w
byte_FFF742:	rs.b 1						; DATA XREF: sub_2023FC+14↑w
										; sub_203E74+1A↑r ...
			rs.b 1
byte_FFF744:	rs.b 1						; DATA XREF: sub_202550+4↑r
										; sub_203F00+50↑w
			rs.b 1
byte_FFF746:	rs.b 1						; DATA XREF: sub_2023FC+C↑w
			rs.b 1
byte_FFF748:	rs.b 1						; DATA XREF: sub_2023FC+10↑w
			rs.b 1
word_FFF74A:	rs.b 2						; DATA XREF: sub_2023FC+44↑w
										; sub_202716+E↑r ...
byte_FFF74C:	rs.b 1						; DATA XREF: sub_20290A+14↑r
										; sub_20290A+1C↑w ...
byte_FFF74D:	rs.b 1						; DATA XREF: sub_20290A+48↑r
										; sub_20290A+50↑w ...
byte_FFF74E:	rs.b 1						; DATA XREF: sub_202A0E+14↑r
										; sub_202A0E+1C↑w
			rs.b 1
byte_FFF750:	rs.b 1						; DATA XREF: sub_202A42+14↑r
										; sub_202A42+1C↑w
			rs.b 3
dword_FFF754:	rs.b 4						; DATA XREF: ROM:00201326↑w
										; ROM:002018EC↑w ...
word_FFF758:	rs.b 2						; DATA XREF: sub_202550+14↑w
										; sub_202550+84↑r ...
word_FFF75A:	rs.b 2						; DATA XREF: sub_202550+18↑w
										; sub_202550+80↑r ...
byte_FFF75C:	rs.b 1						; DATA XREF: sub_2027B8+2C↑r
										; sub_2027B8+3A↑r ...
byte_FFF75D:	rs.b 1						; DATA XREF: sub_20532E+C↑o
miniplay_flag:	rs.b 1					; DATA XREF: ROM:002036CE↑r
										; ROM:00203FD0↑r ...
byte_FFF75F:	rs.b 1						; DATA XREF: ROM:loc_203FB2↑r
										; ROM:00203FC0↑w
word_FFF760:	rs.b 2						; DATA XREF: ROM:0020370E↑w
										; sub_203D60+90↑w ...
word_FFF762:	rs.b 2						; DATA XREF: ROM:00203714↑w
										; sub_203D60+96↑w ...
word_FFF764:	rs.b 2						; DATA XREF: ROM:0020371A↑w
										; sub_203D60+9C↑w ...
byte_FFF766:	rs.b 1						; DATA XREF: sub_20532E↑o
byte_FFF767:	rs.b 1						; DATA XREF: ROM:00201862↑r
										; ROM:0020188C↑w ...
byte_FFF768:	rs.b 1						; DATA XREF: sub_200A9E+A↑w
										; sub_200A9E+16↑w ...
			rs.b 1
byte_FFF76A:	rs.b 1						; DATA XREF: sub_200A9E+E↑w
										; sub_200A9E+1A↑w ...
			rs.b 1
byte_FFF76C:	rs.b 1						; DATA XREF: sub_206DB0+2↑r
										; ROM:loc_206DC2↑w
			rs.b 1
word_FFF76E:	rs.b 2						; DATA XREF: ROM:00206E4A↑w
										; ROM:00206E60↑r ...
dword_FFF770:	rs.b 4						; DATA XREF: ROM:00206DD0↑w
										; ROM:00206E10↑r ...
dword_FFF774:	rs.b 4						; DATA XREF: ROM:00206DD4↑w
										; ROM:00206E2A↑r ...
dword_FFF778:	rs.b 4						; DATA XREF: ROM:00206DDC↑w
dword_FFF77C:	rs.b 4						; DATA XREF: ROM:00206DE0↑w
word_FFF780:	rs.b 2						; DATA XREF: ROM:00201380↑w
										; sub_201C66↑r ...
word_FFF782:	rs.b 2						; DATA XREF: ROM:00201386↑w
										; sub_201C66:loc_201C70↑r ...
byte_FFF784:	rs.b 1						; DATA XREF: ROM:00201216↑w
										; sub_203F00+8↑r ...
			rs.b 1
word_FFF786:	rs.b 2						; DATA XREF: sub_201C4C↑r
										; sub_201C4C+6↑w ...
byte_FFF788:	rs.b 1						; DATA XREF: sub_20409A+EA↑r
										; sub_20409A+F4↑w ...
			rs.b 7
word_FFF790:	rs.b 2						; DATA XREF: ROM:002013F8↑w
			rs.b 4
dword_FFF796:	rs.b 4						; DATA XREF: sub_200E82:loc_200EAA↑r
										; sub_200F42:loc_200F6A↑r ...
			rs.b $E
word_FFF7A8:	rs.b 2						; DATA XREF: sub_203E5A↑r
										; ROM:loc_205938↑r ...
byte_FFF7AA:	rs.b 1						; DATA XREF: sub_203D60+40↑r
										; sub_20477E+24↑r ...
			rs.b 1
dword_FFF7AC:	rs.b 4						; DATA XREF: sub_2023FC+10E↑w
										; sub_204E18:loc_204E72↑r ...
			rs.b $17
byte_FFF7C7:	rs.b 1						; DATA XREF: ROM:00203D26↑r
			rs.b 2
byte_FFF7CA:	rs.b 1						; DATA XREF: sub_20409A+C↑r
										; sub_20451A+12↑r ...
			rs.b 1
byte_FFF7CC:	rs.b 1						; DATA XREF: ROM:loc_203CD6↑r
										; ROM:0020DF58↑w
			rs.b 3
word_FFF7D0:	rs.b 2						; DATA XREF: sub_204C90+5A↑w
										; sub_2063B8+190↑r ...
			rs.b 8
word_FFF7DA:	rs.b 2						; DATA XREF: STOPZ80BUS↑w
										; STARTZ80BUS+8↑r
byte_FFF7DC:	rs.b 1						; DATA XREF: sub_20C042↑r
										; ROM:0020C10A↑r ...
			rs.b $23
byte_FFF800:	rs.b $200					; DATA XREF: sub_201D76+64↑o
										; sub_20325E↑o
byte_FFFA00:	rs.b $80					; DATA XREF: sub_200252+2C↑o
										; sub_20037A+2C↑o
byte_FFFA80:	rs.b $80					; DATA XREF: sub_200252+28↑o
										; sub_2002E2+18↑o ...
byte_FFFB00:	rs.b $80					; DATA XREF: sub_200220+2↑o
										; sub_200252+2↑o ...
byte_FFFB80:	rs.b $80					; DATA XREF: sub_200252+6↑o
										; sub_20037A+6↑o
			rs.b $400
; end of 'RAM'
	rsreset