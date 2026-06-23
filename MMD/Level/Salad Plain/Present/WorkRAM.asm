; ===========================================================================
; Segment type: Regular
; segment "RAM"

	include	"s1.sounddriver.ram.asm"

	rsset	$FF0000
			rs.b $580
byte_FF0580:	rs.b 1
byte_FF0580_ext:	equ	byte_FF0580+$FF<<24
			rs.b $A7F
stackwk:	rs.b $200
stackwk_end:	rs.b 0
			rs.b 2
lvl_reset:	rs.w 1
word_FF1204:	rs.w 1
byte_FF1206:	rs.b 1
			rs.b 1
word_FF1208:	rs.w 1
			rs.b 2
dword_FF120C:	rs.l 1
zone:		rs.b 1
act:		rs.b 1
byte_FF1212:	rs.b 1
			rs.b 1
play_air:	rs.w 1
			rs.b 3
byte_FF1219:	rs.b 1
byte_FF121A:	rs.b 1
byte_FF121B:	rs.b 1
byte_FF121C:	rs.b 1
byte_FF121D:	rs.b 1
byte_FF121E:	rs.b 1
byte_FF121F:	rs.b 1
word_FF1220:	rs.w 1
byte_FF1222:	rs.b 1
byte_FF1223:	rs.b 1
byte_FF1224:	rs.b 1
byte_FF1225:	rs.b 1
dword_FF1226:	rs.l 1
byte_FF122A:	rs.b 1
			rs.b 1
byte_FF122C:	rs.b 1
byte_FF122D:	rs.b 1
byte_FF122E:	rs.b 1
byte_FF122F:	rs.b 1
byte_FF1230:	rs.b 1
byte_FF1231:	rs.b 1
word_FF1232:	rs.w 1
word_FF1234:	rs.w 1
word_FF1236:	rs.w 1
dword_FF1238:	rs.l 1
byte_FF123C:	rs.b 1
byte_FF123D:	rs.b 1
word_FF123E:	rs.w 1
word_FF1240:	rs.w 1
word_FF1242:	rs.w 1
word_FF1244:	rs.w 1
word_FF1246:	rs.w 1
word_FF1248:	rs.w 1
word_FF124A:	rs.w 1
word_FF124C:	rs.w 1
word_FF124E:	rs.w 1
word_FF1250:	rs.w 1
byte_FF1252:	rs.b 1
byte_FF1253:	rs.b 1
byte_FF1254:	rs.b 1
byte_FF1255:	rs.b 1
word_FF1256:	rs.w 1
word_FF1258:	rs.w 1
byte_FF125A:	rs.b 1
			rs.b 1
word_FF125C:	rs.w 1
word_FF125E:	rs.w 1
word_FF1260:	rs.w 1
word_FF1262:	rs.w 1
word_FF1264:	rs.w 1
word_FF1266:	rs.w 1
word_FF1268:	rs.w 1
word_FF126A:	rs.w 1
word_FF126C:	rs.w 1
word_FF126E:	rs.w 1
byte_FF1270:	rs.b 1
byte_FF1271:	rs.b 1
			rs.b 6
word_FF1278:	rs.w 1
byte_FF127A:	rs.b 1
byte_FF127B:	rs.b 1
			rs.b $44
byte_FF12C0:	rs.b 1
byte_FF12C1:	rs.b 1
ring_time:	rs.b 1
ring_frame:	rs.b 1
byte_FF12C4:	rs.b 1
byte_FF12C5:	rs.b 1
byte_FF12C6:	rs.b 1
byte_FF12C7:	rs.b 1
word_FF12C8:	rs.w 1
			rs.b $2A
word_FF12F4:	rs.w 1
			rs.b $1A
dword_FF1310:	rs.l 1
			rs.b 4
dword_FF1318:	rs.l 1
			rs.b 4
byte_FF1320:	rs.b 8
byte_FF1328:	rs.b 8
dword_FF1330:	rs.l 1
word_FF1334:	rs.w 1
word_FF1336:	rs.w 1
			rs.b $B4
byte_FF13EC:	rs.b 1
byte_FF13ED:	rs.b 1
byte_FF13EE:	rs.b 1
byte_FF13EF:	rs.b 1
word_FF13F0:	rs.w 1
			rs.b 2
word_FF13F4:	rs.w 1
			rs.b 2
mdstatus:	rs.b 1
			rs.b 1
word_FF13FA:	rs.w 1
init_f:	rs.l 1
unk_FF1400: rs.b $180
unk_FF1400_end:	rs.b 0
byte_FF1580:	rs.b $300
dword_FF1880:	rs.l 1
word_FF1884:	rs.w 1
byte_FF1886:	rs.b 1
			rs.b 3
byte_FF188A:	rs.b 1
			rs.b $75
byte_FF1900:	rs.b $300
byte_FF1900_end:	rs.b 0
			rs.b $6400
	rsreset

	rsset	$FFFF8000
			rs.b $2400
lvllayoutwk:	rs.b $400
lvllayoutwk_end:	rs.b 0
byte_FFA800:	rs.b $200
bitdevwk:	rs.b $200
spr_list:	rs.b $400
blkwk:		rs.b $1800
playwrtwk:	rs.b $300
playposiwk:	rs.b $100
hscrollwk:	rs.b $400
hscrollwk_end:	rs.b 0
actwk:		rs.b obj
byte_FFD040:	rs.b obj
byte_FFD080:	rs.b obj
byte_FFD0C0:	rs.b obj
			rs.b obj
			rs.b obj
byte_FFD180:	rs.b obj
			rs.b obj
