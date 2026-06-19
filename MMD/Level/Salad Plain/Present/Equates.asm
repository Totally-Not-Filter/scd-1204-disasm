; VRAM Location Equates
plane_w:	equ	$A000
plane_a:	equ	$C000
plane_b:	equ	$E000
sprtbl_vram:	equ	$F800
hscroll_vram:	equ	$FC00

; Z80 Equates
z80busreq:	equ	$A11100
z80reset:	equ	$A11200

; VDP Equates
vdpdata:	equ	$C00000
vdpctrl:	equ	$C00004

; Mega CD Equates
wkram:	equ $200000

; Mega CD Sub-CPU Equates
scpu_IRQ2:	equ	$A12000
scpu_commcmd0:	equ	$A12010
scpu_commstats:	equ	$A12020

; Mega CD Sub-CPU Commands
	rsset	1
scpu_r11aload:	rs.b	1	; $01
scpu_r11bload:	rs.b	1	; $02
scpu_r11cload:	rs.b	1	; $03
scpu_r11dload:	rs.b	1	; $04
scpu_mdinit:	rs.b	1	; $05
scpu_unk0:	rs.b	1	; $06
scpu_unk1:	rs.b	1	; $07
scpu_unk2:	rs.b	1	; $08
scpu_unk3:	rs.b	1	; $09
scpu_unk4:	rs.b	1	; $0A
scpu_unk5:	rs.b	1	; $0B
scpu_unk6:	rs.b	1	; $0C
scpu_unk7:	rs.b	1	; $0D
scpu_fadeCDA:	rs.b	1	; $0E Fade out CDDA music
scpu_r11aMUS:	rs.b	1	; $0F Track 2 (Salad Plain Present)
scpu_timeattackMUS:	rs.b	1	; $10 Track 3 (Collision Chaos Present)
scpu_titleMUS:	rs.b	1	; $11 Track 4 (You Can Do Anything)
scpu_r11dMUS:	rs.b	1	; $12 Track 5 (Salad Plain Good Future)
scpu_r11cMUS:	rs.b	1	; $13 Track 6 (Salad Plain Bad Future)
scpu_r11bMUS:	rs.b	1	; $14 Track 7 (Salad Plain Past)
	rsreset

; Object Structs
obj			struct
id:			dc.b 1
render:		dc.b 1
vram:		dc.w 1
mappings:	dc.l 1
xpos:		dc.l 1
obj.scrypos:	equ obj.xpos+2
ypos:		dc.l 1
xvel:		dc.w 1
yvel:		dc.w 1
inertia:	dc.b 1
field_15:	dc.b 1
field_16:	dc.b 1
field_17:	dc.b 1
priority:	dc.b 1
field_19:	dc.b 1
frame:		dc.b 1
field_1B:	dc.b 1
ani:		dc.b 1
prevani:	dc.b 1
field_1E:	dc.b 1
field_1F:	dc.b 1
colflag:	dc.b 1
field_21:	dc.b 1
status:		dc.b 1
field_23:	dc.b 1
routine:	dc.b 1
routine2:	dc.b 1
angle:		dc.b 1
field_27:	dc.b 1
field_28:	dc.b 1
field_29:	dc.b 1
field_2A:	dc.b 1
field_2B:	dc.b 1
field_2C:	dc.b 1
field_2D:	dc.b 1
field_2E:	dc.b 1
field_2F:	dc.b 1
field_30:	dc.b 1
field_31:	dc.b 1
field_32:	dc.b 1
field_33:	dc.b 1
field_34:	dc.b 1
field_35:	dc.b 1
field_36:	dc.b 1
field_37:	dc.b 1
field_38:	dc.b 1
field_39:	dc.b 1
field_3A:	dc.b 1
field_3B:	dc.b 1
field_3C:	dc.b 1
field_3D:	dc.b 1
field_3E:	dc.b 1
field_3F:	dc.b 1
			ends

; Zone Equates
zoneid_SPZ:	equ	0

; Act Equates
actid_1:	equ 0
actid_2:	equ	1
actid_3:	equ	2
actid_4:	equ	3

; Sonic The Hedgehog (Mega Drive) Leftover Equates
zoneid_LZ:	equ	1
zoneid_MZ:	equ	2
zoneid_SLZ:	equ	3

musid_GHZ:	equ	$81
musid_LZ:	equ	$82
musid_MZ:	equ	$83
musid_SLZ:	equ	$84
musid_SYZ:	equ	$85
musid_SBZ:	equ	$86
musid_FZ:	equ	$8D