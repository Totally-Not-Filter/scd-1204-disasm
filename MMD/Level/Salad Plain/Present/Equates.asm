; VRAM Location Equates
plane_w:	equ	$A000
plane_a:	equ	$C000
plane_b:	equ	$E000
sprtbl_vram:	equ	$F800
hscroll_vram:	equ	$FC00

; Z80 Equates
z80ram:		equ	$A00000
z80busreq:	equ	$A11100
z80reset:	equ	$A11200

version:	EQU	$A10001
port_1:		EQU	$A10003
port_2:		EQU	$A10005
port_3:		EQU	$A10007
cont_1:		EQU	$A10009
cont_2:		EQU	$A1000B
cont_3:		EQU	$A1000D

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
scpu_unk0:		rs.b	1	; $06
scpu_unk1:		rs.b	1	; $07
scpu_unk2:		rs.b	1	; $08
scpu_unk3:		rs.b	1	; $09
scpu_unk4:		rs.b	1	; $0A
scpu_unk5:		rs.b	1	; $0B
scpu_unk6:		rs.b	1	; $0C
scpu_unk7:		rs.b	1	; $0D
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
id:			ds.b 1
render:		ds.b 1
vram:		ds.w 1
mappings:	ds.l 1
xpos:		ds.l 1
obj.scrypos:	equ obj.xpos+2
ypos:		ds.l 1
xvel:		ds.w 1
yvel:		ds.w 1
inertia:	ds.w 1
height:		ds.b 1
width:		ds.b 1
priority:	ds.b 1
field_19:	ds.b 1
frame:		ds.b 1
aniframe:	ds.b 1
ani:		ds.b 1
prevani:	ds.b 1
time:		ds.b 1
field_1F:	ds.b 1
colflag:	ds.b 1
field_21:	ds.b 1
status:		ds.b 1
field_23:	ds.b 1
routine:	ds.b 1
routine2:	ds.b 1
angle:		ds.b 1
field_27:	ds.b 1
subtype:	ds.b 1
field_29:	ds.b 1
field_2A:	ds.b 1
field_2B:	ds.b 1
field_2C:	ds.b 1
field_2D:	ds.b 1
field_2E:	ds.b 1
field_2F:	ds.b 1
field_30:	ds.b 1
field_31:	ds.b 1
field_32:	ds.b 1
field_33:	ds.b 1
field_34:	ds.b 1
field_35:	ds.b 1
field_36:	ds.b 1
field_37:	ds.b 1
field_38:	ds.b 1
field_39:	ds.b 1
field_3A:	ds.b 1
field_3B:	ds.b 1
field_3C:	ds.b 1
field_3D:	ds.b 1
field_3E:	ds.b 1
field_3F:	ds.b 1
			ends

; Chunk Equates
chunksize:	equ	(16*2)*16	; (width*2) * height

; Game Mode Equates
gmmodeid_lvl:	equ	level_ptr-gamemode_index

; Vertical Interrupts Equates
vintid_00:	equ vint00_ptr-vint_index
vintid_02:	equ vint02_ptr-vint_index
vintid_04:	equ vint04_ptr-vint_index
vintid_06:	equ vint06_ptr-vint_index
vintid_08:	equ vint08_ptr-vint_index
vintid_0A:	equ vint0A_ptr-vint_index
vintid_0C:	equ vint0C_ptr-vint_index
vintid_0E:	equ vint0E_ptr-vint_index
vintid_10:	equ vint10_ptr-vint_index
vintid_12:	equ vint12_ptr-vint_index
vintid_14:	equ vint14_ptr-vint_index
vintid_16:	equ vint16_ptr-vint_index
vintid_18:	equ vint18_ptr-vint_index