byte_FFD200:	rs.b obj
byte_FFD240:	rs.b obj
byte_FFD280:	rs.b obj
byte_FFD2C0:	rs.b obj
byte_FFD300:	rs.b obj
byte_FFD340:	rs.b obj
byte_FFD380:	rs.b obj
byte_FFD3C0:	rs.b obj
unk_FFD400: rs.b $400
byte_FFD800:	rs.b $1800
byte_FFD800_end:	rs.b 0
actwk_end:	rs.b 0

soundram:	rs.b SMPS_RAM
			rs.b $40
gamemode:	rs.b 1
			rs.b 1
word_FFF602:	rs.w 1
word_FFF604:	rs.w 1
word_FFF606:	rs.w 1
			rs.b 4
word_FFF60C:	rs.w 1
			rs.b 6
generictimer:	rs.w 1
dword_FFF616:	rs.l 1
dword_FFF61A:	rs.l 1
			rs.b 6
word_FFF624:	rs.w 1
word_FFF626:	rs.w 1
byte_FFF628:	rs.b 1
			rs.b 1
vint_mode:	rs.b 1
			rs.b 1
byte_FFF62C:	rs.b 1
			rs.b 5
byte_FFF632:	rs.b 1
byte_FFF633:	rs.b 1
			rs.b 2
dword_FFF636:	rs.l 1
word_FFF63A:	rs.w 1
			rs.b 4
word_FFF640:	rs.w 1
			rs.b 2
word_FFF644:	rs.w 1
			rs.b 2
word_FFF648:	rs.w 1
			rs.b 3
byte_FFF64D:	rs.b 1
byte_FFF64E:	rs.b 1
byte_FFF64F:	rs.b 1
			rs.b $C
byte_FFF65C:	rs.b 1
byte_FFF65D:	rs.b 1
			rs.b $22
dword_FFF680:	rs.l 1
word_FFF684:	rs.w 1
			rs.b $5A
dword_FFF6E0:	rs.l 1
dword_FFF6E4:	rs.l 1
dword_FFF6E8:	rs.l 1
dword_FFF6EC:	rs.l 1
dword_FFF6F0:	rs.l 1
dword_FFF6F4:	rs.l 1
word_FFF6F8:	rs.w 1
word_FFF6FA:	rs.w 1
			rs.b 4
dword_FFF700:	rs.l 1
dword_FFF704:	rs.l 1
dword_FFF708:	rs.l 1
dword_FFF70C:	rs.l 1
dword_FFF710:	rs.l 1
word_FFF714:	rs.w 1
			rs.b 2
dword_FFF718:	rs.l 1
word_FFF71C:	rs.w 1
			rs.b 2
dword_FFF720:	rs.l 1
dword_FFF724:	rs.l 1
dword_FFF728:	rs.l 1
dword_FFF72C:	rs.l 1
word_FFF730:	rs.w 1
word_FFF732:	rs.w 1
			rs.b 6
word_FFF73A:	rs.w 1
word_FFF73C:	rs.w 1
word_FFF73E:	rs.w 1
byte_FFF740:	rs.b 1
byte_FFF741:	rs.b 1
byte_FFF742:	rs.b 1
			rs.b 1
byte_FFF744:	rs.b 1
			rs.b 1
byte_FFF746:	rs.b 1
			rs.b 1
byte_FFF748:	rs.b 1
			rs.b 1
word_FFF74A:	rs.w 1
byte_FFF74C:	rs.b 1
byte_FFF74D:	rs.b 1
byte_FFF74E:	rs.b 1
			rs.b 1
byte_FFF750:	rs.b 1
			rs.b 3
dword_FFF754:	rs.l 1
word_FFF758:	rs.w 1
word_FFF75A:	rs.w 1
byte_FFF75C:	rs.b 1
byte_FFF75D:	rs.b 1
chibi_flag:	rs.b 1
byte_FFF75F:	rs.b 1
word_FFF760:	rs.w 1
word_FFF762:	rs.w 1
word_FFF764:	rs.w 1
byte_FFF766:	rs.b 1
byte_FFF767:	rs.b 1
byte_FFF768:	rs.b 1
			rs.b 1
byte_FFF76A:	rs.b 1
			rs.b 1
byte_FFF76C:	rs.b 1
			rs.b 1
word_FFF76E:	rs.w 1
dword_FFF770:	rs.l 1
dword_FFF774:	rs.l 1
dword_FFF778:	rs.l 1
dword_FFF77C:	rs.l 1
word_FFF780:	rs.w 1
word_FFF782:	rs.w 1
byte_FFF784:	rs.b 1
			rs.b 1
word_FFF786:	rs.w 1
byte_FFF788:	rs.b 1
			rs.b 7
word_FFF790:	rs.w 1
			rs.b 4
dword_FFF796:	rs.l 1
			rs.b $E
word_FFF7A8:	rs.w 1
byte_FFF7AA:	rs.b 1
			rs.b 1
dword_FFF7AC:	rs.l 1
			rs.b $17
byte_FFF7C7:	rs.b 1
			rs.b 2
byte_FFF7CA:	rs.b 1
			rs.b 1
byte_FFF7CC:	rs.b 1
			rs.b 3
word_FFF7D0:	rs.w 1
			rs.b 8
word_FFF7DA:	rs.w 1
byte_FFF7DC:	rs.b 1
			rs.b $23
byte_FFF800:	rs.b $280
byte_FFF800_end:	rs.b 0
palette_water_fade:	equ byte_FFF800_end-$80
palette_water:	rs.b $80
palette:	rs.b $80
palette_fade:	rs.b $80
			rs.b $400
	rsreset