; Object Equates
objid_00:	equ	0
objid_01:	equ	(obj01_ptr-off_2034AE+4)/4
objid_02:	equ	(obj02_ptr-off_2034AE+4)/4
objid_03:	equ	(obj03_ptr-off_2034AE+4)/4
objid_04:	equ	(obj04_ptr-off_2034AE+4)/4
objid_05:	equ	(obj05_ptr-off_2034AE+4)/4
objid_06:	equ	(obj06_ptr-off_2034AE+4)/4
objid_07:	equ	(obj07_ptr-off_2034AE+4)/4
objid_08:	equ	(obj08_ptr-off_2034AE+4)/4
objid_09:	equ	(obj09_ptr-off_2034AE+4)/4
objid_0A:	equ	(obj0A_ptr-off_2034AE+4)/4
objid_0B:	equ	(obj0B_ptr-off_2034AE+4)/4
objid_0C:	equ	(obj0C_ptr-off_2034AE+4)/4
objid_0D:	equ	(obj0D_ptr-off_2034AE+4)/4
objid_0E:	equ	(obj0E_ptr-off_2034AE+4)/4
objid_0F:	equ	(obj0F_ptr-off_2034AE+4)/4
objid_10:	equ	(obj10_ptr-off_2034AE+4)/4
objid_11:	equ	(obj11_ptr-off_2034AE+4)/4
objid_12:	equ	(obj12_ptr-off_2034AE+4)/4
objid_13:	equ	(obj13_ptr-off_2034AE+4)/4
objid_14:	equ	(obj14_ptr-off_2034AE+4)/4
objid_15:	equ	(obj15_ptr-off_2034AE+4)/4
objid_16:	equ	(obj16_ptr-off_2034AE+4)/4
objid_17:	equ	(obj17_ptr-off_2034AE+4)/4
objid_18:	equ	(obj18_ptr-off_2034AE+4)/4
objid_19:	equ	(obj19_ptr-off_2034AE+4)/4
objid_1A:	equ	(obj1A_ptr-off_2034AE+4)/4
objid_1B:	equ	(obj1B_ptr-off_2034AE+4)/4
objid_1C:	equ	(obj1C_ptr-off_2034AE+4)/4
objid_1D:	equ	(obj1D_ptr-off_2034AE+4)/4
objid_1E:	equ	(obj1E_ptr-off_2034AE+4)/4
objid_1F:	equ	(obj1F_ptr-off_2034AE+4)/4
objid_23:	equ	$23
objid_25:	equ	$25
objid_29:	equ	$29

; Palette Equates
palid_segabg:	equ	(pal_segabg_ptr-pal_index)/8
palid_title:	equ	(pal_title_ptr-pal_index)/8
palid_levelsel:	equ	(pal_levelsel_ptr-pal_index)/8
palid_player:	equ	(pal_player_ptr-pal_index)/8
palid_spz:	equ	(pal_spz_ptr-pal_index)/8

; Division Developer Equates
ddevid_00:	equ (ddev_00_ptr-divdev_index)/2
ddevid_01:	equ (ddev_01_ptr-divdev_index)/2
ddevid_02:	equ (ddev_02_ptr-divdev_index)/2
ddevid_03:	equ (ddev_03_ptr-divdev_index)/2
ddevid_04:	equ (ddev_04_ptr-divdev_index)/2
ddevid_05:	equ (ddev_05_ptr-divdev_index)/2
ddevid_06:	equ (ddev_06_ptr-divdev_index)/2
ddevid_07:	equ (ddev_07_ptr-divdev_index)/2
ddevid_08:	equ (ddev_08_ptr-divdev_index)/2
ddevid_09:	equ (ddev_09_ptr-divdev_index)/2
ddevid_0A:	equ (ddev_0A_ptr-divdev_index)/2
ddevid_0B:	equ (ddev_0B_ptr-divdev_index)/2
ddevid_0C:	equ (ddev_0C_ptr-divdev_index)/2
ddevid_0D:	equ (ddev_0D_ptr-divdev_index)/2
ddevid_0E:	equ (ddev_0E_ptr-divdev_index)/2
ddevid_0F:	equ (ddev_0F_ptr-divdev_index)/2

; Zone Equates
zoneid_SPZ:	equ	0

; Act Equates
actid_1:	equ 0
actid_2:	equ	1
actid_3:	equ	2
actid_4:	equ	3

; Sonic The Hedgehog (Mega Drive) Leftover Equates

; Game Mode Equates
gmmodeid_lvl_S1:	equ	$C
gmmodeid_ss:		equ	$10

; Zone Equates
zoneid_LZ:	equ	1
zoneid_MZ:	equ	2
zoneid_SLZ:	equ	3

; Music ID Equates
musid_GHZ:	equ	$81
musid_LZ:	equ	$82
musid_MZ:	equ	$83
musid_SLZ:	equ	$84
musid_SYZ:	equ	$85
musid_SBZ:	equ	$86
musid_FZ:	equ	$8D