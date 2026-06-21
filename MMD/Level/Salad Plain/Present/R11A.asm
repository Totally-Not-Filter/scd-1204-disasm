; CD Sonic The Hedgehog R11A Disassembly
; Date of R11A: December 4, 1992 21:34:01

	include	"WorkRAM.asm"
	include	"Equates.asm"
	include	"Macros.asm"
	include	"Functions.asm"

	obj	wkram	; set section to use workram

vectors:
			dc.l 0
			dc.l 0
			dc.l MMD_INIT
			dc.l MMD_HINT
			dc.l MMD_VINT
			align $100
MMD_INIT:
			jmp	(init).l
; ---------------------------------------------------------------------------
			jmp	(MMD_ERROR).l
; ---------------------------------------------------------------------------
MMD_HINT:
			jmp	(hint).l
; ---------------------------------------------------------------------------
MMD_VINT:
			jmp	(vint).l
; ---------------------------------------------------------------------------
MMD_ERROR:
			nop
			nop
			bra.s	MMD_ERROR
; ---------------------------------------------------------------------------
init:
			btst	#6,($A1000D).l
			beq.s	loc_200136
			cmpi.l	#"init",(dword_FF13FC).l
			beq.w	loc_200162
loc_200136:
			lea	(unk_FF1000).l,a6
			moveq	#0,d7
			move.w	#(unk_FF1000_end-unk_FF1000)/4-1,d6
loc_200142:
			move.l	d7,(a6)+
			dbf	d6,loc_200142

			move.b	($A10001).l,d0
			andi.b	#$C0,d0
			move.b	d0,(byte_FF13F8).l
			move.l	#"init",(dword_FF13FC).l
loc_200162:
			bsr.w	initvdp
			bsr.w	initjoypads
			move.b	#gmmodeid_lvl,(gamemode).w
			move.b	(gamemode).w,d0
			andi.w	#$1C,d0
			jmp	gamemode_index(pc,d0.w)
; ---------------------------------------------------------------------------

gmmode_ptr	macro
\1_ptr:	bra.w	\1
	endm

gamemode_index:
			gmmode_ptr	level

; =============== S U B R O U T I N E =======================================
sub_200180:
			lea	(word_2001F0).l,a0
			subq.b	#1,(byte_FFF65C).w
			bpl.s	loc_2001B6
			move.b	#7,(byte_FFF65C).w
			moveq	#0,d0
			move.b	(byte_FFF632).w,d0
			cmpi.b	#2,d0
			bne.s	loc_2001A2
			moveq	#0,d0
			bra.s	loc_2001A4
; ---------------------------------------------------------------------------
loc_2001A2:
			addq.b	#1,d0
loc_2001A4:
			move.b	d0,(byte_FFF632).w
			lsl.w	#3,d0
			lea	(palette+$6A).w,a1
			move.l	(a0,d0.w),(a1)+
			move.l	4(a0,d0.w),(a1)
loc_2001B6:
			adda.w	#$18,a0
			subq.b	#1,(byte_FFF65D).w
			bpl.s	locret_2001EE
			move.b	#5,(byte_FFF65D).w
			moveq	#0,d0
			move.b	(byte_FFF633).w,d0
			cmpi.b	#2,d0
			bne.s	loc_2001D6
			moveq	#0,d0
			bra.s	loc_2001D8
; ---------------------------------------------------------------------------
loc_2001D6:
			addq.b	#1,d0
loc_2001D8:
			move.b	d0,(byte_FFF633).w
			andi.w	#3,d0
			lsl.w	#3,d0
			lea	(palette+$58).w,a1
			move.l	(a0,d0.w),(a1)+
			move.l	4(a0,d0.w),(a1)
locret_2001EE:
			rts
; End of function sub_200180
; ---------------------------------------------------------------------------
word_2001F0:
			dc.w  $ECC, $ECA, $EEE, $EA8
			dc.w  $EA8, $ECC, $ECC, $ECA
			dc.w  $ECA, $EA8, $ECA, $ECC
			dc.w  $ECA, $EA8, $C60, $E86
			dc.w  $EA8, $E86, $C60, $ECA
			dc.w  $E86, $ECA, $C60, $EA8
; =============== S U B R O U T I N E =======================================
sub_200220:
			moveq	#0,d0
			lea	(palette).w,a0
			move.b	(word_FFF626).w,d0
			adda.w	d0,a0
			moveq	#0,d1
			move.b	(word_FFF626+1).w,d0
loc_200232:
			move.w	d1,(a0)+
			dbf	d0,loc_200232

			move.w	#$16-1,d4
loc_20023C:
			move.b	#vintid_12,(vint_mode).w
			bsr.w	vsync
			bsr.s	sub_200252
			bsr.w	sub_20209A
			dbf	d4,loc_20023C

			rts
; End of function sub_200220
; =============== S U B R O U T I N E =======================================
sub_200252:
			moveq	#0,d0
			lea	(palette).w,a0
			lea	(palette_fade).w,a1
			move.b	(word_FFF626).w,d0
			adda.w	d0,a0
			adda.w	d0,a1
			move.b	(word_FFF626+1).w,d0
loc_200268:
			bsr.s	sub_200296
			dbf	d0,loc_200268

			cmpi.b	#zoneid_LZ,(zone).l
			bne.s	locret_200294
			moveq	#0,d0
			lea	(palette_water).w,a0
			lea	(palette_water_fade).w,a1
			move.b	(word_FFF626).w,d0
			adda.w	d0,a0
			adda.w	d0,a1
			move.b	(word_FFF626+1).w,d0
loc_20028E:
			bsr.s	sub_200296
			dbf	d0,loc_20028E

locret_200294:
			rts
; End of function sub_200252
; =============== S U B R O U T I N E =======================================
sub_200296:
			move.w	(a1)+,d2
			move.w	(a0),d3
			cmp.w	d2,d3
			beq.s	loc_2002BE
			move.w	d3,d1
			addi.w	#$200,d1
			cmp.w	d2,d1
			bhi.s	loc_2002AC
			move.w	d1,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_2002AC:
			move.w	d3,d1
			addi.w	#$20,d1
			cmp.w	d2,d1
			bhi.s	loc_2002BA
			move.w	d1,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_2002BA:
			addq.w	#2,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_2002BE:
			addq.w	#2,a0
			rts
; End of function sub_200296
; =============== S U B R O U T I N E =======================================
sub_2002C2:
			move.w	#$3F,(word_FFF626).w
			move.w	#$16-1,d4
loc_2002CC:
			move.b	#vintid_12,(vint_mode).w
			bsr.w	vsync
			bsr.s	sub_2002E2
			bsr.w	sub_20209A
			dbf	d4,loc_2002CC

			rts
; End of function sub_2002C2
; =============== S U B R O U T I N E =======================================
sub_2002E2:
			moveq	#0,d0
			lea	(palette).w,a0
			move.b	(word_FFF626).w,d0
			adda.w	d0,a0
			move.b	(word_FFF626+1).w,d0
loc_2002F2:
			bsr.s	sub_200310
			dbf	d0,loc_2002F2

			moveq	#0,d0
			lea	(palette_water).w,a0
			move.b	(word_FFF626).w,d0
			adda.w	d0,a0
			move.b	(word_FFF626+1).w,d0
loc_200308:
			bsr.s	sub_200310
			dbf	d0,loc_200308

			rts
; End of function sub_2002E2
; =============== S U B R O U T I N E =======================================
sub_200310:
			move.w	(a0),d2
			beq.s	loc_20033C
			move.w	d2,d1
			andi.w	#$E,d1
			beq.s	loc_200320
			subq.w	#2,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_200320:
			move.w	d2,d1
			andi.w	#$E0,d1
			beq.s	loc_20032E
			subi.w	#$20,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_20032E:
			move.w	d2,d1
			andi.w	#$E00,d1
			beq.s	loc_20033C
			subi.w	#$200,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_20033C:
			addq.w	#2,a0
			rts
; End of function sub_200310
; =============== S U B R O U T I N E =======================================
sub_200340:
			move.w	#$3F,(word_FFF626).w
			moveq	#0,d0
			lea	(palette).w,a0
			move.b	(word_FFF626).w,d0
			adda.w	d0,a0
			move.w	#$EEE,d1
			move.b	(word_FFF626+1).w,d0
loc_20035A:
			move.w	d1,(a0)+
			dbf	d0,loc_20035A

			move.w	#$16-1,d4
loc_200364:
			move.b	#vintid_12,(vint_mode).w
			bsr.w	vsync
			bsr.s	sub_20037A
			bsr.w	sub_20209A
			dbf	d4,loc_200364

			rts
; End of function sub_200340
; =============== S U B R O U T I N E =======================================
sub_20037A:
			moveq	#0,d0
			lea	(palette).w,a0
			lea	(palette_fade).w,a1
			move.b	(word_FFF626).w,d0
			adda.w	d0,a0
			adda.w	d0,a1
			move.b	(word_FFF626+1).w,d0
loc_200390:
			bsr.s	sub_2003BE
			dbf	d0,loc_200390

			cmpi.b	#zoneid_LZ,(zone).l
			bne.s	locret_2003BC
			moveq	#0,d0
			lea	(palette_water).w,a0
			lea	(palette_water_fade).w,a1
			move.b	(word_FFF626).w,d0
			adda.w	d0,a0
			adda.w	d0,a1
			move.b	(word_FFF626+1).w,d0
loc_2003B6:
			bsr.s	sub_2003BE
			dbf	d0,loc_2003B6

locret_2003BC:
			rts
; End of function sub_20037A
; =============== S U B R O U T I N E =======================================
sub_2003BE:
			move.w	(a1)+,d2
			move.w	(a0),d3
			cmp.w	d2,d3
			beq.s	loc_2003EA
			move.w	d3,d1
			subi.w	#$200,d1
			bcs.s	loc_2003D6
			cmp.w	d2,d1
			bcs.s	loc_2003D6
			move.w	d1,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_2003D6:
			move.w	d3,d1
			subi.w	#$20,d1
			bcs.s	loc_2003E6
			cmp.w	d2,d1
			bcs.s	loc_2003E6
			move.w	d1,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_2003E6:
			subq.w	#2,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_2003EA:
			addq.w	#2,a0
			rts
; End of function sub_2003BE
; =============== S U B R O U T I N E =======================================
sub_2003EE:
			move.w	#$3F,(word_FFF626).w
			move.w	#$16-1,d4
loc_2003F8:
			move.b	#vintid_12,(vint_mode).w
			bsr.w	vsync
			bsr.s	sub_20040E
			bsr.w	sub_20209A
			dbf	d4,loc_2003F8

			rts
; End of function sub_2003EE
; =============== S U B R O U T I N E =======================================
sub_20040E:
			moveq	#0,d0
			lea	(palette).w,a0
			move.b	(word_FFF626).w,d0
			adda.w	d0,a0
			move.b	(word_FFF626+1).w,d0
loc_20041E:
			bsr.s	sub_20043C
			dbf	d0,loc_20041E

			moveq	#0,d0
			lea	(palette_water).w,a0
			move.b	(word_FFF626).w,d0
			adda.w	d0,a0
			move.b	(word_FFF626+1).w,d0
loc_200434:
			bsr.s	sub_20043C
			dbf	d0,loc_200434

			rts
; End of function sub_20040E
; =============== S U B R O U T I N E =======================================
sub_20043C:
			move.w	(a0),d2
			cmpi.w	#$EEE,d2
			beq.s	loc_200478
			move.w	d2,d1
			andi.w	#$E,d1
			cmpi.w	#$E,d1
			beq.s	loc_200454
			addq.w	#2,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_200454:
			move.w	d2,d1
			andi.w	#$E0,d1
			cmpi.w	#$E0,d1
			beq.s	loc_200466
			addi.w	#$20,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_200466:
			move.w	d2,d1
			andi.w	#$E00,d1
			cmpi.w	#$E00,d1
			beq.s	loc_200478
			addi.w	#$200,(a0)+
			rts
; ---------------------------------------------------------------------------
loc_200478:
			addq.w	#2,a0
			rts
; End of function sub_20043C
; =============== S U B R O U T I N E =======================================
palload_fade:
			lea	(pal_index).l,a1
			lsl.w	#3,d0
			adda.w	d0,a1
			movea.l (a1)+,a2
			movea.w (a1)+,a3
			adda.w	#palette_fade-palette,a3
			move.w	(a1)+,d7
loc_200490:
			move.l	(a2)+,(a3)+
			dbf	d7,loc_200490

			rts
; End of function palload_fade
; =============== S U B R O U T I N E =======================================
palload:
			lea	(pal_index).l,a1
			lsl.w	#3,d0
			adda.w	d0,a1
			movea.l (a1)+,a2
			movea.w (a1)+,a3
			move.w	(a1)+,d7
loc_2004A8:
			move.l	(a2)+,(a3)+
			dbf	d7,loc_2004A8

			rts
; End of function palload
; ---------------------------------------------------------------------------

pal_ptr	macro
\1_ptr:
	dc.l \1
	dc.w palette+\2*$10
	dc.w \3/2-1
	endm

pal_index:
			pal_ptr pal_segabg,0,$40
			pal_ptr pal_title,0,$40
			pal_ptr pal_levelsel,0,$40
			pal_ptr pal_player,0,$10
			pal_ptr pal_spz,2,$30

pal_segabg:
pal_title:
			incbin	"Palettes/Title Screen (Sonic 1).bin"
			even

pal_levelsel:
			incbin	"Palettes/Level Select (Sonic 1).bin"
			even

pal_player:
			incbin	"Palettes/Sonic.bin"
			even

pal_spz:
			incbin	"Palettes/SPZ.bin"
			even
; ---------------------------------------------------------------------------
			move.w	obj.xpos(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bhi.w	loc_20067A
			bra.w	displaysprite
; ---------------------------------------------------------------------------
loc_20067A:
			lea	(unk_FF1400).l,a2
			moveq	#0,d0
			move.b	obj.field_23(a0),d0
			beq.s	loc_20068E
			bclr	#7,2(a2,d0.w)
loc_20068E:
			bra.w	deleteobj
; =============== S U B R O U T I N E =======================================
vsync:
			move.w	#$2300,sr
loc_200696:
			tst.b	(vint_mode).w
			bne.s	loc_200696
			rts
; End of function vsync
; =============== S U B R O U T I N E =======================================
calcsine:
			andi.w	#$FF,d0
			add.w	d0,d0
			addi.w	#$80,d0
			move.w	word_2006B6(pc,d0.w),d1
			subi.w	#$80,d0
			move.w	word_2006B6(pc,d0.w),d0
			rts
; End of function calcsine
; ---------------------------------------------------------------------------
word_2006B6:
			dc.w	 0,	   6,	$C,	 $12,  $19,	 $1F,  $25,	 $2B,  $31,	 $38,  $3E,	 $44,  $4A,	 $50,  $56,	 $5C
			dc.w   $61,	 $67,  $6D,	 $73,  $78,	 $7E,  $83,	 $88,  $8E,	 $93,  $98,	 $9D,  $A2,	 $A7,  $AB,	 $B0
			dc.w   $B5,	 $B9,  $BD,	 $C1,  $C5,	 $C9,  $CD,	 $D1,  $D4,	 $D8,  $DB,	 $DE,  $E1,	 $E4,  $E7,	 $EA
			dc.w   $EC,	 $EE,  $F1,	 $F3,  $F4,	 $F6,  $F8,	 $F9,  $FB,	 $FC,  $FD,	 $FE,  $FE,	 $FF,  $FF,	 $FF
			dc.w  $100,	 $FF,  $FF,	 $FF,  $FE,	 $FE,  $FD,	 $FC,  $FB,	 $F9,  $F8,	 $F6,  $F4,	 $F3,  $F1,	 $EE
			dc.w   $EC,	 $EA,  $E7,	 $E4,  $E1,	 $DE,  $DB,	 $D8,  $D4,	 $D1,  $CD,	 $C9,  $C5,	 $C1,  $BD,	 $B9
			dc.w   $B5,	 $B0,  $AB,	 $A7,  $A2,	 $9D,  $98,	 $93,  $8E,	 $88,  $83,	 $7E,  $78,	 $73,  $6D,	 $67
			dc.w   $61,	 $5C,  $56,	 $50,  $4A,	 $44,  $3E,	 $38,  $31,	 $2B,  $25,	 $1F,  $19,	 $12,	$C,	   6
			dc.w	 0,$FFFA,$FFF4,$FFEE,$FFE7,$FFE1,$FFDB,$FFD5,$FFCF,$FFC8,$FFC2,$FFBC,$FFB6,$FFB0,$FFAA,$FFA4
			dc.w $FF9F,$FF99,$FF93,$FF8B,$FF88,$FF82,$FF7D,$FF78,$FF72,$FF6D,$FF68,$FF63,$FF5E,$FF59,$FF55,$FF50
			dc.w $FF4B,$FF47,$FF43,$FF3F,$FF3B,$FF37,$FF33,$FF2F,$FF2C,$FF28,$FF25,$FF22,$FF1F,$FF1C,$FF19,$FF16
			dc.w $FF14,$FF12,$FF0F,$FF0D,$FF0C,$FF0A,$FF08,$FF07,$FF05,$FF04,$FF03,$FF02,$FF02,$FF01,$FF01,$FF01
			dc.w $FF00,$FF01,$FF01,$FF01,$FF02,$FF02,$FF03,$FF04,$FF05,$FF07,$FF08,$FF0A,$FF0C,$FF0D,$FF0F,$FF12
			dc.w $FF14,$FF16,$FF19,$FF1C,$FF1F,$FF22,$FF25,$FF28,$FF2C,$FF2F,$FF33,$FF37,$FF3B,$FF3F,$FF43,$FF47
			dc.w $FF4B,$FF50,$FF55,$FF59,$FF5E,$FF63,$FF68,$FF6D,$FF72,$FF78,$FF7D,$FF82,$FF88,$FF8B,$FF93,$FF99
			dc.w $FF9F,$FFA4,$FFAA,$FFB0,$FFB6,$FFBC,$FFC2,$FFC8,$FFCF,$FFD5,$FFDB,$FFE1,$FFE7,$FFEE,$FFF4,$FFFA
			dc.w	 0,	   6,	$C,	 $12,  $19,	 $1F,  $25,	 $2B,  $31,	 $38,  $3E,	 $44,  $4A,	 $50,  $56,	 $5C
			dc.w   $61,	 $67,  $6D,	 $73,  $78,	 $7E,  $83,	 $88,  $8E,	 $93,  $98,	 $9D,  $A2,	 $A7,  $AB,	 $B0
			dc.w   $B5,	 $B9,  $BD,	 $C1,  $C5,	 $C9,  $CD,	 $D1,  $D4,	 $D8,  $DB,	 $DE,  $E1,	 $E4,  $E7,	 $EA
			dc.w   $EC,	 $EE,  $F1,	 $F3,  $F4,	 $F6,  $F8,	 $F9,  $FB,	 $FC,  $FD,	 $FE,  $FE,	 $FF,  $FF,	 $FF
; =============== S U B R O U T I N E =======================================
calcangle:
			movem.l d3-d4,-(sp)
			moveq	#0,d3
			moveq	#0,d4
			move.w	d1,d3
			move.w	d2,d4
			or.w	d3,d4
			beq.s	loc_200992
			move.w	d2,d4
			tst.w	d3
			bpl.w	loc_200950
			neg.w	d3
loc_200950:
			tst.w	d4
			bpl.w	loc_200958
			neg.w	d4
loc_200958:
			cmp.w	d3,d4
			bcc.w	loc_20096A
			lsl.l	#8,d4
			divu.w	d3,d4
			moveq	#0,d0
			move.b	byte_20099C(pc,d4.w),d0
			bra.s	loc_200974
; ---------------------------------------------------------------------------
loc_20096A:
			lsl.l	#8,d3
			divu.w	d4,d3
			moveq	#$40,d0
			sub.b	byte_20099C(pc,d3.w),d0
loc_200974:
			tst.w	d1
			bpl.w	loc_200980
			neg.w	d0
			addi.w	#$80,d0
loc_200980:
			tst.w	d2
			bpl.w	loc_20098C
			neg.w	d0
			addi.w	#$100,d0
loc_20098C:
			movem.l (sp)+,d3-d4
			rts
; ---------------------------------------------------------------------------
loc_200992:
			move.w	#$40,d0
			movem.l (sp)+,d3-d4
			rts
; End of function calcangle
; ---------------------------------------------------------------------------
byte_20099C:
			dc.b 0,0,0,0
			dc.b 1,1,1,1,1,1
			dc.b 2,2,2,2,2,2
			dc.b 3,3,3,3,3,3,3
			dc.b 4,4,4,4,4,4
			dc.b 5,5,5,5,5,5
			dc.b 6,6,6,6,6,6,6
			dc.b 7,7,7,7,7,7
			dc.b 8,8,8,8,8,8,8
			dc.b 9,9,9,9,9,9
			dc.b $A,$A,$A,$A,$A,$A,$A
			dc.b $B,$B,$B,$B,$B,$B,$B
			dc.b $C,$C,$C,$C,$C,$C,$C
			dc.b $D,$D,$D,$D,$D,$D,$D
			dc.b $E,$E,$E,$E,$E,$E,$E
			dc.b $F,$F,$F,$F,$F,$F,$F
			dc.b $10,$10,$10,$10,$10,$10,$10
			dc.b $11,$11,$11,$11,$11,$11,$11,$11
			dc.b $12,$12,$12,$12,$12,$12,$12
			dc.b $13,$13,$13,$13,$13,$13,$13,$13
			dc.b $14,$14,$14,$14,$14,$14,$14,$14
			dc.b $15,$15,$15,$15,$15,$15,$15,$15,$15
			dc.b $16,$16,$16,$16,$16,$16,$16,$16
			dc.b $17,$17,$17,$17,$17,$17,$17,$17,$17
			dc.b $18,$18,$18,$18,$18,$18,$18,$18,$18
			dc.b $19,$19,$19,$19,$19,$19,$19,$19,$19,$19
			dc.b $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
			dc.b $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
			dc.b $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
			dc.b $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
			dc.b $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
			dc.b $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
			dc.b $20,$20,$20,$20,$20,$20,$20
			dc.b 0
			even

; =============== S U B R O U T I N E =======================================
sub_200A9E:
			btst	#3,obj.status(a0)
			beq.s	loc_200AB2
			moveq	#0,d0
			move.b	d0,(byte_FFF768).w
			move.b	d0,(byte_FFF76A).w
			rts
; ---------------------------------------------------------------------------
loc_200AB2:
			moveq	#3,d0
			move.b	d0,(byte_FFF768).w
			move.b	d0,(byte_FFF76A).w
			move.b	obj.angle(a0),d0
			addi.b	#$20,d0
			bpl.s	loc_200AD4
			move.b	obj.angle(a0),d0
			bpl.s	loc_200ACE
			subq.b	#1,d0
loc_200ACE:
			addi.b	#$20,d0
			bra.s	loc_200AE0
; ---------------------------------------------------------------------------
loc_200AD4:
			move.b	obj.angle(a0),d0
			bpl.s	loc_200ADC
			addq.b	#1,d0
loc_200ADC:
			addi.b	#$1F,d0
loc_200AE0:
			andi.b	#$C0,d0
			cmpi.b	#$40,d0
			beq.w	loc_200D6A
			cmpi.b	#$80,d0
			beq.w	loc_200CC8
			cmpi.b	#$C0,d0
			beq.w	loc_200C2C
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d3
			lea	(byte_FFF768).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$D,d5
			bsr.w	sub_200E82
			move.w	d1,-(sp)
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			neg.w	d0
			add.w	d0,d3
			lea	(byte_FFF76A).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$D,d5
			bsr.w	sub_200E82
			move.w	(sp)+,d0
			bsr.w	sub_200C00
			tst.w	d1
			beq.s	locret_200B6E
			bpl.s	loc_200B70
			cmpi.w	#-$E,d1
			blt.s	locret_200B96
			add.w	d1,obj.ypos(a0)
locret_200B6E:
			rts
; ---------------------------------------------------------------------------
loc_200B70:
			cmpi.w	#$E,d1
			bgt.s	loc_200B7C
loc_200B76:
			add.w	d1,obj.ypos(a0)
			rts
; ---------------------------------------------------------------------------
loc_200B7C:
			tst.b	obj.field_38(a0)
			bne.s	loc_200B76
			bset	#1,obj.status(a0)
			bclr	#5,obj.status(a0)
			move.b	#1,obj.prevani(a0)
			rts
; ---------------------------------------------------------------------------
locret_200B96:
			rts
; End of function sub_200A9E
; ---------------------------------------------------------------------------
			move.l	obj.xpos(a0),d2
			move.w	obj.xvel(a0),d0
			ext.l	d0
			asl.l	#8,d0
			sub.l	d0,d2
			move.l	d2,obj.xpos(a0)
			move.w	#$38,d0
			ext.l	d0
			asl.l	#8,d0
			sub.l	d0,d3
			move.l	d3,obj.ypos(a0)
			rts
; ---------------------------------------------------------------------------
locret_200BBA:
			rts
; ---------------------------------------------------------------------------
			move.l	obj.ypos(a0),d3
			move.w	obj.yvel(a0),d0
			subi.w	#$38,d0
			move.w	d0,obj.yvel(a0)
			ext.l	d0
			asl.l	#8,d0
			sub.l	d0,d3
			move.l	d3,obj.ypos(a0)
			rts
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
			move.l	obj.xpos(a0),d2
			move.l	obj.ypos(a0),d3
			move.w	obj.xvel(a0),d0
			ext.l	d0
			asl.l	#8,d0
			sub.l	d0,d2
			move.w	obj.yvel(a0),d0
			ext.l	d0
			asl.l	#8,d0
			sub.l	d0,d3
			move.l	d2,obj.xpos(a0)
			move.l	d3,obj.ypos(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_200C00:
			move.b	(byte_FFF76A).w,d2
			cmp.w	d0,d1
			ble.s	loc_200C0E
			move.b	(byte_FFF768).w,d2
			move.w	d0,d1
loc_200C0E:
			btst	#0,d2
			bne.s	loc_200C1A
			move.b	d2,obj.angle(a0)
			rts
; ---------------------------------------------------------------------------
loc_200C1A:
			move.b	obj.angle(a0),d2
			addi.b	#$20,d2
			andi.b	#$C0,d2
			move.b	d2,obj.angle(a0)
			rts
; End of function sub_200C00
; ---------------------------------------------------------------------------
loc_200C2C:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_17(a0),d0
			ext.w	d0
			neg.w	d0
			add.w	d0,d2
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d3
			lea	(byte_FFF768).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$D,d5
			bsr.w	sub_200FF2
			move.w	d1,-(sp)
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d3
			lea	(byte_FFF76A).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$D,d5
			bsr.w	sub_200FF2
			move.w	(sp)+,d0
			bsr.w	sub_200C00
			tst.w	d1
			beq.s	locret_200CA0
			bpl.s	loc_200CA2
			cmpi.w	#-$E,d1
			blt.w	locret_200BBA
			add.w	d1,obj.xpos(a0)
locret_200CA0:
			rts
; ---------------------------------------------------------------------------
loc_200CA2:
			cmpi.w	#$E,d1
			bgt.s	loc_200CAE
loc_200CA8:
			add.w	d1,obj.xpos(a0)
			rts
; ---------------------------------------------------------------------------
loc_200CAE:
			tst.b	obj.field_38(a0)
			bne.s	loc_200CA8
			bset	#1,obj.status(a0)
			bclr	#5,obj.status(a0)
			move.b	#1,obj.prevani(a0)
			rts
; ---------------------------------------------------------------------------
loc_200CC8:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d2
			eori.w	#$F,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d3
			lea	(byte_FFF768).w,a4
			movea.w #-$10,a3
			move.w	#$1000,d6
			moveq	#$D,d5
			bsr.w	sub_200E82
			move.w	d1,-(sp)
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d2
			eori.w	#$F,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			sub.w	d0,d3
			lea	(byte_FFF76A).w,a4
			movea.w #-$10,a3
			move.w	#$1000,d6
			moveq	#$D,d5
			bsr.w	sub_200E82
			move.w	(sp)+,d0
			bsr.w	sub_200C00
			tst.w	d1
			beq.s	locret_200D42
			bpl.s	loc_200D44
			cmpi.w	#-$E,d1
			blt.w	locret_200B96
			sub.w	d1,obj.ypos(a0)
locret_200D42:
			rts
; ---------------------------------------------------------------------------
loc_200D44:
			cmpi.w	#$E,d1
			bgt.s	loc_200D50
loc_200D4A:
			sub.w	d1,obj.ypos(a0)
			rts
; ---------------------------------------------------------------------------
loc_200D50:
			tst.b	obj.field_38(a0)
			bne.s	loc_200D4A
			bset	#1,obj.status(a0)
			bclr	#5,obj.status(a0)
			move.b	#1,obj.prevani(a0)
			rts
; ---------------------------------------------------------------------------
loc_200D6A:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_17(a0),d0
			ext.w	d0
			sub.w	d0,d2
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d3
			eori.w	#$F,d3
			lea	(byte_FFF768).w,a4
			movea.w #-$10,a3
			move.w	#$800,d6
			moveq	#$D,d5
			bsr.w	sub_200FF2
			move.w	d1,-(sp)
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d3
			eori.w	#$F,d3
			lea	(byte_FFF76A).w,a4
			movea.w #-$10,a3
			move.w	#$800,d6
			moveq	#$D,d5
			bsr.w	sub_200FF2
			move.w	(sp)+,d0
			bsr.w	sub_200C00
			tst.w	d1
			beq.s	locret_200DE4
			bpl.s	loc_200DE6
			cmpi.w	#-$E,d1
			blt.w	locret_200BBA
			sub.w	d1,obj.xpos(a0)
locret_200DE4:
			rts
; ---------------------------------------------------------------------------
loc_200DE6:
			cmpi.w	#$E,d1
			bgt.s	loc_200DF2
loc_200DEC:
			sub.w	d1,obj.xpos(a0)
			rts
; ---------------------------------------------------------------------------
loc_200DF2:
			tst.b	obj.field_38(a0)
			bne.s	loc_200DEC
			bset	#1,obj.status(a0)
			bclr	#5,obj.status(a0)
			move.b	#1,obj.prevani(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_200E0C:
			move.w	d2,d0
			lsr.w	#1,d0
			andi.w	#$380,d0
			move.w	d3,d1
			lsr.w	#8,d1
			andi.w	#$7F,d1
			add.w	d1,d0
			move.l	#chunkbuffer,d1
			lea	(lvllayoutbuffer).w,a1
			move.b	(a1,d0.w),d1
			beq.s	loc_200E4A
			bmi.s	loc_200E4E
			subq.b	#1,d1
			ext.w	d1
			ror.w	#7,d1
			move.w	d2,d0
			add.w	d0,d0
			andi.w	#$1E0,d0
			add.w	d0,d1
			move.w	d3,d0
			lsr.w	#3,d0
			andi.w	#$1E,d0
			add.w	d0,d1
loc_200E4A:
			movea.l d1,a1
			rts
; ---------------------------------------------------------------------------
loc_200E4E:
			andi.w	#$7F,d1
			btst	#6,obj.render(a0)
			beq.s	loc_200E66
			addq.w	#1,d1
			cmpi.w	#$29,d1
			bne.s	loc_200E66
			move.w	#$51,d1
loc_200E66:
			subq.b	#1,d1
			ror.w	#7,d1
			move.w	d2,d0
			add.w	d0,d0
			andi.w	#$1E0,d0
			add.w	d0,d1
			move.w	d3,d0
			lsr.w	#3,d0
			andi.w	#$1E,d0
			add.w	d0,d1
			movea.l d1,a1
			rts
; End of function sub_200E0C
; =============== S U B R O U T I N E =======================================
sub_200E82:
			bsr.w	sub_200E0C
			cmpi.l	#chunkbuffer,d1
			beq.s	loc_200E9C
			move.w	(a1),d0
			move.w	d0,d4
			andi.w	#$7FF,d0
			beq.s	loc_200E9C
			btst	d5,d4
			bne.s	loc_200EAA
loc_200E9C:
			add.w	a3,d2
			bsr.w	sub_200F42
			sub.w	a3,d2
			addi.w	#$10,d1
			rts
; ---------------------------------------------------------------------------
loc_200EAA:
			movea.l (dword_FFF796).w,a2
			move.b	(a2,d0.w),d0
			andi.w	#$FF,d0
			beq.s	loc_200E9C
			lea	(unk_234A8A).l,a2
			move.b	(a2,d0.w),(a4)
			lsl.w	#4,d0
			move.w	d3,d1
			btst	#$B,d4
			beq.s	loc_200ED0
			not.w	d1
			neg.b	(a4)
loc_200ED0:
			btst	#$C,d4
			beq.s	loc_200EE0
			addi.b	#$40,(a4)
			neg.b	(a4)
			subi.b	#$40,(a4)
loc_200EE0:
			andi.w	#$F,d1
			add.w	d0,d1
			lea	(unk_234B8A).l,a2
			move.b	(a2,d1.w),d0
			ext.w	d0
			eor.w	d6,d4
			btst	#$C,d4
			beq.s	loc_200EFC
			neg.w	d0
loc_200EFC:
			tst.w	d0
			beq.s	loc_200E9C
			bmi.s	loc_200F18
			cmpi.b	#$10,d0
			beq.s	loc_200F34
loc_200F08:
			move.w	d2,d1
			andi.w	#$F,d1
			add.w	d1,d0
			move.w	#$F,d1
			sub.w	d0,d1
			rts
; ---------------------------------------------------------------------------
loc_200F18:
			cmpa.w	#$10,a3
			bne.s	loc_200F28
			move.w	#$10,d0
			move.b	#0,(a4)
			bra.s	loc_200F08
; ---------------------------------------------------------------------------
loc_200F28:
			move.w	d2,d1
			andi.w	#$F,d1
			add.w	d1,d0
			bpl.w	loc_200E9C
loc_200F34:
			sub.w	a3,d2
			bsr.w	sub_200F42
			add.w	a3,d2
			subi.w	#$10,d1
			rts
; End of function sub_200E82
; =============== S U B R O U T I N E =======================================
sub_200F42:
			bsr.w	sub_200E0C
			cmpi.l	#chunkbuffer,d1
			beq.s	loc_200F5C
			move.w	(a1),d0
			move.w	d0,d4
			andi.w	#$7FF,d0
			beq.s	loc_200F5C
			btst	d5,d4
			bne.s	loc_200F6A
loc_200F5C:
			move.w	#$F,d1
			move.w	d2,d0
			andi.w	#$F,d0
			sub.w	d0,d1
			rts
; ---------------------------------------------------------------------------
loc_200F6A:
			movea.l (dword_FFF796).w,a2
			move.b	(a2,d0.w),d0
			andi.w	#$FF,d0
			beq.s	loc_200F5C
			lea	(unk_234A8A).l,a2
			move.b	(a2,d0.w),(a4)
			lsl.w	#4,d0
			move.w	d3,d1
			btst	#$B,d4
			beq.s	loc_200F90
			not.w	d1
			neg.b	(a4)
loc_200F90:
			btst	#$C,d4
			beq.s	loc_200FA0
			addi.b	#$40,(a4)
			neg.b	(a4)
			subi.b	#$40,(a4)
loc_200FA0:
			andi.w	#$F,d1
			add.w	d0,d1
			lea	(unk_234B8A).l,a2
			move.b	(a2,d1.w),d0
			ext.w	d0
			eor.w	d6,d4
			btst	#$C,d4
			beq.s	loc_200FBC
			neg.w	d0
loc_200FBC:
			tst.w	d0
			beq.s	loc_200F5C
			bmi.s	loc_200FD2
loc_200FC2:
			move.w	d2,d1
			andi.w	#$F,d1
			add.w	d1,d0
			move.w	#$F,d1
			sub.w	d0,d1
			rts
; ---------------------------------------------------------------------------
loc_200FD2:
			cmpa.w	#$10,a3
			bne.s	loc_200FE2
			move.w	#$10,d0
			move.b	#0,(a4)
			bra.s	loc_200FC2
; ---------------------------------------------------------------------------
loc_200FE2:
			move.w	d2,d1
			andi.w	#$F,d1
			add.w	d1,d0
			bpl.w	loc_200F5C
			not.w	d1
			rts
; End of function sub_200F42
; =============== S U B R O U T I N E =======================================
sub_200FF2:
			bsr.w	sub_200E0C
			cmpi.l	#chunkbuffer,d1
			beq.s	loc_20100C
			move.w	(a1),d0
			move.w	d0,d4
			andi.w	#$7FF,d0
			beq.s	loc_20100C
			btst	d5,d4
			bne.s	loc_20101A
loc_20100C:
			add.w	a3,d3
			bsr.w	sub_2010A2
			sub.w	a3,d3
			addi.w	#$10,d1
			rts
; ---------------------------------------------------------------------------
loc_20101A:
			movea.l (dword_FFF796).w,a2
			move.b	(a2,d0.w),d0
			andi.w	#$FF,d0
			beq.s	loc_20100C
			lea	(unk_234A8A).l,a2
			move.b	(a2,d0.w),(a4)
			lsl.w	#4,d0
			move.w	d2,d1
			btst	#$C,d4
			beq.s	loc_201048
			not.w	d1
			addi.b	#$40,(a4)
			neg.b	(a4)
			subi.b	#$40,(a4)
loc_201048:
			btst	#$B,d4
			beq.s	loc_201050
			neg.b	(a4)
loc_201050:
			andi.w	#$F,d1
			add.w	d0,d1
			lea	(unk_235B8A).l,a2
			move.b	(a2,d1.w),d0
			ext.w	d0
			eor.w	d6,d4
			btst	#$B,d4
			beq.s	loc_20106C
			neg.w	d0
loc_20106C:
			tst.w	d0
			beq.s	loc_20100C
			bmi.s	loc_201088
			cmpi.b	#$10,d0
			beq.s	loc_201094
			move.w	d3,d1
			andi.w	#$F,d1
			add.w	d1,d0
			move.w	#$F,d1
			sub.w	d0,d1
			rts
; ---------------------------------------------------------------------------
loc_201088:
			move.w	d3,d1
			andi.w	#$F,d1
			add.w	d1,d0
			bpl.w	loc_20100C
loc_201094:
			sub.w	a3,d3
			bsr.w	sub_2010A2
			add.w	a3,d3
			subi.w	#$10,d1
			rts
; End of function sub_200FF2
; =============== S U B R O U T I N E =======================================
sub_2010A2:
			bsr.w	sub_200E0C
			cmpi.l	#chunkbuffer,d1
			beq.s	loc_2010BC
			move.w	(a1),d0
			move.w	d0,d4
			andi.w	#$7FF,d0
			beq.s	loc_2010BC
			btst	d5,d4
			bne.s	loc_2010CA
loc_2010BC:
			move.w	#$F,d1
			move.w	d3,d0
			andi.w	#$F,d0
			sub.w	d0,d1
			rts
; ---------------------------------------------------------------------------
loc_2010CA:
			movea.l (dword_FFF796).w,a2
			move.b	(a2,d0.w),d0
			andi.w	#$FF,d0
			beq.s	loc_2010BC
			lea	(unk_234A8A).l,a2
			move.b	(a2,d0.w),(a4)
			lsl.w	#4,d0
			move.w	d2,d1
			btst	#$C,d4
			beq.s	loc_2010F8
			not.w	d1
			addi.b	#$40,(a4)
			neg.b	(a4)
			subi.b	#$40,(a4)
loc_2010F8:
			btst	#$B,d4
			beq.s	loc_201100
			neg.b	(a4)
loc_201100:
			andi.w	#$F,d1
			add.w	d0,d1
			lea	(unk_235B8A).l,a2
			move.b	(a2,d1.w),d0
			ext.w	d0
			eor.w	d6,d4
			btst	#$B,d4
			beq.s	loc_20111C
			neg.w	d0
loc_20111C:
			tst.w	d0
			beq.s	loc_2010BC
			bmi.s	loc_201132
			move.w	d3,d1
			andi.w	#$F,d1
			add.w	d1,d0
			move.w	#$F,d1
			sub.w	d0,d1
			rts
; ---------------------------------------------------------------------------
loc_201132:
			move.w	d3,d1
			andi.w	#$F,d1
			add.w	d1,d0
			bpl.w	loc_2010BC
			not.w	d1
			rts
; End of function sub_2010A2
; =============== S U B R O U T I N E =======================================
nullsub_3:
			rts
; End of function nullsub_3
; ---------------------------------------------------------------------------
			lea	(unk_234B8A).l,a1
			lea	(unk_234B8A).l,a2
			move.w	#$100-1,d3
loc_201154:
			moveq	#$10,d5
			move.w	#$10-1,d2
loc_20115A:
			moveq	#0,d4
			move.w	#$10-1,d1
loc_201160:
			move.w	(a1)+,d0
			lsr.l	d5,d0
			addx.w	d4,d4
			dbf	d1,loc_201160
			move.w	d4,(a2)+
			suba.w	#$20,a1
			subq.w	#1,d5
			dbf	d2,loc_20115A
			adda.w	#$20,a1
			dbf	d3,loc_201154
			lea	(unk_234B8A).l,a1
			lea	(unk_235B8A).l,a2
			bsr.s	sub_201198
			lea	(unk_234B8A).l,a1
			lea	(unk_234B8A).l,a2
; =============== S U B R O U T I N E =======================================
sub_201198:
			move.w	#$1000-1,d3
loc_20119C:
			moveq	#0,d2
			move.w	#$10-1,d1
			move.w	(a1)+,d0
			beq.s	loc_2011CA
			bmi.s	loc_2011B4
loc_2011A8:
			lsr.w	#1,d0
			bcc.s	loc_2011AE
			addq.b	#1,d2
loc_2011AE:
			dbf	d1,loc_2011A8
			bra.s	loc_2011CC
; ---------------------------------------------------------------------------
loc_2011B4:
			cmpi.w	#$FFFF,d0
			beq.s	loc_2011C6
loc_2011BA:
			lsl.w	#1,d0
			bcc.s	loc_2011C0
			subq.b	#1,d2
loc_2011C0:
			dbf	d1,loc_2011BA
			bra.s	loc_2011CC
; ---------------------------------------------------------------------------
loc_2011C6:
			move.w	#$10,d0
loc_2011CA:
			move.w	d0,d2
loc_2011CC:
			move.b	d2,(a2)+
			dbf	d3,loc_20119C
			rts
; End of function sub_201198
; ---------------------------------------------------------------------------
			dc.b musid_GHZ
			dc.b musid_LZ
			dc.b musid_MZ
			dc.b musid_SLZ
			dc.b musid_SYZ
			dc.b musid_SBZ
			dc.b musid_FZ
			even
; ---------------------------------------------------------------------------
level:
			bset	#0,(byte_FF122A).l
			bne.s	loc_2011FE
			move.b	#3,(byte_FF1212).l
			tst.b	(byte_FF0580_ext).l
			beq.s	loc_2011FE
			move.b	#1,(byte_FF1212).l
loc_2011FE:
			bset	#7,(gamemode).w
			bsr.w	sub_20208C
			btst	#7,(byte_FF123D).l
			beq.s	loc_20122C
			bsr.w	sub_2003EE
			clr.b	(byte_FFF784).w
			tst.w	(word_FF1202).l
			beq.s	loc_201256
			move.w	#0,(word_FF1202).l
			rts
; ---------------------------------------------------------------------------
loc_20122C:
			bsr.w	sub_2002C2
			cmpi.w	#2,(word_FF1202).l
			bne.s	loc_201244
			move.w	#0,(word_FF1202).l
			rts
; ---------------------------------------------------------------------------
loc_201244:
			tst.b	(byte_FF1212).l
			bne.s	loc_201256
			bclr	#0,(byte_FF122A).l
			rts
; ---------------------------------------------------------------------------
loc_201256:
			bsr.w	sub_2015B6
			moveq	#0,d0
;			move.b	(zone).l,d0
;			lsl.w	#4,d0
			lea	(lvlheader).l,a2
			moveq	#0,d0
			move.b	(a2),d0
			beq.s	loc_20126C
			bsr.w	sub_20202E
loc_20126C:
			moveq	#1,d0
			bsr.w	sub_20202E

			clr.b	(byte_FF127B).l
			clr.l	(dword_FF1880).l

			lea	(actwk).w,a1
			moveq	#0,d0
			move.w	#(actwk_end-actwk)/4-1,d1
loc_201288:
			move.l	d0,(a1)+
			dbf	d1,loc_201288

			lea	(byte_FFF628).w,a1
			moveq	#0,d0
			move.w	#(dword_FFF680-byte_FFF628)/4-1,d1
loc_201298:
			move.l	d0,(a1)+
			dbf	d1,loc_201298

			lea	(dword_FFF700).w,a1
			moveq	#0,d0
			move.w	#$100/4-1,d1
loc_2012A8:
			move.l	d0,(a1)+
			dbf	d1,loc_2012A8

			move.w	#$2700,sr
			bsr.w	sub_201D76
			lea	(vdpctrl).l,a6
			move.w	#$8B00+%0011,(a6)
			move.w	#$8200+plane_a>>10,(a6)
			move.w	#$8400+plane_b>>13,(a6)
			move.w	#$8500+sprtbl_vram>>9,(a6)
			move.w	#$9001,(a6)
			move.w	#$8000+%0100,(a6)
			move.w	#$8720,(a6)
			move.w	#$8A00+223,(word_FFF624).w
			move.w	(word_FFF624).w,(a6)
			move.w	#30,(play_air).l
			move.w	#$2300,sr
			moveq	#palid_player,d0
			bsr.w	palload
			moveq	#palid_player,d0
			bsr.w	palload_fade
			move.w	(word_FFF60C).w,d0
			ori.b	#$40,d0
			move.w	d0,(vdpctrl).l
loc_201308:
			move.b	#vintid_0C,(vint_mode).w
			bsr.w	vsync
			bsr.w	sub_20209A
			bne.s	loc_201308
			tst.l	(dword_FFF680).w
			bne.s	loc_201308
			bsr.w	sub_2023FC
			bsr.w	sub_202550
			bset	#2,(dword_FFF754).w
			bsr.w	sub_202F90
			bsr.w	sub_202EA6
			jsr	(nullsub_3).l
			bsr.w	sub_2014F0
loc_20133E:
			move.b	#vintid_0C,(vint_mode).w
			bsr.w	vsync
			bsr.w	sub_20209A
			bne.s	loc_20133E
			tst.l	(dword_FFF680).w
			bne.s	loc_20133E
			bsr.w	sub_20147C
			move.b	#$1C,(byte_FFD080).w
			move.b	#$1C,(byte_FFD0C0).w
			move.b	#1,(byte_FFD0C0+obj.field_28).w
			bsr.w	sub_2015E8
			move.w	#0,(word_FFF602).w
			move.w	#0,(word_FFF604).w
			move.w	#0,(word_FFF606).w
			move.w	#0,(word_FFF780).w
			move.w	#0,(word_FFF782).w
			moveq	#0,d0
			tst.b	(byte_FF1230).l
			bne.s	loc_2013A8
			move.w	d0,(word_FF1220).l
			move.l	d0,(byte_FF1222).l
			move.b	d0,(byte_FF121B).l
loc_2013A8:
			move.b	d0,(byte_FF121A).l
			move.b	d0,(byte_FF122C).l
			move.b	d0,(byte_FF122D).l
			move.b	d0,(byte_FF122E).l
			move.b	d0,(byte_FF122F).l
			move.w	d0,(word_FF1208).l
			move.w	d0,(word_FF1202).l
			move.w	d0,(word_FF1204).l
			move.b	#1,(byte_FF121F).l
			move.b	#1,(byte_FF121D).l
			move.b	#1,(byte_FF121E).l
			move.b	#1,(byte_FF121C).l
			move.w	#0,(word_FFF790).w
			move.w	#$202F,(word_FFF626).w
			bclr	#7,(byte_FF123D).l
			beq.s	loc_201414
			bsr.w	sub_200340
			bra.s	loc_201418
; ---------------------------------------------------------------------------
loc_201414:
			bsr.w	sub_200220
loc_201418:
			bclr	#7,(gamemode).w
loc_20141E:
			move.b	#vintid_08,(vint_mode).w
			bsr.w	vsync
			addq.w	#1,(word_FF1204).l
			jsr	(sub_206DB0).l
			jsr	(sub_2030F2).l
			tst.w	(word_FF1202).l
			bne.w	level
			tst.w	(word_FF1208).l
			bne.s	loc_201454
			cmpi.b	#6,(actwk+obj.routine).w
			bcc.s	loc_201458
loc_201454:
			bsr.w	sub_202550
loc_201458:
			jsr	(sub_20325E).l
			tst.w	(word_FF1278).l
			bne.s	loc_20146A
			bsr.w	sub_200180
loc_20146A:
			jsr	(sub_20DBFA).l
			bsr.w	sub_20209A
			bsr.w	sub_201522
			bra.w	loc_20141E
; =============== S U B R O U T I N E =======================================
sub_20147C:
			lea	(actwk).w,a1
			moveq	#1,d0
			tst.b	(byte_FF1219).l
			beq.s	loc_201490
			lea	(byte_FFD040).w,a1
			moveq	#2,d0
loc_201490:
			move.b	d0,obj.id(a1)
			rts
; End of function sub_20147C
; ---------------------------------------------------------------------------
			lea	(dword_FF1880).l,a1
			moveq	#0,d0
			move.b	(byte_FF123D).l,d0
			bclr	#7,d0
			move.b	(a1,d0.w),d0
			beq.s	locret_2014EE
			subq.b	#1,d0
			lea	(byte_FFD800).w,a2
			moveq	#0,d1
loc_2014B6:
			move.b	#$1F,obj.id(a2)
			move.w	d1,d2
			add.w	d2,d2
			add.w	d2,d2
			moveq	#0,d3
			move.b	(byte_FF123D).l,d3
			bclr	#7,d3
			lsl.w	#8,d3
			add.w	d3,d2
			lea	(byte_FF1580).l,a3
			move.w	(a3,d2.w),obj.xpos(a2)
			move.w	2(a3,d2.w),obj.ypos(a2)
			adda.w	#obj,a2
			addq.b	#1,d1
			dbf	d0,loc_2014B6

locret_2014EE:
			rts
; =============== S U B R O U T I N E =======================================
sub_2014F0:
			moveq	#0,d0
			move.b	(zone).l,d0
			lsl.w	#2,d0
			move.l	off_201502(pc,d0.w),(dword_FFF796).w
			rts
; End of function sub_2014F0
; ---------------------------------------------------------------------------
off_201502:
			dc.l spz_collision
			dc.l spz_collision
			dc.l spz_collision
			dc.l spz_collision
			dc.l spz_collision
			dc.l spz_collision
			dc.l spz_collision
			dc.l spz_collision
; =============== S U B R O U T I N E =======================================
sub_201522:
			subq.b	#1,(byte_FF12C0).l
			bpl.s	loc_201540
			move.b	#11,(byte_FF12C0).l
			subq.b	#1,(byte_FF12C1).l
			andi.b	#7,(byte_FF12C1).l
loc_201540:
			subq.b	#1,(byte_FF12C2).l
			bpl.s	loc_20155E
			move.b	#7,(byte_FF12C2).l
			addq.b	#1,(byte_FF12C3).l
			andi.b	#3,(byte_FF12C3).l
loc_20155E:
			subq.b	#1,(byte_FF12C4).l
			bpl.s	loc_201586
			move.b	#7,(byte_FF12C4).l
			addq.b	#1,(byte_FF12C5).l
			cmpi.b	#6,(byte_FF12C5).l
			bcs.s	loc_201586
			move.b	#0,(byte_FF12C5).l
loc_201586:
			tst.b	(byte_FF12C6).l
			beq.s	locret_2015B4
			moveq	#0,d0
			move.b	(byte_FF12C6).l,d0
			add.w	(word_FF12C8).l,d0
			move.w	d0,(word_FF12C8).l
			rol.w	#7,d0
			andi.w	#3,d0
			move.b	d0,(byte_FF12C7).l
			subq.b	#1,(byte_FF12C6).l
locret_2015B4:
			rts
; End of function sub_201522
; =============== S U B R O U T I N E =======================================
sub_2015B6:
			moveq	#0,d0
			move.b	(byte_FF123D).l,d0
			bclr	#7,d0
			cmpi.b	#2,d0
			bne.s	loc_2015CE
			add.b	(byte_FF127A).l,d0
loc_2015CE:
			move.b	byte_2015DA(pc,d0.w),d0
			ext.w	d0
			jmp	(sub_205404).l
; End of function sub_2015B6
; ---------------------------------------------------------------------------
byte_2015DA:
			dc.b scpu_r11bMUS
			dc.b scpu_r11aMUS
			dc.b scpu_r11cMUS
			dc.b scpu_r11dMUS
			even
; ---------------------------------------------------------------------------
			move.w	#scpu_r11aMUS,d0
			jsr	(sub_205404).l
; =============== S U B R O U T I N E =======================================
sub_2015E8:
			move.l	#$73E00002,d0
			moveq	#0,d2
			move.b	(byte_FF123D).l,d2
			bclr	#7,d2
			lsl.w	#7,d2
			move.l	d0,4(a6)
			lea	(cg_hudicon).l,a1
			lea	(a1,d2.w),a3
	rept 32
			move.l	(a3)+,(a6)
	endr
			rts
; End of function sub_2015E8
; ---------------------------------------------------------------------------
vint:
			bset	#0,(scpu_IRQ2).l
			movem.l d0-a6,-(sp)
			tst.b	(vint_mode).w
			beq.s	vint00
			move.w	(vdpctrl).l,d0
			move.l	#$40000010,(vdpctrl).l
			move.l	(dword_FFF616).w,(vdpdata).l
			btst	#6,(byte_FF13F8).l
			beq.s	loc_201688
			move.w	#$700,d0
loc_201684:
			dbf	d0,loc_201684

loc_201688:
			move.b	(vint_mode).w,d0
			move.b	#vintid_00,(vint_mode).w
			move.w	#1,(word_FFF644).w
			andi.w	#$3E,d0
			move.w	vint_index(pc,d0.w),d0
			jsr	vint_index(pc,d0.w)

loc_2016A4:
			jsr	(sub_201E98).l

loc_2016AA:
			bsr.w	sub_201C66
			bsr.w	sub_201C4C
			addq.l	#1,(dword_FF120C).l
			movem.l (sp)+,d0-a6
			rte
; ---------------------------------------------------------------------------

vint_ptr	macro
\1_ptr:	dc.w \1-vint_index
	endm

vint_index:
			vint_ptr vint00
			vint_ptr vint02
			vint_ptr vint04
			vint_ptr vint06
			vint_ptr vint08
			vint_ptr vint0A
			vint_ptr vint0C
			vint_ptr vint0E
			vint_ptr vint10
			vint_ptr vint12
			vint_ptr vint14
			vint_ptr vint16
			vint_ptr vint18
; ---------------------------------------------------------------------------
vint00:
			cmpi.b	#gmmodeid_lvl_S1+$80,(gamemode).w
			beq.s	loc_2016EA
			cmpi.b	#gmmodeid_lvl_S1,(gamemode).w
			bne.w	loc_2016A4
loc_2016EA:
			cmpi.b	#zoneid_LZ,(zone).l
			bne.w	loc_2016A4
			move.w	(vdpctrl).l,d0
			btst	#6,(byte_FF13F8).l
			beq.s	loc_20170E
			move.w	#$700,d0
loc_20170A:
			dbf	d0,loc_20170A
loc_20170E:
			move.w	#1,(word_FFF644).w
			jsr	(STOPZ80BUS).l
			tst.b	(byte_FFF64E).w
			bne.s	loc_201746
			DMA68K	palette,$80,$C,0
			bra.s	loc_20176A
; ---------------------------------------------------------------------------
loc_201746:
			DMA68K	palette_water,$80,$C,0
loc_20176A:
			move.w	(word_FFF624).w,(a5)
			jsr	(STARTZ80BUS).l
			bra.w	loc_2016A4
; ---------------------------------------------------------------------------
vint02:
			bsr.w	sub_201B1A
vint14:
			tst.w	(word_FFF614).w
			beq.w	locret_201788
			subq.w	#1,(word_FFF614).w
locret_201788:
			rts
; ---------------------------------------------------------------------------
vint04:
			bsr.w	sub_201B1A
			bsr.w	sub_202A76
			bsr.w	sub_2020F0
			tst.w	(word_FFF614).w
			beq.w	locret_2017A2
			subq.w	#1,(word_FFF614).w
locret_2017A2:
			rts
; ---------------------------------------------------------------------------
vint06:
			bsr.w	sub_201B1A
			rts
; ---------------------------------------------------------------------------
vint10:
			cmpi.b	#gmmodeid_ss,(gamemode).w
			beq.w	vint0A
vint08:
			jsr	(STOPZ80BUS).l
			bsr.w	readjoypads
			tst.b	(byte_FFF64E).w
			bne.s	loc_2017EA
			DMA68K	palette,$80,$C,0
			bra.s	loc_20180E
; ---------------------------------------------------------------------------
loc_2017EA:
			DMA68K	palette_water,$80,$C,0
loc_20180E:
			move.w	(word_FFF624).w,(a5)
			lea	(vdpctrl).l,a5
			move.l	#$940193C0,(a5)
			move.l	#$96E69500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7C00,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			lea	(vdpctrl).l,a5
			move.l	#$94019340,(a5)
			move.l	#$96FC9500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7800,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			lea	(actwk).w,a0
			bsr.w	sub_20532E
			tst.b	(byte_FFF767).w
			beq.s	loc_201892
			lea	(vdpctrl).l,a5
			move.l	#$94019370,(a5)
			move.l	#$96E49500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7000,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			move.b	#0,(byte_FFF767).w
loc_201892:
			lea	(byte_FFD040).w,a0
			bsr.w	sub_20532E
			tst.b	(byte_FFF767).w
			beq.s	loc_2018CA
			lea	(vdpctrl).l,a5
			move.l	#$94019370,(a5)
			move.l	#$96E49500,(a5)
			move.w	#$977F,(a5)
			move.w	#$72E0,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			move.b	#0,(byte_FFF767).w
loc_2018CA:
			tst.w	(word_FF1278).l
			bne.s	loc_2018D8
			jsr	(sub_20DFF4).l
loc_2018D8:
			jsr	(STARTZ80BUS).l
			movem.l (dword_FFF700).w,d0-d7
			movem.l d0-d7,(dword_FF1310).l
			movem.l (dword_FFF754).w,d0-d1
			movem.l d0-d1,(dword_FF1330).l
			cmpi.b	#96,(word_FFF624+1).w
			bcc.s	doupdates
			move.b	#1,(byte_FFF64F).w
			addq.l	#4,sp
			bra.w	loc_2016AA
; =============== S U B R O U T I N E =======================================
doupdates:
			bsr.w	sub_202AA2
			bsr.w	sub_20210C
			jsr	(sub_209830).l
			tst.w	(word_FFF614).w
			beq.w	locret_201928
			subq.w	#1,(word_FFF614).w
locret_201928:
			rts
; End of function doupdates
; =============== S U B R O U T I N E =======================================
vint0A:
			rts
; End of function vint0A
; ---------------------------------------------------------------------------
vint0C:
vint18:
			jsr	(STOPZ80BUS).l
			bsr.w	readjoypads
			tst.b	(byte_FFF64E).w
			bne.s	loc_201962
			DMA68K	palette,$80,$C,0
			bra.s	loc_201986
; ---------------------------------------------------------------------------
loc_201962:
			DMA68K	palette_water,$80,$C,0
loc_201986:
			move.w	(word_FFF624).w,(a5)
			lea	(vdpctrl).l,a5
			move.l	#$940193C0,(a5)
			move.l	#$96E69500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7C00,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			lea	(vdpctrl).l,a5
			move.l	#$94019340,(a5)
			move.l	#$96FC9500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7800,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			lea	(actwk).w,a0
			bsr.w	sub_20532E
			tst.b	(byte_FFF767).w
			beq.s	loc_201A0A
			lea	(vdpctrl).l,a5
			move.l	#$94019370,(a5)
			move.l	#$96E49500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7000,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			move.b	#0,(byte_FFF767).w
loc_201A0A:
			jsr	(STARTZ80BUS).l
			movem.l (dword_FFF700).w,d0-d7
			movem.l d0-d7,(dword_FF1310).l
			movem.l (dword_FFF754).w,d0-d1
			movem.l d0-d1,(dword_FF1330).l
			bsr.w	sub_202AA2
			bsr.w	sub_2020F0
			jsr	(sub_209830).l
			rts
; ---------------------------------------------------------------------------
vint0E:
			bsr.w	sub_201B1A
			addq.b	#1,(byte_FFF628).w
			move.b	#vintid_0E,(vint_mode).w
			rts
; ---------------------------------------------------------------------------
vint12:
			bsr.w	sub_201B1A
			move.w	(word_FFF624).w,(a5)
			bra.w	sub_2020F0
; ---------------------------------------------------------------------------
vint16:
			jsr	(STOPZ80BUS).l
			bsr.w	readjoypads
			DMA68K	palette,$80,$C,0
			lea	(vdpctrl).l,a5
			move.l	#$94019340,(a5)
			move.l	#$96FC9500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7800,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			lea	(vdpctrl).l,a5
			move.l	#$940193C0,(a5)
			move.l	#$96E69500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7C00,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			jsr	(STARTZ80BUS).l
			lea	(actwk).w,a0
			bsr.w	sub_20532E
			tst.b	(byte_FFF767).w
			beq.s	loc_201B0C
			lea	(vdpctrl).l,a5
			move.l	#$94019370,(a5)
			move.l	#$96E49500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7000,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			move.b	#0,(byte_FFF767).w
loc_201B0C:
			tst.w	(word_FFF614).w
			beq.w	locret_201B18
			subq.w	#1,(word_FFF614).w
locret_201B18:
			rts
; =============== S U B R O U T I N E =======================================
sub_201B1A:
			jsr	(STOPZ80BUS).l
			bsr.w	readjoypads
			tst.b	(byte_FFF64E).w
			bne.s	loc_201B50
			DMA68K	palette,$80,$C,0
			bra.s	loc_201B74
; ---------------------------------------------------------------------------
loc_201B50:
			DMA68K	palette_water,$80,$C,0
loc_201B74:
			lea	(vdpctrl).l,a5
			move.l	#$94019340,(a5)
			move.l	#$96FC9500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7800,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			lea	(vdpctrl).l,a5
			move.l	#$940193C0,(a5)
			move.l	#$96E69500,(a5)
			move.w	#$977F,(a5)
			move.w	#$7C00,(a5)
			move.w	#$83,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
			jmp	(STARTZ80BUS).l
; End of function sub_201B1A
; ---------------------------------------------------------------------------
hint:
			move.w	#$2700,sr
			tst.w	(word_FFF644).w
			beq.s	locret_201C38
			move.w	#0,(word_FFF644).w
			movem.l a0-a1,-(sp)
			lea	(vdpdata).l,a1
			lea	(palette_water).w,a0
			move.l	#$C0000000,4(a1)
	rept 32
			move.l	(a0)+,(a1)
	endr
			move.w	#$8A00+223,4(a1)
			movem.l (sp)+,a0-a1
			tst.b	(byte_FFF64F).w
			bne.s	loc_201C3A
locret_201C38:
			rte
; ---------------------------------------------------------------------------
loc_201C3A:
			clr.b	(byte_FFF64F).w
			movem.l d0-a6,-(sp)
			bsr.w	doupdates
			movem.l (sp)+,d0-a6
			rte
; =============== S U B R O U T I N E =======================================
sub_201C4C:
			tst.w	(word_FFF786).w
			beq.s	loc_201C56
			addq.w	#1,(word_FFF786).w
loc_201C56:
			tst.w	(word_FF1278).l
			beq.s	locret_201C64
			subq.w	#1,(word_FF1278).l
locret_201C64:
			rts
; End of function sub_201C4C
; =============== S U B R O U T I N E =======================================
sub_201C66:
			tst.w	(word_FFF780).w
			beq.s	loc_201C70
			addq.w	#1,(word_FFF780).w
loc_201C70:
			tst.w	(word_FFF782).w
			beq.s	locret_201C7A
			addq.w	#1,(word_FFF782).w
locret_201C7A:
			rts
; End of function sub_201C66
; =============== S U B R O U T I N E =======================================
initjoypads:
			bsr.w	STOPZ80BUS
			moveq	#$40,d0
			move.b	d0,($A10009).l
			move.b	d0,($A1000B).l
			move.b	d0,($A1000D).l
			bra.w	STARTZ80BUS
; End of function initjoypads
; =============== S U B R O U T I N E =======================================
readjoypads:
			lea	(word_FFF604).w,a0
			lea	($A10003).l,a1
			bsr.s	sub_201CA6
			addq.w	#2,a1
; End of function readjoypads
; =============== S U B R O U T I N E =======================================
sub_201CA6:
			move.b	#0,(a1)
			nop
			nop
			move.b	(a1),d0
			lsl.b	#2,d0
			andi.b	#$C0,d0
			move.b	#$40,(a1)
			nop
			nop
			move.b	(a1),d1
			andi.b	#$3F,d1
			or.b	d1,d0
			not.b	d0
			move.b	(a0),d1
			eor.b	d0,d1
			move.b	d0,(a0)+
			and.b	d0,d1
			move.b	d1,(a0)+
			rts
; End of function sub_201CA6
; =============== S U B R O U T I N E =======================================
initvdp:
			lea	(vdpctrl).l,a0
			lea	(vdpdata).l,a1
			lea	(word_201D50).l,a2
			moveq	#(word_201D50_end-word_201D50)/2-1,d7
loc_201CE8:
			move.w	(a2)+,(a0)
			dbf	d7,loc_201CE8

			move.w	(word_201D50+2).l,d0
			move.w	d0,(word_FFF60C).w
			move.w	#$8A00+223,(word_FFF624).w
			moveq	#0,d0
			move.l	#$C0000000,(vdpctrl).l
			move.w	#$80/2-1,d7
loc_201D0E:
			move.w	d0,(a1)
			dbf	d7,loc_201D0E

			clr.l	(dword_FFF616).w
			clr.l	(dword_FFF61A).w

			move.l	d1,-(sp)

			lea	(vdpctrl).l,a5
			move.w	#$8F01,(a5)
			move.l	#$94FF93FF,(a5)
			move.w	#$9780,(a5)
			move.l	#$40000080,(a5)
			move.w	#0,(vdpdata).l
loc_201D40:
			move.w	(a5),d1
			btst	#1,d1
			bne.s	loc_201D40
			move.w	#$8F02,(a5)

			move.l	(sp)+,d1
			rts
; End of function initvdp
; ---------------------------------------------------------------------------
word_201D50:
			dc.w $8000+%0100
			dc.w $8100+%00110100
			dc.w $8200+plane_a>>10
			dc.w $8300+plane_w>>10
			dc.w $8400+plane_b>>13
			dc.w $8500+sprtbl_vram>>9
			dc.w $8600
			dc.w $8700
			dc.w $8800
			dc.w $8900
			dc.w $8A00
			dc.w $8B00
			dc.w $8C81
			dc.w $8D00+hscroll_vram>>10
			dc.w $8E00
			dc.w $8F02
			dc.w $9001
			dc.w $9100
			dc.w $9200
word_201D50_end:

; =============== S U B R O U T I N E =======================================
sub_201D76:
			lea	(vdpctrl).l,a5
			move.w	#$8F01,(a5)
			move.l	#$940F93FF,(a5)
			move.w	#$9780,(a5)
			move.l	#$40000083,(a5)
			move.w	#0,(vdpdata).l
loc_201D98:
			move.w	(a5),d1
			btst	#1,d1
			bne.s	loc_201D98
			move.w	#$8F02,(a5)

			lea	(vdpctrl).l,a5
			move.w	#$8F01,(a5)
			move.l	#$940F93FF,(a5)
			move.w	#$9780,(a5)
			move.l	#$60000083,(a5)
			move.w	#0,(vdpdata).l
loc_201DC6:
			move.w	(a5),d1
			btst	#1,d1
			bne.s	loc_201DC6
			move.w	#$8F02,(a5)

			clr.l	(dword_FFF616).w
			clr.l	(dword_FFF61A).w

			lea	(byte_FFF800).w,a1
			moveq	#0,d0
			move.w	#(byte_FFF800_end-byte_FFF800)/4,d1
loc_201DE4:
			move.l	d0,(a1)+
			dbf	d1,loc_201DE4

			lea	(byte_FFCC00).w,a1
			moveq	#0,d0
			move.w	#(byte_FFCC00_end-byte_FFCC00)/4,d1
loc_201DF4:
			move.l	d0,(a1)+
			dbf	d1,loc_201DF4

			rts
; End of function sub_201D76
; =============== S U B R O U T I N E =======================================
STOPZ80BUS:
			move.w	sr,(word_FFF7DA).w
			move.w	#$2700,sr
			move.w	#$100,(z80busreq).l
loc_201E0C:
			btst	#0,(z80busreq).l
			bne.s	loc_201E0C
			rts
; End of function STOPZ80BUS
; =============== S U B R O U T I N E =======================================
STARTZ80BUS:
			move.w	#0,(z80busreq).l
			move.w	(word_FFF7DA).w,sr
			rts
; End of function STARTZ80BUS
; ---------------------------------------------------------------------------
z80snddriverload:
			move.w	#$100,(z80reset).l
			jsr	STOPZ80BUS(pc)
			lea	(z80ram).l,a1
			lea	(unk_22EB40).l,a2
			move.w	#(unk_22EB40_end-unk_22EB40)-1,d0
loc_201E42:
			move.b	(a2)+,(a1)+
			dbf	d0,loc_201E42

			lea	(z80ram+$B00).l,a1
			lea	(unk_22E3E4).l,a2
			move.w	#(unk_22E3E4_end-unk_22E3E4)-1,d0
loc_201E58:
			move.b	(a2)+,(a1)+
			dbf	d0,loc_201E58

			lea	(z80ram+$1900).l,a1
			lea	(unk_22E3AC).l,a2
			move.w	#(unk_22E3AC_end-unk_22E3AC)-1,d0
loc_201E6E:
			move.b	(a2)+,(a1)+
			dbf	d0,loc_201E6E

			move.w	#0,(z80reset).l
			ror.b	#8,d0
			move.w	#$100,(z80reset).l
			jmp	STARTZ80BUS(pc)
; =============== S U B R O U T I N E =======================================
queuesound1:
;			move.b	d0,(soundram+SMPS_RAM.v_soundqueue0).w
			rts
; End of function queuesound1
; =============== S U B R O U T I N E =======================================
queuesound2:
			move.b	d0,(soundram+SMPS_RAM.v_soundqueue1).w
			rts
; End of function queuesound2
; ---------------------------------------------------------------------------
queuesound3:
			move.b	d0,(soundram+SMPS_RAM.v_soundqueue2).w
			rts
; =============== S U B R O U T I N E =======================================
sub_201E98:
			jsr	(STOPZ80BUS).l
			tst.b	(soundram+SMPS_RAM.v_soundqueue1).w
			beq.s	loc_201EB4
			move.b	(soundram+SMPS_RAM.v_soundqueue1).w,(z80ram+$1C09).l
			move.b	#0,(soundram+SMPS_RAM.v_soundqueue1).w
			bra.s	loc_201EC8
; ---------------------------------------------------------------------------
loc_201EB4:
			tst.b	(soundram+SMPS_RAM.v_soundqueue2).w
			beq.s	loc_201EC8
			move.b	(soundram+SMPS_RAM.v_soundqueue2).w,(z80ram+$1C09).l
			move.b	#0,(soundram+SMPS_RAM.v_soundqueue2).w
loc_201EC8:
			jmp	(STARTZ80BUS).l
; End of function sub_201E98
; ---------------------------------------------------------------------------
			lea	(vdpdata).l,a6
			move.l	#$800000,d4
loc_201EDA:
			move.l	d0,vdpctrl-vdpdata(a6)
			move.w	d1,d3
loc_201EE0:
			move.w	(a1)+,(a6)
			dbf	d3,loc_201EE0
			add.l	d4,d0
			dbf	d2,loc_201EDA
			rts
; =============== S U B R O U T I N E =======================================
sub_201EEE:
			movem.l d0-d7/a0-a1/a3-a5,-(sp)
			lea	(sub_201FB0).l,a3
			lea	(vdpdata).l,a4
			bra.s	loc_201F0A
; End of function sub_201EEE
; =============== S U B R O U T I N E =======================================
bitdevwkr:
			movem.l d0-a1/a3-a5,-(sp)
			lea	(loc_201FC6).l,a3
loc_201F0A:
			lea	(bitdevwk).w,a1
			move.w	(a0)+,d2
			lsl.w	#1,d2
			bcc.s	loc_201F18
			adda.w	#(sub_201FBA-sub_201FB0),a3
loc_201F18:
			lsl.w	#2,d2
			movea.w d2,a5
			moveq	#8,d3
			moveq	#0,d2
			moveq	#0,d4
			bsr.w	sub_201FDC
			move.b	(a0)+,d5
			asl.w	#8,d5
			move.b	(a0)+,d5
			move.w	#$10,d6
			bsr.s	sub_201F38
			movem.l (sp)+,d0-a1/a3-a5
			rts
; End of function bitdevwkr
; =============== S U B R O U T I N E =======================================
sub_201F38:
			move.w	d6,d7
			subq.w	#8,d7
			move.w	d5,d1
			lsr.w	d7,d1
			cmpi.b	#$FC,d1
			bcc.s	loc_201F84
			andi.w	#$FF,d1
			add.w	d1,d1
			move.b	(a1,d1.w),d0
			ext.w	d0
			sub.w	d0,d6
			cmpi.w	#9,d6
			bcc.s	loc_201F60
			addq.w	#8,d6
			asl.w	#8,d5
			move.b	(a0)+,d5
loc_201F60:
			move.b	1(a1,d1.w),d1
			move.w	d1,d0
			andi.w	#$F,d1
			andi.w	#$F0,d0
loc_201F6E:
			lsr.w	#4,d0
loc_201F70:
			lsl.l	#4,d4
			or.b	d1,d4
			subq.w	#1,d3
			bne.s	loc_201F7E
			jmp	(a3)
; End of function sub_201F38
; =============== S U B R O U T I N E =======================================
sub_201F7A:
			moveq	#0,d4
			moveq	#8,d3
loc_201F7E:
			dbf	d0,loc_201F70

			bra.s	sub_201F38
; ---------------------------------------------------------------------------
loc_201F84:
			subq.w	#6,d6
			cmpi.w	#9,d6
			bcc.s	loc_201F92
			addq.w	#8,d6
			asl.w	#8,d5
			move.b	(a0)+,d5
loc_201F92:
			subq.w	#7,d6
			move.w	d5,d1
			lsr.w	d6,d1
			move.w	d1,d0
			andi.w	#$F,d1
			andi.w	#$70,d0
			cmpi.w	#9,d6
			bcc.s	loc_201F6E
			addq.w	#8,d6
			asl.w	#8,d5
			move.b	(a0)+,d5
			bra.s	loc_201F6E
; End of function sub_201F7A
; =============== S U B R O U T I N E =======================================
sub_201FB0:
			move.l	d4,(a4)
			subq.w	#1,a5
			move.w	a5,d4
			bne.s	sub_201F7A
			rts
; End of function sub_201FB0
; =============== S U B R O U T I N E =======================================
sub_201FBA:
			eor.l	d4,d2
			move.l	d2,(a4)
			subq.w	#1,a5
			move.w	a5,d4
			bne.s	sub_201F7A
			rts
; End of function sub_201FBA
; ---------------------------------------------------------------------------
loc_201FC6:
			move.l	d4,(a4)+
			subq.w	#1,a5
			move.w	a5,d4
			bne.s	sub_201F7A
			rts
; ---------------------------------------------------------------------------
			eor.l	d4,d2
			move.l	d2,(a4)+
			subq.w	#1,a5
			move.w	a5,d4
			bne.s	sub_201F7A
			rts
; =============== S U B R O U T I N E =======================================
sub_201FDC:
			move.b	(a0)+,d0
loc_201FDE:
			cmpi.b	#$FF,d0
			bne.s	loc_201FE6
			rts
; ---------------------------------------------------------------------------
loc_201FE6:
			move.w	d0,d7
loc_201FE8:
			move.b	(a0)+,d0
			cmpi.b	#$80,d0
			bcc.s	loc_201FDE
			move.b	d0,d1
			andi.w	#$F,d7
			andi.w	#$70,d1
			or.w	d1,d7
			andi.w	#$F,d0
			move.b	d0,d1
			lsl.w	#8,d1
			or.w	d1,d7
			moveq	#8,d1
			sub.w	d0,d1
			bne.s	loc_202016
			move.b	(a0)+,d0
			add.w	d0,d0
			move.w	d7,(a1,d0.w)
			bra.s	loc_201FE8
; ---------------------------------------------------------------------------
loc_202016:
			move.b	(a0)+,d0
			lsl.w	d1,d0
			add.w	d0,d0
			moveq	#1,d5
			lsl.w	d1,d5
			subq.w	#1,d5
loc_202022:
			move.w	d7,(a1,d0.w)
			addq.w	#2,d0
			dbf	d5,loc_202022
			bra.s	loc_201FE8
; End of function sub_201FDC
; =============== S U B R O U T I N E =======================================
sub_20202E:
			movem.l a1-a2,-(sp)
			lea	(divdev_index).l,a1
			add.w	d0,d0
			move.w	(a1,d0.w),d0
			lea	(a1,d0.w),a1
			lea	(dword_FFF680).w,a2
loc_202046:
			tst.l	(a2)
			beq.s	loc_20204E
			addq.w	#6,a2
			bra.s	loc_202046
; ---------------------------------------------------------------------------
loc_20204E:
			move.w	(a1)+,d0
			bmi.s	loc_20205A
loc_202052:
			move.l	(a1)+,(a2)+
			move.w	(a1)+,(a2)+
			dbf	d0,loc_202052
loc_20205A:
			movem.l (sp)+,a1-a2
			rts
; End of function sub_20202E
; ---------------------------------------------------------------------------
loc_202060:
			movem.l a1-a2,-(sp)
			lea	(divdev_index).l,a1
			add.w	d0,d0
			move.w	(a1,d0.w),d0
			lea	(a1,d0.w),a1
			bsr.s	sub_20208C
			lea	(dword_FFF680).w,a2
			move.w	(a1)+,d0
			bmi.s	loc_202086
loc_20207E:
			move.l	(a1)+,(a2)+
			move.w	(a1)+,(a2)+
			dbf	d0,loc_20207E
loc_202086:
			movem.l (sp)+,a1-a2
			rts
; =============== S U B R O U T I N E =======================================
sub_20208C:
			lea	(dword_FFF680).w,a2
			moveq	#$80/4-1,d0
loc_202092:
			clr.l	(a2)+
			dbf	d0,loc_202092
			rts
; End of function sub_20208C
; =============== S U B R O U T I N E =======================================
sub_20209A:
			tst.l	(dword_FFF680).w
			beq.s	locret_2020EE
			tst.w	(word_FFF6F8).w
			bne.s	locret_2020EE
			movea.l (dword_FFF680).w,a0
			lea	(sub_201FB0).l,a3
			lea	(bitdevwk).w,a1
			move.w	(a0)+,d2
			bpl.s	loc_2020BC
			adda.w	#(sub_201FBA-sub_201FB0),a3
loc_2020BC:
			andi.w	#$7FFF,d2
			move.w	d2,(word_FFF6F8).w
			bsr.w	sub_201FDC
			move.b	(a0)+,d5
			asl.w	#8,d5
			move.b	(a0)+,d5
			moveq	#$10,d6
			moveq	#0,d0
			move.l	a0,(dword_FFF680).w
			move.l	a3,(dword_FFF6E0).w
			move.l	d0,(dword_FFF6E4).w
			move.l	d0,(dword_FFF6E8).w
			move.l	d0,(dword_FFF6EC).w
			move.l	d5,(dword_FFF6F0).w
			move.l	d6,(dword_FFF6F4).w
locret_2020EE:
			rts
; End of function sub_20209A
; =============== S U B R O U T I N E =======================================
sub_2020F0:
			tst.w	(word_FFF6F8).w
			beq.w	locret_202188
			move.w	#9,(word_FFF6FA).w
			moveq	#0,d0
			move.w	(word_FFF684).w,d0
			addi.w	#$120,(word_FFF684).w
			bra.s	loc_202124
; End of function sub_2020F0
; =============== S U B R O U T I N E =======================================
sub_20210C:
			tst.w	(word_FFF6F8).w
			beq.s	locret_202188
			move.w	#3,(word_FFF6FA).w
			moveq	#0,d0
			move.w	(word_FFF684).w,d0
			addi.w	#$60,(word_FFF684).w
loc_202124:
			lea	(vdpctrl).l,a4
			lsl.l	#2,d0
			lsr.w	#2,d0
			ori.w	#$4000,d0
			swap	d0
			move.l	d0,(a4)
			subq.w	#4,a4
			movea.l (dword_FFF680).w,a0
			movea.l (dword_FFF6E0).w,a3
			move.l	(dword_FFF6E4).w,d0
			move.l	(dword_FFF6E8).w,d1
			move.l	(dword_FFF6EC).w,d2
			move.l	(dword_FFF6F0).w,d5
			move.l	(dword_FFF6F4).w,d6
			lea	(bitdevwk).w,a1
loc_202158:
			movea.w #8,a5
			bsr.w	sub_201F7A
			subq.w	#1,(word_FFF6F8).w
			beq.s	loc_20218A
			subq.w	#1,(word_FFF6FA).w
			bne.s	loc_202158
			move.l	a0,(dword_FFF680).w
			move.l	a3,(dword_FFF6E0).w
			move.l	d0,(dword_FFF6E4).w
			move.l	d1,(dword_FFF6E8).w
			move.l	d2,(dword_FFF6EC).w
			move.l	d5,(dword_FFF6F0).w
			move.l	d6,(dword_FFF6F4).w
locret_202188:
			rts
; ---------------------------------------------------------------------------
loc_20218A:
			lea	(dword_FFF680).w,a0
			moveq	#$58/4-1,d0
loc_202190:
			move.l	6(a0),(a0)+
			dbf	d0,loc_202190
			rts
; End of function sub_20210C
; ---------------------------------------------------------------------------
			lea	(divdev_index).l,a1
			add.w	d0,d0
			move.w	(a1,d0.w),d0
			lea	(a1,d0.w),a1
			move.w	(a1)+,d1
loc_2021AC:
			movea.l (a1)+,a0
			moveq	#0,d0
			move.w	(a1)+,d0
			lsl.l	#2,d0
			lsr.w	#2,d0
			ori.w	#$4000,d0
			swap	d0
			move.l	d0,(vdpctrl).l
			bsr.w	sub_201EEE
			dbf	d1,loc_2021AC
			rts
; ---------------------------------------------------------------------------
mapdevr:
			movem.l d0-d7/a1-a5,-(sp)
			movea.w d0,a3
			move.b	(a0)+,d0
			ext.w	d0
			movea.w d0,a5
			move.b	(a0)+,d4
			lsl.b	#3,d4
			movea.w (a0)+,a2
			adda.w	a3,a2
			movea.w (a0)+,a4
			adda.w	a3,a4
			move.b	(a0)+,d5
			asl.w	#8,d5
			move.b	(a0)+,d5
			moveq	#$10,d6
loc_2021EC:
			moveq	#7,d0
			move.w	d6,d7
			sub.w	d0,d7
			move.w	d5,d1
			lsr.w	d7,d1
			andi.w	#$7F,d1
			move.w	d1,d2
			cmpi.w	#$40,d1
			bcc.s	loc_202206
			moveq	#6,d0
			lsr.w	#1,d2
loc_202206:
			bsr.w	sub_20233A
			andi.w	#$F,d2
			lsr.w	#4,d1
			add.w	d1,d1
			jmp	loc_202262(pc,d1.w)
; ---------------------------------------------------------------------------
loc_202216:
			move.w	a2,(a1)+
			addq.w	#1,a2
			dbf	d2,loc_202216
			bra.s	loc_2021EC
; ---------------------------------------------------------------------------
loc_202220:
			move.w	a4,(a1)+
			dbf	d2,loc_202220
			bra.s	loc_2021EC
; ---------------------------------------------------------------------------
loc_202228:
			bsr.w	loc_20228A
loc_20222C:
			move.w	d1,(a1)+
			dbf	d2,loc_20222C
			bra.s	loc_2021EC
; ---------------------------------------------------------------------------
loc_202234:
			bsr.w	loc_20228A
loc_202238:
			move.w	d1,(a1)+
			addq.w	#1,d1
			dbf	d2,loc_202238
			bra.s	loc_2021EC
; ---------------------------------------------------------------------------
loc_202242:
			bsr.w	loc_20228A
loc_202246:
			move.w	d1,(a1)+
			subq.w	#1,d1
			dbf	d2,loc_202246
			bra.s	loc_2021EC
; ---------------------------------------------------------------------------
loc_202250:
			cmpi.w	#$F,d2
			beq.s	loc_202272
loc_202256:
			bsr.w	loc_20228A
			move.w	d1,(a1)+
			dbf	d2,loc_202256
			bra.s	loc_2021EC
; ---------------------------------------------------------------------------
loc_202262:
			bra.s	loc_202216
; ---------------------------------------------------------------------------
			bra.s	loc_202216
; ---------------------------------------------------------------------------
			bra.s	loc_202220
; ---------------------------------------------------------------------------
			bra.s	loc_202220
; ---------------------------------------------------------------------------
			bra.s	loc_202228
; ---------------------------------------------------------------------------
			bra.s	loc_202234
; ---------------------------------------------------------------------------
			bra.s	loc_202242
; ---------------------------------------------------------------------------
			bra.s	loc_202250
; ---------------------------------------------------------------------------
loc_202272:
			subq.w	#1,a0
			cmpi.w	#$10,d6
			bne.s	loc_20227C
			subq.w	#1,a0
loc_20227C:
			move.w	a0,d0
			lsr.w	#1,d0
			bcc.s	loc_202284
			addq.w	#1,a0
loc_202284:
			movem.l (sp)+,d0-d7/a1-a5
			rts
; ---------------------------------------------------------------------------
loc_20228A:
			move.w	a3,d3
			move.b	d4,d1
			add.b	d1,d1
			bcc.s	loc_20229C
			subq.w	#1,d6
			btst	d6,d5
			beq.s	loc_20229C
			ori.w	#$8000,d3
loc_20229C:
			add.b	d1,d1
			bcc.s	loc_2022AA
			subq.w	#1,d6
			btst	d6,d5
			beq.s	loc_2022AA
			addi.w	#$4000,d3
loc_2022AA:
			add.b	d1,d1
			bcc.s	loc_2022B8
			subq.w	#1,d6
			btst	d6,d5
			beq.s	loc_2022B8
			addi.w	#$2000,d3
loc_2022B8:
			add.b	d1,d1
			bcc.s	loc_2022C6
			subq.w	#1,d6
			btst	d6,d5
			beq.s	loc_2022C6
			ori.w	#$1000,d3
loc_2022C6:
			add.b	d1,d1
			bcc.s	loc_2022D4
			subq.w	#1,d6
			btst	d6,d5
			beq.s	loc_2022D4
			ori.w	#$800,d3
loc_2022D4:
			move.w	d5,d1
			move.w	d6,d7
			sub.w	a5,d7
			bcc.s	loc_202304
			move.w	d7,d6
			addi.w	#$10,d6
			neg.w	d7
			lsl.w	d7,d1
			move.b	(a0),d5
			rol.b	d7,d5
			add.w	d7,d7
			and.w	word_20231A-2(pc,d7.w),d5
			add.w	d5,d1
loc_2022F2:
			move.w	a5,d0
			add.w	d0,d0
			and.w	word_20231A-2(pc,d0.w),d1
			add.w	d3,d1
			move.b	(a0)+,d5
			lsl.w	#8,d5
			move.b	(a0)+,d5
			rts
; ---------------------------------------------------------------------------
loc_202304:
			beq.s	loc_202316
			lsr.w	d7,d1
			move.w	a5,d0
			add.w	d0,d0
			and.w	word_20231A-2(pc,d0.w),d1
			add.w	d3,d1
			move.w	a5,d0
			bra.s	sub_20233A
; ---------------------------------------------------------------------------
loc_202316:
			moveq	#$10,d6
			bra.s	loc_2022F2
; ---------------------------------------------------------------------------
word_20231A:
			dc.w	 1,	   3,	 7,	  $F
			dc.w   $1F,	 $3F,  $7F,	 $FF
			dc.w  $1FF, $3FF, $7FF, $FFF
			dc.w $1FFF,$3FFF,$7FFF,$FFFF
; =============== S U B R O U T I N E =======================================
sub_20233A:
			sub.w	d0,d6
			cmpi.w	#9,d6
			bcc.s	locret_202348
			addq.w	#8,d6
			asl.w	#8,d5
			move.b	(a0)+,d5
locret_202348:
			rts
; End of function sub_20233A
; ---------------------------------------------------------------------------
unlze:
			subq.l	#2,sp
			move.b	(a0)+,1(sp)
			move.b	(a0)+,(sp)
			move.w	(sp),d5
			moveq	#$F,d4
loc_202356:
			lsr.w	#1,d5
			move.w	sr,d6
			dbf	d4,loc_202368

			move.b	(a0)+,1(sp)
			move.b	(a0)+,(sp)
			move.w	(sp),d5
			moveq	#$F,d4
loc_202368:
			move.w	d6,ccr
			bcc.s	loc_202370
			move.b	(a0)+,(a1)+
			bra.s	loc_202356
; ---------------------------------------------------------------------------
loc_202370:
			moveq	#0,d3
			lsr.w	#1,d5
			move.w	sr,d6
			dbf	d4,loc_202384

			move.b	(a0)+,1(sp)
			move.b	(a0)+,(sp)
			move.w	(sp),d5
			moveq	#$F,d4
loc_202384:
			move.w	d6,ccr
			bcs.s	loc_2023B4
			lsr.w	#1,d5
			dbf	d4,loc_202398

			move.b	(a0)+,1(sp)
			move.b	(a0)+,(sp)
			move.w	(sp),d5
			moveq	#$F,d4
loc_202398:
			roxl.w	#1,d3
			lsr.w	#1,d5
			dbf	d4,loc_2023AA

			move.b	(a0)+,1(sp)
			move.b	(a0)+,(sp)
			move.w	(sp),d5
			moveq	#$F,d4
loc_2023AA:
			roxl.w	#1,d3
			addq.w	#1,d3
			moveq	#-1,d2
			move.b	(a0)+,d2
			bra.s	loc_2023CA
; ---------------------------------------------------------------------------
loc_2023B4:
			move.b	(a0)+,d0
			move.b	(a0)+,d1
			moveq	#-1,d2
			move.b	d1,d2
			lsl.w	#5,d2
			move.b	d0,d2
			andi.w	#7,d1
			beq.s	loc_2023D6
			move.b	d1,d3
			addq.w	#1,d3
loc_2023CA:
			move.b	(a1,d2.w),d0
			move.b	d0,(a1)+
			dbf	d3,loc_2023CA

			bra.s	loc_202356
; ---------------------------------------------------------------------------
loc_2023D6:
			move.b	(a0)+,d1
			beq.s	loc_2023E6
			cmpi.b	#1,d1
			beq.w	loc_202356
			move.b	d1,d3
			bra.s	loc_2023CA
; ---------------------------------------------------------------------------
loc_2023E6:
			addq.l	#2,sp
			rts
; =============== S U B R O U T I N E =======================================
sub_2023EA:
			lea	(actwk).w,a6
			tst.b	(byte_FF1219).l
			beq.s	locret_2023FA
			lea	(byte_FFD040).w,a6
locret_2023FA:
			rts
; End of function sub_2023EA
; =============== S U B R O U T I N E =======================================
sub_2023FC:
			bsr.s	sub_2023EA
			moveq	#0,d0
			move.b	d0,(byte_FFF740).w
			move.b	d0,(byte_FFF741).w
			move.b	d0,(byte_FFF746).w
			move.b	d0,(byte_FFF748).w
			move.b	d0,(byte_FFF742).w
			lea	(word_202450).l,a0
			move.w	(a0)+,d0
			move.w	d0,(word_FFF730).w
			move.l	(a0)+,d0
			move.l	d0,(dword_FFF728).w
			move.l	d0,(dword_FFF720).w
			move.l	(a0)+,d0
			move.l	d0,(dword_FFF72C).w
			move.l	d0,(dword_FFF724).w
			move.w	(dword_FFF728).w,d0
			addi.w	#$240,d0
			move.w	d0,(word_FFF732).w
			move.w	#$1010,(word_FFF74A).w
			move.w	(a0)+,d0
			move.w	d0,(word_FFF73E).w
			bra.w	loc_20247C
; ---------------------------------------------------------------------------
word_202450:
			dc.w 4
			dc.w 0
			dc.w $2697
			dc.w 0
			dc.w $310
			dc.w $60

word_20245C:
			dc.w $50, $3B0
			dc.w $EA0, $46C
			dc.w $1750, $BD
			dc.w $A00, $62C
			dc.w $BB0, $4C
			dc.w $1570, $16C
			dc.w $1B0, $72C
			dc.w $1400, $2AC
; ---------------------------------------------------------------------------
loc_20247C:
			tst.b	(byte_FF1230).l
			beq.s	loc_202498
			jsr	(sub_205EE4).l
			moveq	#0,d0
			moveq	#0,d1
			move.w	obj.xpos(a6),d1
			move.w	obj.ypos(a6),d0
			bra.s	loc_2024D4
; ---------------------------------------------------------------------------
loc_202498:
			lea	(word_202510).l,a1
			tst.w	(word_FF13F0).l
			bpl.s	loc_2024BA
			move.w	(word_FF13F4).l,d0
			subq.w	#1,d0
			lsl.w	#2,d0
			lea	(word_20245C).l,a1
			adda.w	d0,a1
			bra.s	loc_2024C4
; ---------------------------------------------------------------------------
loc_2024BA:
			move.w	(word_FF13F0).l,d0
			lsl.w	#2,d0
			adda.w	d0,a1
loc_2024C4:
			moveq	#0,d1
			move.w	(a1)+,d1
			move.w	d1,obj.xpos(a6)
			moveq	#0,d0
			move.w	(a1),d0
			move.w	d0,obj.ypos(a6)
loc_2024D4:
			subi.w	#$A0,d1
			bcc.s	loc_2024DC
			moveq	#0,d1
loc_2024DC:
			move.w	(dword_FFF728+2).w,d2
			cmp.w	d2,d1
			bcs.s	loc_2024E6
			move.w	d2,d1
loc_2024E6:
			move.w	d1,(dword_FFF700).w
			subi.w	#$60,d0
			bcc.s	loc_2024F2
			moveq	#0,d0
loc_2024F2:
			cmp.w	(dword_FFF72C+2).w,d0
			blt.s	loc_2024FC
			move.w	(dword_FFF72C+2).w,d0
loc_2024FC:
			move.w	d0,(dword_FFF704).w
			bsr.w	sub_202518
			lea	(byte_202514).l,a1
			move.l	(a1),(dword_FFF7AC).w
			rts
; End of function sub_2023FC
; ---------------------------------------------------------------------------
word_202510:
			incbin	"Player Positions/Player Positions.bin"
			even

byte_202514:
			dc.b $8C,$7F,$1E,$1E
			even

; =============== S U B R O U T I N E =======================================
sub_202518:
			swap	d0
			asr.l	#4,d0
			move.l	d0,d2
			add.l	d2,d2
			add.l	d2,d0
			move.l	d0,(dword_FFF70C).w
			swap	d0
			move.w	d0,(word_FFF714).w
			move.w	d0,(word_FFF71C).w
			lsr.w	#1,d1
			move.w	d1,(dword_FFF708).w
			lsr.w	#1,d1
			move.w	d1,(dword_FFF710).w
			lsr.w	#1,d1
			move.w	d1,(dword_FFF718).w
			lea	(byte_FFA800).w,a2
			clr.l	(a2)+
			clr.l	(a2)+
			clr.l	(a2)+
			clr.l	(a2)+
			rts
; End of function sub_202518
; =============== S U B R O U T I N E =======================================
sub_202550:
			bsr.w	sub_2023EA
			tst.b	(byte_FFF744).w
			beq.s	loc_20255C
			rts
; ---------------------------------------------------------------------------
loc_20255C:
			clr.w	(dword_FFF754).w
			clr.w	(dword_FFF754+2).w
			clr.w	(word_FFF758).w
			clr.w	(word_FFF75A).w
			bsr.w	sub_202716
			bsr.w	sub_2027B8
			bsr.w	sub_203030
			move.w	(dword_FFF704).w,(dword_FFF616).w
			move.w	(dword_FFF70C).w,(dword_FFF616+2).w
			move.w	(word_FFF73A).w,d4
			ext.l	d4
			asl.l	#5,d4
			moveq	#6,d6
			bsr.w	sub_202A42
			move.w	(word_FFF73A).w,d4
			ext.l	d4
			asl.l	#6,d4
			moveq	#4,d6
			bsr.w	sub_202A0E
			lea	(byte_FFA800+$10).w,a1
			move.w	(word_FFF73A).w,d4
			ext.l	d4
			asl.l	#7,d4
			move.w	(word_FFF73C).w,d5
			ext.l	d5
			asl.l	#4,d5
			move.l	d5,d3
			add.l	d5,d5
			add.l	d3,d5
			bsr.w	sub_20290A
			move.w	(dword_FFF70C).w,(dword_FFF616+2).w
			move.w	(dword_FFF70C).w,(word_FFF714).w
			move.w	(dword_FFF70C).w,(word_FFF71C).w
			move.b	(word_FFF75A).w,d0
			or.b	(word_FFF758).w,d0
			or.b	d0,(dword_FFF754+2).w
			clr.b	(word_FFF75A).w
			clr.b	(word_FFF758).w
			lea	(byte_FFA800).w,a2
			addi.l	#$10000,(a2)+
			addi.l	#$C000,(a2)+
			addi.l	#$8000,(a2)+
			addi.l	#$4000,(a2)+
			move.w	(dword_FFF700).w,d0
			neg.w	d0
			swap	d0
			move.w	(byte_FFA800).w,d0
			add.w	(dword_FFF718).w,d0
			neg.w	d0
			move.w	#4-1,d1
loc_202616:
			move.w	d0,(a1)+
			dbf	d1,loc_202616

			move.w	(byte_FFA800+4).w,d0
			add.w	(dword_FFF718).w,d0
			neg.w	d0
			move.w	#4-1,d1
loc_20262A:
			move.w	d0,(a1)+
			dbf	d1,loc_20262A

			move.w	(byte_FFA800+8).w,d0
			add.w	(dword_FFF718).w,d0
			neg.w	d0
			move.w	#3-1,d1
loc_20263E:
			move.w	d0,(a1)+
			dbf	d1,loc_20263E

			move.w	(byte_FFA800+$C).w,d0
			add.w	(dword_FFF718).w,d0
			neg.w	d0
			move.w	#1-1,d1
loc_202652:
			move.w	d0,(a1)+
			dbf	d1,loc_202652

			move.w	#6-1,d1
			move.w	(dword_FFF718).w,d0
			neg.w	d0
loc_202662:
			move.w	d0,(a1)+
			dbf	d1,loc_202662

			move.w	#8-1,d1
			move.w	(dword_FFF710).w,d0
			neg.w	d0
loc_202672:
			move.w	d0,(a1)+
			dbf	d1,loc_202672

			lea	(byte_FFCC00).w,a1
			lea	(byte_FFA800+$10).w,a2
			move.w	(dword_FFF70C).w,d0
			move.w	d0,d2
			andi.w	#$1F8,d0
			lsr.w	#2,d0
			move.w	d0,d3
			lsr.w	#1,d3
			moveq	#$19,d1
			moveq	#$1C,d5
			sub.w	d3,d1
			bcs.s	loc_2026A2
			sub.w	d1,d5
			lea	(a2,d0.w),a2
			bsr.w	sub_2026D4
loc_2026A2:
			move.w	(dword_FFF710).w,d0
			move.w	(dword_FFF700).w,d2
			sub.w	d0,d2
			ext.l	d2
			asl.l	#8,d2
			divs.w	#256,d2
			ext.l	d2
			asl.l	#8,d2
			moveq	#0,d3
			move.w	d0,d3
			move.w	d5,d1
			lsl.w	#3,d1
			subq.w	#1,d1
loc_2026C2:
			move.w	d3,d0
			neg.w	d0
			move.l	d0,(a1)+
			swap	d3
			add.l	d2,d3
			swap	d3
			dbf	d1,loc_2026C2
			rts
; End of function sub_202550
; =============== S U B R O U T I N E =======================================
sub_2026D4:
			andi.w	#7,d2
			add.w	d2,d2
			move.w	(a2)+,d0
			jmp	loc_2026E2(pc,d2.w)
; End of function sub_2026D4
; ---------------------------------------------------------------------------
loc_2026E0:
			move.w	(a2)+,d0
loc_2026E2:
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			dbf	d1,loc_2026E0
			rts
; ---------------------------------------------------------------------------
			neg.w	d0
			jmp	loc_202700(pc,d2.w)
; ---------------------------------------------------------------------------
			neg.w	d0
loc_202700:
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			move.l	d0,(a1)+
			dbf	d1,loc_2026E0
			rts
; =============== S U B R O U T I N E =======================================
sub_202716:								; CODE XREF: sub_202550+1C↑p
			move.w	(dword_FFF700).w,d4
			bsr.s	sub_20274A
			move.w	(dword_FFF700).w,d0
			andi.w	#$10,d0
			move.b	(word_FFF74A).w,d1
			eor.b	d1,d0
			bne.s	locret_202748
			eori.b	#$10,(word_FFF74A).w
			move.w	(dword_FFF700).w,d0
			sub.w	d4,d0
			bpl.s	loc_202742
			bset	#2,(dword_FFF754).w
			rts
; ---------------------------------------------------------------------------
loc_202742:								; CODE XREF: sub_202716+22↑j
			bset	#3,(dword_FFF754).w
locret_202748:							; CODE XREF: sub_202716+14↑j
			rts
; End of function sub_202716
; =============== S U B R O U T I N E =======================================
sub_20274A:								; CODE XREF: sub_202716+4↑p
			move.w	obj.xpos(a6),d0
			sub.w	(dword_FFF700).w,d0
			subi.w	#$90,d0
			blt.s	loc_20278E
			subi.w	#$10,d0
			bge.s	loc_202764
			clr.w	(word_FFF73A).w
			rts
; ---------------------------------------------------------------------------
loc_202764:								; CODE XREF: sub_20274A+12↑j
										; ROM:002027B6↓j
			cmpi.w	#16,d0
			blt.s	loc_20276E
			move.w	#16,d0
loc_20276E:								; CODE XREF: sub_20274A+1E↑j
			add.w	(dword_FFF700).w,d0
			cmp.w	(dword_FFF728+2).w,d0
			blt.s	loc_20277C
			move.w	(dword_FFF728+2).w,d0
loc_20277C:								; CODE XREF: sub_20274A+2C↑j
										; sub_20274A+56↓j ...
			move.w	d0,d1
			sub.w	(dword_FFF700).w,d1
			asl.w	#8,d1
			move.w	d0,(dword_FFF700).w
			move.w	d1,(word_FFF73A).w
			rts
; ---------------------------------------------------------------------------
loc_20278E:								; CODE XREF: sub_20274A+C↑j
										; ROM:002027B0↓j
			cmpi.w	#-16,d0
			bge.s	loc_202798
			move.w	#-16,d0
loc_202798:								; CODE XREF: sub_20274A+48↑j
			add.w	(dword_FFF700).w,d0
			cmp.w	(dword_FFF728).w,d0
			bgt.s	loc_20277C
			move.w	(dword_FFF728).w,d0
			bra.s	loc_20277C
; End of function sub_20274A
; ---------------------------------------------------------------------------
			tst.w	d0
			bpl.s	loc_2027B2
			move.w	#-2,d0
			bra.s	loc_20278E
; ---------------------------------------------------------------------------
loc_2027B2:								; CODE XREF: ROM:002027AA↑j
			move.w	#2,d0
			bra.s	loc_202764
; =============== S U B R O U T I N E =======================================
sub_2027B8:								; CODE XREF: sub_202550+20↑p
			moveq	#0,d1
			move.w	obj.ypos(a6),d0
			sub.w	(dword_FFF704).w,d0
			btst	#2,obj.status(a6)
			beq.s	loc_2027CC
			subq.w	#5,d0
loc_2027CC:								; CODE XREF: sub_2027B8+10↑j
			btst	#1,obj.status(a6)
			beq.s	loc_2027EC
			addi.w	#$20,d0
			sub.w	(word_FFF73E).w,d0
			bcs.s	loc_202838
			subi.w	#$40,d0
			bcc.s	loc_202838
			tst.b	(byte_FFF75C).w
			bne.s	loc_20284A
			bra.s	loc_2027F8
; ---------------------------------------------------------------------------
loc_2027EC:								; CODE XREF: sub_2027B8+1A↑j
			sub.w	(word_FFF73E).w,d0
			bne.s	loc_2027FE
			tst.b	(byte_FFF75C).w
			bne.s	loc_20284A
loc_2027F8:								; CODE XREF: sub_2027B8+32↑j
			clr.w	(word_FFF73C).w
			rts
; ---------------------------------------------------------------------------
loc_2027FE:								; CODE XREF: sub_2027B8+38↑j
			cmpi.w	#$60,(word_FFF73E).w
			bne.s	loc_202826
			move.w	obj.inertia(a6),d1
			bpl.s	loc_20280E
			neg.w	d1
loc_20280E:								; CODE XREF: sub_2027B8+52↑j
			cmpi.w	#$800,d1
			bcc.s	loc_202838
			move.w	#$600,d1
			cmpi.w	#6,d0
			bgt.s	loc_202898
			cmpi.w	#-6,d0
			blt.s	loc_202862
			bra.s	loc_202850
; ---------------------------------------------------------------------------
loc_202826:								; CODE XREF: sub_2027B8+4C↑j
			move.w	#$200,d1
			cmpi.w	#2,d0
			bgt.s	loc_202898
			cmpi.w	#-2,d0
			blt.s	loc_202862
			bra.s	loc_202850
; ---------------------------------------------------------------------------
loc_202838:								; CODE XREF: sub_2027B8+24↑j
										; sub_2027B8+2A↑j ...
			move.w	#$1000,d1
			cmpi.w	#$10,d0
			bgt.s	loc_202898
			cmpi.w	#-$10,d0
			blt.s	loc_202862
			bra.s	loc_202850
; ---------------------------------------------------------------------------
loc_20284A:								; CODE XREF: sub_2027B8+30↑j
										; sub_2027B8+3E↑j
			moveq	#0,d0
			move.b	d0,(byte_FFF75C).w
loc_202850:								; CODE XREF: sub_2027B8+6C↑j
										; sub_2027B8+7E↑j ...
			moveq	#0,d1
			move.w	d0,d1
			add.w	(dword_FFF704).w,d1
			tst.w	d0
			bpl.w	loc_2028A2
			bra.w	loc_20286E
; ---------------------------------------------------------------------------
loc_202862:								; CODE XREF: sub_2027B8+6A↑j
										; sub_2027B8+7C↑j ...
			neg.w	d1
			ext.l	d1
			asl.l	#8,d1
			add.l	(dword_FFF704).w,d1
			swap	d1
loc_20286E:								; CODE XREF: sub_2027B8+A6↑j
			cmp.w	(dword_FFF72C).w,d1
			bgt.s	loc_2028C6
			cmpi.w	#-$100,d1
			bgt.s	loc_202892
			andi.w	#$7FF,d1
			andi.w	#$7FF,obj.ypos(a6)
			andi.w	#$7FF,(dword_FFF704).w
			andi.w	#$3FF,(dword_FFF70C).w
			bra.s	loc_2028C6
; ---------------------------------------------------------------------------
loc_202892:								; CODE XREF: sub_2027B8+C0↑j
			move.w	(dword_FFF72C).w,d1
			bra.s	loc_2028C6
; ---------------------------------------------------------------------------
loc_202898:								; CODE XREF: sub_2027B8+64↑j
										; sub_2027B8+76↑j ...
			ext.l	d1
			asl.l	#8,d1
			add.l	(dword_FFF704).w,d1
			swap	d1
loc_2028A2:								; CODE XREF: sub_2027B8+A2↑j
			cmp.w	(dword_FFF72C+2).w,d1
			blt.s	loc_2028C6
			subi.w	#$800,d1
			bcs.s	loc_2028C2
			andi.w	#$7FF,obj.ypos(a6)
			subi.w	#$800,(dword_FFF704).w
			andi.w	#$3FF,(dword_FFF70C).w
			bra.s	loc_2028C6
; ---------------------------------------------------------------------------
loc_2028C2:								; CODE XREF: sub_2027B8+F4↑j
			move.w	(dword_FFF72C+2).w,d1
loc_2028C6:								; CODE XREF: sub_2027B8+BA↑j
										; sub_2027B8+D8↑j ...
			move.w	(dword_FFF704).w,d4
			swap	d1
			move.l	d1,d3
			sub.l	(dword_FFF704).w,d3
			ror.l	#8,d3
			move.w	d3,(word_FFF73C).w
			move.l	d1,(dword_FFF704).w
			move.w	(dword_FFF704).w,d0
			andi.w	#$10,d0
			move.b	(word_FFF74A+1).w,d1
			eor.b	d1,d0
			bne.s	locret_202908
			eori.b	#$10,(word_FFF74A+1).w
			move.w	(dword_FFF704).w,d0
			sub.w	d4,d0
			bpl.s	loc_202902
			bset	#0,(dword_FFF754).w
			rts
; ---------------------------------------------------------------------------
loc_202902:								; CODE XREF: sub_2027B8+140↑j
			bset	#1,(dword_FFF754).w
locret_202908:							; CODE XREF: sub_2027B8+132↑j
			rts
; End of function sub_2027B8
; =============== S U B R O U T I N E =======================================
sub_20290A:								; CODE XREF: sub_202550+6A↑p
			move.l	(dword_FFF708).w,d2
			move.l	d2,d0
			add.l	d4,d0
			move.l	d0,(dword_FFF708).w
			move.l	d0,d1
			swap	d1
			andi.w	#$10,d1
			move.b	(byte_FFF74C).w,d3
			eor.b	d3,d1
			bne.s	loc_20293E
			eori.b	#$10,(byte_FFF74C).w
			sub.l	d2,d0
			bpl.s	loc_202938
			bset	#2,(dword_FFF754+2).w
			bra.s	loc_20293E
; ---------------------------------------------------------------------------
loc_202938:								; CODE XREF: sub_20290A+24↑j
			bset	#3,(dword_FFF754+2).w
loc_20293E:								; CODE XREF: sub_20290A+1A↑j
										; sub_20290A+2C↑j
			move.l	(dword_FFF70C).w,d3
			move.l	d3,d0
			add.l	d5,d0
			move.l	d0,(dword_FFF70C).w
			move.l	d0,d1
			swap	d1
			andi.w	#$10,d1
			move.b	(byte_FFF74D).w,d2
			eor.b	d2,d1
			bne.s	locret_202972
			eori.b	#$10,(byte_FFF74D).w
			sub.l	d3,d0
			bpl.s	loc_20296C
			bset	#0,(dword_FFF754+2).w
			rts
; ---------------------------------------------------------------------------
loc_20296C:								; CODE XREF: sub_20290A+58↑j
			bset	#1,(dword_FFF754+2).w
locret_202972:							; CODE XREF: sub_20290A+4E↑j
			rts
; End of function sub_20290A
; ---------------------------------------------------------------------------
			move.l	(dword_FFF70C).w,d3
			move.l	d3,d0
			add.l	d5,d0
			move.l	d0,(dword_FFF70C).w
			move.l	d0,d1
			swap	d1
			andi.w	#$10,d1
			move.b	(byte_FFF74D).w,d2
			eor.b	d2,d1
			bne.s	locret_2029A8
			eori.b	#$10,(byte_FFF74D).w
			sub.l	d3,d0
			bpl.s	loc_2029A2
			bset	#4,(dword_FFF754+2).w
			rts
; ---------------------------------------------------------------------------
loc_2029A2:								; CODE XREF: ROM:00202998↑j
			bset	#5,(dword_FFF754+2).w
locret_2029A8:							; CODE XREF: ROM:0020298E↑j
			rts
; ---------------------------------------------------------------------------
			move.w	(dword_FFF70C).w,d3
			move.w	d0,(dword_FFF70C).w
			move.w	d0,d1
			andi.w	#$10,d1
			move.b	(byte_FFF74D).w,d2
			eor.b	d2,d1
			bne.s	locret_2029D8
			eori.b	#$10,(byte_FFF74D).w
			sub.w	d3,d0
			bpl.s	loc_2029D2
			bset	#0,(dword_FFF754+2).w
			rts
; ---------------------------------------------------------------------------
loc_2029D2:								; CODE XREF: ROM:002029C8↑j
			bset	#1,(dword_FFF754+2).w
locret_2029D8:							; CODE XREF: ROM:002029BE↑j
			rts
; ---------------------------------------------------------------------------
			move.l	(dword_FFF708).w,d2
			move.l	d2,d0
			add.l	d4,d0
			move.l	d0,(dword_FFF708).w
			move.l	d0,d1
			swap	d1
			andi.w	#$10,d1
			move.b	(byte_FFF74C).w,d3
			eor.b	d3,d1
			bne.s	locret_202A0C
			eori.b	#$10,(byte_FFF74C).w
			sub.l	d2,d0
			bpl.s	loc_202A06
			bset	d6,(dword_FFF754+2).w
			bra.s	locret_202A0C
; ---------------------------------------------------------------------------
loc_202A06:								; CODE XREF: ROM:002029FE↑j
			addq.b	#1,d6
			bset	d6,(dword_FFF754+2).w
locret_202A0C:							; CODE XREF: ROM:002029F4↑j
										; ROM:00202A04↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_202A0E:								; CODE XREF: sub_202550+4C↑p
			move.l	(dword_FFF710).w,d2
			move.l	d2,d0
			add.l	d4,d0
			move.l	d0,(dword_FFF710).w
			move.l	d0,d1
			swap	d1
			andi.w	#$10,d1
			move.b	(byte_FFF74E).w,d3
			eor.b	d3,d1
			bne.s	locret_202A40
			eori.b	#$10,(byte_FFF74E).w
			sub.l	d2,d0
			bpl.s	loc_202A3A
			bset	d6,(word_FFF758).w
			bra.s	locret_202A40
; ---------------------------------------------------------------------------
loc_202A3A:								; CODE XREF: sub_202A0E+24↑j
			addq.b	#1,d6
			bset	d6,(word_FFF758).w
locret_202A40:							; CODE XREF: sub_202A0E+1A↑j
										; sub_202A0E+2A↑j
			rts
; End of function sub_202A0E
; =============== S U B R O U T I N E =======================================
sub_202A42:								; CODE XREF: sub_202550+3E↑p
			move.l	(dword_FFF718).w,d2
			move.l	d2,d0
			add.l	d4,d0
			move.l	d0,(dword_FFF718).w
			move.l	d0,d1
			swap	d1
			andi.w	#$10,d1
			move.b	(byte_FFF750).w,d3
			eor.b	d3,d1
			bne.s	locret_202A74
			eori.b	#$10,(byte_FFF750).w
			sub.l	d2,d0
			bpl.s	loc_202A6E
			bset	d6,(word_FFF75A).w
			bra.s	locret_202A74
; ---------------------------------------------------------------------------
loc_202A6E:								; CODE XREF: sub_202A42+24↑j
			addq.b	#1,d6
			bset	d6,(word_FFF75A).w
locret_202A74:							; CODE XREF: sub_202A42+1A↑j
										; sub_202A42+2A↑j
			rts
; End of function sub_202A42
; =============== S U B R O U T I N E =======================================
sub_202A76:								; CODE XREF: ROM:0020178E↑p
			lea	(vdpctrl).l,a5
			lea	(vdpdata).l,a6
			lea	(dword_FFF754+2).w,a2
			lea	(dword_FFF708).w,a3
			lea	(lvllayoutbuffer+$40).w,a4
			move.w	#$6000,d2
			bsr.w	sub_202B60
			lea	(word_FFF758).w,a2
			lea	(dword_FFF710).w,a3
			bra.w	nullsub_1
; End of function sub_202A76
; =============== S U B R O U T I N E =======================================
sub_202AA2:								; CODE XREF: doupdates↑p
										; ROM:00201A2C↑p
			lea	(vdpctrl).l,a5
			lea	(vdpdata).l,a6
			lea	(dword_FF1330+2).l,a2
			lea	(dword_FF1318).l,a3
			lea	(lvllayoutbuffer+$40).w,a4
			move.w	#$6000,d2
			bsr.w	sub_202B60
			lea	(word_FF1334).l,a2
			lea	(byte_FF1320).l,a3
			bsr.w	nullsub_1
			lea	(word_FF1336).l,a2
			lea	(byte_FF1328).l,a3
			bsr.w	nullsub_2
			lea	(dword_FF1330).l,a2
			lea	(dword_FF1310).l,a3
			lea	(lvllayoutbuffer).w,a4
			move.w	#$4000,d2
			tst.b	(a2)
			beq.s	locret_202B5E
			bclr	#0,(a2)
			beq.s	loc_202B14
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	sub_202E6E
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	sub_202C48
loc_202B14:								; CODE XREF: sub_202AA2+60↑j
			bclr	#1,(a2)
			beq.s	loc_202B2E
			move.w	#224,d4
			moveq	#-16,d5
			bsr.w	sub_202E6E
			move.w	#224,d4
			moveq	#-16,d5
			bsr.w	sub_202C48
loc_202B2E:								; CODE XREF: sub_202AA2+76↑j
			bclr	#2,(a2)
			beq.s	loc_202B44
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	sub_202E6E
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	sub_202C9E
loc_202B44:								; CODE XREF: sub_202AA2+90↑j
			bclr	#3,(a2)
			beq.s	locret_202B5E
			moveq	#-16,d4
			move.w	#320,d5
			bsr.w	sub_202E6E
			moveq	#-16,d4
			move.w	#320,d5
			bsr.w	sub_202C9E
locret_202B5E:							; CODE XREF: sub_202AA2+5A↑j
										; sub_202AA2+A6↑j
			rts
; End of function sub_202AA2
; =============== S U B R O U T I N E =======================================
sub_202B60:								; CODE XREF: sub_202A76+1C↑p
										; sub_202AA2+20↑p
			lea	(unk_202F26).l,a0
			adda.w	#1,a0
			moveq	#-16,d4
			bclr	#0,(a2)
			bne.s	loc_202B7C
			bclr	#1,(a2)
			beq.s	loc_202BC6
			move.w	#224,d4
loc_202B7C:								; CODE XREF: sub_202B60+10↑j
			move.w	(dword_FFF70C).w,d0
			add.w	d4,d0
			andi.w	#$FFF0,d0
			asr.w	#4,d0
			move.b	(a0,d0.w),d0
			ext.w	d0
			add.w	d0,d0
			movea.l off_202BF6(pc,d0.w),a3
			beq.s	loc_202BAE
			moveq	#-16,d5
			move.l	a0,-(sp)
			movem.l d4-d5,-(sp)
			bsr.w	sub_202E6E
			movem.l (sp)+,d4-d5
			bsr.w	sub_202C48
			movea.l (sp)+,a0
			bra.s	loc_202BC6
; ---------------------------------------------------------------------------
loc_202BAE:								; CODE XREF: sub_202B60+34↑j
			moveq	#0,d5
			move.l	a0,-(sp)
			movem.l d4-d5,-(sp)
			bsr.w	sub_202E70
			movem.l (sp)+,d4-d5
			moveq	#$1F,d6
			bsr.w	sub_202C74
			movea.l (sp)+,a0
loc_202BC6:								; CODE XREF: sub_202B60+16↑j
										; sub_202B60+4C↑j
			tst.b	(a2)
			bne.s	loc_202BCC
			rts
; ---------------------------------------------------------------------------
loc_202BCC:								; CODE XREF: sub_202B60+68↑j
			moveq	#-16,d4
			moveq	#-16,d5
			move.b	(a2),d0
			andi.b	#$A8,d0
			beq.s	loc_202BE0
			lsr.b	#1,d0
			move.b	d0,(a2)
			move.w	#320,d5
loc_202BE0:								; CODE XREF: sub_202B60+76↑j
			move.w	(dword_FFF70C).w,d0
			andi.w	#$FFF0,d0
			asr.w	#4,d0
			suba.w	#1,a0
			lea	(a0,d0.w),a0
			bra.w	loc_202C06
; ---------------------------------------------------------------------------
off_202BF6: dc.l dword_FF1318			; DATA XREF: sub_202B60+30↑r
										; sub_202B60+B8↓r
			dc.l dword_FF1318
			dc.l byte_FF1320
			dc.l byte_FF1328
; ---------------------------------------------------------------------------
loc_202C06:								; CODE XREF: sub_202B60+92↑j
			moveq	#$F,d6
			move.l	#$800000,d7
loc_202C0E:								; CODE XREF: sub_202B60+DC↓j
			moveq	#0,d0
			move.b	(a0)+,d0
			btst	d0,(a2)
			beq.s	loc_202C38
			add.w	d0,d0
			movea.l off_202BF6(pc,d0.w),a3
			movem.l d4-d5/a0,-(sp)
			movem.l d4-d5,-(sp)
			bsr.w	sub_202D4A
			movem.l (sp)+,d4-d5
			bsr.w	sub_202E6E
			bsr.w	sub_202CCC
			movem.l (sp)+,d4-d5/a0
loc_202C38:								; CODE XREF: sub_202B60+B4↑j
			addi.w	#$10,d4
			dbf	d6,loc_202C0E
			clr.b	(a2)
			rts
; End of function sub_202B60
; =============== S U B R O U T I N E =======================================
nullsub_1:								; CODE XREF: sub_202A76+28↑j
										; sub_202AA2+30↑p
			rts
; End of function nullsub_1
; =============== S U B R O U T I N E =======================================
nullsub_2:								; CODE XREF: sub_202AA2+40↑p
			rts
; End of function nullsub_2
; =============== S U B R O U T I N E =======================================
sub_202C48:								; CODE XREF: sub_202AA2+6E↑p
										; sub_202AA2+88↑p ...
			moveq	#$15,d6
loc_202C4A:								; CODE XREF: sub_202ED0+16↓p
			move.l	#$800000,d7
			move.l	d0,d1
loc_202C52:								; CODE XREF: sub_202C48+26↓j
			movem.l d4-d5,-(sp)
			bsr.w	sub_202D4A
			move.l	d1,d0
			bsr.w	sub_202CCC
			addq.b	#4,d1
			andi.b	#$7F,d1
			movem.l (sp)+,d4-d5
			addi.w	#$10,d5
			dbf	d6,loc_202C52
			rts
; End of function sub_202C48
; =============== S U B R O U T I N E =======================================
sub_202C74:								; CODE XREF: sub_202B60+60↑p
										; sub_202F58+32↓p
			move.l	#$800000,d7
			move.l	d0,d1
loc_202C7C:								; CODE XREF: sub_202C74+24↓j
			movem.l d4-d5,-(sp)
			bsr.w	sub_202D4C
			move.l	d1,d0
			bsr.w	sub_202CCC
			addq.b	#4,d1
			andi.b	#$7F,d1
			movem.l (sp)+,d4-d5
			addi.w	#$10,d5
			dbf	d6,loc_202C7C
			rts
; End of function sub_202C74
; =============== S U B R O U T I N E =======================================
sub_202C9E:								; CODE XREF: sub_202AA2+9E↑p
										; sub_202AA2+B8↑p
			moveq	#$F,d6
			move.l	#$800000,d7
			move.l	d0,d1
loc_202CA8:								; CODE XREF: sub_202C9E+28↓j
			movem.l d4-d5,-(sp)
			bsr.w	sub_202D4A
			move.l	d1,d0
			bsr.w	sub_202CCC
			addi.w	#$100,d1
			andi.w	#$FFF,d1
			movem.l (sp)+,d4-d5
			addi.w	#$10,d4
			dbf	d6,loc_202CA8
			rts
; End of function sub_202C9E
; =============== S U B R O U T I N E =======================================
sub_202CCC:								; CODE XREF: sub_202B60+D0↑p
										; sub_202C48+14↑p ...
			or.w	d2,d0
			swap	d0
			btst	#4,(a0)
			bne.s	loc_202D08
			btst	#3,(a0)
			bne.s	loc_202CE8
			move.l	d0,(a5)
			move.l	(a1)+,(a6)
			add.l	d7,d0
			move.l	d0,(a5)
			move.l	(a1)+,(a6)
			rts
; ---------------------------------------------------------------------------
loc_202CE8:								; CODE XREF: sub_202CCC+E↑j
			move.l	d0,(a5)
			move.l	(a1)+,d4
			eori.l	#$8000800,d4
			swap	d4
			move.l	d4,(a6)
			add.l	d7,d0
			move.l	d0,(a5)
			move.l	(a1)+,d4
			eori.l	#$8000800,d4
			swap	d4
			move.l	d4,(a6)
			rts
; ---------------------------------------------------------------------------
loc_202D08:								; CODE XREF: sub_202CCC+8↑j
			btst	#3,(a0)
			bne.s	loc_202D2A
			move.l	d0,(a5)
			move.l	(a1)+,d5
			move.l	(a1)+,d4
			eori.l	#$10001000,d4
			move.l	d4,(a6)
			add.l	d7,d0
			move.l	d0,(a5)
			eori.l	#$10001000,d5
			move.l	d5,(a6)
			rts
; ---------------------------------------------------------------------------
loc_202D2A:								; CODE XREF: sub_202CCC+40↑j
			move.l	d0,(a5)
			move.l	(a1)+,d5
			move.l	(a1)+,d4
			eori.l	#$18001800,d4
			swap	d4
			move.l	d4,(a6)
			add.l	d7,d0
			move.l	d0,(a5)
			eori.l	#$18001800,d5
			swap	d5
			move.l	d5,(a6)
			rts
; End of function sub_202CCC
; =============== S U B R O U T I N E =======================================
sub_202D4A:								; CODE XREF: sub_202B60+C4↑p
										; sub_202C48+E↑p ...
			add.w	(a3),d5
; End of function sub_202D4A
; =============== S U B R O U T I N E =======================================
sub_202D4C:								; CODE XREF: sub_202C74+C↑p
			add.w	4(a3),d4
loc_202D50:								; CODE XREF: sub_202DD2+20↓p
										; ROM:00206904↓p
			lea	(blkwk).w,a1
			move.w	d4,d3
			lsr.w	#1,d3
			andi.w	#$380,d3
			lsr.w	#3,d5
			move.w	d5,d0
			lsr.w	#5,d0
			andi.w	#$7F,d0
			add.w	d3,d0
			move.l	#chunkbuffer,d3
			move.b	(a4,d0.w),d3
			beq.s	locret_202D98
			subq.b	#1,d3
			andi.w	#$7F,d3
			ror.w	#7,d3
			add.w	d4,d4
			andi.w	#$1E0,d4
			andi.w	#$1E,d5
			add.w	d4,d3
			add.w	d5,d3
			movea.l d3,a0
			move.w	(a0),d3
			andi.w	#$3FF,d3
			lsl.w	#3,d3
			adda.w	d3,a1
			moveq	#1,d0
locret_202D98:							; CODE XREF: sub_202D4C+26↑j
			rts
; End of function sub_202D4C
; ---------------------------------------------------------------------------
			move.w	d4,d3
			lsr.w	#1,d3
			andi.w	#$380,d3
			lsr.w	#3,d5
			move.w	d5,d0
			lsr.w	#5,d0
			andi.w	#$7F,d0
			add.w	d3,d0
			move.l	#chunkbuffer,d3
			move.b	(a4,d0.w),d3
			subq.b	#1,d3
			andi.w	#$7F,d3
			ror.w	#7,d3
			add.w	d4,d4
			andi.w	#$1E0,d4
			andi.w	#$1E,d5
			add.w	d4,d3
			add.w	d5,d3
			movea.l d3,a0
			rts
; =============== S U B R O U T I N E =======================================
sub_202DD2:								; CODE XREF: ROM:00203AB6↓p
										; ROM:00203AC0↓p ...
			move.l	a0,-(sp)
			lea	(lvllayoutbuffer).w,a4
			lea	(vdpctrl).l,a5
			lea	(vdpdata).l,a6
			move.w	#$4000,d2
			move.l	#$800000,d7
			movem.l d3-d5,-(sp)
			bsr.w	loc_202D50
			bne.s	loc_202DFE
			movem.l (sp)+,d3-d5
			bra.s	loc_202E26
; ---------------------------------------------------------------------------
loc_202DFE:								; CODE XREF: sub_202DD2+24↑j
			movem.l (sp)+,d3-d5
			move.w	d3,(a0)
			bsr.w	sub_202E2A
			bne.s	loc_202E26
			movem.l d3-d5,-(sp)
			lea	(blkwk).w,a1
			andi.w	#$3FF,d3
			lsl.w	#3,d3
			adda.w	d3,a1
			bsr.w	loc_202E74
			bsr.w	sub_202CCC
			movem.l (sp)+,d3-d5
loc_202E26:								; CODE XREF: sub_202DD2+2A↑j
										; sub_202DD2+36↑j
			movea.l (sp)+,a0
			rts
; End of function sub_202DD2
; =============== S U B R O U T I N E =======================================
sub_202E2A:								; CODE XREF: sub_202DD2+32↑p
			move.w	(dword_FFF704).w,d0
			move.w	d0,d1
			andi.w	#$FFF0,d0
			subi.w	#16,d0
			cmp.w	d0,d4
			bcs.s	loc_202E6A
			addi.w	#240,d1
			andi.w	#$FFF0,d1
			cmp.w	d1,d4
			bgt.s	loc_202E6A
			move.w	(dword_FFF700).w,d0
			move.w	d0,d1
			andi.w	#$FFF0,d0
			subi.w	#16,d0
			cmp.w	d0,d5
			bcs.s	loc_202E6A
			addi.w	#336,d1
			andi.w	#$FFF0,d1
			cmp.w	d1,d5
			bgt.s	loc_202E6A
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_202E6A:								; CODE XREF: sub_202E2A+10↑j
										; sub_202E2A+1C↑j ...
			moveq	#1,d0
			rts
; End of function sub_202E2A
; =============== S U B R O U T I N E =======================================
sub_202E6E:								; CODE XREF: sub_202AA2+66↑p
										; sub_202AA2+7E↑p ...
			add.w	(a3),d5
; End of function sub_202E6E
; =============== S U B R O U T I N E =======================================
sub_202E70:								; CODE XREF: sub_202B60+56↑p
										; sub_202F58+28↓p
			add.w	4(a3),d4
loc_202E74:								; CODE XREF: sub_202DD2+48↑p
			andi.w	#$F0,d4
			andi.w	#$1F0,d5
			lsl.w	#4,d4
			lsr.w	#2,d5
			add.w	d5,d4
			moveq	#3,d0
			swap	d0
			move.w	d4,d0
			rts
; End of function sub_202E70
; ---------------------------------------------------------------------------
			add.w	4(a3),d4
			add.w	(a3),d5
			andi.w	#$F0,d4
			andi.w	#$1F0,d5
			lsl.w	#4,d4
			lsr.w	#2,d5
			add.w	d5,d4
			moveq	#2,d0
			swap	d0
			move.w	d4,d0
			rts
; =============== S U B R O U T I N E =======================================
sub_202EA6:								; CODE XREF: ROM:00201330↑p
			lea	(vdpctrl).l,a5
			lea	(vdpdata).l,a6
			lea	(dword_FFF700).w,a3
			lea	(lvllayoutbuffer).w,a4
			move.w	#$4000,d2
			bsr.s	sub_202ED0
			lea	(dword_FFF708).w,a3
			lea	(lvllayoutbuffer+$40).w,a4
			move.w	#$6000,d2
			bra.w	loc_202EF8
; End of function sub_202EA6
; =============== S U B R O U T I N E =======================================
sub_202ED0:								; CODE XREF: sub_202EA6+18↑p
			moveq	#-16,d4
			moveq	#16-1,d6
loc_202ED4:								; CODE XREF: sub_202ED0+22↓j
			movem.l d4-d6,-(sp)
			moveq	#0,d5
			move.w	d4,d1
			bsr.w	sub_202E6E
			move.w	d1,d4
			moveq	#0,d5
			moveq	#$1F,d6
			bsr.w	loc_202C4A
			movem.l (sp)+,d4-d6
			addi.w	#$10,d4
			dbf	d6,loc_202ED4
			rts
; End of function sub_202ED0
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_202EA6
loc_202EF8:								; CODE XREF: sub_202EA6+26↑j
			moveq	#-16,d4
			moveq	#16-1,d6
loc_202EFC:								; CODE XREF: sub_202EA6+7A↓j
			movem.l d4-d6/a0,-(sp)
			lea	(unk_202F26).l,a0
			adda.w	#1,a0
			move.w	(dword_FFF70C).w,d0
			add.w	d4,d0
			andi.w	#$1F0,d0
			bsr.w	sub_202F58
			movem.l (sp)+,d4-d6/a0
			addi.w	#$10,d4
			dbf	d6,loc_202EFC
			rts
; END OF FUNCTION CHUNK FOR sub_202EA6
; ---------------------------------------------------------------------------
unk_202F26: dc.b   0					; DATA XREF: sub_202B60↑o
										; sub_202EA6+5A↑o
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
off_202F48: dc.l dword_FFF708&$FFFFFF			; DATA XREF: sub_202F58+8↓r
			dc.l dword_FFF708&$FFFFFF
			dc.l dword_FFF710&$FFFFFF
			dc.l dword_FFF718&$FFFFFF
; =============== S U B R O U T I N E =======================================
sub_202F58:								; CODE XREF: sub_202EA6+6E↑p
			lsr.w	#4,d0
			move.b	(a0,d0.w),d0
			add.w	d0,d0
			movea.l off_202F48(pc,d0.w),a3
			beq.s	loc_202F7A
			moveq	#-16,d5
			movem.l d4-d5,-(sp)
			bsr.w	sub_202E6E
			movem.l (sp)+,d4-d5
			bsr.w	sub_202C48
			bra.s	locret_202F8E
; ---------------------------------------------------------------------------
loc_202F7A:								; CODE XREF: sub_202F58+C↑j
			moveq	#0,d5
			movem.l d4-d5,-(sp)
			bsr.w	sub_202E70
			movem.l (sp)+,d4-d5
			moveq	#$20-1,d6
			bsr.w	sub_202C74
locret_202F8E:							; CODE XREF: sub_202F58+20↑j
			rts
; End of function sub_202F58
; =============== S U B R O U T I N E =======================================
sub_202F90:								; CODE XREF: ROM:0020132C↑p
			moveq	#0,d0
;			move.b	(zone).l,d0
;			lsl.w	#4,d0
			lea	(lvlheader).l,a2
			move.l	a2,-(sp)
			addq.l	#4,a2
			movea.l (a2)+,a0
			lea	(blkwk).w,a4
			bsr.w	bitdevwkr
			movea.l (a2)+,a0
			lea	(chunkbuffer).l,a1
			bsr.w	unlze
			bsr.w	layoutload
			move.w	(a2)+,d0
			move.w	(a2),d0
			andi.w	#$FF,d0
			bsr.w	palload_fade
			movea.l (sp)+,a2
			addq.w	#4,a2
			btst	#7,(byte_FF123D).l
			beq.s	loc_202FD6
			jmp	(loc_20DBD6).l
; ---------------------------------------------------------------------------
loc_202FD6:								; CODE XREF: sub_202F90+3E↑j
			moveq	#0,d0
			move.b	(a2),d0
			beq.s	locret_202FE0
			bsr.w	sub_20202E
locret_202FE0:							; CODE XREF: sub_202F90+4A↑j
			rts
; End of function sub_202F90
; =============== S U B R O U T I N E =======================================
layoutload:								; CODE XREF: sub_202F90+22↑p
			lea	(lvllayoutbuffer).w,a3
			move.w	#(lvllayoutbuffer_end-lvllayoutbuffer)/2-1,d1
			moveq	#0,d0
loc_202FEC:								; CODE XREF: layoutload+C↓j
			move.l	d0,(a3)+
			dbf	d1,loc_202FEC

			lea	(lvllayoutbuffer).w,a3
			moveq	#0,d1
			bsr.w	sub_203002
			lea	(lvllayoutbuffer+$40).w,a3
			moveq	#2,d1
; End of function layoutload
; =============== S U B R O U T I N E =======================================
sub_203002:								; CODE XREF: layoutload+16↑p
			moveq	#0,d0
			add.w	d1,d0
			lea	(lvllayout_index).l,a1
			move.w	(a1,d0.w),d0
			lea	(a1,d0.w),a1
			moveq	#0,d1
			move.w	d1,d2
			move.b	(a1)+,d1
			move.b	(a1)+,d2
loc_20301C:								; CODE XREF: sub_203002+28↓j
			move.w	d1,d0
			movea.l a3,a0
loc_203020:								; CODE XREF: sub_203002+20↓j
			move.b	(a1)+,(a0)+
			dbf	d0,loc_203020

			lea	$80(a3),a3
			dbf	d2,loc_20301C

			rts
; End of function sub_203002
; =============== S U B R O U T I N E =======================================
sub_203030:								; CODE XREF: sub_202550+24↑p
			bsr.w	sub_2023EA
			moveq	#0,d0
			move.b	(zone).l,d0
			add.w	d0,d0
			move.w	off_20309A(pc,d0.w),d0
			jsr	off_20309A(pc,d0.w)
			moveq	#4,d1
			move.w	(dword_FFF724+2).w,d0
			sub.w	(dword_FFF72C+2).w,d0
			beq.s	locret_203074
			bcc.s	loc_203076
			neg.w	d1
			move.w	(dword_FFF704).w,d0
			cmp.w	(dword_FFF724+2).w,d0
			bls.s	loc_20306A
			move.w	d0,(dword_FFF72C+2).w
			andi.w	#$FFFE,(dword_FFF72C+2).w
loc_20306A:								; CODE XREF: sub_203030+2E↑j
			add.w	d1,(dword_FFF72C+2).w
			move.b	#1,(byte_FFF75C).w
locret_203074:							; CODE XREF: sub_203030+20↑j
			rts
; ---------------------------------------------------------------------------
loc_203076:								; CODE XREF: sub_203030+22↑j
			move.w	(dword_FFF704).w,d0
			addq.w	#8,d0
			cmp.w	(dword_FFF72C+2).w,d0
			bcs.s	loc_20308E
			btst	#1,obj.status(a6)
			beq.s	loc_20308E
			add.w	d1,d1
			add.w	d1,d1
loc_20308E:								; CODE XREF: sub_203030+50↑j
										; sub_203030+58↑j
			add.w	d1,(dword_FFF72C+2).w
			move.b	#1,(byte_FFF75C).w
			rts
; End of function sub_203030
; ---------------------------------------------------------------------------
off_20309A: dc.w loc_2030AA-off_20309A
			dc.w loc_2030AA-off_20309A
			dc.w loc_2030CA-off_20309A
			dc.w loc_2030EA-off_20309A
			dc.w loc_2030EA-off_20309A
			dc.w loc_2030EA-off_20309A
			dc.w loc_2030EA-off_20309A
			dc.w loc_2030EA-off_20309A
; ---------------------------------------------------------------------------
loc_2030AA:								; DATA XREF: ROM:off_20309A↑o
										; ROM:0020309C↑o
			moveq	#0,d0
			move.b	(act).l,d0
			add.w	d0,d0
			move.w	off_2030BC(pc,d0.w),d0
			jmp	off_2030BC(pc,d0.w)
; ---------------------------------------------------------------------------
off_2030BC: dc.w loc_2030C2-off_2030BC
			dc.w loc_2030C2-off_2030BC
			dc.w loc_2030C2-off_2030BC
; ---------------------------------------------------------------------------
loc_2030C2:								; DATA XREF: ROM:off_2030BC↑o
										; ROM:002030BE↑o ...
			move.w	#$310,(dword_FFF724+2).w
			rts
; ---------------------------------------------------------------------------
loc_2030CA:								; DATA XREF: ROM:0020309E↑o
			moveq	#0,d0
			move.b	(act).l,d0
			add.w	d0,d0
			move.w	off_2030DC(pc,d0.w),d0
			jmp	off_2030DC(pc,d0.w)
; ---------------------------------------------------------------------------
off_2030DC: dc.w loc_2030E2-off_2030DC
			dc.w loc_2030E2-off_2030DC
			dc.w loc_2030E2-off_2030DC
; ---------------------------------------------------------------------------
loc_2030E2:								; DATA XREF: ROM:off_2030DC↑o
										; ROM:002030DE↑o ...
			move.w	#$510,(dword_FFF724+2).w
			rts
; ---------------------------------------------------------------------------
loc_2030EA:								; DATA XREF: ROM:002030A0↑o
										; ROM:002030A2↑o ...
			move.w	#$710,(dword_FFF724+2).w
			rts
; =============== S U B R O U T I N E =======================================
sub_2030F2:								; CODE XREF: ROM:00201434↑p
			lea	(actwk).w,a0
			moveq	#(byte_FFD800_end-actwk)/obj-1,d7
			moveq	#0,d0
loc_2030FA:								; CODE XREF: sub_2030F2+22↓j
										; ROM:0020311C↓p
			move.b	(a0),d0
			beq.s	loc_203110
			add.w	d0,d0
			add.w	d0,d0
			lea	(off_2034AE).l,a1
			movea.l -4(a1,d0.w),a1
			jsr	(a1)
			moveq	#0,d0
loc_203110:								; CODE XREF: sub_2030F2+A↑j
			lea	obj(a0),a0
			dbf	d7,loc_2030FA
			rts
; End of function sub_2030F2
; ---------------------------------------------------------------------------
			moveq	#(byte_FFD800-actwk)/obj-1,d7
			bsr.s	loc_2030FA
			moveq	#$1800/obj-1,d7
loc_203120:								; CODE XREF: ROM:00203134↓j
			moveq	#0,d0
			move.b	(a0),d0
			beq.s	loc_203130
			tst.b	obj.render(a0)
			bpl.s	loc_203130
			bsr.w	displaysprite
loc_203130:								; CODE XREF: ROM:00203124↑j
										; ROM:0020312A↑j
			lea	obj(a0),a0
			dbf	d7,loc_203120
			rts
; =============== S U B R O U T I N E =======================================
sub_20313A:								; CODE XREF: ROM:00203FEC↓j
										; ROM:0020402A↓p ...
			move.l	obj.xpos(a0),d2
			move.l	obj.ypos(a0),d3
			move.w	obj.xvel(a0),d0
			ext.l	d0
			asl.l	#8,d0
			add.l	d0,d2
			move.w	obj.yvel(a0),d0
			addi.w	#$38,obj.yvel(a0)
			ext.l	d0
			asl.l	#8,d0
			add.l	d0,d3
			move.l	d2,obj.xpos(a0)
			move.l	d3,obj.ypos(a0)
			rts
; End of function sub_20313A
; =============== S U B R O U T I N E =======================================
sub_203166:								; CODE XREF: ROM:0020400A↓p
										; ROM:0020405C↓p ...
			move.l	obj.xpos(a0),d2
			move.l	obj.ypos(a0),d3
			move.w	obj.xvel(a0),d0
			btst	#3,obj.status(a0)
			beq.s	loc_2031A2
			moveq	#0,d1
			move.b	obj.field_3D(a0),d1
			lsl.w	#6,d1
			addi.l	#actwk&$FFFFFF,d1
			movea.l d1,a1
			cmpi.b	#$1E,obj.id(a1)
			bne.s	loc_2031A2
			move.w	#-$100,d1
			btst	#0,obj.status(a1)
			beq.s	loc_2031A0
			neg.w	d1
loc_2031A0:								; CODE XREF: sub_203166+36↑j
			add.w	d1,d0
loc_2031A2:								; CODE XREF: sub_203166+12↑j
										; sub_203166+2A↑j
			ext.l	d0
			asl.l	#8,d0
			add.l	d0,d2
			move.w	obj.yvel(a0),d0
			ext.l	d0
			asl.l	#8,d0
			add.l	d0,d3
			move.l	d2,obj.xpos(a0)
			move.l	d3,obj.ypos(a0)
			rts
; End of function sub_203166
; =============== S U B R O U T I N E =======================================
displaysprite:							; CODE XREF: ROM:00200676↑j
										; ROM:0020312C↑p ...
			bclr	#7,obj.render(a0)
			move.b	obj.render(a0),d0
			andi.w	#$C,d0
			beq.s	loc_203204
			move.b	obj.field_19(a0),d0
			move.w	obj.xpos(a0),d3
			sub.w	(dword_FFF700).w,d3
			move.w	d3,d1
			add.w	d0,d1
			bmi.s	locret_203220
			move.w	d3,d1
			sub.w	d0,d1
			cmpi.w	#320,d1
			bge.s	locret_203220
			move.b	obj.field_16(a0),d0
			move.w	obj.ypos(a0),d3
			sub.w	(dword_FFF704).w,d3
			move.w	d3,d1
			add.w	d0,d1
			bmi.s	locret_203220
			move.w	d3,d1
			sub.w	d0,d1
			cmpi.w	#224,d1
			bge.s	locret_203220
loc_203204:								; CODE XREF: displaysprite+E↑j
			lea	(byte_FFAC00).w,a1
			move.w	obj.priority(a0),d0
			lsr.w	#1,d0
			andi.w	#$380,d0
			adda.w	d0,a1
			cmpi.w	#$7E,(a1)
			bcc.s	locret_203220
			addq.w	#2,(a1)
			adda.w	(a1),a1
			move.w	a0,(a1)
locret_203220:							; CODE XREF: displaysprite+20↑j
										; displaysprite+2A↑j ...
			rts
; End of function displaysprite
; ---------------------------------------------------------------------------
			lea	(byte_FFAC00).w,a2
			move.w	obj.priority(a1),d0
			lsr.w	#1,d0
			andi.w	#$380,d0
			adda.w	d0,a2
			cmpi.w	#$7E,(a2)
			bcc.s	locret_20323E
			addq.w	#2,(a2)
			adda.w	(a2),a2
			move.w	a1,(a2)
locret_20323E:							; CODE XREF: ROM:00203236↑j
			rts
; ---------------------------------------------------------------------------
deleteobj:								; CODE XREF: ROM:loc_20068E↑j
										; sub_203E16+14↓j ...
			movea.l a0,a1
			moveq	#0,d1
			moveq	#obj/4-1,d0
loc_203246:								; CODE XREF: obj13-6912↓j
			move.l	d1,(a1)+
			dbf	d0,loc_203246

			rts
; ---------------------------------------------------------------------------
dword_20324E:	dc.l 0						; DATA XREF: sub_20325E+2A↓r
			dc.l dword_FFF700&$FFFFFF
			dc.l dword_FFF708&$FFFFFF
			dc.l dword_FFF718&$FFFFFF
; =============== S U B R O U T I N E =======================================
sub_20325E:								; CODE XREF: ROM:loc_201458↑p
			lea	(byte_FFF800).w,a2
			moveq	#0,d5
			lea	(byte_FFAC00).w,a4
			moveq	#7,d7
loc_20326A:								; CODE XREF: sub_20325E+A8↓j
			tst.w	(a4)
			beq.w	loc_203302
			moveq	#2,d6
loc_203272:								; CODE XREF: sub_20325E+A0↓j
			movea.w (a4,d6.w),a0
			tst.b	(a0)
			beq.w	loc_2032FA
			move.b	obj.render(a0),d0
			move.b	d0,d4
			andi.w	#$C,d0
			beq.s	loc_2032B0
			movea.l dword_20324E(pc,d0.w),a1
			moveq	#0,d0
			move.b	obj.field_19(a0),d0
			move.w	obj.xpos(a0),d3
			sub.w	(a1),d3
			addi.w	#128,d3
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			move.w	obj.ypos(a0),d2
			sub.w	4(a1),d2
			addi.w	#128,d2
			bra.s	loc_2032D2
; ---------------------------------------------------------------------------
loc_2032B0:								; CODE XREF: sub_20325E+28↑j
			move.w	obj.scrypos(a0),d2
			move.w	obj.xpos(a0),d3
			bra.s	loc_2032D2
; ---------------------------------------------------------------------------
			move.w	obj.ypos(a0),d2
			sub.w	4(a1),d2
			addi.w	#128,d2
			cmpi.w	#$60,d2
			bcs.s	loc_2032FA
			cmpi.w	#$180,d2
			bcc.s	loc_2032FA
loc_2032D2:								; CODE XREF: sub_20325E+50↑j
										; sub_20325E+5A↑j
			movea.l obj.mappings(a0),a1
			moveq	#0,d1
			btst	#5,d4
			bne.s	loc_2032F0
			move.b	obj.frame(a0),d1
			add.w	d1,d1
			adda.w	(a1,d1.w),a1
			moveq	#0,d1
			move.b	(a1)+,d1
			subq.b	#1,d1
			bmi.s	loc_2032F4
loc_2032F0:								; CODE XREF: sub_20325E+7E↑j
			bsr.w	sub_203324
loc_2032F4:								; CODE XREF: sub_20325E+90↑j
			bset	#7,obj.render(a0)
loc_2032FA:								; CODE XREF: sub_20325E+1A↑j
										; sub_20325E+6C↑j ...
			addq.w	#2,d6
			subq.w	#2,(a4)
			bne.w	loc_203272
loc_203302:								; CODE XREF: sub_20325E+E↑j
			lea	$80(a4),a4
			dbf	d7,loc_20326A

			move.b	d5,(byte_FFF62C).w
			cmpi.b	#80,d5
			beq.s	loc_20331C
			move.l	#0,(a2)
			rts
; ---------------------------------------------------------------------------
loc_20331C:								; CODE XREF: sub_20325E+B4↑j
			move.b	#0,-5(a2)
			rts
; End of function sub_20325E
; =============== S U B R O U T I N E =======================================
sub_203324:								; CODE XREF: sub_20325E:loc_2032F0↑p
			movea.w obj.vram(a0),a3
			btst	#0,d4
			bne.s	loc_20336A
			btst	#1,d4
			bne.w	loc_2033B8
loc_203336:								; CODE XREF: sub_203324+40↓j
			cmpi.b	#80,d5
			beq.s	locret_203368
			move.b	(a1)+,d0
			ext.w	d0
			add.w	d2,d0
			move.w	d0,(a2)+
			move.b	(a1)+,(a2)+
			addq.b	#1,d5
			move.b	d5,(a2)+
			move.b	(a1)+,d0
			lsl.w	#8,d0
			move.b	(a1)+,d0
			add.w	a3,d0
			move.w	d0,(a2)+
			move.b	(a1)+,d0
			ext.w	d0
			add.w	d3,d0
			andi.w	#$1FF,d0
			bne.s	loc_203362
			addq.w	#1,d0
loc_203362:								; CODE XREF: sub_203324+3A↑j
			move.w	d0,(a2)+
			dbf	d1,loc_203336

locret_203368:							; CODE XREF: sub_203324+16↑j
			rts
; ---------------------------------------------------------------------------
loc_20336A:								; CODE XREF: sub_203324+8↑j
			btst	#1,d4
			bne.w	loc_2033FE
loc_203372:								; CODE XREF: sub_203324+8E↓j
			cmpi.b	#80,d5
			beq.s	locret_2033B6
			move.b	(a1)+,d0
			ext.w	d0
			add.w	d2,d0
			move.w	d0,(a2)+
			move.b	(a1)+,d4
			move.b	d4,(a2)+
			addq.b	#1,d5
			move.b	d5,(a2)+
			move.b	(a1)+,d0
			lsl.w	#8,d0
			move.b	(a1)+,d0
			add.w	a3,d0
			eori.w	#$800,d0
			move.w	d0,(a2)+
			move.b	(a1)+,d0
			ext.w	d0
			neg.w	d0
			add.b	d4,d4
			andi.w	#$18,d4
			addq.w	#8,d4
			sub.w	d4,d0
			add.w	d3,d0
			andi.w	#$1FF,d0
			bne.s	loc_2033B0
			addq.w	#1,d0
loc_2033B0:								; CODE XREF: sub_203324+88↑j
			move.w	d0,(a2)+
			dbf	d1,loc_203372

locret_2033B6:							; CODE XREF: sub_203324+52↑j
			rts
; ---------------------------------------------------------------------------
loc_2033B8:								; CODE XREF: sub_203324+E↑j
										; sub_203324+D4↓j
			cmpi.b	#80,d5
			beq.s	locret_2033FC
			move.b	(a1)+,d0
			move.b	(a1),d4
			ext.w	d0
			neg.w	d0
			lsl.b	#3,d4
			andi.w	#$18,d4
			addq.w	#8,d4
			sub.w	d4,d0
			add.w	d2,d0
			move.w	d0,(a2)+
			move.b	(a1)+,(a2)+
			addq.b	#1,d5
			move.b	d5,(a2)+
			move.b	(a1)+,d0
			lsl.w	#8,d0
			move.b	(a1)+,d0
			add.w	a3,d0
			eori.w	#$1000,d0
			move.w	d0,(a2)+
			move.b	(a1)+,d0
			ext.w	d0
			add.w	d3,d0
			andi.w	#$1FF,d0
			bne.s	loc_2033F6
			addq.w	#1,d0
loc_2033F6:								; CODE XREF: sub_203324+CE↑j
			move.w	d0,(a2)+
			dbf	d1,loc_2033B8

locret_2033FC:							; CODE XREF: sub_203324+98↑j
			rts
; ---------------------------------------------------------------------------
loc_2033FE:								; CODE XREF: sub_203324+4A↑j
										; sub_203324+128↓j
			cmpi.b	#80,d5
			beq.s	locret_203450
			move.b	(a1)+,d0
			move.b	(a1),d4
			ext.w	d0
			neg.w	d0
			lsl.b	#3,d4
			andi.w	#$18,d4
			addq.w	#8,d4
			sub.w	d4,d0
			add.w	d2,d0
			move.w	d0,(a2)+
			move.b	(a1)+,d4
			move.b	d4,(a2)+
			addq.b	#1,d5
			move.b	d5,(a2)+
			move.b	(a1)+,d0
			lsl.w	#8,d0
			move.b	(a1)+,d0
			add.w	a3,d0
			eori.w	#$1800,d0
			move.w	d0,(a2)+
			move.b	(a1)+,d0
			ext.w	d0
			neg.w	d0
			add.b	d4,d4
			andi.w	#$18,d4
			addq.w	#8,d4
			sub.w	d4,d0
			add.w	d3,d0
			andi.w	#$1FF,d0
			bne.s	loc_20344A
			addq.w	#1,d0
loc_20344A:								; CODE XREF: sub_203324+122↑j
			move.w	d0,(a2)+
			dbf	d1,loc_2033FE

locret_203450:							; CODE XREF: sub_203324+DE↑j
			rts
; End of function sub_203324
; ---------------------------------------------------------------------------
			move.w	obj.xpos(a0),d0
			sub.w	(dword_FFF700).w,d0
			bmi.s	loc_203476
			cmpi.w	#320,d0
			bge.s	loc_203476
			move.w	obj.ypos(a0),d1
			sub.w	(dword_FFF704).w,d1
			bmi.s	loc_203476
			cmpi.w	#224,d1
			bge.s	loc_203476
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_203476:								; CODE XREF: ROM:0020345A↑j
										; ROM:00203460↑j ...
			moveq	#1,d0
			rts
; ---------------------------------------------------------------------------
			moveq	#0,d1
			move.b	obj.field_19(a0),d1
			move.w	obj.xpos(a0),d0
			sub.w	(dword_FFF700).w,d0
			add.w	d1,d0
			bmi.s	loc_2034AA
			add.w	d1,d1
			sub.w	d1,d0
			cmpi.w	#320,d0
			bge.s	loc_2034AA
			move.w	obj.ypos(a0),d1
			sub.w	(dword_FFF704).w,d1
			bmi.s	loc_2034AA
			cmpi.w	#224,d1
			bge.s	loc_2034AA
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_2034AA:								; CODE XREF: ROM:0020348A↑j
										; ROM:00203494↑j ...
			moveq	#1,d0
			rts
; ---------------------------------------------------------------------------
off_2034AE: dc.l obj01					; DATA XREF: sub_2030F2+10↑o
			dc.l obj01
			dc.l obj03
			dc.l obj04
			dc.l obj05
			dc.l obj06
			dc.l obj07
			dc.l obj08
			dc.l obj09
			dc.l obj0A
			dc.l obj0B
			dc.l obj0C
			dc.l obj0D
			dc.l obj0E
			dc.l obj0F
			dc.l obj10
			dc.l obj11
			dc.l obj12
			dc.l obj13
			dc.l obj14
			dc.l obj15
			dc.l obj16
			dc.l obj17
			dc.l obj18
			dc.l obj19
			dc.l obj1A
			dc.l obj1B
			dc.l obj1C
			dc.l objNull
			dc.l objNull
			dc.l obj1F
			dc.l obj20
			dc.l obj21
			dc.l obj22
			dc.l obj23
			dc.l obj24
			dc.l objNull
			dc.l obj26
			dc.l obj27
			dc.l obj28
			dc.l obj29
; ---------------------------------------------------------------------------
objNull:								; DATA XREF: ROM:0020351E↑o
										; ROM:00203522↑o ...
			move.b	#0,(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_203558:								; CODE XREF: ROM:loc_203FC4↓p
			lea	(word_FFF780).w,a1
			cmpi.b	#1,obj.id(a0)
			beq.s	loc_203568
			lea	(word_FFF782).w,a1
loc_203568:								; CODE XREF: sub_203558+A↑j
			cmpi.b	#5,obj.ani(a0)
			beq.s	loc_203576
			move.w	#0,(a1)
			rts
; ---------------------------------------------------------------------------
loc_203576:								; CODE XREF: sub_203558+16↑j
			tst.w	(a1)
			bne.s	loc_203580
			move.b	#1,obj.render(a1)
loc_203580:								; CODE XREF: sub_203558+20↑j
			cmpi.w	#$2A30,(a1)
			bcs.s	locret_2035AE
			move.w	#0,(a1)
			move.b	#$2B,obj.ani(a0)
			move.w	#-$500,obj.yvel(a0)
			move.w	#$100,obj.xvel(a0)
			btst	#0,obj.status(a0)
			beq.s	loc_2035A8
			neg.w	obj.xvel(a0)
loc_2035A8:								; CODE XREF: sub_203558+4A↑j
			move.w	#0,obj.inertia(a0)
locret_2035AE:							; CODE XREF: sub_203558+2C↑j
			rts
; End of function sub_203558
; =============== S U B R O U T I N E =======================================
sub_2035B0:								; CODE XREF: ROM:loc_20362C↓p
			move.w	(word_FFF606).w,d0
			moveq	#2,d1
			lea	(word_FFF782).w,a4
			lea	(actwk).w,a5
			lea	(byte_FFD040).w,a6
			tst.b	(byte_FF1219).l
			beq.s	loc_2035DC
			move.w	(word_FFF604).w,d0
			moveq	#1,d1
			lea	(word_FFF780).w,a4
			lea	(byte_FFD040).w,a5
			lea	(actwk).w,a6
loc_2035DC:								; CODE XREF: sub_2035B0+18↑j
			tst.b	obj.id(a6)
			bne.s	locret_203614
			andi.b	#$F0,d0
			beq.s	locret_203614
			move.b	d1,obj.id(a6)
			move.b	obj.status(a5),obj.status(a6)
			move.l	obj.ypos(a5),obj.ypos(a6)
			move.l	obj.xpos(a5),obj.xpos(a6)
			move.w	obj.yvel(a5),obj.yvel(a6)
			move.w	obj.xvel(a5),obj.xvel(a6)
			move.w	obj.inertia(a5),obj.inertia(a6)
			move.w	#0,(a4)
locret_203614:							; CODE XREF: sub_2035B0+30↑j
										; sub_2035B0+36↑j
			rts
; End of function sub_2035B0
; ---------------------------------------------------------------------------
obj01:									; DATA XREF: ROM:off_2034AE↑o
										; ROM:002034B2↑o
			move.b	obj.field_2A(a0),d0
			beq.s	loc_20362C
			addq.b	#1,d0
			cmpi.b	#60,d0
			bcs.s	loc_203628
			move.b	#60,d0
loc_203628:								; CODE XREF: ROM:00203622↑j
			move.b	d0,obj.field_2A(a0)
loc_20362C:								; CODE XREF: ROM:0020361A↑j
			bsr.s	sub_2035B0
			clr.b	obj.field_29(a0)
			moveq	#0,d0
			move.b	obj.id(a0),d0
			subq.b	#1,d0
			cmp.b	(byte_FF1219).l,d0
			bne.s	loc_203648
			move.b	#1,obj.field_29(a0)
loc_203648:								; CODE XREF: ROM:00203640↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_203656(pc,d0.w),d1
			jmp	off_203656(pc,d1.w)
; ---------------------------------------------------------------------------
off_203656: dc.w loc_2036BE-*			; CODE XREF: ROM:00203652↑j
										; DATA XREF: ROM:0020364E↑r ...
			dc.w loc_203CB8-off_203656
			dc.w loc_204CF2-off_203656
			dc.w loc_204D5E-off_203656
			dc.w loc_204DBA-off_203656
; ---------------------------------------------------------------------------
			tst.b	obj.field_29(a0)
			beq.s	locret_203674
			move.b	#1,(byte_FF122C).l
			move.b	#3,(byte_FFD180).w
locret_203674:							; CODE XREF: ROM:00203664↑j
			rts
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_203F00
loc_203676:								; CODE XREF: sub_203F00+8E↓j
			tst.b	(byte_FFD300).w
			bne.s	locret_2036BA
			tst.b	obj.field_29(a0)
			beq.s	locret_2036BA
			move.b	#1,(byte_FF122F).l
			move.b	#3,(byte_FFD300).w
			move.b	#5,(byte_FFD300+obj.ani).w
			move.b	#3,(byte_FFD340).w
			move.b	#6,(byte_FFD340+obj.ani).w
			move.b	#3,(byte_FFD380).w
			move.b	#7,(byte_FFD380+obj.ani).w
			move.b	#3,(byte_FFD3C0).w
			move.b	#8,(byte_FFD3C0+obj.ani).w
locret_2036BA:							; CODE XREF: sub_203F00-886↑j
										; sub_203F00-880↑j
			rts
; END OF FUNCTION CHUNK FOR sub_203F00
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_2036BE:								; DATA XREF: ROM:off_203656↑o
			addq.b	#2,obj.routine(a0)
			move.b	#$13,obj.field_16(a0)
			move.b	#9,obj.field_17(a0)
			tst.b	(miniplay_flag).w
			beq.s	loc_2036E0
			move.b	#$A,obj.field_16(a0)
			move.b	#5,obj.field_17(a0)
loc_2036E0:								; CODE XREF: ROM:002036D2↑j
			move.l	#player_map,obj.mappings(a0)
			move.w	#$780,obj.vram(a0)
			cmpi.b	#1,obj.id(a0)
			beq.s	loc_2036FC
			move.w	#$797,obj.vram(a0)
loc_2036FC:								; CODE XREF: ROM:002036F4↑j
			move.b	#2,obj.priority(a0)
			move.b	#$18,obj.field_19(a0)
			move.b	#4,obj.render(a0)
			move.w	#$600,(word_FFF760).w
			move.w	#$C,(word_FFF762).w
			move.w	#$80,(word_FFF764).w
; =============== S U B R O U T I N E =======================================
sub_203720:								; CODE XREF: ROM:loc_203CB8↓p
			tst.b	(zone).l
			bne.s	locret_203786
			move.b	(word_FF1204+1).l,d0
			andi.b	#3,d0
			bne.s	locret_203786
			move.b	obj.field_16(a0),d2
			ext.w	d2
			add.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			bsr.w	sub_203800
			cmpi.b	#$2F,d1
			bne.s	locret_203788
			cmpi.w	#$15C0,obj.xpos(a0)
			bcc.s	locret_203786
			tst.b	obj.field_2C(a0)
			beq.s	locret_203786
			jsr	(findfreeobj).l
			bne.s	locret_203786
			move.b	#$E,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			moveq	#1,d0
			tst.w	obj.xvel(a0)
			bmi.s	loc_20377E
			moveq	#0,d0
loc_20377E:								; CODE XREF: sub_203720+5A↑j
			move.b	d0,obj.render(a1)
			move.b	d0,obj.status(a1)
locret_203786:							; CODE XREF: sub_203720+6↑j
										; sub_203720+12↑j ...
			rts
; ---------------------------------------------------------------------------
locret_203788:							; CODE XREF: sub_203720+2A↑j
			rts
; End of function sub_203720
; ---------------------------------------------------------------------------
			move.b	obj.field_16(a0),d2
			ext.w	d2
			add.w	obj.ypos(a0),d2
			cmpi.b	#$10,d1
			bne.s	loc_2037A8
			cmpi.w	#$210,d2
			bcc.s	locret_203786
			cmpi.w	#$208,d2
			bcs.s	locret_203786
			bra.s	loc_2037BA
; ---------------------------------------------------------------------------
loc_2037A8:								; CODE XREF: ROM:00203798↑j
			cmpi.b	#$21,d1
			bne.s	locret_203786
			cmpi.w	#$2A0,d2
			bcc.s	locret_203786
			cmpi.w	#$298,d2
			bcs.s	locret_203786
loc_2037BA:								; CODE XREF: ROM:002037A6↑j
			tst.w	obj.inertia(a0)
			beq.s	locret_203786
			jsr	(findfreeobj).l
			bne.s	locret_203786
			move.b	#$B,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			andi.w	#$FFF8,d2
			move.w	d2,obj.ypos(a1)
			move.b	#1,obj.field_28(a1)
			move.w	obj.inertia(a0),d0
			bpl.s	loc_2037EA
			neg.w	d0
loc_2037EA:								; CODE XREF: ROM:002037E6↑j
			cmpi.w	#$600,d0
			bcc.s	loc_2037F6
			move.b	#2,obj.field_28(a1)
loc_2037F6:								; CODE XREF: ROM:002037EE↑j
			move.w	#$A1,d0
			jmp	(queuesound2).l
; =============== S U B R O U T I N E =======================================
sub_203800:								; CODE XREF: sub_203720+22↑p
			move.w	d2,d0
			lsr.w	#1,d0
			andi.w	#$380,d0
			move.w	d3,d1
			lsr.w	#8,d1
			andi.w	#$7F,d1
			add.w	d1,d0
			move.l	#chunkbuffer,d1
			lea	(lvllayoutbuffer).w,a1
			move.b	(a1,d0.w),d1
			andi.b	#$7F,d1
			rts
; End of function sub_203800
; =============== S U B R O U T I N E =======================================
sub_203826:								; CODE XREF: ROM:00203D0A↓p
			cmpi.b	#zoneid_MZ,(zone).l
			beq.s	loc_203832
			rts
; ---------------------------------------------------------------------------
loc_203832:								; CODE XREF: sub_203826+8↑j
			move.w	obj.xvel(a0),d1
			move.w	obj.yvel(a0),d2
			jsr	(calcangle).l
			subi.b	#$20,d0
			andi.b	#$C0,d0
			cmpi.b	#$40,d0
			beq.w	loc_203916
			cmpi.b	#$80,d0
			beq.w	loc_20389C
			cmpi.b	#$C0,d0
			beq.w	loc_2038D8
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			sub.w	d0,d3
			bsr.w	sub_203954
			bne.s	locret_20389A
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d3
			bra.w	sub_203954
; ---------------------------------------------------------------------------
locret_20389A:							; CODE XREF: sub_203826+56↑j
			rts
; ---------------------------------------------------------------------------
loc_20389C:								; CODE XREF: sub_203826+2E↑j
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			sub.w	d0,d3
			bsr.w	sub_203954
			bne.s	locret_2038D6
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d3
			bra.w	sub_203954
; ---------------------------------------------------------------------------
locret_2038D6:							; CODE XREF: sub_203826+92↑j
			rts
; ---------------------------------------------------------------------------
loc_2038D8:								; CODE XREF: sub_203826+36↑j
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d3
			move.b	obj.field_16(a0),d0
			subq.b	#6,d0
			ext.w	d0
			sub.w	d0,d2
			bsr.w	sub_203954
			bne.s	locret_203914
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d3
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d2
			bra.w	sub_203954
; ---------------------------------------------------------------------------
locret_203914:							; CODE XREF: sub_203826+D0↑j
			rts
; ---------------------------------------------------------------------------
loc_203916:								; CODE XREF: sub_203826+26↑j
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.field_17(a0),d0
			ext.w	d0
			sub.w	d0,d3
			move.b	obj.field_16(a0),d0
			subq.b	#6,d0
			ext.w	d0
			sub.w	d0,d2
			bsr.w	sub_203954
			bne.s	locret_203952
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.field_17(a0),d0
			ext.w	d0
			sub.w	d0,d3
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d2
			bra.w	sub_203954
; ---------------------------------------------------------------------------
locret_203952:							; CODE XREF: sub_203826+10E↑j
			rts
; End of function sub_203826
; =============== S U B R O U T I N E =======================================
sub_203954:								; CODE XREF: sub_203826+52↑p
										; sub_203826+70↑j ...
			jsr	(sub_200E0C).l
			move.w	(a1),d0
			move.w	d0,d4
			andi.w	#$7FF,d0
			beq.s	loc_203994
			moveq	#0,d1
			move.b	(byte_FF123D).l,d1
			cmpi.b	#2,d1
			bne.s	loc_203978
			add.b	(byte_FF127A).l,d1
loc_203978:								; CODE XREF: sub_203954+1C↑j
			add.w	d1,d1
			move.w	off_203998(pc,d1.w),d1
			lea	off_203998(pc,d1.w),a1
			moveq	#0,d6
			move.w	(a1)+,d6
			moveq	#0,d1
loc_203988:								; CODE XREF: sub_203954+3C↓j
			cmp.w	(a1,d1.w),d0
			beq.s	loc_203A0C
			addq.w	#2,d1
			dbf	d6,loc_203988

loc_203994:								; CODE XREF: sub_203954+E↑j
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
off_203998: dc.w word_2039C2-*			; DATA XREF: sub_203954+26↑r
										; sub_203954+2A↑o ...
			dc.w word_2039A0-off_203998
			dc.w word_2039EA-off_203998
			dc.w word_2039C8-off_203998
word_2039A0:	dc.w 15						; DATA XREF: sub_203954+46↑o
			dc.w $13C
			dc.w $146
			dc.w $19B
			dc.w $1AE
			dc.w $83
			dc.w $84
			dc.w $89
			dc.w $8A
			dc.w $77
			dc.w $76
			dc.w $80
			dc.w $7F
			dc.w $7E
			dc.w $7D
			dc.w $7C
			dc.w $82
word_2039C2:	dc.w 1						; DATA XREF: sub_203954:off_203998↑o
			dc.w $145
			dc.w $146
word_2039C8:	dc.w 15						; DATA XREF: sub_203954+4A↑o
			dc.w $13C
			dc.w $146
			dc.w 0
			dc.w 0
			dc.w $83
			dc.w $84
			dc.w $89
			dc.w $8A
			dc.w $77
			dc.w $76
			dc.w $80
			dc.w $7F
			dc.w $7E
			dc.w $7D
			dc.w $7C
			dc.w $82
word_2039EA:	dc.w 15						; DATA XREF: sub_203954+48↑o
			dc.w $13C
			dc.w $146
			dc.w $165
			dc.w 0
			dc.w $83
			dc.w $84
			dc.w $89
			dc.w $8A
			dc.w $77
			dc.w $76
			dc.w $80
			dc.w $7F
			dc.w $7E
			dc.w $7D
			dc.w $7C
			dc.w $82
; ---------------------------------------------------------------------------
loc_203A0C:								; CODE XREF: sub_203954+38↑j
			move.b	#0,(byte_FF1886).l
			move.w	off_203A2C(pc,d1.w),d0
			jsr	off_203A2C(pc,d0.w)
			tst.b	(byte_FF1886).l
			beq.s	loc_203A28
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_203A28:								; CODE XREF: sub_203954+CE↑j
			moveq	#1,d0
			rts
; End of function sub_203954
; ---------------------------------------------------------------------------
off_203A2C: dc.w loc_203A4C-*			; CODE XREF: sub_203954+C4↑p
										; DATA XREF: sub_203954+C0↑r ...
			dc.w loc_203A4C-off_203A2C
			dc.w loc_203ADA-off_203A2C
			dc.w loc_203ADA-off_203A2C
			dc.w loc_203C70-off_203A2C
			dc.w sub_203B2C-off_203A2C
			dc.w sub_203B3E-off_203A2C
			dc.w sub_203B3E-off_203A2C
			dc.w loc_203C4C-off_203A2C
			dc.w sub_203BA4-off_203A2C
			dc.w sub_203BA4-off_203A2C
			dc.w sub_203BA4-off_203A2C
			dc.w sub_203B88-off_203A2C
			dc.w sub_203B2C-off_203A2C
			dc.w sub_203B2C-off_203A2C
			dc.w sub_203B50-off_203A2C
; ---------------------------------------------------------------------------
loc_203A4C:								; DATA XREF: ROM:off_203A2C↑o
										; ROM:00203A2E↑o
			andi.w	#$FFF0,d2
			tst.b	d1
			bne.s	loc_203A58
			addi.w	#$10,d2
loc_203A58:								; CODE XREF: ROM:00203A52↑j
			andi.w	#$FFF0,d3
			btst	#$B,d4
			bne.s	loc_203A66
			addi.w	#$10,d3
loc_203A66:								; CODE XREF: ROM:00203A60↑j
			move.w	d3,d1
			movem.l d1-d2,-(sp)
			sub.w	obj.xpos(a0),d1
			sub.w	obj.ypos(a0),d2
			jsr	(calcangle).l
			jsr	(calcsine).l
			muls.w	#-$700,d1
			asr.l	#8,d1
			move.w	d1,obj.xvel(a0)
			muls.w	#-$700,d0
			asr.l	#8,d0
			move.w	d0,obj.yvel(a0)
			bset	#1,obj.status(a0)
			bclr	#4,obj.status(a0)
			bclr	#5,obj.status(a0)
			clr.b	obj.field_3C(a0)
			movem.l (sp)+,d1-d2
			move.w	d2,d4
			move.w	d1,d5
			move.w	#0,d3
			jsr	(sub_202DD2).l
			subi.w	#$10,d5
			jsr	(sub_202DD2).l
			subi.w	#$10,d4
			jsr	(sub_202DD2).l
			addi.w	#$10,d5
			jmp	(sub_202DD2).l
; ---------------------------------------------------------------------------
loc_203ADA:								; DATA XREF: ROM:00203A30↑o
										; ROM:00203A32↑o
			andi.w	#$FFF0,d2
			addq.w	#8,d2
			andi.w	#$FFF0,d3
			addq.w	#8,d3
			move.w	d3,d1
			sub.w	obj.xpos(a0),d1
			sub.w	obj.ypos(a0),d2
			jsr	(calcangle).l
			jsr	(calcsine).l
			muls.w	#-$700,d1
			asr.l	#8,d1
			asr.l	#1,d1
			move.w	d1,obj.xvel(a0)
			muls.w	#-$700,d0
			asr.l	#8,d0
			asr.l	#1,d0
			move.w	d0,obj.yvel(a0)
; START OF FUNCTION CHUNK FOR sub_203B2C
;	ADDITIONAL PARENT FUNCTION sub_203B3E
;	ADDITIONAL PARENT FUNCTION sub_203B50
;	ADDITIONAL PARENT FUNCTION sub_203BA4
loc_203B14:								; CODE XREF: sub_203B2C+10↓j
										; sub_203B3E+10↓j ...
			bset	#1,obj.status(a0)
			bclr	#4,obj.status(a0)
			bclr	#5,obj.status(a0)
			clr.b	obj.field_3C(a0)
			rts
; END OF FUNCTION CHUNK FOR sub_203B2C
; =============== S U B R O U T I N E =======================================
sub_203B2C:								; CODE XREF: sub_203B88+12↓j
										; sub_203B88+18↓j ...
; FUNCTION CHUNK AT 00203B14 SIZE 00000018 BYTES
			move.w	#$700,d0
			tst.w	obj.yvel(a0)
			bmi.s	loc_203B38
			neg.w	d0
loc_203B38:								; CODE XREF: sub_203B2C+8↑j
			move.w	d0,obj.yvel(a0)
			bra.s	loc_203B14
; End of function sub_203B2C
; =============== S U B R O U T I N E =======================================
sub_203B3E:								; CODE XREF: sub_203B88+10↓j
										; sub_203B88+1A↓j ...
; FUNCTION CHUNK AT 00203B14 SIZE 00000018 BYTES
			move.w	#$700,d0
			tst.w	obj.xvel(a0)
			bmi.s	loc_203B4A
			neg.w	d0
loc_203B4A:								; CODE XREF: sub_203B3E+8↑j
			move.w	d0,obj.xvel(a0)
			bra.s	loc_203B14
; End of function sub_203B3E
; =============== S U B R O U T I N E =======================================
sub_203B50:								; CODE XREF: ROM:00203C84↓j
										; ROM:00203C8C↓j ...
; FUNCTION CHUNK AT 00203B14 SIZE 00000018 BYTES
			andi.w	#$FFF0,d2
			addq.w	#8,d2
			andi.w	#$FFF0,d3
			addq.w	#8,d3
			move.w	d3,d1
			sub.w	obj.xpos(a0),d1
			sub.w	obj.ypos(a0),d2
			jsr	(calcangle).l
			jsr	(calcsine).l
			muls.w	#-$700,d1
			asr.l	#8,d1
			move.w	d1,obj.xvel(a0)
			muls.w	#-$700,d0
			asr.l	#8,d0
			move.w	d0,obj.yvel(a0)
			bra.s	loc_203B14
; End of function sub_203B50
; =============== S U B R O U T I N E =======================================
sub_203B88:								; DATA XREF: ROM:00203A44↑o
			move.w	d3,d1
			andi.w	#$F,d1
			cmpi.b	#8,d1
			bcc.s	loc_203B9C
			btst	#$B,d4
			bne.s	sub_203B3E
			bra.s	sub_203B2C
; ---------------------------------------------------------------------------
loc_203B9C:								; CODE XREF: sub_203B88+A↑j
			btst	#$B,d4
			bne.s	sub_203B2C
			bra.s	sub_203B3E
; End of function sub_203B88
; =============== S U B R O U T I N E =======================================
sub_203BA4:								; CODE XREF: ROM:00203C60↓j
										; ROM:00203C6C↓j
										; DATA XREF: ...
; FUNCTION CHUNK AT 00203B14 SIZE 00000018 BYTES
			subi.w	#$12,d1
			bmi.s	loc_203BD6
			move.w	off_203C16(pc,d1.w),d0
			lea	off_203C16(pc,d0.w),a1
			andi.w	#$F,d2
			andi.w	#$F,d3
			btst	#$B,d4
			bne.s	loc_203BC6
			neg.b	d3
			addi.b	#$F,d3
loc_203BC6:								; CODE XREF: sub_203BA4+1A↑j
			cmp.b	(a1,d3.w),d2
			bcc.s	loc_203BD6
			move.b	#1,(byte_FF1886).l
			rts
; ---------------------------------------------------------------------------
loc_203BD6:								; CODE XREF: sub_203BA4+4↑j
										; sub_203BA4+26↑j
			move.w	obj.xvel(a0),d1
			move.w	obj.yvel(a0),d2
			jsr	(calcangle).l
			addi.b	#$80,d0
			neg.b	d0
			subi.b	#$20,d0
			btst	#$B,d4
			beq.s	loc_203BF8
			addi.b	#$40,d0
loc_203BF8:								; CODE XREF: sub_203BA4+4E↑j
			jsr	(calcsine).l
			muls.w	#-$700,d1
			asr.l	#8,d1
			move.w	d1,obj.xvel(a0)
			muls.w	#-$700,d0
			asr.l	#8,d0
			move.w	d0,obj.yvel(a0)
			bra.w	loc_203B14
; End of function sub_203BA4
; ---------------------------------------------------------------------------
off_203C16: dc.w unk_203C1C-*			; DATA XREF: sub_203BA4+6↑r
										; sub_203BA4+A↑o ...
			dc.w unk_203C2C-off_203C16
			dc.w unk_203C3C-off_203C16
unk_203C1C: dc.b   1					; DATA XREF: ROM:off_203C16↑o
			dc.b   1
			dc.b   1
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   3
			dc.b   3
			dc.b   3
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   5
			dc.b   5
			dc.b   5
			dc.b   6
unk_203C2C: dc.b   6					; DATA XREF: ROM:00203C18↑o
			dc.b   6
			dc.b   7
			dc.b   7
			dc.b   7
			dc.b   8
			dc.b   8
			dc.b   8
			dc.b   9
			dc.b   9
			dc.b   9
			dc.b  $A
			dc.b  $A
			dc.b  $A
			dc.b  $B
			dc.b  $B
unk_203C3C: dc.b  $B					; DATA XREF: ROM:00203C1A↑o
			dc.b  $C
			dc.b  $C
			dc.b  $C
			dc.b  $D
			dc.b  $D
			dc.b  $D
			dc.b  $E
			dc.b  $E
			dc.b  $E
			dc.b  $F
			dc.b  $F
			dc.b  $F
			dc.b $10
			dc.b $10
			dc.b $10
; ---------------------------------------------------------------------------
loc_203C4C:								; DATA XREF: ROM:00203A3C↑o
			move.w	d3,d1
			andi.w	#$F,d1
			cmpi.b	#8,d1
			bcc.s	loc_203C64
			btst	#$B,d4
			bne.w	sub_203B3E
			bra.w	sub_203BA4
; ---------------------------------------------------------------------------
loc_203C64:								; CODE XREF: ROM:00203C56↑j
			btst	#$B,d4
			bne.w	sub_203B2C
			bra.w	sub_203BA4
; ---------------------------------------------------------------------------
loc_203C70:								; DATA XREF: ROM:00203A34↑o
			move.w	d3,d1
			andi.w	#$F,d1
			cmpi.b	#8,d1
			bcc.s	loc_203C88
			btst	#$B,d4
			bne.w	sub_203B2C
			bra.w	sub_203B50
; ---------------------------------------------------------------------------
loc_203C88:								; CODE XREF: ROM:00203C7A↑j
			btst	#$B,d4
			bne.w	sub_203B50
			bra.w	sub_203B2C
; ---------------------------------------------------------------------------
			move.w	d2,d1
			andi.w	#$F,d1
			cmpi.b	#8,d1
			bcc.s	loc_203CAC
			btst	#$C,d4
			bne.w	sub_203B3E
			bra.w	sub_203B50
; ---------------------------------------------------------------------------
loc_203CAC:								; CODE XREF: ROM:00203C9E↑j
			btst	#$C,d4
			bne.w	sub_203B50
			bra.w	sub_203B3E
; ---------------------------------------------------------------------------
loc_203CB8:								; DATA XREF: ROM:00203658↑o
			bsr.w	sub_203720
			tst.w	(word_FF13FA).l
			beq.s	loc_203CD6
			btst	#4,(word_FFF604+1).w
			beq.s	loc_203CD6
			move.b	#1,(word_FF1208).l
			rts
; ---------------------------------------------------------------------------
loc_203CD6:								; CODE XREF: ROM:00203CC2↑j
										; ROM:00203CCA↑j
			tst.b	(byte_FFF7CC).w
			bne.s	loc_203CF0
			move.w	(word_FFF604).w,(word_FFF602).w
			cmpi.b	#1,obj.id(a0)
			beq.s	loc_203CF0
			move.w	(word_FFF606).w,(word_FFF602).w
loc_203CF0:								; CODE XREF: ROM:00203CDA↑j
										; ROM:00203CE8↑j
			btst	#0,obj.field_2C(a0)
			bne.s	loc_203D0E
			moveq	#0,d0
			move.b	obj.status(a0),d0
			andi.w	#6,d0
			move.w	off_203D52(pc,d0.w),d1
			jsr	off_203D52(pc,d1.w)
			bsr.w	sub_203826
loc_203D0E:								; CODE XREF: ROM:00203CF6↑j
			bsr.s	sub_203D60
			tst.b	obj.field_29(a0)
			beq.s	loc_203D1A
			bsr.w	sub_203E5A
loc_203D1A:								; CODE XREF: ROM:00203D14↑j
			move.b	(byte_FFF768).w,obj.field_36(a0)
			move.b	(byte_FFF76A).w,obj.field_37(a0)
			tst.b	(byte_FFF7C7).w
			beq.s	loc_203D38
			tst.b	obj.ani(a0)
			bne.s	loc_203D38
			move.b	obj.prevani(a0),obj.ani(a0)
loc_203D38:								; CODE XREF: ROM:00203D2A↑j
										; ROM:00203D30↑j
			bsr.w	sub_204EF4
			tst.b	obj.field_2C(a0)
			bmi.s	loc_203D48
			jsr	(sub_2063B8).l
loc_203D48:								; CODE XREF: ROM:00203D40↑j
			bsr.w	sub_204E18
			bsr.w	sub_203E16
			rts
; ---------------------------------------------------------------------------
off_203D52: dc.w loc_203FB2-*			; CODE XREF: ROM:00203D06↑p
										; DATA XREF: ROM:00203D02↑r ...
			dc.w loc_20401A-off_203D52
			dc.w loc_204048-off_203D52
			dc.w loc_20406C-off_203D52
unk_203D5A: dc.b $81					; DATA XREF: sub_203D60:loc_203DC4↓o
			dc.b $82
			dc.b $83
			dc.b $84
			dc.b $85
			dc.b $86
			even
; =============== S U B R O U T I N E =======================================
sub_203D60:								; CODE XREF: ROM:loc_203D0E↑p
			cmpi.w	#$D2,(word_FFF786).w
			bcc.s	loc_203D8C
			move.w	obj.field_30(a0),d0
			beq.s	loc_203D76
			subq.w	#1,obj.field_30(a0)
			lsr.w	#3,d0
			bcc.s	loc_203D8C
loc_203D76:								; CODE XREF: sub_203D60+C↑j
			tst.b	obj.field_29(a0)
			bne.s	loc_203D86
			btst	#0,(dword_FF120C+3).l
			beq.s	loc_203D8C
loc_203D86:								; CODE XREF: sub_203D60+1A↑j
			jsr	(displaysprite).l
loc_203D8C:								; CODE XREF: sub_203D60+6↑j
										; sub_203D60+14↑j ...
			tst.b	(byte_FF122D).l
			beq.s	loc_203DDC
			tst.w	obj.field_32(a0)
			beq.s	loc_203DDC
			subq.w	#1,obj.field_32(a0)
			bne.s	loc_203DDC
			tst.b	(byte_FFF7AA).w
			bne.s	loc_203DD4
			cmpi.w	#$C,(play_air).l
			bcs.s	loc_203DD4
			moveq	#0,d0
			move.b	(zone).l,d0
			cmpi.w	#zoneact(zoneid_LZ,actid_4),(zone).l
			bne.s	loc_203DC4
			moveq	#5,d0
loc_203DC4:								; CODE XREF: sub_203D60+60↑j
			lea	(unk_203D5A).l,a1
			move.b	(a1,d0.w),d0
			jsr	(queuesound1).l
loc_203DD4:								; CODE XREF: sub_203D60+44↑j
										; sub_203D60+4E↑j
			move.b	#0,(byte_FF122D).l
loc_203DDC:								; CODE XREF: sub_203D60+32↑j
										; sub_203D60+38↑j ...
			tst.b	(byte_FF122E).l
			beq.s	locret_203E14
			tst.w	obj.field_34(a0)
			beq.s	locret_203E14
			subq.w	#1,obj.field_34(a0)
			bne.s	locret_203E14
			move.w	#$600,(word_FFF760).w
			move.w	#$C,(word_FFF762).w
			move.w	#$80,(word_FFF764).w
			move.b	#0,(byte_FF122E).l
			move.w	#$E3,d0
			jmp	(queuesound1).l
; ---------------------------------------------------------------------------
locret_203E14:							; CODE XREF: sub_203D60+82↑j
										; sub_203D60+88↑j ...
			rts
; End of function sub_203D60
; =============== S U B R O U T I N E =======================================
sub_203E16:								; CODE XREF: ROM:00203D4C↑p
			tst.b	obj.field_29(a0)
			bne.s	locret_203E58
			move.w	(dword_FFF700).w,d0
			subi.w	#$80,d0
			bcs.s	loc_203E2E
			cmp.w	obj.xpos(a0),d0
			bhi.w	deleteobj
loc_203E2E:								; CODE XREF: sub_203E16+E↑j
			addi.w	#$240,d0
			cmp.w	obj.xpos(a0),d0
			blt.w	deleteobj
			move.w	(dword_FFF704).w,d0
			subi.w	#$60,d0
			bcs.s	loc_203E4C
			cmp.w	obj.ypos(a0),d0
			bhi.w	deleteobj
loc_203E4C:								; CODE XREF: sub_203E16+2C↑j
			addi.w	#$180,d0
			cmp.w	obj.ypos(a0),d0
			blt.w	deleteobj
locret_203E58:							; CODE XREF: sub_203E16+4↑j
			rts
; End of function sub_203E16
; =============== S U B R O U T I N E =======================================
sub_203E5A:								; CODE XREF: ROM:00203D16↑p
										; ROM:00204D14↓p ...
			move.w	(word_FFF7A8).w,d0
			lea	(byte_FFCB00).w,a1
			lea	(a1,d0.w),a1
			move.w	obj.xpos(a0),(a1)+
			move.w	obj.ypos(a0),(a1)+
			addq.b	#4,(word_FFF7A8+1).w
			rts
; End of function sub_203E5A
; =============== S U B R O U T I N E =======================================
sub_203E74:								; CODE XREF: sub_203F00+78↓p
			move.b	(byte_FF1230).l,(byte_FF1255).l
			move.w	obj.xpos(a0),(word_FF1256).l
			move.w	obj.ypos(a0),(word_FF1258).l
			move.b	(byte_FFF742).w,(byte_FF125A).l
			move.b	(byte_FFF64D).w,(byte_FF1270).l
			move.w	(dword_FFF72C+2).w,(word_FF125C).l
			move.w	(dword_FFF700).w,(word_FF125E).l
			move.w	(dword_FFF704).w,(word_FF1260).l
			move.w	(dword_FFF708).w,(word_FF1262).l
			move.w	(dword_FFF70C).w,(word_FF1264).l
			move.w	(dword_FFF710).w,(word_FF1266).l
			move.w	(word_FFF714).w,(word_FF1268).l
			move.w	(dword_FFF718).w,(word_FF126A).l
			move.w	(word_FFF71C).w,(word_FF126C).l
			move.w	(word_FFF648).w,(word_FF126E).l
			move.b	(byte_FFF64D).w,(byte_FF1270).l
			move.b	(byte_FFF64E).w,(byte_FF1271).l
			rts
; End of function sub_203E74
; =============== S U B R O U T I N E =======================================
sub_203F00:								; CODE XREF: ROM:loc_203FF2↓p
										; ROM:loc_20401A↓p ...
			tst.b	obj.field_2A(a0)
			bne.w	locret_203FB0
			tst.b	(byte_FFF784).w
			beq.w	locret_203FB0
			move.w	(word_FFF760).w,d2
			moveq	#0,d0
			move.w	obj.inertia(a0),d0
			bpl.s	loc_203F1E
			neg.w	d0
loc_203F1E:								; CODE XREF: sub_203F00+1A↑j
			tst.w	(word_FFF786).w
			bne.s	loc_203F2A
			move.w	#1,(word_FFF786).w
loc_203F2A:								; CODE XREF: sub_203F00+22↑j
			move.w	(word_FFF786).w,d1
			cmpi.w	#$E6,d1
			bcs.s	loc_203F40
			move.b	#1,(word_FF1202).l
			bra.w	loc_205400
; ---------------------------------------------------------------------------
loc_203F40:								; CODE XREF: sub_203F00+32↑j
			cmpi.w	#$D2,d1
			bcs.s	loc_203F86
			cmpi.b	#2,(byte_FF1230).l
			beq.s	locret_203F84
			move.b	#1,(byte_FFF744).w
			move.b	(byte_FF123D).l,d0
			add.b	(byte_FFF784).w,d0
			bpl.s	loc_203F66
			moveq	#0,d0
			bra.s	loc_203F6E
; ---------------------------------------------------------------------------
loc_203F66:								; CODE XREF: sub_203F00+60↑j
			cmpi.b	#3,d0
			bcs.s	loc_203F6E
			moveq	#2,d0
loc_203F6E:								; CODE XREF: sub_203F00+64↑j
										; sub_203F00+6A↑j
			bset	#7,d0
			move.b	d0,(byte_FF123D).l
			bsr.w	sub_203E74
			move.b	#2,(byte_FF1230).l
locret_203F84:							; CODE XREF: sub_203F00+4E↑j
			rts
; ---------------------------------------------------------------------------
loc_203F86:								; CODE XREF: sub_203F00+44↑j
			cmpi.w	#$5A,d1
			bcc.s	loc_203F9E
			cmp.w	d2,d0
			bcc.w	loc_203676
			clr.w	(word_FFF786).w
			clr.b	(byte_FF122F).l
			rts
; ---------------------------------------------------------------------------
loc_203F9E:								; CODE XREF: sub_203F00+8A↑j
			cmp.w	d2,d0
			bcc.s	locret_203FB0
			clr.w	(word_FFF786).w
			clr.b	(byte_FFF784).w
			clr.b	(byte_FF122F).l
locret_203FB0:							; CODE XREF: sub_203F00+4↑j
										; sub_203F00+C↑j ...
			rts
; End of function sub_203F00
; ---------------------------------------------------------------------------
loc_203FB2:								; DATA XREF: ROM:off_203D52↑o
			tst.b	(byte_FFF75F).w
			beq.s	loc_203FC4
			cmpi.b	#5,obj.ani(a0)
			bne.s	locret_204018
			clr.b	(byte_FFF75F).w
loc_203FC4:								; CODE XREF: ROM:00203FB6↑j
			bsr.w	sub_203558
			cmpi.b	#$2B,obj.ani(a0)
			bne.s	loc_203FF2
			tst.b	(miniplay_flag).w
			beq.s	loc_203FE0
			cmpi.b	#$79,obj.frame(a0)
			bne.s	locret_204018
			bra.s	loc_203FE8
; ---------------------------------------------------------------------------
loc_203FE0:								; CODE XREF: ROM:00203FD4↑j
			cmpi.b	#$17,obj.frame(a0)
			bne.s	locret_204018
loc_203FE8:								; CODE XREF: ROM:00203FDE↑j
			bsr.w	sub_20477E
			jmp	(sub_20313A).l
; ---------------------------------------------------------------------------
loc_203FF2:								; CODE XREF: ROM:00203FCE↑j
			bsr.w	sub_203F00
			bsr.w	sub_20484C
			bsr.w	sub_2049B0
			bsr.w	sub_20409A
			bsr.w	sub_2047DC
			bsr.w	sub_20477E
			jsr	(sub_203166).l
			bsr.w	sub_200A9E
			bsr.w	sub_204A2E
locret_204018:							; CODE XREF: ROM:00203FBE↑j
										; ROM:00203FDC↑j ...
			rts
; ---------------------------------------------------------------------------
loc_20401A:								; DATA XREF: ROM:00203D54↑o
			bsr.w	sub_203F00
			bsr.w	sub_20496E
			bsr.w	sub_2046BC
			bsr.w	sub_20477E
			jsr	(sub_20313A).l
			btst	#6,obj.status(a0)
			beq.s	loc_20403E
			subi.w	#$28,obj.yvel(a0)
loc_20403E:								; CODE XREF: ROM:00204036↑j
			bsr.w	sub_204A70
			bsr.w	sub_204A8C
			rts
; ---------------------------------------------------------------------------
loc_204048:								; DATA XREF: ROM:00203D56↑o
			bsr.w	sub_203F00
			bsr.w	sub_20484C
			bsr.w	sub_2049EC
			bsr.w	sub_20451A
			bsr.w	sub_20477E
			jsr	(sub_203166).l
			bsr.w	sub_200A9E
			bsr.w	sub_204A2E
			rts
; ---------------------------------------------------------------------------
loc_20406C:								; DATA XREF: ROM:00203D58↑o
			bsr.w	sub_203F00
			bsr.w	sub_20496E
			bsr.w	sub_2046BC
			bsr.w	sub_20477E
			jsr	(sub_20313A).l
			btst	#6,obj.status(a0)
			beq.s	loc_204090
			subi.w	#$28,obj.yvel(a0)
loc_204090:								; CODE XREF: ROM:00204088↑j
			bsr.w	sub_204A70
			bsr.w	sub_204A8C
			rts
; =============== S U B R O U T I N E =======================================
sub_20409A:								; CODE XREF: ROM:00203FFE↑p
			move.w	(word_FFF760).w,d6
			move.w	(word_FFF762).w,d5
			move.w	(word_FFF764).w,d4
			tst.b	(byte_FFF7CA).w
			bne.w	loc_204380
			tst.w	obj.field_3E(a0)
			bne.w	loc_204330
			btst	#2,(word_FFF602).w
			beq.s	loc_2040C2
			bsr.w	sub_204410
loc_2040C2:								; CODE XREF: sub_20409A+22↑j
			btst	#3,(word_FFF602).w
			beq.s	loc_2040CE
			bsr.w	sub_204498
loc_2040CE:								; CODE XREF: sub_20409A+2E↑j
			move.b	obj.angle(a0),d0
			addi.b	#$20,d0
			andi.b	#$C0,d0
			bne.w	loc_204330
			tst.w	obj.inertia(a0)
			beq.s	loc_2040EC
			tst.b	obj.field_2A(a0)
			beq.w	loc_204330
loc_2040EC:								; CODE XREF: sub_20409A+48↑j
			bclr	#5,obj.status(a0)
			move.b	#5,obj.ani(a0)
			btst	#3,obj.status(a0)
			beq.s	loc_204148
			moveq	#0,d0
			move.b	obj.field_3D(a0),d0
			lsl.w	#6,d0
			lea	(actwk).w,a1
			lea	(a1,d0.w),a1
			tst.b	obj.status(a1)
			bmi.s	loc_20417C
			cmpi.b	#$1E,obj.id(a1)
			bne.s	loc_204128
			move.b	#0,obj.ani(a0)
			bra.w	loc_204330
; ---------------------------------------------------------------------------
loc_204128:								; CODE XREF: sub_20409A+82↑j
			moveq	#0,d1
			move.b	obj.field_19(a1),d1
			move.w	d1,d2
			add.w	d2,d2
			subq.w	#4,d2
			add.w	obj.xpos(a0),d1
			sub.w	obj.xpos(a1),d1
			cmpi.w	#4,d1
			blt.s	loc_20416C
			cmp.w	d2,d1
			bge.s	loc_20415C
			bra.s	loc_20417C
; ---------------------------------------------------------------------------
loc_204148:								; CODE XREF: sub_20409A+64↑j
			jsr	(sub_20611C).l
			cmpi.w	#$C,d1
			blt.s	loc_20417C
			cmpi.b	#3,obj.field_36(a0)
			bne.s	loc_204164
loc_20415C:								; CODE XREF: sub_20409A+AA↑j
			bclr	#0,obj.status(a0)
			bra.s	loc_204172
; ---------------------------------------------------------------------------
loc_204164:								; CODE XREF: sub_20409A+C0↑j
			cmpi.b	#3,obj.field_37(a0)
			bne.s	loc_20417C
loc_20416C:								; CODE XREF: sub_20409A+A6↑j
			bset	#0,obj.status(a0)
loc_204172:								; CODE XREF: sub_20409A+C8↑j
			move.b	#6,obj.ani(a0)
			bra.w	loc_204330
; ---------------------------------------------------------------------------
loc_20417C:								; CODE XREF: sub_20409A+7A↑j
										; sub_20409A+AC↑j ...
			tst.b	obj.field_29(a0)
			beq.w	loc_2041E4
			move.b	(byte_FFF788).w,d0
			andi.b	#$F,d0
			beq.s	loc_204198
			addq.b	#1,(byte_FFF788).w
			andi.b	#$CF,(byte_FFF788).w
loc_204198:								; CODE XREF: sub_20409A+F2↑j
			btst	#7,(byte_FFF788).w
			bne.w	loc_204264
			btst	#6,(byte_FFF788).w
			bne.w	loc_20428C
			btst	#1,(word_FFF602).w
			bne.w	loc_20428C
			andi.b	#$F,(byte_FFF788).w
			beq.s	loc_2041D0
			btst	#0,(word_FFF602+1).w
			beq.s	loc_2041E4
			bset	#7,(byte_FFF788).w
			bra.w	loc_204354
; ---------------------------------------------------------------------------
loc_2041D0:								; CODE XREF: sub_20409A+122↑j
			btst	#0,(word_FFF602+1).w
			beq.w	loc_2041E4
			move.b	#1,(byte_FFF788).w
			bra.w	loc_204354
; ---------------------------------------------------------------------------
loc_2041E4:								; CODE XREF: sub_20409A+E6↑j
										; sub_20409A+12A↑j ...
			btst	#0,(word_FFF602).w
			beq.s	loc_204224
			move.b	#7,obj.ani(a0)
			tst.b	obj.field_2A(a0)
			beq.s	loc_204210
			move.b	#0,obj.ani(a0)
			moveq	#$19,d0
			btst	#0,obj.status(a0)
			beq.s	loc_20420A
			neg.w	d0
loc_20420A:								; CODE XREF: sub_20409A+16C↑j
			add.w	d0,obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_204210:								; CODE XREF: sub_20409A+15C↑j
			move.b	(word_FFF602+1).w,d0
			andi.b	#$70,d0
			beq.s	loc_204220
			move.b	#1,obj.field_2A(a0)
loc_204220:								; CODE XREF: sub_20409A+17E↑j
			bra.w	loc_204354
; ---------------------------------------------------------------------------
loc_204224:								; CODE XREF: sub_20409A+150↑j
			cmpi.b	#$3C,obj.field_2A(a0)
			beq.s	loc_20423A
			move.b	#0,obj.field_2A(a0)
			move.w	#0,obj.inertia(a0)
			bra.s	loc_20428C
; ---------------------------------------------------------------------------
loc_20423A:								; CODE XREF: sub_20409A+190↑j
			move.b	#$3D,obj.field_2A(a0)
			move.w	(word_FFF760).w,d6
			move.w	(word_FFF762).w,d5
			move.w	(word_FFF764).w,d4
			btst	#0,obj.status(a0)
			bne.s	loc_20425C
			bsr.w	sub_204498
			bra.w	loc_204330
; ---------------------------------------------------------------------------
loc_20425C:								; CODE XREF: sub_20409A+1B8↑j
			bsr.w	sub_204410
			bra.w	loc_204330
; ---------------------------------------------------------------------------
loc_204264:								; CODE XREF: sub_20409A+104↑j
			btst	#0,(word_FFF602).w
			beq.s	loc_20428C
			move.b	#7,obj.ani(a0)
			tst.b	obj.field_29(a0)
			beq.w	loc_20430E
			cmpi.w	#200,(word_FFF73E).w
			beq.w	loc_204354
			addq.w	#2,(word_FFF73E).w
			bra.w	loc_204354
; ---------------------------------------------------------------------------
loc_20428C:								; CODE XREF: sub_20409A+10E↑j
										; sub_20409A+118↑j ...
			tst.b	obj.field_29(a0)
			beq.s	loc_2042C8
			btst	#6,(byte_FFF788).w
			bne.w	loc_20430E
			andi.b	#$F,(byte_FFF788).w
			beq.s	loc_2042B6
			btst	#1,(word_FFF602+1).w
			beq.s	loc_2042C8
			bset	#6,(byte_FFF788).w
			bra.w	loc_204354
; ---------------------------------------------------------------------------
loc_2042B6:								; CODE XREF: sub_20409A+208↑j
			btst	#1,(word_FFF602+1).w
			beq.s	loc_2042C8
			move.b	#1,(byte_FFF788).w
			bra.w	loc_204354
; ---------------------------------------------------------------------------
loc_2042C8:								; CODE XREF: sub_20409A+1F6↑j
										; sub_20409A+210↑j ...
			btst	#1,(word_FFF602).w
			beq.s	loc_204330
			move.b	#8,obj.ani(a0)
			tst.b	obj.field_2A(a0)
			bne.s	loc_20430C
			move.b	(word_FFF602+1).w,d0
			andi.b	#$70,d0
			beq.s	loc_20430C
			move.b	#1,obj.field_2A(a0)
			move.w	#$16,obj.inertia(a0)
			btst	#0,obj.status(a0)
			beq.s	loc_2042FE
			neg.w	obj.inertia(a0)
loc_2042FE:								; CODE XREF: sub_20409A+25E↑j
			move.w	#$9C,d0
			jsr	(queuesound2).l
			bsr.w	sub_204804
loc_20430C:								; CODE XREF: sub_20409A+240↑j
										; sub_20409A+24A↑j
			bra.s	loc_204354
; ---------------------------------------------------------------------------
loc_20430E:								; CODE XREF: sub_20409A+1DC↑j
										; sub_20409A+1FE↑j
			btst	#1,(word_FFF602).w
			beq.s	loc_204330
			move.b	#8,obj.ani(a0)
			tst.b	obj.field_29(a0)
			beq.s	loc_204354
			cmpi.w	#8,(word_FFF73E).w
			beq.s	loc_204354
			subq.w	#2,(word_FFF73E).w
			bra.s	loc_204354
; ---------------------------------------------------------------------------
loc_204330:								; CODE XREF: sub_20409A+18↑j
										; sub_20409A+40↑j ...
			cmpi.w	#$60,(word_FFF73E).w
			bne.s	loc_20434A
			move.b	(byte_FFF788).w,d0
			andi.b	#$F,d0
			bne.s	loc_204354
			move.b	#0,(byte_FFF788).w
			bra.s	loc_204354
; ---------------------------------------------------------------------------
loc_20434A:								; CODE XREF: sub_20409A+29C↑j
			bcc.s	loc_204350
			addq.w	#4,(word_FFF73E).w
loc_204350:								; CODE XREF: sub_20409A:loc_20434A↑j
			subq.w	#2,(word_FFF73E).w
loc_204354:								; CODE XREF: sub_20409A+132↑j
										; sub_20409A+146↑j ...
			move.b	(word_FFF602).w,d0
			andi.b	#$C,d0
			bne.s	loc_204380
			move.w	obj.inertia(a0),d0
			beq.s	loc_204380
			bmi.s	loc_204374
			sub.w	d5,d0
			bcc.s	loc_20436E
			move.w	#0,d0
loc_20436E:								; CODE XREF: sub_20409A+2CE↑j
			move.w	d0,obj.inertia(a0)
			bra.s	loc_204380
; ---------------------------------------------------------------------------
loc_204374:								; CODE XREF: sub_20409A+2CA↑j
			add.w	d5,d0
			bcc.s	loc_20437C
			move.w	#0,d0
loc_20437C:								; CODE XREF: sub_20409A+2DC↑j
			move.w	d0,obj.inertia(a0)
loc_204380:								; CODE XREF: sub_20409A+10↑j
										; sub_20409A+2C2↑j ...
			move.b	obj.angle(a0),d0
			jsr	(calcsine).l
			muls.w	obj.inertia(a0),d1
			asr.l	#8,d1
			move.w	d1,obj.xvel(a0)
			muls.w	obj.inertia(a0),d0
			asr.l	#8,d0
			move.w	d0,obj.yvel(a0)
loc_20439E:								; CODE XREF: sub_20451A+158↓j
			move.b	obj.angle(a0),d0
			addi.b	#$40,d0
			bmi.s	locret_20440E
			move.b	#$40,d1
			tst.w	obj.inertia(a0)
			beq.s	locret_20440E
			bmi.s	loc_2043B6
			neg.w	d1
loc_2043B6:								; CODE XREF: sub_20409A+318↑j
			move.b	obj.angle(a0),d0
			add.b	d1,d0
			move.w	d0,-(sp)
			bsr.w	sub_205FDC
			move.w	(sp)+,d0
			tst.w	d1
			bpl.s	locret_20440E
			asl.w	#8,d1
			addi.b	#$20,d0
			andi.b	#$C0,d0
			beq.s	loc_20440A
			cmpi.b	#$40,d0
			beq.s	loc_2043F8
			cmpi.b	#$80,d0
			beq.s	loc_2043F2
			add.w	d1,obj.xvel(a0)
			bset	#5,obj.status(a0)
			move.w	#0,obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_2043F2:								; CODE XREF: sub_20409A+344↑j
			sub.w	d1,obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_2043F8:								; CODE XREF: sub_20409A+33E↑j
			sub.w	d1,obj.xvel(a0)
			bset	#5,obj.status(a0)
			move.w	#0,obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_20440A:								; CODE XREF: sub_20409A+338↑j
			add.w	d1,obj.yvel(a0)
locret_20440E:							; CODE XREF: sub_20409A+30C↑j
										; sub_20409A+316↑j ...
			rts
; End of function sub_20409A
; =============== S U B R O U T I N E =======================================
sub_204410:								; CODE XREF: sub_20409A+24↑p
										; sub_20409A:loc_20425C↑p
			move.w	obj.inertia(a0),d0
			beq.s	loc_204418
			bpl.s	loc_204460
loc_204418:								; CODE XREF: sub_204410+4↑j
			tst.b	obj.field_2A(a0)
			beq.s	loc_204434
			cmpi.b	#$3D,obj.field_2A(a0)
			bne.s	locret_204496
			bset	#2,(word_FFF602).w
			lsl.w	#7,d5
			move.b	#0,obj.field_2A(a0)
loc_204434:								; CODE XREF: sub_204410+C↑j
			bset	#0,obj.status(a0)
			bne.s	loc_204448
			bclr	#5,obj.status(a0)
			move.b	#1,obj.prevani(a0)
loc_204448:								; CODE XREF: sub_204410+2A↑j
			sub.w	d5,d0
			move.w	d6,d1
			neg.w	d1
			cmp.w	d1,d0
			bgt.s	loc_204454
			move.w	d1,d0
loc_204454:								; CODE XREF: sub_204410+40↑j
			move.w	d0,obj.inertia(a0)
			move.b	#0,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_204460:								; CODE XREF: sub_204410+6↑j
			sub.w	d4,d0
			bcc.s	loc_204468
			move.w	#-$80,d0
loc_204468:								; CODE XREF: sub_204410+52↑j
			move.w	d0,obj.inertia(a0)
			move.b	obj.angle(a0),d0
			addi.b	#$20,d0
			andi.b	#$C0,d0
			bne.s	locret_204496
			cmpi.w	#$400,d0
			blt.s	locret_204496
			move.b	#$D,obj.ani(a0)
			bclr	#0,obj.status(a0)
			move.w	#$90,d0
			jsr	(queuesound2).l
locret_204496:							; CODE XREF: sub_204410+14↑j
										; sub_204410+68↑j ...
			rts
; End of function sub_204410
; =============== S U B R O U T I N E =======================================
sub_204498:								; CODE XREF: sub_20409A+30↑p
										; sub_20409A+1BA↑p
			move.w	obj.inertia(a0),d0
			bmi.s	loc_2044E2
			tst.b	obj.field_2A(a0)
			beq.s	loc_2044BA
			cmpi.b	#$3D,obj.field_2A(a0)
			bne.s	locret_204518
			bset	#3,(word_FFF602).w
			lsl.w	#7,d5
			move.b	#0,obj.field_2A(a0)
loc_2044BA:								; CODE XREF: sub_204498+A↑j
			bclr	#0,obj.status(a0)
			beq.s	loc_2044CE
			bclr	#5,obj.status(a0)
			move.b	#1,obj.prevani(a0)
loc_2044CE:								; CODE XREF: sub_204498+28↑j
			add.w	d5,d0
			cmp.w	d6,d0
			blt.s	loc_2044D6
			move.w	d6,d0
loc_2044D6:								; CODE XREF: sub_204498+3A↑j
			move.w	d0,obj.inertia(a0)
			move.b	#0,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_2044E2:								; CODE XREF: sub_204498+4↑j
			add.w	d4,d0
			bcc.s	loc_2044EA
			move.w	#$80,d0
loc_2044EA:								; CODE XREF: sub_204498+4C↑j
			move.w	d0,obj.inertia(a0)
			move.b	obj.angle(a0),d0
			addi.b	#$20,d0
			andi.b	#$C0,d0
			bne.s	locret_204518
			cmpi.w	#-$400,d0
			bgt.s	locret_204518
			move.b	#$D,obj.ani(a0)
			bset	#0,obj.status(a0)
			move.w	#$90,d0
			jsr	(queuesound2).l
locret_204518:							; CODE XREF: sub_204498+12↑j
										; sub_204498+62↑j ...
			rts
; End of function sub_204498
; =============== S U B R O U T I N E =======================================
sub_20451A:								; CODE XREF: ROM:00204054↑p
			move.w	(word_FFF760).w,d6
			asl.w	#1,d6
			move.w	(word_FFF762).w,d5
			asr.w	#1,d5
			move.w	(word_FFF764).w,d4
			asr.w	#2,d4
			tst.b	(byte_FFF7CA).w
			bne.w	loc_204640
			tst.w	obj.field_3E(a0)
			bne.s	loc_204552
			btst	#2,(word_FFF602).w
			beq.s	loc_204546
			bsr.w	sub_204676
loc_204546:								; CODE XREF: sub_20451A+26↑j
			btst	#3,(word_FFF602).w
			beq.s	loc_204552
			bsr.w	sub_20469A
loc_204552:								; CODE XREF: sub_20451A+1E↑j
										; sub_20451A+32↑j
			tst.b	obj.field_2A(a0)
			beq.w	loc_2045E8
			move.w	#$19,d0
			move.w	(word_FFF760).w,d1
			asl.w	#1,d1
			btst	#0,obj.status(a0)
			beq.s	loc_204570
			neg.w	d0
			neg.w	d1
loc_204570:								; CODE XREF: sub_20451A+50↑j
			add.w	d0,obj.inertia(a0)
			move.w	obj.inertia(a0),d0
			cmp.w	d1,d0
			bgt.s	loc_20457E
			move.w	d1,d0
loc_20457E:								; CODE XREF: sub_20451A+60↑j
			move.w	d0,obj.inertia(a0)
			btst	#1,(word_FFF602).w
			beq.s	loc_2045BA
			move.b	(word_FFF602+1).w,d0
			andi.b	#$70,d0
			beq.s	locret_2045E6
loc_204594:								; CODE XREF: sub_20451A+A6↓j
			move.w	#$AB,d0
			jsr	(queuesound2).l
			move.b	#0,obj.field_2A(a0)
			move.w	#0,obj.inertia(a0)
			move.w	#0,obj.xvel(a0)
			move.w	#0,obj.yvel(a0)
			bra.w	loc_204610
; ---------------------------------------------------------------------------
loc_2045BA:								; CODE XREF: sub_20451A+6E↑j
			cmpi.b	#$3C,obj.field_2A(a0)
			bne.s	loc_204594
			move.b	#0,obj.field_2A(a0)
			move.w	#$91,d0
			jsr	(queuesound2).l
			btst	#0,obj.status(a0)
			bne.s	loc_2045E0
			bsr.w	sub_20469A
			bra.s	loc_2045E8
; ---------------------------------------------------------------------------
loc_2045E0:								; CODE XREF: sub_20451A+BE↑j
			bsr.w	sub_204676
			bra.s	loc_2045E8
; ---------------------------------------------------------------------------
locret_2045E6:							; CODE XREF: sub_20451A+78↑j
			rts
; ---------------------------------------------------------------------------
loc_2045E8:								; CODE XREF: sub_20451A+3C↑j
										; sub_20451A+C4↑j ...
			move.w	obj.inertia(a0),d0
			beq.s	loc_20460A
			bmi.s	loc_2045FE
			sub.w	d5,d0
			bcc.s	loc_2045F8
			move.w	#0,d0
loc_2045F8:								; CODE XREF: sub_20451A+D8↑j
			move.w	d0,obj.inertia(a0)
			bra.s	loc_20460A
; ---------------------------------------------------------------------------
loc_2045FE:								; CODE XREF: sub_20451A+D4↑j
			add.w	d5,d0
			bcc.s	loc_204606
			move.w	#0,d0
loc_204606:								; CODE XREF: sub_20451A+E6↑j
			move.w	d0,obj.inertia(a0)
loc_20460A:								; CODE XREF: sub_20451A+D2↑j
										; sub_20451A+E2↑j
			tst.w	obj.inertia(a0)
			bne.s	loc_204640
loc_204610:								; CODE XREF: sub_20451A+9C↑j
			bclr	#2,obj.status(a0)
			tst.b	(miniplay_flag).w
			beq.s	loc_20462A
			move.b	#$A,obj.field_16(a0)
			move.b	#5,obj.field_17(a0)
			bra.s	loc_20463A
; ---------------------------------------------------------------------------
loc_20462A:								; CODE XREF: sub_20451A+100↑j
			move.b	#$13,obj.field_16(a0)
			move.b	#9,obj.field_17(a0)
			subq.w	#5,obj.ypos(a0)
loc_20463A:								; CODE XREF: sub_20451A+10E↑j
			move.b	#5,obj.ani(a0)
loc_204640:								; CODE XREF: sub_20451A+16↑j
										; sub_20451A+F4↑j
			move.b	obj.angle(a0),d0
			jsr	(calcsine).l
			muls.w	obj.inertia(a0),d0
			asr.l	#8,d0
			move.w	d0,obj.yvel(a0)
			muls.w	obj.inertia(a0),d1
			asr.l	#8,d1
			cmpi.w	#$1000,d1
			ble.s	loc_204664
			move.w	#$1000,d1
loc_204664:								; CODE XREF: sub_20451A+144↑j
			cmpi.w	#-$1000,d1
			bge.s	loc_20466E
			move.w	#-$1000,d1
loc_20466E:								; CODE XREF: sub_20451A+14E↑j
			move.w	d1,obj.xvel(a0)
			bra.w	loc_20439E
; End of function sub_20451A
; =============== S U B R O U T I N E =======================================
sub_204676:								; CODE XREF: sub_20451A+28↑p
										; sub_20451A:loc_2045E0↑p
			move.w	obj.inertia(a0),d0
			beq.s	loc_20467E
			bpl.s	loc_20468C
loc_20467E:								; CODE XREF: sub_204676+4↑j
			bset	#0,obj.status(a0)
			move.b	#2,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_20468C:								; CODE XREF: sub_204676+6↑j
			sub.w	d4,d0
			bcc.s	loc_204694
			move.w	#-$80,d0
loc_204694:								; CODE XREF: sub_204676+18↑j
			move.w	d0,obj.inertia(a0)
			rts
; End of function sub_204676
; =============== S U B R O U T I N E =======================================
sub_20469A:								; CODE XREF: sub_20451A+34↑p
										; sub_20451A+C0↑p
			move.w	obj.inertia(a0),d0
			bmi.s	loc_2046AE
			bclr	#0,obj.status(a0)
			move.b	#2,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_2046AE:								; CODE XREF: sub_20469A+4↑j
			add.w	d4,d0
			bcc.s	loc_2046B6
			move.w	#$80,d0
loc_2046B6:								; CODE XREF: sub_20469A+16↑j
			move.w	d0,obj.inertia(a0)
			rts
; End of function sub_20469A
; =============== S U B R O U T I N E =======================================
sub_2046BC:								; CODE XREF: ROM:00204022↑p
										; ROM:00204074↑p
			move.w	(word_FFF760).w,d6
			move.w	(word_FFF762).w,d5
			asl.w	#1,d5
			btst	#4,obj.status(a0)
			bne.s	loc_204706
			move.w	obj.xvel(a0),d0
			btst	#2,(word_FFF602).w
			beq.s	loc_2046EC
			bset	#0,obj.status(a0)
			sub.w	d5,d0
			move.w	d6,d1
			neg.w	d1
			cmp.w	d1,d0
			bgt.s	loc_2046EC
			move.w	d1,d0
loc_2046EC:								; CODE XREF: sub_2046BC+1C↑j
										; sub_2046BC+2C↑j
			btst	#3,(word_FFF602).w
			beq.s	loc_204702
			bclr	#0,obj.status(a0)
			add.w	d5,d0
			cmp.w	d6,d0
			blt.s	loc_204702
			move.w	d6,d0
loc_204702:								; CODE XREF: sub_2046BC+36↑j
										; sub_2046BC+42↑j
			move.w	d0,obj.xvel(a0)
loc_204706:								; CODE XREF: sub_2046BC+10↑j
			tst.b	obj.field_29(a0)
			beq.s	loc_20471E
			cmpi.w	#$60,(word_FFF73E).w
			beq.s	loc_20471E
			bcc.s	loc_20471A
			addq.w	#4,(word_FFF73E).w
loc_20471A:								; CODE XREF: sub_2046BC+58↑j
			subq.w	#2,(word_FFF73E).w
loc_20471E:								; CODE XREF: sub_2046BC+4E↑j
										; sub_2046BC+56↑j
			cmpi.w	#-$400,obj.yvel(a0)
			bcs.s	locret_20474C
			move.w	obj.xvel(a0),d0
			move.w	d0,d1
			asr.w	#5,d1
			beq.s	locret_20474C
			bmi.s	loc_204740
			sub.w	d1,d0
			bcc.s	loc_20473A
			move.w	#0,d0
loc_20473A:								; CODE XREF: sub_2046BC+78↑j
			move.w	d0,obj.xvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_204740:								; CODE XREF: sub_2046BC+74↑j
			sub.w	d1,d0
			bcs.s	loc_204748
			move.w	#0,d0
loc_204748:								; CODE XREF: sub_2046BC+86↑j
			move.w	d0,obj.xvel(a0)
locret_20474C:							; CODE XREF: sub_2046BC+68↑j
										; sub_2046BC+72↑j
			rts
; End of function sub_2046BC
; ---------------------------------------------------------------------------
			move.b	obj.angle(a0),d0
			addi.b	#$20,d0
			andi.b	#$C0,d0
			bne.s	locret_20477C
			bsr.w	sub_206216
			tst.w	d1
			bpl.s	locret_20477C
			move.w	#0,obj.inertia(a0)
			move.w	#0,obj.xvel(a0)
			move.w	#0,obj.yvel(a0)
			move.b	#$B,obj.ani(a0)
locret_20477C:							; CODE XREF: ROM:0020475A↑j
										; ROM:00204762↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_20477E:								; CODE XREF: ROM:loc_203FE8↑p
										; ROM:00204006↑p ...
			move.l	obj.xpos(a0),d1
			move.w	obj.xvel(a0),d0
			ext.l	d0
			asl.l	#8,d0
			add.l	d0,d1
			swap	d1
			move.w	(dword_FFF728).w,d0
			addi.w	#$10,d0
			cmp.w	d1,d0
			bhi.s	loc_2047C4
			move.w	(dword_FFF728+2).w,d0
			addi.w	#$128,d0
			tst.b	(byte_FFF7AA).w
			bne.s	loc_2047AC
			addi.w	#$40,d0
loc_2047AC:								; CODE XREF: sub_20477E+28↑j
			cmp.w	d1,d0
			bls.s	loc_2047C4
loc_2047B0:								; CODE XREF: sub_20477E+5C↓j
			move.w	(dword_FFF72C+2).w,d0
			addi.w	#224,d0
			cmp.w	obj.ypos(a0),d0
			blt.s	loc_2047C0
			rts
; ---------------------------------------------------------------------------
loc_2047C0:								; CODE XREF: sub_20477E+3E↑j
			bra.w	loc_206668
; ---------------------------------------------------------------------------
loc_2047C4:								; CODE XREF: sub_20477E+1A↑j
										; sub_20477E+30↑j
			move.w	d0,obj.xpos(a0)
			move.w	#0,obj.scrypos(a0)
			move.w	#0,obj.xvel(a0)
			move.w	#0,obj.inertia(a0)
			bra.s	loc_2047B0
; End of function sub_20477E
; =============== S U B R O U T I N E =======================================
sub_2047DC:								; CODE XREF: ROM:00204002↑p
			tst.b	(byte_FFF7CA).w
			bne.s	locret_204802
			move.w	obj.inertia(a0),d0
			bpl.s	loc_2047EA
			neg.w	d0
loc_2047EA:								; CODE XREF: sub_2047DC+A↑j
			cmpi.w	#$80,d0
			bcs.s	locret_204802
			move.b	(word_FFF602).w,d0
			andi.b	#$C,d0
			bne.s	locret_204802
			btst	#1,(word_FFF602).w
			bne.s	sub_204804
locret_204802:							; CODE XREF: sub_2047DC+4↑j
										; sub_2047DC+12↑j ...
			rts
; End of function sub_2047DC
; =============== S U B R O U T I N E =======================================
sub_204804:								; CODE XREF: sub_20409A+26E↑p
										; sub_2047DC+24↑j ...
			btst	#2,obj.status(a0)
			beq.s	loc_20480E
			rts
; ---------------------------------------------------------------------------
loc_20480E:								; CODE XREF: sub_204804+6↑j
			bset	#2,obj.status(a0)
			tst.b	(miniplay_flag).w
			beq.s	loc_204828
			move.b	#$A,obj.field_16(a0)
			move.b	#5,obj.field_17(a0)
			bra.s	loc_204838
; ---------------------------------------------------------------------------
loc_204828:								; CODE XREF: sub_204804+14↑j
			move.b	#$E,obj.field_16(a0)
			move.b	#7,obj.field_17(a0)
			addq.w	#5,obj.ypos(a0)
loc_204838:								; CODE XREF: sub_204804+22↑j
			move.b	#2,obj.ani(a0)
			tst.w	obj.inertia(a0)
			bne.s	locret_20484A
			move.w	#$200,obj.inertia(a0)
locret_20484A:							; CODE XREF: sub_204804+3E↑j
			rts
; End of function sub_204804
; =============== S U B R O U T I N E =======================================
sub_20484C:								; CODE XREF: ROM:00203FF6↑p
										; ROM:0020404C↑p
			tst.b	obj.field_2A(a0)
			beq.s	loc_204876
			move.b	(word_FFF602+1).w,d0
			andi.b	#$70,d0
			beq.s	loc_204876
			move.b	#0,obj.field_2A(a0)
			move.w	#0,obj.inertia(a0)
			move.w	#0,obj.xvel(a0)
			move.w	#0,obj.yvel(a0)
			bra.s	loc_204888
; ---------------------------------------------------------------------------
loc_204876:								; CODE XREF: sub_20484C+4↑j
										; sub_20484C+E↑j
			move.b	(word_FFF602).w,d0
			andi.b	#3,d0
			beq.s	loc_204888
			tst.w	obj.inertia(a0)
			beq.w	locret_204964
loc_204888:								; CODE XREF: sub_20484C+28↑j
										; sub_20484C+32↑j
			move.b	(word_FFF602+1).w,d0
			andi.b	#$70,d0
			beq.w	locret_204964
			btst	#3,obj.status(a0)
			beq.s	loc_2048A4
			jsr	(sub_205394).l
			beq.s	loc_2048D4
loc_2048A4:								; CODE XREF: sub_20484C+4E↑j
			moveq	#0,d0
			move.b	obj.angle(a0),d0
			addi.b	#$80,d0
			bsr.w	sub_206046
			cmpi.w	#6,d1
			blt.w	locret_204964
			move.w	#$680,d2
			btst	#6,obj.status(a0)
			beq.s	loc_2048CA
			move.w	#$380,d2
loc_2048CA:								; CODE XREF: sub_20484C+78↑j
			moveq	#0,d0
			move.b	obj.angle(a0),d0
			subi.b	#$40,d0
loc_2048D4:								; CODE XREF: sub_20484C+56↑j
			jsr	(calcsine).l
			muls.w	d2,d1
			asr.l	#8,d1
			add.w	d1,obj.xvel(a0)
			muls.w	d2,d0
			asr.l	#8,d0
			add.w	d0,obj.yvel(a0)
			bset	#1,obj.status(a0)
			bclr	#5,obj.status(a0)
			addq.l	#4,sp
			move.b	#1,obj.field_3C(a0)
			clr.b	obj.field_38(a0)
			move.w	#$92,d0
			jsr	(queuesound2).l
			tst.b	(miniplay_flag).w
			beq.s	loc_204920
			move.b	#$A,obj.field_16(a0)
			move.b	#5,obj.field_17(a0)
			bra.s	loc_20492C
; ---------------------------------------------------------------------------
loc_204920:								; CODE XREF: sub_20484C+C4↑j
			move.b	#$13,obj.field_16(a0)
			move.b	#9,obj.field_17(a0)
loc_20492C:								; CODE XREF: sub_20484C+D2↑j
			btst	#2,obj.status(a0)
			bne.s	loc_204966
			tst.b	(miniplay_flag).w
			beq.s	loc_204948
			move.b	#$A,obj.field_16(a0)
			move.b	#5,obj.field_17(a0)
			bra.s	loc_204958
; ---------------------------------------------------------------------------
loc_204948:								; CODE XREF: sub_20484C+EC↑j
			move.b	#$E,obj.field_16(a0)
			move.b	#7,obj.field_17(a0)
			addq.w	#5,obj.ypos(a0)
loc_204958:								; CODE XREF: sub_20484C+FA↑j
			bset	#2,obj.status(a0)
			move.b	#2,obj.ani(a0)
locret_204964:							; CODE XREF: sub_20484C+38↑j
										; sub_20484C+44↑j ...
			rts
; ---------------------------------------------------------------------------
loc_204966:								; CODE XREF: sub_20484C+E6↑j
			bset	#4,obj.status(a0)
			rts
; End of function sub_20484C
; =============== S U B R O U T I N E =======================================
sub_20496E:								; CODE XREF: ROM:0020401E↑p
										; ROM:00204070↑p
			tst.b	obj.field_3C(a0)
			beq.s	loc_2049A0
			move.w	#-$400,d1
			btst	#6,obj.status(a0)
			beq.s	loc_204984
			move.w	#-$200,d1
loc_204984:								; CODE XREF: sub_20496E+10↑j
			cmp.w	obj.yvel(a0),d1
			ble.s	locret_20499E
			move.b	(word_FFF602).w,d0
			andi.b	#$70,d0
			bne.s	locret_20499E
			move.b	#0,obj.field_2A(a0)
			move.w	d1,obj.yvel(a0)
locret_20499E:							; CODE XREF: sub_20496E+1A↑j
										; sub_20496E+24↑j
			rts
; ---------------------------------------------------------------------------
loc_2049A0:								; CODE XREF: sub_20496E+4↑j
			cmpi.w	#-$FC0,obj.yvel(a0)
			bge.s	locret_2049AE
			move.w	#-$FC0,obj.yvel(a0)
locret_2049AE:							; CODE XREF: sub_20496E+38↑j
			rts
; End of function sub_20496E
; =============== S U B R O U T I N E =======================================
sub_2049B0:								; CODE XREF: ROM:00203FFA↑p
			tst.b	obj.field_2A(a0)
			bne.s	locret_2049EA
			move.b	obj.angle(a0),d0
			addi.b	#$60,d0
			cmpi.b	#$C0,d0
			bcc.s	locret_2049EA
			move.b	obj.angle(a0),d0
			jsr	(calcsine).l
			muls.w	#$20,d0
			asr.l	#8,d0
			tst.w	obj.inertia(a0)
			beq.s	locret_2049EA
			bmi.s	loc_2049E6
			tst.w	d0
			beq.s	locret_2049E4
			add.w	d0,obj.inertia(a0)
locret_2049E4:							; CODE XREF: sub_2049B0+2E↑j
			rts
; ---------------------------------------------------------------------------
loc_2049E6:								; CODE XREF: sub_2049B0+2A↑j
			add.w	d0,obj.inertia(a0)
locret_2049EA:							; CODE XREF: sub_2049B0+4↑j
										; sub_2049B0+12↑j ...
			rts
; End of function sub_2049B0
; =============== S U B R O U T I N E =======================================
sub_2049EC:								; CODE XREF: ROM:00204050↑p
			tst.b	obj.field_2A(a0)
			bne.s	locret_204A2C
			move.b	obj.angle(a0),d0
			addi.b	#$60,d0
			cmpi.b	#$C0,d0
			bcc.s	locret_204A2C
			move.b	obj.angle(a0),d0
			jsr	(calcsine).l
			muls.w	#$50,d0
			asr.l	#8,d0
			tst.w	obj.inertia(a0)
			bmi.s	loc_204A22
			tst.w	d0
			bpl.s	loc_204A1C
			asr.l	#2,d0
loc_204A1C:								; CODE XREF: sub_2049EC+2C↑j
			add.w	d0,obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_204A22:								; CODE XREF: sub_2049EC+28↑j
			tst.w	d0
			bmi.s	loc_204A28
			asr.l	#2,d0
loc_204A28:								; CODE XREF: sub_2049EC+38↑j
			add.w	d0,obj.inertia(a0)
locret_204A2C:							; CODE XREF: sub_2049EC+4↑j
										; sub_2049EC+12↑j
			rts
; End of function sub_2049EC
; =============== S U B R O U T I N E =======================================
sub_204A2E:								; CODE XREF: ROM:00204014↑p
										; ROM:00204066↑p
			nop
			tst.b	obj.field_38(a0)
			bne.s	locret_204A68
			tst.w	obj.field_3E(a0)
			bne.s	loc_204A6A
			move.b	obj.angle(a0),d0
			addi.b	#$20,d0
			andi.b	#$C0,d0
			beq.s	locret_204A68
			move.w	obj.inertia(a0),d0
			bpl.s	loc_204A52
			neg.w	d0
loc_204A52:								; CODE XREF: sub_204A2E+20↑j
			cmpi.w	#$280,d0
			bcc.s	locret_204A68
			clr.w	obj.inertia(a0)
			bset	#1,obj.status(a0)
			move.w	#30,obj.field_3E(a0)
locret_204A68:							; CODE XREF: sub_204A2E+6↑j
										; sub_204A2E+1A↑j ...
			rts
; ---------------------------------------------------------------------------
loc_204A6A:								; CODE XREF: sub_204A2E+C↑j
			subq.w	#1,obj.field_3E(a0)
			rts
; End of function sub_204A2E
; =============== S U B R O U T I N E =======================================
sub_204A70:								; CODE XREF: ROM:loc_20403E↑p
										; ROM:loc_204090↑p
			move.b	obj.angle(a0),d0
			beq.s	locret_204A8A
			bpl.s	loc_204A80
			addq.b	#2,d0
			bcc.s	loc_204A7E
			moveq	#0,d0
loc_204A7E:								; CODE XREF: sub_204A70+A↑j
			bra.s	loc_204A86
; ---------------------------------------------------------------------------
loc_204A80:								; CODE XREF: sub_204A70+6↑j
			subq.b	#2,d0
			bcc.s	loc_204A86
			moveq	#0,d0
loc_204A86:								; CODE XREF: sub_204A70:loc_204A7E↑j
										; sub_204A70+12↑j
			move.b	d0,obj.angle(a0)
locret_204A8A:							; CODE XREF: sub_204A70+4↑j
			rts
; End of function sub_204A70
; =============== S U B R O U T I N E =======================================
sub_204A8C:								; CODE XREF: ROM:00204042↑p
										; ROM:00204094↑p ...
			move.w	obj.xvel(a0),d1
			move.w	obj.yvel(a0),d2
			jsr	(calcangle).l
			move.b	d0,(byte_FF13EC).l
			subi.b	#$20,d0
			move.b	d0,(byte_FF13ED).l
			andi.b	#$C0,d0
			move.b	d0,(byte_FF13EE).l
			cmpi.b	#$40,d0
			beq.w	loc_204B70
			cmpi.b	#$80,d0
			beq.w	loc_204BD2
			cmpi.b	#$C0,d0
			beq.w	loc_204C2E
			bsr.w	sub_20635C
			tst.w	d1
			bpl.s	loc_204ADE
			sub.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
loc_204ADE:								; CODE XREF: sub_204A8C+46↑j
			bsr.w	sub_2061BE
			tst.w	d1
			bpl.s	loc_204AF0
			add.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
loc_204AF0:								; CODE XREF: sub_204A8C+58↑j
			bsr.w	loc_20606E
			move.b	d1,(byte_FF13EF).l
			tst.w	d1
			bpl.s	locret_204B6E
			move.b	obj.yvel(a0),d2
			addq.b	#8,d2
			neg.b	d2
			cmp.b	d2,d1
			bge.s	loc_204B0E
			cmp.b	d2,d0
			blt.s	locret_204B6E
loc_204B0E:								; CODE XREF: sub_204A8C+7C↑j
			add.w	d1,obj.ypos(a0)
			move.b	d3,obj.angle(a0)
			bsr.w	sub_204C90
			move.b	#0,obj.ani(a0)
			move.b	d3,d0
			addi.b	#$20,d0
			andi.b	#$40,d0
			bne.s	loc_204B4C
			move.b	d3,d0
			addi.b	#$10,d0
			andi.b	#$20,d0
			beq.s	loc_204B3E
			asr.w	obj.yvel(a0)
			bra.s	loc_204B60
; ---------------------------------------------------------------------------
loc_204B3E:								; CODE XREF: sub_204A8C+AA↑j
			move.w	#0,obj.yvel(a0)
			move.w	obj.xvel(a0),obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_204B4C:								; CODE XREF: sub_204A8C+9E↑j
			move.w	#0,obj.xvel(a0)
			cmpi.w	#$FC0,obj.yvel(a0)
			ble.s	loc_204B60
			move.w	#$FC0,obj.yvel(a0)
loc_204B60:								; CODE XREF: sub_204A8C+B0↑j
										; sub_204A8C+CC↑j
			move.w	obj.yvel(a0),obj.inertia(a0)
			tst.b	d3
			bpl.s	locret_204B6E
			neg.w	obj.inertia(a0)
locret_204B6E:							; CODE XREF: sub_204A8C+70↑j
										; sub_204A8C+80↑j ...
			rts
; ---------------------------------------------------------------------------
loc_204B70:								; CODE XREF: sub_204A8C+2C↑j
			bsr.w	sub_20635C
			tst.w	d1
			bpl.s	loc_204B8A
			sub.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
			move.w	obj.yvel(a0),obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_204B8A:								; CODE XREF: sub_204A8C+EA↑j
			bsr.w	sub_206216
			tst.w	d1
			bpl.s	loc_204BA4
			sub.w	d1,obj.ypos(a0)
			tst.w	obj.yvel(a0)
			bpl.s	locret_204BA2
			move.w	#0,obj.yvel(a0)
locret_204BA2:							; CODE XREF: sub_204A8C+10E↑j
			rts
; ---------------------------------------------------------------------------
loc_204BA4:								; CODE XREF: sub_204A8C+104↑j
			tst.w	obj.yvel(a0)
			bmi.s	locret_204BD0
			bsr.w	loc_20606E
			tst.w	d1
			bpl.s	locret_204BD0
			add.w	d1,obj.ypos(a0)
			move.b	d3,obj.angle(a0)
			bsr.w	sub_204C90
			move.b	#0,obj.ani(a0)
			move.w	#0,obj.yvel(a0)
			move.w	obj.xvel(a0),obj.inertia(a0)
locret_204BD0:							; CODE XREF: sub_204A8C+11C↑j
										; sub_204A8C+124↑j
			rts
; ---------------------------------------------------------------------------
loc_204BD2:								; CODE XREF: sub_204A8C+34↑j
			bsr.w	sub_20635C
			tst.w	d1
			bpl.s	loc_204BE4
			sub.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
loc_204BE4:								; CODE XREF: sub_204A8C+14C↑j
			bsr.w	sub_2061BE
			tst.w	d1
			bpl.s	loc_204BF6
			add.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
loc_204BF6:								; CODE XREF: sub_204A8C+15E↑j
			bsr.w	sub_206216
			tst.w	d1
			bpl.s	locret_204C2C
			sub.w	d1,obj.ypos(a0)
			move.b	d3,d0
			addi.b	#$20,d0
			andi.b	#$40,d0
			bne.s	loc_204C16
			move.w	#0,obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_204C16:								; CODE XREF: sub_204A8C+180↑j
			move.b	d3,obj.angle(a0)
			bsr.w	sub_204C90
			move.w	obj.yvel(a0),obj.inertia(a0)
			tst.b	d3
			bpl.s	locret_204C2C
			neg.w	obj.inertia(a0)
locret_204C2C:							; CODE XREF: sub_204A8C+170↑j
										; sub_204A8C+19A↑j
			rts
; ---------------------------------------------------------------------------
loc_204C2E:								; CODE XREF: sub_204A8C+3C↑j
			bsr.w	sub_2061BE
			tst.w	d1
			bpl.s	loc_204C48
			add.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
			move.w	obj.yvel(a0),obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_204C48:								; CODE XREF: sub_204A8C+1A8↑j
			bsr.w	sub_206216
			tst.w	d1
			bpl.s	loc_204C62
			sub.w	d1,obj.ypos(a0)
			tst.w	obj.yvel(a0)
			bpl.s	locret_204C60
			move.w	#0,obj.yvel(a0)
locret_204C60:							; CODE XREF: sub_204A8C+1CC↑j
			rts
; ---------------------------------------------------------------------------
loc_204C62:								; CODE XREF: sub_204A8C+1C2↑j
			tst.w	obj.yvel(a0)
			bmi.s	locret_204C8E
			bsr.w	loc_20606E
			tst.w	d1
			bpl.s	locret_204C8E
			add.w	d1,obj.ypos(a0)
			move.b	d3,obj.angle(a0)
			bsr.w	sub_204C90
			move.b	#0,obj.ani(a0)
			move.w	#0,obj.yvel(a0)
			move.w	obj.xvel(a0),obj.inertia(a0)
locret_204C8E:							; CODE XREF: sub_204A8C+1DA↑j
										; sub_204A8C+1E2↑j
			rts
; End of function sub_204A8C
; =============== S U B R O U T I N E =======================================
sub_204C90:								; CODE XREF: sub_204A8C+8A↑p
										; sub_204A8C+12E↑p ...
			btst	#4,obj.status(a0)
			beq.s	loc_204C9A
			nop
loc_204C9A:								; CODE XREF: sub_204C90+6↑j
			bclr	#5,obj.status(a0)
			bclr	#1,obj.status(a0)
			bclr	#4,obj.status(a0)
			btst	#2,obj.status(a0)
			beq.s	loc_204CE4
			bclr	#2,obj.status(a0)
			tst.b	(miniplay_flag).w
			beq.s	loc_204CCE
			move.b	#$A,obj.field_16(a0)
			move.b	#5,obj.field_17(a0)
			bra.s	loc_204CDE
; ---------------------------------------------------------------------------
loc_204CCE:								; CODE XREF: sub_204C90+2E↑j
			move.b	#$13,obj.field_16(a0)
			move.b	#9,obj.field_17(a0)
			subq.w	#5,obj.ypos(a0)
loc_204CDE:								; CODE XREF: sub_204C90+3C↑j
			move.b	#0,obj.ani(a0)
loc_204CE4:								; CODE XREF: sub_204C90+22↑j
			move.b	#0,obj.field_3C(a0)
			move.w	#0,(word_FFF7D0).w
			rts
; End of function sub_204C90
; ---------------------------------------------------------------------------
loc_204CF2:								; DATA XREF: ROM:0020365A↑o
			jsr	(sub_203166).l
			addi.w	#$30,obj.yvel(a0)
			btst	#6,obj.status(a0)
			beq.s	loc_204D0C
			subi.w	#$20,obj.yvel(a0)
loc_204D0C:								; CODE XREF: ROM:00204D04↑j
			bsr.w	sub_204D22
			bsr.w	sub_20477E
			bsr.w	sub_203E5A
			bsr.w	sub_204EF4
			jmp	(displaysprite).l
; =============== S U B R O U T I N E =======================================
sub_204D22:								; CODE XREF: ROM:loc_204D0C↑p
			move.w	(dword_FFF72C+2).w,d0
			addi.w	#224,d0
			cmp.w	obj.ypos(a0),d0
			bcs.w	loc_206668
			bsr.w	sub_204A8C
			btst	#1,obj.status(a0)
			bne.s	locret_204D5C
			moveq	#0,d0
			move.w	d0,obj.yvel(a0)
			move.w	d0,obj.xvel(a0)
			move.w	d0,obj.inertia(a0)
			move.b	#0,obj.ani(a0)
			subq.b	#2,obj.routine(a0)
			move.w	#120,obj.field_30(a0)
locret_204D5C:							; CODE XREF: sub_204D22+1A↑j
			rts
; End of function sub_204D22
; ---------------------------------------------------------------------------
loc_204D5E:								; DATA XREF: ROM:0020365C↑o
			bsr.w	sub_204D76
			jsr	(sub_20313A).l
			bsr.w	sub_203E5A
			bsr.w	sub_204EF4
			jmp	(displaysprite).l
; =============== S U B R O U T I N E =======================================
sub_204D76:								; CODE XREF: ROM:loc_204D5E↑p
			move.w	(dword_FFF72C+2).w,d0
			addi.w	#$100,d0
			cmp.w	obj.ypos(a0),d0
			bcc.w	locret_204DB8
			move.w	#-$38,obj.yvel(a0)
			addq.b	#2,obj.routine(a0)
			clr.b	(byte_FF121E).l
			addq.b	#1,(byte_FF121C).l
			subq.b	#1,(byte_FF1212).l
loc_204DA2:								; CODE XREF: sub_204D76+40↓j
			move.w	#60,obj.field_3A(a0)
			tst.b	(byte_FF121A).l
			beq.s	locret_204DB8
			move.w	#0,obj.field_3A(a0)
			bra.s	loc_204DA2
; ---------------------------------------------------------------------------
locret_204DB8:							; CODE XREF: sub_204D76+C↑j
										; sub_204D76+38↑j
			rts
; End of function sub_204D76
; ---------------------------------------------------------------------------
loc_204DBA:								; DATA XREF: ROM:0020365E↑o
			tst.w	obj.field_3A(a0)
			beq.s	locret_204E16
			subq.w	#1,obj.field_3A(a0)
			bne.s	locret_204E16
			move.w	#1,(word_FF1202).l
			lea	(byte_FFD040).w,a5
			cmpi.b	#1,obj.id(a0)
			beq.s	loc_204DDE
			lea	(actwk).w,a5
loc_204DDE:								; CODE XREF: ROM:00204DD8↑j
			tst.b	obj.id(a5)
			beq.w	loc_204DFA
			move.w	#0,(word_FF1202).l
			eori.b	#1,(byte_FF1219).l
			bra.w	deleteobj
; ---------------------------------------------------------------------------
loc_204DFA:								; CODE XREF: ROM:00204DE2↑j
			clr.l	(dword_FF1880).l
			move.w	#scpu_fadeCDA,d0
			tst.b	(byte_FF1212).l
			beq.s	loc_204E12
			clr.w	(word_FF12F4).l
loc_204E12:								; CODE XREF: ROM:00204E0A↑j
			bra.w	sub_205404
; ---------------------------------------------------------------------------
locret_204E16:							; CODE XREF: ROM:00204DBE↑j
										; ROM:00204DC4↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_204E18:								; CODE XREF: ROM:loc_203D48↑p
			cmpi.b	#zoneid_SLZ,(zone).l
			beq.s	loc_204E2C
			tst.b	(zone).l
			bne.w	locret_204EE2
loc_204E2C:								; CODE XREF: sub_204E18+8↑j
			move.w	obj.ypos(a0),d0
			lsr.w	#1,d0
			andi.w	#$380,d0
			move.b	obj.xpos(a0),d1
			andi.w	#$7F,d1
			add.w	d1,d0
			lea	(lvllayoutbuffer).w,a1
			move.b	(a1,d0.w),d1
			cmp.b	(dword_FFF7AC+2).w,d1
			bne.s	loc_204E6A
			tst.b	(zone).l
			bne.w	loc_204EE4
			move.w	obj.ypos(a0),d0
			andi.w	#$FF,d0
			cmpi.w	#$90,d0
			bcc.w	loc_204EE4
			bra.s	loc_204E72
; ---------------------------------------------------------------------------
loc_204E6A:								; CODE XREF: sub_204E18+34↑j
			cmp.b	(dword_FFF7AC+3).w,d1
			beq.w	loc_204EE4
loc_204E72:								; CODE XREF: sub_204E18+50↑j
			cmp.b	(dword_FFF7AC).w,d1
			beq.s	loc_204E96
			cmp.b	(dword_FFF7AC+1).w,d1
			beq.s	loc_204E86
			bclr	#6,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_204E86:								; CODE XREF: sub_204E18+64↑j
			btst	#1,obj.status(a0)
			beq.s	loc_204E96
			bclr	#6,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_204E96:								; CODE XREF: sub_204E18+5E↑j
										; sub_204E18+74↑j
			move.w	obj.xpos(a0),d2
			cmpi.b	#$2C,d2
			bcc.s	loc_204EA8
			bclr	#6,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_204EA8:								; CODE XREF: sub_204E18+86↑j
			cmpi.b	#$E0,d2
			bcs.s	loc_204EB6
			bset	#6,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_204EB6:								; CODE XREF: sub_204E18+94↑j
			btst	#6,obj.render(a0)
			bne.s	loc_204ED2
			move.b	obj.angle(a0),d1
			beq.s	locret_204EE2
			cmpi.b	#$80,d1
			bhi.s	locret_204EE2
			bset	#6,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_204ED2:								; CODE XREF: sub_204E18+A4↑j
			move.b	obj.angle(a0),d1
			cmpi.b	#$80,d1
			bls.s	locret_204EE2
			bclr	#6,obj.render(a0)
locret_204EE2:							; CODE XREF: sub_204E18+10↑j
										; sub_204E18+AA↑j ...
			rts
; ---------------------------------------------------------------------------
loc_204EE4:								; CODE XREF: sub_204E18+3C↑j
										; sub_204E18+4C↑j ...
			move.w	#$9C,d0
			jsr	(queuesound2).l
			jmp	(sub_204804).l
; End of function sub_204E18
; =============== S U B R O U T I N E =======================================
sub_204EF4:								; CODE XREF: ROM:loc_203D38↑p
										; ROM:00204D18↑p ...
			lea	(play_ani).l,a1
			moveq	#0,d0
			move.b	obj.ani(a0),d0
			cmp.b	obj.prevani(a0),d0
			beq.s	loc_204F16
			move.b	d0,obj.prevani(a0)
			move.b	#0,obj.field_1B(a0)
			move.b	#0,obj.field_1E(a0)
loc_204F16:								; CODE XREF: sub_204EF4+10↑j
			bsr.w	sub_205132
			add.w	d0,d0
			adda.w	(a1,d0.w),a1
			move.b	(a1),d0
			bmi.s	loc_204F8E
			move.b	obj.status(a0),d1
			andi.b	#1,d1
			andi.b	#$FC,obj.render(a0)
			or.b	d1,obj.render(a0)
			subq.b	#1,obj.field_1E(a0)
			bpl.s	locret_204F5C
			move.b	d0,obj.field_1E(a0)
; End of function sub_204EF4
; =============== S U B R O U T I N E =======================================
sub_204F40:								; CODE XREF: sub_204EF4+118↓p
										; sub_204EF4+16E↓j ...
			moveq	#0,d1
			move.b	obj.field_1B(a0),d1
			move.b	1(a1,d1.w),d0
			beq.s	loc_204F54
			bpl.s	loc_204F54
			cmpi.b	#$FD,d0
			bge.s	loc_204F5E
loc_204F54:								; CODE XREF: sub_204F40+A↑j
										; sub_204F40+C↑j ...
			move.b	d0,obj.frame(a0)
			addq.b	#1,obj.field_1B(a0)
locret_204F5C:							; CODE XREF: sub_204EF4+46↑j
										; sub_204EF4+9E↓j
			rts
; ---------------------------------------------------------------------------
loc_204F5E:								; CODE XREF: sub_204F40+12↑j
			addq.b	#1,d0
			bne.s	loc_204F6E
			move.b	#0,obj.field_1B(a0)
			move.b	1(a1),d0
			bra.s	loc_204F54
; ---------------------------------------------------------------------------
loc_204F6E:								; CODE XREF: sub_204F40+20↑j
			addq.b	#1,d0
			bne.s	loc_204F82
			move.b	2(a1,d1.w),d0
			sub.b	d0,obj.field_1B(a0)
			sub.b	d0,d1
			move.b	1(a1,d1.w),d0
			bra.s	loc_204F54
; ---------------------------------------------------------------------------
loc_204F82:								; CODE XREF: sub_204F40+30↑j
			addq.b	#1,d0
			bne.s	locret_204F8C
			move.b	2(a1,d1.w),obj.ani(a0)
locret_204F8C:							; CODE XREF: sub_204F40+44↑j
			rts
; End of function sub_204F40
; ---------------------------------------------------------------------------
loc_204F8E:								; CODE XREF: sub_204EF4+2E↑j
			subq.b	#1,obj.field_1E(a0)
			bpl.s	locret_204F5C
			addq.b	#1,d0
			bne.w	loc_205016
			tst.b	(miniplay_flag).w
			bne.w	loc_2050BC
			moveq	#0,d1
			move.b	obj.angle(a0),d0
			move.b	obj.status(a0),d2
			andi.b	#1,d2
			bne.s	loc_204FB4
			not.b	d0
loc_204FB4:								; CODE XREF: sub_204EF4+BC↑j
			addi.b	#$10,d0
			bpl.s	loc_204FBC
			moveq	#3,d1
loc_204FBC:								; CODE XREF: sub_204EF4+C4↑j
			andi.b	#$FC,obj.render(a0)
			eor.b	d1,d2
			or.b	d2,obj.render(a0)
			btst	#5,obj.status(a0)
			bne.w	loc_20506A
			lsr.b	#4,d0
			andi.b	#6,d0
			move.w	obj.inertia(a0),d2
			bpl.s	loc_204FE0
			neg.w	d2
loc_204FE0:								; CODE XREF: sub_204EF4+E8↑j
			lea	(unk_2051DE).l,a1
			cmpi.w	#$600,d2
			bcc.s	loc_204FF8
			lea	(unk_2051D6).l,a1
			move.b	d0,d1
			lsr.b	#1,d1
			add.b	d1,d0
loc_204FF8:								; CODE XREF: sub_204EF4+F6↑j
			add.b	d0,d0
			move.b	d0,d3
			neg.w	d2
			addi.w	#$800,d2
			bpl.s	loc_205006
			moveq	#0,d2
loc_205006:								; CODE XREF: sub_204EF4+10E↑j
			lsr.w	#8,d2
			move.b	d2,obj.field_1E(a0)
			bsr.w	sub_204F40
			add.b	d3,obj.frame(a0)
			rts
; ---------------------------------------------------------------------------
loc_205016:								; CODE XREF: sub_204EF4+A2↑j
										; sub_204EF4+20C↓j
			addq.b	#1,d0
			bne.s	loc_205066
			move.w	obj.inertia(a0),d2
			bpl.s	loc_205022
			neg.w	d2
loc_205022:								; CODE XREF: sub_204EF4+12A↑j
			lea	(unk_2052B4).l,a1
			tst.b	(miniplay_flag).w
			bne.s	loc_205040
			lea	(unk_2051EE).l,a1
			cmpi.w	#$600,d2
			bcc.s	loc_205040
			lea	(unk_2051E6).l,a1
loc_205040:								; CODE XREF: sub_204EF4+138↑j
										; sub_204EF4+144↑j
			neg.w	d2
			addi.w	#$400,d2
			bpl.s	loc_20504A
			moveq	#0,d2
loc_20504A:								; CODE XREF: sub_204EF4+152↑j
			lsr.w	#8,d2
			move.b	d2,obj.field_1E(a0)
			move.b	obj.status(a0),d1
			andi.b	#1,d1
			andi.b	#$FC,obj.render(a0)
			or.b	d1,obj.render(a0)
			bra.w	sub_204F40
; ---------------------------------------------------------------------------
loc_205066:								; CODE XREF: sub_204EF4+124↑j
			addq.b	#1,d0
			bne.s	loc_2050A8
loc_20506A:								; CODE XREF: sub_204EF4+DA↑j
			move.w	obj.inertia(a0),d2
			bmi.s	loc_205072
			neg.w	d2
loc_205072:								; CODE XREF: sub_204EF4+17A↑j
			addi.w	#$800,d2
			bpl.s	loc_20507A
			moveq	#0,d2
loc_20507A:								; CODE XREF: sub_204EF4+182↑j
			lsr.w	#6,d2
			move.b	d2,obj.field_1E(a0)
			lea	(unk_2052C6).l,a1
			tst.b	(miniplay_flag).w
			bne.s	loc_205092
			lea	(unk_2051F6).l,a1
loc_205092:								; CODE XREF: sub_204EF4+196↑j
			move.b	obj.status(a0),d1
			andi.b	#1,d1
			andi.b	#$FC,obj.render(a0)
			or.b	d1,obj.render(a0)
			bra.w	sub_204F40
; ---------------------------------------------------------------------------
loc_2050A8:								; CODE XREF: sub_204EF4+174↑j
			moveq	#0,d1
			move.b	obj.field_1B(a0),d1
			move.b	1(a1,d1.w),obj.frame(a0)
			move.b	#0,obj.field_1E(a0)
			rts
; ---------------------------------------------------------------------------
loc_2050BC:								; CODE XREF: sub_204EF4+AA↑j
			moveq	#0,d1
			move.b	obj.angle(a0),d0
			move.b	obj.status(a0),d2
			andi.b	#1,d2
			bne.s	loc_2050CE
			not.b	d0
loc_2050CE:								; CODE XREF: sub_204EF4+1D6↑j
			addi.b	#$10,d0
			bpl.s	loc_2050D6
			moveq	#0,d1
loc_2050D6:								; CODE XREF: sub_204EF4+1DE↑j
			andi.b	#$FC,obj.render(a0)
			or.b	d2,obj.render(a0)
			addi.b	#$30,d0
			cmpi.b	#$60,d0
			bcs.s	loc_205104
			bset	#2,obj.status(a0)
			move.b	#$A,obj.field_16(a0)
			move.b	#5,obj.field_17(a0)
			move.b	#$FF,d0
			bra.w	loc_205016
; ---------------------------------------------------------------------------
loc_205104:								; CODE XREF: sub_204EF4+1F4↑j
			move.w	obj.inertia(a0),d2
			bpl.s	loc_20510C
			neg.w	d2
loc_20510C:								; CODE XREF: sub_204EF4+214↑j
			lea	(unk_2052AE).l,a1
			cmpi.w	#$600,d2
			bcc.s	loc_20511E
			lea	(unk_2052A8).l,a1
loc_20511E:								; CODE XREF: sub_204EF4+222↑j
			neg.w	d2
			addi.w	#$800,d2
			bpl.s	loc_205128
			moveq	#0,d2
loc_205128:								; CODE XREF: sub_204EF4+230↑j
			lsr.w	#8,d2
			move.b	d2,$1E(a0)
			bra.w	sub_204F40
; =============== S U B R O U T I N E =======================================
sub_205132:								; CODE XREF: sub_204EF4:loc_204F16↑p
			tst.b	(miniplay_flag).w
			beq.s	locret_20513C
			move.b	byte_20513E(pc,d0.w),d0
locret_20513C:							; CODE XREF: sub_205132+4↑j
			rts
; End of function sub_205132
; ---------------------------------------------------------------------------
byte_20513E:	dc.b $21					; DATA XREF: sub_205132+6↑r
			dc.b $18
			dc.b $23 ; #
			dc.b $23 ; #
			dc.b $27 ; '
			dc.b $1F
			dc.b $26 ; &
			dc.b $28 ; (
			dc.b $20
			dc.b   9
			dc.b  $A
			dc.b  $B
			dc.b  $C
			dc.b $24 ; $
			dc.b  $E
			dc.b  $F
			dc.b $28 ; (
			dc.b $11
			dc.b $12
			dc.b $13
			dc.b $14
			dc.b $15
			dc.b $16
			dc.b $17
			dc.b $18
			dc.b $19
			dc.b $25 ; %
			dc.b $25 ; %
			dc.b $1C
			dc.b $1D
			dc.b $1E
			dc.b $1F
			dc.b $20
			dc.b $21 ; !
			dc.b $22 ; "
			dc.b $23 ; #
			dc.b $24 ; $
			dc.b $25 ; %
			dc.b $26 ; &
			dc.b $27 ; '
			dc.b $28 ; (
			dc.b $29 ; )
			dc.b $2A ; *
			dc.b $30 ; 0
			dc.b $2C ; ,
			dc.b $2D ; -
			dc.b $2E ; .
			dc.b $2F ; /
play_ani:
			dc.w unk_2051D6-play_ani
			dc.w unk_2051DE-play_ani
			dc.w unk_2051E6-play_ani
			dc.w unk_2051EE-play_ani
			dc.w unk_2051F6-play_ani
			dc.w unk_2051FE-play_ani
			dc.w unk_205214-play_ani
			dc.w unk_205218-play_ani
			dc.w unk_20521C-play_ani
			dc.w unk_205220-play_ani
			dc.w unk_205224-play_ani
			dc.w unk_205228-play_ani
			dc.w unk_20522C-play_ani
			dc.w unk_205230-play_ani
			dc.w unk_205234-play_ani
			dc.w unk_205238-play_ani
			dc.w unk_205240-play_ani
			dc.w unk_205244-play_ani
			dc.w unk_205248-play_ani
			dc.w unk_20524E-play_ani
			dc.w unk_205254-play_ani
			dc.w unk_205258-play_ani
			dc.w unk_205260-play_ani
			dc.w unk_205264-play_ani
			dc.w unk_205268-play_ani
			dc.w unk_20526C-play_ani
			dc.w unk_205276-play_ani
			dc.w unk_20527A-play_ani
			dc.w unk_20527E-play_ani
			dc.w unk_205282-play_ani
			dc.w unk_20528A-play_ani
			dc.w unk_20528E-play_ani
			dc.w unk_2052A4-play_ani
			dc.w unk_2052A8-play_ani
			dc.w unk_2052AE-play_ani
			dc.w unk_2052B4-play_ani
			dc.w unk_2052BA-play_ani
			dc.w unk_2052BE-play_ani
			dc.w unk_2052C2-play_ani
			dc.w unk_2052C6-play_ani
			dc.w unk_2052CE-play_ani
			dc.w unk_2052D2-play_ani
			dc.w unk_2052D6-play_ani
			dc.w unk_2052E6-play_ani
			dc.w unk_20530C-play_ani
			dc.w unk_205310-play_ani
			dc.w unk_205318-play_ani
			dc.w unk_205320-play_ani
			dc.w unk_205326-play_ani
			dc.w unk_205310-play_ani
			dc.w unk_205318-play_ani
			dc.w unk_205320-play_ani
unk_2051D6: dc.b $FF					; DATA XREF: sub_204EF4+F8↑o
										; ROM:play_ani↑o
			dc.b $35 ; 5
			dc.b $36 ; 6
			dc.b $37 ; 7
			dc.b $38 ; 8
			dc.b $33 ; 3
			dc.b $34 ; 4
			dc.b $FF
unk_2051DE: dc.b $FF					; DATA XREF: sub_204EF4:loc_204FE0↑o
										; ROM:00205170↑o
			dc.b $4B ; K
			dc.b $4C ; L
			dc.b $4D ; M
			dc.b $4E ; N
			dc.b $FF
			dc.b $FF
			dc.b $FF
unk_2051E6: dc.b $FE					; DATA XREF: sub_204EF4+146↑o
										; ROM:00205172↑o
			dc.b $2D ; -
			dc.b $2E ; .
			dc.b $2F ; /
			dc.b $30 ; 0
			dc.b $31 ; 1
			dc.b $FF
			dc.b $FF
unk_2051EE: dc.b $FE					; DATA XREF: sub_204EF4+13A↑o
										; ROM:00205174↑o
			dc.b $2D ; -
			dc.b $2E ; .
			dc.b $31 ; 1
			dc.b $2F ; /
			dc.b $30 ; 0
			dc.b $31 ; 1
			dc.b $FF
unk_2051F6: dc.b $FD					; DATA XREF: sub_204EF4+198↑o
										; ROM:00205176↑o
			dc.b $64 ; d
			dc.b $65 ; e
			dc.b $66 ; f
			dc.b $67 ; g
			dc.b $FF
			dc.b $FF
			dc.b $FF
unk_2051FE: dc.b $17					; DATA XREF: ROM:00205178↑o
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   3
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b $FE
			dc.b   2
			dc.b   0
unk_205214: dc.b $1F					; DATA XREF: ROM:0020517A↑o
			dc.b $6D ; m
			dc.b $6E ; n
			dc.b $FF
unk_205218: dc.b $3F ; ?				; DATA XREF: ROM:0020517C↑o
			dc.b   5
			dc.b $FF
			dc.b   0
unk_20521C: dc.b $3F ; ?				; DATA XREF: ROM:0020517E↑o
			dc.b $60 ; `
			dc.b $FF
			dc.b   0
unk_205220: dc.b $3F ; ?				; DATA XREF: ROM:00205180↑o
			dc.b $33 ; 3
			dc.b $FF
			dc.b   0
unk_205224: dc.b $3F ; ?				; DATA XREF: ROM:00205182↑o
			dc.b $34 ; 4
			dc.b $FF
			dc.b   0
unk_205228: dc.b $3F ; ?				; DATA XREF: ROM:00205184↑o
			dc.b $35 ; 5
			dc.b $FF
			dc.b   0
unk_20522C: dc.b $3F ; ?				; DATA XREF: ROM:00205186↑o
			dc.b $36 ; 6
			dc.b $FF
			dc.b   0
unk_205230: dc.b   7					; DATA XREF: ROM:00205188↑o
			dc.b $5B ; [
			dc.b $5C ; \
			dc.b $FF
unk_205234: dc.b   7					; DATA XREF: ROM:0020518A↑o
			dc.b $3C ; <
			dc.b $3F ; ?
			dc.b $FF
unk_205238: dc.b   7					; DATA XREF: ROM:0020518C↑o
			dc.b $3C ; <
			dc.b $3D ; =
			dc.b $53 ; S
			dc.b $3E ; >
			dc.b $54 ; T
			dc.b $FF
			dc.b   0
unk_205240: dc.b $2F ; /				; DATA XREF: ROM:0020518E↑o
			dc.b $32 ; 2
			dc.b $FD
			dc.b   0
unk_205244: dc.b   4					; DATA XREF: ROM:00205190↑o
			dc.b $6B ; k
			dc.b $6C ; l
			dc.b $FF
unk_205248: dc.b  $F					; DATA XREF: ROM:00205192↑o
			dc.b $43 ; C
			dc.b $43 ; C
			dc.b $43 ; C
			dc.b $FE
			dc.b   1
unk_20524E: dc.b  $F					; DATA XREF: ROM:00205194↑o
			dc.b $43 ; C
			dc.b $44 ; D
			dc.b $FE
			dc.b   1
			dc.b   0
unk_205254: dc.b $3F ; ?				; DATA XREF: ROM:00205196↑o
			dc.b $49 ; I
			dc.b $FF
			dc.b   0
unk_205258: dc.b  $B					; DATA XREF: ROM:00205198↑o
			dc.b $5F ; _
			dc.b $5F ; _
			dc.b $37 ; 7
			dc.b $38 ; 8
			dc.b $FD
			dc.b   0
			dc.b   0
unk_205260: dc.b $20					; DATA XREF: ROM:0020519A↑o
			dc.b $68 ; h
			dc.b $FF
			dc.b   0
unk_205264: dc.b $2F ; /				; DATA XREF: ROM:0020519C↑o
			dc.b $69 ; i
			dc.b $FF
			dc.b   0
unk_205268: dc.b   3					; DATA XREF: ROM:0020519E↑o
			dc.b $6A ; j
			dc.b $FF
			dc.b   0
unk_20526C: dc.b   3					; DATA XREF: ROM:002051A0↑o
			dc.b $4E ; N
			dc.b $4F ; O
			dc.b $50 ; P
			dc.b $51 ; Q
			dc.b $52 ; R
			dc.b   0
			dc.b $FE
			dc.b   1
			dc.b   0
unk_205276: dc.b   3					; DATA XREF: ROM:002051A2↑o
			dc.b $5D ; ]
			dc.b $FF
			dc.b   0
unk_20527A: dc.b   7					; DATA XREF: ROM:002051A4↑o
			dc.b $5D ; ]
			dc.b $5E ; ^
			dc.b $FF
unk_20527E: dc.b $77 ; w				; DATA XREF: ROM:002051A6↑o
			dc.b   0
			dc.b $FD
			dc.b   0
unk_205282: dc.b   3					; DATA XREF: ROM:002051A8↑o
			dc.b $3C ; <
			dc.b $3D ; =
			dc.b $53 ; S
			dc.b $3E ; >
			dc.b $54 ; T
			dc.b $FF
			dc.b   0
unk_20528A: dc.b   3					; DATA XREF: ROM:002051AA↑o
			dc.b $3C ; <
			dc.b $FD
			dc.b   0
unk_20528E: dc.b $17					; DATA XREF: ROM:002051AC↑o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $6F ; o
			dc.b $70 ; p
			dc.b $70 ; p
			dc.b $70 ; p
			dc.b $71 ; q
			dc.b $70 ; p
			dc.b $71 ; q
			dc.b $FE
			dc.b   2
			dc.b   0
unk_2052A4: dc.b $3F ; ?				; DATA XREF: ROM:002051AE↑o
			dc.b $72 ; r
			dc.b $FF
			dc.b   0
unk_2052A8: dc.b $FF					; DATA XREF: sub_204EF4+224↑o
										; ROM:002051B0↑o
			dc.b $73 ; s
			dc.b $74 ; t
			dc.b $75 ; u
			dc.b $74 ; t
			dc.b $FF
unk_2052AE: dc.b $FF					; DATA XREF: sub_204EF4:loc_20510C↑o
										; ROM:002051B2↑o
			dc.b $76 ; v
			dc.b $77 ; w
			dc.b $FF
			dc.b $FF
			dc.b $FF
unk_2052B4: dc.b $FE					; DATA XREF: sub_204EF4:loc_205022↑o
										; ROM:002051B4↑o
			dc.b $7C ; |
			dc.b $7D ; }
			dc.b $7E ; ~
			dc.b $FF
			dc.b $FF
unk_2052BA: dc.b   7					; DATA XREF: ROM:002051B6↑o
			dc.b $78 ; x
			dc.b $78 ; x
			dc.b $FF
unk_2052BE: dc.b   3					; DATA XREF: ROM:002051B8↑o
			dc.b $79 ; y
			dc.b $FF
			dc.b   0
unk_2052C2: dc.b $1F					; DATA XREF: ROM:002051BA↑o
			dc.b $7A ; z
			dc.b $7B ; {
			dc.b $FF
unk_2052C6: dc.b $FD					; DATA XREF: sub_204EF4+18C↑o
										; ROM:002051BC↑o
			dc.b $73 ; s
			dc.b $74 ; t
			dc.b $75 ; u
			dc.b $FF
			dc.b $FF
			dc.b $FF
			dc.b   0
unk_2052CE: dc.b $3F ; ?				; DATA XREF: ROM:002051BE↑o
			dc.b $6F ; o
			dc.b $FF
			dc.b   0
unk_2052D2: dc.b $3F ; ?				; DATA XREF: ROM:002051C0↑o
			dc.b   6
			dc.b $FF
			dc.b   0
unk_2052D6: dc.b   3					; DATA XREF: ROM:002051C2↑o
			dc.b   7
			dc.b   7
			dc.b   7
			dc.b   7
			dc.b   7
			dc.b   9
			dc.b   9
			dc.b   8
			dc.b   8
			dc.b   8
			dc.b   1
			dc.b  $A
			dc.b  $A
			dc.b $FD
			dc.b   5
unk_2052E6: dc.b   9					; DATA XREF: ROM:002051C4↑o
			dc.b $11
			dc.b $11
			dc.b $11
			dc.b $11
			dc.b $11
			dc.b $11
			dc.b $11
			dc.b $11
			dc.b $11
			dc.b $11
			dc.b $11
			dc.b $11
			dc.b $12
			dc.b $12
			dc.b $12
			dc.b $12
			dc.b $13
			dc.b $14
			dc.b $14
			dc.b $14
			dc.b $14
			dc.b $14
			dc.b $14
			dc.b $14
			dc.b $14
			dc.b $15
			dc.b $15
			dc.b $15
			dc.b $15
			dc.b $16
			dc.b $16
			dc.b $16
			dc.b $16
			dc.b $17
			dc.b $FE
			dc.b   1
			dc.b   0
unk_20530C: dc.b   4					; DATA XREF: ROM:002051C6↑o
			dc.b $18
			dc.b $19
			dc.b $FF
unk_205310: dc.b $FC					; DATA XREF: ROM:002051C8↑o
										; ROM:002051D0↑o
			dc.b $1A
			dc.b $1B
			dc.b $1C
			dc.b $1F
			dc.b $1D
			dc.b $1E
			dc.b $FF
unk_205318: dc.b $FF					; DATA XREF: ROM:002051CA↑o
										; ROM:002051D2↑o
			dc.b  $D
			dc.b  $E
			dc.b  $F
			dc.b $10
			dc.b  $B
			dc.b  $C
			dc.b $FF
unk_205320: dc.b $FF					; DATA XREF: ROM:002051CC↑o
										; ROM:002051D4↑o
			dc.b $61 ; a
			dc.b $62 ; b
			dc.b $63 ; c
			dc.b $FF
			dc.b   0
unk_205326: dc.b $13					; DATA XREF: ROM:002051CE↑o
			dc.b $70 ; p
			dc.b $6F ; o
			dc.b $70 ; p
			dc.b $79 ; y
			dc.b $FE
			dc.b   1
			dc.b   0
; =============== S U B R O U T I N E =======================================
sub_20532E:								; CODE XREF: ROM:0020185E↑p
										; ROM:00201896↑p ...
			lea	(byte_FFF766).w,a2
			cmpi.b	#1,obj.id(a0)
			beq.s	loc_20533E
			lea	(byte_FFF75D).w,a2
loc_20533E:								; CODE XREF: sub_20532E+A↑j
			moveq	#0,d0
			move.b	obj.frame(a0),d0
			cmp.b	(a2),d0
			beq.s	locret_205392
			move.b	d0,(a2)
			lea	(dplc_player).l,a2
			add.w	d0,d0
			adda.w	(a2,d0.w),a2
			moveq	#0,d1
			move.b	(a2)+,d1
			subq.b	#1,d1
			bmi.s	locret_205392
			lea	(byte_FFC800).w,a3
			move.b	#1,(byte_FFF767).w
loc_205368:								; CODE XREF: sub_20532E+60↓j
			moveq	#0,d2
			move.b	(a2)+,d2
			move.w	d2,d0
			lsr.b	#4,d0
			lsl.w	#8,d2
			move.b	(a2)+,d2
			lsl.w	#5,d2
			lea	(cg_player).l,a1
			adda.l	d2,a1
loc_20537E:								; CODE XREF: sub_20532E+5C↓j
			movem.l (a1)+,d2-d6/a4-a6
			movem.l d2-d6/a4-a6,(a3)
			lea	$20(a3),a3
			dbf	d0,loc_20537E
			dbf	d1,loc_205368
locret_205392:							; CODE XREF: sub_20532E+18↑j
										; sub_20532E+2E↑j
			rts
; End of function sub_20532E
; =============== S U B R O U T I N E =======================================
sub_205394:								; CODE XREF: sub_20484C+50↑p
			moveq	#0,d0
			move.b	obj.field_3D(a0),d0
			lsl.w	#6,d0
			addi.l	#actwk&$FFFFFF,d0
			movea.l d0,a1
			cmpi.b	#$1E,obj.id(a1)
			bne.s	locret_2053FE
			move.b	#1,obj.ani(a1)
			move.w	obj.xpos(a1),d1
			move.w	obj.ypos(a1),d2
			addi.w	#$18,d2
			sub.w	obj.xpos(a0),d1
			sub.w	obj.ypos(a0),d2
			jsr	(calcangle).l
			moveq	#0,d2
			move.b	obj.field_19(a1),d2
			move.w	obj.xpos(a0),d3
			sub.w	obj.xpos(a1),d3
			add.w	d2,d3
			btst	#0,obj.status(a1)
			bne.s	loc_2053EC
			move.w	#$40,d1
			sub.w	d3,d1
			move.w	d1,d3
loc_2053EC:								; CODE XREF: sub_205394+4E↑j
			move.w	#-$A00,d2
			move.w	d2,d1
			ext.l	d1
			muls.w	d3,d1
			divs.w	#$40,d1
			add.w	d1,d2
			moveq	#0,d1
locret_2053FE:							; CODE XREF: sub_205394+16↑j
			rts
; End of function sub_205394
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_203F00
loc_205400:								; CODE XREF: sub_203F00+3C↑j
										; ROM:0020DFC0↓j
			move.w	#scpu_fadeCDA,d0
; END OF FUNCTION CHUNK FOR sub_203F00
; =============== S U B R O U T I N E =======================================
sub_205404:								; CODE XREF: sub_2015B6+1E↑j
										; ROM:002015E2↑p ...
			move.w	d0,(scpu_commcmd0).l
loc_20540A:								; CODE XREF: sub_205404+C↓j
			tst.w	(scpu_commstats).l
			beq.s	loc_20540A
			move.w	#0,(scpu_commcmd0).l
loc_20541A:								; CODE XREF: sub_205404+1C↓j
			tst.w	(scpu_commstats).l
			bne.s	loc_20541A
			rts
; End of function sub_205404
; =============== S U B R O U T I N E =======================================
animateobj:								; CODE XREF: ROM:00205540↓p
										; ROM:0020558E↓p ...
			tst.b	obj.render(a0)
			bpl.s	locret_205486
			moveq	#0,d0
			move.b	obj.ani(a0),d0
			cmp.b	obj.prevani(a0),d0
			beq.s	loc_205446
			move.b	d0,obj.prevani(a0)
			move.b	#0,obj.field_1B(a0)
			move.b	#0,obj.field_1E(a0)
loc_205446:								; CODE XREF: animateobj+10↑j
			subq.b	#1,obj.field_1E(a0)
			bpl.s	locret_205486
			add.w	d0,d0
			adda.w	(a1,d0.w),a1
			move.b	(a1),obj.field_1E(a0)
			moveq	#0,d1
			move.b	obj.field_1B(a0),d1
			move.b	1(a1,d1.w),d0
			bmi.s	loc_205488
loc_205462:								; CODE XREF: animateobj+72↓j
										; animateobj+86↓j
			move.b	d0,d1
			andi.b	#$1F,d0
			move.b	d0,obj.frame(a0)
			move.b	obj.status(a0),d0
			rol.b	#3,d1
			eor.b	d0,d1
			andi.b	#3,d1
			andi.b	#$FC,obj.render(a0)
			or.b	d1,obj.render(a0)
			addq.b	#1,obj.field_1B(a0)
locret_205486:							; CODE XREF: animateobj+4↑j
										; animateobj+26↑j
			rts
; ---------------------------------------------------------------------------
loc_205488:								; CODE XREF: animateobj+3C↑j
			addq.b	#1,d0
			bne.s	loc_205498
			move.b	#0,obj.field_1B(a0)
			move.b	1(a1),d0
			bra.s	loc_205462
; ---------------------------------------------------------------------------
loc_205498:								; CODE XREF: animateobj+66↑j
			addq.b	#1,d0
			bne.s	loc_2054AC
			move.b	2(a1,d1.w),d0
			sub.b	d0,obj.field_1B(a0)
			sub.b	d0,d1
			move.b	1(a1,d1.w),d0
			bra.s	loc_205462
; ---------------------------------------------------------------------------
loc_2054AC:								; CODE XREF: animateobj+76↑j
			addq.b	#1,d0
			bne.s	loc_2054B6
			move.b	2(a1,d1.w),obj.ani(a0)
loc_2054B6:								; CODE XREF: animateobj+8A↑j
			addq.b	#1,d0
			bne.s	loc_2054BE
			addq.b	#2,obj.routine(a0)
loc_2054BE:								; CODE XREF: animateobj+94↑j
			addq.b	#1,d0
			bne.s	loc_2054CC
			move.b	#0,obj.field_1B(a0)
			clr.b	obj.routine2(a0)
loc_2054CC:								; CODE XREF: animateobj+9C↑j
			addq.b	#1,d0
			bne.s	locret_2054D4
			addq.b	#2,obj.routine2(a0)
locret_2054D4:							; CODE XREF: animateobj+AA↑j
			rts
; End of function animateobj
; ---------------------------------------------------------------------------
obj06:									; DATA XREF: ROM:002034C2↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2054E4(pc,d0.w),d0
			jmp	off_2054E4(pc,d0.w)
; ---------------------------------------------------------------------------
off_2054E4: dc.w loc_2054E8-*			; CODE XREF: ROM:002054E0↑j
										; DATA XREF: ROM:002054DC↑r ...
			dc.w loc_20551C-off_2054E4
; ---------------------------------------------------------------------------
loc_2054E8:								; DATA XREF: ROM:off_2054E4↑o
			btst	#7,obj.status(a0)
			bne.w	deleteobj
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.l	#obj06_map,obj.mappings(a0)
			move.w	#$541,obj.vram(a0)
			move.w	obj.xpos(a0),obj.field_30(a0)
			move.b	#6,obj.colflag(a0)
loc_20551C:								; DATA XREF: ROM:002054E6↑o
			move.w	obj.field_30(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bhi.w	deleteobj
			lea	(obj06_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
obj18:									; DATA XREF: ROM:0020350A↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_205558(pc,d0.w),d0
			jmp	off_205558(pc,d0.w)
; ---------------------------------------------------------------------------
off_205558: dc.w loc_20555E-*			; CODE XREF: ROM:00205554↑j
										; DATA XREF: ROM:00205550↑r ...
			dc.w loc_205588-off_205558
			dc.w loc_205598-off_205558
; ---------------------------------------------------------------------------
loc_20555E:								; DATA XREF: ROM:off_205558↑o
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.w	#$680,obj.vram(a0)
			move.l	#obj18_map,obj.mappings(a0)
			move.b	#0,obj.colflag(a0)
			move.w	#1,obj.ani(a0)
loc_205588:								; DATA XREF: ROM:0020555A↑o
			lea	(obj18_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_205598:								; DATA XREF: ROM:0020555C↑o
			tst.b	obj.routine2(a0)
			beq.s	loc_2055A4
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_2055A4:								; CODE XREF: ROM:0020559C↑j
			move.b	#$1F,obj.id(a0)
			move.b	#0,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
obj1F:									; DATA XREF: ROM:00203526↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2055C6(pc,d0.w),d0
			jsr	off_2055C6(pc,d0.w)
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
off_2055C6: dc.w loc_2055D0-*			; CODE XREF: ROM:002055BC↑p
										; DATA XREF: ROM:002055B8↑r ...
			dc.w loc_20561A-off_2055C6
			dc.w loc_20565C-off_2055C6
			dc.w loc_2056AC-off_2055C6
			dc.w loc_2056BA-off_2055C6
; ---------------------------------------------------------------------------
loc_2055D0:								; DATA XREF: ROM:off_2055C6↑o
			ori.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#0,obj.field_16(a0)
			move.w	#$46D6,obj.vram(a0)
			move.l	#obj1F_map,obj.mappings(a0)
			bsr.w	sub_205666
			move.b	(a1),d0
			move.b	#4,obj.routine(a0)
			move.b	#3,obj.ani(a0)
			btst	#6,d0
			bne.s	loc_20565C
			move.w	#2,obj.ani(a0)
			move.b	#2,obj.routine(a0)
			move.w	#$6D6,obj.vram(a0)
loc_20561A:								; DATA XREF: ROM:002055C8↑o
			jsr	(sub_20611C).l
			tst.w	d1
			bpl.s	loc_205658
			add.w	d1,obj.ypos(a0)
			bsr.w	sub_205666
			lea	(dword_FF1880).l,a2
			move.b	(a2,d1.w),d0
			addq.b	#1,(a2,d1.w)
			bsr.w	sub_20568C
			move.w	obj.xpos(a0),(a1,d0.w)
			move.w	obj.ypos(a0),2(a1,d0.w)
			move.b	#4,obj.routine(a0)
			move.b	#1,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_205658:								; CODE XREF: ROM:00205622↑j
			addq.w	#2,obj.ypos(a0)
loc_20565C:								; CODE XREF: ROM:00205606↑j
										; ROM:002056B8↓j ...
			lea	(obj1F_ani).l,a1
			bra.w	animateobj
; =============== S U B R O U T I N E =======================================
sub_205666:								; CODE XREF: ROM:002055F0↑p
										; ROM:00205628↑p
			moveq	#0,d0
			move.b	obj.field_23(a0),d0
			move.w	d0,d1
			add.w	d1,d1
			add.w	d1,d0
			moveq	#0,d1
			move.b	(byte_FF123D).l,d1
			bclr	#7,d1
			add.w	d1,d0
			lea	(unk_FF1400).l,a1
			lea	2(a1,d0.w),a1
			rts
; End of function sub_205666
; =============== S U B R O U T I N E =======================================
sub_20568C:								; CODE XREF: ROM:0020563A↑p
			andi.w	#$3F,d0
			add.w	d0,d0
			add.w	d0,d0
			moveq	#0,d1
			move.b	(byte_FF123D).l,d1
			bclr	#7,d1
			lsl.w	#8,d1
			add.w	d1,d0
			lea	(byte_FF1580).l,a1
			rts
; End of function sub_20568C
; ---------------------------------------------------------------------------
loc_2056AC:								; DATA XREF: ROM:002055CC↑o
			move.w	#$46D6,obj.vram(a0)
			move.b	#2,obj.ani(a0)
			bra.s	loc_20565C
; ---------------------------------------------------------------------------
loc_2056BA:								; DATA XREF: ROM:002055CE↑o
			move.b	#3,obj.ani(a0)
			move.b	#4,obj.routine(a0)
			bra.s	loc_20565C
; ---------------------------------------------------------------------------
obj0E:									; DATA XREF: ROM:002034E2↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2056D6(pc,d0.w),d0
			jmp	off_2056D6(pc,d0.w)
; ---------------------------------------------------------------------------
off_2056D6: dc.w loc_2056DC-*			; CODE XREF: ROM:002056D2↑j
										; DATA XREF: ROM:002056CE↑r ...
			dc.w loc_2056FA-off_2056D6
			dc.w loc_20570A-off_2056D6
; ---------------------------------------------------------------------------
loc_2056DC:								; DATA XREF: ROM:off_2056D6↑o
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.l	#obj0E_map,obj.mappings(a0)
			move.w	#$31E,obj.vram(a0)
			move.b	#1,obj.priority(a0)
loc_2056FA:								; DATA XREF: ROM:002056D8↑o
			lea	(obj0E_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20570A:								; DATA XREF: ROM:002056DA↑o
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
obj0D:									; DATA XREF: ROM:002034DE↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20572A(pc,d0.w),d0
			jsr	off_20572A(pc,d0.w)
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20572A: dc.w loc_205782-*			; CODE XREF: ROM:0020571A↑p
										; DATA XREF: ROM:00205716↑r ...
			dc.w loc_2057AE-off_20572A
			dc.w loc_2057BE-off_20572A
			dc.w loc_2057C8-off_20572A
; =============== S U B R O U T I N E =======================================
sub_205732:								; CODE XREF: ROM:002057B2↓p
										; ROM:002057BA↓j
			tst.w	obj.yvel(a1)
			bpl.s	loc_205774
			bsr.w	obj0C
			beq.s	loc_205774
			move.b	#4,obj.routine(a0)
			tst.b	obj.field_28(a0)
			bne.s	locret_205772
			jsr	(findfreeobj).l
			bne.s	locret_205772
			move.b	#$B,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			subq.w	#4,obj.ypos(a1)
			move.w	#$A4,d0
			jmp	(queuesound2).l
; ---------------------------------------------------------------------------
locret_205772:							; CODE XREF: sub_205732+16↑j
										; sub_205732+1E↑j
			rts
; ---------------------------------------------------------------------------
loc_205774:								; CODE XREF: sub_205732+4↑j
										; sub_205732+A↑j
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_205732
; ---------------------------------------------------------------------------
loc_205782:								; DATA XREF: ROM:off_20572A↑o
			addq.b	#2,obj.routine(a0)
			move.l	#obj0D_map,obj.mappings(a0)
			move.b	#1,obj.priority(a0)
			ori.b	#4,obj.render(a0)
			move.b	#$2C,obj.field_19(a0)
			move.b	#8,obj.field_16(a0)
			moveq	#$C,d0
			jsr	(sub_20DC4C).l
loc_2057AE:								; DATA XREF: ROM:0020572C↑o
			lea	(actwk).w,a1
			bsr.w	sub_205732
			lea	(byte_FFD040).w,a1
			bra.w	sub_205732
; ---------------------------------------------------------------------------
loc_2057BE:								; DATA XREF: ROM:0020572E↑o
			lea	(obj0D_ani).l,a1
			bra.w	animateobj
; ---------------------------------------------------------------------------
loc_2057C8:								; DATA XREF: ROM:00205730↑o
			move.b	#1,obj.prevani(a0)
			move.b	#0,obj.frame(a0)
			subq.b	#4,obj.routine(a0)
			rts
; =============== S U B R O U T I N E =======================================
obj0C:									; CODE XREF: sub_205732+6↑p
										; DATA XREF: ROM:002034DA↑o
			move.w	obj.xpos(a1),d0
			sub.w	obj.xpos(a0),d0
			moveq	#0,d1
			move.b	obj.field_19(a0),d1
			add.w	d1,d0
			bmi.s	loc_20580E
			add.w	d1,d1
			cmp.w	d1,d0
			bcc.s	loc_20580E
			move.w	obj.ypos(a1),d0
			sub.w	obj.ypos(a0),d0
			moveq	#0,d1
			move.b	obj.field_16(a0),d1
			add.w	d1,d0
			bmi.s	loc_20580E
			add.w	d1,d1
			cmp.w	d1,d0
			bcc.s	loc_20580E
			moveq	#1,d0
			rts
; ---------------------------------------------------------------------------
loc_20580E:								; CODE XREF: obj0C+10↑j
										; obj0C+16↑j ...
			moveq	#0,d0
			rts
; End of function obj0C
; ---------------------------------------------------------------------------
obj0B:									; DATA XREF: ROM:002034D6↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_205820(pc,d0.w),d0
			jmp	off_205820(pc,d0.w)
; ---------------------------------------------------------------------------
off_205820: dc.w loc_205826-*			; CODE XREF: ROM:0020581C↑j
										; DATA XREF: ROM:00205818↑r ...
			dc.w loc_205862-off_205820
			dc.w loc_205872-off_205820
; ---------------------------------------------------------------------------
loc_205826:								; DATA XREF: ROM:off_205820↑o
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.l	#obj0B_map,obj.mappings(a0)
			move.b	obj.field_28(a0),obj.ani(a0)
			moveq	#$D,d0
			jsr	(sub_20DC4C).l
			move.w	#$A2,d0
			cmpi.b	#2,obj.field_28(a0)
			bcs.s	loc_20585C
			move.w	#$A1,d0
loc_20585C:								; CODE XREF: ROM:00205856↑j
			jsr	(queuesound2).l
loc_205862:								; DATA XREF: ROM:00205822↑o
			lea	(obj0B_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_205872:								; DATA XREF: ROM:00205824↑o
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
obj03:									; DATA XREF: ROM:002034B6↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_205886(pc,d0.w),d1
			jmp	off_205886(pc,d1.w)
; ---------------------------------------------------------------------------
off_205886: dc.w loc_20588E-*			; CODE XREF: ROM:00205882↑j
										; DATA XREF: ROM:0020587E↑r ...
			dc.w loc_2058CA-off_205886
			dc.w loc_205912-off_205886
			dc.w loc_20592A-off_205886
; ---------------------------------------------------------------------------
loc_20588E:								; DATA XREF: ROM:off_205886↑o
			addq.b	#2,obj.routine(a0)
			move.l	#obj06_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.w	#$544,obj.vram(a0)
			tst.b	obj.ani(a0)
			beq.s	locret_2058C8
			addq.b	#2,obj.routine(a0)
			cmpi.b	#5,obj.ani(a0)
			bcs.s	locret_2058C8
			addq.b	#2,obj.routine(a0)
locret_2058C8:							; CODE XREF: ROM:002058B6↑j
										; ROM:002058C2↑j
			rts
; ---------------------------------------------------------------------------
loc_2058CA:								; DATA XREF: ROM:00205888↑o
			tst.b	(byte_FF122C).l
			beq.s	loc_20590C
			tst.b	(byte_FF122F).l
			bne.s	locret_20590A
			tst.b	(byte_FF122D).l
			bne.s	locret_20590A
			jsr	(sub_2023EA).l
			move.w	obj.xpos(a6),obj.xpos(a0)
			move.w	obj.ypos(a6),obj.ypos(a0)
			move.b	obj.status(a6),obj.status(a0)
			lea	(obj06_ani).l,a1
			jsr	(animateobj).l
			bra.w	loc_205992
; ---------------------------------------------------------------------------
locret_20590A:							; CODE XREF: ROM:002058D8↑j
										; ROM:002058E0↑j
			rts
; ---------------------------------------------------------------------------
loc_20590C:								; CODE XREF: ROM:002058D0↑j
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_205912:								; DATA XREF: ROM:0020588A↑o
			tst.b	(byte_FF122F).l
			beq.s	loc_20591C
			rts
; ---------------------------------------------------------------------------
loc_20591C:								; CODE XREF: ROM:00205918↑j
			tst.b	(byte_FF122D).l
			bne.s	loc_205938
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_20592A:								; DATA XREF: ROM:0020588C↑o
			tst.b	(byte_FF122F).l
			bne.s	loc_205938
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_205938:								; CODE XREF: ROM:00205922↑j
										; ROM:00205930↑j
			move.w	(word_FFF7A8).w,d0
			move.b	obj.ani(a0),d1
			subq.b	#1,d1
			cmpi.b	#4,d1
			bcs.s	loc_20594A
			subq.b	#4,d1
loc_20594A:								; CODE XREF: ROM:00205946↑j
			lsl.b	#3,d1
			move.b	d1,d2
			add.b	d1,d1
			add.b	d2,d1
			addq.b	#4,d1
			sub.b	d1,d0
			move.b	obj.field_30(a0),d1
			sub.b	d1,d0
			addq.b	#4,d1
			cmpi.b	#$18,d1
			bcs.s	loc_205966
			moveq	#0,d1
loc_205966:								; CODE XREF: ROM:00205962↑j
			move.b	d1,obj.field_30(a0)
			lea	(byte_FFCB00).w,a1
			lea	(a1,d0.w),a1
			move.w	(a1)+,obj.xpos(a0)
			move.w	(a1)+,obj.ypos(a0)
			jsr	(sub_2023EA).l
			move.b	obj.status(a6),obj.status(a0)
			lea	(obj06_ani).l,a1
			jsr	(animateobj).l
loc_205992:								; CODE XREF: ROM:00205906↑j
			move.b	(byte_FF127B).l,d0
			andi.b	#7,d0
			cmp.b	obj.routine(a0),d0
			beq.s	loc_2059B2
			move.b	obj.routine(a0),(byte_FF127B).l
			bset	#7,(byte_FF127B).l
loc_2059B2:								; CODE XREF: ROM:002059A0↑j
			jmp	(displaysprite).l
; =============== S U B R O U T I N E =======================================
sub_2059B8:								; CODE XREF: sub_20DFF4↓j
			bclr	#7,(byte_FF127B).l
			beq.s	locret_205A06
			moveq	#0,d0
			move.b	(byte_FF127B).l,d0
			subq.b	#2,d0
			add.w	d0,d0
			movea.l off_205A08(pc,d0.w),a1
			lea	(byte_FF1900).l,a2
			move.w	#(byte_FF1900_end-byte_FF1900)/4-1,d0
loc_2059DC:								; CODE XREF: sub_2059B8+26↓j
			move.l	(a1)+,(a2)+
			dbf	d0,loc_2059DC
			lea	(vdpctrl).l,a5
			move.l	#$94029340,(a5)
			move.l	#$968C9580,(a5)
			move.w	#$977F,(a5)
			move.w	#$6880,(a5)
			move.w	#$82,(word_FFF640).w
			move.w	(word_FFF640).w,(a5)
locret_205A06:							; CODE XREF: sub_2059B8+8↑j
			rts
; End of function sub_2059B8
; ---------------------------------------------------------------------------
off_205A08: dc.l unk_22F628				; DATA XREF: sub_2059B8+16↑r
			dc.l unk_22FAA8
			dc.l unk_22FF28
obj06_ani:	dc.w unk_205A26-*			; DATA XREF: ROM:0020553A↑o
										; ROM:002058FA↑o ...
			dc.w unk_205A2E-obj06_ani
			dc.w unk_205A34-obj06_ani
			dc.w unk_205A4E-obj06_ani
			dc.w unk_205A68-obj06_ani
			dc.w unk_205A82-obj06_ani
			dc.w unk_205A8E-obj06_ani
			dc.w unk_205AC8-obj06_ani
			dc.w unk_205B02-obj06_ani
unk_205A26: dc.b   1					; DATA XREF: ROM:obj06_ani↑o
			dc.b   1
			dc.b   0
			dc.b   2
			dc.b   0
			dc.b   3
			dc.b   0
			dc.b $FF
unk_205A2E: dc.b   5					; DATA XREF: ROM:00205A16↑o
			dc.b   4
			dc.b   5
			dc.b   6
			dc.b   7
			dc.b $FF
unk_205A34: dc.b   0					; DATA XREF: ROM:00205A18↑o
			dc.b   4
			dc.b   4
			dc.b   0
			dc.b   4
			dc.b   4
			dc.b   0
			dc.b   5
			dc.b   5
			dc.b   0
			dc.b   5
			dc.b   5
			dc.b   0
			dc.b   6
			dc.b   6
			dc.b   0
			dc.b   6
			dc.b   6
			dc.b   0
			dc.b   7
			dc.b   7
			dc.b   0
			dc.b   7
			dc.b   7
			dc.b   0
			dc.b $FF
unk_205A4E: dc.b   0					; DATA XREF: ROM:00205A1A↑o
			dc.b   4
			dc.b   4
			dc.b   0
			dc.b   4
			dc.b   0
			dc.b   0
			dc.b   5
			dc.b   5
			dc.b   0
			dc.b   5
			dc.b   0
			dc.b   0
			dc.b   6
			dc.b   6
			dc.b   0
			dc.b   6
			dc.b   0
			dc.b   0
			dc.b   7
			dc.b   7
			dc.b   0
			dc.b   7
			dc.b   0
			dc.b   0
			dc.b $FF
unk_205A68: dc.b   0					; DATA XREF: ROM:00205A1C↑o
			dc.b   4
			dc.b   0
			dc.b   0
			dc.b   4
			dc.b   0
			dc.b   0
			dc.b   5
			dc.b   0
			dc.b   0
			dc.b   5
			dc.b   0
			dc.b   0
			dc.b   6
			dc.b   0
			dc.b   0
			dc.b   6
			dc.b   0
			dc.b   0
			dc.b   7
			dc.b   0
			dc.b   0
			dc.b   7
			dc.b   0
			dc.b   0
			dc.b $FF
unk_205A82: dc.b   0					; DATA XREF: ROM:00205A1E↑o
			dc.b   8
			dc.b   9
			dc.b  $A
			dc.b  $B
			dc.b  $C
			dc.b  $B
			dc.b  $A
			dc.b   9
			dc.b   8
			dc.b   0
			dc.b $FF
unk_205A8E: dc.b   0					; DATA XREF: ROM:00205A20↑o
			dc.b   8
			dc.b   8
			dc.b   0
			dc.b   8
			dc.b   8
			dc.b   0
			dc.b   9
			dc.b   9
			dc.b   0
			dc.b   9
			dc.b   9
			dc.b   0
			dc.b  $A
			dc.b  $A
			dc.b   0
			dc.b  $A
			dc.b  $A
			dc.b   0
			dc.b  $B
			dc.b  $B
			dc.b   0
			dc.b  $B
			dc.b  $B
			dc.b   0
			dc.b  $C
			dc.b  $C
			dc.b   0
			dc.b  $C
			dc.b  $C
			dc.b   0
			dc.b  $B
			dc.b  $B
			dc.b   0
			dc.b  $B
			dc.b  $B
			dc.b   0
			dc.b  $A
			dc.b  $A
			dc.b   0
			dc.b  $A
			dc.b  $A
			dc.b   0
			dc.b   9
			dc.b   9
			dc.b   0
			dc.b   9
			dc.b   9
			dc.b   0
			dc.b   8
			dc.b   8
			dc.b   0
			dc.b   8
			dc.b   8
			dc.b   0
			dc.b   0
			dc.b $FF
			dc.b   0
unk_205AC8: dc.b   0					; DATA XREF: ROM:00205A22↑o
			dc.b   8
			dc.b   8
			dc.b   0
			dc.b   8
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b   9
			dc.b   0
			dc.b   9
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b  $A
			dc.b   0
			dc.b  $A
			dc.b   0
			dc.b   0
			dc.b  $B
			dc.b  $B
			dc.b   0
			dc.b  $B
			dc.b   0
			dc.b   0
			dc.b  $C
			dc.b  $C
			dc.b   0
			dc.b  $C
			dc.b   0
			dc.b   0
			dc.b  $B
			dc.b  $B
			dc.b   0
			dc.b  $B
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b  $A
			dc.b   0
			dc.b  $A
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b   9
			dc.b   0
			dc.b   9
			dc.b   0
			dc.b   0
			dc.b   8
			dc.b   8
			dc.b   0
			dc.b   8
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $FF
			dc.b   0
unk_205B02: dc.b   0					; DATA XREF: ROM:00205A24↑o
			dc.b   8
			dc.b   0
			dc.b   0
			dc.b   8
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   0
			dc.b   0
			dc.b  $B
			dc.b   0
			dc.b   0
			dc.b  $B
			dc.b   0
			dc.b   0
			dc.b  $C
			dc.b   0
			dc.b   0
			dc.b  $C
			dc.b   0
			dc.b   0
			dc.b  $B
			dc.b   0
			dc.b   0
			dc.b  $B
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b   0
			dc.b   0
			dc.b   8
			dc.b   0
			dc.b   0
			dc.b   8
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $FF
			dc.b   0
obj06_map:
			dc.w byte_205B56+$B-obj06_map
			dc.w byte_205B56-obj06_map
			dc.w byte_205B6B-obj06_map
			dc.w byte_205B80-obj06_map
			dc.w byte_205B95-obj06_map
			dc.w byte_205BAA-obj06_map
			dc.w byte_205BBF-obj06_map
			dc.w byte_205BD4-obj06_map
			dc.w byte_205BEA-obj06_map
			dc.w byte_205C00-obj06_map
			dc.w byte_205C16-obj06_map
			dc.w byte_205C2C-obj06_map
			dc.w byte_205C42-obj06_map
byte_205B56:	dc.b 4						; DATA XREF: ROM:00205B3E↑o
			dc.b $E8, $A,  0,  0,$E8
			dc.b $E8, $A,  0,  9,  0
			dc.b   0, $A,$10,  0,$E8
			dc.b   0, $A,$10,  9,  0
byte_205B6B:	dc.b 4						; DATA XREF: ROM:00205B40↑o
			dc.b $E8, $A,  0,$12,$E8
			dc.b $E8, $A,  0,$1B,  0
			dc.b   0, $A,$10,$12,$E8
			dc.b   0, $A,$10,$1B,  0
byte_205B80:	dc.b 4						; DATA XREF: ROM:00205B42↑o
			dc.b $E8, $A,  8,  9,$E8
			dc.b $E8, $A,  8,  0,  0
			dc.b   0, $A,$18,  9,$E8
			dc.b   0, $A,$18,  0,  0
byte_205B95:	dc.b 4						; DATA XREF: ROM:00205B44↑o
			dc.b $E8, $A,  0,  0,$E8
			dc.b $E8, $A,  0,  9,  0
			dc.b   0, $A,$18,  9,$E8
			dc.b   0, $A,$18,  0,  0
byte_205BAA:	dc.b 4						; DATA XREF: ROM:00205B46↑o
			dc.b $E8, $A,  8,  9,$E8
			dc.b $E8, $A,  8,  0,  0
			dc.b   0, $A,$10,  0,$E8
			dc.b   0, $A,$10,  9,  0
byte_205BBF:	dc.b 4						; DATA XREF: ROM:00205B48↑o
			dc.b $E8, $A,  0,$12,$E8
			dc.b $E8, $A,  0,$1B,  0
			dc.b   0, $A,$18,$1B,$E8
			dc.b   0, $A,$18,$12,  0
byte_205BD4:	dc.b 4						; DATA XREF: ROM:00205B4A↑o
			dc.b $E8, $A,  8,$1B,$E8
			dc.b $E8, $A,  8,$12,  0
			dc.b   0, $A,$10,$12,$E8
			dc.b   0, $A,$10,$1B,  0
			even
byte_205BEA:	dc.b 4						; DATA XREF: ROM:00205B4C↑o
			dc.b $F0,  5,  0,  0,$F0
			dc.b $F0,  5,  8,  0,  0
			dc.b   0,  5,$10,  0,$F0
			dc.b   0,  5,$18,  0,  0
			even
byte_205C00:	dc.b 4						; DATA XREF: ROM:00205B4E↑o
			dc.b $F0,  5,  0,  4,$F0
			dc.b $F0,  5,  8,  4,  0
			dc.b   0,  5,$10,  4,$F0
			dc.b   0,  5,$18,  4,  0
			even
byte_205C16:	dc.b 4						; DATA XREF: ROM:00205B50↑o
			dc.b $E8, $A,  0,  8,$E8
			dc.b $E8, $A,  8,  8,  0
			dc.b   0, $A,$10,  8,$E8
			dc.b   0, $A,$18,  8,  0
			even
byte_205C2C:	dc.b 4						; DATA XREF: ROM:00205B52↑o
			dc.b $F0,  5,  0,$11,$F0
			dc.b $F0,  5,  0,$15,  0
			dc.b   0,  5,$18,$15,$F0
			dc.b   0,  5,$18,$11,  0
			even
byte_205C42:	dc.b 2						; DATA XREF: ROM:00205B54↑o
			dc.b $F4,  6,  0,$19,$F0
			dc.b $F4,  6,  8,$19,  0
			even
obj0B_ani:	dc.w unk_205C54-*			; DATA XREF: ROM:loc_205862↑o
										; ROM:00205C50↓o ...
			dc.w unk_205C5C-obj0B_ani
			dc.w unk_205C62-obj0B_ani
unk_205C54: dc.b   3					; DATA XREF: ROM:obj0B_ani↑o
			dc.b   0
			dc.b   4
			dc.b   3
			dc.b   1
			dc.b   2
			dc.b $FC
			dc.b   0
unk_205C5C: dc.b   3					; DATA XREF: ROM:00205C50↑o
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b $FC
			dc.b   0
unk_205C62: dc.b   3					; DATA XREF: ROM:00205C52↑o
			dc.b   6
			dc.b   5
			dc.b $FC
obj0B_map:	dc.w byte_205C74-*			; DATA XREF: ROM:00205836↑o
										; ROM:00205C68↓o ...
			dc.w byte_205C80-obj0B_map
			dc.w byte_205C8C-obj0B_map
			dc.w byte_205C92-obj0B_map
			dc.w byte_205CA8-obj0B_map
			dc.w byte_205CBE-obj0B_map
			dc.w byte_205CC4-obj0B_map
byte_205C74:	dc.b 2						; DATA XREF: ROM:obj0B_map↑o
			dc.b $F0,  5,  0,  0,$FC
			dc.b $F8,  0,  0,  4,$F4
			even
byte_205C80:	dc.b 2						; DATA XREF: ROM:00205C68↑o
			dc.b $E0,  0,  0,  5,$F8
			dc.b $E8, $E,  0,  6,$F0
			even
byte_205C8C:	dc.b 1						; DATA XREF: ROM:00205C6A↑o
			dc.b $E0, $F,  0,$12,$F0
byte_205C92:	dc.b 4						; DATA XREF: ROM:00205C6C↑o
			dc.b $D0,  6,  0,$22,$F8
			dc.b $D8,  0,  0,$28,$F0
			dc.b $E0,  0,  0,$29,  8
			dc.b $E8, $E,  0,$2A,$F0
			even
byte_205CA8:	dc.b 4						; DATA XREF: ROM:00205C6E↑o
			dc.b $C0,  0,  0,$36,$F8
			dc.b $C8,  6,  0,$37,$F8
			dc.b $D8,  0,  0,$3D,$F0
			dc.b $E0, $F,  0,$3E,$F0
			even
byte_205CBE:	dc.b 1						; DATA XREF: ROM:00205C70↑o
			dc.b $F0,  9,  0,$4E,$F4
byte_205CC4:	dc.b 1						; DATA XREF: ROM:00205C72↑o
			dc.b $F8,  4,  0,$54,$F8
obj0D_ani:	dc.w unk_205CCC-*			; DATA XREF: ROM:loc_2057BE↑o
unk_205CCC: dc.b   0					; DATA XREF: ROM:obj0D_ani↑o
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b   1
			dc.b $FC
obj0D_map:	dc.w byte_205CE8-*			; DATA XREF: ROM:00205786↑o
										; ROM:00205CDA↓o ...
			dc.w byte_205CDC-obj0D_map
byte_205CDC:	dc.b 2						; DATA XREF: ROM:00205CDA↑o
			dc.b $D0,  3,  0,  0,$E4
			dc.b $F0,  1,  0,  4,$E4
			even
byte_205CE8:	dc.b 2						; DATA XREF: ROM:obj0D_map↑o
			dc.b $F8, $C,  0,  6,$E8
			dc.b $F8,  4,  0, $A,  8
			even
obj0E_ani:	dc.w unk_205CF6-*			; DATA XREF: ROM:loc_2056FA↑o
unk_205CF6: dc.b   3					; DATA XREF: ROM:obj0E_ani↑o
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b $FC
			dc.b   0
obj0E_map:	dc.w byte_205D02-*			; DATA XREF: ROM:002056E6↑o
										; ROM:00205CFE↓o ...
			dc.w byte_205D08-obj0E_map
			dc.w byte_205D0E-obj0E_map
byte_205D02:	dc.b 1						; DATA XREF: ROM:obj0E_map↑o
			dc.b $F0, $F,  0,  0,$F0
byte_205D08:	dc.b 1						; DATA XREF: ROM:00205CFE↑o
			dc.b $F4, $A,  0,$10,$F4
byte_205D0E:	dc.b 1						; DATA XREF: ROM:00205D00↑o
			dc.b $F8,  5,  0,$19,$F8
obj18_ani:	dc.w unk_205D18-*			; DATA XREF: ROM:loc_205588↑o
										; ROM:00205D16↓o
			dc.w unk_205D20-obj18_ani
unk_205D18: dc.b   3					; DATA XREF: ROM:obj18_ani↑o
			dc.b   0
			dc.b   5
			dc.b   6
			dc.b   3
			dc.b   4
			dc.b $FC
			dc.b   0
unk_205D20: dc.b   3					; DATA XREF: ROM:00205D16↑o
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b $FC
			dc.b   0
obj18_map:	dc.w byte_205D36-*			; DATA XREF: ROM:00205574↑o
										; ROM:00205D2A↓o ...
			dc.w byte_205D42-obj18_map
			dc.w byte_205D52-obj18_map
			dc.w byte_205D68-obj18_map
			dc.w byte_205D7E-obj18_map
			dc.w byte_205D94-obj18_map
			dc.w byte_205DA4-obj18_map
byte_205D36:	dc.b 2						; DATA XREF: ROM:obj18_map↑o
			dc.b $F8,  5,  0,  0,$F0
			dc.b $F8,  5,  8,  0,  0
			even
byte_205D42:	dc.b 3						; DATA XREF: ROM:00205D2A↑o
			dc.b $F0, $D,  0,  4,$F0
			dc.b   0,  5,  0, $C,$F0
			dc.b   0,  5,  8, $C,  0
byte_205D52:	dc.b 4						; DATA XREF: ROM:00205D2C↑o
			dc.b $F0,  5,  0,$10,$F0
			dc.b $F0,  5,  0,$14,  0
			dc.b   0,  5,  0,$18,$F0
			dc.b   0,  5,$18,$10,  0
			even
byte_205D68:	dc.b 4						; DATA XREF: ROM:00205D2E↑o
			dc.b $E8, $A,  0,$1C,$E8
			dc.b $E8, $A,  8,$1C,  0
			dc.b   0, $A,$10,$1C,$E8
			dc.b   0, $A,$18,$1C,  0
			even
byte_205D7E:	dc.b 4						; DATA XREF: ROM:00205D30↑o
			dc.b $E8, $A,  0,$25,$E8
			dc.b $E8, $A,  8,$25,  0
			dc.b   0, $A,$10,$25,$E8
			dc.b   0, $A,$18,$25,  0
			even
byte_205D94:	dc.b 3						; DATA XREF: ROM:00205D32↑o
			dc.b $F0, $D,  0,$2E,$F0
			dc.b   0,  5,  0,$36,$F0
			dc.b   0,  5,  8,$36,  0
byte_205DA4:	dc.b 4						; DATA XREF: ROM:00205D34↑o
			dc.b $F0,  5,  0,$3A,$F0
			dc.b $F0,  5,  0,$3E,  0
			dc.b   0,  5,  0,$42,$F0
			dc.b   0,  5,$18,$3A,  0
			even
obj1F_ani:	dc.w unk_205DC2-*			; DATA XREF: ROM:loc_20565C↑o
										; ROM:00205DBC↓o ...
			dc.w unk_205DC6-obj1F_ani
			dc.w unk_205DCC-obj1F_ani
			dc.w unk_205DD2-obj1F_ani
unk_205DC2: dc.b   3					; DATA XREF: ROM:obj1F_ani↑o
			dc.b   0
			dc.b   1
			dc.b $FF
unk_205DC6: dc.b   3					; DATA XREF: ROM:00205DBC↑o
			dc.b   2
			dc.b   3
			dc.b   2
			dc.b   3
			dc.b $FC
unk_205DCC: dc.b   1					; DATA XREF: ROM:00205DBE↑o
			dc.b   5
			dc.b   5
			dc.b   4
			dc.b   6
			dc.b $FC
unk_205DD2: dc.b $13					; DATA XREF: ROM:00205DC0↑o
			dc.b   6
			dc.b   7
			dc.b $FF
obj1F_map:	dc.w byte_205DE6-*			; DATA XREF: ROM:002055E8↑o
										; ROM:00205DD8↓o ...
			dc.w byte_205DEC-obj1F_map
			dc.w byte_205DF2-obj1F_map
			dc.w byte_205DF8-obj1F_map
			dc.w byte_205DFE-obj1F_map
			dc.w byte_205E0A-obj1F_map
			dc.w byte_205E10-obj1F_map
			dc.w byte_205E20-obj1F_map
byte_205DE6:	dc.b 1						; DATA XREF: ROM:obj1F_map↑o
			dc.b $F0,  1,  0,  0,$FC
byte_205DEC:	dc.b 1						; DATA XREF: ROM:00205DD8↑o
			dc.b $F0,  1,  8,  0,$FC
byte_205DF2:	dc.b 1						; DATA XREF: ROM:00205DDA↑o
			dc.b $F0,  5,  0,  2,$F8
byte_205DF8:	dc.b 1						; DATA XREF: ROM:00205DDC↑o
			dc.b $F0,  5,  0,  6,$F8
byte_205DFE:	dc.b 2						; DATA XREF: ROM:00205DDE↑o
			dc.b $E8,  9,  0,$1C,$F4
			dc.b $F8,  0,  0,$22,$FC
			even
byte_205E0A:	dc.b 1						; DATA XREF: ROM:00205DE0↑o
			dc.b $F0,  5,  0,$23,$F8
byte_205E10:	dc.b 3						; DATA XREF: ROM:00205DE2↑o
			dc.b $D0, $A,  0, $A,$F4
			dc.b $E8,  9,  0,$1C,$F4
			dc.b $F8,  0,  0,$22,$FC
byte_205E20:	dc.b 3						; DATA XREF: ROM:00205DE4↑o
			dc.b $D0, $A,  0,$13,$F4
			dc.b $E8,  9,  0,$1C,$F4
			dc.b $F8,  0,  0,$22,$FC
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_205EE4
loc_205E30:								; CODE XREF: sub_205EE4+8↓j
			move.b	(byte_FF1255).l,(byte_FF1230).l
			move.w	(word_FF1256).l,obj.xpos(a6)
			move.w	(word_FF1258).l,obj.ypos(a6)
			move.b	(byte_FF125A).l,(byte_FFF742).w
			move.b	(byte_FF1270).l,(byte_FFF64D).w
			move.w	(word_FF125C).l,(dword_FFF72C+2).w
			move.w	(word_FF125C).l,(dword_FFF724+2).w
			move.w	(word_FF125E).l,(dword_FFF700).w
			move.w	(word_FF1260).l,(dword_FFF704).w
			move.w	(word_FF1262).l,(dword_FFF708).w
			move.w	(word_FF1264).l,(dword_FFF70C).w
			move.w	(word_FF1266).l,(dword_FFF710).w
			move.w	(word_FF1268).l,(word_FFF714).w
			move.w	(word_FF126A).l,(dword_FFF718).w
			move.w	(word_FF126C).l,(word_FFF71C).w
			cmpi.b	#zoneid_LZ,(zone).l
			bne.s	loc_205ECC
			move.w	(word_FF126E).l,(word_FFF648).w
			move.b	(byte_FF1270).l,(byte_FFF64D).w
			move.b	(byte_FF1271).l,(byte_FFF64E).w
loc_205ECC:								; CODE XREF: sub_205EE4-32↑j
			tst.b	(byte_FF1230).l
			bpl.s	locret_205EE2
			move.w	(word_FF1256).l,d0
			subi.w	#160,d0
			move.w	d0,(dword_FFF728).w
locret_205EE2:							; CODE XREF: sub_205EE4-12↑j
			rts
; END OF FUNCTION CHUNK FOR sub_205EE4
; =============== S U B R O U T I N E =======================================
sub_205EE4:								; CODE XREF: sub_2023FC+88↑p
; FUNCTION CHUNK AT 00205E30 SIZE 000000B4 BYTES
			cmpi.b	#2,(byte_FF1230).l
			beq.w	loc_205E30
			move.b	(byte_FF1231).l,(byte_FF1230).l
			move.w	(word_FF1232).l,obj.xpos(a6)
			move.w	(word_FF1234).l,obj.ypos(a6)
			move.w	(word_FF1236).l,(word_FF1220).l
			move.b	(byte_FF1254).l,(byte_FF121B).l
			clr.w	(word_FF1220).l
			clr.b	(byte_FF121B).l
			move.l	(dword_FF1238).l,(byte_FF1222).l
			move.b	#59,(byte_FF1225).l
			subq.b	#1,(byte_FF1224).l
			move.b	(byte_FF123C).l,(byte_FFF742).w
			move.b	(byte_FF1252).l,(byte_FFF64D).w
			move.w	(word_FF123E).l,(dword_FFF72C+2).w
			move.w	(word_FF123E).l,(dword_FFF724+2).w
			move.w	(word_FF1240).l,(dword_FFF700).w
			move.w	(word_FF1242).l,(dword_FFF704).w
			move.w	(word_FF1244).l,(dword_FFF708).w
			move.w	(word_FF1246).l,(dword_FFF70C).w
			move.w	(word_FF1248).l,(dword_FFF710).w
			move.w	(word_FF124A).l,(word_FFF714).w
			move.w	(word_FF124C).l,(dword_FFF718).w
			move.w	(word_FF124E).l,(word_FFF71C).w
			cmpi.b	#zoneid_LZ,(zone).l
			bne.s	loc_205FC4
			move.w	(word_FF1250).l,(word_FFF648).w
			move.b	(byte_FF1252).l,(byte_FFF64D).w
			move.b	(byte_FF1253).l,(byte_FFF64E).w
loc_205FC4:								; CODE XREF: sub_205EE4+C6↑j
			tst.b	(byte_FF1230).l
			bpl.s	locret_205FDA
			move.w	(word_FF1232).l,d0
			subi.w	#160,d0
			move.w	d0,(dword_FFF728).w
locret_205FDA:							; CODE XREF: sub_205EE4+E6↑j
			rts
; End of function sub_205EE4
; =============== S U B R O U T I N E =======================================
sub_205FDC:								; CODE XREF: sub_20409A+324↑p
; FUNCTION CHUNK AT 002060F2 SIZE 0000002A BYTES
; FUNCTION CHUNK AT 002061C6 SIZE 00000020 BYTES
; FUNCTION CHUNK AT 0020628E SIZE 00000024 BYTES
; FUNCTION CHUNK AT 00206364 SIZE 00000024 BYTES
			move.l	obj.xpos(a0),d3
			move.l	obj.ypos(a0),d2
			move.w	obj.xvel(a0),d1
			ext.l	d1
			asl.l	#8,d1
			add.l	d1,d3
			move.w	obj.yvel(a0),d1
			ext.l	d1
			asl.l	#8,d1
			add.l	d1,d2
			swap	d2
			swap	d3
			move.b	d0,(byte_FFF768).w
			move.b	d0,(byte_FFF76A).w
			move.b	d0,d1
			addi.b	#$20,d0
			bpl.s	loc_206018
			move.b	d1,d0
			bpl.s	loc_206012
			subq.b	#1,d0
loc_206012:								; CODE XREF: sub_205FDC+32↑j
			addi.b	#$20,d0
			bra.s	loc_206022
; ---------------------------------------------------------------------------
loc_206018:								; CODE XREF: sub_205FDC+2E↑j
			move.b	d1,d0
			bpl.s	loc_20601E
			addq.b	#1,d0
loc_20601E:								; CODE XREF: sub_205FDC+3E↑j
			addi.b	#$1F,d0
loc_206022:								; CODE XREF: sub_205FDC+3A↑j
			andi.b	#$C0,d0
			beq.w	loc_2060F2
			cmpi.b	#$80,d0
			beq.w	loc_20628E
			andi.b	#$38,d1
			bne.s	loc_20603A
			addq.w	#8,d2
loc_20603A:								; CODE XREF: sub_205FDC+5A↑j
			cmpi.b	#$40,d0
			beq.w	loc_206364
			bra.w	loc_2061C6
; End of function sub_205FDC
; =============== S U B R O U T I N E =======================================
sub_206046:								; CODE XREF: sub_20484C+62↑p
			move.b	d0,(byte_FFF768).w
			move.b	d0,(byte_FFF76A).w
			addi.b	#$20,d0
			andi.b	#$C0,d0
			cmpi.b	#$40,d0
			beq.w	loc_2062EC
			cmpi.b	#$80,d0
			beq.w	sub_206216
			cmpi.b	#$C0,d0
			beq.w	loc_206156
loc_20606E:								; CODE XREF: sub_204A8C:loc_204AF0↑p
										; sub_204A8C+11E↑p ...
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d3
			lea	(byte_FFF768).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$D,d5
			jsr	(sub_200E82).l
			move.w	d1,-(sp)
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			sub.w	d0,d3
			lea	(byte_FFF76A).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$D,d5
			jsr	(sub_200E82).l
			move.w	(sp)+,d0
			move.b	#0,d2
loc_2060D2:								; CODE XREF: sub_206046+174↓j
										; sub_206216+6C↓j ...
			move.b	(byte_FFF76A).w,d3
			cmp.w	d0,d1
			ble.s	loc_2060E0
			move.b	(byte_FFF768).w,d3
			exg.l	d0,d1
loc_2060E0:								; CODE XREF: sub_206046+92↑j
			btst	#0,d3
			beq.s	locret_2060E8
			move.b	d2,d3
locret_2060E8:							; CODE XREF: sub_206046+9E↑j
			rts
; End of function sub_206046
; ---------------------------------------------------------------------------
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3

loc_2060F2:								; CODE XREF: sub_205FDC+4A↑j
			addi.w	#$A,d2
			lea	(byte_FFF768).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$E,d5
			jsr	(sub_200E82).l
			move.b	#0,d2
loc_20610E:								; CODE XREF: sub_205FDC+206↓j
										; sub_205FDC+2D2↓j ...
			move.b	(byte_FFF768).w,d3
			btst	#0,d3
			beq.s	locret_20611A
			move.b	d2,d3
locret_20611A:							; CODE XREF: sub_205FDC+13A↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_20611C:								; CODE XREF: sub_20409A:loc_204148↑p
										; ROM:loc_20561A↑p ...
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d2
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d2
			lea	(byte_FFF768).w,a4
			move.b	#0,(a4)
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$D,d5
			jsr	(sub_200E82).l
			move.b	(byte_FFF768).w,d3
			btst	#0,d3
			beq.s	locret_206154
			move.b	#0,d3
locret_206154:							; CODE XREF: sub_20611C+32↑j
			rts
; End of function sub_20611C
; ---------------------------------------------------------------------------
loc_206156:								; CODE XREF: sub_206046+24↑j
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_17(a0),d0
			ext.w	d0
			sub.w	d0,d2
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d3
			lea	(byte_FFF768).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$E,d5
			jsr	(sub_200FF2).l
			move.w	d1,-(sp)
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d3
			lea	(byte_FFF76A).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$E,d5
			jsr	(sub_200FF2).l
			move.w	(sp)+,d0
			move.b	#-$40,d2
			bra.w	loc_2060D2
; =============== S U B R O U T I N E =======================================
sub_2061BE:								; CODE XREF: sub_204A8C:loc_204ADE↑p
										; sub_204A8C:loc_204BE4↑p ...
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
; End of function sub_2061BE

loc_2061C6:								; CODE XREF: sub_205FDC+66↑j
			addi.w	#$A,d3
			lea	(byte_FFF768).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$E,d5
			jsr	(sub_200FF2).l
			move.b	#-$40,d2
			bra.w	loc_20610E
; =============== S U B R O U T I N E =======================================
sub_2061E6:								; CODE XREF: ROM:0020A4BE↓p
			add.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d2
			lea	(byte_FFF768).w,a4
			move.b	#0,(a4)
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$E,d5
			jsr	(sub_200FF2).l
			move.b	(byte_FFF768).w,d3
			btst	#0,d3
			beq.s	locret_206214
			move.b	#-$40,d3
locret_206214:							; CODE XREF: sub_2061E6+28↑j
			rts
; End of function sub_2061E6
; =============== S U B R O U T I N E =======================================
sub_206216:								; CODE XREF: ROM:0020475C↑p
										; sub_204A8C:loc_204B8A↑p ...
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d2
			eori.w	#$F,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d3
			lea	(byte_FFF768).w,a4
			movea.w #-$10,a3
			move.w	#$1000,d6
			moveq	#$E,d5
			jsr	(sub_200E82).l
			move.w	d1,-(sp)
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d2
			eori.w	#$F,d2
			move.b	obj.field_17(a0),d0
			ext.w	d0
			sub.w	d0,d3
			lea	(byte_FFF76A).w,a4
			movea.w #-$10,a3
			move.w	#$1000,d6
			moveq	#$E,d5
			jsr	(sub_200E82).l
			move.w	(sp)+,d0
			move.b	#$80,d2
			bra.w	loc_2060D2
; End of function sub_206216
; ---------------------------------------------------------------------------
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3

loc_20628E:								; CODE XREF: sub_205FDC+52↑j
			subi.w	#$A,d2
			eori.w	#$F,d2
			lea	(byte_FFF768).w,a4
			movea.w #-$10,a3
			move.w	#$1000,d6
			moveq	#$E,d5
			jsr	(sub_200E82).l
			move.b	#$80,d2
			bra.w	loc_20610E
; =============== S U B R O U T I N E =======================================
sub_2062B2:								; CODE XREF: ROM:0020D9A6↓p
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d2
			eori.w	#$F,d2
			lea	(byte_FFF768).w,a4
			movea.w #-$10,a3
			move.w	#$1000,d6
			moveq	#$E,d5
			jsr	(sub_200E82).l
			move.b	(byte_FFF768).w,d3
			btst	#0,d3
			beq.s	locret_2062EA
			move.b	#$80,d3
locret_2062EA:							; CODE XREF: sub_2062B2+32↑j
			rts
; End of function sub_2062B2
; ---------------------------------------------------------------------------
loc_2062EC:								; CODE XREF: sub_206046+14↑j
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_17(a0),d0
			ext.w	d0
			sub.w	d0,d2
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d3
			eori.w	#$F,d3
			lea	(byte_FFF768).w,a4
			movea.w #-$10,a3
			move.w	#$800,d6
			moveq	#$E,d5
			jsr	(sub_200FF2).l
			move.w	d1,-(sp)
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.field_17(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.field_16(a0),d0
			ext.w	d0
			sub.w	d0,d3
			eori.w	#$F,d3
			lea	(byte_FFF76A).w,a4
			movea.w #-$10,a3
			move.w	#$800,d6
			moveq	#$E,d5
			jsr	(sub_200FF2).l
			move.w	(sp)+,d0
			move.b	#$40,d2
			bra.w	loc_2060D2
; =============== S U B R O U T I N E =======================================
sub_20635C:								; CODE XREF: sub_204A8C+40↑p
										; sub_204A8C:loc_204B70↑p ...
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
; End of function sub_20635C
loc_206364:								; CODE XREF: sub_205FDC+62↑j
			subi.w	#$A,d3
			eori.w	#$F,d3
			lea	(byte_FFF768).w,a4
			movea.w #-$10,a3
			move.w	#$800,d6
			moveq	#$E,d5
			jsr	(sub_200FF2).l
			move.b	#$40,d2
			bra.w	loc_20610E
; =============== S U B R O U T I N E =======================================
sub_206388:								; CODE XREF: ROM:0020A44E↓p
			add.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d2
			lea	(byte_FFF768).w,a4
			move.b	#0,(a4)
			movea.w #-$10,a3
			move.w	#$800,d6
			moveq	#$E,d5
			jsr	(sub_200FF2).l
			move.b	(byte_FFF768).w,d3
			btst	#0,d3
			beq.s	locret_2063B6
			move.b	#$40,d3
locret_2063B6:							; CODE XREF: sub_206388+28↑j
			rts
; End of function sub_206388
; =============== S U B R O U T I N E =======================================
sub_2063B8:								; CODE XREF: ROM:00203D42↑p
			nop
			move.w	obj.xpos(a0),d2
			move.w	obj.ypos(a0),d3
			subq.w	#8,d2
			moveq	#0,d5
			move.b	obj.field_16(a0),d5
			subq.b	#3,d5
			sub.w	d5,d3
			cmpi.b	#$39,obj.frame(a0)
			bne.s	loc_2063DC
			addi.w	#$C,d3
			moveq	#$A,d5
loc_2063DC:								; CODE XREF: sub_2063B8+1C↑j
			move.w	#$10,d4
			add.w	d5,d5
			lea	(byte_FFD800).w,a1
			move.w	#$5F,d6 ; '_'
loc_2063EA:								; CODE XREF: sub_2063B8+42↓j
			tst.b	obj.render(a1)
			bpl.s	loc_2063F6
			move.b	obj.colflag(a1),d0
			bne.s	loc_20644A
loc_2063F6:								; CODE XREF: sub_2063B8+36↑j
										; sub_2063B8+B0↓j ...
			lea	obj(a1),a1
			dbf	d6,loc_2063EA
			moveq	#0,d0
locret_206400:							; DATA XREF: sub_2063B8+98↓o
			rts
; ---------------------------------------------------------------------------
			dc.b $14,$14
			dc.b  $C,$14
			dc.b $14, $C
			dc.b   4,$10
			dc.b  $C,$12
			dc.b $10,$10
			dc.b   6,  6
			dc.b $18, $C
			dc.b  $C,$10
			dc.b $10, $C
			dc.b   8,  8
			dc.b $14,$10
			dc.b $14,  8
			dc.b  $E, $E
			dc.b $18,$18
			dc.b $28,$10
			dc.b $10,$18
			dc.b   8,$10
			dc.b $20,$70
			dc.b $40,$20
			dc.b $80,$20
			dc.b $20,$20
			dc.b   8,  8
			dc.b   4,  4
			dc.b $20,  8
			dc.b  $C, $C
			dc.b   8,  4
			dc.b $18,  4
			dc.b $28,  4
			dc.b   4,  8
			dc.b   4,$18
			dc.b   4,$28
			dc.b   4,$20
			dc.b $18,$18
			dc.b  $C,$18
			dc.b $48,  8
; ---------------------------------------------------------------------------
loc_20644A:								; CODE XREF: sub_2063B8+3C↑j
			andi.w	#$3F,d0
			add.w	d0,d0
			lea	locret_206400(pc,d0.w),a2
			moveq	#0,d1
			move.b	(a2)+,d1
			move.w	obj.xpos(a1),d0
			sub.w	d1,d0
			sub.w	d2,d0
			bcc.s	loc_20646C
			add.w	d1,d1
			add.w	d1,d0
			bcs.s	loc_206472
			bra.w	loc_2063F6
; ---------------------------------------------------------------------------
loc_20646C:								; CODE XREF: sub_2063B8+A8↑j
			cmp.w	d4,d0
			bhi.w	loc_2063F6
loc_206472:								; CODE XREF: sub_2063B8+AE↑j
			moveq	#0,d1
			move.b	(a2)+,d1
			move.w	obj.ypos(a1),d0
			sub.w	d1,d0
			sub.w	d3,d0
			bcc.s	loc_20648A
			add.w	d1,d1
			add.w	d0,d1
			bcs.s	loc_206490
			bra.w	loc_2063F6
; ---------------------------------------------------------------------------
loc_20648A:								; CODE XREF: sub_2063B8+C6↑j
			cmp.w	d5,d0
			bhi.w	loc_2063F6
loc_206490:								; CODE XREF: sub_2063B8+CC↑j
			move.b	obj.colflag(a1),d1
			andi.b	#$C0,d1
			beq.w	loc_206504
			cmpi.b	#$C0,d1
			beq.w	loc_2066C2
			tst.b	d1
			bmi.w	loc_2065C0
			move.b	obj.colflag(a1),d0
			andi.b	#$3F,d0
			cmpi.b	#6,d0
			beq.s	loc_2064C8
			cmpi.w	#90,obj.field_30(a0)
			bcc.w	locret_2064C6
			addq.b	#2,obj.routine(a1)
locret_2064C6:							; CODE XREF: sub_2063B8+106↑j
			rts
; ---------------------------------------------------------------------------
loc_2064C8:								; CODE XREF: sub_2063B8+FE↑j
			tst.w	obj.yvel(a0)
			bpl.s	loc_2064F2
			move.w	obj.ypos(a0),d0
			subi.w	#$10,d0
			cmp.w	obj.ypos(a1),d0
			bcs.s	locret_206502
			neg.w	obj.yvel(a0)
			move.w	#-$180,obj.yvel(a1)
			tst.b	obj.routine2(a1)
			bne.s	locret_206502
			addq.b	#4,obj.routine2(a1)
			rts
; ---------------------------------------------------------------------------
loc_2064F2:								; CODE XREF: sub_2063B8+114↑j
			cmpi.b	#2,obj.ani(a0)
			bne.s	locret_206502
			neg.w	obj.yvel(a0)
			addq.b	#2,obj.routine(a1)
locret_206502:							; CODE XREF: sub_2063B8+122↑j
										; sub_2063B8+132↑j ...
			rts
; ---------------------------------------------------------------------------
loc_206504:								; CODE XREF: sub_2063B8+E0↑j
										; sub_2063B8:loc_20671C↓j
			tst.b	(byte_FF122D).l
			bne.s	loc_206516
			cmpi.b	#2,obj.ani(a0)
			bne.w	loc_2065C0
loc_206516:								; CODE XREF: sub_2063B8+152↑j
			tst.b	obj.field_21(a1)
			beq.s	loc_206540
			neg.w	obj.xvel(a0)
			neg.w	obj.yvel(a0)
			asr.w	obj.xvel(a0)
			asr.w	obj.yvel(a0)
			move.b	#0,obj.colflag(a1)
			subq.b	#1,obj.field_21(a1)
			bne.s	locret_20653E
			bset	#7,obj.status(a1)
locret_20653E:							; CODE XREF: sub_2063B8+17E↑j
			rts
; ---------------------------------------------------------------------------
loc_206540:								; CODE XREF: sub_2063B8+162↑j
			bset	#7,obj.status(a1)
			moveq	#0,d0
			move.w	(word_FFF7D0).w,d0
			addq.w	#2,(word_FFF7D0).w
			cmpi.w	#6,d0
			bcs.s	loc_206558
			moveq	#6,d0
loc_206558:								; CODE XREF: sub_2063B8+19C↑j
			move.w	d0,obj.field_3E(a1)
			move.w	word_2065B2(pc,d0.w),d0
			cmpi.w	#$20,(word_FFF7D0).w
			bcs.s	loc_206572
			move.w	#1000,d0
			move.w	#$A,obj.field_3E(a1)
loc_206572:								; CODE XREF: sub_2063B8+1AE↑j
			bsr.w	sub_209810
			move.w	#$9E,d0
			jsr	(queuesound2).l
			move.b	#$18,obj.id(a1)
			move.b	#0,obj.routine(a1)
			tst.w	obj.yvel(a0)
			bmi.s	loc_2065A2
			move.w	obj.ypos(a0),d0
			cmp.w	obj.ypos(a1),d0
			bcc.s	loc_2065AA
			neg.w	obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_2065A2:								; CODE XREF: sub_2063B8+1D8↑j
			addi.w	#$100,obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_2065AA:								; CODE XREF: sub_2063B8+1E2↑j
			subi.w	#$100,obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
word_2065B2:	dc.w 10						; DATA XREF: sub_2063B8+1A4↑r
			dc.w 20
			dc.w 50
			dc.w 100
; ---------------------------------------------------------------------------
loc_2065BA:								; CODE XREF: sub_2063B8:loc_2066EA↓j
			bset	#7,obj.status(a1)
loc_2065C0:								; CODE XREF: sub_2063B8+EE↑j
										; sub_2063B8+15A↑j ...
			tst.b	(byte_FF122D).l
			beq.s	loc_2065CC
loc_2065C8:								; CODE XREF: sub_2063B8+21A↓j
			moveq	#-1,d0
			rts
; ---------------------------------------------------------------------------
loc_2065CC:								; CODE XREF: sub_2063B8+20E↑j
			nop
			tst.w	obj.field_30(a0)
			bne.s	loc_2065C8
			movea.l a1,a2
			tst.b	(byte_FF122C).l
			bne.s	loc_206602
			tst.w	(word_FF1220).l
			beq.w	loc_20665E
			jsr	(findfreeobj).l
			bne.s	loc_206602
			move.b	#$11,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
loc_206602:								; CODE XREF: sub_2063B8+224↑j
										; sub_2063B8+236↑j ...
			move.b	#0,(byte_FF122C).l
			move.b	#4,obj.routine(a0)
			bsr.w	sub_204C90
			bset	#1,obj.status(a0)
			move.w	#-$400,obj.yvel(a0)
			move.w	#-$200,obj.xvel(a0)
			btst	#6,obj.status(a0)
			beq.s	loc_20663A
			move.w	#-$200,obj.yvel(a0)
			move.w	#-$100,obj.xvel(a0)
loc_20663A:								; CODE XREF: sub_2063B8+274↑j
			move.w	obj.xpos(a0),d0
			cmp.w	obj.xpos(a2),d0
			bcs.s	loc_206648
			neg.w	obj.xvel(a0)
loc_206648:								; CODE XREF: sub_2063B8+28A↑j
			move.w	#0,obj.inertia(a0)
			move.b	#$1A,obj.ani(a0)
			move.w	#120,obj.field_30(a0)
			moveq	#-1,d0
			rts
; ---------------------------------------------------------------------------
loc_20665E:								; CODE XREF: sub_2063B8+22C↑j
			tst.w	(word_FF13FA).l
			bne.w	loc_206602
loc_206668:								; CODE XREF: sub_20477E:loc_2047C0↑j
										; sub_204D22+C↑j ...
			tst.w	(word_FF1208).l
			bne.s	loc_2066BE
			tst.b	obj.field_29(a0)
			beq.w	deleteobj
			move.b	#0,(byte_FF122D).l
			move.b	#6,obj.routine(a0)
			bsr.w	sub_204C90
			bset	#1,obj.status(a0)
			move.w	#-$700,obj.yvel(a0)
			move.w	#0,obj.xvel(a0)
			move.w	#0,obj.inertia(a0)
			move.w	obj.ypos(a0),obj.field_38(a0)
			move.b	#$18,obj.ani(a0)
			bset	#7,obj.vram(a0)
			move.w	#$93,d0
			jsr	(queuesound2).l
loc_2066BE:								; CODE XREF: sub_2063B8+2B6↑j
			moveq	#-1,d0
			rts
; ---------------------------------------------------------------------------
loc_2066C2:								; CODE XREF: sub_2063B8+E8↑j
			move.b	obj.colflag(a1),d1
			andi.b	#$3F,d1
			cmpi.b	#$1F,d1
			beq.s	loc_206720
			cmpi.b	#$B,d1
			beq.s	loc_2066EA
			cmpi.b	#$C,d1
			beq.s	loc_2066EE
			cmpi.b	#$17,d1
			beq.s	loc_206720
			cmpi.b	#$21,d1 ; '!'
			beq.s	loc_206720
			rts
; ---------------------------------------------------------------------------
loc_2066EA:								; CODE XREF: sub_2063B8+31C↑j
			bra.w	loc_2065BA
; ---------------------------------------------------------------------------
loc_2066EE:								; CODE XREF: sub_2063B8+322↑j
			sub.w	d0,d5
			cmpi.w	#8,d5
			bcc.s	loc_20671C
			move.w	obj.xpos(a1),d0
			subq.w	#4,d0
			btst	#0,obj.status(a1)
			beq.s	loc_206708
			subi.w	#$10,d0
loc_206708:								; CODE XREF: sub_2063B8+34A↑j
			sub.w	d2,d0
			bcc.s	loc_206714
			addi.w	#$18,d0
			bcs.s	loc_206718
			bra.s	loc_20671C
; ---------------------------------------------------------------------------
loc_206714:								; CODE XREF: sub_2063B8+352↑j
			cmp.w	d4,d0
			bhi.s	loc_20671C
loc_206718:								; CODE XREF: sub_2063B8+358↑j
			bra.w	loc_2065C0
; ---------------------------------------------------------------------------
loc_20671C:								; CODE XREF: sub_2063B8+33C↑j
										; sub_2063B8+35A↑j ...
			bra.w	loc_206504
; ---------------------------------------------------------------------------
loc_206720:								; CODE XREF: sub_2063B8+316↑j
										; sub_2063B8+328↑j ...
			addq.b	#1,obj.field_21(a1)
			cmpa.w	#actwk,a0
			beq.s	locret_20672E
			addq.b	#1,obj.field_21(a1)
locret_20672E:							; CODE XREF: sub_2063B8+370↑j
			rts
; End of function sub_2063B8
; ---------------------------------------------------------------------------
obj04:									; DATA XREF: ROM:002034BA↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_206750(pc,d0.w),d0
			jsr	off_206750(pc,d0.w)
			lea	(obj04_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
off_206750: dc.w loc_206754-*			; CODE XREF: ROM:0020673A↑p
										; DATA XREF: ROM:00206736↑r ...
			dc.w loc_20678C-off_206750
; ---------------------------------------------------------------------------
loc_206754:								; DATA XREF: ROM:off_206750↑o
			addq.b	#2,obj.routine(a0)
			move.l	#obj04_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.w	#$3BA,obj.vram(a0)
			andi.w	#$FFF0,obj.ypos(a0)
			move.w	obj.ypos(a0),obj.field_2A(a0)
			addi.w	#$180,obj.field_2A(a0)
			rts
; ---------------------------------------------------------------------------
loc_20678C:								; DATA XREF: ROM:00206752↑o
			move.w	obj.ypos(a0),d0
			addq.w	#4,d0
			cmp.w	obj.field_2A(a0),d0
			bcs.s	loc_20679E
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_20679E:								; CODE XREF: ROM:00206796↑j
			move.w	d0,obj.ypos(a0)
			moveq	#2,d3
			bset	#$D,d3
			move.w	obj.ypos(a0),d4
			move.w	obj.xpos(a0),d5
			subi.w	#$60,d5
			move.w	d4,d6
			andi.w	#$F,d6
			bne.s	locret_2067CC
			moveq	#$B,d6
loc_2067BE:								; CODE XREF: ROM:002067C8↓j
			jsr	(sub_202DD2).l
			addi.w	#$10,d5
			dbf	d6,loc_2067BE
locret_2067CC:							; CODE XREF: ROM:002067BA↑j
			rts
; ---------------------------------------------------------------------------
obj08:									; DATA XREF: ROM:002034CA↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_206824(pc,d0.w),d0
			jsr	off_206824(pc,d0.w)
			lea	(obj06_ani).l,a1
			bsr.w	animateobj
			jsr	(displaysprite).l
			move.w	obj.xpos(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bhi.s	loc_20680A
			rts
; ---------------------------------------------------------------------------
loc_20680A:								; CODE XREF: ROM:00206806↑j
			lea	(unk_FF1400).l,a2
			moveq	#0,d0
			move.b	obj.field_23(a0),d0
			beq.s	loc_20681E
			bclr	#7,2(a2,d0.w)
loc_20681E:								; CODE XREF: ROM:00206816↑j
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
off_206824: dc.w loc_206828-*			; CODE XREF: ROM:002067D8↑p
										; DATA XREF: ROM:002067D4↑r ...
			dc.w loc_206846-off_206824
; ---------------------------------------------------------------------------
loc_206828:								; DATA XREF: ROM:off_206824↑o
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.l	#obj06_map,obj.mappings(a0)
			move.w	#$541,obj.vram(a0)
loc_206846:								; DATA XREF: ROM:00206826↑o
			lea	(actwk).w,a1
			bsr.w	sub_206886
			bcs.s	loc_20685A
			lea	(byte_FFD040).w,a1
			bsr.w	sub_206886
			bcc.s	locret_206884
loc_20685A:								; CODE XREF: ROM:0020684E↑j
			move.b	#0,obj.routine(a0)
			move.b	#5,obj.id(a0)
			move.w	#$1940,obj.xpos(a0)
			move.w	#$2D0,obj.ypos(a0)
			move.b	#9,obj.field_2E(a0)
			move.b	#$17,obj.field_2C(a0)
			move.b	#$2B,obj.field_2A(a0) ; '+'
locret_206884:							; CODE XREF: ROM:00206858↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_206886:								; CODE XREF: ROM:0020684A↑p
										; ROM:00206854↑p
			moveq	#0,d0
			move.w	obj.xpos(a1),d0
			sub.w	obj.xpos(a0),d0
			addi.w	#$10,d0
			cmpi.w	#$20,d0
			bcc.s	locret_2068AA
			move.w	obj.ypos(a1),d0
			sub.w	obj.ypos(a0),d0
			addi.w	#$10,d0
			cmpi.w	#$20,d0
locret_2068AA:							; CODE XREF: sub_206886+12↑j
			rts
; End of function sub_206886
; ---------------------------------------------------------------------------
obj05:									; DATA XREF: ROM:002034BE↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2068BA(pc,d0.w),d0
			jmp	off_2068BA(pc,d0.w)
; ---------------------------------------------------------------------------
off_2068BA: dc.w loc_2068BE-*			; CODE XREF: ROM:002068B6↑j
										; DATA XREF: ROM:002068B2↑r ...
			dc.w loc_2068C8-off_2068BA
; ---------------------------------------------------------------------------
loc_2068BE:								; DATA XREF: ROM:off_2068BA↑o
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
loc_2068C8:								; DATA XREF: ROM:002068BC↑o
			move.b	(dword_FF120C+3).l,d0
			andi.b	#$F,d0
			bne.s	locret_206930
			subq.b	#1,obj.field_2E(a0)
			bne.s	loc_2068E0
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_2068E0:								; CODE XREF: ROM:002068D8↑j
			lea	(lvllayoutbuffer).w,a4
			move.w	obj.ypos(a0),d4
			moveq	#0,d0
			move.b	obj.field_2A(a0),d0
loc_2068EE:								; CODE XREF: ROM:0020692C↓j
			movem.l d0/a0,-(sp)
			move.w	obj.xpos(a0),d5
			moveq	#0,d6
			move.b	obj.field_2C(a0),d6
loc_2068FC:								; CODE XREF: ROM:00206920↓j
			movem.l d4-d5,-(sp)
			subi.w	#$10,d4
			jsr	(loc_202D50).l
			bne.s	loc_206910
			moveq	#0,d3
			bra.s	loc_206912
; ---------------------------------------------------------------------------
loc_206910:								; CODE XREF: ROM:0020690A↑j
			move.w	(a0),d3
loc_206912:								; CODE XREF: ROM:0020690E↑j
			movem.l (sp)+,d4-d5
			jsr	(sub_202DD2).l
			addi.w	#$10,d5
			dbf	d6,loc_2068FC
			movem.l (sp)+,d0/a0
			subi.w	#$10,d4
			dbf	d0,loc_2068EE
locret_206930:							; CODE XREF: ROM:002068D2↑j
			rts
; ---------------------------------------------------------------------------
			movem.l (sp)+,d4-d5
			movem.l (sp)+,d0/a0
			rts
; ---------------------------------------------------------------------------
obj04_ani:	dc.w unk_20693E-*			; DATA XREF: ROM:0020673E↑o
unk_20693E: dc.b   4					; DATA XREF: ROM:obj04_ani↑o
			dc.b   0
			dc.b   1
			dc.b $FF
obj04_map:	dc.w byte_206946-*			; DATA XREF: ROM:00206758↑o
										; ROM:00206944↓o ...
			dc.w byte_206966-obj04_map
byte_206946:	dc.b 6						; DATA XREF: ROM:obj04_map↑o
			dc.b $F0, $F,  0,  0,$A0
			dc.b $F0, $F,  0,  0,$C0
			dc.b $F0, $F,  0,  0,$E0
			dc.b $F0, $F,  0,  0,  0
			dc.b $F0, $F,  0,  0,$20
			dc.b $F0, $F,  0,  0,$40
			even
byte_206966:	dc.b 6						; DATA XREF: ROM:00206944↑o
			dc.b $F0, $F,  0,$10,$A0
			dc.b $F0, $F,  0,$10,$C0
			dc.b $F0, $F,  0,$10,$E0
			dc.b $F0, $F,  0,$10,  0
			dc.b $F0, $F,  0,$10,$20
			dc.b $F0, $F,  0,$10,$40
			even
; ---------------------------------------------------------------------------
			move.b	(word_FFF604).w,d0
			andi.b	#$F,d0
			bne.s	loc_20699C
			move.l	#$4000,(dword_206B16).l
			bra.s	loc_2069BC
; ---------------------------------------------------------------------------
loc_20699C:								; CODE XREF: ROM:0020698E↑j
			addi.l	#$2000,(dword_206B16).l
			cmpi.l	#$80000,(dword_206B16).l
			bls.s	loc_2069BC
			move.l	#$80000,(dword_206B16).l
loc_2069BC:								; CODE XREF: ROM:0020699A↑j
										; ROM:002069B0↑j
			move.l	(dword_206B16).l,d0
			btst	#0,(word_FFF604).w
			beq.s	loc_2069CE
			sub.l	d0,obj.ypos(a0)
loc_2069CE:								; CODE XREF: ROM:002069C8↑j
			btst	#1,(word_FFF604).w
			beq.s	loc_2069DA
			add.l	d0,obj.ypos(a0)
loc_2069DA:								; CODE XREF: ROM:002069D4↑j
			btst	#2,(word_FFF604).w
			beq.s	loc_2069E6
			sub.l	d0,obj.xpos(a0)
loc_2069E6:								; CODE XREF: ROM:002069E0↑j
			btst	#3,(word_FFF604).w
			beq.s	loc_2069F2
			add.l	d0,obj.xpos(a0)
loc_2069F2:								; CODE XREF: ROM:002069EC↑j
			move.w	obj.ypos(a0),d2
			move.b	obj.field_16(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.w	obj.xpos(a0),d3
			jsr	(sub_200E0C).l
			move.w	(a1),(word_FF1884).l
			lea	(byte_206B1A).l,a2
			btst	#6,(word_FFF604+1).w
			beq.s	loc_206A34
			moveq	#0,d1
			move.b	(byte_FF1206).l,d1
			addq.b	#1,d1
			cmp.b	(a2),d1
			bcs.s	loc_206A2E
			move.b	#0,d1
loc_206A2E:								; CODE XREF: ROM:00206A28↑j
			move.b	d1,(byte_FF1206).l
loc_206A34:								; CODE XREF: ROM:00206A1A↑j
			btst	#7,(word_FFF604+1).w
			beq.s	loc_206A54
			moveq	#0,d1
			move.b	(byte_FF1206).l,d1
			subq.b	#1,d1
			cmpi.b	#$FF,d1
			bne.s	loc_206A4E
			move.b	(a2),d1
loc_206A4E:								; CODE XREF: ROM:00206A4A↑j
			move.b	d1,(byte_FF1206).l
loc_206A54:								; CODE XREF: ROM:00206A3A↑j
			moveq	#0,d1
			move.b	(byte_FF1206).l,d1
			mulu.w	#$C,d1
			move.l	4(a2,d1.w),obj.mappings(a0)
			move.w	8(a2,d1.w),obj.vram(a0)
			move.b	3(a2,d1.w),obj.priority(a0)
			move.b	$D(a2,d1.w),obj.frame(a0)
			move.b	$C(a2,d1.w),(byte_FF188A).l
			move.b	$B(a2,d1.w),d0
			ori.b	#4,d0
			move.b	d0,obj.render(a0)
			move.b	#0,obj.ani(a0)
			btst	#5,(word_FFF604+1).w
			beq.s	loc_206AE0
			bsr.w	findfreeobj
			bne.s	loc_206AE0
			moveq	#0,d1
			move.b	(byte_FF1206).l,d1
			mulu.w	#$C,d1
			move.b	2(a2,d1.w),obj.id(a1)
			move.b	$A(a2,d1.w),obj.field_28(a1)
			move.b	$C(a2,d1.w),obj.field_29(a1)
			move.b	$D(a2,d1.w),obj.frame(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.b	obj.render(a0),d0
			andi.b	#3,d0
			move.b	d0,obj.render(a1)
			move.b	d0,obj.status(a1)
loc_206AE0:								; CODE XREF: ROM:00206A98↑j
										; ROM:00206A9E↑j
			btst	#4,(word_FFF604+1).w
			beq.s	loc_206B10
			move.b	#0,(word_FF1208).l
			move.l	#player_map,obj.mappings(a0)
			move.w	#$780,obj.vram(a0)
			move.b	#2,obj.priority(a0)
			move.b	#0,obj.frame(a0)
			move.b	#4,obj.render(a0)
loc_206B10:								; CODE XREF: ROM:00206AE6↑j
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
dword_206B16:	dc.l $4000					; DATA XREF: ROM:00206990↑w
										; ROM:loc_20699C↑w ...
byte_206B1A:	dc.b $37					; DATA XREF: ROM:00206A0E↑o
			dc.b   0
			dc.b $25 ; %
			dc.b   1
			dc.l off_20CEE2
			dc.w $31E
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $1B
			dc.b   1
			dc.l obj1B_map
			dc.w $326
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $26 ; &
			dc.b   1
			dc.l obj26_map
			dc.w $33A
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $28 ; (
			dc.b   1
			dc.l obj28_map
			dc.w $342
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $28 ; (
			dc.b   1
			dc.l obj28_map
			dc.w $342
			dc.b   1
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b  $D
			dc.b   1
			dc.l obj0D_map
			dc.w $357
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $27 ; '
			dc.b   1
			dc.l obj27_map
			dc.w $49B
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b   1
			dc.l obj09_map
			dc.w $4D2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b   1
			dc.l obj09_map
			dc.w $47C
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b $21 ; !
			dc.b   1
			dc.l obj21_map
			dc.w $4000
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b  $F
			dc.b   4
			dc.l obj0F_map
			dc.w $4D4
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b  $F
			dc.b   4
			dc.l obj0F_map
			dc.w $493
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map
			dc.w $520
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map
			dc.w $520
			dc.b   0
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_2
			dc.w $520
			dc.b   4
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_2
			dc.w $520
			dc.b   4
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_3
			dc.w $3A1
			dc.b   8
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_3
			dc.w $3A1
			dc.b   8
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_3
			dc.w $3A1
			dc.b   8
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_3
			dc.w $3A1
			dc.b   8
			dc.b   3
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map
			dc.w $2520
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map
			dc.w $2520
			dc.b   2
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_2
			dc.w $2520
			dc.b   6
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_2
			dc.w $2520
			dc.b   6
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_3
			dc.w $23A1
			dc.b  $A
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_3
			dc.w $23A1
			dc.b  $A
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_3
			dc.w $23A1
			dc.b  $A
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b   1
			dc.l obj0A_map_3
			dc.w $23A1
			dc.b  $A
			dc.b   3
			dc.b   0
			dc.b   0
			dc.b $24 ; $
			dc.b   1
			dc.l obj24_map
			dc.w $3C7
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $24 ; $
			dc.b   1
			dc.l obj24b_map
			dc.w $3C7
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $13
			dc.b   4
			dc.l obj13_map
			dc.w $23DF
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $14
			dc.b   4
			dc.l obj14_map
			dc.w $23DF
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $15
			dc.b   4
			dc.l obj15_map
			dc.w $2456
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $16
			dc.b   4
			dc.l obj16_map
			dc.w $2428
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $22 ; "
			dc.b   4
			dc.l obj22_map
			dc.w $2413
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $19
			dc.b   4
			dc.l monitor_map
			dc.w $5A8
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $19
			dc.b   4
			dc.l monitor_map
			dc.w $5A8
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b $19
			dc.b   4
			dc.l monitor_map
			dc.w $5A8
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b $19
			dc.b   4
			dc.l monitor_map
			dc.w $5A8
			dc.b   3
			dc.b   0
			dc.b   0
			dc.b   3
			dc.b $19
			dc.b   4
			dc.l monitor_map
			dc.w $5A8
			dc.b   4
			dc.b   0
			dc.b   0
			dc.b   4
			dc.b $19
			dc.b   4
			dc.l monitor_map
			dc.w $5A8
			dc.b   5
			dc.b   0
			dc.b   0
			dc.b   5
			dc.b $19
			dc.b   4
			dc.l monitor_map
			dc.w $5A8
			dc.b   6
			dc.b   0
			dc.b   0
			dc.b   6
			dc.b $19
			dc.b   4
			dc.l monitor_map
			dc.w $5A8
			dc.b   7
			dc.b   0
			dc.b   0
			dc.b   7
			dc.b   4
			dc.b   1
			dc.l obj04_map
			dc.w $3BA
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b  $E
			dc.b   1
			dc.l obj0E_map
			dc.w $31E
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $20
			dc.b   3
			dc.l off_20D34C
			dc.w $4000
			dc.b $10
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b $20
			dc.b   3
			dc.l off_20D34C
			dc.w $4000
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $20
			dc.b   3
			dc.l off_20D418
			dc.w $4000
			dc.b $80
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $20
			dc.b   3
			dc.l off_20D418
			dc.w $4000
			dc.b $81
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b $20
			dc.b   3
			dc.l off_20D418
			dc.w $4000
			dc.b $82
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b $20
			dc.b   3
			dc.l off_20D418
			dc.w $4000
			dc.b $83
			dc.b   0
			dc.b   0
			dc.b   3
			dc.b $20
			dc.b   3
			dc.l off_20D418
			dc.w $4000
			dc.b $84
			dc.b   0
			dc.b   0
			dc.b   4
			dc.b $20
			dc.b   3
			dc.l off_20D418
			dc.w $4000
			dc.b $85
			dc.b   0
			dc.b   0
			dc.b   5
			dc.b $19
			dc.b   4
			dc.l monitor_map
			dc.w $5A8
			dc.b   8
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b $19
			dc.b   4
			dc.l monitor_map
			dc.w $5A8
			dc.b   9
			dc.b   0
			dc.b   0
			dc.b  $C
; =============== S U B R O U T I N E =======================================
sub_206DB0:								; CODE XREF: ROM:0020142E↑p
			moveq	#0,d0
			move.b	(byte_FFF76C).w,d0
			move.w	off_206DBE(pc,d0.w),d0
			jmp	off_206DBE(pc,d0.w)
; End of function sub_206DB0
; ---------------------------------------------------------------------------
off_206DBE: dc.w loc_206DC2-*			; CODE XREF: sub_206DB0+A↑j
										; DATA XREF: sub_206DB0+6↑r ...
			dc.w loc_206E50-off_206DBE
; ---------------------------------------------------------------------------
loc_206DC2:								; DATA XREF: ROM:off_206DBE↑o
			addq.b	#2,(byte_FFF76C).w
			lea	(unk_207000).l,a0
			movea.l a0,a1
			adda.w	(a0),a0
			move.l	a0,(dword_FFF770).w
			move.l	a0,(dword_FFF774).w
			adda.w	2(a1),a1
			move.l	a1,(dword_FFF778).w
			move.l	a1,(dword_FFF77C).w
			lea	(unk_FF1400).l,a2
			move.w	#$101,(a2)+
			move.w	#(unk_FF1400_end-unk_FF1400-2)/4-1,d0
loc_206DF2:								; CODE XREF: ROM:00206DF4↓j
			clr.l	(a2)+
			dbf	d0,loc_206DF2
			lea	(unk_FF1400).l,a2
			moveq	#0,d2
			move.w	(dword_FFF700).w,d6
			subi.w	#$80,d6
			bcc.s	loc_206E0C
			moveq	#0,d6
loc_206E0C:								; CODE XREF: ROM:00206E08↑j
			andi.w	#$FF80,d6
			movea.l (dword_FFF770).w,a0
loc_206E14:								; CODE XREF: ROM:00206E24↓j
			cmp.w	(a0),d6
			bls.s	loc_206E26
			tst.b	4(a0)
			bpl.s	loc_206E22
			move.b	(a2),d2
			addq.b	#1,(a2)
loc_206E22:								; CODE XREF: ROM:00206E1C↑j
			addq.w	#8,a0
			bra.s	loc_206E14
; ---------------------------------------------------------------------------
loc_206E26:								; CODE XREF: ROM:00206E16↑j
			move.l	a0,(dword_FFF770).w
			movea.l (dword_FFF774).w,a0
			subi.w	#$80,d6
			bcs.s	loc_206E46
loc_206E34:								; CODE XREF: ROM:00206E44↓j
			cmp.w	(a0),d6
			bls.s	loc_206E46
			tst.b	4(a0)
			bpl.s	loc_206E42
			addq.b	#1,1(a2)
loc_206E42:								; CODE XREF: ROM:00206E3C↑j
			addq.w	#8,a0
			bra.s	loc_206E34
; ---------------------------------------------------------------------------
loc_206E46:								; CODE XREF: ROM:00206E32↑j
										; ROM:00206E36↑j
			move.l	a0,(dword_FFF774).w
			move.w	#$FFFF,(word_FFF76E).w
loc_206E50:								; DATA XREF: ROM:00206DC0↑o
			lea	(unk_FF1400).l,a2
			moveq	#0,d2
			move.w	(dword_FFF700).w,d6
			andi.w	#$FF80,d6
			cmp.w	(word_FFF76E).w,d6
			beq.w	locret_206F0C
			bge.s	loc_206EC8
			move.w	d6,(word_FFF76E).w
			movea.l (dword_FFF774).w,a0
			subi.w	#$80,d6
			bcs.s	loc_206EA4
loc_206E78:								; CODE XREF: ROM:00206E96↓j
			cmp.w	-8(a0),d6
			bge.s	loc_206EA4
			subq.w	#8,a0
			tst.b	4(a0)
			bpl.s	loc_206E8E
			subq.b	#1,1(a2)
			move.b	1(a2),d2
loc_206E8E:								; CODE XREF: ROM:00206E84↑j
			bsr.w	sub_206F2C
			bne.s	loc_206E98
			subq.w	#8,a0
			bra.s	loc_206E78
; ---------------------------------------------------------------------------
loc_206E98:								; CODE XREF: ROM:00206E92↑j
			tst.b	4(a0)
			bpl.s	loc_206EA2
			addq.b	#1,1(a2)
loc_206EA2:								; CODE XREF: ROM:00206E9C↑j
			addq.w	#8,a0
loc_206EA4:								; CODE XREF: ROM:00206E76↑j
										; ROM:00206E7C↑j
			move.l	a0,(dword_FFF774).w
			movea.l (dword_FFF770).w,a0
			addi.w	#$300,d6
loc_206EB0:								; CODE XREF: ROM:00206EC0↓j
			cmp.w	-8(a0),d6
			bgt.s	loc_206EC2
			tst.b	-4(a0)
			bpl.s	loc_206EBE
			subq.b	#1,(a2)
loc_206EBE:								; CODE XREF: ROM:00206EBA↑j
			subq.w	#8,a0
			bra.s	loc_206EB0
; ---------------------------------------------------------------------------
loc_206EC2:								; CODE XREF: ROM:00206EB4↑j
			move.l	a0,(dword_FFF770).w
			rts
; ---------------------------------------------------------------------------
loc_206EC8:								; CODE XREF: ROM:00206E68↑j
			move.w	d6,(word_FFF76E).w
			movea.l (dword_FFF770).w,a0
			addi.w	#$280,d6
loc_206ED4:								; CODE XREF: ROM:00206EE6↓j
			cmp.w	(a0),d6
			bls.s	loc_206EE8
			tst.b	4(a0)
			bpl.s	loc_206EE2
			move.b	(a2),d2
			addq.b	#1,(a2)
loc_206EE2:								; CODE XREF: ROM:00206EDC↑j
			bsr.w	sub_206F2C
			beq.s	loc_206ED4
loc_206EE8:								; CODE XREF: ROM:00206ED6↑j
			move.l	a0,(dword_FFF770).w
			movea.l (dword_FFF774).w,a0
			subi.w	#$300,d6
			bcs.s	loc_206F08
loc_206EF6:								; CODE XREF: ROM:00206F06↓j
			cmp.w	(a0),d6
			bls.s	loc_206F08
			tst.b	4(a0)
			bpl.s	loc_206F04
			addq.b	#1,1(a2)
loc_206F04:								; CODE XREF: ROM:00206EFE↑j
			addq.w	#8,a0
			bra.s	loc_206EF6
; ---------------------------------------------------------------------------
loc_206F08:								; CODE XREF: ROM:00206EF4↑j
										; ROM:00206EF8↑j
			move.l	a0,(dword_FFF774).w
locret_206F0C:							; CODE XREF: ROM:00206E64↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_206F0E:								; CODE XREF: sub_206F2C↓p
			moveq	#0,d0
			move.b	(byte_FF123D).l,d0
			move.w	d2,d3
			add.w	d3,d3
			add.w	d2,d3
			add.w	d0,d3
			move.b	6(a0),d1
			rol.b	#3,d1
			andi.b	#7,d1
			btst	d0,d1
			rts
; End of function sub_206F0E
; =============== S U B R O U T I N E =======================================
sub_206F2C:								; CODE XREF: ROM:loc_206E8E↑p
										; ROM:loc_206EE2↑p
			bsr.s	sub_206F0E
			beq.s	loc_206F3E
			tst.b	4(a0)
			bpl.s	loc_206F44
			bset	#7,2(a2,d3.w)
			beq.s	loc_206F44
loc_206F3E:								; CODE XREF: sub_206F2C+2↑j
			addq.w	#8,a0
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_206F44:								; CODE XREF: sub_206F2C+8↑j
										; sub_206F2C+10↑j
			bsr.w	findfreeobj
			bne.s	locret_206F84
			move.w	(a0)+,obj.xpos(a1)
			move.w	(a0)+,d0
			move.w	d0,d1
			andi.w	#$FFF,d0
			move.w	d0,obj.ypos(a1)
			rol.w	#2,d1
			andi.b	#3,d1
			move.b	d1,obj.render(a1)
			move.b	d1,obj.status(a1)
			move.b	(a0)+,d0
			bpl.s	loc_206F74
			andi.b	#$7F,d0
			move.b	d2,obj.field_23(a1)
loc_206F74:								; CODE XREF: sub_206F2C+3E↑j
			move.b	d0,obj.id(a1)
			move.b	(a0)+,obj.field_28(a1)
			move.b	(a0)+,d0
			move.b	(a0)+,obj.field_29(a1)
			moveq	#0,d0
locret_206F84:							; CODE XREF: sub_206F2C+1C↑j
			rts
; End of function sub_206F2C
; =============== S U B R O U T I N E =======================================
findfreeobj:							; CODE XREF: sub_203720+3A↑p
										; ROM:002037C0↑p ...
			lea	(byte_FFD800).w,a1
			move.w	#(byte_FFD800_end-byte_FFD800)/obj-1,d0
loc_206F8E:								; CODE XREF: findfreeobj+10↓j
			tst.b	(a1)
			beq.s	locret_206F9A
			lea	obj(a1),a1
			dbf	d0,loc_206F8E
locret_206F9A:							; CODE XREF: findfreeobj+A↑j
			rts
; End of function findfreeobj
; =============== S U B R O U T I N E =======================================
sub_206F9C:								; CODE XREF: ROM:loc_20D1D4↓p
										; ROM:loc_20D2E4↓p
			movea.l a0,a1
			move.w	#byte_FFD800_end,d0
			sub.w	a0,d0
			lsr.w	#6,d0
			subq.w	#1,d0
			bcs.s	locret_206FB6
loc_206FAA:								; CODE XREF: sub_206F9C+16↓j
			tst.b	(a1)
			beq.s	locret_206FB6
			lea	obj(a1),a1
			dbf	d0,loc_206FAA
locret_206FB6:							; CODE XREF: sub_206F9C+C↑j
										; sub_206F9C+10↑j
			rts
; End of function sub_206F9C
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR obj13
loc_206FB8:								; CODE XREF: ROM:00205724↑j
										; ROM:0020811E↓j ...
			move.w	obj.xpos(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bls.s	locret_206FFE
			moveq	#0,d0
			move.b	obj.field_23(a0),d0
			beq.s	loc_206FF8
			lea	(unk_FF1400).l,a1
			move.w	d0,d1
			add.w	d1,d1
			add.w	d1,d0
			moveq	#0,d1
			move.b	(byte_FF123D).l,d1
			add.w	d1,d0
			bclr	#7,2(a1,d0.w)
loc_206FF8:								; CODE XREF: obj13-2B80↑j
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
locret_206FFE:							; CODE XREF: obj13-2B88↑j
			rts
; END OF FUNCTION CHUNK FOR obj13
; ---------------------------------------------------------------------------
unk_207000: incbin	"Object Positions/ObjPos.bin"
			even
; ---------------------------------------------------------------------------
obj07:									; DATA XREF: ROM:002034C6↑o
			bsr.w	sub_2023EA
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_207B78(pc,d0.w),d1
			jsr	off_207B78(pc,d1.w)
			cmpi.b	#4,obj.routine(a0)
			bcc.s	locret_207B70
			move.w	obj.xpos(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bhi.s	loc_207B72
locret_207B70:							; CODE XREF: ROM:00207B52↑j
			rts
; ---------------------------------------------------------------------------
loc_207B72:								; CODE XREF: ROM:00207B6E↑j
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
off_207B78: dc.w loc_207B80-*			; CODE XREF: ROM:00207B48↑p
										; DATA XREF: ROM:00207B44↑r ...
			dc.w loc_207BC6-off_207B78
			dc.w loc_207C3E-off_207B78
			dc.w loc_207C52-off_207B78
; ---------------------------------------------------------------------------
loc_207B80:								; DATA XREF: ROM:off_207B78↑o
			move.l	#obj06_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.w	#$541,obj.vram(a0)
			addq.b	#2,obj.routine(a0)
			move.b	obj.field_28(a0),d0
			add.w	d0,d0
			andi.w	#$1E,d0
			lea	off_207D7C(pc),a2
			adda.w	(a2,d0.w),a2
			move.w	(a2)+,obj.field_3A(a0)
			move.l	a2,obj.field_3C(a0)
			move.w	(a2)+,obj.field_36(a0)
			move.w	(a2)+,obj.field_38(a0)
loc_207BC6:								; DATA XREF: ROM:00207B7A↑o
			move.w	obj.xpos(a6),d0
			sub.w	obj.xpos(a0),d0
			addi.w	#$10,d0
			cmpi.w	#$20,d0
			bcc.s	locret_207C3C
			move.w	obj.ypos(a6),d1
			sub.w	obj.ypos(a0),d1
			addi.w	#$20,d1
			cmpi.w	#$40,d1
			bcc.s	locret_207C3C
			tst.b	obj.field_2C(a6)
			bne.s	locret_207C3C
			addq.b	#2,obj.routine(a0)
			move.b	#$81,obj.field_2C(a6)
			move.b	#2,obj.ani(a6)
			bsr.w	sub_207D5C
			move.w	#0,obj.xvel(a6)
			move.w	#0,obj.yvel(a6)
			bclr	#5,obj.status(a0)
			bclr	#5,obj.status(a6)
			bset	#1,obj.status(a6)
			move.w	obj.xpos(a0),obj.xpos(a6)
			move.w	obj.ypos(a0),obj.ypos(a6)
			clr.b	obj.field_32(a0)
			move.w	#$91,d0
			jsr	(queuesound2).l
locret_207C3C:							; CODE XREF: ROM:00207BD6↑j
										; ROM:00207BE8↑j ...
			rts
; ---------------------------------------------------------------------------
loc_207C3E:								; DATA XREF: ROM:00207B7C↑o
			bsr.w	sub_207CCC
			addq.b	#2,obj.routine(a0)
			move.w	#$91,d0
			jsr	(queuesound2).l
			rts
; ---------------------------------------------------------------------------
loc_207C52:								; DATA XREF: ROM:00207B7E↑o
			addq.l	#4,sp
			subq.b	#1,obj.field_2E(a0)
			bpl.s	loc_207C90
			move.w	obj.field_36(a0),obj.xpos(a6)
			move.w	obj.field_38(a0),obj.ypos(a6)
			moveq	#0,d1
			move.b	obj.field_3A(a0),d1
			addq.b	#4,d1
			cmp.b	obj.field_3B(a0),d1
			bcs.s	loc_207C78
			moveq	#0,d1
			bra.s	loc_207CB6
; ---------------------------------------------------------------------------
loc_207C78:								; CODE XREF: ROM:00207C72↑j
			move.b	d1,obj.field_3A(a0)
			movea.l obj.field_3C(a0),a2
			move.w	(a2,d1.w),obj.field_36(a0)
			move.w	2(a2,d1.w),obj.field_38(a0)
			bra.w	sub_207CCC
; ---------------------------------------------------------------------------
loc_207C90:								; CODE XREF: ROM:00207C58↑j
			move.l	obj.xpos(a6),d2
			move.l	obj.ypos(a6),d3
			move.w	obj.xvel(a6),d0
			ext.l	d0
			asl.l	#8,d0
			add.l	d0,d2
			move.w	obj.yvel(a6),d0
			ext.l	d0
			asl.l	#8,d0
			add.l	d0,d3
			move.l	d2,obj.xpos(a6)
			move.l	d3,obj.ypos(a6)
			rts
; ---------------------------------------------------------------------------
loc_207CB6:								; CODE XREF: ROM:00207C76↑j
			andi.w	#$7FF,obj.ypos(a6)
			clr.b	obj.routine(a0)
			clr.b	obj.field_2C(a6)
			move.w	#2,obj.routine(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_207CCC:								; CODE XREF: ROM:loc_207C3E↑p
										; ROM:00207C8C↑j
			moveq	#0,d0
			move.w	obj.inertia(a6),d2
			move.w	obj.inertia(a6),d3
			move.w	obj.field_36(a0),d0
			sub.w	obj.xpos(a6),d0
			bge.s	loc_207CE4
			neg.w	d0
			neg.w	d2
loc_207CE4:								; CODE XREF: sub_207CCC+12↑j
			moveq	#0,d1
			move.w	obj.field_38(a0),d1
			sub.w	obj.ypos(a6),d1
			bge.s	loc_207CF4
			neg.w	d1
			neg.w	d3
loc_207CF4:								; CODE XREF: sub_207CCC+22↑j
			cmp.w	d0,d1
			bcs.s	loc_207D2A
			moveq	#0,d1
			move.w	obj.field_38(a0),d1
			sub.w	obj.ypos(a6),d1
			swap	d1
			divs.w	d3,d1
			moveq	#0,d0
			move.w	obj.field_36(a0),d0
			sub.w	obj.xpos(a6),d0
			beq.s	loc_207D16
			swap	d0
			divs.w	d1,d0
loc_207D16:								; CODE XREF: sub_207CCC+44↑j
			move.w	d0,obj.xvel(a6)
			move.w	d3,obj.yvel(a6)
			tst.w	d1
			bpl.s	loc_207D24
			neg.w	d1
loc_207D24:								; CODE XREF: sub_207CCC+54↑j
			move.w	d1,obj.field_2E(a0)
			rts
; ---------------------------------------------------------------------------
loc_207D2A:								; CODE XREF: sub_207CCC+2A↑j
			moveq	#0,d0
			move.w	obj.field_36(a0),d0
			sub.w	obj.xpos(a6),d0
			swap	d0
			divs.w	d2,d0
			moveq	#0,d1
			move.w	obj.field_38(a0),d1
			sub.w	obj.ypos(a6),d1
			beq.s	loc_207D48
			swap	d1
			divs.w	d0,d1
loc_207D48:								; CODE XREF: sub_207CCC+76↑j
			move.w	d1,obj.yvel(a6)
			move.w	d2,obj.xvel(a6)
			tst.w	d0
			bpl.s	loc_207D56
			neg.w	d0
loc_207D56:								; CODE XREF: sub_207CCC+86↑j
			move.w	d0,obj.field_2E(a0)
			rts
; End of function sub_207CCC
; =============== S U B R O U T I N E =======================================
sub_207D5C:								; CODE XREF: ROM:00207C00↑p
			moveq	#0,d0
			move.b	obj.field_28(a0),d0
			add.w	d0,d0
			move.w	word_207D74(pc,d0.w),d0
			cmp.w	obj.inertia(a6),d0
			ble.s	locret_207D72
			move.w	d0,obj.inertia(a6)
locret_207D72:							; CODE XREF: sub_207D5C+10↑j
			rts
; End of function sub_207D5C
; ---------------------------------------------------------------------------
word_207D74:	dc.w $1000					; DATA XREF: sub_207D5C+8↑r
			dc.w $C00
			dc.w $C00
			dc.w $800
off_207D7C: dc.w unk_207D8C-*			; DATA XREF: ROM:00207BAE↑o
										; ROM:00207D7E↓o ...
			dc.w unk_207E16-off_207D7C
			dc.w unk_207E5C-off_207D7C
			dc.w sub_207EA2-off_207D7C
			dc.w sub_207EA2-off_207D7C
			dc.w sub_207EA2-off_207D7C
			dc.w sub_207EA2-off_207D7C
			dc.w sub_207EA2-off_207D7C
unk_207D8C: dc.b   0					; DATA XREF: ROM:off_207D7C↑o
			dc.b $88
			dc.b $14
			dc.b $40 ; @
			dc.b   0
			dc.b $F0
			dc.b $14
			dc.b $78 ; x
			dc.b   1
			dc.b   8
			dc.b $14
			dc.b $90
			dc.b   1
			dc.b $40 ; @
			dc.b $14
			dc.b $90
			dc.b   1
			dc.b $E0
			dc.b $14
			dc.b $40 ; @
			dc.b   1
			dc.b $F8
			dc.b $14
			dc.b   0
			dc.b   1
			dc.b $E0
			dc.b $13
			dc.b $F0
			dc.b   1
			dc.b $C0
			dc.b $13
			dc.b $F0
			dc.b   1
			dc.b $80
			dc.b $14
			dc.b   0
			dc.b   1
			dc.b $70 ; p
			dc.b $14
			dc.b $20
			dc.b   1
			dc.b $68 ; h
			dc.b $14
			dc.b $40 ; @
			dc.b   1
			dc.b $70 ; p
			dc.b $14
			dc.b $68 ; h
			dc.b   1
			dc.b $A8
			dc.b $16
			dc.b $60 ; `
			dc.b   2
			dc.b $18
			dc.b $16
			dc.b $A0
			dc.b   2
			dc.b $10
			dc.b $16
			dc.b $C0
			dc.b   1
			dc.b $F8
			dc.b $16
			dc.b $D0
			dc.b   1
			dc.b $C8
			dc.b $16
			dc.b $C0
			dc.b   1
			dc.b $A8
			dc.b $16
			dc.b $80
			dc.b   1
			dc.b $98
			dc.b $16
			dc.b $58 ; X
			dc.b   1
			dc.b $A0
			dc.b $16
			dc.b $40 ; @
			dc.b   1
			dc.b $C8
			dc.b $16
			dc.b $50 ; P
			dc.b   1
			dc.b $F0
			dc.b $16
			dc.b $80
			dc.b   2
			dc.b   0
			dc.b $16
			dc.b $C0
			dc.b   2
			dc.b   0
			dc.b $16
			dc.b $D0
			dc.b   2
			dc.b $10
			dc.b $16
			dc.b $D0
			dc.b   2
			dc.b $88
			dc.b $16
			dc.b $C0
			dc.b   2
			dc.b $C0
			dc.b $16
			dc.b $80
			dc.b   2
			dc.b $D8
			dc.b $16
			dc.b $50 ; P
			dc.b   2
			dc.b $C0
			dc.b $16
			dc.b $50 ; P
			dc.b   2
			dc.b $A0
			dc.b $16
			dc.b $80
			dc.b   2
			dc.b $90
			dc.b $17
			dc.b   0
			dc.b   2
			dc.b $90
			dc.b $17
			dc.b $28 ; (
			dc.b   2
			dc.b $A0
			dc.b $17
			dc.b $28 ; (
			dc.b   2
			dc.b $E0
			dc.b $17
			dc.b   0
			dc.b   2
			dc.b $F0
unk_207E16: dc.b   0					; DATA XREF: ROM:00207D7E↑o
			dc.b $44 ; D
			dc.b  $F
			dc.b   8
			dc.b   1
			dc.b $A0
			dc.b  $F
			dc.b $90
			dc.b   1
			dc.b $A0
			dc.b  $F
			dc.b $C8
			dc.b   1
			dc.b $B8
			dc.b  $F
			dc.b $E0
			dc.b   1
			dc.b $F0
			dc.b  $F
			dc.b $E0
			dc.b   2
			dc.b $60 ; `
			dc.b $10
			dc.b   0
			dc.b   2
			dc.b $90
			dc.b $10
			dc.b $30 ; 0
			dc.b   2
			dc.b $A0
			dc.b $10
			dc.b $68 ; h
			dc.b   2
			dc.b $88
			dc.b $10
			dc.b $80
			dc.b   2
			dc.b $50 ; P
			dc.b $10
			dc.b $68 ; h
			dc.b   2
			dc.b $18
			dc.b $10
			dc.b $30 ; 0
			dc.b   2
			dc.b   0
			dc.b  $F
			dc.b $F0
			dc.b   2
			dc.b $20
			dc.b  $F
			dc.b $E0
			dc.b   2
			dc.b $60 ; `
			dc.b $10
			dc.b   0
			dc.b   2
			dc.b $90
			dc.b $10
			dc.b $30 ; 0
			dc.b   2
			dc.b $A0
			dc.b $10
			dc.b $68 ; h
			dc.b   2
			dc.b $88
			dc.b $11
			dc.b $30 ; 0
			dc.b   1
			dc.b $C8
unk_207E5C: dc.b   0					; DATA XREF: ROM:00207D80↑o
			dc.b $44 ; D
			dc.b $16
			dc.b $30 ; 0
			dc.b   2
			dc.b $90
			dc.b $16
			dc.b $30 ; 0
			dc.b   3
			dc.b $18
			dc.b $16
			dc.b $38 ; 8
			dc.b   3
			dc.b $38 ; 8
			dc.b $16
			dc.b $D0
			dc.b   3
			dc.b $D0
			dc.b $17
			dc.b   0
			dc.b   3
			dc.b $E0
			dc.b $17
			dc.b $38 ; 8
			dc.b   3
			dc.b $C8
			dc.b $17
			dc.b $58 ; X
			dc.b   3
			dc.b $90
			dc.b $17
			dc.b $38 ; 8
			dc.b   3
			dc.b $58 ; X
			dc.b $16
			dc.b $F8
			dc.b   3
			dc.b $40 ; @
			dc.b $16
			dc.b $C0
			dc.b   3
			dc.b $60 ; `
			dc.b $16
			dc.b $A8
			dc.b   3
			dc.b $90
			dc.b $16
			dc.b $D0
			dc.b   3
			dc.b $D0
			dc.b $17
			dc.b   0
			dc.b   3
			dc.b $E0
			dc.b $17
			dc.b $38 ; 8
			dc.b   3
			dc.b $C8
			dc.b $17
			dc.b $B8
			dc.b   3
			dc.b $48 ; H
			dc.b $17
			dc.b $D0
			dc.b   3
			dc.b $20
			dc.b $17
			dc.b $D0
			dc.b   2
			dc.b $78 ; x
; =============== S U B R O U T I N E =======================================
sub_207EA2:								; CODE XREF: sub_207F56:loc_20805C↓p
										; sub_207F56:loc_208068↓p
										; DATA XREF: ...
			btst	#3,obj.status(a0)
			beq.s	locret_207EDA
			btst	#3,obj.status(a1)
			beq.s	locret_207EDA
			moveq	#0,d0
			move.b	obj.field_3D(a1),d0
			lsl.w	#6,d0
			addi.l	#actwk&$FFFFFF,d0
			cmpa.w	d0,a0
			bne.s	locret_207EDA
			clr.b	obj.field_38(a1)
			bset	#1,obj.status(a1)
			bclr	#3,obj.status(a1)
			bclr	#3,obj.status(a0)
locret_207EDA:							; CODE XREF: sub_207EA2+6↑j
										; sub_207EA2+E↑j ...
			rts
; End of function sub_207EA2
; =============== S U B R O U T I N E =======================================
sub_207EDC:								; CODE XREF: sub_207F56+FE↓p
			clr.b	obj.routine2(a0)
			clr.b	obj.field_3C(a1)
			bset	#3,obj.status(a0)
			bne.s	loc_207F0A
			bclr	#2,obj.status(a1)
			beq.s	loc_207F0A
			move.b	#$13,obj.field_16(a1)
			move.b	#9,obj.field_17(a1)
			subq.w	#5,obj.ypos(a1)
			move.b	#0,obj.ani(a1)
loc_207F0A:								; CODE XREF: sub_207EDC+E↑j
										; sub_207EDC+16↑j
			bset	#3,obj.status(a1)
			beq.s	loc_207F2C
			moveq	#0,d0
			move.b	obj.field_3D(a1),d0
			lsl.w	#6,d0
			addi.l	#actwk&$FFFFFF,d0
			cmpa.w	d0,a0
			beq.s	locret_207F54
			movea.l d0,a2
			bclr	#3,obj.status(a2)
loc_207F2C:								; CODE XREF: sub_207EDC+34↑j
			move.w	a0,d0
			subi.w	#actwk,d0
			lsr.w	#6,d0
			andi.w	#$7F,d0
			move.b	d0,obj.field_3D(a1)
			move.b	#0,obj.angle(a1)
			move.w	#0,obj.yvel(a1)
			move.w	obj.xvel(a1),obj.inertia(a1)
			bclr	#1,obj.status(a1)
locret_207F54:							; CODE XREF: sub_207EDC+46↑j
			rts
; End of function sub_207EDC
; =============== S U B R O U T I N E =======================================
sub_207F56:								; CODE XREF: sub_205732+4A↑j
										; sub_2080EA+8↓j ...
			cmpi.b	#4,obj.routine(a1)
			bcc.w	loc_20805C
			cmpi.b	#$2B,obj.ani(a1) ; '+'
			beq.w	loc_20805C
			tst.b	obj.id(a1)
			beq.w	loc_20805C
			tst.b	obj.render(a0)
			bpl.w	loc_20805C
			tst.b	(word_FF1208).l
			bne.w	loc_20805C
			moveq	#0,d1
			moveq	#0,d2
			move.b	obj.field_16(a0),d2
			move.b	obj.field_19(a0),d1
			moveq	#$10,d5
			add.w	d1,d5
			move.w	obj.xpos(a1),d0
			sub.w	d3,d0
			add.w	d5,d0
			bmi.w	loc_20805C
			move.w	d5,d6
			add.w	d5,d5
			cmp.w	d5,d0
			bcc.w	loc_20805C
			move.w	d0,d5
			move.w	obj.xpos(a1),d0
			sub.w	d3,d0
			add.w	d1,d0
			bmi.w	loc_208068
			add.w	d1,d1
			cmp.w	d1,d0
			bcc.w	loc_208068
			tst.b	obj.routine2(a0)
			beq.s	loc_207FD0
			cmpi.b	#2,obj.ani(a1)
			beq.w	loc_20805C
loc_207FD0:								; CODE XREF: sub_207F56+6E↑j
			btst	#1,obj.render(a0)
			beq.s	loc_207FE2
			tst.w	obj.yvel(a1)
			bpl.w	loc_20805C
			bra.s	loc_207FEA
; ---------------------------------------------------------------------------
loc_207FE2:								; CODE XREF: sub_207F56+80↑j
			tst.w	obj.yvel(a1)
			bmi.w	loc_20805C
loc_207FEA:								; CODE XREF: sub_207F56+8A↑j
			move.w	obj.ypos(a1),d0
			moveq	#0,d1
			move.b	obj.field_16(a1),d1
			btst	#1,obj.render(a0)
			beq.s	loc_208000
			sub.w	d1,d0
			bra.s	loc_208002
; ---------------------------------------------------------------------------
loc_208000:								; CODE XREF: sub_207F56+A4↑j
			add.w	d1,d0
loc_208002:								; CODE XREF: sub_207F56+A8↑j
			addq.w	#2,d2
			sub.w	d4,d0
			add.w	d2,d0
			bmi.s	loc_20805C
			add.w	d2,d2
			cmp.w	d2,d0
			bcc.s	loc_20805C
			move.w	d4,obj.ypos(a1)
			lsr.w	#1,d2
			add.w	d1,d2
			subq.w	#2,d2
			btst	#1,obj.render(a0)
			beq.s	loc_208028
			add.w	d2,obj.ypos(a1)
			bra.s	loc_20802C
; ---------------------------------------------------------------------------
loc_208028:								; CODE XREF: sub_207F56+CA↑j
			sub.w	d2,obj.ypos(a1)
loc_20802C:								; CODE XREF: sub_207F56+D0↑j
			moveq	#0,d1
			move.w	obj.xvel(a0),d1
			ext.l	d1
			asl.l	#8,d1
			move.l	obj.xpos(a1),d0
			add.l	d1,d0
			move.l	d0,obj.xpos(a1)
			moveq	#0,d1
			move.w	obj.yvel(a0),d1
			ext.l	d1
			asl.l	#8,d1
			move.l	obj.ypos(a1),d0
			add.l	d1,d0
			move.l	d0,obj.ypos(a1)
			bsr.w	sub_207EDC
			moveq	#1,d0
			rts
; ---------------------------------------------------------------------------
loc_20805C:								; CODE XREF: sub_207F56+6↑j
										; sub_207F56+10↑j ...
			bsr.w	sub_207EA2
			clr.b	obj.routine2(a0)
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_208068:								; CODE XREF: sub_207F56+5E↑j
										; sub_207F56+66↑j
			bsr.w	sub_207EA2
			btst	#1,obj.status(a1)
			bne.s	loc_2080DA
			subq.w	#2,d2
			move.w	obj.ypos(a1),d0
			add.b	obj.field_16(a1),d0
			sub.w	d4,d0
			add.w	d2,d0
			bmi.s	loc_2080DA
			add.b	obj.field_16(a1),d2
			add.w	d2,d2
			cmp.w	d2,d0
			bcc.s	loc_2080DA
			move.w	obj.xpos(a1),d0
			cmp.w	d3,d0
			bcc.s	loc_20809E
			tst.w	obj.xvel(a1)
			bpl.s	loc_2080B2
			bra.s	loc_2080A4
; ---------------------------------------------------------------------------
loc_20809E:								; CODE XREF: sub_207F56+13E↑j
			tst.w	obj.xvel(a1)
			bmi.s	loc_2080B2
loc_2080A4:								; CODE XREF: sub_207F56+146↑j
			bclr	#5,obj.status(a1)
			bclr	#5,obj.status(a0)
			bra.s	loc_2080BE
; ---------------------------------------------------------------------------
loc_2080B2:								; CODE XREF: sub_207F56+144↑j
										; sub_207F56+14C↑j
			bset	#5,obj.status(a1)
			bset	#5,obj.status(a0)
loc_2080BE:								; CODE XREF: sub_207F56+15A↑j
			cmp.w	d5,d6
			bcc.s	loc_2080C6
			add.w	d6,d6
			sub.w	d6,d5
loc_2080C6:								; CODE XREF: sub_207F56+16A↑j
			sub.w	d5,obj.xpos(a1)
			move.w	#0,obj.inertia(a1)
			move.w	#0,obj.xvel(a1)
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_2080DA:								; CODE XREF: sub_207F56+11C↑j
										; sub_207F56+12C↑j ...
			bclr	#5,obj.status(a1)
			bclr	#5,obj.status(a0)
			moveq	#0,d0
			rts
; End of function sub_207F56
; =============== S U B R O U T I N E =======================================
sub_2080EA:								; CODE XREF: ROM:0020815E↓p
										; ROM:0020816C↓p
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_2080EA
; ---------------------------------------------------------------------------
obj09:									; DATA XREF: ROM:002034CE↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_208124(pc,d0.w),d0
			jsr	off_208124(pc,d0.w)
			tst.w	(word_FF1278).l
			bne.s	loc_208118
			lea	(obj09_ani).l,a1
			bsr.w	animateobj
loc_208118:								; CODE XREF: ROM:0020810C↑j
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_208124: dc.w loc_208128-*			; CODE XREF: ROM:00208102↑p
										; DATA XREF: ROM:002080FE↑r ...
			dc.w loc_208152-off_208124
; ---------------------------------------------------------------------------
loc_208128:								; DATA XREF: ROM:off_208124↑o
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#4,obj.priority(a0)
			move.l	#obj09_map,obj.mappings(a0)
			moveq	#6,d0
			jsr	sub_20DC4C(pc)
			move.b	#$10,obj.field_19(a0)
			move.b	#8,obj.field_16(a0)
loc_208152:								; DATA XREF: ROM:00208126↑o
			tst.b	obj.render(a0)
			bpl.w	locret_2081BC
			lea	(actwk).w,a1
			bsr.s	sub_2080EA
			beq.s	loc_208166
			bsr.s	sub_208172
			bra.s	loc_208168
; ---------------------------------------------------------------------------
loc_208166:								; CODE XREF: ROM:00208160↑j
			bsr.s	sub_2081A6
loc_208168:								; CODE XREF: ROM:00208164↑j
			lea	(byte_FFD040).w,a1
			bsr.w	sub_2080EA
			beq.s	sub_2081A6
; =============== S U B R O U T I N E =======================================
sub_208172:								; CODE XREF: ROM:00208162↑p
; FUNCTION CHUNK AT 002081BE SIZE 0000005C BYTES
; FUNCTION CHUNK AT 0020827E SIZE 000000BE BYTES
			tst.w	(word_FF1278).l
			bne.s	locret_2081BC
			bset	#0,obj.field_2C(a1)
			bne.s	loc_2081A4
			move.b	#$2D,obj.ani(a1) ; '-'
			moveq	#0,d0
			move.b	d0,obj.field_2B(a1)
			move.w	obj.xpos(a1),d0
			sub.w	obj.xpos(a0),d0
			bcc.s	loc_2081A0
			neg.w	d0
			move.b	#$80,obj.field_2B(a1)
loc_2081A0:								; CODE XREF: sub_208172+24↑j
			move.b	d0,obj.field_39(a1)
loc_2081A4:								; CODE XREF: sub_208172+E↑j
			bra.s	loc_2081BE
; End of function sub_208172
; =============== S U B R O U T I N E =======================================
sub_2081A6:								; CODE XREF: ROM:loc_208166↑p
										; ROM:00208170↑j
			moveq	#0,d0
			move.b	obj.field_3D(a1),d0
			lsl.w	#6,d0
			addi.l	#actwk&$FFFFFF,d0
			cmpa.w	d0,a0
			bne.s	locret_2081BC
			clr.b	obj.field_2C(a1)
locret_2081BC:							; CODE XREF: ROM:00208156↑j
										; sub_208172+6↑j ...
			rts
; End of function sub_2081A6
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_208172
loc_2081BE:								; CODE XREF: sub_208172:loc_2081A4↑j
			addq.b	#8,obj.field_2B(a1)
			move.b	obj.field_2B(a1),d0
			jsr	(calcsine).l
			moveq	#0,d0
			move.b	obj.field_39(a1),d0
			muls.w	d1,d0
			lsr.l	#8,d0
			move.w	obj.xpos(a0),obj.xpos(a1)
			add.w	d0,obj.xpos(a1)
			moveq	#0,d0
			move.b	obj.field_2B(a1),d0
			move.b	d0,d1
			andi.b	#$F0,d0
			lsr.b	#4,d0
			move.b	byte_20821C(pc,d0.w),obj.field_1B(a1)
			andi.b	#$3F,d1
			bne.s	loc_2081FE
			addq.b	#1,obj.field_39(a1)
loc_2081FE:								; CODE XREF: sub_208172+86↑j
			move.w	(word_FFF604).w,(word_FFF602).w
			cmpi.b	#1,obj.id(a1)
			beq.s	loc_208212
			move.w	(word_FFF606).w,(word_FFF602).w
loc_208212:								; CODE XREF: sub_208172+98↑j
			bsr.w	sub_20822C
			bra.w	loc_20827E
; END OF FUNCTION CHUNK FOR sub_208172
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
byte_20821C:	dc.b 0						; DATA XREF: sub_208172+7C↑r
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b   1
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   3
			dc.b   3
			dc.b   3
			dc.b   4
			dc.b   4
			dc.b   5
			dc.b   5
			dc.b   5
; =============== S U B R O U T I N E =======================================
sub_20822C:								; CODE XREF: sub_208172:loc_208212↑p
			move.w	obj.xpos(a1),d0
			sub.w	obj.xpos(a0),d0
			bcc.s	loc_20825A
			btst	#2,(word_FFF602).w
			beq.s	loc_208244
			addq.b	#1,obj.field_39(a1)
			bra.s	locret_20827C
; ---------------------------------------------------------------------------
loc_208244:								; CODE XREF: sub_20822C+10↑j
			btst	#3,(word_FFF602).w
			beq.s	locret_20827C
			subq.b	#1,obj.field_39(a1)
			bcc.s	locret_20827C
			move.b	#0,obj.field_39(a1)
			bra.s	locret_20827C
; ---------------------------------------------------------------------------
loc_20825A:								; CODE XREF: sub_20822C+8↑j
			btst	#3,(word_FFF602).w
			beq.s	loc_208268
			addq.b	#1,obj.field_39(a1)
			bra.s	locret_20827C
; ---------------------------------------------------------------------------
loc_208268:								; CODE XREF: sub_20822C+34↑j
			btst	#2,(word_FFF602).w
			beq.s	locret_20827C
			subq.b	#1,obj.field_39(a1)
			bcc.s	locret_20827C
			move.b	#0,obj.field_39(a1)
locret_20827C:							; CODE XREF: sub_20822C+16↑j
										; sub_20822C+1E↑j ...
			rts
; End of function sub_20822C
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_208172
loc_20827E:								; CODE XREF: sub_208172+A4↑j
			move.b	(word_FFF602+1).w,d0
			andi.b	#$70,d0
			beq.w	locret_208332
			move.w	#$680,d2
			btst	#6,obj.status(a0)
			beq.s	loc_20829A
			move.w	#$380,d2
loc_20829A:								; CODE XREF: sub_208172+122↑j
			moveq	#0,d0
			move.b	obj.angle(a1),d0
			subi.b	#$40,d0
			jsr	(calcsine).l
			muls.w	d2,d1
			asr.l	#8,d1
			add.w	d1,obj.xvel(a1)
			muls.w	d2,d0
			asr.l	#8,d0
			add.w	d0,obj.yvel(a1)
			bset	#1,obj.status(a1)
			bclr	#5,obj.status(a1)
			move.b	#1,obj.field_3C(a1)
			clr.b	obj.field_38(a1)
			move.w	#$A0,d0
			jsr	(queuesound2).l
			tst.b	(miniplay_flag).w
			beq.s	loc_2082EE
			move.b	#$A,obj.field_16(a1)
			move.b	#5,obj.field_17(a1)
			bra.s	loc_2082FA
; ---------------------------------------------------------------------------
loc_2082EE:								; CODE XREF: sub_208172+16C↑j
			move.b	#$13,obj.field_16(a1)
			move.b	#9,obj.field_17(a1)
loc_2082FA:								; CODE XREF: sub_208172+17A↑j
			btst	#2,obj.status(a1)
			bne.s	loc_208334
			tst.b	(miniplay_flag).w
			beq.s	loc_208316
			move.b	#$A,obj.field_16(a1)
			move.b	#5,obj.field_17(a1)
			bra.s	loc_208326
; ---------------------------------------------------------------------------
loc_208316:								; CODE XREF: sub_208172+194↑j
			move.b	#$E,obj.field_16(a1)
			move.b	#7,obj.field_17(a1)
			addq.w	#5,obj.ypos(a1)
loc_208326:								; CODE XREF: sub_208172+1A2↑j
			bset	#2,obj.status(a1)
			move.b	#2,obj.ani(a1)
locret_208332:							; CODE XREF: sub_208172+114↑j
			rts
; ---------------------------------------------------------------------------
loc_208334:								; CODE XREF: sub_208172+18E↑j
			bset	#4,obj.status(a1)
			rts
; END OF FUNCTION CHUNK FOR sub_208172
; ---------------------------------------------------------------------------
obj09_ani:	dc.w unk_20833E-*			; DATA XREF: ROM:0020810E↑o
unk_20833E: dc.b   1					; DATA XREF: ROM:obj09_ani↑o
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b $FF
			dc.b   0
obj09_map:	dc.w byte_20834A-*			; DATA XREF: ROM:00206B72↑o
										; ROM:00206B7E↑o ...
			dc.w byte_208356-obj09_map
			dc.w byte_208362-obj09_map
byte_20834A:	dc.b 2						; DATA XREF: ROM:obj09_map↑o
			dc.b $F8,  5,  0,  0,$F0
			dc.b $F8,  5,  8,  0,  0
			even
byte_208356:	dc.b 2						; DATA XREF: ROM:00208346↑o
			dc.b $F8,  5,  0,  0,$F0
			dc.b $F8,  5,  8,  0,  0
			even
byte_208362:	dc.b 1						; DATA XREF: ROM:00208348↑o
			dc.b $F8, $D,  0,  4,$F0
; ---------------------------------------------------------------------------
obj1B:									; DATA XREF: ROM:00203516↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_208382(pc,d0.w),d0
			jsr	off_208382(pc,d0.w)
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_208382: dc.w loc_208386-*			; CODE XREF: ROM:00208372↑p
										; DATA XREF: ROM:0020836E↑r ...
			dc.w loc_2083B8-off_208382
; ---------------------------------------------------------------------------
loc_208386:								; DATA XREF: ROM:off_208382↑o
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.b	#4,obj.priority(a0)
			move.l	#obj1B_map,obj.mappings(a0)
			move.b	#$10,obj.field_19(a0)
			move.b	#$10,obj.field_16(a0)
			move.b	#0,obj.frame(a0)
			moveq	#$B,d0
			jsr	(sub_20DC4C).l
loc_2083B8:								; DATA XREF: ROM:00208384↑o
			tst.b	obj.render(a0)
			bpl.s	locret_2083D8
			lea	(actwk).w,a1
			bsr.w	sub_2083CA
			lea	(byte_FFD040).w,a1
; =============== S U B R O U T I N E =======================================
sub_2083CA:								; CODE XREF: ROM:002083C2↑p
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_2083CA
; ---------------------------------------------------------------------------
locret_2083D8:							; CODE XREF: ROM:002083BC↑j
			rts
; ---------------------------------------------------------------------------
obj1B_map:	dc.w byte_2083DC-*			; DATA XREF: ROM:00206B2A↑o
										; ROM:00208396↑o
byte_2083DC:	dc.b 2						; DATA XREF: ROM:obj1B_map↑o
			dc.b $F8,  2,  0,  0,$EC
			dc.b $F0, $F,  0,  3,$F4
			even
; ---------------------------------------------------------------------------
obj0F:									; DATA XREF: ROM:002034E6↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_208416(pc,d0.w),d0
			jsr	off_208416(pc,d0.w)
			move.w	obj.field_36(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bhi.w	deleteobj
			rts
; ---------------------------------------------------------------------------
off_208416: dc.w loc_20841C-*			; CODE XREF: ROM:002083F2↑p
										; DATA XREF: ROM:002083EE↑r ...
			dc.w loc_20848A-off_208416
			dc.w loc_2084AA-off_208416
; ---------------------------------------------------------------------------
loc_20841C:								; DATA XREF: ROM:off_208416↑o
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.b	#4,obj.priority(a0)
			move.l	#obj0F_map,obj.mappings(a0)
			move.b	#8,obj.field_19(a0)
			move.b	#8,obj.field_16(a0)
			move.w	obj.xpos(a0),obj.field_36(a0)
			move.w	#$180,obj.xvel(a0)
			moveq	#$E,d0
			jsr	(sub_20DC4C).l
			jsr	(findfreeobj).l
			beq.s	loc_208462
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_208462:								; CODE XREF: ROM:0020845A↑j
			move.b	#$A,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			subi.w	#$10,obj.ypos(a1)
			move.b	#$F0,obj.field_39(a1)
			move.w	a0,obj.field_34(a1)
			move.b	obj.field_28(a0),obj.field_28(a1)
loc_20848A:								; DATA XREF: ROM:00208418↑o
			jsr	(sub_20611C).l
			tst.w	d1
			bpl.s	loc_2084A4
			add.w	d1,obj.ypos(a0)
			move.w	obj.ypos(a0),obj.field_32(a0)
			addq.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_2084A4:								; CODE XREF: ROM:00208492↑j
			addq.w	#1,obj.ypos(a0)
			rts
; ---------------------------------------------------------------------------
loc_2084AA:								; DATA XREF: ROM:0020841A↑o
			tst.w	(word_FF1278).l
			bne.s	loc_2084E0
			jsr	(sub_20611C).l
			add.w	d1,obj.ypos(a0)
			move.w	obj.field_32(a0),d0
			sub.w	obj.ypos(a0),d0
			cmpi.w	#$C,d0
			bcs.s	loc_2084CE
			neg.w	obj.xvel(a0)
loc_2084CE:								; CODE XREF: ROM:002084C8↑j
			jsr	(sub_203166).l
			lea	(off_2089C0).l,a1
			jsr	(animateobj).l
loc_2084E0:								; CODE XREF: ROM:002084B0↑j
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
obj0A:									; DATA XREF: ROM:002034D2↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			beq.s	loc_2084F4
			tst.b	obj.render(a0)
			bpl.s	loc_2084FC
loc_2084F4:								; CODE XREF: ROM:002084EC↑j
			move.w	off_20854E(pc,d0.w),d1
			jsr	off_20854E(pc,d1.w)
loc_2084FC:								; CODE XREF: ROM:002084F2↑j
			bsr.w	displaysprite
			move.l	#$FFFF0000,d1
			move.w	obj.field_34(a0),d1
			beq.s	loc_20852E
			movea.l d1,a1
			move.w	obj.xpos(a1),obj.xpos(a0)
			move.w	obj.ypos(a1),obj.ypos(a0)
			move.b	obj.field_38(a0),d0
			ext.w	d0
			add.w	d0,obj.xpos(a0)
			move.b	obj.field_39(a0),d0
			ext.w	d0
			add.w	d0,obj.ypos(a0)
loc_20852E:								; CODE XREF: ROM:0020850A↑j
			move.w	obj.field_36(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bhi.w	deleteobj
			rts
; ---------------------------------------------------------------------------
off_20854E: dc.w loc_208568-*			; CODE XREF: ROM:002084F8↑p
										; DATA XREF: ROM:loc_2084F4↑r ...
			dc.w loc_208624-off_20854E
			dc.w loc_208670-off_20854E
			dc.w loc_208686-off_20854E
			dc.w loc_2086AC-off_20854E
			dc.w loc_208734-off_20854E
			dc.w loc_20874E-off_20854E
			dc.w loc_20876E-off_20854E
			dc.w loc_2087B8-off_20854E
			dc.w loc_2087CE-off_20854E
			dc.w loc_2087E0-off_20854E
			dc.w loc_208896-off_20854E
			dc.w loc_2088A0-off_20854E
; ---------------------------------------------------------------------------
loc_208568:								; DATA XREF: ROM:off_20854E↑o
			addq.b	#2,obj.routine(a0)
			move.l	#obj0A_map,obj.mappings(a0)
			move.w	#$520,obj.vram(a0)
			ori.b	#4,obj.render(a0)
			move.b	#$10,obj.field_19(a0)
			move.b	#8,obj.field_16(a0)
			move.w	obj.xpos(a0),obj.field_36(a0)
			move.b	#4,obj.priority(a0)
			move.b	obj.field_28(a0),d0
			btst	#2,d0
			beq.s	loc_2085BE
			move.b	#8,obj.routine(a0)
			move.b	#8,obj.field_19(a0)
			move.b	#$10,obj.field_16(a0)
			move.l	#obj0A_map_2,obj.mappings(a0)
			bra.s	loc_2085FA
; ---------------------------------------------------------------------------
loc_2085BE:								; CODE XREF: ROM:002085A0↑j
			btst	#3,d0
			beq.s	loc_2085E6
			move.b	#$14,obj.routine(a0)
			move.b	#$10,obj.field_16(a0)
			move.l	#obj0A_map_3,obj.mappings(a0)
			move.l	d0,-(sp)
			moveq	#$F,d0
			jsr	(sub_20DC4C).l
			move.l	(sp)+,d0
			bra.s	loc_2085FA
; ---------------------------------------------------------------------------
loc_2085E6:								; CODE XREF: ROM:002085C2↑j
			btst	#1,obj.render(a0)
			beq.s	loc_2085FA
			move.b	#$E,obj.routine(a0)
			bset	#1,obj.status(a0)
loc_2085FA:								; CODE XREF: ROM:002085BC↑j
										; ROM:002085E4↑j ...
			btst	#1,d0
			beq.s	loc_208606
			bset	#5,obj.vram(a0)
loc_208606:								; CODE XREF: ROM:002085FE↑j
			andi.w	#2,d0
			move.w	word_208612(pc,d0.w),obj.field_30(a0)
			rts
; ---------------------------------------------------------------------------
word_208612:	dc.w $F000					; DATA XREF: ROM:0020860A↑r
			dc.w $F600
; =============== S U B R O U T I N E =======================================
sub_208616:								; CODE XREF: ROM:0020862E↓p
										; ROM:00208638↓p ...
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_208616
; ---------------------------------------------------------------------------
loc_208624:								; DATA XREF: ROM:00208550↑o
			tst.b	obj.render(a0)
			bpl.s	locret_20863C
			lea	(actwk).w,a1
			bsr.s	sub_208616
			beq.s	loc_208634
			bsr.s	sub_20863E
loc_208634:								; CODE XREF: ROM:00208630↑j
			lea	(byte_FFD040).w,a1
			bsr.s	sub_208616
			bne.s	sub_20863E
locret_20863C:							; CODE XREF: ROM:00208628↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_20863E:								; CODE XREF: ROM:00208632↑p
										; ROM:0020863A↑j
			move.b	#4,obj.routine(a0)
			addq.w	#8,obj.ypos(a1)
			move.w	obj.field_30(a0),obj.yvel(a1)
			bset	#1,obj.status(a1)
			bclr	#3,obj.status(a1)
			move.b	#$10,obj.ani(a1)
			bclr	#3,obj.status(a0)
			move.w	#$98,d0
			jmp	(queuesound2).l
; End of function sub_20863E
; ---------------------------------------------------------------------------
loc_208670:								; DATA XREF: ROM:00208552↑o
			lea	(actwk).w,a1
			bsr.s	sub_208616
			lea	(byte_FFD040).w,a1
			bsr.s	sub_208616
			lea	(off_20891C).l,a1
			bra.w	animateobj
; ---------------------------------------------------------------------------
loc_208686:								; DATA XREF: ROM:00208554↑o
			bclr	#3,obj.status(a0)
			move.b	#1,obj.prevani(a0)
			subq.b	#4,obj.routine(a0)
			move.b	#0,obj.frame(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_20869E:								; CODE XREF: ROM:002086B6↓p
										; ROM:002086C6↓p ...
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_20869E
; ---------------------------------------------------------------------------
loc_2086AC:								; DATA XREF: ROM:00208556↑o
			tst.b	obj.render(a0)
			bpl.s	locret_2086D0
			lea	(actwk).w,a1
			bsr.s	sub_20869E
			btst	#5,obj.status(a0)
			beq.s	loc_2086C2
			bsr.s	sub_2086D2
loc_2086C2:								; CODE XREF: ROM:002086BE↑j
			lea	(byte_FFD040).w,a1
			bsr.s	sub_20869E
			btst	#5,obj.status(a0)
			bne.s	sub_2086D2
locret_2086D0:							; CODE XREF: ROM:002086B0↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_2086D2:								; CODE XREF: ROM:002086C0↑p
										; ROM:002086CE↑j
			move.b	#$A,obj.routine(a0)
			move.w	obj.field_30(a0),obj.xvel(a1)
			addq.w	#8,obj.xpos(a1)
			bset	#0,obj.status(a1)
			btst	#0,obj.status(a0)
			bne.s	loc_208700
			subi.w	#$10,obj.xpos(a1)
			neg.w	obj.xvel(a1)
			bclr	#0,obj.status(a1)
loc_208700:								; CODE XREF: sub_2086D2+1C↑j
			move.w	#$F,obj.field_3E(a1)
			move.w	obj.xvel(a1),obj.inertia(a1)
			btst	#2,obj.status(a1)
			bne.s	loc_20871A
			move.b	#0,obj.ani(a1)
loc_20871A:								; CODE XREF: sub_2086D2+40↑j
			clr.b	obj.angle(a1)
			bclr	#5,obj.status(a0)
			bclr	#5,obj.status(a1)
			move.w	#$98,d0
			jmp	(queuesound2).l
; End of function sub_2086D2
; ---------------------------------------------------------------------------
loc_208734:								; DATA XREF: ROM:00208558↑o
			lea	(actwk).w,a1
			bsr.w	sub_20869E
			lea	(byte_FFD040).w,a1
			bsr.w	sub_20869E
			lea	(off_20891C).l,a1
			bra.w	animateobj
; ---------------------------------------------------------------------------
loc_20874E:								; DATA XREF: ROM:0020855A↑o
			move.b	#1,obj.prevani(a0)
			subq.b	#4,obj.routine(a0)
			move.b	#0,obj.frame(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_208760:								; CODE XREF: ROM:00208778↓p
										; ROM:00208782↓p ...
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_208760
; ---------------------------------------------------------------------------
loc_20876E:								; DATA XREF: ROM:0020855C↑o
			tst.b	obj.render(a0)
			bpl.s	locret_208786
			lea	(actwk).w,a1
			bsr.s	sub_208760
			beq.s	loc_20877E
			bsr.s	sub_208788
loc_20877E:								; CODE XREF: ROM:0020877A↑j
			lea	(byte_FFD040).w,a1
			bsr.s	sub_208760
			bne.s	sub_208788
locret_208786:							; CODE XREF: ROM:00208772↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_208788:								; CODE XREF: ROM:0020877C↑p
										; ROM:00208784↑j
			move.b	#$10,obj.routine(a0)
			subq.w	#8,obj.ypos(a1)
			move.w	obj.field_30(a0),obj.yvel(a1)
			neg.w	obj.yvel(a1)
			bset	#1,obj.status(a1)
			bclr	#3,obj.status(a1)
			bclr	#3,obj.status(a0)
			move.w	#$98,d0
			jsr	(queuesound2).l
loc_2087B8:								; DATA XREF: ROM:0020855E↑o
			lea	(actwk).w,a1
			bsr.s	sub_208760
			lea	(byte_FFD040).w,a1
			bsr.s	sub_208760
			lea	(off_20891C).l,a1
			bra.w	animateobj
; End of function sub_208788
; ---------------------------------------------------------------------------
loc_2087CE:								; DATA XREF: ROM:00208560↑o
			move.b	#1,obj.prevani(a0)
			subq.b	#4,obj.routine(a0)
			move.b	#0,obj.frame(a0)
			rts
; ---------------------------------------------------------------------------
loc_2087E0:								; DATA XREF: ROM:00208562↑o
			tst.b	obj.render(a0)
			bpl.s	locret_20880C
			lea	(actwk).w,a1
			bsr.w	sub_208760
			bne.s	loc_2087F8
			btst	#5,obj.status(a0)
			beq.s	loc_2087FA
loc_2087F8:								; CODE XREF: ROM:002087EE↑j
			bsr.s	sub_20880E
loc_2087FA:								; CODE XREF: ROM:002087F6↑j
			lea	(byte_FFD040).w,a1
			bsr.w	sub_208760
			bne.s	sub_20880E
			btst	#5,obj.status(a0)
			bne.s	sub_20880E
locret_20880C:							; CODE XREF: ROM:002087E4↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_20880E:								; CODE XREF: ROM:loc_2087F8↑p
										; ROM:00208802↑j ...
			move.b	#$16,obj.routine(a0)
			moveq	#0,d0
			move.b	#$D0,d0
			jsr	(calcsine).l
			move.w	obj.field_30(a0),d2
			neg.w	d2
			mulu.w	d2,d0
			mulu.w	d2,d1
			lsr.l	#8,d0
			lsr.l	#8,d1
			move.w	d0,obj.yvel(a1)
			move.w	d1,obj.xvel(a1)
			addq.w	#8,obj.ypos(a1)
			btst	#1,obj.render(a0)
			beq.s	loc_20884C
			subi.w	#$10,obj.ypos(a1)
			neg.w	obj.yvel(a1)
loc_20884C:								; CODE XREF: sub_20880E+32↑j
			bclr	#0,obj.status(a1)
			subq.w	#8,obj.xpos(a1)
			btst	#0,obj.status(a0)
			beq.s	loc_20886E
			addi.w	#$10,obj.xpos(a1)
			bset	#0,obj.status(a1)
			neg.w	obj.xvel(a1)
loc_20886E:								; CODE XREF: sub_20880E+4E↑j
			bset	#1,obj.status(a1)
			bclr	#3,obj.status(a1)
			bclr	#5,obj.status(a1)
			bclr	#3,obj.status(a0)
			bclr	#5,obj.status(a0)
			move.w	#$98,d0
			jsr	(queuesound2).l
loc_208896:								; DATA XREF: ROM:00208564↑o
			lea	(off_20891C).l,a1
			bra.w	animateobj
; End of function sub_20880E
; ---------------------------------------------------------------------------
loc_2088A0:								; DATA XREF: ROM:00208566↑o
			move.b	#1,obj.prevani(a0)
			subq.b	#4,obj.routine(a0)
			move.b	#0,obj.frame(a0)
			rts
; ---------------------------------------------------------------------------
off_2088B2: dc.w unk_2088B6-*			; DATA XREF: ROM:002088B4↓o
			dc.w unk_2088C2-off_2088B2
unk_2088B6: dc.b   0					; DATA XREF: ROM:off_2088B2↑o
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   0
			dc.b $FC
unk_2088C2: dc.b   0					; DATA XREF: ROM:002088B4↑o
			dc.b   4
			dc.b   3
			dc.b   3
			dc.b   5
			dc.b   5
			dc.b   5
			dc.b   5
			dc.b   5
			dc.b   5
			dc.b   3
			dc.b $FC
off_2088CE: dc.w byte_2088DA-*			; DATA XREF: ROM:002088D0↓o
										; ROM:002088D2↓o ...
			dc.w byte_2088E5-off_2088CE
			dc.w byte_2088EB-off_2088CE
			dc.w byte_2088FB-off_2088CE
			dc.w byte_208901-off_2088CE
			dc.w byte_208907-off_2088CE
byte_2088DA:	dc.b 2						; DATA XREF: ROM:off_2088CE↑o
			dc.b $F8, $C,  0,  0,$F0
			dc.b   0, $C,  0,  4,$F0
byte_2088E5:	dc.b 1						; DATA XREF: ROM:002088D0↑o
			dc.b   0, $C,  0,  0,$F0
byte_2088EB:	dc.b 3						; DATA XREF: ROM:002088D2↑o
			dc.b $E8, $C,  0,  0,$F0
			dc.b $F0,  5,  0,  8,$F8
			dc.b   0, $C,  0, $C,$F0
byte_2088FB:	dc.b 1						; DATA XREF: ROM:002088D4↑o
			dc.b $F0,  7,  0,  0,$F8
byte_208901:	dc.b 1						; DATA XREF: ROM:002088D6↑o
			dc.b $F0,  3,  0,  4,$F8
byte_208907:	dc.b 4						; DATA XREF: ROM:002088D8↑o
			dc.b $F0,  3,  0,  4,$10
			dc.b $F8,  9,  0,  8,$F8
			dc.b $F0,  0,  0,  0,$F8
			dc.b   8,  0,  0,  3,$F8
off_20891C: dc.w unk_20891E-*			; DATA XREF: ROM:0020867C↑o
										; ROM:00208744↑o ...
unk_20891E: dc.b   0					; DATA XREF: ROM:off_20891C↑o
			dc.b   0
			dc.b   1
			dc.b   1
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   1
			dc.b $FC
obj0A_map:	dc.w byte_208936-*			; DATA XREF: ROM:00206BAE↑o
										; ROM:00206BBA↑o ...
			dc.w byte_208942-obj0A_map
			dc.w byte_208948-obj0A_map
obj0A_map_2:	dc.w byte_208958-*			; DATA XREF: ROM:00206BC6↑o
										; ROM:00206BD2↑o ...
			dc.w byte_208964-obj0A_map_2
			dc.w byte_20896A-obj0A_map_2
byte_208936:	dc.b 2						; DATA XREF: ROM:obj0A_map↑o
			dc.b $F8, $C,  0,  0,$F0
			dc.b   0, $C,  0,  4,$F0
			even
byte_208942:	dc.b 1						; DATA XREF: ROM:0020892C↑o
			dc.b   0, $C,  0,  0,$F0
byte_208948:	dc.b 3						; DATA XREF: ROM:0020892E↑o
			dc.b $E0, $C,  0,  0,$F0
			dc.b $E8,  6,  0,  8,$F8
			dc.b   0, $C,  0, $E,$F0
byte_208958:	dc.b 2						; DATA XREF: ROM:obj0A_map_2↑o
			dc.b $F0,  3,  0,$12,  0
			dc.b $F0,  3,  0,$16,$F8
			even
byte_208964:	dc.b 1						; DATA XREF: ROM:00208932↑o
			dc.b $F0,  3,  0,$12,$F8
byte_20896A:	dc.b 3						; DATA XREF: ROM:00208934↑o
			dc.b $F0,  3,  0,$12,$18
			dc.b $F8,  9,  0,$1A,  0
			dc.b $F0,  3,  0,$20,$F8
obj0A_map_3:	dc.w byte_208980-*			; DATA XREF: ROM:00206BDE↑o
										; ROM:00206BEA↑o ...
			dc.w byte_208990-obj0A_map_3
			dc.w byte_2089A6-obj0A_map_3
byte_208980:	dc.b 3						; DATA XREF: ROM:obj0A_map_3↑o
			dc.b $F0,  8,  0,  0,$F0
			dc.b $F8, $D,  0,  3,$F0
			dc.b   8,  8,  0, $B,$F8
byte_208990:	dc.b 4						; DATA XREF: ROM:0020897C↑o
			dc.b $F0,  5,  0, $E,$F0
			dc.b $F8,  0,  0,$12,  0
			dc.b   0,  0,  0,$13,$F0
			dc.b   0,  9,  0,$14,$F8
			even
byte_2089A6:	dc.b 5						; DATA XREF: ROM:0020897E↑o
			dc.b $E0,  8,  0,  0,  0
			dc.b $E8, $E,  0,$1A,  0
			dc.b $F0,  1,  0,$26,$F8
			dc.b $F8,  1,  0,$28,$F0
			dc.b   0,  5,  0,$2A,$F8
off_2089C0: dc.w unk_2089C2-*			; DATA XREF: ROM:002084D4↑o
unk_2089C2: dc.b   8					; DATA XREF: ROM:off_2089C0↑o
			dc.b   0
			dc.b   1
			dc.b $FF
obj0F_map:	dc.w byte_2089CA-*			; DATA XREF: ROM:00206B96↑o
										; ROM:00206BA2↑o ...
			dc.w byte_2089D0-obj0F_map
byte_2089CA:	dc.b 1						; DATA XREF: ROM:obj0F_map↑o
			dc.b $F8,  5,  0,  0,$F8
byte_2089D0:	dc.b 1						; DATA XREF: ROM:002089C8↑o
			dc.b $F8,  5,  0,  4,$F8
; ---------------------------------------------------------------------------
obj10:									; DATA XREF: ROM:002034EA↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2089E4(pc,d0.w),d1
			jmp	off_2089E4(pc,d1.w)
; ---------------------------------------------------------------------------
off_2089E4: dc.w loc_208A0E-*			; CODE XREF: ROM:002089E0↑j
										; DATA XREF: ROM:002089DC↑r ...
			dc.w loc_208AFE-off_2089E4
			dc.w loc_208B30-off_2089E4
			dc.w loc_208B6A-off_2089E4
			dc.w loc_208B78-off_2089E4
byte_2089EE:	dc.b $10,  0				; DATA XREF: ROM:00208A4E↓r
										; ROM:00208A54↓r
			dc.b $18,  0
			dc.b $20,  0
			dc.b   0,$10
			dc.b   0,$18
			dc.b   0,$20
			dc.b $10,$10
			dc.b $18,$18
			dc.b $20,$20
			dc.b $F0,$10
			dc.b $E8,$18
			dc.b $E0,$20
			dc.b $10,  8
			dc.b $18,$10
			dc.b $F0,  8
			dc.b $E8,$10
; ---------------------------------------------------------------------------
loc_208A0E:								; DATA XREF: ROM:off_2089E4↑o
			lea	(unk_FF1400).l,a2
			moveq	#0,d0
			move.b	obj.field_23(a0),d0
			move.w	d0,d1
			add.w	d1,d1
			add.w	d1,d0
			moveq	#0,d1
			move.b	(byte_FF123D).l,d1
			add.w	d1,d0
			lea	2(a2,d0.w),a2
			move.b	(a2),d4
			move.b	obj.field_28(a0),d1
			moveq	#0,d0
			move.b	d1,d0
			andi.w	#7,d1
			cmpi.w	#7,d1
			bne.s	loc_208A44
			moveq	#6,d1
loc_208A44:								; CODE XREF: ROM:00208A40↑j
			swap	d1
			move.w	#1,d1
			lsr.b	#4,d0
			add.w	d0,d0
			move.b	byte_2089EE(pc,d0.w),d5
			ext.w	d5
			move.b	byte_2089EE+1(pc,d0.w),d6
			ext.w	d6
			movea.l a0,a1
			move.w	obj.xpos(a0),d2
			move.w	obj.ypos(a0),d3
			lea	1(a2),a3
			moveq	#0,d0
			move.b	(byte_FF123D).l,d0
loc_208A70:								; CODE XREF: ROM:00208A76↓j
			move.b	-(a3),d4
			lsr.b	d1,d4
			bcs.s	loc_208AEA
			dbf	d0,loc_208A70
			bclr	#7,(a2)
			bra.s	loc_208AA2
; ---------------------------------------------------------------------------
loc_208A80:								; CODE XREF: ROM:00208AF2↓j
			swap	d1
			lea	1(a2),a3
			moveq	#0,d0
			move.b	(byte_FF123D).l,d0
loc_208A8E:								; CODE XREF: ROM:00208A94↓j
			move.b	-(a3),d4
			lsr.b	d1,d4
			bcs.s	loc_208AEA
			dbf	d0,loc_208A8E
			bclr	#7,(a2)
			bsr.w	findfreeobj
			bne.s	loc_208AF6
loc_208AA2:								; CODE XREF: ROM:00208A7E↑j
			move.b	#$10,obj.id(a1)
			addq.b	#2,obj.routine(a1)
			move.w	d2,obj.xpos(a1)
			move.w	obj.xpos(a0),obj.field_32(a1)
			move.w	d3,obj.ypos(a1)
			move.l	#ring_map,obj.mappings(a1)
			move.w	#$A7AE,obj.vram(a1)
			move.b	#4,obj.render(a1)
			move.b	#2,obj.priority(a1)
			move.b	#$47,obj.colflag(a1) ; 'G'
			move.b	#8,obj.field_19(a1)
			move.b	obj.field_23(a0),obj.field_23(a1)
			move.b	d1,obj.field_34(a1)
loc_208AEA:								; CODE XREF: ROM:00208A74↑j
										; ROM:00208A92↑j
			addq.w	#1,d1
			add.w	d5,d2
			add.w	d6,d3
			swap	d1
			dbf	d1,loc_208A80
loc_208AF6:								; CODE XREF: ROM:00208AA0↑j
			btst	#0,(a2)
			bne.w	deleteobj
loc_208AFE:								; DATA XREF: ROM:002089E6↑o
			move.w	obj.field_32(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bhi.w	loc_208B78
			tst.w	(word_FF1278).l
			bne.s	loc_208B2C
			move.b	(byte_FF12C3).l,obj.frame(a0)
loc_208B2C:								; CODE XREF: ROM:00208B22↑j
			bra.w	displaysprite
; ---------------------------------------------------------------------------
loc_208B30:								; DATA XREF: ROM:002089E8↑o
			addq.b	#2,obj.routine(a0)
			move.b	#0,obj.colflag(a0)
			move.b	#1,obj.priority(a0)
			bsr.w	sub_208B7C
			lea	(unk_FF1400).l,a2
			moveq	#0,d0
			move.b	obj.field_23(a0),d0
			move.w	d0,d1
			add.w	d1,d1
			add.w	d1,d0
			moveq	#0,d1
			move.b	(byte_FF123D).l,d1
			add.w	d1,d0
			move.b	obj.field_34(a0),d1
			subq.b	#1,d1
			bset	d1,2(a2,d0.w)
loc_208B6A:								; DATA XREF: ROM:002089EA↑o
			lea	(ring_ani).l,a1
			bsr.w	animateobj
			bra.w	displaysprite
; ---------------------------------------------------------------------------
loc_208B78:								; CODE XREF: ROM:00208B18↑j
										; DATA XREF: ROM:002089EC↑o
			bra.w	deleteobj
; =============== S U B R O U T I N E =======================================
sub_208B7C:								; CODE XREF: ROM:00208B40↑p
										; ROM:00208D18↓p
			addq.w	#1,(word_FF1220).l
			ori.b	#1,(byte_FF121D).l
			move.w	#$95,d0
			cmpi.w	#100,(word_FF1220).l
			bcs.s	loc_208BC6
			bset	#1,(byte_FF121B).l
			beq.s	loc_208BB6
			cmpi.w	#200,(word_FF1220).l
			bcs.s	loc_208BC6
			bset	#2,(byte_FF121B).l
			bne.s	loc_208BC6
loc_208BB6:								; CODE XREF: sub_208B7C+24↑j
			addq.b	#1,(byte_FF1212).l
			addq.b	#1,(byte_FF121C).l
			move.w	#$88,d0
loc_208BC6:								; CODE XREF: sub_208B7C+1A↑j
										; sub_208B7C+2E↑j ...
			jmp	(queuesound2).l
; End of function sub_208B7C
; ---------------------------------------------------------------------------
obj11:									; DATA XREF: ROM:002034EE↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_208BDA(pc,d0.w),d1
			jmp	off_208BDA(pc,d1.w)
; ---------------------------------------------------------------------------
off_208BDA: dc.w loc_208BE4-*			; CODE XREF: ROM:00208BD6↑j
										; DATA XREF: ROM:00208BD2↑r ...
			dc.w loc_208CB0-off_208BDA
			dc.w loc_208D08-off_208BDA
			dc.w loc_208D1C-off_208BDA
			dc.w loc_208D2A-off_208BDA
; ---------------------------------------------------------------------------
loc_208BE4:								; DATA XREF: ROM:off_208BDA↑o
			movea.l a0,a1
			moveq	#0,d5
			move.w	(word_FF1220).l,d5
			moveq	#$20,d0
			cmp.w	d0,d5
			bcs.s	loc_208BF6
			move.w	d0,d5
loc_208BF6:								; CODE XREF: ROM:00208BF2↑j
			subq.w	#1,d5
			move.w	#$288,d4
			bra.s	loc_208C06
; ---------------------------------------------------------------------------
loc_208BFE:								; CODE XREF: ROM:00208C8A↓j
			bsr.w	findfreeobj
			bne.w	loc_208C8E
loc_208C06:								; CODE XREF: ROM:00208BFC↑j
			move.b	#$11,obj.id(a1)
			addq.b	#2,obj.routine(a1)
			move.b	#8,obj.field_16(a1)
			move.b	#8,obj.field_17(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.l	#ring_map,obj.mappings(a1)
			move.w	#$A7AE,obj.vram(a1)
			move.b	#4,obj.render(a1)
			move.b	#3,obj.priority(a1)
			move.b	#$47,obj.colflag(a1) ; 'G'
			move.b	#8,obj.field_19(a1)
			move.b	#-1,(byte_FF12C6).l
			tst.w	d4
			bmi.s	loc_208C7E
			move.w	d4,d0
			jsr	(calcsine).l
			move.w	d4,d2
			lsr.w	#8,d2
			asl.w	d2,d0
			asl.w	d2,d1
			move.w	d0,d2
			move.w	d1,d3
			addi.b	#$10,d4
			bcc.s	loc_208C7E
			subi.w	#$80,d4
			bcc.s	loc_208C7E
			move.w	#$288,d4
loc_208C7E:								; CODE XREF: ROM:00208C58↑j
										; ROM:00208C72↑j ...
			move.w	d2,obj.xvel(a1)
			move.w	d3,obj.yvel(a1)
			neg.w	d2
			neg.w	d4
			dbf	d5,loc_208BFE
loc_208C8E:								; CODE XREF: ROM:00208C02↑j
			move.w	#0,(word_FF1220).l
			move.b	#$80,(byte_FF121D).l
			move.b	#0,(byte_FF121B).l
			move.w	#$94,d0
			jsr	(queuesound2).l
loc_208CB0:								; DATA XREF: ROM:00208BDC↑o
			move.b	(byte_FF12C7).l,obj.frame(a0)
			bsr.w	sub_203166
			addi.w	#$18,obj.yvel(a0)
			bmi.s	loc_208CEE
			move.b	(dword_FF120C+3).l,d0
			add.b	d7,d0
			andi.b	#3,d0
			bne.s	loc_208CEE
			jsr	(sub_20611C).l
			tst.w	d1
			bpl.s	loc_208CEE
			add.w	d1,obj.ypos(a0)
			move.w	obj.yvel(a0),d0
			asr.w	#2,d0
			sub.w	d0,obj.yvel(a0)
			neg.w	obj.yvel(a0)
loc_208CEE:								; CODE XREF: ROM:00208CC2↑j
										; ROM:00208CD0↑j ...
			tst.b	(byte_FF12C6).l
			beq.s	loc_208D2A
			move.w	(dword_FFF72C+2).w,d0
			addi.w	#224,d0
			cmp.w	obj.ypos(a0),d0
			bcs.s	loc_208D2A
			bra.w	displaysprite
; ---------------------------------------------------------------------------
loc_208D08:								; DATA XREF: ROM:00208BDE↑o
			addq.b	#2,obj.routine(a0)
			move.b	#0,obj.colflag(a0)
			move.b	#1,obj.priority(a0)
			bsr.w	sub_208B7C
loc_208D1C:								; DATA XREF: ROM:00208BE0↑o
			lea	(ring_ani).l,a1
			bsr.w	animateobj
			bra.w	displaysprite
; ---------------------------------------------------------------------------
loc_208D2A:								; CODE XREF: ROM:00208CF4↑j
										; ROM:00208D02↑j
										; DATA XREF: ...
			bra.w	deleteobj
; ---------------------------------------------------------------------------
ring_ani:	dc.w unk_208D30-*			; DATA XREF: ROM:loc_208B6A↑o
										; ROM:loc_208D1C↑o
unk_208D30: dc.b   5					; DATA XREF: ROM:ring_ani↑o
			dc.b   4
			dc.b   5
			dc.b   6
			dc.b   7
			dc.b $FC
ring_map:	dc.w byte_208D48-*			; DATA XREF: ROM:00208ABA↑o
										; ROM:00208C28↑o ...
			dc.w byte_208D4E-ring_map
			dc.w byte_208D54-ring_map
			dc.w byte_208D5A-ring_map
			dc.w byte_208D60-ring_map
			dc.w byte_208D66-ring_map
			dc.w byte_208D6C-ring_map
			dc.w byte_208D72-ring_map
			dc.w byte_208D78-ring_map
byte_208D48:	dc.b 1						; DATA XREF: ROM:ring_map↑o
			dc.b $F8,  5,  0,  0,$F8
byte_208D4E:	dc.b 1						; DATA XREF: ROM:00208D38↑o
			dc.b $F8,  5,  0,  4,$F8
byte_208D54:	dc.b 1						; DATA XREF: ROM:00208D3A↑o
			dc.b $F8,  1,  0,  8,$FC
byte_208D5A:	dc.b 1						; DATA XREF: ROM:00208D3C↑o
			dc.b $F8,  5,  8,  4,$F8
byte_208D60:	dc.b 1						; DATA XREF: ROM:00208D3E↑o
			dc.b $F8,  5,  0, $A,$F8
byte_208D66:	dc.b 1						; DATA XREF: ROM:00208D40↑o
			dc.b $F8,  5,$18, $A,$F8
byte_208D6C:	dc.b 1						; DATA XREF: ROM:00208D42↑o
			dc.b $F8,  5,$10, $A,$F8
byte_208D72:	dc.b 1						; DATA XREF: ROM:00208D44↑o
			dc.b $F8,  5,  8, $A,$F8
byte_208D78:	dc.b 0						; DATA XREF: ROM:00208D46↑o
			even
off_208D7A: dc.w byte_208D82-*			; DATA XREF: ROM:00208D7C↓o
										; ROM:00208D7E↓o ...
			dc.w byte_208DB5-off_208D7A
			dc.w byte_208DDE-off_208D7A
			dc.w byte_208DF3-off_208D7A
byte_208D82:	dc.b $A						; DATA XREF: ROM:off_208D7A↑o
			dc.b $E0,  8,  0,  0,$E8
			dc.b $E0,  8,  0,  3,  0
			dc.b $E8, $C,  0,  6,$E0
			dc.b $E8, $C,  0, $A,  0
			dc.b $F0,  7,  0, $E,$E0
			dc.b $F0,  7,  0,$16,$10
			dc.b $10, $C,  0,$1E,$E0
			dc.b $10, $C,  0,$22,  0
			dc.b $18,  8,  0,$26,$E8
			dc.b $18,  8,  0,$29,  0
byte_208DB5:	dc.b 8						; DATA XREF: ROM:00208D7C↑o
			dc.b $E0, $C,  0,$2C,$F0
			dc.b $E8,  8,  0,$30,$E8
			dc.b $E8,  9,  0,$33,  0
			dc.b $F0,  7,  0,$39,$E8
			dc.b $F8,  5,  0,$41,  8
			dc.b   8,  9,  0,$45,  0
			dc.b $10,  8,  0,$4B,$E8
			dc.b $18, $C,  0,$4E,$F0
byte_208DDE:	dc.b 4						; DATA XREF: ROM:00208D7E↑o
			dc.b $E0,  7,  0,$52,$F4
			dc.b $E0,  3,  8,$52,  4
			dc.b   0,  7,  0,$5A,$F4
			dc.b   0,  3,  8,$5A,  4
byte_208DF3:	dc.b 8						; DATA XREF: ROM:00208D80↑o
			dc.b $E0, $C,  8,$2C,$F0
			dc.b $E8,  8,  8,$30,  0
			dc.b $E8,  9,  8,$33,$E8
			dc.b $F0,  7,  8,$39,  8
			dc.b $F8,  5,  8,$41,$E8
			dc.b   8,  9,  8,$45,$E8
			dc.b $10,  8,  8,$4B,  0
			dc.b $18, $C,  8,$4E,$F0
off_208E1C: dc.w byte_208E2C-*			; DATA XREF: ROM:00208E1E↓o
										; ROM:00208E20↓o ...
			dc.w byte_208E37-off_208E1C
			dc.w byte_208E4C-off_208E1C
			dc.w byte_208E61-off_208E1C
			dc.w byte_208E76-off_208E1C
			dc.w byte_208E8B-off_208E1C
			dc.w byte_208EA0-off_208E1C
			dc.w byte_208EAB-off_208E1C
byte_208E2C:	dc.b 2						; DATA XREF: ROM:off_208E1C↑o
			dc.b $E0, $F,  0,  0,  0
			dc.b   0, $F,$10,  0,  0
byte_208E37:	dc.b 4						; DATA XREF: ROM:00208E1E↑o
			dc.b $E0, $F,  0,$10,$F0
			dc.b $E0,  7,  0,$20,$10
			dc.b   0, $F,$10,$10,$F0
			dc.b   0,  7,$10,$20,$10
byte_208E4C:	dc.b 4						; DATA XREF: ROM:00208E20↑o
			dc.b $E0, $F,  0,$28,$E8
			dc.b $E0, $B,  0,$38,  8
			dc.b   0, $F,$10,$28,$E8
			dc.b   0, $B,$10,$38,  8
byte_208E61:	dc.b 4						; DATA XREF: ROM:00208E22↑o
			dc.b $E0, $F,  8,$34,$E0
			dc.b $E0, $F,  0,$34,  0
			dc.b   0, $F,$18,$34,$E0
			dc.b   0, $F,$10,$34,  0
byte_208E76:	dc.b 4						; DATA XREF: ROM:00208E24↑o
			dc.b $E0, $B,  8,$38,$E0
			dc.b $E0, $F,  8,$28,$F8
			dc.b   0, $B,$18,$38,$E0
			dc.b   0, $F,$18,$28,$F8
byte_208E8B:	dc.b 4						; DATA XREF: ROM:00208E26↑o
			dc.b $E0,  7,  8,$20,$E0
			dc.b $E0, $F,  8,$10,$F0
			dc.b   0,  7,$18,$20,$E0
			dc.b   0, $F,$18,$10,$F0
byte_208EA0:	dc.b 2						; DATA XREF: ROM:00208E28↑o
			dc.b $E0, $F,  8,  0,$E0
			dc.b   0, $F,$18,  0,$E0
byte_208EAB:	dc.b 4						; DATA XREF: ROM:00208E2A↑o
			dc.b $E0, $F,  0,$44,$E0
			dc.b $E0, $F,  8,$44,  0
			dc.b   0, $F,$10,$44,$E0
			dc.b   0, $F,$18,$44,  0
; ---------------------------------------------------------------------------
obj12:									; DATA XREF: ROM:002034F2↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_208EEE(pc,d0.w),d0
			jsr	off_208EEE(pc,d0.w)
			move.w	obj.xpos(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bhi.w	deleteobj
			rts
; ---------------------------------------------------------------------------
off_208EEE: dc.w loc_208EFC-*			; CODE XREF: ROM:00208ECA↑p
										; DATA XREF: ROM:00208EC6↑r ...
			dc.w loc_208F2E-off_208EEE
			dc.w loc_208F72-off_208EEE
			dc.w loc_208F94-off_208EEE
			dc.w loc_208FB8-off_208EEE
			dc.w loc_208FE6-off_208EEE
			dc.w loc_208FFA-off_208EEE
; ---------------------------------------------------------------------------
loc_208EFC:								; DATA XREF: ROM:off_208EEE↑o
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.l	#obj12_map,obj.mappings(a0)
			moveq	#5,d0
			jsr	(sub_20DC4C).l
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.b	#4,obj.field_16(a0)
			move.b	#5,obj.frame(a0)
loc_208F2E:								; DATA XREF: ROM:00208EF0↑o
			bsr.w	sub_209002
			tst.b	(byte_FF123D).l
			beq.s	loc_208F68
			cmpi.b	#2,(byte_FF123D).l
			bne.s	loc_208F4E
			btst	#3,obj.status(a0)
			bne.s	loc_208F6E
			bra.s	loc_208F68
; ---------------------------------------------------------------------------
loc_208F4E:								; CODE XREF: ROM:00208F42↑j
			move.b	#0,obj.frame(a0)
			btst	#3,obj.status(a0)
			beq.s	loc_208F68
			move.b	#6,obj.routine(a0)
			move.b	#1,obj.ani(a0)
loc_208F68:								; CODE XREF: ROM:00208F38↑j
										; ROM:00208F4C↑j ...
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_208F6E:								; CODE XREF: ROM:00208F4A↑j
			addq.b	#2,obj.routine(a0)
loc_208F72:								; DATA XREF: ROM:00208EF2↑o
			bsr.w	sub_209002
			addq.w	#2,obj.ypos(a0)
			move.w	(dword_FFF704).w,d0
			addi.w	#224,d0
			cmp.w	obj.ypos(a0),d0
			bcc.s	loc_208F8E
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_208F8E:								; CODE XREF: ROM:00208F86↑j
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_208F94:								; DATA XREF: ROM:00208EF4↑o
			bsr.w	sub_209002
			btst	#3,obj.status(a0)
			bne.s	loc_208FA8
			move.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_208FA8:								; CODE XREF: ROM:00208F9E↑j
			lea	(obj12_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_208FB8:								; DATA XREF: ROM:00208EF6↑o
			move.b	#0,obj.ani(a0)
			bsr.w	sub_209002
			btst	#3,obj.status(a0)
			bne.s	loc_208FD6
			addq.b	#2,obj.routine(a0)
			move.b	#2,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_208FD6:								; CODE XREF: ROM:00208FC8↑j
			lea	(obj12_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_208FE6:								; DATA XREF: ROM:00208EF8↑o
			bsr.w	sub_209002
			lea	(obj12_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_208FFA:								; DATA XREF: ROM:00208EFA↑o
			move.b	#2,obj.routine(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_209002:								; CODE XREF: ROM:loc_208F2E↑p
										; ROM:loc_208F72↑p ...
			lea	(actwk).w,a1
			bsr.w	sub_20900E
			lea	(byte_FFD040).w,a1
; End of function sub_209002
; =============== S U B R O U T I N E =======================================
sub_20900E:								; CODE XREF: sub_209002+4↑p
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			subq.w	#8,d4
			jmp	(sub_207F56).l
; End of function sub_20900E
; ---------------------------------------------------------------------------
obj12_ani:	dc.w unk_209024-*			; DATA XREF: ROM:loc_208FA8↑o
										; ROM:loc_208FD6↑o ...
			dc.w unk_209028-obj12_ani
			dc.w unk_209032-obj12_ani
unk_209024: dc.b   2					; DATA XREF: ROM:obj12_ani↑o
			dc.b   5
			dc.b $FF
			dc.b   0
unk_209028: dc.b   2					; DATA XREF: ROM:00209020↑o
			dc.b   1
			dc.b   5
			dc.b   2
			dc.b   5
			dc.b   3
			dc.b   5
			dc.b   4
			dc.b   5
			dc.b $FC
unk_209032: dc.b   2					; DATA XREF: ROM:00209022↑o
			dc.b   1
			dc.b   0
			dc.b   2
			dc.b   0
			dc.b   3
			dc.b   0
			dc.b   4
			dc.b   0
			dc.b $FC
obj12_map:	dc.w byte_209048-*			; DATA XREF: ROM:00208F06↑o
										; ROM:0020903E↓o ...
			dc.w byte_20904A-obj12_map
			dc.w byte_20905A-obj12_map
			dc.w byte_20906A-obj12_map
			dc.w byte_209076-obj12_map
			dc.w byte_209082-obj12_map
byte_209048:	dc.b 0						; DATA XREF: ROM:obj12_map↑o
			even
byte_20904A:	dc.b 3						; DATA XREF: ROM:0020903E↑o
			dc.b $F4,  9,  0,  0,$F4
			dc.b   4,  0,  0,  0,$FC
			dc.b   4,  0,  0,  0,  4
byte_20905A:	dc.b 3						; DATA XREF: ROM:00209040↑o
			dc.b $F4,  9,  8,  0,$F4
			dc.b   4,  0,  8,  0,$F4
			dc.b   4,  0,  8,  0,$FC
byte_20906A:	dc.b 2						; DATA XREF: ROM:00209042↑o
			dc.b $F4,  9,$18,  0,$F4
			dc.b   4,  0,$18,  0,$FC
			even
byte_209076:	dc.b 2						; DATA XREF: ROM:00209044↑o
			dc.b $F4,  9,$10,  0,$F4
			dc.b   4,  0,$10,  0,$FC
			even
byte_209082:	dc.b 1						; DATA XREF: ROM:00209046↑o
			dc.b $F4, $A,  0,  6,$F4
; ---------------------------------------------------------------------------
loc_209088:								; CODE XREF: ROM:002091B4↓j
			tst.b	(byte_FF0580_ext).l
			beq.s	loc_209096
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_209096:								; CODE XREF: ROM:0020908E↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2090B0(pc,d0.w),d0
			jsr	off_2090B0(pc,d0.w)
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_2090B0: dc.w loc_2090B8-*			; CODE XREF: ROM:002090A0↑p
										; DATA XREF: ROM:0020909C↑r ...
			dc.w loc_209124-off_2090B0
			dc.w loc_209154-off_2090B0
			dc.w locret_20917A-off_2090B0
; ---------------------------------------------------------------------------
loc_2090B8:								; DATA XREF: ROM:off_2090B0↑o
			addq.b	#2,obj.routine(a0)
			move.b	#$E,obj.field_16(a0)
			move.b	#$E,obj.field_17(a0)
			move.l	#monitor_map,obj.mappings(a0)
			move.w	#$5A8,obj.vram(a0)
			move.b	#4,obj.render(a0)
			move.b	#3,obj.priority(a0)
			move.b	#$F,obj.field_19(a0)
			move.b	obj.field_28(a0),obj.ani(a0)
			bsr.w	sub_20917C
			bclr	#7,2(a2,d0.w)
			move.b	#$A,obj.frame(a0)
			cmpi.b	#8,obj.field_28(a0)
			beq.s	loc_20910A
			addq.b	#2,obj.frame(a0)
loc_20910A:								; CODE XREF: ROM:00209104↑j
			btst	#0,2(a2,d0.w)
			beq.s	loc_20911E
			addq.b	#1,obj.frame(a0)
			move.b	#6,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20911E:								; CODE XREF: ROM:00209110↑j
			move.b	#$DF,obj.colflag(a0)
loc_209124:								; DATA XREF: ROM:002090B2↑o
			tst.b	obj.field_21(a0)
			beq.s	locret_209152
			move.b	#$3C,obj.field_2A(a0)
			addq.b	#2,obj.routine(a0)
			bsr.w	sub_20917C
			bset	#0,2(a2,d0.w)
			move.b	#$FF,(byte_FFF784).w
			cmpi.b	#8,obj.field_28(a0)
			beq.s	locret_209152
			move.b	#1,(byte_FFF784).w
locret_209152:							; CODE XREF: ROM:00209128↑j
										; ROM:0020914A↑j
			rts
; ---------------------------------------------------------------------------
loc_209154:								; DATA XREF: ROM:002090B4↑o
			subq.b	#1,obj.field_2A(a0)
			beq.s	loc_209164
			lea	(monitor_ani).l,a1
			bra.w	animateobj
; ---------------------------------------------------------------------------
loc_209164:								; CODE XREF: ROM:00209158↑j
			addq.b	#2,obj.routine(a0)
			move.b	#$B,obj.frame(a0)
			cmpi.b	#8,obj.field_28(a0)
			beq.s	locret_20917A
			addq.b	#2,obj.frame(a0)
locret_20917A:							; CODE XREF: ROM:00209174↑j
										; DATA XREF: ROM:002090B6↑o
			rts
; =============== S U B R O U T I N E =======================================
sub_20917C:								; CODE XREF: ROM:002090EE↑p
										; ROM:00209134↑p ...
			lea	(unk_FF1400).l,a2
			moveq	#0,d0
			move.b	obj.field_23(a0),d0
			move.w	d0,d1
			add.w	d1,d1
			add.w	d1,d0
			moveq	#0,d1
			move.b	(byte_FF123D).l,d1
			add.w	d1,d0
			rts
; End of function sub_20917C
; =============== S U B R O U T I N E =======================================
sub_20919A:								; CODE XREF: ROM:00209264↓p
										; ROM:0020926C↓p
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			move.b	#1,obj.routine2(a0)
			jmp	(sub_207F56).l
; End of function sub_20919A
; ---------------------------------------------------------------------------
obj19:									; DATA XREF: ROM:0020350E↑o
			cmpi.b	#8,obj.field_28(a0)
			bcc.w	loc_209088
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2091C6(pc,d0.w),d1
			jmp	off_2091C6(pc,d1.w)
; ---------------------------------------------------------------------------
off_2091C6: dc.w loc_2091D0-*			; CODE XREF: ROM:002091C2↑j
										; DATA XREF: ROM:002091BE↑r ...
			dc.w loc_20922C-off_2091C6
			dc.w loc_20928C-off_2091C6
			dc.w loc_209270-off_2091C6
			dc.w loc_209282-off_2091C6
; ---------------------------------------------------------------------------
loc_2091D0:								; DATA XREF: ROM:off_2091C6↑o
			addq.b	#2,obj.routine(a0)
			move.b	#$E,obj.field_16(a0)
			move.b	#$E,obj.field_17(a0)
			move.l	#monitor_map,obj.mappings(a0)
			move.w	#$5A8,obj.vram(a0)
			move.b	#4,obj.render(a0)
			move.b	#3,obj.priority(a0)
			move.b	#$F,obj.field_19(a0)
			bsr.w	sub_20917C
			bclr	#7,2(a2,d0.w)
			btst	#0,2(a2,d0.w)
			beq.s	loc_209220
			move.b	#8,obj.routine(a0)
			move.b	#$11,obj.frame(a0)
			rts
; ---------------------------------------------------------------------------
loc_209220:								; CODE XREF: ROM:00209210↑j
			move.b	#$46,obj.colflag(a0) ; 'F'
			move.b	obj.field_28(a0),obj.ani(a0)
loc_20922C:								; DATA XREF: ROM:002091C8↑o
			tst.b	obj.render(a0)
			bpl.w	loc_209282
			move.b	obj.routine2(a0),d0
			beq.s	loc_20925A
			bsr.w	sub_20313A
			jsr	(sub_20611C).l
			tst.w	d1
			bpl.w	loc_209270
			add.w	d1,obj.ypos(a0)
			clr.w	obj.yvel(a0)
			clr.b	obj.routine2(a0)
			bra.w	loc_209270
; ---------------------------------------------------------------------------
loc_20925A:								; CODE XREF: ROM:00209238↑j
			tst.b	obj.render(a0)
			bpl.s	loc_209270
			lea	(actwk).w,a1
			bsr.w	sub_20919A
			lea	(byte_FFD040).w,a1
			bsr.w	sub_20919A
loc_209270:								; CODE XREF: ROM:00209246↑j
										; ROM:00209256↑j ...
			tst.w	(word_FF1278).l
			bne.s	loc_209282
			lea	(monitor_ani).l,a1
			bsr.w	animateobj
loc_209282:								; CODE XREF: ROM:00209230↑j
										; ROM:00209276↑j
										; DATA XREF: ...
			bsr.w	displaysprite
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
loc_20928C:								; DATA XREF: ROM:002091CA↑o
			move.w	#$96,d0
			jsr	(queuesound2).l
			addq.b	#4,obj.routine(a0)
			move.b	#0,obj.colflag(a0)
			bsr.w	findfreeobj
			bne.s	loc_2092BE
			move.b	#$1A,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.b	obj.ani(a0),obj.ani(a1)
loc_2092BE:								; CODE XREF: ROM:002092A4↑j
			bsr.w	findfreeobj
			bne.s	loc_2092DC
			move.b	#$18,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.b	#1,obj.routine2(a1)
loc_2092DC:								; CODE XREF: ROM:002092C2↑j
			bsr.w	sub_20917C
			bset	#0,2(a2,d0.w)
			move.b	#$11,obj.frame(a0)
			bra.w	displaysprite
; ---------------------------------------------------------------------------
obj1A:									; DATA XREF: ROM:00203512↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_209302(pc,d0.w),d1
			jsr	off_209302(pc,d1.w)
			bra.w	displaysprite
; ---------------------------------------------------------------------------
off_209302: dc.w loc_209308-*			; CODE XREF: ROM:002092FA↑p
										; DATA XREF: ROM:002092F6↑r ...
			dc.w loc_209346-off_209302
			dc.w loc_2094A2-off_209302
; ---------------------------------------------------------------------------
loc_209308:								; DATA XREF: ROM:off_209302↑o
			addq.b	#2,obj.routine(a0)
			move.w	#$5A8,obj.vram(a0)
			move.b	#$24,obj.render(a0) ; '$'
			move.b	#3,obj.priority(a0)
			move.b	#8,obj.field_19(a0)
			move.w	#-$300,obj.yvel(a0)
			moveq	#0,d0
			move.b	obj.ani(a0),d0
			move.b	d0,obj.frame(a0)
			movea.l #monitor_map,a1
			add.b	d0,d0
			adda.w	(a1,d0.w),a1
			addq.w	#1,a1
			move.l	a1,obj.mappings(a0)
loc_209346:								; DATA XREF: ROM:00209304↑o
			tst.w	obj.yvel(a0)
			bpl.w	loc_20935A
			bsr.w	sub_203166
			addi.w	#$18,obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_20935A:								; CODE XREF: ROM:0020934A↑j
			addq.b	#2,obj.routine(a0)
			move.w	#29,obj.field_1E(a0)
			jsr	(sub_2023EA).l
			move.b	obj.ani(a0),d0
			bne.s	loc_209386
loc_209370:								; CODE XREF: ROM:002093AE↓j
										; ROM:002093C4↓j
			addq.b	#1,(byte_FF1212).l
			addq.b	#1,(byte_FF121C).l
			move.w	#$88,d0
			jmp	(queuesound1).l
; ---------------------------------------------------------------------------
loc_209386:								; CODE XREF: ROM:0020936E↑j
			cmpi.b	#1,d0
			bne.s	loc_2093D2
			addi.w	#10,(word_FF1220).l
			ori.b	#1,(byte_FF121D).l
			cmpi.w	#100,(word_FF1220).l
			bcs.s	loc_2093C8
			bset	#1,(byte_FF121B).l
			beq.w	loc_209370
			cmpi.w	#200,(word_FF1220).l
			bcs.s	loc_2093C8
			bset	#2,(byte_FF121B).l
			beq.w	loc_209370
loc_2093C8:								; CODE XREF: ROM:002093A4↑j
										; ROM:002093BA↑j
			move.w	#$B5,d0
			jmp	(queuesound1).l
; ---------------------------------------------------------------------------
loc_2093D2:								; CODE XREF: ROM:0020938A↑j
			cmpi.b	#2,d0
			bne.s	loc_2093F0
; =============== S U B R O U T I N E =======================================
sub_2093D8:								; CODE XREF: ROM:loc_209498↓p
			move.b	#1,(byte_FF122C).l
			move.b	#3,(byte_FFD180).w
			move.w	#$AF,d0
			jmp	(queuesound1).l
; End of function sub_2093D8
; ---------------------------------------------------------------------------
loc_2093F0:								; CODE XREF: ROM:002093D6↑j
			cmpi.b	#3,d0
			bne.s	loc_209450
; =============== S U B R O U T I N E =======================================
sub_2093F6:								; CODE XREF: ROM:0020949C↓p
			move.b	#1,(byte_FF122D).l
			move.w	#1200,obj.field_32(a6)
			move.b	#3,(byte_FFD200).w
			move.b	#1,(byte_FFD200+obj.ani).w
			move.b	#3,(byte_FFD240).w
			move.b	#2,(byte_FFD240+obj.ani).w
			move.b	#3,(byte_FFD280).w
			move.b	#3,(byte_FFD280+obj.ani).w
			move.b	#3,(byte_FFD2C0).w
			move.b	#4,(byte_FFD2C0+obj.ani).w
			tst.b	(byte_FFF7AA).w
			bne.s	locret_20944E
			cmpi.w	#$C,(play_air).l
			bls.s	locret_20944E
			move.w	#$87,d0
			jmp	(queuesound1).l
; ---------------------------------------------------------------------------
locret_20944E:							; CODE XREF: sub_2093F6+42↑j
										; sub_2093F6+4C↑j
			rts
; End of function sub_2093F6
; ---------------------------------------------------------------------------
loc_209450:								; CODE XREF: ROM:002093F4↑j
			cmpi.b	#4,d0
			bne.s	loc_209480
loc_209456:								; CODE XREF: ROM:002094A0↓j
			move.b	#1,(byte_FF122E).l
			move.w	#1200,obj.field_34(a6)
			move.w	#$C00,(word_FFF760).w
			move.w	#$18,(word_FFF762).w
			move.w	#$80,(word_FFF764).w
			move.w	#$E2,d0
			jmp	(queuesound1).l
; ---------------------------------------------------------------------------
loc_209480:								; CODE XREF: ROM:00209454↑j
			cmpi.b	#5,d0
			bne.s	loc_209490
			move.w	#$12C,(word_FF1278).l
			rts
; ---------------------------------------------------------------------------
loc_209490:								; CODE XREF: ROM:00209484↑j
			cmpi.b	#6,d0
			bne.s	loc_209498
			nop
loc_209498:								; CODE XREF: ROM:00209494↑j
			bsr.w	sub_2093D8
			bsr.w	sub_2093F6
			bra.s	loc_209456
; ---------------------------------------------------------------------------
loc_2094A2:								; DATA XREF: ROM:00209306↑o
			subq.w	#1,obj.field_1E(a0)
			bmi.w	deleteobj
			rts
; ---------------------------------------------------------------------------
monitor_ani:	dc.w unk_2094C0-*			; DATA XREF: ROM:0020915A↑o
										; ROM:00209278↑o ...
			dc.w unk_2094CC-monitor_ani
			dc.w unk_2094D8-monitor_ani
			dc.w unk_2094E4-monitor_ani
			dc.w unk_2094F0-monitor_ani
			dc.w unk_2094FC-monitor_ani
			dc.w unk_209508-monitor_ani
			dc.w unk_209514-monitor_ani
			dc.w unk_209520-monitor_ani
			dc.w unk_20952A-monitor_ani
unk_2094C0: dc.b   1					; DATA XREF: ROM:monitor_ani↑o
			dc.b $10
			dc.b   0
			dc.b   0
			dc.b   8
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b   0
			dc.b   0
			dc.b $FF
			dc.b   0
unk_2094CC: dc.b   1					; DATA XREF: ROM:002094AE↑o
			dc.b $10
			dc.b   1
			dc.b   1
			dc.b   8
			dc.b   1
			dc.b   1
			dc.b   9
			dc.b   1
			dc.b   1
			dc.b $FF
			dc.b   0
unk_2094D8: dc.b   1					; DATA XREF: ROM:002094B0↑o
			dc.b $10
			dc.b   2
			dc.b   2
			dc.b   8
			dc.b   2
			dc.b   2
			dc.b   9
			dc.b   2
			dc.b   2
			dc.b $FF
			dc.b   0
unk_2094E4: dc.b   1					; DATA XREF: ROM:002094B2↑o
			dc.b $10
			dc.b   3
			dc.b   3
			dc.b   8
			dc.b   3
			dc.b   3
			dc.b   9
			dc.b   3
			dc.b   3
			dc.b $FF
			dc.b   0
unk_2094F0: dc.b   1					; DATA XREF: ROM:002094B4↑o
			dc.b $10
			dc.b   4
			dc.b   4
			dc.b   8
			dc.b   4
			dc.b   4
			dc.b   9
			dc.b   4
			dc.b   4
			dc.b $FF
			dc.b   0
unk_2094FC: dc.b   1					; DATA XREF: ROM:002094B6↑o
			dc.b $10
			dc.b   5
			dc.b   5
			dc.b   8
			dc.b   5
			dc.b   5
			dc.b   9
			dc.b   5
			dc.b   5
			dc.b $FF
			dc.b   0
unk_209508: dc.b   1					; DATA XREF: ROM:002094B8↑o
			dc.b $10
			dc.b   6
			dc.b   6
			dc.b   8
			dc.b   6
			dc.b   6
			dc.b   9
			dc.b   6
			dc.b   6
			dc.b $FF
			dc.b   0
unk_209514: dc.b   1					; DATA XREF: ROM:002094BA↑o
			dc.b $10
			dc.b   7
			dc.b   7
			dc.b   8
			dc.b   7
			dc.b   7
			dc.b   9
			dc.b   7
			dc.b   7
			dc.b $FF
			dc.b   0
unk_209520: dc.b   1					; DATA XREF: ROM:002094BC↑o
			dc.b  $A
			dc.b  $E
			dc.b  $F
			dc.b  $E
			dc.b  $B
			dc.b  $E
			dc.b  $F
			dc.b  $E
			dc.b $FF
unk_20952A: dc.b   1					; DATA XREF: ROM:002094BE↑o
			dc.b  $C
			dc.b  $E
			dc.b  $F
			dc.b  $E
			dc.b  $D
			dc.b  $E
			dc.b  $F
			dc.b  $E
			dc.b $FF
monitor_map:	dc.w byte_209558-*			; DATA XREF: ROM:00206CC2↑o
										; ROM:00206CCE↑o ...
			dc.w byte_20956E-monitor_map
			dc.w byte_209584-monitor_map
			dc.w byte_20959A-monitor_map
			dc.w byte_2095B0-monitor_map
			dc.w byte_2095C6-monitor_map
			dc.w byte_2095DC-monitor_map
			dc.w byte_2095F2-monitor_map
			dc.w byte_209608-monitor_map
			dc.w byte_20961E-monitor_map
			dc.w byte_209634-monitor_map
			dc.w byte_20964E-monitor_map
			dc.w byte_209668-monitor_map
			dc.w byte_209682-monitor_map
			dc.w byte_20969C-monitor_map
			dc.w byte_2096B6-monitor_map
			dc.w byte_2096D0-monitor_map
			dc.w byte_2096E0-monitor_map
byte_209558:	dc.b 4						; DATA XREF: ROM:monitor_map↑o
			dc.b $F6,  5,  0,$12,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_20956E:	dc.b 4						; DATA XREF: ROM:00209536↑o
			dc.b $F6,  5,  0,$16,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_209584:	dc.b 4						; DATA XREF: ROM:00209538↑o
			dc.b $F6,  5,  0,$1A,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_20959A:	dc.b 4						; DATA XREF: ROM:0020953A↑o
			dc.b $F6,  5,  0,$1E,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_2095B0:	dc.b 4						; DATA XREF: ROM:0020953C↑o
			dc.b $F6,  5,  0,$22,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_2095C6:	dc.b 4						; DATA XREF: ROM:0020953E↑o
			dc.b $F6,  5,  0,$26,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_2095DC:	dc.b 4						; DATA XREF: ROM:00209540↑o
			dc.b $F6,  5,  0,$2A,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_2095F2:	dc.b 4						; DATA XREF: ROM:00209542↑o
			dc.b $F6,  5,  0,$2E,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_209608:	dc.b 4						; DATA XREF: ROM:00209544↑o
			dc.b $F6,  5,  0,$48,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_20961E:	dc.b 4						; DATA XREF: ROM:00209546↑o
			dc.b $F6,  5,  8,$48,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_209634:	dc.b 5						; DATA XREF: ROM:00209548↑o
			dc.b $D8, $D,  0,$32,$F0
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_20964E:	dc.b 5						; DATA XREF: ROM:0020954A↑o
			dc.b $D8, $D,  8,$32,$F0
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_209668:	dc.b 5						; DATA XREF: ROM:0020954C↑o
			dc.b $D8, $D,  0,$3A,$F0
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_209682:	dc.b 5						; DATA XREF: ROM:0020954E↑o
			dc.b $D8, $D,  8,$3A,$F0
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_20969C:	dc.b 5						; DATA XREF: ROM:00209550↑o
			dc.b $D8,  5,  0,$42,$F8
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_2096B6:	dc.b 5						; DATA XREF: ROM:00209552↑o
			dc.b $D8,  1,  0,$46,$FC
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_2096D0:	dc.b 3						; DATA XREF: ROM:00209554↑o
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
byte_2096E0:	dc.b 1						; DATA XREF: ROM:00209556↑o
			dc.b   0, $D,  0, $A,$F0
; ---------------------------------------------------------------------------
obj1C:									; DATA XREF: ROM:0020351A↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2096F4(pc,d0.w),d0
			jmp	off_2096F4(pc,d0.w)
; ---------------------------------------------------------------------------
off_2096F4: dc.w loc_2096F8-*			; CODE XREF: ROM:002096F0↑j
										; DATA XREF: ROM:002096EC↑r ...
			dc.w loc_20973C-off_2096F4
; ---------------------------------------------------------------------------
loc_2096F8:								; DATA XREF: ROM:off_2096F4↑o
			addq.b	#2,obj.routine(a0)
			move.l	#hud_map,obj.mappings(a0)
			move.w	#$8568,obj.vram(a0)
			move.w	#$90,obj.xpos(a0)
			move.w	#$88,obj.scrypos(a0)
			tst.w	(word_FF13FA).l
			beq.s	loc_209724
			move.b	#2,obj.frame(a0)
loc_209724:								; CODE XREF: ROM:0020971C↑j
			tst.b	obj.field_28(a0)
			beq.s	loc_20973C
			move.w	#$90,obj.xpos(a0)
			move.w	#$148,obj.scrypos(a0)
			move.b	#1,obj.frame(a0)
loc_20973C:								; CODE XREF: ROM:00209728↑j
										; DATA XREF: ROM:002096F6↑o
			tst.b	obj.field_28(a0)
			bne.s	loc_209756
			move.b	#0,obj.frame(a0)
			tst.w	(word_FF13FA).l
			beq.s	loc_209756
			move.b	#2,obj.frame(a0)
loc_209756:								; CODE XREF: ROM:00209740↑j
										; ROM:0020974E↑j
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
hud_map:	dc.w byte_209762-*			; DATA XREF: ROM:002096FC↑o
										; ROM:0020975E↓o ...
			dc.w byte_2097B8-hud_map
			dc.w byte_2097C8-hud_map
byte_209762:	dc.b 17						; DATA XREF: ROM:hud_map↑o
			dc.b   0,  1,  0,  0,  0
			dc.b   0,  5,  0,  2,  8
			dc.b   0,  1,  0,  6,$18
			dc.b   0,  1,  0,  8,$20
			dc.b   0,  9,  0,$1B,$30
			dc.b   0,  9,  0,$21,$48
			dc.b $10,  9,  0, $A,  0
			dc.b $10,  1,  0,  8,$18
			dc.b $10,  1,  0,$27,$28
			dc.b $10,  0,  0,$18,$30
			dc.b $10,  5,  0,$29,$38
			dc.b $10,  0,  0,$19,$48
			dc.b $10,  5,  0,$2D,$50
			dc.b $20,  1,  0,$10,  0
			dc.b $20,  9,  0,$12,  8
			dc.b $20,  1,  0,  0,$20
			dc.b $20,  9,  0,$31,$30
			even
byte_2097B8:	dc.b 3						; DATA XREF: ROM:0020975E↑o
			dc.b   0,  5,  0,$37,  0
			dc.b   8,  0,  0,$1A,$10
			dc.b   0,  1,  0,$3B,$18
			even
byte_2097C8:	dc.b 14						; DATA XREF: ROM:00209760↑o
			dc.b   0,  1,  0,  0,  0
			dc.b   0,  5,  0,  2,  8
			dc.b   0,  1,  0,  6,$18
			dc.b   0,  1,  0,  8,$20
			dc.b   0,  9,  0,$1B,$30
			dc.b   0,  9,  0,$21,$48
			dc.b $10,  9,  0, $A,  0
			dc.b $10,  1,  0,  8,$18
			dc.b $10,  5,  0,$29,$40
			dc.b $10,  5,  0,$2D,$50
			dc.b $20,  1,  0,$10,  0
			dc.b $20,  9,  0,$12,  8
			dc.b $20,  1,  0,  0,$20
			dc.b $20,  9,  0,$31,$30
			even
; =============== S U B R O U T I N E =======================================
sub_209810:								; CODE XREF: sub_2063B8:loc_206572↑p
			move.b	#1,(byte_FF121F).l
			lea	(dword_FF1226).l,a3
			add.l	d0,(a3)
			move.l	#999999,d1
			cmp.l	(a3),d1
			bhi.s	loc_20982C
			move.l	d1,(a3)
loc_20982C:								; CODE XREF: sub_209810+18↑j
			move.l	(a3),d0
			rts
; End of function sub_209810
; =============== S U B R O U T I N E =======================================
sub_209830:								; CODE XREF: doupdates+8↑p
										; ROM:00201A34↑p
			tst.w	(word_FF13FA).l
			beq.s	loc_209852
			bsr.w	sub_2099C0
			move.l	#$73200002,d0
			moveq	#0,d1
			move.b	(byte_FF188A).l,d1
			bsr.w	sub_209AEA
			bra.w	loc_209896
; ---------------------------------------------------------------------------
loc_209852:								; CODE XREF: sub_209830+6↑j
			tst.b	(byte_FF121F).l
			beq.s	loc_209870
			clr.b	(byte_FF121F).l
			move.l	#$70600002,d0
			move.l	(dword_FF1226).l,d1
			bsr.w	sub_2099E8
loc_209870:								; CODE XREF: sub_209830+28↑j
			tst.b	(byte_FF121D).l
			beq.s	loc_209896
			bpl.s	loc_20987E
			bsr.w	sub_209952
loc_20987E:								; CODE XREF: sub_209830+48↑j
			clr.b	(byte_FF121D).l
			move.l	#$73200002,d0
			moveq	#0,d1
			move.w	(word_FF1220).l,d1
			bsr.w	sub_2099DE
loc_209896:								; CODE XREF: sub_209830+1E↑j
										; sub_209830+46↑j
			tst.w	(word_FF13FA).l
			bne.w	loc_209924
			tst.b	(byte_FF121E).l
			beq.s	loc_209924
			tst.w	(word_FFF63A).w
			bne.s	loc_209924
			lea	(byte_FF1222).l,a1
			cmpi.l	#$93B3B,(a1)+
			addq.b	#1,-(a1)
			cmpi.b	#60,(a1)
			bcs.s	loc_2098DE
			move.b	#0,(a1)
			addq.b	#1,-(a1)
			cmpi.b	#60,(a1)
			bcs.s	loc_2098DE
			move.b	#0,(a1)
			addq.b	#1,-(a1)
			cmpi.b	#9,(a1)
			bcs.s	loc_2098DE
			move.b	#9,(a1)
loc_2098DE:								; CODE XREF: sub_209830+90↑j
										; sub_209830+9C↑j ...
			move.l	#$71E00002,d0
			moveq	#0,d1
			move.b	(byte_FF1223).l,d1
			bsr.w	sub_209AF4
			move.l	#$72200002,d0
			moveq	#0,d1
			move.b	(byte_FF1224).l,d1
			bsr.w	sub_209AFE
			move.l	#$72A00002,d0
			moveq	#0,d1
			move.b	(byte_FF1225).l,d1
			mulu.w	#100,d1
			divu.w	#60,d1
			swap	d1
			move.w	#0,d1
			swap	d1
			bsr.w	sub_209AFE
loc_209924:								; CODE XREF: sub_209830+6C↑j
										; sub_209830+76↑j ...
			tst.b	(byte_FF121C).l
			beq.s	locret_209936
			clr.b	(byte_FF121C).l
			bsr.w	sub_209AD4
locret_209936:							; CODE XREF: sub_209830+FA↑j
			rts
; End of function sub_209830
; ---------------------------------------------------------------------------
			clr.b	(byte_FF121E).l
			lea	(actwk).w,a0
			movea.l a0,a2
			bsr.w	loc_206668
			move.b	#1,(byte_FF121A).l
			rts
; =============== S U B R O U T I N E =======================================
sub_209952:								; CODE XREF: sub_209830+4A↑p
			move.l	#$73200002,(vdpctrl).l
			lea	unk_2099BC(pc),a2
			move.w	#3-1,d2
			bra.s	loc_209982
; ---------------------------------------------------------------------------
			lea	(vdpdata).l,a6
			bsr.w	sub_209AD4
			move.l	#$5C400003,(vdpctrl).l
			lea	unk_2099B0(pc),a2
			move.w	#15-1,d2
loc_209982:								; CODE XREF: sub_209952+12↑j
			lea	(cg_hudnumbersletters).l,a1
loc_209988:								; CODE XREF: sub_209952:loc_20999E↓j
			move.w	#16-1,d1
			move.b	(a2)+,d0
			bmi.s	loc_2099A4
			ext.w	d0
			lsl.w	#5,d0
			lea	(a1,d0.w),a3
loc_209998:								; CODE XREF: sub_209952+48↓j
			move.l	(a3)+,(a6)
			dbf	d1,loc_209998
loc_20999E:								; CODE XREF: sub_209952+5C↓j
			dbf	d2,loc_209988
			rts
; ---------------------------------------------------------------------------
loc_2099A4:								; CODE XREF: sub_209952+3C↑j
										; sub_209952+58↓j
			move.l	#0,(a6)
			dbf	d1,loc_2099A4
			bra.s	loc_20999E
; End of function sub_209952
; ---------------------------------------------------------------------------
unk_2099B0: dc.b $16					; DATA XREF: sub_209952+28↑o
			dc.b $FF
			dc.b $FF
			dc.b $FF
			dc.b $FF
			dc.b $FF
			dc.b $FF
			dc.b   0
			dc.b   0
			dc.b $14
			dc.b   0
			dc.b   0
unk_2099BC: dc.b $FF					; DATA XREF: sub_209952+A↑o
			dc.b $FF
			dc.b   0
			dc.b   0
; =============== S U B R O U T I N E =======================================
sub_2099C0:								; CODE XREF: sub_209830+8↑p
			move.l	#$70E00002,d0
			moveq	#0,d1
			move.w	(actwk+obj.xpos).w,d1
			bsr.w	sub_209ACA
			move.l	#$72200002,d0
			move.w	(actwk+obj.ypos).w,d1
			bra.w	sub_209ACA
; End of function sub_2099C0
; =============== S U B R O U T I N E =======================================
sub_2099DE:								; CODE XREF: sub_209830+62↑p
			lea	(dword_209AAE).l,a2
			moveq	#3-1,d6
			bra.s	loc_2099F0
; End of function sub_2099DE
; =============== S U B R O U T I N E =======================================
sub_2099E8:								; CODE XREF: sub_209830+3C↑p
			lea	(dword_209AA2).l,a2
			moveq	#6-1,d6
loc_2099F0:								; CODE XREF: sub_2099DE+8↑j
			moveq	#0,d4
			lea	(cg_hudnumbersletters).l,a1
loc_2099F8:								; CODE XREF: sub_2099E8+5A↓j
			moveq	#0,d2
			move.l	(a2)+,d3
loc_2099FC:								; CODE XREF: sub_2099E8+1A↓j
			sub.l	d3,d1
			bcs.s	loc_209A04
			addq.w	#1,d2
			bra.s	loc_2099FC
; ---------------------------------------------------------------------------
loc_209A04:								; CODE XREF: sub_2099E8+16↑j
			add.l	d3,d1
			tst.w	d2
			beq.s	loc_209A0E
			move.w	#1,d4
loc_209A0E:								; CODE XREF: sub_2099E8+20↑j
			tst.w	d4
			beq.s	loc_209A3C
			lsl.w	#6,d2
			move.l	d0,4(a6)
			lea	(a1,d2.w),a3
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
loc_209A3C:								; CODE XREF: sub_2099E8+28↑j
			addi.l	#$400000,d0
			dbf	d6,loc_2099F8
			rts
; End of function sub_2099E8
; ---------------------------------------------------------------------------
			move.l	#$5F800003,(vdpctrl).l
			lea	(vdpdata).l,a6
			lea	(dword_209AB2).l,a2
			moveq	#2-1,d6
			moveq	#0,d4
			lea	(cg_hudnumbersletters).l,a1
loc_209A68:								; CODE XREF: ROM:00209A9C↓j
			moveq	#0,d2
			move.l	(a2)+,d3
loc_209A6C:								; CODE XREF: ROM:00209A72↓j
			sub.l	d3,d1
			bcs.s	loc_209A74
			addq.w	#1,d2
			bra.s	loc_209A6C
; ---------------------------------------------------------------------------
loc_209A74:								; CODE XREF: ROM:00209A6E↑j
			add.l	d3,d1
			lsl.w	#6,d2
			lea	(a1,d2.w),a3
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			dbf	d6,loc_209A68
			rts
; ---------------------------------------------------------------------------
dword_209AA2:	dc.l 100000				; DATA XREF: sub_2099E8↑o
			dc.l 10000
			dc.l 1000
dword_209AAE:	dc.l 100					; DATA XREF: sub_2099DE↑o
dword_209AB2:	dc.l 10					; DATA XREF: ROM:00209A58↑o
										; sub_209AFE↓o
dword_209AB6:	dc.l 1						; DATA XREF: sub_209AEA↓o
										; sub_209AF4↓o
dword_209ABA:	dc.l $1000					; DATA XREF: sub_209ACA+2↓o
			dc.l $100
			dc.l $10
			dc.l 1
; =============== S U B R O U T I N E =======================================
sub_209ACA:								; CODE XREF: sub_2099C0+C↑p
										; sub_2099C0+1A↑j
			moveq	#4-1,d6
			lea	(dword_209ABA).l,a2
			bra.s	loc_209B06
; End of function sub_209ACA
; =============== S U B R O U T I N E =======================================
sub_209AD4:								; CODE XREF: sub_209830+102↑p
										; sub_209952+1A↑p
			move.l	#$74600002,d0
			moveq	#0,d1
			move.b	(byte_FF1212).l,d1
			cmpi.b	#9,d1
			bcs.s	sub_209AEA
			moveq	#9,d1
; End of function sub_209AD4
; =============== S U B R O U T I N E =======================================
sub_209AEA:								; CODE XREF: sub_209830+1A↑p
										; sub_209AD4+12↑j
			lea	(dword_209AB6).l,a2
			moveq	#1-1,d6
			bra.s	loc_209B06
; End of function sub_209AEA
; =============== S U B R O U T I N E =======================================
sub_209AF4:								; CODE XREF: sub_209830+BC↑p
			lea	(dword_209AB6).l,a2
			moveq	#1-1,d6
			bra.s	loc_209B06
; End of function sub_209AF4
; =============== S U B R O U T I N E =======================================
sub_209AFE:								; CODE XREF: sub_209830+CE↑p
										; sub_209830+F0↑p
			lea	(dword_209AB2).l,a2
			moveq	#2-1,d6
loc_209B06:								; CODE XREF: sub_209ACA+8↑j
										; sub_209AEA+8↑j ...
			moveq	#0,d4
			lea	(cg_hudnumbersletters).l,a1
loc_209B0E:								; CODE XREF: sub_209AFE+56↓j
			moveq	#0,d2
			move.l	(a2)+,d3
loc_209B12:								; CODE XREF: sub_209AFE+1A↓j
			sub.l	d3,d1
			bcs.s	loc_209B1A
			addq.w	#1,d2
			bra.s	loc_209B12
; ---------------------------------------------------------------------------
loc_209B1A:								; CODE XREF: sub_209AFE+16↑j
			add.l	d3,d1
			tst.w	d2
			beq.s	loc_209B24
			move.w	#1,d4
loc_209B24:								; CODE XREF: sub_209AFE+20↑j
			lsl.w	#6,d2
			move.l	d0,4(a6)
			lea	(a1,d2.w),a3
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			move.l	(a3)+,(a6)
			addi.l	#$400000,d0
			dbf	d6,loc_209B0E
			rts
; End of function sub_209AFE
; =============== S U B R O U T I N E =======================================
obj13:									; DATA XREF: ROM:002034F6↑o
			move.b	obj.field_28(a0),d0
			bmi.w	loc_209DD4
			bra.w	loc_209C32
; ---------------------------------------------------------------------------
obj14:									; DATA XREF: ROM:002034FA↑o
			move.b	obj.field_28(a0),d0
			bmi.w	loc_209F7C
			bra.w	loc_20A18E
; ---------------------------------------------------------------------------
obj15:									; DATA XREF: ROM:002034FE↑o
			move.b	obj.field_28(a0),d0
			bmi.w	loc_20A51E
			bra.w	loc_20A3A0
; ---------------------------------------------------------------------------
obj16:									; DATA XREF: ROM:00203502↑o
			move.b	obj.field_28(a0),d0
			bmi.w	loc_20A814
			bra.w	loc_20A702
; ---------------------------------------------------------------------------
obj22:									; DATA XREF: ROM:00203532↑o
			move.b	obj.field_28(a0),d0
			bmi.w	loc_20AC58
			bra.w	loc_20A926
; ---------------------------------------------------------------------------
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_209BA4(pc,d0.w),d0
			jmp	off_209BA4(pc,d0.w)
; ---------------------------------------------------------------------------
off_209BA4: dc.w loc_209BA8-*			; CODE XREF: obj13+46↑j
										; DATA XREF: obj13+42↑r ...
			dc.w loc_209BFC-off_209BA4
; ---------------------------------------------------------------------------
loc_209BA8:								; DATA XREF: obj13:off_209BA4↑o
			addq.b	#2,obj.routine(a0)
			move.l	#off_20B4C8,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.w	#$400,obj.vram(a0)
			move.w	#$C00,obj.vram(a0)
			move.w	#$1400,obj.vram(a0)
			move.w	#$24FC,obj.vram(a0)
			move.l	(actwk+obj.xpos).w,d0
			addi.l	#$A0000,d0
			move.l	d0,obj.xpos(a0)
			move.l	(actwk+obj.ypos).w,d0
			subi.l	#$320000,d0
			move.l	d0,obj.ypos(a0)
			rts
; ---------------------------------------------------------------------------
loc_209BFC:								; DATA XREF: obj13+4C↑o
			move.l	(actwk+obj.xpos).w,d0
			addi.l	#$A0000,d0
			move.l	d0,obj.xpos(a0)
			move.l	(actwk+obj.ypos).w,d0
			subi.l	#$320000,d0
			move.l	d0,obj.ypos(a0)
			move.b	#0,obj.ani(a0)
			lea	(off_20B4B6).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209C32:								; CODE XREF: obj13+8↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			beq.s	loc_209C4C
			tst.b	obj.render(a0)
			bmi.s	loc_209C4C
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
loc_209C4C:								; CODE XREF: obj13+DE↑j
										; obj13+E4↑j
			move.w	off_209C5A(pc,d0.w),d0
			jsr	off_209C5A(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_209C5A: dc.w loc_209C66-*			; CODE XREF: obj13+F6↑p
										; DATA XREF: obj13:loc_209C4C↑r ...
			dc.w loc_209CA2-off_209C5A
			dc.w loc_209CEA-off_209C5A
			dc.w loc_209D5C-off_209C5A
			dc.w loc_209D8A-off_209C5A
			dc.w loc_209DC0-off_209C5A
; ---------------------------------------------------------------------------
loc_209C66:								; DATA XREF: obj13:off_209C5A↑o
			move.b	#6,obj.colflag(a0)
			addq.b	#2,obj.routine(a0)
			move.l	#obj13_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#0,d0
			jsr	(sub_20DC4C).l
			move.b	#1,obj.ani(a0)
			move.l	obj.xpos(a0),d0
			move.l	d0,obj.field_2C(a0)
			rts
; ---------------------------------------------------------------------------
loc_209CA2:								; DATA XREF: obj13+102↑o
			bra.w	loc_209CEA
; ---------------------------------------------------------------------------
			move.w	#$2C00,obj.vram(a0)
			move.l	obj.xpos(a0),d0
			addi.l	#$10000,d0
			move.l	d0,obj.xpos(a0)
			move.w	obj.xpos(a0),d0
			move.w	obj.field_2C(a0),d1
			addi.w	#$6E,d1
			cmp.w	d0,d1
			bpl.w	loc_209CD2
			move.b	#4,obj.routine(a0)
loc_209CD2:								; CODE XREF: obj13+16E↑j
			bsr.w	loc_209D2A
			lea	(obj13_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209CEA:								; CODE XREF: obj13:loc_209CA2↑j
										; DATA XREF: obj13+104↑o
			moveq	#0,d0
			jsr	(sub_20DC4C).l
			move.l	obj.xpos(a0),d0
			subi.l	#$10000,d0
			move.l	d0,obj.xpos(a0)
			move.w	obj.xpos(a0),d0
			move.w	obj.field_2C(a0),d1
			subi.w	#$6E,d1
			cmp.w	d0,d1
			bmi.w	loc_209D12
loc_209D12:								; CODE XREF: obj13+1B4↑j
			bsr.w	loc_209D2A
			lea	(obj13_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209D2A:								; CODE XREF: obj13:loc_209CD2↑p
										; obj13:loc_209D12↑p
			move.w	(actwk+obj.xpos).w,d1
			move.w	obj.xpos(a0),d0
			move.w	d1,d2
			addi.w	#$32,d1
			subi.w	#$32,d2
			cmp.w	d1,d0
			bpl.w	locret_209D5A
			cmp.w	d2,d0
			bmi.w	locret_209D5A
			move.b	#6,obj.routine(a0)
			move.b	#2,obj.ani(a0)
			move.w	#$32,obj.field_2A(a0)
locret_209D5A:							; CODE XREF: obj13+1E4↑j
										; obj13+1EA↑j
			rts
; ---------------------------------------------------------------------------
loc_209D5C:								; DATA XREF: obj13+106↑o
			move.w	obj.field_2A(a0),d0
			subq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			bne.w	loc_209D76
			move.b	#8,obj.routine(a0)
			move.b	#3,obj.ani(a0)
loc_209D76:								; CODE XREF: obj13+20C↑j
			lea	(obj13_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209D8A:								; DATA XREF: obj13+108↑o
			move.l	obj.ypos(a0),d0
			addi.l	#$60000,d0
			move.l	d0,obj.ypos(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			bmi.w	loc_209DB8
			lea	(obj13_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209DB8:								; CODE XREF: obj13+246↑j
			move.b	#$A,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_209DC0:								; DATA XREF: obj13+10A↑o
			lea	(obj13_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209DD4:								; CODE XREF: obj13+4↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			beq.s	loc_209DEE
			tst.b	obj.render(a0)
			bmi.s	loc_209DEE
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
loc_209DEE:								; CODE XREF: obj13+280↑j
										; obj13+286↑j
			move.w	off_209DFC(pc,d0.w),d0
			jsr	off_209DFC(pc,d0.w)
			jmp	(loc_206FB8).l
; End of function obj13
; ---------------------------------------------------------------------------
off_209DFC: dc.w loc_209E08-*			; CODE XREF: obj13+298↑p
										; DATA XREF: obj13:loc_209DEE↑r ...
			dc.w loc_209E4A-off_209DFC
			dc.w loc_209E92-off_209DFC
			dc.w loc_209F04-off_209DFC
			dc.w loc_209F32-off_209DFC
			dc.w loc_209F68-off_209DFC
; ---------------------------------------------------------------------------
loc_209E08:								; DATA XREF: ROM:off_209DFC↑o
			move.b	#6,obj.colflag(a0)
			addq.b	#2,obj.routine(a0)
			move.l	#obj13b_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.w	#$400,obj.vram(a0)
			moveq	#0,d0
			jsr	(sub_20DC4C).l
			move.b	#1,obj.ani(a0)
			move.l	obj.xpos(a0),d0
			move.l	d0,obj.field_2C(a0)
			rts
; ---------------------------------------------------------------------------
loc_209E4A:								; DATA XREF: ROM:00209DFE↑o
			bra.w	loc_209E92
; ---------------------------------------------------------------------------
			move.w	#$2C00,obj.vram(a0)
			move.l	obj.xpos(a0),d0
			addi.l	#$10000,d0
			move.l	d0,obj.xpos(a0)
			move.w	obj.xpos(a0),d0
			move.w	obj.field_2C(a0),d1
			addi.w	#$6E,d1
			cmp.w	d0,d1
			bpl.w	loc_209E7A
			move.b	#4,obj.routine(a0)
loc_209E7A:								; CODE XREF: ROM:00209E70↑j
			bsr.w	sub_209ED2
			lea	(obj13b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209E92:								; CODE XREF: ROM:loc_209E4A↑j
										; DATA XREF: ROM:00209E00↑o
			moveq	#0,d0
			jsr	(sub_20DC4C).l
			move.l	obj.xpos(a0),d0
			subi.l	#$10000,d0
			move.l	d0,obj.xpos(a0)
			move.w	obj.xpos(a0),d0
			move.w	obj.field_2C(a0),d1
			subi.w	#$6E,d1
			cmp.w	d0,d1
			bmi.w	loc_209EBA
loc_209EBA:								; CODE XREF: ROM:00209EB6↑j
			bsr.w	sub_209ED2
			lea	(obj13b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; =============== S U B R O U T I N E =======================================
sub_209ED2:								; CODE XREF: ROM:loc_209E7A↑p
										; ROM:loc_209EBA↑p
			move.w	(actwk+obj.xpos).w,d1
			move.w	obj.xpos(a0),d0
			move.w	d1,d2
			addi.w	#$32,d1
			subi.w	#$32,d2
			cmp.w	d1,d0
			bpl.w	locret_209F02
			cmp.w	d2,d0
			bmi.w	locret_209F02
			move.b	#6,obj.routine(a0)
			move.b	#2,obj.ani(a0)
			move.w	#$3C,obj.field_2A(a0)
locret_209F02:							; CODE XREF: sub_209ED2+14↑j
										; sub_209ED2+1A↑j
			rts
; End of function sub_209ED2
; ---------------------------------------------------------------------------
loc_209F04:								; DATA XREF: ROM:00209E02↑o
			move.w	obj.field_2A(a0),d0
			subq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			bne.w	loc_209F1E
			move.b	#8,obj.routine(a0)
			move.b	#3,obj.ani(a0)
loc_209F1E:								; CODE XREF: ROM:00209F0E↑j
			lea	(obj13b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209F32:								; DATA XREF: ROM:00209E04↑o
			move.l	obj.ypos(a0),d0
			addi.l	#$60000,d0
			move.l	d0,obj.ypos(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			bmi.w	loc_209F60
			lea	(obj13b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209F60:								; CODE XREF: ROM:00209F48↑j
			move.b	#$A,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_209F68:								; DATA XREF: ROM:00209E06↑o
			lea	(obj13b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR obj13
loc_209F7C:								; CODE XREF: obj13+10↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_209F90(pc,d0.w),d0
			jsr	off_209F90(pc,d0.w)
			jmp	(loc_206FB8).l
; END OF FUNCTION CHUNK FOR obj13
; ---------------------------------------------------------------------------
off_209F90: dc.w loc_209F9A-*			; CODE XREF: obj13+42C↑p
										; DATA XREF: obj13+428↑r ...
			dc.w loc_209FE8-off_209F90
			dc.w loc_20A11C-off_209F90
			dc.w loc_20A072-off_209F90
			dc.w loc_20A11C-off_209F90
; ---------------------------------------------------------------------------
loc_209F9A:								; DATA XREF: ROM:off_209F90↑o
			move.b	#6,obj.colflag(a0)
			addq.b	#2,obj.routine(a0)
			move.l	#obj14_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#1,d0
			jsr	(sub_20DC4C).l
			move.w	#0,obj.field_30(a0)
			move.w	#0,obj.field_2A(a0)
			bclr	#0,obj.status(a0)
			bclr	#0,obj.render(a0)
			move.l	obj.ypos(a0),d0
			move.l	d0,obj.field_2C(a0)
			rts
; ---------------------------------------------------------------------------
loc_209FE8:								; DATA XREF: ROM:00209F92↑o
			tst.b	obj.render(a0)
			bpl.s	loc_20A06C
			move.b	#0,obj.ani(a0)
			moveq	#1,d0
			jsr	(sub_20DC4C).l
			bclr	#0,obj.status(a0)
			bclr	#0,obj.render(a0)
			bsr.w	sub_20A0FA
			move.l	obj.xpos(a0),d0
			subi.l	#$8000,d0
			move.l	d0,obj.xpos(a0)
			move.w	obj.field_30(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_30(a0)
			cmpi.w	#$FA,d0
			bne.w	loc_20A040
			move.w	#0,obj.field_30(a0)
			move.b	#$60,obj.field_32(a0)
			move.b	#4,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A040:								; CODE XREF: ROM:0020A028↑j
			move.w	obj.field_2A(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			cmpi.w	#$300,d0
			bne.w	loc_20A060
			move.w	#0,obj.field_2A(a0)
			move.b	#6,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A060:								; CODE XREF: ROM:0020A04E↑j
			lea	(obj14_ani).l,a1
			jsr	(animateobj).l
loc_20A06C:								; CODE XREF: ROM:00209FEC↑j
										; ROM:0020A076↓j ...
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20A072:								; DATA XREF: ROM:00209F96↑o
			tst.b	obj.render(a0)
			bpl.s	loc_20A06C
			move.b	#1,obj.ani(a0)
			moveq	#1,d0
			jsr	(sub_20DC4C).l
			bsr.w	sub_20A0FA
			bset	#0,obj.status(a0)
			bset	#0,obj.render(a0)
			move.l	obj.xpos(a0),d0
			addi.l	#$8000,d0
			move.l	d0,obj.xpos(a0)
			move.w	obj.field_30(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_30(a0)
			cmpi.w	#$FA,d0
			bne.w	loc_20A0C8
			move.w	#0,obj.field_30(a0)
			move.b	#$60,obj.field_32(a0)
			move.b	#8,obj.routine(a0)
loc_20A0C8:								; CODE XREF: ROM:0020A0B2↑j
			move.w	obj.field_2A(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			cmpi.w	#$300,d0
			bne.w	loc_20A0E6
			move.w	#0,obj.field_2A(a0)
			move.b	#2,obj.routine(a0)
loc_20A0E6:								; CODE XREF: ROM:0020A0D6↑j
			lea	(obj14_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; =============== S U B R O U T I N E =======================================
sub_20A0FA:								; CODE XREF: ROM:0020A008↑p
										; ROM:0020A086↑p
			move.w	obj.field_2A(a0),d0
			mulu.w	#256,d0
			divu.w	#128,d0
			jsr	(calcsine).l
			muls.w	#$1C00,d0
			move.l	obj.field_2C(a0),d1
			add.l	d0,d1
			move.l	d1,obj.ypos(a0)
			rts
; End of function sub_20A0FA
; ---------------------------------------------------------------------------
loc_20A11C:								; DATA XREF: ROM:00209F94↑o
										; ROM:00209F98↑o
			tst.b	obj.render(a0)
			bpl.w	loc_20A06C
			move.b	obj.field_32(a0),d0
			subq.w	#1,d0
			move.b	d0,obj.field_32(a0)
			beq.w	loc_20A168
			move.l	#$4000,d1
			addi.b	#$30,d0
			andi.b	#$3F,d0
			cmpi.b	#$20,d0
			bpl.w	loc_20A14A
			neg.l	d1
loc_20A14A:								; CODE XREF: ROM:0020A144↑j
			move.l	obj.ypos(a0),d2
			add.l	d1,d2
			move.l	d2,obj.ypos(a0)
			lea	(obj14_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A168:								; CODE XREF: ROM:0020A12E↑j
			move.w	#0,obj.field_30(a0)
			move.b	obj.routine(a0),d0
			cmpi.b	#4,d0
			beq.w	loc_20A17E
			bra.w	loc_20A186
; ---------------------------------------------------------------------------
loc_20A17E:								; CODE XREF: ROM:0020A176↑j
			move.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A186:								; CODE XREF: ROM:0020A17A↑j
			move.b	#6,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR obj13
loc_20A18E:								; CODE XREF: obj13+14↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20A1A2(pc,d0.w),d0
			jsr	off_20A1A2(pc,d0.w)
			jmp	(loc_206FB8).l
; END OF FUNCTION CHUNK FOR obj13
; ---------------------------------------------------------------------------
off_20A1A2: dc.w loc_20A1AC-*			; CODE XREF: obj13+63E↑p
										; DATA XREF: obj13+63A↑r ...
			dc.w loc_20A1FA-off_20A1A2
			dc.w loc_20A32E-off_20A1A2
			dc.w loc_20A286-off_20A1A2
			dc.w loc_20A32E-off_20A1A2
; ---------------------------------------------------------------------------
loc_20A1AC:								; DATA XREF: ROM:off_20A1A2↑o
			move.b	#6,obj.colflag(a0)
			addq.b	#2,obj.routine(a0)
			move.l	#obj14_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#1,d0
			jsr	(sub_20DC4C).l
			move.w	#0,obj.field_30(a0)
			move.w	#0,obj.field_2A(a0)
			bclr	#0,obj.status(a0)
			bclr	#0,obj.render(a0)
			move.l	obj.ypos(a0),d0
			move.l	d0,obj.field_2C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A1FA:								; DATA XREF: ROM:0020A1A4↑o
			tst.b	obj.render(a0)
			bpl.w	loc_20A280
			move.b	#0,obj.ani(a0)
			moveq	#1,d0
			jsr	(sub_20DC4C).l
			bsr.w	sub_20A30C
			bclr	#0,obj.status(a0)
			bclr	#0,obj.render(a0)
			move.l	obj.xpos(a0),d0
			subi.l	#$8000,d0
			move.l	d0,obj.xpos(a0)
			move.w	obj.field_30(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_30(a0)
			cmpi.w	#$1F4,d0
			bne.w	loc_20A254
			move.w	#0,obj.field_30(a0)
			move.b	#$60,obj.field_32(a0)
			move.b	#4,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A254:								; CODE XREF: ROM:0020A23C↑j
			move.w	obj.field_2A(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			cmpi.w	#$300,d0
			bne.w	loc_20A274
			move.w	#0,obj.field_2A(a0)
			move.b	#6,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A274:								; CODE XREF: ROM:0020A262↑j
			lea	(obj14b_ani).l,a1
			jsr	(animateobj).l
loc_20A280:								; CODE XREF: ROM:0020A1FE↑j
										; ROM:0020A28A↓j ...
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20A286:								; DATA XREF: ROM:0020A1A8↑o
			tst.b	obj.render(a0)
			bpl.s	loc_20A280
			move.b	#1,obj.ani(a0)
			moveq	#1,d0
			jsr	(sub_20DC4C).l
			bsr.w	sub_20A30C
			bset	#0,obj.status(a0)
			bset	#0,obj.render(a0)
			move.l	obj.xpos(a0),d0
			addi.l	#$8000,d0
			move.l	d0,obj.xpos(a0)
			move.w	obj.field_30(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_30(a0)
			cmpi.w	#$1F4,d0
			bne.w	loc_20A2DC
			move.w	#0,obj.field_30(a0)
			move.b	#$60,obj.field_32(a0)
			move.b	#8,obj.routine(a0)
loc_20A2DC:								; CODE XREF: ROM:0020A2C6↑j
			move.w	obj.field_2A(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			cmpi.w	#$300,d0
			bne.w	loc_20A2FA
			move.w	#0,obj.field_2A(a0)
			move.b	#2,obj.routine(a0)
loc_20A2FA:								; CODE XREF: ROM:0020A2EA↑j
			lea	(obj14b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; =============== S U B R O U T I N E =======================================
sub_20A30C:								; CODE XREF: ROM:0020A210↑p
										; ROM:0020A29A↑p
			move.w	obj.field_2A(a0),d0
			mulu.w	#256,d0
			divu.w	#128,d0
			jsr	(calcsine).l
			muls.w	#$3800,d0
			move.l	obj.field_2C(a0),d1
			add.l	d0,d1
			move.l	d1,obj.ypos(a0)
			rts
; End of function sub_20A30C
; ---------------------------------------------------------------------------
loc_20A32E:								; DATA XREF: ROM:0020A1A6↑o
										; ROM:0020A1AA↑o
			tst.b	obj.render(a0)
			bne.w	loc_20A280
			move.b	obj.field_32(a0),d0
			subq.w	#1,d0
			move.b	d0,obj.field_32(a0)
			beq.w	loc_20A37A
			move.l	#$4000,d1
			addi.b	#$30,d0
			andi.b	#$3F,d0
			cmpi.b	#$20,d0
			bpl.w	loc_20A35C
			neg.l	d1
loc_20A35C:								; CODE XREF: ROM:0020A356↑j
			move.l	obj.ypos(a0),d2
			add.l	d1,d2
			move.l	d2,obj.ypos(a0)
			lea	(obj14b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A37A:								; CODE XREF: ROM:0020A340↑j
			move.w	#0,obj.field_30(a0)
			move.b	obj.routine(a0),d0
			cmpi.b	#4,d0
			beq.w	loc_20A390
			bra.w	loc_20A398
; ---------------------------------------------------------------------------
loc_20A390:								; CODE XREF: ROM:0020A388↑j
			move.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A398:								; CODE XREF: ROM:0020A38C↑j
			move.b	#6,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR obj13
loc_20A3A0:								; CODE XREF: obj13+20↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			beq.s	loc_20A3BA
			tst.b	obj.render(a0)
			bmi.s	loc_20A3BA
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
loc_20A3BA:								; CODE XREF: obj13+84C↑j
										; obj13+852↑j
			move.w	off_20A3C8(pc,d0.w),d0
			jsr	off_20A3C8(pc,d0.w)
			jmp	(loc_206FB8).l
; END OF FUNCTION CHUNK FOR obj13
; ---------------------------------------------------------------------------
off_20A3C8: dc.w loc_20A3D0-*			; CODE XREF: obj13+864↑p
										; DATA XREF: obj13:loc_20A3BA↑r ...
			dc.w loc_20A404-off_20A3C8
			dc.w loc_20A43E-off_20A3C8
			dc.w loc_20A4AE-off_20A3C8
; ---------------------------------------------------------------------------
loc_20A3D0:								; DATA XREF: ROM:off_20A3C8↑o
			move.b	#6,obj.colflag(a0)
			addq.b	#2,obj.routine(a0)
			move.l	#obj15_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#2,d0
			jsr	(sub_20DC4C).l
			move.b	#0,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A404:								; DATA XREF: ROM:0020A3CA↑o
			move.l	obj.ypos(a0),d0
			addi.l	#$20000,d0
			move.l	d0,obj.ypos(a0)
			move.b	#$12,obj.field_16(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			bmi.w	loc_20A436
			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20A436:								; CODE XREF: ROM:0020A420↑j
			move.b	#4,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A43E:								; DATA XREF: ROM:0020A3CC↑o
			move.b	#$12,obj.field_16(a0)
			subi.l	#$10000,obj.xpos(a0)
			moveq	#8,d3
			jsr	(sub_206388).l
			tst.b	d1
			bne.w	loc_20A45E
			bra.w	loc_20A498
; ---------------------------------------------------------------------------
loc_20A45E:								; CODE XREF: ROM:0020A456↑j
			jsr	(sub_20611C).l
			tst.w	d1
			beq.w	loc_20A484
			cmpi.w	#7,d1
			bpl.w	loc_20A498
			cmpi.w	#-8,d1
			bmi.w	loc_20A498
			move.w	obj.ypos(a0),d0
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
loc_20A484:								; CODE XREF: ROM:0020A466↑j
			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A498:								; CODE XREF: ROM:0020A45A↑j
										; ROM:0020A46E↑j ...
			move.b	#6,obj.routine(a0)
			bset	#0,obj.status(a0)
			bset	#0,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A4AE:								; DATA XREF: ROM:0020A3CE↑o
			move.b	#$12,obj.field_16(a0)
			addi.l	#$10000,obj.xpos(a0)
			moveq	#8,d3
			jsr	(sub_2061E6).l
			tst.b	d1
			bne.w	loc_20A4CE
			bra.w	loc_20A508
; ---------------------------------------------------------------------------
loc_20A4CE:								; CODE XREF: ROM:0020A4C6↑j
			jsr	(sub_20611C).l
			tst.w	d1
			beq.w	loc_20A4F4
			cmpi.w	#7,d1
			bpl.w	loc_20A508
			cmpi.w	#-8,d1
			bmi.w	loc_20A508
			move.w	obj.ypos(a0),d0
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
loc_20A4F4:								; CODE XREF: ROM:0020A4D6↑j
			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A508:								; CODE XREF: ROM:0020A4CA↑j
										; ROM:0020A4DE↑j ...
			move.b	#4,obj.routine(a0)
			bclr	#0,obj.status(a0)
			bclr	#0,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR obj13
loc_20A51E:								; CODE XREF: obj13+1C↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			beq.s	loc_20A538
			tst.b	obj.render(a0)
			bmi.s	loc_20A538
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
loc_20A538:								; CODE XREF: obj13+9CA↑j
										; obj13+9D0↑j
			move.w	off_20A546(pc,d0.w),d0
			jsr	off_20A546(pc,d0.w)
			jmp	(loc_206FB8).l
; END OF FUNCTION CHUNK FOR obj13
; ---------------------------------------------------------------------------
off_20A546: dc.w loc_20A552-*			; CODE XREF: obj13+9E2↑p
										; DATA XREF: obj13:loc_20A538↑r ...
			dc.w loc_20A58C-off_20A546
			dc.w loc_20A5C6-off_20A546
			dc.w loc_20A642-off_20A546
			dc.w loc_20A686-off_20A546
			dc.w loc_20A664-off_20A546
; ---------------------------------------------------------------------------
loc_20A552:								; DATA XREF: ROM:off_20A546↑o
			move.b	#6,obj.colflag(a0)
			addq.b	#2,obj.routine(a0)
			move.l	#obj15_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#2,d0
			jsr	(sub_20DC4C).l
			move.b	#1,obj.ani(a0)
			move.w	#0,obj.field_3E(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A58C:								; DATA XREF: ROM:0020A548↑o
			move.l	obj.ypos(a0),d0
			addi.l	#$10000,d0
			move.l	d0,obj.ypos(a0)
			move.b	#$12,obj.field_16(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			bmi.w	loc_20A5BE
			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20A5BE:								; CODE XREF: ROM:0020A5A8↑j
			move.b	#4,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A5C6:								; DATA XREF: ROM:0020A54A↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$F0,d0
			beq.w	loc_20A634
			move.b	#$12,obj.field_16(a0)
			subi.l	#$C000,obj.xpos(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			beq.w	loc_20A60C
			cmpi.w	#7,d1
			bpl.w	loc_20A620
			cmpi.w	#-7,d1
			bmi.w	loc_20A620
			move.w	obj.ypos(a0),d0
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
loc_20A60C:								; CODE XREF: ROM:0020A5EE↑j
										; ROM:0020A640↓j ...
			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A620:								; CODE XREF: ROM:0020A5F6↑j
										; ROM:0020A5FE↑j
			move.b	#8,obj.routine(a0)
			bset	#0,obj.status(a0)
			bset	#0,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A634:								; CODE XREF: ROM:0020A5D4↑j
			move.w	#0,obj.field_3E(a0)
			move.b	#6,obj.routine(a0)
			bra.s	loc_20A60C
; ---------------------------------------------------------------------------
loc_20A642:								; DATA XREF: ROM:0020A54C↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$3C,d0
			beq.w	loc_20A656
			bra.s	loc_20A60C
; ---------------------------------------------------------------------------
loc_20A656:								; CODE XREF: ROM:0020A650↑j
			move.w	#0,obj.field_3E(a0)
			move.b	#4,obj.routine(a0)
			bra.s	loc_20A60C
; ---------------------------------------------------------------------------
loc_20A664:								; DATA XREF: ROM:0020A550↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$3C,d0
			beq.w	loc_20A678
			bra.s	loc_20A60C
; ---------------------------------------------------------------------------
loc_20A678:								; CODE XREF: ROM:0020A672↑j
			move.w	#0,obj.field_3E(a0)
			move.b	#8,obj.routine(a0)
			bra.s	loc_20A60C
; ---------------------------------------------------------------------------
loc_20A686:								; DATA XREF: ROM:0020A54E↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$F0,d0
			beq.w	loc_20A6F4
			move.b	#$12,obj.field_16(a0)
			addi.l	#$C000,obj.xpos(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			beq.w	loc_20A6CC
			cmpi.w	#7,d1
			bpl.w	loc_20A6E0
			cmpi.w	#-7,d1
			bmi.w	loc_20A6E0
			move.w	obj.ypos(a0),d0
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
loc_20A6CC:								; CODE XREF: ROM:0020A6AE↑j
										; ROM:0020A700↓j
			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A6E0:								; CODE XREF: ROM:0020A6B6↑j
										; ROM:0020A6BE↑j
			move.b	#4,obj.routine(a0)
			bclr	#0,obj.status(a0)
			bclr	#0,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A6F4:								; CODE XREF: ROM:0020A694↑j
			move.w	#0,obj.field_3E(a0)
			move.b	#$A,obj.routine(a0)
			bra.s	loc_20A6CC
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR obj13
loc_20A702:								; CODE XREF: obj13+2C↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20A716(pc,d0.w),d0
			jsr	off_20A716(pc,d0.w)
			jmp	(loc_206FB8).l
; END OF FUNCTION CHUNK FOR obj13
; ---------------------------------------------------------------------------
off_20A716: dc.w loc_20A71E-*			; CODE XREF: obj13+BB2↑p
										; DATA XREF: obj13+BAE↑r ...
			dc.w loc_20A75A-off_20A716
			dc.w loc_20A7AA-off_20A716
			dc.w loc_20A802-off_20A716
; ---------------------------------------------------------------------------
loc_20A71E:								; DATA XREF: ROM:off_20A716↑o
			move.b	#6,obj.colflag(a0)
			addq.b	#2,obj.routine(a0)
			move.l	#obj16_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#3,d0
			jsr	(sub_20DC4C).l
			move.l	#$FFFC0000,obj.field_2A(a0)
			move.b	#0,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A75A:								; DATA XREF: ROM:0020A718↑o
			addi.l	#$1000,obj.field_2A(a0)
			move.l	obj.ypos(a0),d0
			move.l	obj.field_2A(a0),d1
			add.l	d1,d0
			move.l	d0,obj.ypos(a0)
			tst.l	d1
			bpl.w	loc_20A79C
			cmpi.l	#$FFFFA000,d1
			bpl.w	loc_20A794
loc_20A780:								; CODE XREF: ROM:0020A79A↓j
										; ROM:0020A7A8↓j
			lea	(obj16_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A794:								; CODE XREF: ROM:0020A77C↑j
			move.b	#2,obj.ani(a0)
			bra.s	loc_20A780
; ---------------------------------------------------------------------------
loc_20A79C:								; CODE XREF: ROM:0020A772↑j
			move.b	#4,obj.routine(a0)
			move.b	#3,obj.ani(a0)
			bra.s	loc_20A780
; ---------------------------------------------------------------------------
loc_20A7AA:								; DATA XREF: ROM:0020A71A↑o
			addi.l	#$1000,obj.field_2A(a0)
			move.l	obj.ypos(a0),d0
			move.l	obj.field_2A(a0),d1
			add.l	d1,d0
			move.l	d0,obj.ypos(a0)
			move.l	#-$40000,d2
			neg.l	d2
			cmp.l	d2,d1
			bpl.w	loc_20A7EC
			cmpi.l	#$10000,d1
			bpl.w	loc_20A7FA
loc_20A7D8:								; CODE XREF: ROM:0020A800↓j
			lea	(obj16_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A7EC:								; CODE XREF: ROM:0020A7CA↑j
			move.b	#6,obj.routine(a0)
			move.w	#$C8,obj.field_2E(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A7FA:								; CODE XREF: ROM:0020A7D4↑j
			move.b	#1,obj.ani(a0)
			bra.s	loc_20A7D8
; ---------------------------------------------------------------------------
loc_20A802:								; DATA XREF: ROM:0020A71C↑o
			subq.w	#1,obj.field_2E(a0)
			beq.w	loc_20A80C
			rts
; ---------------------------------------------------------------------------
loc_20A80C:								; CODE XREF: ROM:0020A806↑j
			move.b	#0,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR obj13
loc_20A814:								; CODE XREF: obj13+28↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20A828(pc,d0.w),d0
			jsr	off_20A828(pc,d0.w)
			jmp	(loc_206FB8).l
; END OF FUNCTION CHUNK FOR obj13
; ---------------------------------------------------------------------------
off_20A828: dc.w loc_20A830-*			; CODE XREF: obj13+CC4↑p
										; DATA XREF: obj13+CC0↑r ...
			dc.w loc_20A86C-off_20A828
			dc.w loc_20A8BC-off_20A828
			dc.w loc_20A914-off_20A828
; ---------------------------------------------------------------------------
loc_20A830:								; DATA XREF: ROM:off_20A828↑o
			move.b	#6,obj.colflag(a0)
			addq.b	#2,obj.routine(a0)
			move.l	#obj16_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#3,d0
			jsr	(sub_20DC4C).l
			move.l	#$FFFA0000,obj.field_2A(a0)
			move.b	#4,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A86C:								; DATA XREF: ROM:0020A82A↑o
			addi.l	#$2000,obj.field_2A(a0)
			move.l	obj.ypos(a0),d0
			move.l	obj.field_2A(a0),d1
			add.l	d1,d0
			move.l	d0,obj.ypos(a0)
			tst.l	d1
			bpl.w	loc_20A8AE
			cmpi.l	#$FFFF0000,d1
			bpl.w	loc_20A8A6
loc_20A892:								; CODE XREF: ROM:0020A8AC↓j
										; ROM:0020A8BA↓j
			lea	(obj16_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A8A6:								; CODE XREF: ROM:0020A88E↑j
			move.b	#6,obj.ani(a0)
			bra.s	loc_20A892
; ---------------------------------------------------------------------------
loc_20A8AE:								; CODE XREF: ROM:0020A884↑j
			move.b	#4,obj.routine(a0)
			move.b	#7,obj.ani(a0)
			bra.s	loc_20A892
; ---------------------------------------------------------------------------
loc_20A8BC:								; DATA XREF: ROM:0020A82C↑o
			addi.l	#$2000,obj.field_2A(a0)
			move.l	obj.ypos(a0),d0
			move.l	obj.field_2A(a0),d1
			add.l	d1,d0
			move.l	d0,obj.ypos(a0)
			move.l	#-$60000,d2
			neg.l	d2
			cmp.l	d2,d1
			bpl.w	loc_20A8FE
			cmpi.l	#$10000,d1
			bpl.w	loc_20A90C
loc_20A8EA:								; CODE XREF: ROM:0020A912↓j
			lea	(obj16_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A8FE:								; CODE XREF: ROM:0020A8DC↑j
			move.b	#6,obj.routine(a0)
			move.w	#$C8,obj.field_2E(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A90C:								; CODE XREF: ROM:0020A8E6↑j
			move.b	#5,obj.ani(a0)
			bra.s	loc_20A8EA
; ---------------------------------------------------------------------------
loc_20A914:								; DATA XREF: ROM:0020A82E↑o
			subq.w	#1,obj.field_2E(a0)
			beq.w	loc_20A91E
			rts
; ---------------------------------------------------------------------------
loc_20A91E:								; CODE XREF: ROM:0020A918↑j
			move.b	#0,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR obj13
loc_20A926:								; CODE XREF: obj13+38↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20A93A(pc,d0.w),d0
			jsr	off_20A93A(pc,d0.w)
			jmp	(loc_206FB8).l
; END OF FUNCTION CHUNK FOR obj13
; ---------------------------------------------------------------------------
off_20A93A: dc.w loc_20A946-*			; CODE XREF: obj13+DD6↑p
										; DATA XREF: obj13+DD2↑r ...
			dc.w loc_20A992-off_20A93A
			dc.w loc_20A9EA-off_20A93A
			dc.w loc_20AA90-off_20A93A
			dc.w loc_20ABA4-off_20A93A
			dc.w loc_20AB36-off_20A93A
; ---------------------------------------------------------------------------
loc_20A946:								; DATA XREF: ROM:off_20A93A↑o
			move.b	#6,obj.colflag(a0)
			addq.b	#2,obj.routine(a0)
			move.l	#obj22_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.w	#$400,obj.vram(a0)
			move.w	#$C00,obj.vram(a0)
			move.w	#$1400,obj.vram(a0)
			move.w	#$24C1,obj.vram(a0)
			moveq	#4,d0
			jsr	(sub_20DC4C).l
			move.w	#0,obj.field_3E(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A992:								; DATA XREF: ROM:0020A93C↑o
			move.b	#1,obj.ani(a0)
			move.l	obj.ypos(a0),d0
			addi.l	#$10000,d0
			move.l	d0,obj.ypos(a0)
			move.b	#$E,obj.field_16(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			beq.w	loc_20A9D0
			bmi.w	loc_20A9D0
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A9D0:								; CODE XREF: ROM:0020A9B4↑j
										; ROM:0020A9B8↑j
			move.b	#4,obj.routine(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A9EA:								; DATA XREF: ROM:0020A93E↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$120,d0
			beq.w	loc_20AA5C
			bclr	#0,obj.render(a0)
			bclr	#0,obj.status(a0)
			move.b	#1,obj.ani(a0)
			move.b	#$E,obj.field_16(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			beq.w	loc_20AA3A
			cmpi.w	#7,d1
			bpl.w	loc_20AA5C
			cmpi.w	#-7,d1
			bmi.w	loc_20AA5C
			move.w	obj.ypos(a0),d0
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
loc_20AA3A:								; CODE XREF: ROM:0020AA1C↑j
			move.l	obj.xpos(a0),d0
			subi.l	#$C000,d0
			move.l	d0,obj.xpos(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AA5C:								; CODE XREF: ROM:0020A9F8↑j
										; ROM:0020AA24↑j ...
			move.l	obj.xpos(a0),d0
			addi.l	#$C000,d0
			move.l	d0,obj.xpos(a0)
			move.w	#0,obj.field_3E(a0)
			move.b	#$A,obj.routine(a0)
			move.b	#2,obj.ani(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AA90:								; DATA XREF: ROM:0020A940↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$120,d0
			beq.w	loc_20AB02
			bset	#0,obj.render(a0)
			bset	#0,obj.status(a0)
			move.b	#1,obj.ani(a0)
			move.b	#$E,obj.field_16(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			beq.w	loc_20AAE0
			cmpi.w	#7,d1
			bpl.w	loc_20AB02
			cmpi.w	#-7,d1
			bmi.w	loc_20AB02
			move.w	obj.ypos(a0),d0
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
loc_20AAE0:								; CODE XREF: ROM:0020AAC2↑j
			move.l	obj.xpos(a0),d0
			addi.l	#$C000,d0
			move.l	d0,obj.xpos(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AB02:								; CODE XREF: ROM:0020AA9E↑j
										; ROM:0020AACA↑j ...
			move.w	#0,obj.field_3E(a0)
			move.b	#8,obj.routine(a0)
			move.b	#2,obj.ani(a0)
			move.l	obj.xpos(a0),d0
			subi.l	#$C000,d0
			move.l	d0,obj.xpos(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AB36:								; DATA XREF: ROM:0020A944↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$46,d0
			beq.w	loc_20AB82
			cmpi.w	#$5A,d0
			beq.w	loc_20AB9E
			cmpi.w	#$96,d0
			beq.w	loc_20AB8A
			cmpi.w	#$B4,d0
			beq.w	loc_20AB74
loc_20AB60:								; CODE XREF: ROM:0020AB80↓j
										; ROM:0020AB88↓j ...
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AB74:								; CODE XREF: ROM:0020AB5C↑j
			move.w	#0,obj.field_3E(a0)
			move.b	#6,obj.routine(a0)
			bra.s	loc_20AB60
; ---------------------------------------------------------------------------
loc_20AB82:								; CODE XREF: ROM:0020AB44↑j
			move.b	#3,obj.ani(a0)
			bra.s	loc_20AB60
; ---------------------------------------------------------------------------
loc_20AB8A:								; CODE XREF: ROM:0020AB54↑j
			move.b	#2,obj.ani(a0)
			bset	#0,obj.render(a0)
			bset	#0,obj.status(a0)
			bra.s	loc_20AB60
; ---------------------------------------------------------------------------
loc_20AB9E:								; CODE XREF: ROM:0020AB4C↑j
			bsr.w	sub_20AC12
			bra.s	loc_20AB60
; ---------------------------------------------------------------------------
loc_20ABA4:								; DATA XREF: ROM:0020A942↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$46,d0
			beq.w	loc_20ABF0
			cmpi.w	#$5A,d0
			beq.w	loc_20AC0C
			cmpi.w	#$96,d0
			beq.w	loc_20ABF8
			cmpi.w	#$B4,d0
			beq.w	loc_20ABE2
loc_20ABCE:								; CODE XREF: ROM:0020ABEE↓j
										; ROM:0020ABF6↓j ...
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20ABE2:								; CODE XREF: ROM:0020ABCA↑j
			move.w	#0,obj.field_3E(a0)
			move.b	#4,obj.routine(a0)
			bra.s	loc_20ABCE
; ---------------------------------------------------------------------------
loc_20ABF0:								; CODE XREF: ROM:0020ABB2↑j
			move.b	#3,obj.ani(a0)
			bra.s	loc_20ABCE
; ---------------------------------------------------------------------------
loc_20ABF8:								; CODE XREF: ROM:0020ABC2↑j
			move.b	#2,obj.ani(a0)
			bclr	#0,obj.render(a0)
			bclr	#0,obj.status(a0)
			bra.s	loc_20ABCE
; ---------------------------------------------------------------------------
loc_20AC0C:								; CODE XREF: ROM:0020ABBA↑j
			bsr.w	sub_20AC12
			bra.s	loc_20ABCE
; =============== S U B R O U T I N E =======================================
sub_20AC12:								; CODE XREF: ROM:loc_20AB9E↑p
										; ROM:loc_20AC0C↑p
			move.b	#1,d6
			bsr.w	sub_20AC24
			move.b	#2,d6
			bsr.w	sub_20AC24
			rts
; End of function sub_20AC12
; =============== S U B R O U T I N E =======================================
sub_20AC24:								; CODE XREF: sub_20AC12+4↑p
										; sub_20AC12+C↑p
			jsr	(sub_20B4D8).l
			tst.b	d0
			beq.w	locret_20AC56
			move.b	d6,obj.field_28(a2)
			move.b	#$23,obj.id(a2)
			move.l	obj.xpos(a0),d1
			addi.l	#0,d1
			move.l	d1,obj.xpos(a2)
			move.l	obj.ypos(a0),d1
			addi.l	#$FFF00000,d1
			move.l	d1,obj.ypos(a2)
locret_20AC56:							; CODE XREF: sub_20AC24+8↑j
			rts
; End of function sub_20AC24
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR obj13
loc_20AC58:								; CODE XREF: obj13+34↑j
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20AC6C(pc,d0.w),d0
			jsr	off_20AC6C(pc,d0.w)
			jmp	(loc_206FB8).l
; END OF FUNCTION CHUNK FOR obj13
; ---------------------------------------------------------------------------
off_20AC6C: dc.w loc_20AC78-*			; CODE XREF: obj13+1108↑p
										; DATA XREF: obj13+1104↑r ...
			dc.w loc_20ACC4-off_20AC6C
			dc.w loc_20AD1C-off_20AC6C
			dc.w loc_20ADC2-off_20AC6C
			dc.w loc_20AED6-off_20AC6C
			dc.w loc_20AE68-off_20AC6C
; ---------------------------------------------------------------------------
loc_20AC78:								; DATA XREF: ROM:off_20AC6C↑o
			move.b	#6,obj.colflag(a0)
			addq.b	#2,obj.routine(a0)
			move.l	#obj22_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.w	#$400,obj.vram(a0)
			move.w	#$C00,obj.vram(a0)
			move.w	#$1400,obj.vram(a0)
			move.w	#$24C1,obj.vram(a0)
			moveq	#4,d0
			jsr	(sub_20DC4C).l
			move.w	#0,obj.field_3E(a0)
			rts
; ---------------------------------------------------------------------------
loc_20ACC4:								; DATA XREF: ROM:0020AC6E↑o
			move.b	#4,obj.ani(a0)
			move.l	obj.ypos(a0),d0
			addi.l	#$10000,d0
			move.l	d0,obj.ypos(a0)
			move.b	#$E,obj.field_16(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			beq.w	loc_20AD02
			bmi.w	loc_20AD02
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AD02:								; CODE XREF: ROM:0020ACE6↑j
										; ROM:0020ACEA↑j
			move.b	#4,obj.routine(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AD1C:								; DATA XREF: ROM:0020AC70↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$1B0,d0
			beq.w	loc_20AD8E
			bclr	#0,obj.render(a0)
			bclr	#0,obj.status(a0)
			move.b	#4,obj.ani(a0)
			move.b	#$E,obj.field_16(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			beq.w	loc_20AD6C
			cmpi.w	#7,d1
			bpl.w	loc_20AD8E
			cmpi.w	#-7,d1
			bmi.w	loc_20AD8E
			move.w	obj.ypos(a0),d0
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
loc_20AD6C:								; CODE XREF: ROM:0020AD4E↑j
			move.l	obj.xpos(a0),d0
			subi.l	#$5000,d0
			move.l	d0,obj.xpos(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AD8E:								; CODE XREF: ROM:0020AD2A↑j
										; ROM:0020AD56↑j ...
			move.l	obj.xpos(a0),d0
			addi.l	#$5000,d0
			move.l	d0,obj.xpos(a0)
			move.w	#0,obj.field_3E(a0)
			move.b	#$A,obj.routine(a0)
			move.b	#2,obj.ani(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20ADC2:								; DATA XREF: ROM:0020AC72↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$1B0,d0
			beq.w	loc_20AE34
			bset	#0,obj.render(a0)
			bset	#0,obj.status(a0)
			move.b	#4,obj.ani(a0)
			move.b	#$E,obj.field_16(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			beq.w	loc_20AE12
			cmpi.w	#7,d1
			bpl.w	loc_20AE34
			cmpi.w	#-7,d1
			bmi.w	loc_20AE34
			move.w	obj.ypos(a0),d0
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
loc_20AE12:								; CODE XREF: ROM:0020ADF4↑j
			move.l	obj.xpos(a0),d0
			addi.l	#$5000,d0
			move.l	d0,obj.xpos(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AE34:								; CODE XREF: ROM:0020ADD0↑j
										; ROM:0020ADFC↑j ...
			move.w	#0,obj.field_3E(a0)
			move.b	#8,obj.routine(a0)
			move.b	#2,obj.ani(a0)
			move.l	obj.xpos(a0),d0
			subi.l	#$5000,d0
			move.l	d0,obj.xpos(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AE68:								; DATA XREF: ROM:0020AC76↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$50,d0
			beq.w	loc_20AEB4
			cmpi.w	#$96,d0
			beq.w	loc_20AED0
			cmpi.w	#$BE,d0
			beq.w	loc_20AEBC
			cmpi.w	#$F0,d0
			beq.w	loc_20AEA6
loc_20AE92:								; CODE XREF: ROM:0020AEB2↓j
										; ROM:0020AEBA↓j ...
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AEA6:								; CODE XREF: ROM:0020AE8E↑j
			move.w	#0,obj.field_3E(a0)
			move.b	#6,obj.routine(a0)
			bra.s	loc_20AE92
; ---------------------------------------------------------------------------
loc_20AEB4:								; CODE XREF: ROM:0020AE76↑j
			move.b	#3,obj.ani(a0)
			bra.s	loc_20AE92
; ---------------------------------------------------------------------------
loc_20AEBC:								; CODE XREF: ROM:0020AE86↑j
			move.b	#2,obj.ani(a0)
			bset	#0,obj.render(a0)
			bset	#0,obj.status(a0)
			bra.s	loc_20AE92
; ---------------------------------------------------------------------------
loc_20AED0:								; CODE XREF: ROM:0020AE7E↑j
			bsr.w	sub_20AF44
			bra.s	loc_20AE92
; ---------------------------------------------------------------------------
loc_20AED6:								; DATA XREF: ROM:0020AC74↑o
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$50,d0
			beq.w	loc_20AF22
			cmpi.w	#$96,d0
			beq.w	loc_20AF3E
			cmpi.w	#$BE,d0
			beq.w	loc_20AF2A
			cmpi.w	#$F0,d0
			beq.w	loc_20AF14
loc_20AF00:								; CODE XREF: ROM:0020AF20↓j
										; ROM:0020AF28↓j ...
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AF14:								; CODE XREF: ROM:0020AEFC↑j
			move.w	#0,obj.field_3E(a0)
			move.b	#4,obj.routine(a0)
			bra.s	loc_20AF00
; ---------------------------------------------------------------------------
loc_20AF22:								; CODE XREF: ROM:0020AEE4↑j
			move.b	#3,obj.ani(a0)
			bra.s	loc_20AF00
; ---------------------------------------------------------------------------
loc_20AF2A:								; CODE XREF: ROM:0020AEF4↑j
			move.b	#2,obj.ani(a0)
			bclr	#0,obj.render(a0)
			bclr	#0,obj.status(a0)
			bra.s	loc_20AF00
; ---------------------------------------------------------------------------
loc_20AF3E:								; CODE XREF: ROM:0020AEEC↑j
			bsr.w	sub_20AF44
			bra.s	loc_20AF00
; =============== S U B R O U T I N E =======================================
sub_20AF44:								; CODE XREF: ROM:loc_20AED0↑p
										; ROM:loc_20AF3E↑p
			move.b	#3,d6
			bsr.w	sub_20AF56
			move.b	#4,d6
			bsr.w	sub_20AF56
			rts
; End of function sub_20AF44
; =============== S U B R O U T I N E =======================================
sub_20AF56:								; CODE XREF: sub_20AF44+4↑p
										; sub_20AF44+C↑p
			jsr	(sub_20B4D8).l
			tst.b	d0
			beq.w	locret_20AF88
			move.b	d6,obj.field_28(a2)
			move.b	#$23,obj.id(a2)
			move.l	obj.xpos(a0),d1
			addi.l	#0,d1
			move.l	d1,obj.xpos(a2)
			move.l	obj.ypos(a0),d1
			addi.l	#$FFF00000,d1
			move.l	d1,obj.ypos(a2)
locret_20AF88:							; CODE XREF: sub_20AF56+8↑j
			rts
; End of function sub_20AF56
; ---------------------------------------------------------------------------
obj13_ani:	dc.w unk_20AF92-*			; DATA XREF: obj13+17C↑o
										; obj13+1BC↑o ...
			dc.w unk_20AF9A-obj13_ani
			dc.w unk_20AF9E-obj13_ani
			dc.w unk_20AFAE-obj13_ani
unk_20AF92: dc.b $13					; DATA XREF: ROM:obj13_ani↑o
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b $FF
			even
unk_20AF9A: dc.b   1					; DATA XREF: ROM:0020AF8C↑o
			dc.b   0
			dc.b   1
			dc.b $FF
			even
unk_20AF9E: dc.b   6					; DATA XREF: ROM:0020AF8E↑o
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b $FF
			even
unk_20AFAE: dc.b   0					; DATA XREF: ROM:0020AF90↑o
			dc.b   4
			dc.b $FF
			even
obj13_map:	dc.w byte_20AFBC-*			; DATA XREF: ROM:00206C86↑o
										; obj13+116↑o ...
			dc.w byte_20AFC7-obj13_map
			dc.w byte_20AFD2-obj13_map
			dc.w byte_20AFE2-obj13_map
			dc.w byte_20AFF2-obj13_map
byte_20AFBC:	dc.b 2						; DATA XREF: ROM:obj13_map↑o
			dc.b $F4, $A,  0,  0,$F8
			dc.b $FC,  0,  0,  9,$F0
byte_20AFC7:	dc.b 2						; DATA XREF: ROM:0020AFB4↑o
			dc.b $FC,  9,  0, $A,$F8
			dc.b $FC,  0,  0,  9,$F0
byte_20AFD2:	dc.b 3						; DATA XREF: ROM:0020AFB6↑o
			dc.b $F0,  6,  0,$10,  0
			dc.b   8,  4,  0,$16,$F0
			dc.b   0,  0,  0,$18,$F8
byte_20AFE2:	dc.b 3						; DATA XREF: ROM:0020AFB8↑o
			dc.b $F0,  9,  0,$19,$F8
			dc.b   0,  4,  0,$1F,$F8
			dc.b   8,  0,  0,$21,$F8
byte_20AFF2:	dc.b 3						; DATA XREF: ROM:0020AFBA↑o
			dc.b $F0,  6,  0,$22,$F4
			dc.b   8,  0,  0,$28,$FC
			dc.b $F0,  0,  0,$29,  4
			even
obj13b_ani: dc.w unk_20B00A-*			; DATA XREF: ROM:00209E7E↑o
										; ROM:00209EBE↑o ...
			dc.w unk_20B012-obj13b_ani
			dc.w unk_20B016-obj13b_ani
			dc.w unk_20B020-obj13b_ani
unk_20B00A: dc.b $13					; DATA XREF: ROM:obj13b_ani↑o
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b $FF
			even
unk_20B012: dc.b   4					; DATA XREF: ROM:0020B004↑o
			dc.b   0
			dc.b   1
			dc.b $FF
			even
unk_20B016: dc.b  $E					; DATA XREF: ROM:0020B006↑o
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b $FF
			even
unk_20B020: dc.b   0					; DATA XREF: ROM:0020B008↑o
			dc.b   4
			dc.b $FF
			even
obj13b_map: dc.w byte_20B02E-*			; DATA XREF: ROM:00209E12↑o
										; ROM:0020B026↓o ...
			dc.w byte_20B039-obj13b_map
			dc.w byte_20B03F-obj13b_map
			dc.w byte_20B04F-obj13b_map
			dc.w byte_20B05F-obj13b_map
byte_20B02E:	dc.b 2						; DATA XREF: ROM:obj13b_map↑o
			dc.b $F4, $A,  0,$2A,$F8
			dc.b $FC,  1,  0,$33,$F0
byte_20B039:	dc.b 1						; DATA XREF: ROM:0020B026↑o
			dc.b $FC, $D,  0,$35,$F0
byte_20B03F:	dc.b 3						; DATA XREF: ROM:0020B028↑o
			dc.b $F0,  6,  0,$10,  0
			dc.b   0,  1,  0,$3D,$F8
			dc.b   8,  0,  0,$3F,$F0
byte_20B04F:	dc.b 3						; DATA XREF: ROM:0020B02A↑o
			dc.b $F0,  9,  0,$19,$F8
			dc.b   0,  4,  0,$40,$F8
			dc.b   8,  0,  0,$42,$F8
byte_20B05F:	dc.b 3						; DATA XREF: ROM:0020B02C↑o
			dc.b $F0,  6,  0,$43,$F4
			dc.b   8,  0,  0,$49,$FC
			dc.b $F0,  0,  0,$29,  4
			even
obj14b_ani: dc.w unk_20B07A-*			; DATA XREF: ROM:loc_20A274↑o
										; ROM:loc_20A2FA↑o ...
			dc.w unk_20B082-obj14b_ani
			dc.b $13
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   1
			dc.b $FF
			even
unk_20B07A: dc.b   4					; DATA XREF: ROM:obj14b_ani↑o
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   1
			dc.b $FF
			even
unk_20B082: dc.b   4					; DATA XREF: ROM:0020B072↑o
			dc.b   3
			dc.b   3
			dc.b   4
			dc.b   5
			dc.b   4
			dc.b $FF
			even
obj14_map:	dc.w byte_20B096-*			; DATA XREF: ROM:00206C92↑o
										; ROM:00209FA4↑o ...
			dc.w byte_20B0A6-obj14_map
			dc.w byte_20B0B6-obj14_map
			dc.w byte_20B096-obj14_map
			dc.w byte_20B0A6-obj14_map
			dc.w byte_20B0B6-obj14_map
byte_20B096:	dc.b 3						; DATA XREF: ROM:obj14_map↑o
										; ROM:0020B090↑o
			dc.b $F0,  8,  0,  0,$F8
			dc.b $F8, $D,  0,  3,$F0
			dc.b   8,  8,  0, $B,$F0
			even
byte_20B0A6:	dc.b 3						; DATA XREF: ROM:0020B08C↑o
										; ROM:0020B092↑o
			dc.b $F8,  9,  0, $E,$F0
			dc.b   0,  0,  0,$14,  8
			dc.b   8,  0,  0,$15,  0
			even
byte_20B0B6:	dc.b 3						; DATA XREF: ROM:0020B08E↑o
										; ROM:0020B094↑o
			dc.b $F0,  0,  0,$16,$F0
			dc.b $F8,  8,  0,$17,$F0
			dc.b   0, $D,  0,$1A,$F0
			even
obj14_ani:	dc.w unk_20B0D0-*			; DATA XREF: ROM:loc_20A060↑o
										; ROM:loc_20A0E6↑o ...
			dc.w unk_20B0D8-obj14_ani
			dc.b $13
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   1
			dc.b $FF
			even
unk_20B0D0: dc.b   4					; DATA XREF: ROM:obj14_ani↑o
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   1
			dc.b $FF
			even
unk_20B0D8: dc.b   4					; DATA XREF: ROM:0020B0C8↑o
			dc.b   3
			dc.b   3
			dc.b   4
			dc.b   5
			dc.b   4
			dc.b $FF
			even
off_20B0E0: dc.w byte_20B0EC-*			; DATA XREF: ROM:0020B0E2↓o
										; ROM:0020B0E4↓o ...
			dc.w byte_20B0FC-off_20B0E0
			dc.w byte_20B10C-off_20B0E0
			dc.w byte_20B0EC-off_20B0E0
			dc.w byte_20B0FC-off_20B0E0
			dc.w byte_20B10C-off_20B0E0
byte_20B0EC:	dc.b 3						; DATA XREF: ROM:off_20B0E0↑o
										; ROM:0020B0E6↑o
			dc.b $F0,  8,  0,  0,$F8
			dc.b $F8, $D,  0,$22,$F0
			dc.b   8,  8,  0, $B,$F0
			even
byte_20B0FC:	dc.b 3						; DATA XREF: ROM:0020B0E2↑o
										; ROM:0020B0E8↑o
			dc.b $F8,  9,  0, $E,$F0
			dc.b   0,  0,  0,$14,  8
			dc.b   8,  0,  0,$15,  0
			even
byte_20B10C:	dc.b 3						; DATA XREF: ROM:0020B0E4↑o
										; ROM:0020B0EA↑o
			dc.b $F0,  0,  0,$16,$F0
			dc.b $F8,  8,  0,$17,$F0
			dc.b   0, $D,  0,$2A,$F0
			even
off_20B11C: dc.w unk_20B132-*			; DATA XREF: ROM:0020A424↑o
										; ROM:loc_20A484↑o ...
			dc.w unk_20B136-off_20B11C
			dc.w unk_20B12E-off_20B11C
			dc.w unk_20B124-off_20B11C
unk_20B124: dc.b $13					; DATA XREF: ROM:0020B122↑o
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b   5
			dc.b   6
			dc.b   7
			dc.b $FF
			even
unk_20B12E: dc.b $13					; DATA XREF: ROM:0020B120↑o
			dc.b   0
			dc.b $FF
			even
unk_20B132: dc.b   3					; DATA XREF: ROM:off_20B11C↑o
			dc.b   6
			dc.b   7
			dc.b $FF
			even
unk_20B136: dc.b   3					; DATA XREF: ROM:0020B11E↑o
			dc.b   8
			dc.b   9
			dc.b $FF
			even
obj15_map:	dc.w byte_20B1B6-*			; DATA XREF: ROM:00206C9E↑o
										; ROM:0020A3DA↑o ...
			dc.w byte_20B1C6-obj15_map
			dc.w byte_20B1CC-obj15_map
			dc.w byte_20B1D2-obj15_map
			dc.w byte_20B1D8-obj15_map
			dc.w byte_20B1DE-obj15_map
			dc.w byte_20B14E-obj15_map
			dc.w byte_20B168-obj15_map
			dc.w byte_20B182-obj15_map
			dc.w byte_20B19C-obj15_map
byte_20B14E:	dc.b 5						; DATA XREF: ROM:0020B146↑o
			dc.b $EA,  5,  0,  0,$F4
			dc.b $FA,  0,  0,  4,$F4
			dc.b $FA,  5,  0,  5,$FC
			dc.b   2,  5,  0,  9,$F8
			dc.b $FA,  0,  0,$11, $E
			even
byte_20B168:	dc.b 5						; DATA XREF: ROM:0020B148↑o
			dc.b $EB,  5,  0,  0,$F4
			dc.b $FB,  0,  0,  4,$F4
			dc.b $FB,  5,  0,  5,$FC
			dc.b   2,  5,  0, $D,$F8
			dc.b $FA,  0,  0,$11,$12
			even
byte_20B182:	dc.b 5						; DATA XREF: ROM:0020B14A↑o
			dc.b $EA,  5,  0,$12,$F4
			dc.b $FA,  0,  0,  4,$F4
			dc.b $FA,  5,  0,  5,$FC
			dc.b   2,  5,  0,  9,$F8
			dc.b $FA,  0,  0,$11, $E
			even
byte_20B19C:	dc.b 5						; DATA XREF: ROM:0020B14C↑o
			dc.b $EB,  5,  0,$12,$F4
			dc.b $FB,  0,  0,  4,$F4
			dc.b $FB,  5,  0,  5,$FC
			dc.b   2,  5,  0, $D,$F8
			dc.b $FA,  0,  0,$11,$12
			even
byte_20B1B6:	dc.b 3						; DATA XREF: ROM:obj15_map↑o
			dc.b $F0,  5,  0,  0,$F4
			dc.b   0,  0,  0,  4,$F4
			dc.b   0,  5,  0,  5,$FC
			even
byte_20B1C6:	dc.b 1						; DATA XREF: ROM:0020B13C↑o
			dc.b $F8,  5,  0,  9,$F8
			even
byte_20B1CC:	dc.b 1						; DATA XREF: ROM:0020B13E↑o
			dc.b $F8,  5,  0, $D,$F8
			even
byte_20B1D2:	dc.b 1						; DATA XREF: ROM:0020B140↑o
			dc.b $FC,  0,  0,$11,$FC
			even
byte_20B1D8:	dc.b 1						; DATA XREF: ROM:0020B142↑o
			dc.b $FC,  0,  0,$11,  0
			even
byte_20B1DE:	dc.b 3						; DATA XREF: ROM:0020B144↑o
			dc.b $F0,  5,  0,$12,$F4
			dc.b   0,  0,  0,  4,$F4
			dc.b   0,  5,  0,  5,$FC
			even
obj16_ani:	dc.w unk_20B202-*			; DATA XREF: ROM:loc_20A780↑o
										; ROM:loc_20A7D8↑o ...
			dc.w unk_20B206-obj16_ani
			dc.w unk_20B20A-obj16_ani
			dc.w unk_20B20E-obj16_ani
			dc.w unk_20B212-obj16_ani
			dc.w unk_20B216-obj16_ani
			dc.w unk_20B21A-obj16_ani
			dc.w unk_20B21E-obj16_ani
			dc.w unk_20B222-obj16_ani
			dc.w unk_20B22A-obj16_ani
unk_20B202: dc.b   9					; DATA XREF: ROM:obj16_ani↑o
			dc.b   6
			dc.b   7
			dc.b $FF
			even
unk_20B206: dc.b   9					; DATA XREF: ROM:0020B1F0↑o
			dc.b   8
			dc.b   9
			dc.b $FF
			even
unk_20B20A: dc.b $27 ; '				; DATA XREF: ROM:0020B1F2↑o
			dc.b  $A
			dc.b $FF
			even
unk_20B20E: dc.b $27 ; '				; DATA XREF: ROM:0020B1F4↑o
			dc.b  $B
			dc.b $FF
			even
unk_20B212: dc.b   9					; DATA XREF: ROM:0020B1F6↑o
			dc.b   6
			dc.b   7
			dc.b $FF
			even
unk_20B216: dc.b   9					; DATA XREF: ROM:0020B1F8↑o
			dc.b  $C
			dc.b  $D
			dc.b $FF
			even
unk_20B21A: dc.b $27 ; '				; DATA XREF: ROM:0020B1FA↑o
			dc.b  $A
			dc.b $FF
			even
unk_20B21E: dc.b $27 ; '				; DATA XREF: ROM:0020B1FC↑o
			dc.b  $E
			dc.b $FF
			even
unk_20B222: dc.b $27 ; '				; DATA XREF: ROM:0020B1FE↑o
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b   5
			dc.b $FF
			even
unk_20B22A: dc.b   9					; DATA XREF: ROM:0020B200↑o
			dc.b   6
			dc.b   7
			dc.b   6
			dc.b   7
			dc.b   6
			dc.b   7
			dc.b  $A
			dc.b  $A
			dc.b  $B
			dc.b  $B
			dc.b   8
			dc.b   9
			dc.b   9
			dc.b   8
			dc.b   9
			dc.b   8
			dc.b   9
			dc.b $FF
			even
obj16_map:	dc.w byte_20B25C-*			; DATA XREF: ROM:00206CAA↑o
										; ROM:0020A728↑o ...
			dc.w byte_20B271-obj16_map
			dc.w byte_20B286-obj16_map
			dc.w byte_20B29B-obj16_map
			dc.w byte_20B2B0-obj16_map
			dc.w byte_20B2BB-obj16_map
			dc.w byte_20B2F0-obj16_map
			dc.w byte_20B310-obj16_map
			dc.w byte_20B330-obj16_map
			dc.w byte_20B350-obj16_map
			dc.w byte_20B370-obj16_map
			dc.w byte_20B386-obj16_map
			dc.w byte_20B39B-obj16_map
			dc.w byte_20B3BA-obj16_map
			dc.w byte_20B3D9-obj16_map
byte_20B25C:	dc.b 4						; DATA XREF: ROM:obj16_map↑o
			dc.b $F0,  3,  0,  0,$F8
			dc.b $F8,  0,  0,  4,$F0
			dc.b $F0,  3,  8,  0,  0
			dc.b $F8,  0,  8,  4,  8
byte_20B271:	dc.b 4						; DATA XREF: ROM:0020B240↑o
			dc.b $F0,  6,  0,  5,$F0
			dc.b   8,  0,  0, $B,$F8
			dc.b $F0,  6,  8,  5,  0
			dc.b   8,  0,  8, $B,  0
byte_20B286:	dc.b 4						; DATA XREF: ROM:0020B242↑o
			dc.b $F8,  6,  0, $C,$F0
			dc.b $F0,  0,  0,$12,$F8
			dc.b $F8,  6,  8, $C,  0
			dc.b $F0,  0,  8,$12,  0
byte_20B29B:	dc.b 4						; DATA XREF: ROM:0020B244↑o
			dc.b $F0,  3,  0,$13,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$13,  0
			dc.b   0,  0,$18,  4,  8
byte_20B2B0:	dc.b 2						; DATA XREF: ROM:0020B246↑o
			dc.b $F4,  6,  0,$17,$F0
			dc.b $F4,  6,  8,$17,  0
byte_20B2BB:	dc.b 2						; DATA XREF: ROM:0020B248↑o
			dc.b $F4,  6,  0,$1D,$F0
			dc.b $F4,  6,  8,$1D,  0


			dc.b 4
			dc.b $F8,  6,  0,$23,$F0
			dc.b $F0,  0,  0,$29,$F8
			dc.b $F8,  6,  8,$23,  0
			dc.b $F0,  0,  8,$29,  0
			dc.b 4
			dc.b $F0,  3,  0,$2A,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$2A,  0
			dc.b   0,  0,$18,  4,  8
byte_20B2F0:	dc.b 6						; DATA XREF: ROM:0020B24A↑o
			dc.b $F0,  3,  0,  0,$F8
			dc.b $F8,  0,  0,  4,$F0
			dc.b $F0,  3,  8,  0,  0
			dc.b $F8,  0,  8,  4,  8
			dc.b $E5,  6,  0,$17,$F0
			dc.b $E5,  6,  8,$17,  0
			even
byte_20B310:	dc.b 6						; DATA XREF: ROM:0020B24C↑o
			dc.b $F0,  3,  0,  0,$F8
			dc.b $F8,  0,  0,  4,$F0
			dc.b $F0,  3,  8,  0,  0
			dc.b $F8,  0,  8,  4,  8
			dc.b $E5,  6,  0,$1D,$F0
			dc.b $E5,  6,  8,$1D,  0
			even
byte_20B330:	dc.b 6						; DATA XREF: ROM:0020B24E↑o
			dc.b $F0,  3,  0,$13,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$13,  0
			dc.b   0,  0,$18,  4,  8
			dc.b   3,  6,$10,$17,$F0
			dc.b   3,  6,$18,$17,  0
			even
byte_20B350:	dc.b 6						; DATA XREF: ROM:0020B250↑o
			dc.b $F0,  3,  0,$13,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$13,  0
			dc.b   0,  0,$18,  4,  8
			dc.b   3,  6,$10,$1D,$F0
			dc.b   3,  6,$18,$1D,  0
			even
byte_20B370:	dc.b 4						; DATA XREF: ROM:0020B252↑o
			dc.b $F0,  6,  0,  5,$F0
			dc.b   8,  0,  0, $B,$F8
			dc.b $F0,  6,  8,  5,  0
			dc.b   8,  0,  8, $B,  0
			even
byte_20B386:	dc.b 4						; DATA XREF: ROM:0020B254↑o
			dc.b $F8,  6,  0, $C,$F0
			dc.b $F0,  0,  0,$12,$F8
			dc.b $F8,  6,  8, $C,  0
			dc.b $F0,  0,  8,$12,  0
byte_20B39B:	dc.b 6						; DATA XREF: ROM:0020B256↑o
			dc.b $F0,  3,  0,$2A,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$2A,  0
			dc.b   0,  0,$18,  4,  8
			dc.b   3,  6,$10,$17,$F0
			dc.b   3,  6,$18,$17,  0
			even
byte_20B3BA:	dc.b 6						; DATA XREF: ROM:0020B258↑o
			dc.b $F0,  3,  0,$2A,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$2A,  0
			dc.b   0,  0,$18,  4,  8
			dc.b   3,  6,$10,$1D,$F0
			dc.b   3,  6,$18,$1D,  0
byte_20B3D9:	dc.b 4						; DATA XREF: ROM:0020B25A↑o
			dc.b $F8,  6,  0,$23,$F0
			dc.b $F0,  0,  0,$29,$F8
			dc.b $F8,  6,  8,$23,  0
			dc.b $F0,  0,  8,$29,  0
			even
obj22_ani:	dc.w unk_20B3F8-*			; DATA XREF: ROM:0020A9BC↑o
										; ROM:0020A9D6↑o ...
			dc.w unk_20B434-obj22_ani
			dc.w unk_20B43A-obj22_ani
			dc.w unk_20B43E-obj22_ani
			dc.w unk_20B442-obj22_ani
unk_20B3F8: dc.b $13					; DATA XREF: ROM:obj22_ani↑o
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   5
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   5
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b   5
			dc.b   6
			dc.b   7
			dc.b $FF
			even
unk_20B434: dc.b $13					; DATA XREF: ROM:0020B3F0↑o
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b $FF
			even
unk_20B43A: dc.b $13					; DATA XREF: ROM:0020B3F2↑o
			dc.b   0
			dc.b   0
			dc.b $FF
			even
unk_20B43E: dc.b   9					; DATA XREF: ROM:0020B3F4↑o
			dc.b   2
			dc.b   2
			dc.b $FF
			even
unk_20B442: dc.b   5					; DATA XREF: ROM:0020B3F6↑o
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b $FF
			even
obj22_map:	dc.w byte_20B458-*			; DATA XREF: ROM:00206CB6↑o
										; ROM:0020A950↑o ...
			dc.w byte_20B46D-obj22_map
			dc.w byte_20B482-obj22_map
			dc.w byte_20B48D-obj22_map
			dc.w byte_20B493-obj22_map
			dc.w byte_20B499-obj22_map
			dc.w byte_20B49F-obj22_map
			dc.w byte_20B4A5-obj22_map
byte_20B458:	dc.b 4						; DATA XREF: ROM:obj22_map↑o
			dc.b $F0,  9,  0,  0,$F8
			dc.b   0,  9,  0,  6,$F8
			dc.b $F8,  0,  0, $C,$F0
			dc.b   0,  0,  0, $D,$F0
byte_20B46D:	dc.b 4						; DATA XREF: ROM:0020B44A↑o
			dc.b $F1,  9,  0,  0,$F8
			dc.b   1,  9,  0, $E,$F8
			dc.b $F9,  0,  0, $C,$F0
			dc.b   1,  0,  0, $D,$F0
byte_20B482:	dc.b 2						; DATA XREF: ROM:0020B44C↑o
			dc.b $F0,  8,  0,$14,$F8
			dc.b $F8, $E,  0,$17,$F0
byte_20B48D:	dc.b 1						; DATA XREF: ROM:0020B44E↑o
			dc.b $FC,  0,  0,$23,$FC
byte_20B493:	dc.b 1						; DATA XREF: ROM:0020B450↑o
			dc.b $FC,  0,  0,$24,$FC
byte_20B499:	dc.b 1						; DATA XREF: ROM:0020B452↑o
			dc.b $F8,  5,  0,$25,$F8
byte_20B49F:	dc.b 1						; DATA XREF: ROM:0020B454↑o
			dc.b $F8,  5,  0,$29,$F8
byte_20B4A5:	dc.b 3						; DATA XREF: ROM:0020B456↑o
			dc.b $EF,  9,  0,$2D,$F8
			dc.b $F7,  0,  0, $C,$F0
			dc.b $FF, $D,  0,$33,$F0
			even
off_20B4B6: dc.w unk_20B4BC-*			; DATA XREF: obj13+C4↑o
										; ROM:0020B4B8↓o ...
			dc.w unk_20B4C0-off_20B4B6
			dc.w unk_20B4C4-off_20B4B6
unk_20B4BC: dc.b $1D					; DATA XREF: ROM:off_20B4B6↑o
			dc.b   0
			dc.b   1
			dc.b $FF
			even
unk_20B4C0: dc.b   0					; DATA XREF: ROM:0020B4B8↑o
			dc.b   0
			dc.b $FF
			even
unk_20B4C4: dc.b   0					; DATA XREF: ROM:0020B4BA↑o
			dc.b   1
			dc.b $FF
			even
off_20B4C8: dc.w byte_20B4CC-*			; DATA XREF: obj13+52↑o
										; ROM:0020B4CA↓o
			dc.w byte_20B4D2-off_20B4C8
byte_20B4CC:	dc.b 1						; DATA XREF: ROM:off_20B4C8↑o
			dc.b $F8,  5,  0,  0,$F8
byte_20B4D2:	dc.b 1						; DATA XREF: ROM:0020B4CA↑o
			dc.b $F8,  5,  0,  4,$F8
			even
; =============== S U B R O U T I N E =======================================
sub_20B4D8:								; CODE XREF: sub_20AC24↑p
										; sub_20AF56↑p
			lea	(unk_FFD400).w,a2
			moveq	#0,d0
loc_20B4DE:								; CODE XREF: sub_20B4D8+18↓j
			move.b	obj.id(a2),d1
			beq.w	loc_20B4F6
			addq.w	#1,d0
			lea	obj(a2),a2
			cmpi.w	#$3C,d0
			bne.s	loc_20B4DE
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_20B4F6:								; CODE XREF: sub_20B4D8+A↑j
			moveq	#-1,d0
			rts
; End of function sub_20B4D8
; ---------------------------------------------------------------------------
obj23:									; DATA XREF: ROM:00203536↑o
			moveq	#0,d0
			move.b	obj.field_28(a0),d0
			andi.w	#$7F,d0
			add.w	d0,d0
			move.w	off_20B510(pc,d0.w),d0
			jmp	off_20B510(pc,d0.w)
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
off_20B510: dc.w locret_20B524-*		; CODE XREF: ROM:0020B50A↑j
										; DATA XREF: ROM:0020B506↑r ...
			dc.w locret_20B524-off_20B510
			dc.w locret_20B524-off_20B510
			dc.w locret_20B524-off_20B510
			dc.w locret_20B524-off_20B510
			dc.w locret_20B524-off_20B510
			dc.w locret_20B524-off_20B510
			dc.w locret_20B524-off_20B510
			dc.w locret_20B524-off_20B510
			dc.w loc_20B526-off_20B510
; ---------------------------------------------------------------------------
locret_20B524:							; DATA XREF: ROM:off_20B510↑o
										; ROM:0020B512↑o ...
			rts
; ---------------------------------------------------------------------------
loc_20B526:								; DATA XREF: ROM:0020B522↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20B534(pc,d0.w),d0
			jmp	off_20B534(pc,d0.w)
; ---------------------------------------------------------------------------
off_20B534: dc.w loc_20B538-*			; CODE XREF: ROM:0020B530↑j
										; DATA XREF: ROM:0020B52C↑r ...
			dc.w loc_20B578-off_20B534
; ---------------------------------------------------------------------------
loc_20B538:								; DATA XREF: ROM:off_20B534↑o
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#4,obj.field_17(a0)
			move.b	#4,obj.field_16(a0)
			move.w	#$2400,obj.vram(a0)
			move.l	#obj23_map,obj.mappings(a0)
			move.l	#$10000,obj.field_2A(a0)
			move.b	obj.field_3F(a0),d0
			bpl.w	locret_20B576
			neg.l	obj.field_2A(a0)
locret_20B576:							; CODE XREF: ROM:0020B56E↑j
			rts
; ---------------------------------------------------------------------------
loc_20B578:								; DATA XREF: ROM:0020B536↑o
			move.l	obj.field_2A(a0),d0
			add.l	d0,obj.xpos(a0)
			lea	(obj23_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
obj23_ani:
			dc.w byte_20B592-obj23_ani

byte_20B592:
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b $FF
			even
obj23_map:	dc.w byte_20B59E-*			; DATA XREF: ROM:0020B55A↑o
										; ROM:0020B59C↓o
			dc.w byte_20B5B3-obj23_map
byte_20B59E:	dc.b 4						; DATA XREF: ROM:obj23_map↑o
			dc.b $F8,  0,  0,$2A,$F8
			dc.b $F8,  0,  8,$2A,  0
			dc.b   0,  0,$10,$2A,$F8
			dc.b   0,  0,$18,$2A,  0
byte_20B5B3:	dc.b 4						; DATA XREF: ROM:0020B59C↑o
			dc.b $F8,  0,  0,$2B,$F8
			dc.b $F8,  0,  8,$2B,  0
			dc.b   0,  0,$10,$2B,$F8
			dc.b   0,  0,$18,$2B,  0
			even
; ---------------------------------------------------------------------------
			movea.l a0,a1
			moveq	#obj-1,d0
			moveq	#0,d1
loc_20B5CE:								; CODE XREF: ROM:0020B5D0↓j
			move.b	d1,(a1)+
			dbf	d0,loc_20B5CE
			rts
; ---------------------------------------------------------------------------
			move.l	d1,-(sp)
			move.l	(dword_FFF636).w,d1
			bne.s	loc_20B5E4
			move.l	#$2A6D365A,d1
loc_20B5E4:								; CODE XREF: ROM:0020B5DC↑j
			move.l	d1,d0
			asl.l	#2,d1
			add.l	d0,d1
			asl.l	#3,d1
			add.l	d0,d1
			move.w	d1,d0
			swap	d1
			add.w	d1,d0
			move.w	d0,d1
			swap	d1
			move.l	d1,(dword_FFF636).w
			move.l	(sp)+,d1
			rts
; ---------------------------------------------------------------------------
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20B60E(pc,d0.w),d0
			jmp	off_20B60E(pc,d0.w)
; ---------------------------------------------------------------------------
off_20B60E: dc.w loc_20B612-*			; CODE XREF: ROM:0020B60A↑j
										; DATA XREF: ROM:0020B606↑r ...
			dc.w loc_20B654-off_20B60E
; ---------------------------------------------------------------------------
loc_20B612:								; DATA XREF: ROM:off_20B60E↑o
			addq.b	#2,obj.routine(a0)
			move.l	#off_20CF16,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.w	#$47A,obj.vram(a0)
			move.l	(actwk+obj.xpos).w,d0
			addi.l	#$32,d0
			move.l	d0,obj.xpos(a0)
			move.l	(actwk+obj.ypos).w,d0
			addi.l	#$320000,d0
			move.l	d0,obj.ypos(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B654:								; DATA XREF: ROM:0020B610↑o
			move.l	(actwk+obj.xpos).w,d0
			addi.l	#$320000,d0
			move.l	d0,obj.xpos(a0)
			move.l	(actwk+obj.ypos).w,d0
			subi.l	#$320000,d0
			move.l	d0,obj.ypos(a0)
			lea	(obj26_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; =============== S U B R O U T I N E =======================================
sub_20B684:								; CODE XREF: ROM:0020B88A↓p
										; ROM:0020B8CA↓p ...
			lea	(actwk).w,a1
			move.w	obj.yvel(a1),d1
			bmi.w	loc_20B694
			bra.w	loc_20B6EC
; ---------------------------------------------------------------------------
loc_20B694:								; CODE XREF: sub_20B684+8↑j
			moveq	#0,d1
			bclr	#3,obj.status(a0)
			rts
; ---------------------------------------------------------------------------
			lea	(actwk).w,a1
			move.w	obj.yvel(a1),d1
			bpl.w	loc_20B6AE
			bra.w	loc_20B6EC
; ---------------------------------------------------------------------------
loc_20B6AE:								; CODE XREF: sub_20B684+22↑j
			moveq	#0,d1
			bclr	#3,obj.status(a0)
			rts
; ---------------------------------------------------------------------------
			lea	(actwk).w,a1
			move.w	obj.xvel(a1),d1
			bmi.w	loc_20B6C8
			bra.w	loc_20B6EC
; ---------------------------------------------------------------------------
loc_20B6C8:								; CODE XREF: sub_20B684+3C↑j
			moveq	#0,d1
			bclr	#3,obj.status(a0)
			rts
; ---------------------------------------------------------------------------
			lea	(actwk).w,a1
			move.w	obj.xvel(a1),d1
			bpl.w	loc_20B6E2
			bra.w	loc_20B6EC
; ---------------------------------------------------------------------------
loc_20B6E2:								; CODE XREF: sub_20B684+56↑j
			moveq	#0,d1
			bclr	#3,obj.status(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B6EC:								; CODE XREF: sub_20B684+C↑j
										; sub_20B684+26↑j ...
			lea	(byte_20B7B6).l,a2
			move.l	d0,d1
			andi.w	#$FF00,d0
			cmpi.w	#$100,d0
			bne.w	loc_20B706
			lea	(byte_20B806).l,a2
loc_20B706:								; CODE XREF: sub_20B684+78↑j
			cmpi.w	#$200,d0
			bne.w	loc_20B714
			lea	(byte_20B80A).l,a2
loc_20B714:								; CODE XREF: sub_20B684+86↑j
			cmpi.w	#$300,d0
			bne.w	loc_20B722
			lea	(byte_20B80E).l,a2
loc_20B722:								; CODE XREF: sub_20B684+94↑j
			move.w	d1,d0
			andi.w	#$FF,d0
			asl.w	#2,d0
			lea	(a2,d0.w),a2
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d0
			move.w	obj.xpos(a1),d1
			move.b	obj.field_17(a1),d3
			ext.w	d3
			move.b	0(a2),d2
			ext.w	d2
			move.w	d0,d4
			move.w	d1,d5
			add.w	d2,d4
			sub.w	d3,d5
			cmp.w	d4,d5
			bpl.w	loc_20B7AC
			move.b	1(a2),d2
			ext.w	d2
			neg.w	d2
			move.w	d0,d4
			move.w	d1,d5
			sub.w	d2,d4
			add.w	d3,d5
			cmp.w	d5,d4
			bpl.w	loc_20B7AC
			move.w	obj.ypos(a0),d0
			move.w	obj.ypos(a1),d1
			move.b	obj.field_16(a1),d3
			ext.w	d3
			move.b	2(a2),d2
			ext.w	d2
			move.w	d0,d4
			move.w	d1,d5
			add.w	d2,d4
			sub.w	d3,d5
			cmp.w	d4,d5
			bpl.w	loc_20B7AC
			move.b	3(a2),d2
			ext.w	d2
			neg.w	d2
			move.w	d0,d4
			move.w	d1,d5
			sub.w	d2,d4
			add.w	d3,d5
			cmp.w	d5,d4
			bpl.w	loc_20B7AC
			moveq	#-1,d1
			bset	#3,obj.status(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B7AC:								; CODE XREF: sub_20B684+CC↑j
										; sub_20B684+E2↑j ...
			moveq	#0,d1
			bclr	#3,obj.status(a0)
			rts
; End of function sub_20B684
; ---------------------------------------------------------------------------
byte_20B7B6:	dc.b $10,$F0,$10,$F0		; DATA XREF: sub_20B684:loc_20B6EC↑o
			dc.b $10,$F0,  4,$FC
			dc.b   9,$F7,$38,$10
			dc.b   0,$E8,  4,$FC
			dc.b   0,$E8, $C,  0
			dc.b $18,  0,  4,$FC
			dc.b $18,  0, $C,  0
			dc.b $20,$E0,$20,$E0
			dc.b $10,$F0,$10,  0
			dc.b $20,$E0,$10,  0
			dc.b   8,$F8,$10,$F0
			dc.b   8,$F8,$18,$E8
			dc.b $10,$F0,  8,  1
			dc.b $10,$F0,  0,$F8
			dc.b $10,$F0,$10,$F0
			dc.b   8,$F8,$10,$C0
			dc.b $17,$E9,$10,$F0
			dc.b   8,$F8,  8,$F8
			dc.b $10,$F0,$10,$F0
			dc.b $10,$F0,$40,$C0
byte_20B806:	dc.b $10,$F0,$10,$F0		; DATA XREF: sub_20B684+7C↑o
byte_20B80A:	dc.b $10,$F0,$10,$F0		; DATA XREF: sub_20B684+8A↑o
byte_20B80E:	dc.b $10,$F0,$10,$F0		; DATA XREF: sub_20B684+98↑o
; ---------------------------------------------------------------------------
obj28:									; DATA XREF: ROM:0020354A↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20B826(pc,d0.w),d0
			jsr	off_20B826(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20B826: dc.w loc_20B834-*			; CODE XREF: ROM:0020B81C↑p
										; DATA XREF: ROM:0020B818↑r ...
			dc.w loc_20B888-off_20B826
			dc.w loc_20B8C8-off_20B826
			dc.w loc_20B9B4-off_20B826
			dc.w loc_20B908-off_20B826
			dc.w loc_20B9FC-off_20B826
			dc.w loc_20B950-off_20B826
; ---------------------------------------------------------------------------
loc_20B834:								; DATA XREF: ROM:off_20B826↑o
			move.l	#obj28_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#7,d0
			jsr	sub_20DC4C(pc)
			move.b	#$18,obj.field_17(a0)
			move.b	#4,obj.field_16(a0)
			move.b	obj.field_28(a0),d0
			cmpi.b	#1,d0
			beq.w	loc_20B87A
			move.b	#3,obj.ani(a0)
			move.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B87A:								; CODE XREF: ROM:0020B868↑j
			move.b	#4,obj.ani(a0)
			move.b	#4,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B888:								; DATA XREF: ROM:0020B828↑o
			moveq	#5,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20B8B6
			lea	(actwk).w,a1
			move.l	obj.ypos(a0),d0
			moveq	#0,d1
			move.b	obj.field_16(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
			move.b	#$A,obj.routine(a0)
			move.b	#3,obj.ani(a0)
loc_20B8B6:								; CODE XREF: ROM:0020B890↑j
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20B8C8:								; DATA XREF: ROM:0020B82A↑o
			moveq	#3,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20B8F6
			lea	(actwk).w,a1
			move.l	obj.ypos(a0),d0
			moveq	#0,d1
			move.b	obj.field_16(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
			move.b	#$C,obj.routine(a0)
			move.b	#4,obj.ani(a0)
loc_20B8F6:								; CODE XREF: ROM:0020B8D0↑j
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20B908:								; DATA XREF: ROM:0020B82E↑o
			moveq	#3,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20B926
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20B926:								; CODE XREF: ROM:0020B910↑j
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
			move.b	#4,obj.routine(a0)
			btst	#1,obj.status(a1)
			bne.w	loc_20B942
			rts
; ---------------------------------------------------------------------------
loc_20B942:								; CODE XREF: ROM:0020B93C↑j
			move.w	#$64,obj.field_2A(a0)
			move.b	#$C,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B950:								; DATA XREF: ROM:0020B832↑o
			move.b	#2,obj.ani(a0)
			moveq	#4,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20B986
			lea	(actwk).w,a1
			move.w	obj.yvel(a1),d0
			addi.w	#$100,d0
			cmpi.w	#$A00,d0
			bmi.w	loc_20B97A
			move.w	#$A00,d0
loc_20B97A:								; CODE XREF: ROM:0020B972↑j
			neg.w	d0
			move.w	d0,obj.yvel(a1)
			move.w	#$64,obj.field_2A(a0)
loc_20B986:								; CODE XREF: ROM:0020B95E↑j
			move.w	obj.field_2A(a0),d0
			subq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			bne.w	loc_20B9A2
			move.b	#4,obj.routine(a0)
			move.b	#4,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B9A2:								; CODE XREF: ROM:0020B990↑j
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20B9B4:								; DATA XREF: ROM:0020B82C↑o
			moveq	#5,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20B9D2
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20B9D2:								; CODE XREF: ROM:0020B9BC↑j
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
			move.b	#2,obj.routine(a0)
			btst	#1,obj.status(a1)
			bne.w	loc_20B9EE
			rts
; ---------------------------------------------------------------------------
loc_20B9EE:								; CODE XREF: ROM:0020B9E8↑j
			move.w	#$64,obj.field_2A(a0)
			move.b	#$A,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B9FC:								; DATA XREF: ROM:0020B830↑o
			move.b	#1,obj.ani(a0)
			moveq	#6,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20BA32
			lea	(actwk).w,a1
			move.w	obj.yvel(a1),d0
			addi.w	#$100,d0
			cmpi.w	#$A00,d0
			bmi.w	loc_20BA26
			move.w	#$A00,d0
loc_20BA26:								; CODE XREF: ROM:0020BA1E↑j
			neg.w	d0
			move.w	d0,obj.yvel(a1)
			move.w	#$64,obj.field_2A(a0)
loc_20BA32:								; CODE XREF: ROM:0020BA0A↑j
			move.w	obj.field_2A(a0),d0
			subq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			bne.w	loc_20BA4E
			move.b	#2,obj.routine(a0)
			move.b	#3,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_20BA4E:								; CODE XREF: ROM:0020BA3C↑j
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
obj27:									; DATA XREF: ROM:00203546↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20BA74(pc,d0.w),d0
			jsr	off_20BA74(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20BA74: dc.w loc_20BA7C-*			; CODE XREF: ROM:0020BA6A↑p
										; DATA XREF: ROM:0020BA66↑r ...
			dc.w loc_20BAA2-off_20BA74
			dc.w loc_20BAE4-off_20BA74
			dc.w loc_20BBA8-off_20BA74
; ---------------------------------------------------------------------------
loc_20BA7C:								; DATA XREF: ROM:off_20BA74↑o
			addq.b	#2,obj.routine(a0)
			move.l	#obj27_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#8,d0
			jsr	sub_20DC4C(pc)
			rts
; ---------------------------------------------------------------------------
loc_20BAA2:								; DATA XREF: ROM:0020BA76↑o
			tst.b	obj.render(a0)
			bpl.w	loc_20BADE
			moveq	#9,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20BAD2
			lea	(actwk).w,a1
			bclr	#1,obj.status(a1)
			bset	#3,obj.status(a1)
			move.b	#4,obj.routine(a0)
			move.w	#0,obj.field_2A(a0)
loc_20BAD2:								; CODE XREF: ROM:0020BAB2↑j
			lea	(obj27_ani).l,a1
			jsr	(animateobj).l
loc_20BADE:								; CODE XREF: ROM:0020BAA6↑j
										; ROM:0020BAE8↓j ...
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20BAE4:								; DATA XREF: ROM:0020BA78↑o
			tst.b	obj.render(a0)
			bpl.s	loc_20BADE
			moveq	#7,d0
			bsr.w	sub_20B684
			tst.b	d1
			bne.w	loc_20BB0C
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
			move.b	#6,obj.routine(a0)
			move.w	#0,obj.field_2A(a0)
loc_20BB0C:								; CODE XREF: ROM:0020BAF2↑j
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d2
			move.w	obj.xpos(a1),d3
			move.w	obj.xvel(a1),d4
			beq.w	loc_20BB3C
			bmi.w	loc_20BB28
			bpl.w	loc_20BB32
loc_20BB28:								; CODE XREF: ROM:0020BB20↑j
			cmp.w	d2,d3
			bpl.w	loc_20BB4A
			bra.w	loc_20BB3C
; ---------------------------------------------------------------------------
loc_20BB32:								; CODE XREF: ROM:0020BB24↑j
			cmp.w	d2,d3
			bmi.w	loc_20BB4A
			bra.w	loc_20BB3C
; ---------------------------------------------------------------------------
loc_20BB3C:								; CODE XREF: ROM:0020BB1C↑j
										; ROM:0020BB2E↑j ...
			move.l	obj.ypos(a1),d0
			addi.l	#$8000,d0
			move.l	d0,obj.ypos(a1)
loc_20BB4A:								; CODE XREF: ROM:0020BB2A↑j
										; ROM:0020BB34↑j
			moveq	#0,d0
			move.w	obj.field_2A(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			lea	(loc_20BC80).l,a3
			lea	(unk_20BC1E).l,a2
			move.w	obj.xpos(a0),d2
			move.w	obj.xpos(a1),d3
			cmp.w	d2,d3
			bmi.w	loc_20BB7C
			lea	(unk_20BC34).l,a2
			lea	(loc_20BC80).l,a3
loc_20BB7C:								; CODE XREF: ROM:0020BB6C↑j
			divu.w	#2,d0
			move.b	(a2,d0.w),d1
			move.b	d1,obj.ani(a0)
			cmpi.b	#6,d1
			bne.w	loc_20BB96
			bclr	#3,obj.status(a1)
loc_20BB96:								; CODE XREF: ROM:0020BB8C↑j
			lea	(obj27_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20BBA8:								; DATA XREF: ROM:0020BA7A↑o
			tst.b	obj.render(a0)
			bne.w	loc_20BADE
			moveq	#9,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20BBD8
			lea	(actwk).w,a1
			bclr	#1,obj.status(a1)
			bset	#3,obj.status(a1)
			move.b	#4,obj.routine(a0)
			move.w	#0,obj.field_2A(a0)
loc_20BBD8:								; CODE XREF: ROM:0020BBB8↑j
			lea	(unk_20BC4A).l,a2
			move.w	obj.field_2A(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			move.b	(a2,d0.w),d1
			bmi.w	loc_20BC06
			move.b	d1,obj.ani(a0)
			lea	(obj27_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20BC06:								; CODE XREF: ROM:0020BBEC↑j
			move.b	#2,obj.routine(a0)
			lea	(obj27_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
unk_20BC1E: dc.b   1					; DATA XREF: ROM:0020BB5C↑o
			dc.b   1
			dc.b   2
			dc.b   2
			dc.b   3
			dc.b   3
			dc.b   4
			dc.b   4
			dc.b   5
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
unk_20BC34: dc.b   7					; DATA XREF: ROM:0020BB70↑o
			dc.b   7
			dc.b   8
			dc.b   8
			dc.b   9
			dc.b   9
			dc.b  $A
			dc.b  $A
			dc.b  $B
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   0
unk_20BC4A: dc.b   0					; DATA XREF: ROM:loc_20BBD8↑o
			dc.b   5
			dc.b   4
			dc.b   3
			dc.b   2
			dc.b   1
			dc.b   0
			dc.b  $D
			dc.b   7
			dc.b   8
			dc.b   9
			dc.b  $A
			dc.b  $B
			dc.b  $A
			dc.b   9
			dc.b   8
			dc.b   7
			dc.b  $D
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b   3
			dc.b   2
			dc.b   1
			dc.b  $D
			dc.b   7
			dc.b   8
			dc.b   9
			dc.b  $A
			dc.b   9
			dc.b   8
			dc.b   7
			dc.b  $D
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   2
			dc.b   1
			dc.b  $D
			dc.b   7
			dc.b   8
			dc.b   7
			dc.b  $D
			dc.b   1
			dc.b   2
			dc.b   1
			dc.b  $D
			dc.b   7
			dc.b  $D
			dc.b   1
			dc.b  $D
			dc.b $FF
			even
; ---------------------------------------------------------------------------
loc_20BC80:								; DATA XREF: ROM:0020BB56↑o
										; ROM:0020BB76↑o
			move.w	obj.xpos(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bcs.s	locret_20BCA2
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
locret_20BCA2:							; CODE XREF: ROM:0020BC9A↑j
			rts
; ---------------------------------------------------------------------------
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20BCB2(pc,d0.w),d0
			jmp	off_20BCB2(pc,d0.w)
; ---------------------------------------------------------------------------
off_20BCB2: dc.w loc_20BCD4-*			; CODE XREF: ROM:0020BCAE↑j
										; DATA XREF: ROM:0020BCAA↑r ...
			dc.w sub_20BDC6-off_20BCB2
			dc.w loc_20BE6A-off_20BCB2
			dc.w loc_20BED8-off_20BCB2
			dc.w loc_20C14C-off_20BCB2
			dc.w loc_20C18C-off_20BCB2
			dc.w loc_20C0FE-off_20BCB2
			dc.w loc_20C2A2-off_20BCB2
			dc.w loc_20C346-off_20BCB2
			dc.w loc_20C3B0-off_20BCB2
			dc.w loc_20C278-off_20BCB2
			dc.w loc_20C212-off_20BCB2
			dc.w loc_20C19E-off_20BCB2
			dc.w loc_20C40A-off_20BCB2
			dc.w locret_20C5FC-off_20BCB2
			dc.w loc_20C5E8-off_20BCB2
			dc.w loc_20C5D4-off_20BCB2
; ---------------------------------------------------------------------------
loc_20BCD4:								; DATA XREF: ROM:off_20BCB2↑o
			move.b	#$C,obj.routine(a0)
			move.l	#off_20CEE2,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#9,d0
			jsr	sub_20DC4C(pc)
			move.b	#1,obj.ani(a0)
			move.b	#0,obj.field_30(a0)
			move.b	#0,obj.field_31(a0)
			moveq	#0,d7
loc_20BD0E:								; CODE XREF: ROM:0020BD32↓j
			jsr	(findfreeobj).l
			bne.w	loc_20BDB6
			move.b	#$25,obj.id(a1)
			move.b	#2,obj.routine(a1)
			move.w	a0,obj.field_3E(a1)
			move.b	d7,obj.field_3C(a1)
			addq.w	#1,d7
			cmpi.w	#8,d7
			bne.s	loc_20BD0E
			jsr	(findfreeobj).l
			bne.w	loc_20BDB6
			move.b	#$25,obj.id(a1)
			move.b	#4,obj.routine(a1)
			move.w	a0,obj.field_3E(a1)
			move.b	#$FF,obj.field_3C(a1)
			move.b	#2,obj.ani(a1)
			move.l	obj.xpos(a0),d0
			subi.l	#$100000,d0
			move.l	d0,obj.xpos(a1)
			move.l	obj.ypos(a0),d0
			subi.l	#$100000,d0
			move.l	d0,obj.ypos(a1)
			bsr.w	findfreeobj
			bne.w	loc_20BDB6
			move.b	#$25,obj.id(a1)
			move.b	#4,obj.routine(a1)
			move.w	a0,obj.field_3E(a1)
			move.b	#$FE,obj.field_3C(a1)
			move.b	#2,obj.ani(a1)
			move.l	obj.xpos(a0),d0
			addi.l	#$800000,d0
			move.l	d0,obj.xpos(a1)
			move.l	obj.ypos(a0),d0
			subi.l	#$100000,d0
			move.l	d0,obj.ypos(a1)
loc_20BDB6:								; CODE XREF: ROM:0020BD14↑j
										; ROM:0020BD3A↑j ...
			tst.b	obj.field_28(a0)
			beq.w	locret_20BDC4
			move.b	#$1C,obj.routine(a0)
locret_20BDC4:							; CODE XREF: ROM:0020BDBA↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_20BDC6:								; DATA XREF: ROM:0020BCB4↑o
			move.b	#6,obj.routine(a0)
			move.l	#off_20CEE2,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#9,d0
			jsr	sub_20DC4C(pc)
			move.b	#1,obj.ani(a0)
			movea.w obj.field_3E(a0),a2
			tst.b	obj.field_28(a2)
			beq.w	loc_20BE04
			move.b	#$1A,obj.routine(a0)
loc_20BE04:								; CODE XREF: sub_20BDC6+34↑j
			movea.w obj.field_3E(a0),a1
			moveq	#0,d1
			move.b	obj.field_3C(a0),d1
			mulu.w	#$10,d1
			swap	d1
			move.l	obj.xpos(a1),d0
			add.l	d1,d0
			move.l	d0,obj.xpos(a0)
			move.l	obj.ypos(a1),d0
			move.l	d0,obj.ypos(a0)
			swap	d0
			move.w	d0,obj.field_38(a0)
			move.w	d0,obj.field_34(a0)
			moveq	#0,d1
			move.b	obj.field_3C(a0),d1
			mulu.w	#8,d1
			sub.w	d1,d0
			addi.w	#$60,d0
			move.w	d0,obj.field_36(a0)
			movea.w obj.field_3E(a0),a2
			moveq	#0,d1
			move.w	obj.xpos(a2),d0
			move.w	obj.xpos(a0),d1
			move.w	#$58,d2
			sub.w	d0,d1
			sub.w	d2,d1
			muls.w	d1,d1
			mulu.w	#10,d1
			muls.w	d2,d2
			divu.w	d2,d1
			move.w	d1,obj.field_3A(a0)
			rts
; End of function sub_20BDC6
; ---------------------------------------------------------------------------
loc_20BE6A:								; DATA XREF: ROM:0020BCB6↑o
			move.b	#8,obj.routine(a0)
			move.l	#off_20CEE2,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#9,d0
			jsr	sub_20DC4C(pc)
			movea.w obj.field_3E(a0),a2
			tst.b	obj.field_28(a2)
			beq.w	loc_20BEC0
			move.b	#$1E,obj.routine(a0)
			move.b	obj.field_3C(a0),d0
			cmpi.b	#$FE,d0
			beq.w	loc_20BEC0
			move.w	obj.ypos(a0),d1
			addi.w	#$70,d1
			move.w	d1,obj.ypos(a0)
			ori.w	#$800,obj.vram(a0)
loc_20BEC0:								; CODE XREF: ROM:0020BE98↑j
										; ROM:0020BEAA↑j
			move.w	obj.ypos(a0),d0
			move.w	d0,obj.field_38(a0)
			move.w	d0,obj.field_34(a0)
			moveq	#0,d1
			addi.w	#$60,d0
			move.w	d0,obj.field_36(a0)
			rts
; ---------------------------------------------------------------------------
loc_20BED8:								; DATA XREF: ROM:0020BCB8↑o
			movea.w obj.field_3E(a0),a2
			move.b	obj.routine(a2),d0
			cmpi.b	#$18,d0
			bne.w	loc_20BEEE
			move.b	#$E,obj.routine(a0)
loc_20BEEE:								; CODE XREF: ROM:0020BEE4↑j
			moveq	#$13,d0
			bsr.w	loc_20B6EC
			tst.b	d1
			beq.w	loc_20BF42
			moveq	#$B,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20BF42
			movea.w obj.field_3E(a0),a2
			move.b	obj.field_3C(a0),d0
			addq.w	#1,d0
			move.b	d0,obj.field_31(a2)
			lea	(actwk).w,a1
			bset	#3,obj.status(a1)
			bset	#3,obj.status(a0)
			bclr	#1,obj.status(a1)
			move.l	obj.ypos(a0),d0
			subi.l	#$80000,d0
			moveq	#0,d1
			move.b	obj.field_16(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
loc_20BF42:								; CODE XREF: ROM:0020BEF6↑j
										; ROM:0020BF02↑j
			bsr.w	sub_20C042
			bsr.w	sub_20BFCE
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
			moveq	#0,d2
			movea.w obj.field_3E(a0),a2
			move.b	obj.field_3D(a2),d2
			lea	(unk_20BF8E).l,a3
			andi.w	#$3F,d2
			move.b	(a3,d2.w),d2
			move.w	obj.field_38(a0),d0
			move.w	obj.field_3A(a0),d1
			muls.w	d2,d1
			divs.w	#10,d1
			sub.w	d2,d1
			sub.w	d1,d0
			move.w	d0,obj.ypos(a0)
			rts
; ---------------------------------------------------------------------------
unk_20BF8E: dc.b   0					; DATA XREF: ROM:0020BF68↑o
			dc.b   0
			dc.b   1
			dc.b   1
			dc.b   2
			dc.b   2
			dc.b   3
			dc.b   3
			dc.b   4
			dc.b   4
			dc.b   5
			dc.b   5
			dc.b   6
			dc.b   6
			dc.b   7
			dc.b   7
			dc.b   8
			dc.b   8
			dc.b   7
			dc.b   7
			dc.b   6
			dc.b   6
			dc.b   5
			dc.b   5
			dc.b   4
			dc.b   4
			dc.b   3
			dc.b   3
			dc.b   2
			dc.b   2
			dc.b   1
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b   5
			dc.b   6
			dc.b   7
			dc.b   8
			dc.b   9
			dc.b  $A
			dc.b  $B
			dc.b  $C
			dc.b  $D
			dc.b  $E
			dc.b  $F
			dc.b $10
			dc.b  $F
			dc.b  $E
			dc.b  $D
			dc.b  $C
			dc.b  $B
			dc.b  $A
			dc.b   9
			dc.b   8
			dc.b   7
			dc.b   6
			dc.b   5
			dc.b   4
			dc.b   3
			dc.b   2
			dc.b   1
			even

; =============== S U B R O U T I N E =======================================
sub_20BFCE:								; CODE XREF: ROM:0020BF46↑p
										; ROM:0020C398↓p
			lea	(actwk).w,a1
			lea	(unk_20C04E).l,a3
			movea.w obj.field_3E(a0),a2
			move.w	obj.xpos(a2),d0
			subi.w	#$10,d0
			move.w	obj.xpos(a1),d1
			sub.w	d0,d1
			move.b	obj.field_30(a2),d0
			bne.w	loc_20C014
			bra.w	loc_20C038
; ---------------------------------------------------------------------------
			move.w	obj.xpos(a2),d0
			subi.w	#$10,d0
			move.w	obj.xpos(a1),d1
			sub.w	d0,d1
			bpl.w	loc_20C00A
			moveq	#0,d1
loc_20C00A:								; CODE XREF: sub_20BFCE+36↑j
			cmpi.w	#$C0,d1
			bmi.w	loc_20C014
			moveq	#0,d1
loc_20C014:								; CODE XREF: sub_20BFCE+20↑j
										; sub_20BFCE+40↑j
			asr.w	#3,d1
			mulu.w	#8,d1
			lea	(a3,d1.w),a3
			moveq	#0,d0
			move.b	obj.field_3C(a0),d0
			moveq	#0,d2
			move.b	(a3,d0.w),d2
			asr.b	#1,d2
			move.w	obj.field_38(a0),d3
			add.w	d2,d3
			move.w	d3,obj.ypos(a0)
			rts
; ---------------------------------------------------------------------------
loc_20C038:								; CODE XREF: sub_20BFCE+24↑j
			move.w	obj.field_38(a0),d3
			move.w	d3,obj.ypos(a0)
			rts
; End of function sub_20BFCE
; =============== S U B R O U T I N E =======================================
sub_20C042:								; CODE XREF: ROM:loc_20BF42↑p
										; ROM:loc_20C32E↓p ...
			btst	#0,(byte_FFF7DC).w
			beq.w	locret_20C04C
locret_20C04C:							; CODE XREF: sub_20C042+6↑j
			rts
; End of function sub_20C042
; ---------------------------------------------------------------------------
unk_20C04E: dc.b   0					; DATA XREF: sub_20BFCE+4↑o
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   6
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   6
			dc.b   6
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   6
			dc.b   8
			dc.b   6
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   6
			dc.b   8
			dc.b   8
			dc.b   6
			dc.b   4
			dc.b   2
			dc.b   2
			dc.b   4
			dc.b   6
			dc.b   8
			dc.b   8
			dc.b   6
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   6
			dc.b   8
			dc.b   6
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   6
			dc.b   6
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   6
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   4
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			even
; ---------------------------------------------------------------------------
loc_20C0FE:								; DATA XREF: ROM:0020BCBE↑o
			move.b	obj.field_31(a0),obj.field_30(a0)
			move.b	#0,obj.field_31(a0)
			btst	#0,(byte_FFF7DC).w
			beq.w	loc_20C11A
			move.b	#$18,obj.routine(a0)
loc_20C11A:								; CODE XREF: ROM:0020C110↑j
			move.b	obj.field_3D(a0),d0
			addq.w	#1,d0
			move.b	d0,obj.field_3D(a0)
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d0
			move.w	obj.xpos(a1),d1
			move.w	d0,d2
			addi.w	#$80,d2
			subi.w	#$10,d0
			cmp.w	d0,d1
			bmi.w	locret_20C14A
			cmp.w	d2,d1
			bpl.w	locret_20C14A
			bra.w	locret_20C14A
; ---------------------------------------------------------------------------
locret_20C14A:							; CODE XREF: ROM:0020C13C↑j
										; ROM:0020C142↑j ...
			rts
; ---------------------------------------------------------------------------
loc_20C14C:								; DATA XREF: ROM:0020BCBA↑o
			movea.w obj.field_3E(a0),a2
			move.b	obj.routine(a2),d0
			cmpi.b	#$18,d0
			bne.w	loc_20C162
			move.b	#$16,obj.routine(a0)
loc_20C162:								; CODE XREF: ROM:0020C158↑j
			moveq	#$F,d0
			bsr.w	loc_20B6EC
			tst.b	d1
			beq.w	loc_20C178
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
loc_20C178:								; CODE XREF: ROM:0020C16A↑j
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C18C:								; DATA XREF: ROM:0020BCBC↑o
			lea	(obj26_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20C19E:								; DATA XREF: ROM:0020BCCA↑o
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$64,d0
			bne.w	loc_20C1B8
			nop
			move.b	#$12,obj.routine(a0)
loc_20C1B8:								; CODE XREF: ROM:0020C1AC↑j
			move.b	obj.field_3D(a0),d0
			addq.w	#1,d0
			move.b	d0,obj.field_3D(a0)
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d0
			move.w	obj.xpos(a1),d1
			move.w	d0,d2
			addi.w	#$C0,d2
			subi.w	#$10,d0
			cmp.w	d0,d1
			bmi.w	loc_20C1FA
			cmp.w	d2,d1
			bpl.w	loc_20C1FA
			bset	#3,obj.status(a1)
			bset	#3,obj.status(a0)
			move.b	#0,obj.angle(a1)
			bra.w	locret_20C210
; ---------------------------------------------------------------------------
loc_20C1FA:								; CODE XREF: ROM:0020C1DA↑j
										; ROM:0020C1E0↑j
			btst	#3,obj.status(a0)
			beq.w	locret_20C14A
			bclr	#3,obj.status(a1)
			bclr	#3,obj.status(a0)
locret_20C210:							; CODE XREF: ROM:0020C1F6↑j
			rts
; ---------------------------------------------------------------------------
loc_20C212:								; DATA XREF: ROM:0020BCC8↑o
			movea.w obj.field_3E(a0),a2
			move.b	obj.routine(a2),d0
			cmpi.b	#$18,d0
			beq.w	loc_20C228
			move.b	#$14,obj.routine(a0)
loc_20C228:								; CODE XREF: ROM:0020C21E↑j
			move.b	obj.field_3C(a0),d0
			cmpi.b	#$FE,d0
			beq.w	loc_20C24E
			move.w	obj.field_32(a2),d0
			move.w	#$64,d1
			move.w	#$60,d2
			mulu.w	d2,d0
			divu.w	d1,d0
			move.w	obj.field_34(a0),d1
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
loc_20C24E:								; CODE XREF: ROM:0020C230↑j
			moveq	#$F,d0
			bsr.w	loc_20B6EC
			tst.b	d1
			beq.w	loc_20C264
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
loc_20C264:								; CODE XREF: ROM:0020C256↑j
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C278:								; DATA XREF: ROM:0020BCC6↑o
			moveq	#$F,d0
			bsr.w	loc_20B6EC
			tst.b	d1
			beq.w	loc_20C28E
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
loc_20C28E:								; CODE XREF: ROM:0020C280↑j
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C2A2:								; DATA XREF: ROM:0020BCC0↑o
			movea.w obj.field_3E(a0),a2
			move.b	obj.routine(a2),d0
			cmpi.b	#$18,d0
			beq.w	loc_20C2C2
			move.b	#$10,obj.routine(a0)
			move.w	obj.field_36(a0),obj.field_38(a0)
			bra.w	loc_20C32E
; ---------------------------------------------------------------------------
loc_20C2C2:								; CODE XREF: ROM:0020C2AE↑j
			move.w	obj.field_36(a0),d2
			move.w	obj.field_34(a0),d3
			sub.w	d3,d2
			move.w	obj.field_32(a2),d0
			move.w	#$64,d1
			mulu.w	d2,d0
			divu.w	d1,d0
			move.w	obj.field_34(a0),d1
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
			move.w	obj.field_32(a2),d1
			add.b	obj.field_3C(a0),d1
			andi.w	#1,d1
			add.w	d1,d0
			move.w	d0,obj.ypos(a0)
			moveq	#$B,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20C32E
			lea	(actwk).w,a1
			bset	#3,obj.status(a1)
			bset	#3,obj.status(a0)
			bclr	#1,obj.status(a1)
			move.l	obj.ypos(a0),d0
			subi.l	#$80000,d0
			moveq	#0,d1
			move.b	obj.field_16(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
loc_20C32E:								; CODE XREF: ROM:0020C2BE↑j
										; ROM:0020C2FC↑j
			bsr.w	sub_20C042
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C346:								; DATA XREF: ROM:0020BCC2↑o
			btst	#1,(byte_FFF7DC).w
			beq.w	loc_20C35A
			move.b	obj.field_3C(a0),d0
			move.b	#$1A,obj.routine(a0)
loc_20C35A:								; CODE XREF: ROM:0020C34C↑j
			moveq	#$B,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20C394
			lea	(actwk).w,a1
			bset	#3,obj.status(a1)
			bset	#3,obj.status(a0)
			bclr	#1,obj.status(a1)
			move.l	obj.ypos(a0),d0
			subi.l	#$80000,d0
			moveq	#0,d1
			move.b	obj.field_16(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
loc_20C394:								; CODE XREF: ROM:0020C362↑j
			bsr.w	sub_20C042
			bsr.w	sub_20BFCE
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C3B0:								; DATA XREF: ROM:0020BCC4↑o
			move.b	obj.field_3D(a0),d0
			addq.w	#1,d0
			move.b	d0,obj.field_3D(a0)
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d0
			move.w	obj.xpos(a1),d1
			move.w	d0,d2
			addi.w	#$C0,d2
			subi.w	#$10,d0
			cmp.w	d0,d1
			bmi.w	locret_20C14A
			cmp.w	d2,d1
			bpl.w	loc_20C3F2
			bset	#3,obj.status(a1)
			bset	#3,obj.status(a0)
			move.b	#0,obj.angle(a1)
			bra.w	locret_20C408
; ---------------------------------------------------------------------------
loc_20C3F2:								; CODE XREF: ROM:0020C3D8↑j
			btst	#3,obj.status(a0)
			beq.w	locret_20C14A
			bclr	#3,obj.status(a1)
			bclr	#3,obj.status(a0)
locret_20C408:							; CODE XREF: ROM:0020C3EE↑j
			rts
; ---------------------------------------------------------------------------
loc_20C40A:								; DATA XREF: ROM:0020BCCC↑o
			bsr.w	sub_20C45C
			moveq	#$B,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20C448
			lea	(actwk).w,a1
			bset	#3,obj.status(a1)
			bset	#3,obj.status(a0)
			bclr	#1,obj.status(a1)
			move.l	obj.ypos(a0),d0
			subi.l	#$80000,d0
			moveq	#0,d1
			move.b	obj.field_16(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
loc_20C448:								; CODE XREF: ROM:0020C416↑j
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; =============== S U B R O U T I N E =======================================
sub_20C45C:								; CODE XREF: ROM:loc_20C40A↑p
; FUNCTION CHUNK AT 0020C4FC SIZE 00000064 BYTES
; FUNCTION CHUNK AT 0020C582 SIZE 00000052 BYTES
			move.b	obj.field_3C(a0),d0
			cmpi.b	#7,d0
			bpl.w	loc_20C4FC
			cmpi.b	#5,d0
			bpl.w	loc_20C582
			bra.w	loc_20C478
; ---------------------------------------------------------------------------
			dc.b $12
			dc.b $34 ; 4
			dc.b $56 ; V
			dc.b $78 ; x
; ---------------------------------------------------------------------------
loc_20C478:								; CODE XREF: sub_20C45C+14↑j
			movea.w obj.field_3E(a0),a2
			lea	(unk_20C5FE).l,a3
			move.w	obj.field_32(a0),d0
			moveq	#0,d1
			move.b	obj.field_3C(a0),d1
			move.w	#$E,d2
			asl.w	#1,d1
			lsr.w	#1,d0
			mulu.w	d0,d2
			add.w	d1,d2
			moveq	#0,d6
			moveq	#0,d3
			move.b	(a3,d2.w),d6
			move.b	1(a3,d2.w),d3
			ext.w	d3
			move.w	obj.xpos(a2),d4
			move.w	obj.ypos(a2),d5
			add.w	d6,d4
			add.w	d3,d5
			addi.w	#$60,d5
			move.w	d4,obj.xpos(a0)
			move.w	d5,obj.ypos(a0)
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$26,d0
			bne.w	locret_20C4DA
			move.b	#$20,obj.routine(a0)
			bsr.w	sub_20C4DC
locret_20C4DA:							; CODE XREF: sub_20C45C+70↑j
			rts
; End of function sub_20C45C
; =============== S U B R O U T I N E =======================================
sub_20C4DC:								; CODE XREF: sub_20C45C+7A↑p
			move.b	obj.field_3C(a0),d0
			move.w	obj.ypos(a2),d1
			move.w	obj.xpos(a2),d2
			mulu.w	#$10,d0
			add.w	d0,d1
			addi.w	#$60,d1
			move.w	d1,obj.ypos(a0)
			move.w	d2,obj.xpos(a0)
			rts
; End of function sub_20C4DC
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_20C45C
loc_20C4FC:								; CODE XREF: sub_20C45C+8↑j
			movea.w obj.field_3E(a0),a2
			lea	(unk_20C708).l,a3
			move.w	obj.field_32(a0),d0
			moveq	#0,d1
			move.b	obj.field_3C(a0),d1
			move.w	#$E,d2
			subq.b	#6,d1
			asl.w	#1,d1
			lsr.w	#1,d0
			mulu.w	d0,d2
			add.w	d1,d2
			moveq	#0,d6
			moveq	#0,d3
			move.b	(a3,d2.w),d6
			move.b	1(a3,d2.w),d3
			move.w	obj.xpos(a2),d4
			move.w	obj.ypos(a2),d5
			sub.w	d6,d4
			add.w	d3,d5
			addi.w	#$B0,d4
			move.w	d4,obj.xpos(a0)
			move.w	d5,obj.ypos(a0)
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$26,d0
			bne.w	locret_20C55E
			move.b	#$20,obj.routine(a0)
			bsr.w	sub_20C560
locret_20C55E:							; CODE XREF: sub_20C45C+F4↑j
			rts
; END OF FUNCTION CHUNK FOR sub_20C45C
; =============== S U B R O U T I N E =======================================
sub_20C560:								; CODE XREF: sub_20C45C+FE↑p
										; sub_20C45C+174↓p
			move.b	obj.field_3C(a0),d0
			move.w	obj.ypos(a2),d1
			move.w	obj.xpos(a2),d2
			subq.w	#6,d0
			mulu.w	#$10,d0
			add.w	d0,d1
			addi.w	#$B0,d2
			move.w	d1,obj.ypos(a0)
			move.w	d2,obj.xpos(a0)
			rts
; End of function sub_20C560
; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR sub_20C45C
loc_20C582:								; CODE XREF: sub_20C45C+10↑j
			movea.w obj.field_3E(a0),a2
			move.w	obj.field_32(a0),d0
			mulu.w	#$C,d0
			move.w	obj.ypos(a2),d1
			add.w	d0,d1
			addi.w	#$28,d1
			move.w	d1,obj.ypos(a0)
			move.w	obj.field_32(a0),d0
			move.w	obj.xpos(a0),d1
			move.b	obj.field_3C(a0),d2
			cmpi.b	#6,d2
			beq.w	loc_20C5B2
			neg.w	d0
loc_20C5B2:								; CODE XREF: sub_20C45C+150↑j
			add.w	d0,d1
			move.w	d1,obj.xpos(a0)
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$26,d0
			bne.w	locret_20C5D2
			move.b	#$20,obj.routine(a0)
			bsr.s	sub_20C560
locret_20C5D2:							; CODE XREF: sub_20C45C+16A↑j
			rts
; END OF FUNCTION CHUNK FOR sub_20C45C
; ---------------------------------------------------------------------------
loc_20C5D4:								; DATA XREF: ROM:0020BCD2↑o
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C5E8:								; DATA XREF: ROM:0020BCD0↑o
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
locret_20C5FC:							; DATA XREF: ROM:0020BCCE↑o
			rts
; ---------------------------------------------------------------------------
unk_20C5FE: dc.b   0					; DATA XREF: sub_20C45C+20↑o
			dc.b   0
			dc.b  $F
			dc.b $F8
			dc.b $1F
			dc.b $F0
			dc.b $2F ; /
			dc.b $E8
			dc.b $3F ; ?
			dc.b $E0
			dc.b $4F ; O
			dc.b $D8
			dc.b $5F ; _
			dc.b $D0
			dc.b   0
			dc.b   0
			dc.b $11
			dc.b $FC
			dc.b $23 ; #
			dc.b $F8
			dc.b $34 ; 4
			dc.b $F5
			dc.b $46 ; F
			dc.b $F1
			dc.b $57 ; W
			dc.b $EE
			dc.b $69 ; i
			dc.b $EA
			dc.b   0
			dc.b   0
			dc.b $11
			dc.b   0
			dc.b $23 ; #
			dc.b $FF
			dc.b $35 ; 5
			dc.b $FE
			dc.b $47 ; G
			dc.b $FD
			dc.b $59 ; Y
			dc.b $FC
			dc.b $6B ; k
			dc.b $FB
			dc.b   0
			dc.b   0
			dc.b $11
			dc.b   5
			dc.b $22 ; "
			dc.b  $A
			dc.b $33 ; 3
			dc.b  $F
			dc.b $44 ; D
			dc.b $14
			dc.b $55 ; U
			dc.b $19
			dc.b $66 ; f
			dc.b $1E
			dc.b   0
			dc.b   0
			dc.b  $F
			dc.b   8
			dc.b $1F
			dc.b $11
			dc.b $2E ; .
			dc.b $1A
			dc.b $3E ; >
			dc.b $22 ; "
			dc.b $4E ; N
			dc.b $2B ; +
			dc.b $5D ; ]
			dc.b $34 ; 4
			dc.b   0
			dc.b   0
			dc.b  $D
			dc.b  $B
			dc.b $1B
			dc.b $16
			dc.b $29 ; )
			dc.b $22 ; "
			dc.b $37 ; 7
			dc.b $2D ; -
			dc.b $44 ; D
			dc.b $39 ; 9
			dc.b $52 ; R
			dc.b $44 ; D
			dc.b   0
			dc.b   0
			dc.b  $B
			dc.b  $D
			dc.b $17
			dc.b $1A
			dc.b $23 ; #
			dc.b $28 ; (
			dc.b $2F ; /
			dc.b $35 ; 5
			dc.b $3B ; ;
			dc.b $43 ; C
			dc.b $46 ; F
			dc.b $50 ; P
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b  $E
			dc.b $13
			dc.b $1D
			dc.b $1D
			dc.b $2C ; ,
			dc.b $27 ; '
			dc.b $3B ; ;
			dc.b $31 ; 1
			dc.b $4A ; J
			dc.b $3B ; ;
			dc.b $59 ; Y
			dc.b   0
			dc.b   0
			dc.b   8
			dc.b  $F
			dc.b $10
			dc.b $1F
			dc.b $18
			dc.b $2F ; /
			dc.b $21 ; !
			dc.b $3F ; ?
			dc.b $29 ; )
			dc.b $4F ; O
			dc.b $31 ; 1
			dc.b $5F ; _
			dc.b   0
			dc.b   0
			dc.b   6
			dc.b $10
			dc.b  $D
			dc.b $21 ; !
			dc.b $14
			dc.b $31 ; 1
			dc.b $1B
			dc.b $42 ; B
			dc.b $21 ; !
			dc.b $52 ; R
			dc.b $28 ; (
			dc.b $63 ; c
			dc.b   0
			dc.b   0
			dc.b   5
			dc.b $11
			dc.b  $B
			dc.b $22 ; "
			dc.b $10
			dc.b $33 ; 3
			dc.b $16
			dc.b $44 ; D
			dc.b $1B
			dc.b $55 ; U
			dc.b $21 ; !
			dc.b $66 ; f
			dc.b   0
			dc.b   0
			dc.b   4
			dc.b $11
			dc.b   8
			dc.b $22 ; "
			dc.b  $D
			dc.b $33 ; 3
			dc.b $11
			dc.b $45 ; E
			dc.b $16
			dc.b $56 ; V
			dc.b $1A
			dc.b $67 ; g
			dc.b   0
			dc.b   0
			dc.b   3
			dc.b $11
			dc.b   7
			dc.b $23 ; #
			dc.b  $A
			dc.b $34 ; 4
			dc.b  $E
			dc.b $46 ; F
			dc.b $12
			dc.b $57 ; W
			dc.b $15
			dc.b $69 ; i
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b $11
			dc.b   5
			dc.b $23 ; #
			dc.b   8
			dc.b $34 ; 4
			dc.b  $B
			dc.b $46 ; F
			dc.b  $E
			dc.b $58 ; X
			dc.b $11
			dc.b $69 ; i
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b $11
			dc.b   4
			dc.b $23 ; #
			dc.b   6
			dc.b $35 ; 5
			dc.b   8
			dc.b $46 ; F
			dc.b  $B
			dc.b $58 ; X
			dc.b  $D
			dc.b $6A ; j
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b $11
			dc.b   3
			dc.b $23 ; #
			dc.b   5
			dc.b $35 ; 5
			dc.b   6
			dc.b $47 ; G
			dc.b   8
			dc.b $59 ; Y
			dc.b  $A
			dc.b $6A ; j
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b $11
			dc.b   2
			dc.b $23 ; #
			dc.b   3
			dc.b $35 ; 5
			dc.b   5
			dc.b $47 ; G
			dc.b   6
			dc.b $59 ; Y
			dc.b   7
			dc.b $6B ; k
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $11
			dc.b   1
			dc.b $23 ; #
			dc.b   2
			dc.b $35 ; 5
			dc.b   3
			dc.b $47 ; G
			dc.b   4
			dc.b $59 ; Y
			dc.b   5
			dc.b $6B ; k
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $11
			dc.b   1
			dc.b $23 ; #
			dc.b   1
			dc.b $35 ; 5
			dc.b   2
			dc.b $47 ; G
			dc.b   3
			dc.b $59 ; Y
			dc.b   3
			dc.b $6B ; k
unk_20C708: dc.b   0					; DATA XREF: sub_20C45C+A4↑o
			dc.b   0
			dc.b  $F
			dc.b   7
			dc.b $1F
			dc.b  $F
			dc.b $2F ; /
			dc.b $17
			dc.b $3F ; ?
			dc.b $1F
			dc.b $4F ; O
			dc.b $27 ; '
			dc.b $5F ; _
			dc.b $2F ; /
			dc.b   0
			dc.b   0
			dc.b  $E
			dc.b   9
			dc.b $1D
			dc.b $13
			dc.b $2C ; ,
			dc.b $1D
			dc.b $3B ; ;
			dc.b $27 ; '
			dc.b $4A ; J
			dc.b $31 ; 1
			dc.b $59 ; Y
			dc.b $3B ; ;
			dc.b   0
			dc.b   0
			dc.b  $D
			dc.b  $B
			dc.b $1B
			dc.b $17
			dc.b $28 ; (
			dc.b $22 ; "
			dc.b $36 ; 6
			dc.b $2E ; .
			dc.b $44 ; D
			dc.b $3A ; :
			dc.b $51 ; Q
			dc.b $45 ; E
			dc.b   0
			dc.b   0
			dc.b  $C
			dc.b  $D
			dc.b $18
			dc.b $1A
			dc.b $24 ; $
			dc.b $27 ; '
			dc.b $30 ; 0
			dc.b $34 ; 4
			dc.b $3C ; <
			dc.b $41 ; A
			dc.b $49 ; I
			dc.b $4E ; N
			dc.b   0
			dc.b   0
			dc.b  $A
			dc.b  $E
			dc.b $15
			dc.b $1C
			dc.b $20
			dc.b $2B ; +
			dc.b $2A ; *
			dc.b $39 ; 9
			dc.b $35 ; 5
			dc.b $47 ; G
			dc.b $40 ; @
			dc.b $56 ; V
			dc.b   0
			dc.b   0
			dc.b   9
			dc.b  $F
			dc.b $12
			dc.b $1E
			dc.b $1B
			dc.b $2E ; .
			dc.b $24 ; $
			dc.b $3D ; =
			dc.b $2D ; -
			dc.b $4C ; L
			dc.b $37 ; 7
			dc.b $5C ; \
			dc.b   0
			dc.b   0
			dc.b   7
			dc.b $10
			dc.b  $F
			dc.b $20
			dc.b $17
			dc.b $30 ; 0
			dc.b $1F
			dc.b $40 ; @
			dc.b $26 ; &
			dc.b $50 ; P
			dc.b $2E ; .
			dc.b $60 ; `
			dc.b   0
			dc.b   0
			dc.b   6
			dc.b $10
			dc.b  $C
			dc.b $21 ; !
			dc.b $13
			dc.b $31 ; 1
			dc.b $19
			dc.b $42 ; B
			dc.b $20
			dc.b $53 ; S
			dc.b $26 ; &
			dc.b $63 ; c
			dc.b   0
			dc.b   0
			dc.b   5
			dc.b $11
			dc.b  $A
			dc.b $22 ; "
			dc.b $10
			dc.b $33 ; 3
			dc.b $15
			dc.b $44 ; D
			dc.b $1A
			dc.b $55 ; U
			dc.b $20
			dc.b $66 ; f
			dc.b   0
			dc.b   0
			dc.b   4
			dc.b $11
			dc.b   8
			dc.b $22 ; "
			dc.b  $D
			dc.b $34 ; 4
			dc.b $11
			dc.b $45 ; E
			dc.b $15
			dc.b $56 ; V
			dc.b $1A
			dc.b $68 ; h
			dc.b   0
			dc.b   0
			dc.b   3
			dc.b $11
			dc.b   6
			dc.b $23 ; #
			dc.b  $A
			dc.b $34 ; 4
			dc.b  $D
			dc.b $46 ; F
			dc.b $11
			dc.b $57 ; W
			dc.b $14
			dc.b $69 ; i
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b $11
			dc.b   5
			dc.b $23 ; #
			dc.b   8
			dc.b $35 ; 5
			dc.b  $B
			dc.b $46 ; F
			dc.b  $D
			dc.b $58 ; X
			dc.b $10
			dc.b $6A ; j
			dc.b   0
			dc.b   0
			dc.b   2
			dc.b $11
			dc.b   4
			dc.b $23 ; #
			dc.b   6
			dc.b $35 ; 5
			dc.b   8
			dc.b $47 ; G
			dc.b  $A
			dc.b $58 ; X
			dc.b  $C
			dc.b $6A ; j
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b $11
			dc.b   3
			dc.b $23 ; #
			dc.b   4
			dc.b $35 ; 5
			dc.b   6
			dc.b $47 ; G
			dc.b   8
			dc.b $59 ; Y
			dc.b   9
			dc.b $6A ; j
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b $11
			dc.b   2
			dc.b $23 ; #
			dc.b   3
			dc.b $35 ; 5
			dc.b   4
			dc.b $47 ; G
			dc.b   6
			dc.b $59 ; Y
			dc.b   7
			dc.b $6B ; k
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $11
			dc.b   1
			dc.b $23 ; #
			dc.b   2
			dc.b $35 ; 5
			dc.b   3
			dc.b $47 ; G
			dc.b   4
			dc.b $59 ; Y
			dc.b   5
			dc.b $6B ; k
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $11
			dc.b   1
			dc.b $23 ; #
			dc.b   1
			dc.b $35 ; 5
			dc.b   2
			dc.b $47 ; G
			dc.b   3
			dc.b $59 ; Y
			dc.b   3
			dc.b $6B ; k
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $11
			dc.b   0
			dc.b $23 ; #
			dc.b   1
			dc.b $35 ; 5
			dc.b   1
			dc.b $47 ; G
			dc.b   1
			dc.b $59 ; Y
			dc.b   2
			dc.b $6B ; k
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $11
			dc.b   0
			dc.b $23 ; #
			dc.b   0
			dc.b $35 ; 5
			dc.b   0
			dc.b $47 ; G
			dc.b   1
			dc.b $59 ; Y
			dc.b   1
			dc.b $6B ; k
			even
; ---------------------------------------------------------------------------
obj26:									; DATA XREF: ROM:00203542↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20C820(pc,d0.w),d0
			jmp	off_20C820(pc,d0.w)
; ---------------------------------------------------------------------------
off_20C820: dc.w loc_20C824-*			; CODE XREF: ROM:0020C81C↑j
										; DATA XREF: ROM:0020C818↑r ...
			dc.w loc_20C88A-off_20C820
; ---------------------------------------------------------------------------
loc_20C824:								; DATA XREF: ROM:off_20C820↑o
			addq.b	#2,obj.routine(a0)
			move.l	#obj26_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			moveq	#$A,d0
			jsr	sub_20DC4C(pc)
			move.b	obj.field_28(a0),d0
			andi.b	#7,d0
			move.b	d0,obj.ani(a0)
			move.b	#$86,obj.colflag(a0)
			move.b	#$10,obj.field_19(a0)
			move.b	#$C,obj.field_16(a0)
			cmpi.b	#3,d0
			bne.w	loc_20C874
			move.b	#2,obj.field_19(a0)
			move.b	#$C,obj.field_16(a0)
loc_20C874:								; CODE XREF: ROM:0020C864↑j
			cmpi.b	#4,d0
			bmi.w	locret_20C888
			move.b	#$10,obj.field_19(a0)
			move.b	#3,obj.field_16(a0)
locret_20C888:							; CODE XREF: ROM:0020C878↑j
			rts
; ---------------------------------------------------------------------------
loc_20C88A:								; DATA XREF: ROM:0020C822↑o
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jsr	(sub_207F56).l
			lea	(obj26_ani).l,a1
			jsr	(animateobj).l
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
obj29:									; DATA XREF: ROM:0020354E↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20C8C2(pc,d0.w),d0
			jmp	off_20C8C2(pc,d0.w)
; ---------------------------------------------------------------------------
off_20C8C2: dc.w loc_20C8CA-*			; CODE XREF: ROM:0020C8BE↑j
										; DATA XREF: ROM:0020C8BA↑r ...
			dc.w loc_20C9AC-off_20C8C2
			dc.w loc_20CB98-off_20C8C2
			dc.w loc_20CC02-off_20C8C2
; ---------------------------------------------------------------------------
loc_20C8CA:								; DATA XREF: ROM:off_20C8C2↑o
			addq.b	#2,obj.routine(a0)
			move.l	#obj29_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#$11,d0
			jsr	(sub_20DC4C).l
			move.b	obj.field_3D(a0),d0
			bne.s	loc_20C92E
			move.b	obj.field_28(a0),d6
			andi.w	#$F,d6
			jsr	sub_20C93C(pc)
			move.b	obj.field_3D(a1),d0
			ori.b	#$80,d0
			move.b	d0,obj.field_3D(a1)
			movea.w a2,a4
			subq.w	#1,d6
loc_20C912:								; CODE XREF: ROM:0020C918↓j
			jsr	sub_20C93C(pc)
			subq.w	#1,d6
			bne.s	loc_20C912
			move.b	obj.field_28(a0),d0
			andi.b	#$70,d0
			cmpi.b	#$70,d0
			bne.s	locret_20C92C
			jsr	sub_20C966(pc)
locret_20C92C:							; CODE XREF: ROM:0020C926↑j
			rts
; ---------------------------------------------------------------------------
loc_20C92E:								; CODE XREF: ROM:0020C8F4↑j
			move.b	obj.field_3D(a0),d0
			bpl.s	locret_20C93A
			move.b	#4,obj.routine(a0)
locret_20C93A:							; CODE XREF: ROM:0020C932↑j
			rts
; =============== S U B R O U T I N E =======================================
sub_20C93C:								; CODE XREF: ROM:0020C8FE↑p
										; ROM:loc_20C912↑p
			jsr	(findfreeobj).l
			bne.s	locret_20C964
			move.b	obj.field_28(a0),obj.field_28(a1)
			move.b	#$29,obj.id(a1)
			move.w	a0,obj.field_3E(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.b	d6,obj.field_3D(a1)
locret_20C964:							; CODE XREF: sub_20C93C+6↑j
										; sub_20C966+6↓j
			rts
; End of function sub_20C93C
; =============== S U B R O U T I N E =======================================
sub_20C966:								; CODE XREF: ROM:0020C928↑p
			jsr	(findfreeobj).l
			bne.s	locret_20C964
			move.b	#$13,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.w	a4,obj.field_3E(a1)
			move.b	#1,obj.field_3D(a1)
			rts
; End of function sub_20C966
; ---------------------------------------------------------------------------
unk_20C98C: dc.b   1					; DATA XREF: ROM:0020C9B2↓o
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			even
; ---------------------------------------------------------------------------
loc_20C9AC:								; DATA XREF: ROM:0020C8C4↑o
			moveq	#0,d0
			move.b	obj.field_3D(a0),d0
			lea	(unk_20C98C).l,a3
			move.b	(a3,d0.w),d2
			move.b	d2,obj.ani(a0)
			tst.b	d0
			beq.s	loc_20C9DA
			jsr	sub_20CB40(pc)
			lea	(obj29_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20C9DA:								; CODE XREF: ROM:0020C9C2↑j
			moveq	#0,d0
			move.b	obj.field_28(a0),d0
			andi.w	#$F0,d0
			asr.w	#2,d0
			lea	(off_20CA06).l,a3
			movea.l (a3,d0.w),a4
			jsr	(a4)
			lea	(obj29_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
off_20CA06: dc.l loc_20CA26				; DATA XREF: ROM:0020C9E6↑o
			dc.l loc_20CA32
			dc.l loc_20CA3E
			dc.l loc_20CA6E
			dc.l loc_20CA9E
			dc.l loc_20CAD4
			dc.l loc_20CB0A
			dc.l loc_20CA32
; ---------------------------------------------------------------------------
loc_20CA26:								; DATA XREF: ROM:off_20CA06↑o
			move.b	obj.field_3C(a0),d0
			addq.w	#1,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA32:								; DATA XREF: ROM:0020CA0A↑o
										; ROM:0020CA22↑o
			move.b	obj.field_3C(a0),d0
			subq.w	#1,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA3E:								; DATA XREF: ROM:0020CA0E↑o
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			andi.w	#$FF,d0
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$80,d0
			bpl.w	loc_20CA58
			bmi.w	loc_20CA62
loc_20CA58:								; CODE XREF: ROM:0020CA50↑j
			addi.w	#$40,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA62:								; CODE XREF: ROM:0020CA54↑j
			not.w	d0
			addi.w	#$40,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA6E:								; DATA XREF: ROM:0020CA12↑o
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			andi.w	#$FF,d0
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$80,d0
			bpl.w	loc_20CA88
			bmi.w	loc_20CA92
loc_20CA88:								; CODE XREF: ROM:0020CA80↑j
			addi.w	#$C0,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA92:								; CODE XREF: ROM:0020CA84↑j
			not.w	d0
			addi.w	#$C0,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA9E:								; DATA XREF: ROM:0020CA16↑o
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			cmpi.w	#$300,d0
			bmi.w	loc_20CAAE
			moveq	#0,d0
loc_20CAAE:								; CODE XREF: ROM:0020CAA8↑j
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$180,d0
			bpl.w	loc_20CABE
			bmi.w	loc_20CAC8
loc_20CABE:								; CODE XREF: ROM:0020CAB6↑j
			addi.w	#$C0,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CAC8:								; CODE XREF: ROM:0020CABA↑j
			not.w	d0
			addi.w	#$C0,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CAD4:								; DATA XREF: ROM:0020CA1A↑o
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			cmpi.w	#$200,d0
			bmi.w	loc_20CAE4
			moveq	#0,d0
loc_20CAE4:								; CODE XREF: ROM:0020CADE↑j
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$100,d0
			bpl.w	loc_20CAF4
			bmi.w	loc_20CAFE
loc_20CAF4:								; CODE XREF: ROM:0020CAEC↑j
			addi.w	#$80,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CAFE:								; CODE XREF: ROM:0020CAF0↑j
			addi.w	#$80,d0
			not.w	d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CB0A:								; DATA XREF: ROM:0020CA1E↑o
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			cmpi.w	#$80,d0
			bmi.w	loc_20CB1A
			moveq	#0,d0
loc_20CB1A:								; CODE XREF: ROM:0020CB14↑j
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$40,d0
			bpl.w	loc_20CB2A
			bmi.w	loc_20CB34
loc_20CB2A:								; CODE XREF: ROM:0020CB22↑j
			addi.w	#$A0,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CB34:								; CODE XREF: ROM:0020CB26↑j
			addi.w	#$E0,d0
			not.w	d0
			move.b	d0,obj.field_3C(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_20CB40:								; CODE XREF: ROM:0020C9C4↑p
										; ROM:0020CB9E↓p ...
			move.l	obj.xpos(a0),obj.field_38(a0)
			move.l	obj.ypos(a0),obj.field_34(a0)
			movea.w obj.field_3E(a0),a2
			moveq	#0,d0
			move.b	obj.field_3C(a2),d0
			jsr	(calcsine).l
			moveq	#0,d3
			move.b	obj.field_3D(a0),d3
			andi.w	#$F,d3
			mulu.w	#$100,d3
			muls.w	d3,d0
			asl.l	#4,d0
			move.l	d0,d4
			move.l	obj.xpos(a2),d2
			add.l	d0,d2
			move.l	d2,obj.xpos(a0)
			muls.w	d3,d1
			asl.l	#4,d1
			move.l	d1,d5
			move.l	obj.ypos(a2),d2
			add.l	d1,d2
			move.l	d2,obj.ypos(a0)
			asr.l	#8,d4
			asr.l	#8,d5
			move.w	d4,obj.xvel(a2)
			move.w	d5,obj.yvel(a2)
			rts
; End of function sub_20CB40
; ---------------------------------------------------------------------------
loc_20CB98:								; DATA XREF: ROM:0020C8C6↑o
			move.b	#3,obj.ani(a0)
			bsr.s	sub_20CB40
			move.b	#$18,obj.field_19(a0)
			move.b	#8,obj.field_16(a0)
			move.b	#8,obj.field_16(a0)
			lea	(actwk).w,a1
			bsr.w	sub_20B684
			beq.w	loc_20CBEE
			bsr.w	sub_20CC4C
			bne.w	loc_20CBEE
			move.w	obj.ypos(a0),d0
			moveq	#0,d1
			move.b	obj.field_16(a1),d1
			sub.w	d1,d0
			move.b	obj.field_16(a0),d1
			sub.w	d1,d0
			move.w	d0,obj.ypos(a1)
			bset	#3,obj.status(a1)
			bclr	#1,obj.status(a1)
			move.b	#6,obj.routine(a0)
loc_20CBEE:								; CODE XREF: ROM:0020CBBA↑j
										; ROM:0020CBC2↑j ...
			lea	(obj29_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20CC02:								; DATA XREF: ROM:0020C8C8↑o
			move.b	#3,obj.ani(a0)
			bsr.w	sub_20CB40
			lea	(actwk).w,a1
			moveq	#$10,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20CC3E
			move.l	obj.xpos(a0),d0
			sub.l	obj.field_38(a0),d0
			add.l	obj.xpos(a1),d0
			move.l	d0,obj.xpos(a1)
			move.l	obj.ypos(a0),d0
			sub.l	obj.field_34(a0),d0
			add.l	obj.ypos(a1),d0
			move.l	d0,obj.ypos(a1)
			bra.s	loc_20CBEE
; ---------------------------------------------------------------------------
loc_20CC3E:								; CODE XREF: ROM:0020CC18↑j
			bclr	#3,obj.status(a1)
			move.b	#4,obj.routine(a0)
			bra.s	loc_20CBEE
; =============== S U B R O U T I N E =======================================
sub_20CC4C:								; CODE XREF: ROM:0020CBBE↑p
			lea	(actwk).w,a1
			moveq	#0,d2
			moveq	#0,d3
			move.b	obj.field_16(a0),d2
			move.b	obj.field_16(a1),d3
			move.w	obj.ypos(a0),d0
			move.w	obj.ypos(a1),d1
			add.w	d2,d0
			add.w	d3,d1
			cmp.w	d0,d1
			bpl.w	loc_20CC72
			bmi.w	loc_20CC76
loc_20CC72:								; CODE XREF: sub_20CC4C+1E↑j
			moveq	#-1,d1
			rts
; ---------------------------------------------------------------------------
loc_20CC76:								; CODE XREF: sub_20CC4C+22↑j
			moveq	#0,d1
			rts
; End of function sub_20CC4C
; ---------------------------------------------------------------------------
			dc.b 1
			dc.b $F8,  5,  0,  0,$F8
			even
			dc.b 1
			dc.b $F8, $D,  0,  4,$F0
			even
			dc.b 1
			dc.b $FC,  0,  0, $C,$FC
			even
			dc.b 1
			dc.b $F0,  3,  0, $D,$FC
			even
			dc.b 1
			dc.b $F0,  3,  0,$11,$FC
			even
			dc.b 1
			dc.b $F8,  5,  8,  0,$F8
			even
			dc.b 1
			dc.b $F8, $D,  8,  4,$F0
			even
			dc.b 1
			dc.b $FC,  0,  8, $C,$FC
			even
			dc.b 1
			dc.b $F0,  3,  8, $D,$FC
			even
			dc.b 1
			dc.b $F0,  3,  8,$11,$FC
			even
obj28_ani:	dc.w unk_20CCC0-*			; DATA XREF: ROM:loc_20B8B6↑o
										; ROM:loc_20B8F6↑o ...
			dc.w unk_20CCD0-obj28_ani
			dc.w unk_20CCDA-obj28_ani
			dc.w unk_20CCE4-obj28_ani
			dc.w unk_20CCE8-obj28_ani
unk_20CCC0: dc.b   2					; DATA XREF: ROM:obj28_ani↑o
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   2
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   3
			dc.b   4
			dc.b   3
			dc.b   5
			dc.b   3
			dc.b   4
			dc.b   3
			dc.b $FF
			even
unk_20CCD0: dc.b   2					; DATA XREF: ROM:0020CCB8↑o
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   2
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b $FF
			even
unk_20CCDA: dc.b   2					; DATA XREF: ROM:0020CCBA↑o
			dc.b   3
			dc.b   4
			dc.b   3
			dc.b   5
			dc.b   3
			dc.b   4
			dc.b   3
			dc.b $FF
			even
unk_20CCE4: dc.b   0					; DATA XREF: ROM:0020CCBC↑o
			dc.b   0
			dc.b $FF
			even
unk_20CCE8: dc.b   0					; DATA XREF: ROM:0020CCBE↑o
			dc.b   3
			dc.b $FF
			even
obj28_map:	dc.w byte_20CCF8-*			; DATA XREF: ROM:00206B42↑o
										; ROM:00206B4E↑o ...
			dc.w byte_20CD04-obj28_map
			dc.w byte_20CD10-obj28_map
			dc.w byte_20CD1C-obj28_map
			dc.w byte_20CD28-obj28_map
			dc.w byte_20CD34-obj28_map
byte_20CCF8:	dc.b 2						; DATA XREF: ROM:obj28_map↑o
			dc.b $FC,  1,  0,  0,$F8
			dc.b $FC,  8,  0,  2,  0
			even
byte_20CD04:	dc.b 2						; DATA XREF: ROM:0020CCEE↑o
			dc.b $FC,  5,  0,  5,$F8
			dc.b   0,  5,  0,  9,  8
			even
byte_20CD10:	dc.b 2						; DATA XREF: ROM:0020CCF0↑o
			dc.b $FC,  5,  0, $D,$F8
			dc.b $F0,  5,  0,$11,  8
			even
byte_20CD1C:	dc.b 2						; DATA XREF: ROM:0020CCF2↑o
			dc.b $FC,  1,  8,  0,  0
			dc.b $FC,  8,  8,  2,$E8
			even
byte_20CD28:	dc.b 2						; DATA XREF: ROM:0020CCF4↑o
			dc.b $FC,  5,  8,  5,$F8
			dc.b   0,  5,  8,  9,$E8
			even
byte_20CD34:	dc.b 2						; DATA XREF: ROM:0020CCF6↑o
			dc.b $FC,  5,  8, $D,$F8
			dc.b $F0,  5,  8,$11,$E8
			even
obj27_ani:	dc.w unk_20CD5C-*			; DATA XREF: ROM:loc_20BAD2↑o
										; ROM:loc_20BB96↑o ...
			dc.w unk_20CD6C-obj27_ani
			dc.w unk_20CD70-obj27_ani
			dc.w unk_20CD74-obj27_ani
			dc.w unk_20CD78-obj27_ani
			dc.w unk_20CD7C-obj27_ani
			dc.w unk_20CD80-obj27_ani
			dc.w unk_20CD84-obj27_ani
			dc.w unk_20CD88-obj27_ani
			dc.w unk_20CD8C-obj27_ani
			dc.w unk_20CD90-obj27_ani
			dc.w unk_20CD94-obj27_ani
			dc.w unk_20CD98-obj27_ani
			dc.w unk_20CD9C-obj27_ani
unk_20CD5C: dc.b   9					; DATA XREF: ROM:obj27_ani↑o
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b   5
			dc.b   6
			dc.b   7
			dc.b   8
			dc.b   9
			dc.b  $A
			dc.b  $B
			dc.b  $C
			dc.b $FF
			even
unk_20CD6C: dc.b   0					; DATA XREF: ROM:0020CD42↑o
			dc.b   0
			dc.b $FF
			even
unk_20CD70: dc.b   0					; DATA XREF: ROM:0020CD44↑o
			dc.b   1
			dc.b $FF
			even
unk_20CD74: dc.b   0					; DATA XREF: ROM:0020CD46↑o
			dc.b   2
			dc.b $FF
			even
unk_20CD78: dc.b   0					; DATA XREF: ROM:0020CD48↑o
			dc.b   3
			dc.b $FF
			even
unk_20CD7C: dc.b   0					; DATA XREF: ROM:0020CD4A↑o
			dc.b   4
			dc.b $FF
			even
unk_20CD80: dc.b   0					; DATA XREF: ROM:0020CD4C↑o
			dc.b   5
			dc.b $FF
			even
unk_20CD84: dc.b   0					; DATA XREF: ROM:0020CD4E↑o
			dc.b   6
			dc.b $FF
			even
unk_20CD88: dc.b   0					; DATA XREF: ROM:0020CD50↑o
			dc.b   7
			dc.b $FF
			even
unk_20CD8C: dc.b   0					; DATA XREF: ROM:0020CD52↑o
			dc.b   8
			dc.b $FF
			even
unk_20CD90: dc.b   0					; DATA XREF: ROM:0020CD54↑o
			dc.b   9
			dc.b $FF
			even
unk_20CD94: dc.b   0					; DATA XREF: ROM:0020CD56↑o
			dc.b  $A
			dc.b $FF
			even
unk_20CD98: dc.b   0					; DATA XREF: ROM:0020CD58↑o
			dc.b  $B
			dc.b $FF
			even
unk_20CD9C: dc.b   0					; DATA XREF: ROM:0020CD5A↑o
			dc.b  $C
			dc.b $FF
			even
obj27_map:	dc.w byte_20CDBA-*			; DATA XREF: ROM:00206B66↑o
										; ROM:0020BA80↑o ...
			dc.w byte_20CDCA-obj27_map
			dc.w byte_20CDE4-obj27_map
			dc.w byte_20CDF4-obj27_map
			dc.w byte_20CE18-obj27_map
			dc.w byte_20CE32-obj27_map
			dc.w byte_20CE42-obj27_map
			dc.w byte_20CE52-obj27_map
			dc.w byte_20CE6C-obj27_map
			dc.w byte_20CE7C-obj27_map
			dc.w byte_20CEA0-obj27_map
			dc.w byte_20CEBA-obj27_map
			dc.w byte_20CECA-obj27_map
byte_20CDBA:	dc.b 3						; DATA XREF: ROM:obj27_map↑o
			dc.b $F0, $C,  0,  0,  0
			dc.b   8, $C,$18,  0,$E0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CDCA:	dc.b 5						; DATA XREF: ROM:0020CDA2↑o
			dc.b $F0, $C,  0,  4,  0
			dc.b $E8,  0,  0,  8,$18
			dc.b   8, $C,$18,  4,$E0
			dc.b $10,  0,$18,  8,$E0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CDE4:	dc.b 3						; DATA XREF: ROM:0020CDA4↑o
			dc.b $E8, $D,  0,  9,  0
			dc.b   8, $D,$18,  9,$E0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CDF4:	dc.b 7						; DATA XREF: ROM:0020CDA6↑o
			dc.b $E8, $D,  0,$11,  0
			dc.b $E0,  0,  0,$19,$10
			dc.b $F0,  0,  0,$1A,$F8
			dc.b   8, $D,$18,$11,$E0
			dc.b $18,  0,$18,$19,$E8
			dc.b   8,  0,$18,$1A,  0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE18:	dc.b 5						; DATA XREF: ROM:0020CDA8↑o
			dc.b $E0, $E,  0,$1B,  0
			dc.b $F0,  0,  0,$27,$F8
			dc.b   8, $E,$18,$1B,$E0
			dc.b   8,  0,$18,$27,  0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE32:	dc.b 3						; DATA XREF: ROM:0020CDAA↑o
			dc.b $E0,  6,  0,$28,$F8
			dc.b   8,  6,$10,$28,$F8
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE42:	dc.b 3						; DATA XREF: ROM:0020CDAC↑o
			dc.b $F0, $C,  8,  0,$E0
			dc.b   8, $C,$10,  0,  0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE52:	dc.b 5						; DATA XREF: ROM:0020CDAE↑o
			dc.b $F0, $C,  8,  4,$E0
			dc.b $E8,  0,  8,  8,$E0
			dc.b   8, $C,$10,  4,  0
			dc.b $10,  0,$10,  8,$18
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE6C:	dc.b 3						; DATA XREF: ROM:0020CDB0↑o
			dc.b $E8, $D,  8,  9,$E0
			dc.b   8, $D,$10,  9,  0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE7C:	dc.b 7						; DATA XREF: ROM:0020CDB2↑o
			dc.b $E8, $D,  8,$11,$E0
			dc.b $E0,  0,  8,$19,$E8
			dc.b $F0,  0,  8,$1A,  0
			dc.b   8, $D,$10,$11,  0
			dc.b $18,  0,$10,$19,$10
			dc.b   8,  0,$10,$1A,$F8
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CEA0:	dc.b 5						; DATA XREF: ROM:0020CDB4↑o
			dc.b $E0, $E,  8,$1B,$E0
			dc.b $F0,  0,  8,$27,  0
			dc.b   8, $E,$10,$1B,  0
			dc.b   8,  0,$10,$27,$F8
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CEBA:	dc.b 3						; DATA XREF: ROM:0020CDB6↑o
			dc.b $E0,  6,  8,$28,$F8
			dc.b   8,  6,$18,$28,$F8
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CECA:	dc.b 1						; DATA XREF: ROM:0020CDB8↑o
			dc.b $FC,  0,$C0,$2E,$FC
			even
off_20CED0: dc.w unk_20CED6-*			; DATA XREF: ROM:0020BF4A↑o
										; ROM:loc_20C178↑o ...
			dc.w unk_20CEDA-off_20CED0
			dc.w unk_20CEDE-off_20CED0
unk_20CED6: dc.b $1D					; DATA XREF: ROM:off_20CED0↑o
			dc.b   0
			dc.b   1
			dc.b $FF
unk_20CEDA: dc.b   0					; DATA XREF: ROM:0020CED2↑o
			dc.b   0
			dc.b $FF
			even
unk_20CEDE: dc.b   0					; DATA XREF: ROM:0020CED4↑o
			dc.b   1
			dc.b $FF
			even
off_20CEE2: dc.w byte_20CEE6-*			; DATA XREF: ROM:00206B1E↑o
										; ROM:0020BCDA↑o ...
			dc.w byte_20CEEC-off_20CEE2
byte_20CEE6:	dc.b 1						; DATA XREF: ROM:off_20CEE2↑o
			dc.b $F8,  5,  0,  0,$F8
			even
byte_20CEEC:	dc.b 1						; DATA XREF: ROM:0020CEE4↑o
			dc.b $F8,  5,  0,  4,$F8
			even
obj26_ani:	dc.w unk_20CEFE-*			; DATA XREF: ROM:0020B670↑o
										; ROM:loc_20C18C↑o ...
			dc.w unk_20CF02-obj26_ani
			dc.w unk_20CF06-obj26_ani
			dc.w unk_20CF0A-obj26_ani
			dc.w unk_20CF0E-obj26_ani
			dc.w unk_20CF12-obj26_ani
unk_20CEFE: dc.b $1D					; DATA XREF: ROM:obj26_ani↑o
			dc.b   0
			dc.b $FF
			even
unk_20CF02: dc.b $1D					; DATA XREF: ROM:0020CEF4↑o
			dc.b   1
			dc.b $FF
			even
unk_20CF06: dc.b $1D					; DATA XREF: ROM:0020CEF6↑o
			dc.b   2
			dc.b $FF
			even
unk_20CF0A: dc.b $1D					; DATA XREF: ROM:0020CEF8↑o
			dc.b   3
			dc.b $FF
			even
unk_20CF0E: dc.b $1D					; DATA XREF: ROM:0020CEFA↑o
			dc.b   4
			dc.b $FF
			even
unk_20CF12: dc.b $1D					; DATA XREF: ROM:0020CEFC↑o
			dc.b   5
			dc.b $FF
			even
off_20CF16: dc.w byte_20CF1C-*			; DATA XREF: ROM:0020B616↑o
										; ROM:0020CF18↓o ...
			dc.w byte_20CF27-off_20CF16
			dc.w byte_20CF32-off_20CF16
byte_20CF1C:	dc.b 2						; DATA XREF: ROM:off_20CF16↑o
			dc.b $F0,  7,  0,  0,$F0
			dc.b $F0,  7,  0,  0,  0
byte_20CF27:	dc.b 2						; DATA XREF: ROM:0020CF18↑o
			dc.b $F0, $D,  0,  8,$F0
			dc.b   0, $D,  0,  8,$F0
			even
byte_20CF32:	dc.b 2						; DATA XREF: ROM:0020CF1A↑o
			dc.b $F0, $D,  8,  8,$F0
			dc.b   0, $D,  8,  8,$F0
			even
off_20CF3E: dc.w byte_20CF46-*			; DATA XREF: ROM:0020CF40↓o
										; ROM:0020CF42↓o ...
			dc.w byte_20CF5B-off_20CF3E
			dc.w byte_20CF70-off_20CF3E
			dc.w byte_20CF85-off_20CF3E
byte_20CF46:	dc.b 4						; DATA XREF: ROM:off_20CF3E↑o
			dc.b $F0,  3,  0,  0,$F0
			dc.b $F1,  3,  0,  0,$F8
			dc.b $F2,  3,  0,  0,  0
			dc.b $F3,  3,  0,  0,  8
byte_20CF5B:	dc.b 4						; DATA XREF: ROM:0020CF40↑o
			dc.b $F0, $C,  0,  4,$F0
			dc.b $F8, $C,  0,  4,$F1
			dc.b   0, $C,  0,  4,$F2
			dc.b   8, $C,  0,  4,$F3
			even
byte_20CF70:	dc.b 4						; DATA XREF: ROM:0020CF42↑o
			dc.b $F0, $C,  8,  4,$F3
			dc.b $F8, $C,  8,  4,$F2
			dc.b   0, $C,  8,  4,$F1
			dc.b   8, $C,  8,  4,$F0
byte_20CF85:	dc.b 2						; DATA XREF: ROM:0020CF44↑o
			dc.b $F0,  3,  0,  0,$F4
			dc.b $F0,  3,  0,  0,  4
			even
obj26_map:	dc.w byte_20CF9C-*			; DATA XREF: ROM:00206B36↑o
										; ROM:0020C828↑o ...
			dc.w byte_20CFA7-obj26_map
			dc.w byte_20CFBC-obj26_map
			dc.w byte_20CFD1-obj26_map
			dc.w byte_20CFD8-obj26_map
			dc.w byte_20CFDE-obj26_map
byte_20CF9C:	dc.b 2						; DATA XREF: ROM:obj26_map↑o
			dc.b $F0,  7,  0,  0,$F0
			dc.b $F0,  7,  0,  0,  0
byte_20CFA7:	dc.b 4						; DATA XREF: ROM:0020CF92↑o
			dc.b $F0, $C,  0,  8,$F0
			dc.b $F8, $C,  0,  8,$F0
			dc.b   0, $C,  0,  8,$F0
			dc.b   8, $C,  0,  8,$F0
			even
byte_20CFBC:	dc.b 4						; DATA XREF: ROM:0020CF94↑o
			dc.b $F0, $C,  8,  8,$F0
			dc.b $F8, $C,  8,  8,$F0
			dc.b   0, $C,  8,  8,$F0
			dc.b   8, $C,  8,  8,$F0
byte_20CFD1:	dc.b 1						; DATA XREF: ROM:0020CF96↑o
			dc.b $F0,  3,  0,  0,$FC
			even
byte_20CFD8:	dc.b 1						; DATA XREF: ROM:0020CF98↑o
			dc.b $FC, $C,  0,  8,$F0
			even
byte_20CFDE:	dc.b 1						; DATA XREF: ROM:0020CF9A↑o
			dc.b $FC, $C,  8,  8,$F0
			even
obj29_ani:	dc.w unk_20CFEC-*			; DATA XREF: ROM:0020C9C8↑o
										; ROM:0020C9F2↑o ...
			dc.w unk_20CFF2-obj29_ani
			dc.w unk_20CFF6-obj29_ani
			dc.w unk_20CFFA-obj29_ani
unk_20CFEC: dc.b $1D					; DATA XREF: ROM:obj29_ani↑o
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b $FF
			even
unk_20CFF2: dc.b $1D					; DATA XREF: ROM:0020CFE6↑o
			dc.b   0
			dc.b $FF
			even
unk_20CFF6: dc.b $1D					; DATA XREF: ROM:0020CFE8↑o
			dc.b   1
			dc.b $FF
			even
unk_20CFFA: dc.b $1D					; DATA XREF: ROM:0020CFEA↑o
			dc.b   2
			dc.b $FF
			even
obj29_map:	dc.w byte_20D004-*			; DATA XREF: ROM:0020C8CE↑o
										; ROM:0020D000↓o ...
			dc.w byte_20D00A-obj29_map
			dc.w byte_20D010-obj29_map
byte_20D004:	dc.b 1						; DATA XREF: ROM:obj29_map↑o
			dc.b $F8,  5,  0,  0,$F8
			even
byte_20D00A:	dc.b 1						; DATA XREF: ROM:0020D000↑o
			dc.b $F8,  5,  0,  4,$F8
			even
byte_20D010:	dc.b 2						; DATA XREF: ROM:0020D002↑o
			dc.b $F8,  9,  0,  8,$E8
			dc.b $F8,  9,  8,  8,  0
			even
; ---------------------------------------------------------------------------
obj20:									; DATA XREF: ROM:0020352A↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20D030(pc,d0.w),d0
			jsr	off_20D030(pc,d0.w)
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
off_20D030: dc.w loc_20D038-*			; CODE XREF: ROM:0020D026↑p
										; DATA XREF: ROM:0020D022↑r ...
			dc.w loc_20D0AC-off_20D030
			dc.w loc_20D0F2-off_20D030
			dc.w loc_20D136-off_20D030
; ---------------------------------------------------------------------------
loc_20D038:								; DATA XREF: ROM:off_20D030↑o
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.b	#3,obj.priority(a0)
			move.w	#$4000,obj.vram(a0)
			lea	off_20D34C(pc),a1
			lea	off_20D3C2(pc),a2
			move.b	obj.field_28(a0),d0
			bpl.w	loc_20D066
			lea	off_20D418(pc),a1
			lea	off_20D5B0(pc),a2
loc_20D066:								; CODE XREF: ROM:0020D05A↑j
			move.l	a1,obj.mappings(a0)
			btst	#4,d0
			beq.w	loc_20D07E
			bset	#0,obj.render(a0)
			bset	#0,obj.status(a0)
loc_20D07E:								; CODE XREF: ROM:0020D06E↑j
			andi.w	#$F,d0
			move.b	d0,obj.frame(a0)
			add.w	d0,d0
			move.w	(a2,d0.w),d0
			move.b	(a2,d0.w),d1
			addq.b	#1,d1
			asl.b	#3,d1
			move.b	d1,obj.field_19(a0)
			move.b	1(a2,d0.w),d1
			bpl.w	loc_20D0A2
			neg.b	d1
loc_20D0A2:								; CODE XREF: ROM:0020D09C↑j
			addq.b	#1,d1
			asl.b	#3,d1
			addq.b	#2,d1
			move.b	d1,obj.field_16(a0)
loc_20D0AC:								; DATA XREF: ROM:0020D032↑o
			tst.b	obj.render(a0)
			bpl.s	locret_20D0E0
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			lea	(actwk).w,a3
			lea	(byte_FFD040).w,a1
			move.b	(byte_FF1219).l,d0
			beq.w	loc_20D0CE
			exg.l	a1,a3
loc_20D0CE:								; CODE XREF: ROM:0020D0C8↑j
			jsr	(sub_207F56).l
			exg.l	a1,a3
			jsr	(sub_207F56).l
			bne.w	loc_20D0E2
locret_20D0E0:							; CODE XREF: ROM:0020D0B0↑j
			rts
; ---------------------------------------------------------------------------
loc_20D0E2:								; CODE XREF: ROM:0020D0DC↑j
			addq.b	#2,obj.routine(a0)
			move.b	obj.field_28(a0),d0
			bpl.w	loc_20D170
			bra.w	loc_20D262
; ---------------------------------------------------------------------------
loc_20D0F2:								; DATA XREF: ROM:0020D034↑o
			lea	obj.field_2A(a0),a3
			addi.w	#-1,(a3)
			bne.w	loc_20D102
			addq.b	#2,obj.routine(a0)
loc_20D102:								; CODE XREF: ROM:0020D0FA↑j
			move.b	obj.field_3E(a0),d0
			beq.w	locret_20D134
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			lea	(actwk).w,a1
			bsr.w	sub_20D11E
			lea	(byte_FFD040).w,a1
; =============== S U B R O U T I N E =======================================
sub_20D11E:								; CODE XREF: ROM:0020D116↑p
			jsr	(sub_207F56).l
			beq.w	locret_20D134
			tst.w	(a3)
			bne.w	locret_20D134
			bclr	#3,obj.status(a1)
locret_20D134:							; CODE XREF: ROM:0020D106↑j
										; sub_20D11E+6↑j ...
			rts
; End of function sub_20D11E
; ---------------------------------------------------------------------------
loc_20D136:								; DATA XREF: ROM:0020D036↑o
			move.l	obj.field_2C(a0),d0
			add.l	d0,obj.ypos(a0)
			addi.l	#$4000,obj.field_2C(a0)
			move.w	obj.ypos(a0),d0
			lea	(actwk).w,a1
			move.b	(byte_FF1219).l,d1
			beq.w	loc_20D15C
			lea	(byte_FFD040).w,a1
loc_20D15C:								; CODE XREF: ROM:0020D154↑j
			sub.w	obj.ypos(a1),d0
			cmpi.w	#$200,d0
			bgt.w	loc_20D16A
			rts
; ---------------------------------------------------------------------------
loc_20D16A:								; CODE XREF: ROM:0020D164↑j
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_20D170:								; CODE XREF: ROM:0020D0EA↑j
										; DATA XREF: ROM:0020D17E↓o
			move.b	obj.field_28(a0),d0
			suba.l	a4,a4
			btst	#4,d0
			beq.w	loc_20D182
			lea	loc_20D170(pc),a4
loc_20D182:								; CODE XREF: ROM:0020D17A↑j
			lea	off_20D3C2(pc),a6
			andi.w	#$F,d0
			add.w	d0,d0
			move.w	(a6,d0.w),d0
			lea	(a6,d0.w),a6
			moveq	#0,d0
			move.b	(a6)+,d0
			movea.w d0,a5
			asl.w	#3,d0
			move.w	#-$10,d1
			cmpa.w	#0,a4
			bne.w	loc_20D1AC
			neg.w	d0
			neg.w	d1
loc_20D1AC:								; CODE XREF: ROM:0020D1A4↑j
			add.w	obj.xpos(a0),d0
			movea.w d0,a2
			movea.w d1,a3
			moveq	#0,d6
			move.b	(a6)+,d6
			move.w	d6,d4
			asl.w	#3,d4
			add.w	obj.ypos(a0),d4
			move.w	#9,d2
			move.b	obj.id(a0),obj.field_3F(a0)
			clr.b	obj.id(a0)
loc_20D1CE:								; CODE XREF: ROM:0020D25C↓j
			move.w	a5,d5
			move.w	a2,d3
			move.w	d2,d1
loc_20D1D4:								; CODE XREF: ROM:0020D252↓j
			jsr	(sub_206F9C).l
			bne.w	locret_20D260
			move.b	(a6)+,d0
			bmi.w	loc_20D24C
			move.b	d0,obj.frame(a1)
			ori.b	#4,obj.render(a1)
			move.b	#3,obj.priority(a1)
			move.w	#$4000,obj.vram(a1)
			move.l	#obj20_map,obj.mappings(a1)
			move.l	#$20000,obj.field_2C(a1)
			move.b	obj.field_3F(a0),obj.id(a1)
			move.b	obj.routine(a0),obj.routine(a1)
			cmpa.w	#0,a4
			beq.w	loc_20D22A
			bset	#0,obj.render(a1)
			bset	#0,obj.status(a1)
loc_20D22A:								; CODE XREF: ROM:0020D21A↑j
			tst.w	d6
			bne.w	loc_20D240
			st	obj.field_3E(a1)
			move.b	#8,obj.field_19(a1)
			move.b	#9,obj.field_16(a1)
loc_20D240:								; CODE XREF: ROM:0020D22C↑j
			move.w	d4,obj.ypos(a1)
			move.w	d3,obj.xpos(a1)
			move.w	d1,obj.field_2A(a1)
loc_20D24C:								; CODE XREF: ROM:0020D1E0↑j
			add.w	a3,d3
			addi.w	#$C,d1
			dbf	d5,loc_20D1D4
			addi.w	#-$10,d4
			addq.w	#5,d2
			dbf	d6,loc_20D1CE
locret_20D260:							; CODE XREF: ROM:0020D1DA↑j
			rts
; ---------------------------------------------------------------------------
loc_20D262:								; CODE XREF: ROM:0020D0EE↑j
			move.b	obj.field_28(a0),d2
			lea	off_20D5B0(pc),a6
			move.b	d2,d0
			andi.w	#$1F,d0
			add.w	d0,d0
			move.w	(a6,d0.w),d0
			lea	(a6,d0.w),a6
			move.b	(a6)+,d5
			move.b	(a6)+,d1
			addq.b	#1,d1
			asl.b	#3,d1
			addq.b	#2,d1
			andi.w	#$FF,d5
			move.w	d5,d4
			lsl.w	#3,d4
			neg.w	d4
			move.w	#$10,d3
			moveq	#1,d6
			btst	#6,d2
			bne.w	loc_20D2A2
			lsl.b	#2,d2
			bra.w	loc_20D2C4
; ---------------------------------------------------------------------------
loc_20D2A2:								; CODE XREF: ROM:0020D298↑j
			lea	(actwk).w,a1
			move.b	(byte_FF1219).l,d0
			beq.w	loc_20D2B4
			lea	(byte_FFD040).w,a1
loc_20D2B4:								; CODE XREF: ROM:0020D2AC↑j
			move.w	obj.xvel(a1),d0
			btst	#5,d2
			beq.w	loc_20D2C2
			neg.w	d0
loc_20D2C2:								; CODE XREF: ROM:0020D2BC↑j
			tst.w	d0
loc_20D2C4:								; CODE XREF: ROM:0020D29E↑j
			bpl.w	loc_20D2D2
			lea	(a6,d5.w),a6
			neg.w	d4
			neg.w	d3
			neg.w	d6
loc_20D2D2:								; CODE XREF: ROM:loc_20D2C4↑j
			add.w	obj.xpos(a0),d4
			move.w	#9,d2
			move.b	obj.id(a0),obj.field_3F(a0)
			clr.b	obj.id(a0)
loc_20D2E4:								; CODE XREF: ROM:0020D346↓j
			jsr	(sub_206F9C).l
			bne.w	locret_20D34A
			move.b	#3,obj.priority(a1)
			move.w	#$4000,obj.vram(a1)
			ori.b	#4,obj.render(a1)
			move.l	#obj20b_map,obj.mappings(a1)
			move.l	#$20000,obj.field_2C(a1)
			move.b	obj.field_3F(a0),obj.id(a1)
			move.b	obj.routine(a0),obj.routine(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			st	obj.field_3E(a1)
			move.b	#8,obj.field_19(a1)
			move.b	d1,obj.field_16(a1)
			move.b	(a6),obj.frame(a1)
			lea	(a6,d6.w),a6
			move.w	d4,obj.xpos(a1)
			add.w	d3,d4
			move.w	d2,obj.field_2A(a1)
			addi.w	#$C,d2
			dbf	d5,loc_20D2E4
locret_20D34A:							; CODE XREF: ROM:0020D2EA↑j
			rts
; ---------------------------------------------------------------------------
off_20D34C: dc.w byte_20D34E-*			; DATA XREF: ROM:00206D3A↑o
										; ROM:00206D46↑o ...
byte_20D34E:	dc.b 23						; DATA XREF: ROM:off_20D34C↑o
			dc.b $D0,  5,  8, $D,$D8
			dc.b $D0,  5,  8, $D,$E8
			dc.b $D0,  5,  8, $D,$F8
			dc.b $D0,  5,  8, $D,  8
			dc.b $D0,  5,  8, $D,$18
			dc.b $E0,  5,  8,$11,$D8
			dc.b $E0,  5,  8,$11,$E8
			dc.b $E0,  5,  8,$11,$F8
			dc.b $E0,  5,  8,$11,  8
			dc.b $E0,  5,  8,$11,$18
			dc.b $F0,  5,  0,$19,$D8
			dc.b $F0,  5,  8,$15,$E8
			dc.b $F0,  5,  8,$15,$F8
			dc.b $F0,  5,  8,$15,  8
			dc.b $F0,  5,  8,$15,$18
			dc.b   0,  5,  8,$25,$D8
			dc.b   0,  5,  0,$1D,$E8
			dc.b   0,  5,  0,$21,$F8
			dc.b   0,  5,  0,$21,  8
			dc.b   0,  5,  8,$1D,$18
			dc.b $10,  5,  0,$19,$F8
			dc.b $10,  5,  0,$19,  8
			dc.b $10,  5,  0,$19,$18
			even
off_20D3C2: dc.w unk_20D3C4-*			; DATA XREF: ROM:0020D052↑o
										; ROM:loc_20D182↑o
unk_20D3C4: dc.b   4					; DATA XREF: ROM:off_20D3C2↑o
			dc.b   3
			dc.b $FF
			dc.b $FF
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   3
			dc.b   4
			dc.b   0
			dc.b   5
			dc.b   5
			dc.b   5
			dc.b   5
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			dc.b   6
			even
obj20_map:	dc.w byte_20D3E8-*			; DATA XREF: ROM:0020D1FA↑o
										; ROM:0020D3DC↓o ...
			dc.w byte_20D3EE-obj20_map
			dc.w byte_20D3F4-obj20_map
			dc.w byte_20D3FA-obj20_map
			dc.w byte_20D400-obj20_map
			dc.w byte_20D406-obj20_map
			dc.w byte_20D40C-obj20_map
byte_20D3E8:	dc.b 1						; DATA XREF: ROM:obj20_map↑o
			dc.b $F8,  5,  0,$19,$F8
			even
byte_20D3EE:	dc.b 1						; DATA XREF: ROM:0020D3DC↑o
			dc.b $F8,  5,  8,$25,$F8
			even
byte_20D3F4:	dc.b 1						; DATA XREF: ROM:0020D3DE↑o
			dc.b $F8,  5,  0,$1D,$F8
			even
byte_20D3FA:	dc.b 1						; DATA XREF: ROM:0020D3E0↑o
			dc.b $F8,  5,  0,$21,$F8
			even
byte_20D400:	dc.b 1						; DATA XREF: ROM:0020D3E2↑o
			dc.b $F8,  5,  8,$1D,$F8
			even
byte_20D406:	dc.b 1						; DATA XREF: ROM:0020D3E4↑o
			dc.b $F8,  5,  8,$15,$F8
			even
byte_20D40C:	dc.b 2						; DATA XREF: ROM:0020D3E6↑o
			dc.b $E8,  5,  8, $D,$F8
			dc.b $F8,  5,  8,$11,$F8
			even
off_20D418: dc.w byte_20D424-*			; DATA XREF: ROM:00206D52↑o
										; ROM:00206D5E↑o ...
			dc.w byte_20D424-off_20D418
			dc.w byte_20D47F-off_20D418
			dc.w byte_20D4E4-off_20D418
			dc.w byte_20D549-off_20D418
			dc.w byte_20D57C-off_20D418
byte_20D424:	dc.b 18						; DATA XREF: ROM:off_20D418↑o
										; ROM:0020D41A↑o
			dc.b $E0,  5,  0, $D,$D0
			dc.b $E0,  5,  0, $D,$E0
			dc.b $E0,  5,  0, $D,$F0
			dc.b $E0,  5,  0, $D,  0
			dc.b $E0,  5,  0, $D,$10
			dc.b $E0,  5,  0, $D,$20
			dc.b $F0,  5,  0,$11,$D0
			dc.b $F0,  5,  0,$11,$E0
			dc.b $F0,  5,  0,$11,$F0
			dc.b $F0,  5,  0,$11,  0
			dc.b $F0,  5,  0,$11,$10
			dc.b $F0,  5,  0,$11,$20
			dc.b   0,  5,  0,$15,$D0
			dc.b   0,  5,  0,$15,$E0
			dc.b   0,  5,  0,$15,$F0
			dc.b   0,  5,  0,$15,  0
			dc.b   0,  5,  0,$15,$10
			dc.b   0,  5,  0,$15,$20
byte_20D47F:	dc.b 20						; DATA XREF: ROM:0020D41C↑o
			dc.b $D0,  5,  0, $D,$E0
			dc.b $D0,  5,  0, $D,$F0
			dc.b $D0,  5,  0, $D,  0
			dc.b $D0,  5,  0, $D,$10
			dc.b $E0,  5,  0,$11,$E0
			dc.b $E0,  5,  0,$11,$F0
			dc.b $E0,  5,  0,$11,  0
			dc.b $E0,  5,  0,$11,$10
			dc.b $F0,  5,  0,$15,$E0
			dc.b $F0,  5,  0,$15,$F0
			dc.b $F0,  5,  0,$15,  0
			dc.b $F0,  5,  0,$15,$10
			dc.b   0,  5,  0,$29,$E0
			dc.b   0,  5,  0,$33,$F0
			dc.b   0,  5,  0,$33,  0
			dc.b   0,  5,  0,$33,$10
			dc.b $10,  5,  0,$31,$E0
			dc.b $10,  5,  0,$2B,$F0
			dc.b $10,  5,  0,$2B,  0
			dc.b $10,  5,  0,$2B,$10
			even
byte_20D4E4:	dc.b 20						; DATA XREF: ROM:0020D41E↑o
			dc.b $D0,  5,  0, $D,$E0
			dc.b $D0,  5,  0, $D,$F0
			dc.b $D0,  5,  0, $D,  0
			dc.b $D0,  5,  0, $D,$10
			dc.b $E0,  5,  0,$11,$E0
			dc.b $E0,  5,  0,$11,$F0
			dc.b $E0,  5,  0,$11,  0
			dc.b $E0,  5,  0,$11,$10
			dc.b $F0,  5,  0,$15,$E0
			dc.b $F0,  5,  0,$15,$F0
			dc.b $F0,  5,  0,$15,  0
			dc.b $F0,  5,  0,$15,$10
			dc.b   0,  5,  0,$33,$E0
			dc.b   0,  5,  0,$33,$F0
			dc.b   0,  5,  0,$33,  0
			dc.b   0,  5,  0,$33,$10
			dc.b $10,  5,  0,$2B,$E0
			dc.b $10,  5,  0,$2B,$F0
			dc.b $10,  5,  0,$2B,  0
			dc.b $10,  5,  0,$2B,$10
byte_20D549:	dc.b 10						; DATA XREF: ROM:0020D420↑o
			dc.b $D0,  5,  0, $D,$F0
			dc.b $D0,  5,  0, $D,  0
			dc.b $E0,  5,  0,$11,$F0
			dc.b $E0,  5,  0,$11,  0
			dc.b $F0,  5,  0,$15,$F0
			dc.b $F0,  5,  0,$15,  0
			dc.b   0,  5,  0,$1D,$F0
			dc.b   0,  5,  0,$21,  0
			dc.b $10,  5,  0,$19,$F0
			dc.b $10,  5,  0,$19,  0
			even
byte_20D57C:	dc.b 10						; DATA XREF: ROM:0020D422↑o
			dc.b $D0,  5,  0, $D,$F0
			dc.b $D0,  5,  0, $D,  0
			dc.b $E0,  5,  0,$11,$F0
			dc.b $E0,  5,  0,$11,  0
			dc.b $F0,  5,  0,$15,$F0
			dc.b $F0,  5,  0,$15,  0
			dc.b   0,  5,  0,$21,$F0
			dc.b   0,  5,  8,$1D,  0
			dc.b $10,  5,  0,$19,$F0
			dc.b $10,  5,  0,$19,  0
			even
off_20D5B0: dc.w unk_20D5BC-*			; DATA XREF: ROM:0020D062↑o
										; ROM:0020D266↑o ...
			dc.w unk_20D5BC-off_20D5B0
			dc.w unk_20D5C4-off_20D5B0
			dc.w unk_20D5CA-off_20D5B0
			dc.w unk_20D5D0-off_20D5B0
			dc.w unk_20D5D4-off_20D5B0
unk_20D5BC: dc.b   5					; DATA XREF: ROM:off_20D5B0↑o
										; ROM:0020D5B2↑o
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			even
unk_20D5C4: dc.b   3					; DATA XREF: ROM:0020D5B4↑o
			dc.b   3
			dc.b   1
			dc.b   2
			dc.b   2
			dc.b   2
			even
unk_20D5CA: dc.b   3					; DATA XREF: ROM:0020D5B6↑o
			dc.b   3
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			even
unk_20D5D0: dc.b   1					; DATA XREF: ROM:0020D5B8↑o
			dc.b   3
			dc.b   3
			dc.b   5
			even
unk_20D5D4: dc.b   1					; DATA XREF: ROM:0020D5BA↑o
			dc.b   3
			dc.b   5
			dc.b   4
			even
obj20b_map: dc.w byte_20D5E4-*			; DATA XREF: ROM:0020D300↑o
										; ROM:0020D5DA↓o ...
			dc.w byte_20D5F4-obj20b_map
			dc.w byte_20D60E-obj20b_map
			dc.w byte_20D628-obj20b_map
			dc.w byte_20D642-obj20b_map
			dc.w byte_20D65C-obj20b_map
byte_20D5E4:	dc.b 3						; DATA XREF: ROM:obj20b_map↑o
			dc.b $E0,  5,  0, $D,$F8
			dc.b $F0,  5,  0,$11,$F8
			dc.b   0,  5,  0,$15,$F8
			even
byte_20D5F4:	dc.b 5						; DATA XREF: ROM:0020D5DA↑o
			dc.b $D0,  5,  0, $D,$F8
			dc.b $E0,  5,  0,$11,$F8
			dc.b $F0,  5,  0,$15,$F8
			dc.b   0,  5,  0,$29,$F8
			dc.b $10,  5,  0,$31,$F8
			even
byte_20D60E:	dc.b 5						; DATA XREF: ROM:0020D5DC↑o
			dc.b $D0,  5,  0, $D,$F8
			dc.b $E0,  5,  0,$11,$F8
			dc.b $F0,  5,  0,$15,$F8
			dc.b   0,  5,  0,$33,$F8
			dc.b $10,  5,  0,$2B,$F8
			even
byte_20D628:	dc.b 5						; DATA XREF: ROM:0020D5DE↑o
			dc.b $D0,  5,  0, $D,$F8
			dc.b $E0,  5,  0,$11,$F8
			dc.b $F0,  5,  0,$15,$F8
			dc.b   0,  5,  0,$1D,$F8
			dc.b $10,  5,  0,$19,$F8
			even
byte_20D642:	dc.b 5						; DATA XREF: ROM:0020D5E0↑o
			dc.b $D0,  5,  0, $D,$F8
			dc.b $E0,  5,  0,$11,$F8
			dc.b $F0,  5,  0,$15,$F8
			dc.b   0,  5,  8,$1D,$F8
			dc.b $10,  5,  0,$19,$F8
			even
byte_20D65C:	dc.b 5						; DATA XREF: ROM:0020D5E2↑o
			dc.b $D0,  5,  0, $D,$F8
			dc.b $E0,  5,  0,$11,$F8
			dc.b $F0,  5,  0,$15,$F8
			dc.b   0,  5,  0,$21,$F8
			dc.b $10,  5,  0,$19,$F8
			even
; ---------------------------------------------------------------------------
obj21:									; DATA XREF: ROM:0020352E↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20D68C(pc,d0.w),d0
			jsr	off_20D68C(pc,d0.w)
			jsr	(displaysprite).l
			rts
; ---------------------------------------------------------------------------
off_20D68C: dc.w loc_20D6A4-*			; CODE XREF: ROM:0020D680↑p
										; DATA XREF: ROM:0020D67C↑r ...
			dc.w loc_20D776-off_20D68C
; =============== S U B R O U T I N E =======================================
sub_20D690:								; CODE XREF: ROM:0020D77E↓j
										; ROM:0020D7DE↓j ...
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			subq.w	#4,d4
			jmp	(sub_207F56).l
; End of function sub_20D690
; ---------------------------------------------------------------------------
loc_20D6A4:								; DATA XREF: ROM:off_20D68C↑o
			ori.b	#4,obj.render(a0)
			move.w	#$4000,obj.vram(a0)
			move.b	#3,obj.priority(a0)
			move.w	obj.xpos(a0),obj.field_38(a0)
			move.w	obj.ypos(a0),obj.field_3A(a0)
			move.w	obj.ypos(a0),obj.field_36(a0)
			move.l	#obj21_map,d0
			cmpi.w	#zoneact(zoneid_SPZ,actid_1),(zone).l
			beq.s	loc_20D6EE
			move.l	#obj21b_map,d0
			cmpi.w	#zoneact(zoneid_SPZ,actid_2),(zone).l
			beq.s	loc_20D6EE
			move.l	#obj21b_map,d0
loc_20D6EE:								; CODE XREF: ROM:0020D6D6↑j
										; ROM:0020D6E6↑j
			move.l	d0,obj.mappings(a0)
			move.b	obj.field_28(a0),d0
			move.b	d0,d1
			andi.w	#3,d0
			move.b	d0,obj.frame(a0)
			move.b	byte_20D76E(pc,d0.w),obj.field_19(a0)
			move.b	#4,obj.field_16(a0)
			lsr.b	#2,d1
			andi.w	#3,d1
			move.b	byte_20D772(pc,d1.w),obj.field_2D(a0)
			move.b	obj.field_29(a0),d0
			beq.s	loc_20D768
			jsr	(findfreeobj).l
			beq.s	loc_20D72C
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_20D72C:								; CODE XREF: ROM:0020D724↑j
			move.b	#$A,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			subi.w	#$10,obj.ypos(a1)
			move.b	#$F0,obj.field_39(a1)
			move.w	a0,obj.field_34(a1)
			move.b	obj.field_29(a0),d0
			move.b	d0,d1
			andi.b	#2,d1
			move.b	d1,obj.field_28(a1)
			andi.b	#$F8,d0
			move.b	d0,obj.field_38(a1)
			add.w	d0,obj.xpos(a1)
loc_20D768:								; CODE XREF: ROM:0020D71C↑j
			addq.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
byte_20D76E:	dc.b $10					; DATA XREF: ROM:0020D700↑r
			dc.b $20
			dc.b $30 ; 0
			dc.b   0
			even
byte_20D772:	dc.b $20					; DATA XREF: ROM:0020D712↑r
			dc.b $30 ; 0
			dc.b $40 ; @
			dc.b $60 ; `
			even
; ---------------------------------------------------------------------------
loc_20D776:								; DATA XREF: ROM:0020D68E↑o
			tst.w	(word_FF1278).l
			beq.s	loc_20D782
			bra.w	sub_20D690
; ---------------------------------------------------------------------------
loc_20D782:								; CODE XREF: ROM:0020D77C↑j
			move.b	obj.field_28(a0),d0
			lsr.b	#4,d0
			andi.w	#$F,d0
			add.w	d0,d0
			move.w	off_20D7BA(pc,d0.w),d0
			jsr	off_20D7BA(pc,d0.w)
			move.w	obj.field_38(a0),d0
			andi.w	#$FF80,d0
			move.w	(dword_FFF700).w,d1
			subi.w	#$80,d1
			andi.w	#$FF80,d1
			sub.w	d1,d0
			cmpi.w	#$280,d0
			bls.s	locret_20D7B8
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
locret_20D7B8:							; CODE XREF: ROM:0020D7B0↑j
			rts
; ---------------------------------------------------------------------------
off_20D7BA: dc.w loc_20D7CE-*			; CODE XREF: ROM:0020D792↑p
										; DATA XREF: ROM:0020D78E↑r ...
			dc.w loc_20D7E4-off_20D7BA
			dc.w loc_20D83E-off_20D7BA
			dc.w loc_20D862-off_20D7BA
			dc.w sub_20D888-off_20D7BA
			dc.w loc_20D89C-off_20D7BA
			dc.w loc_20D912-off_20D7BA
			dc.w loc_20D966-off_20D7BA
			dc.w loc_20D9C6-off_20D7BA
			dc.w loc_20DA3E-off_20D7BA
; ---------------------------------------------------------------------------
loc_20D7CE:								; DATA XREF: ROM:off_20D7BA↑o
			addq.b	#1,obj.field_2A(a0)
			jsr	sub_20DAB6(pc)
			add.w	obj.field_3A(a0),d0
			move.w	d0,obj.ypos(a0)
			jmp	(sub_20D690).l
; ---------------------------------------------------------------------------
loc_20D7E4:								; DATA XREF: ROM:0020D7BC↑o
			move.l	obj.xpos(a0),-(sp)
			jsr	sub_20DAB6(pc)
			add.w	obj.field_38(a0),d0
			move.w	d0,obj.xpos(a0)
			addq.b	#1,obj.field_2A(a0)
			moveq	#0,d0
			move.b	obj.field_2C(a0),d0
			asr.b	#1,d0
			add.w	obj.field_3A(a0),d0
			move.w	d0,obj.ypos(a0)
loc_20D808:								; CODE XREF: ROM:0020D85E↓j
										; ROM:0020D884↓j ...
			move.l	(sp)+,d0
			move.l	obj.xpos(a0),d1
			sub.l	d0,d1
			asr.l	#8,d1
			move.w	d1,obj.xvel(a0)
; START OF FUNCTION CHUNK FOR sub_20D888
loc_20D816:								; CODE XREF: sub_20D888+10↓j
										; ROM:0020D9B0↓j
			jsr	sub_20D690(pc)
			beq.s	loc_20D82E
			move.b	obj.field_2C(a0),d0
			cmpi.b	#8,d0
			bcc.s	loc_20D82A
			addq.b	#1,obj.field_2C(a0)
loc_20D82A:								; CODE XREF: sub_20D888-64↑j
			moveq	#1,d0
			rts
; ---------------------------------------------------------------------------
loc_20D82E:								; CODE XREF: sub_20D888-6E↑j
			moveq	#0,d0
			move.b	obj.field_2C(a0),d0
			beq.s	loc_20D83A
			subq.b	#1,obj.field_2C(a0)
loc_20D83A:								; CODE XREF: sub_20D888-54↑j
			moveq	#0,d0
			rts
; END OF FUNCTION CHUNK FOR sub_20D888
; ---------------------------------------------------------------------------
loc_20D83E:								; DATA XREF: ROM:0020D7BE↑o
			move.l	obj.xpos(a0),-(sp)
			addq.b	#1,obj.field_2A(a0)
			jsr	sub_20DAB6(pc)
			add.w	obj.field_3A(a0),d0
			move.w	d0,obj.ypos(a0)
			jsr	sub_20DAB6(pc)
			add.w	obj.field_38(a0),d0
			move.w	d0,obj.xpos(a0)
			bra.w	loc_20D808
; ---------------------------------------------------------------------------
loc_20D862:								; DATA XREF: ROM:0020D7C0↑o
			move.l	obj.xpos(a0),-(sp)
			addq.b	#1,obj.field_2A(a0)
			jsr	sub_20DAB6(pc)
			add.w	obj.field_3A(a0),d0
			move.w	d0,obj.ypos(a0)
			jsr	sub_20DAB6(pc)
			neg.w	d0
			add.w	obj.field_38(a0),d0
			move.w	d0,obj.xpos(a0)
			bra.w	loc_20D808
; =============== S U B R O U T I N E =======================================
sub_20D888:								; CODE XREF: ROM:0020D8A2↓p
										; ROM:0020D8BE↓j ...
; FUNCTION CHUNK AT 0020D816 SIZE 00000028 BYTES
			moveq	#0,d0
			move.b	obj.field_2C(a0),d0
			asr.b	#1,d0
			add.w	obj.field_3A(a0),d0
			move.w	d0,obj.ypos(a0)
			bra.w	loc_20D816
; End of function sub_20D888
; ---------------------------------------------------------------------------
loc_20D89C:								; DATA XREF: ROM:0020D7C4↑o
			move.b	obj.field_2B(a0),d0
			bne.s	loc_20D8B4
			jsr	sub_20D888(pc)
			bne.s	loc_20D8AA
			rts
; ---------------------------------------------------------------------------
loc_20D8AA:								; CODE XREF: ROM:0020D8A6↑j
			move.b	#$1E,obj.field_2E(a0)
			addq.b	#2,obj.field_2B(a0)
loc_20D8B4:								; CODE XREF: ROM:0020D8A0↑j
			move.b	obj.field_2E(a0),d0
			beq.s	loc_20D8C2
			subq.b	#1,obj.field_2E(a0)
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20D8C2:								; CODE XREF: ROM:0020D8B8↑j
			jsr	sub_20D690(pc)
			move.l	obj.ypos(a0),d1
			move.w	obj.yvel(a0),d0
			ext.l	d0
			asl.l	#8,d0
			add.l	d0,d1
			move.l	d1,obj.ypos(a0)
			move.w	obj.yvel(a0),d0
			cmpi.w	#$400,d0
			bcc.s	loc_20D8E8
			addi.w	#$40,obj.yvel(a0)
loc_20D8E8:								; CODE XREF: ROM:0020D8E0↑j
			jsr	(sub_20611C).l
			tst.w	d1
			bpl.s	loc_20D8FC
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
loc_20D8FC:								; CODE XREF: ROM:0020D8F0↑j
			move.w	(dword_FFF704).w,d0
			addi.w	#224,d0
			cmp.w	obj.ypos(a0),d0
			bcc.s	locret_20D910
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
locret_20D910:							; CODE XREF: ROM:0020D908↑j
			rts
; ---------------------------------------------------------------------------
loc_20D912:								; DATA XREF: ROM:0020D7C6↑o
			move.b	obj.field_2B(a0),d0
			andi.w	#$FF,d0
			move.w	off_20D922(pc,d0.w),d0
			jmp	off_20D922(pc,d0.w)
; ---------------------------------------------------------------------------
off_20D922: dc.w loc_20D928-*			; CODE XREF: ROM:0020D91E↑j
										; DATA XREF: ROM:0020D91A↑r ...
			dc.w loc_20D934-off_20D922
			dc.w loc_20D962-off_20D922
; ---------------------------------------------------------------------------
loc_20D928:								; DATA XREF: ROM:off_20D922↑o
			jsr	sub_20D888(pc)
			bne.s	loc_20D930
			rts
; ---------------------------------------------------------------------------
loc_20D930:								; CODE XREF: ROM:0020D92C↑j
			addq.b	#2,obj.field_2B(a0)
loc_20D934:								; DATA XREF: ROM:0020D924↑o
			move.b	obj.field_2A(a0),d0
			cmpi.b	#$40,d0
			bcc.w	loc_20D958
			jsr	sub_20DAB6(pc)
			neg.w	d0
			add.w	obj.field_3A(a0),d0
			move.w	d0,obj.ypos(a0)
			addq.b	#2,obj.field_2A(a0)
			jmp	(sub_20D690).l
; ---------------------------------------------------------------------------
loc_20D958:								; CODE XREF: ROM:0020D93C↑j
			move.w	obj.ypos(a0),obj.field_3A(a0)
			addq.b	#2,obj.field_2B(a0)
loc_20D962:								; DATA XREF: ROM:0020D926↑o
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20D966:								; DATA XREF: ROM:0020D7C8↑o
			move.b	obj.field_2B(a0),d0
			andi.w	#$FF,d0
			move.w	off_20D976(pc,d0.w),d0
			jmp	off_20D976(pc,d0.w)
; ---------------------------------------------------------------------------
off_20D976: dc.w loc_20D97C-*			; CODE XREF: ROM:0020D972↑j
										; DATA XREF: ROM:0020D96E↑r ...
			dc.w loc_20D98E-off_20D976
			dc.w loc_20D9C2-off_20D976
; ---------------------------------------------------------------------------
loc_20D97C:								; DATA XREF: ROM:off_20D976↑o
			jsr	sub_20D888(pc)
			bne.s	loc_20D984
			rts
; ---------------------------------------------------------------------------
loc_20D984:								; CODE XREF: ROM:0020D980↑j
			addq.b	#2,obj.field_2B(a0)
			move.b	#$3C,obj.field_2E(a0)
loc_20D98E:								; DATA XREF: ROM:0020D978↑o
			move.b	obj.field_2E(a0),d0
			beq.s	loc_20D99C
			subq.b	#1,obj.field_2E(a0)
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20D99C:								; CODE XREF: ROM:0020D992↑j
			jsr	(sub_203166).l
			subq.w	#8,obj.yvel(a0)
			jsr	(sub_2062B2).l
			tst.w	d1
			bmi.s	loc_20D9B4
			bra.w	loc_20D816
; ---------------------------------------------------------------------------
loc_20D9B4:								; CODE XREF: ROM:0020D9AE↑j
			sub.w	d1,obj.ypos(a0)
			move.w	obj.ypos(a0),obj.field_3A(a0)
			addq.b	#2,obj.field_2B(a0)
loc_20D9C2:								; DATA XREF: ROM:0020D97A↑o
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20D9C6:								; DATA XREF: ROM:0020D7CA↑o
			move.b	obj.field_2B(a0),d0
			andi.w	#$FF,d0
			move.w	off_20D9D6(pc,d0.w),d0
			jmp	off_20D9D6(pc,d0.w)
; ---------------------------------------------------------------------------
off_20D9D6: dc.w loc_20D9DC-*			; CODE XREF: ROM:0020D9D2↑j
										; DATA XREF: ROM:0020D9CE↑r ...
			dc.w loc_20D9EE-off_20D9D6
			dc.w loc_20DA3A-off_20D9D6
; ---------------------------------------------------------------------------
loc_20D9DC:								; DATA XREF: ROM:off_20D9D6↑o
			jsr	sub_20D888(pc)
			bne.s	loc_20D9E4
			rts
; ---------------------------------------------------------------------------
loc_20D9E4:								; CODE XREF: ROM:0020D9E0↑j
			addq.b	#2,obj.field_2B(a0)
			move.b	#$3C,obj.field_2E(a0)
loc_20D9EE:								; DATA XREF: ROM:0020D9D8↑o
			move.b	obj.field_2E(a0),d0
			beq.s	loc_20D9FC
			subq.b	#1,obj.field_2E(a0)
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20D9FC:								; CODE XREF: ROM:0020D9F2↑j
			move.b	obj.field_2A(a0),d0
			cmpi.b	#$40,d0
			bcc.w	loc_20DA30
			move.l	obj.xpos(a0),-(sp)
			jsr	sub_20DAB6(pc)
			add.w	obj.field_38(a0),d0
			move.w	d0,obj.xpos(a0)
			addq.b	#1,obj.field_2A(a0)
			moveq	#0,d0
			move.b	obj.field_2C(a0),d0
			asr.b	#1,d0
			add.w	obj.field_3A(a0),d0
			move.w	d0,obj.ypos(a0)
			bra.w	loc_20D808
; ---------------------------------------------------------------------------
loc_20DA30:								; CODE XREF: ROM:0020DA04↑j
			move.w	obj.xpos(a0),obj.field_38(a0)
			addq.b	#2,obj.field_2B(a0)
loc_20DA3A:								; DATA XREF: ROM:0020D9DA↑o
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20DA3E:								; DATA XREF: ROM:0020D7CC↑o
			move.b	obj.field_2B(a0),d0
			andi.w	#$FF,d0
			move.w	off_20DA4E(pc,d0.w),d0
			jmp	off_20DA4E(pc,d0.w)
; ---------------------------------------------------------------------------
off_20DA4E: dc.w loc_20DA54-*			; CODE XREF: ROM:0020DA4A↑j
										; DATA XREF: ROM:0020DA46↑r ...
			dc.w loc_20DA66-off_20DA4E
			dc.w loc_20DAB2-off_20DA4E
; ---------------------------------------------------------------------------
loc_20DA54:								; DATA XREF: ROM:off_20DA4E↑o
			jsr	sub_20D888(pc)
			bne.s	loc_20DA5C
			rts
; ---------------------------------------------------------------------------
loc_20DA5C:								; CODE XREF: ROM:0020DA58↑j
			addq.b	#2,obj.field_2B(a0)
			move.b	#$3C,obj.field_2E(a0)
loc_20DA66:								; DATA XREF: ROM:0020DA50↑o
			move.b	obj.field_2E(a0),d0
			beq.s	loc_20DA74
			subq.b	#1,obj.field_2E(a0)
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20DA74:								; CODE XREF: ROM:0020DA6A↑j
			move.b	obj.field_2A(a0),d0
			cmpi.b	#$40,d0
			bcc.s	loc_20DAA8
			move.l	obj.xpos(a0),-(sp)
			jsr	sub_20DAB6(pc)
			neg.w	d0
			add.w	obj.field_38(a0),d0
			move.w	d0,obj.xpos(a0)
			addq.b	#1,obj.field_2A(a0)
			moveq	#0,d0
			move.b	obj.field_2C(a0),d0
			asr.b	#1,d0
			add.w	obj.field_3A(a0),d0
			move.w	d0,obj.ypos(a0)
			bra.w	loc_20D808
; ---------------------------------------------------------------------------
loc_20DAA8:								; CODE XREF: ROM:0020DA7C↑j
			move.w	obj.xpos(a0),obj.field_38(a0)
			addq.b	#2,obj.field_2B(a0)
loc_20DAB2:								; DATA XREF: ROM:0020DA52↑o
			bra.w	sub_20D888
; =============== S U B R O U T I N E =======================================
sub_20DAB6:								; CODE XREF: ROM:0020D7D2↑p
										; ROM:0020D7E8↑p ...
			moveq	#0,d0
			move.b	obj.field_2A(a0),d0
			jsr	(calcsine).l
			moveq	#0,d2
			move.b	obj.field_2D(a0),d2
			muls.w	d2,d0
			lsr.l	#8,d0
			rts
; End of function sub_20DAB6
; ---------------------------------------------------------------------------
obj21_map:	dc.w byte_20DAD4-*			; DATA XREF: ROM:00206B8A↑o
										; ROM:0020D6C8↑o ...
			dc.w byte_20DAEA-obj21_map
			dc.w byte_20DB14-obj21_map
byte_20DAD4:	dc.b 4						; DATA XREF: ROM:obj21_map↑o
			dc.b $F0,  5,  0,  1,$F0
			dc.b $F0,  5,  8,  1,  0
			dc.b   0,  5,  0,  5,$F0
			dc.b   0,  5,  8,  5,  0
			even
byte_20DAEA:	dc.b 8						; DATA XREF: ROM:0020DAD0↑o
			dc.b $F0,  5,  0,  1,$E0
			dc.b $F0,  5,  0,  1,$F0
			dc.b $F0,  5,  0,  1,  0
			dc.b $F0,  5,  0,  1,$10
			dc.b   0,  5,  0,  5,$E0
			dc.b   0,  5,  0,  9,$F0
			dc.b   0,  5,  0,  9,  0
			dc.b   0,  5,  8,  5,$10
			even
byte_20DB14:	dc.b $C						; DATA XREF: ROM:0020DAD2↑o
			dc.b $F0,  5,  0,  1,$D0
			dc.b $F0,  5,  0,  1,$E0
			dc.b $F0,  5,  0,  1,$F0
			dc.b $F0,  5,  0,  1,  0
			dc.b $F0,  5,  0,  1,$10
			dc.b $F0,  5,  0,  1,$20
			dc.b   0,  5,  0,  5,$D0
			dc.b   0,  5,  0,  9,$E0
			dc.b   0,  5,  0,  9,$F0
			dc.b   0,  5,  0,  9,  0
			dc.b   0,  5,  0,  9,$10
			dc.b   0,  5,  8,  5,$20
			even
obj21b_map: dc.w byte_20DB58-*			; DATA XREF: ROM:0020D6D8↑o
										; ROM:0020D6E8↑o ...
			dc.w byte_20DB6E-obj21b_map
			dc.w byte_20DB98-obj21b_map
byte_20DB58:	dc.b 4						; DATA XREF: ROM:obj21b_map↑o
			dc.b $F0,  5,  0,$31,$F0
			dc.b $F0,  5,  8,$31,  0
			dc.b   0,  5,  0,$35,$F0
			dc.b   0,  5,  8,$35,  0
			even
byte_20DB6E:	dc.b 8						; DATA XREF: ROM:0020DB54↑o
			dc.b $F0,  5,  0,$31,$E0
			dc.b $F0,  5,  8,$31,$F0
			dc.b   0,  5,  0,$35,$E0
			dc.b   0,  5,  8,$35,$F0
			dc.b $F0,  5,  0,$31,  0
			dc.b $F0,  5,  8,$31,$10
			dc.b   0,  5,  0,$35,  0
			dc.b   0,  5,  8,$35,$10
			even
byte_20DB98:	dc.b 12						; DATA XREF: ROM:0020DB56↑o
			dc.b $F0,  5,  0,$31,$D0
			dc.b $F0,  5,  8,$31,$E0
			dc.b   0,  5,  0,$35,$D0
			dc.b   0,  5,  8,$35,$E0
			dc.b $F0,  5,  0,$31,$F0
			dc.b $F0,  5,  8,$31,  0
			dc.b   0,  5,  0,$35,$F0
			dc.b   0,  5,  8,$35,  0
			dc.b $F0,  5,  0,$31,$10
			dc.b $F0,  5,  8,$31,$20
			dc.b   0,  5,  0,$35,$10
			dc.b   0,  5,  8,$35,$20
			even
; ---------------------------------------------------------------------------
loc_20DBD6:								; CODE XREF: sub_202F90+40↑j
			lea	word_20DC28(pc),a1
			moveq	#0,d0
			moveq	#0,d1
			move.w	(dword_FFF700).w,d0
loc_20DBE2:								; CODE XREF: sub_202F90+AC58↓j
			cmp.w	(a1)+,d0
			bcs.s	loc_20DBEA
			addq.b	#2,d1
			bra.s	loc_20DBE2
; ---------------------------------------------------------------------------
loc_20DBEA:								; CODE XREF: sub_202F90+AC54↑j
			move.b	d1,(word_FF12F4).l
			move.w	word_20DC40(pc,d1.w),d0
			jmp	(sub_20202E).l

; =============== S U B R O U T I N E =======================================
sub_20DBFA:								; CODE XREF: ROM:loc_20146A↑p
			lea	word_20DC28(pc),a1
			moveq	#0,d0
			moveq	#0,d1
			move.w	(dword_FFF700).w,d0
loc_20DC06:								; CODE XREF: sub_20DBFA+12↓j
			cmp.w	(a1)+,d0
			bcs.s	loc_20DC0E
			addq.b	#2,d1
			bra.s	loc_20DC06
; ---------------------------------------------------------------------------
loc_20DC0E:								; CODE XREF: sub_20DBFA+E↑j
			cmp.b	(word_FF12F4).l,d1
			bne.s	loc_20DC18
			rts
; ---------------------------------------------------------------------------
loc_20DC18:								; CODE XREF: sub_20DBFA+1A↑j
			move.b	d1,(word_FF12F4).l
			move.w	word_20DC34(pc,d1.w),d0
			jmp	(loc_202060).l
; End of function sub_20DBFA
; ---------------------------------------------------------------------------
word_20DC28:
			dc.w $D00
			dc.w $1100
			dc.w $1500
			dc.w $1A00
			dc.w $2000
			dc.w $FFFF

word_20DC34:
			dc.w ddevid_04
			dc.w ddevid_05
			dc.w ddevid_06
			dc.w ddevid_07
			dc.w ddevid_08
			dc.w ddevid_09

word_20DC40:
			dc.w ddevid_0A
			dc.w ddevid_0B
			dc.w ddevid_0C
			dc.w ddevid_0D
			dc.w ddevid_0E
			dc.w ddevid_0F

; =============== S U B R O U T I N E =======================================
sub_20DC4C:								; CODE XREF: ROM:002057A8↑p
										; ROM:00205846↑p ...
			lea	(off_20DC6E).l,a1
			add.w	d0,d0
			move.w	off_20DC6E(pc,d0.w),d4
			lea	off_20DC6E(pc,d4.w),a2
			moveq	#0,d1
			move.b	obj.field_29(a0),d1
			add.w	d1,d1
			move.w	(a2,d1.w),d5
			move.w	d5,2(a0)
			rts
; End of function sub_20DC4C
; ---------------------------------------------------------------------------
off_20DC6E: dc.w word_20DC92-*			; DATA XREF: sub_20DC4C↑o
										; sub_20DC4C+8↑r ...
			dc.w word_20DC94-off_20DC6E
			dc.w word_20DC96-off_20DC6E
			dc.w word_20DC98-off_20DC6E
			dc.w word_20DC9A-off_20DC6E
			dc.w word_20DC9C-off_20DC6E
			dc.w word_20DCA6-off_20DC6E
			dc.w word_20DCA0-off_20DC6E
			dc.w word_20DCA4-off_20DC6E
			dc.w word_20DCA2-off_20DC6E
			dc.w word_20DC9E-off_20DC6E
			dc.w word_20DCA8-off_20DC6E
			dc.w word_20DCAA-off_20DC6E
			dc.w word_20DCAC-off_20DC6E
			dc.w word_20DCAE-off_20DC6E
			dc.w word_20DCB0-off_20DC6E
			dc.w word_20DCB2-off_20DC6E
			dc.w word_20DCB4-off_20DC6E
word_20DC92:	dc.w $23E7					; DATA XREF: ROM:off_20DC6E↑o
word_20DC94:	dc.w $24DC					; DATA XREF: ROM:0020DC70↑o
word_20DC96:	dc.w $245F					; DATA XREF: ROM:0020DC72↑o
word_20DC98:	dc.w $2431					; DATA XREF: ROM:0020DC74↑o
word_20DC9A:	dc.w $23E7					; DATA XREF: ROM:0020DC76↑o
word_20DC9C:	dc.w $4363					; DATA XREF: ROM:0020DC78↑o
word_20DC9E:	dc.w $33A					; DATA XREF: ROM:0020DC82↑o
word_20DCA0:	dc.w $342					; DATA XREF: ROM:0020DC7C↑o
word_20DCA2:	dc.w $431E					; DATA XREF: ROM:0020DC80↑o
word_20DCA4:	dc.w $4495					; DATA XREF: ROM:0020DC7E↑o
word_20DCA6:	dc.w $375					; DATA XREF: ROM:0020DC7A↑o
word_20DCA8:	dc.w $326					; DATA XREF: ROM:0020DC84↑o
word_20DCAA:	dc.w $8357					; DATA XREF: ROM:0020DC86↑o
word_20DCAC:	dc.w $475					; DATA XREF: ROM:0020DC88↑o
word_20DCAE:	dc.w $384					; DATA XREF: ROM:0020DC8A↑o
word_20DCB0:	dc.w $3A1					; DATA XREF: ROM:0020DC8C↑o
word_20DCB2:	dc.w $422					; DATA XREF: ROM:0020DC8E↑o
word_20DCB4:	dc.w 0						; DATA XREF: ROM:0020DC90↑o
; ---------------------------------------------------------------------------
obj24:									; DATA XREF: ROM:0020353A↑o
			moveq	#0,d0
			move.b	obj.field_28(a0),d0
			add.w	d0,d0
			move.w	off_20DCCC(pc,d0.w),d0
			jsr	off_20DCCC(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20DCCC: dc.w loc_20DCD0-*			; CODE XREF: ROM:0020DCC2↑p
										; DATA XREF: ROM:0020DCBE↑r ...
			dc.w loc_20DDCA-off_20DCCC
; ---------------------------------------------------------------------------
loc_20DCD0:								; DATA XREF: ROM:off_20DCCC↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20DCDE(pc,d0.w),d0
			jmp	off_20DCDE(pc,d0.w)
; ---------------------------------------------------------------------------
off_20DCDE: dc.w loc_20DCE4-*			; CODE XREF: ROM:0020DCDA↑j
										; DATA XREF: ROM:0020DCD6↑r ...
			dc.w loc_20DD22-off_20DCDE
			dc.w loc_20DD72-off_20DCDE
; ---------------------------------------------------------------------------
loc_20DCE4:								; DATA XREF: ROM:off_20DCDE↑o
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#8,obj.field_17(a0)
			move.b	#8,obj.field_16(a0)
			move.w	#$3CF,obj.vram(a0)
			move.l	#obj24_map,obj.mappings(a0)
			move.l	obj.xpos(a0),obj.field_2A(a0)
			move.l	obj.ypos(a0),obj.field_2E(a0)
			move.b	#1,obj.field_32(a0)
			rts
; ---------------------------------------------------------------------------
loc_20DD22:								; DATA XREF: ROM:0020DCE0↑o
			move.b	obj.field_32(a0),d0
			jsr	(calcsine).l
			swap	d1
			swap	d0
			asr.l	#1,d1
			asr.l	#1,d0
			add.l	obj.field_2A(a0),d1
			add.l	obj.field_2E(a0),d0
			move.l	d1,obj.xpos(a0)
			move.l	d0,obj.ypos(a0)
			move.w	#$BCF,obj.vram(a0)
			addq.b	#1,obj.field_32(a0)
			cmpi.b	#$7F,obj.field_32(a0)
			bpl.w	loc_20DD6C
loc_20DD58:								; CODE XREF: ROM:0020DD70↓j
										; ROM:0020DDAA↓j ...
			lea	(obj24_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20DD6C:								; CODE XREF: ROM:0020DD54↑j
			addq.b	#2,obj.routine(a0)
			bra.s	loc_20DD58
; ---------------------------------------------------------------------------
loc_20DD72:								; DATA XREF: ROM:0020DCE2↑o
			move.b	obj.field_32(a0),d0
			jsr	(calcsine).l
			swap	d1
			swap	d0
			asr.l	#1,d1
			asr.l	#1,d0
			add.l	obj.field_2A(a0),d1
			add.l	obj.field_2E(a0),d0
			move.l	d1,obj.xpos(a0)
			move.l	d0,obj.ypos(a0)
			move.w	#$3CF,obj.vram(a0)
			addi.b	#-1,obj.field_32(a0)
			cmpi.b	#1,obj.field_32(a0)
			bmi.w	loc_20DDAC
			bra.s	loc_20DD58
; ---------------------------------------------------------------------------
loc_20DDAC:								; CODE XREF: ROM:0020DDA6↑j
			addi.b	#-2,obj.routine(a0)
			bra.s	loc_20DD58
; ---------------------------------------------------------------------------
obj24_ani:	dc.w unk_20DDB6-*			; DATA XREF: ROM:loc_20DD58↑o
unk_20DDB6: dc.b $13					; DATA XREF: ROM:obj24_ani↑o
			dc.b   0
			dc.b   1
			dc.b $FF
			even
obj24_map:	dc.w byte_20DDBE-*			; DATA XREF: ROM:00206C6E↑o
										; ROM:0020DD06↑o ...
			dc.w byte_20DDC4-obj24_map
byte_20DDBE:	dc.b 1						; DATA XREF: ROM:obj24_map↑o
			dc.b $F8,  5,  0,  0,$F8
			even
byte_20DDC4:	dc.b 1						; DATA XREF: ROM:0020DDBC↑o
			dc.b $F8,  5,  0,  4,$F8
			even
; ---------------------------------------------------------------------------
loc_20DDCA:								; DATA XREF: ROM:0020DCCE↑o
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20DDD8(pc,d0.w),d0
			jmp	off_20DDD8(pc,d0.w)
; ---------------------------------------------------------------------------
off_20DDD8: dc.w loc_20DDDE-*			; CODE XREF: ROM:0020DDD4↑j
										; DATA XREF: ROM:0020DDD0↑r ...
			dc.w loc_20DE12-off_20DDD8
			dc.w loc_20DE6E-off_20DDD8
; ---------------------------------------------------------------------------
loc_20DDDE:								; DATA XREF: ROM:off_20DDD8↑o
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#8,obj.field_17(a0)
			move.b	#8,obj.field_16(a0)
			move.w	#$3CF,obj.vram(a0)
			move.l	#obj24b_map,obj.mappings(a0)
			move.l	#$FFFC0000,obj.field_2A(a0)
			rts
; ---------------------------------------------------------------------------
loc_20DE12:								; DATA XREF: ROM:0020DDDA↑o
			move.w	#$3CF,obj.vram(a0)
			addi.l	#$10000,obj.xpos(a0)
			move.l	obj.field_2A(a0),d0
			add.l	d0,obj.ypos(a0)
			move.b	#0,obj.ani(a0)
			addi.l	#$2000,obj.field_2A(a0)
			bmi.w	loc_20DE40
			move.b	#1,obj.ani(a0)
loc_20DE40:								; CODE XREF: ROM:0020DE36↑j
			jsr	(sub_20611C).l
			tst.w	d1
			bmi.w	loc_20DE60
loc_20DE4C:								; CODE XREF: ROM:0020DE6C↓j
										; ROM:0020DEA8↓j ...
			lea	(obj24b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20DE60:								; CODE XREF: ROM:0020DE48↑j
			addq.b	#2,obj.routine(a0)
			move.l	#$FFFC0000,obj.field_2A(a0)
			bra.s	loc_20DE4C
; ---------------------------------------------------------------------------
loc_20DE6E:								; DATA XREF: ROM:0020DDDC↑o
			move.w	#$BCF,obj.vram(a0)
			addi.l	#$FFFF0000,obj.xpos(a0)
			move.l	obj.field_2A(a0),d0
			add.l	d0,obj.ypos(a0)
			move.b	#0,obj.ani(a0)
			addi.l	#$2000,obj.field_2A(a0)
			bmi.w	loc_20DE9C
			move.b	#1,obj.ani(a0)
loc_20DE9C:								; CODE XREF: ROM:0020DE92↑j
			jsr	(sub_20611C).l
			tst.w	d1
			bmi.w	loc_20DEAA
			bra.s	loc_20DE4C
; ---------------------------------------------------------------------------
loc_20DEAA:								; CODE XREF: ROM:0020DEA4↑j
			addi.b	#-2,obj.routine(a0)
			move.l	#$FFFC0000,obj.field_2A(a0)
			bra.s	loc_20DE4C
; ---------------------------------------------------------------------------
obj24b_ani: dc.w unk_20DEBE-obj24b_ani
			dc.w unk_20DEC2-obj24b_ani
unk_20DEBE: dc.b $13					; DATA XREF: ROM:obj24b_ani↑o
			dc.b   1
			dc.b $FF
			even
unk_20DEC2: dc.b $13					; DATA XREF: ROM:0020DEBC↑o
			dc.b   0
			dc.b $FF
			even
obj24b_map: dc.w byte_20DECA-obj24b_map
			dc.w byte_20DED0-obj24b_map
byte_20DECA:	dc.b 1						; DATA XREF: ROM:obj24b_map↑o
			dc.b $F8,  9,  0,  8,$F4
			even
byte_20DED0:	dc.b 1						; DATA XREF: ROM:0020DEC8↑o
			dc.b $F8,  9,  0, $E,$F4
			even
; ---------------------------------------------------------------------------
			include	"Objects/17 - Signpost.asm"
; ---------------------------------------------------------------------------
obj17_ani:
			dc.w unk_20DFCA-obj17_ani
unk_20DFCA:
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b $FF
			even

obj17_map:
			include	"Mappings/Signpost.asm"

sub_20DFF4:
			jmp	(sub_2059B8).l
; ---------------------------------------------------------------------------
lvlheader:
			dc.l ddevid_03<<24+spz_8x8
			dc.l ddevid_02<<24+spz_16x16
			dc.l spz_256x256
			dc.b 0
			dc.b musid_GHZ
			dc.b palid_spz
			dc.b palid_spz
			even

ddev_ptr	macro
\1_ptr:	dc.w \1-divdev_index
	endm

divdev_index:
			ddev_ptr ddev_00
			ddev_ptr ddev_01
			ddev_ptr ddev_02
			ddev_ptr ddev_03
			ddev_ptr ddev_04
			ddev_ptr ddev_05
			ddev_ptr ddev_06
			ddev_ptr ddev_07
			ddev_ptr ddev_08
			ddev_ptr ddev_09
			ddev_ptr ddev_0A
			ddev_ptr ddev_0B
			ddev_ptr ddev_0C
			ddev_ptr ddev_0D
			ddev_ptr ddev_0E
			ddev_ptr ddev_0F
ddev_00:
ddev_03:
			dc.w 1-1
			dc.l spz_8x8
			dc.w 0
ddev_01:
			dc.w 14-1
			dc.l cg_rock
			dc.w $64C0
			dc.l cg_spikes
			dc.w $6740
			dc.l unk_23396C
			dc.w $6840
			dc.l unk_23256A
			dc.w $6AE0
			dc.l unk_231FF4
			dc.w $6C60
			dc.l unk_232190
			dc.w $6EA0
			dc.l unk_2320DA
			dc.w $7080
			dc.l cg_dspring
			dc.w $7420
			dc.l cg_spring
			dc.w $A400
			dc.l cg_hud
			dc.w $AD00
			dc.l cg_monitortimesign
			dc.w $B500
			dc.l cg_explosion
			dc.w $D000
			dc.l cg_flowers
			dc.w $DAC0
			dc.l cg_ring
			dc.w $F5C0
ddev_02:
			dc.w 7-1
			dc.l cg_bridge
			dc.w $63C0
			dc.l cg_flickyricky
			dc.w $79E0
			dc.l unk_2328B2
			dc.w $7CE0
			dc.l unk_2331BE
			dc.w $8620
			dc.l unk_232FDA
			dc.w $8BE0
			dc.l unk_232604
			dc.w $8EA0
			dc.l unk_232CCC
			dc.w $9B80
ddev_04:
			dc.w 2-1
			dc.l unk_2328B2
			dc.w $7CE0
			dc.l unk_2331BE
			dc.w $8620
ddev_05:
			dc.w 4-1
			dc.l cg_bridge
			dc.w $63C0
			dc.l unk_233512
			dc.w $7CE0
			dc.l unk_232FDA
			dc.w $8BE0
			dc.l unk_232604
			dc.w $8EA0
ddev_06:
			dc.w 2-1
			dc.l unk_23227E
			dc.w $8440
			dc.l unk_233AA4
			dc.w $92A0
ddev_07:
			dc.w 2-1
			dc.l unk_233512
			dc.w $7CE0
			dc.l unk_23227E
			dc.w $8440
ddev_08:
			dc.w 6-1
			dc.l cg_bridge
			dc.w $63C0
			dc.l cg_flickyricky
			dc.w $79E0
			dc.l unk_2328B2
			dc.w $7CE0
			dc.l unk_2331BE
			dc.w $8620
			dc.l unk_232FDA
			dc.w $8BE0
			dc.l cg_signpost
			dc.w $A060
ddev_09:
			dc.w 1-1
			dc.l cg_signpost
			dc.w $A060
ddev_0A:
			dc.w 15-1
			dc.l cg_bridge
			dc.w $63C0
			dc.l cg_rock
			dc.w $64C0
			dc.l cg_spikes
			dc.w $6740
			dc.l unk_23396C
			dc.w $6840
			dc.l unk_23256A
			dc.w $6AE0
			dc.l unk_231FF4
			dc.w $6C60
			dc.l unk_232190
			dc.w $6EA0
			dc.l unk_2320DA
			dc.w $7080
			dc.l cg_dspring
			dc.w $7420
			dc.l cg_flickyricky
			dc.w $79E0
			dc.l unk_2328B2
			dc.w $7CE0
			dc.l unk_2331BE
			dc.w $8620
			dc.l unk_232FDA
			dc.w $8BE0
			dc.l unk_232604
			dc.w $8EA0
			dc.l unk_232CCC
			dc.w $9B80
ddev_0B:
			dc.w 14-1
			dc.l cg_bridge
			dc.w $63C0
			dc.l cg_rock
			dc.w $64C0
			dc.l cg_spikes
			dc.w $6740
			dc.l unk_23396C
			dc.w $6840
			dc.l unk_23256A
			dc.w $6AE0
			dc.l unk_231FF4
			dc.w $6C60
			dc.l unk_232190
			dc.w $6EA0
			dc.l unk_2320DA
			dc.w $7080
			dc.l cg_dspring
			dc.w $7420
			dc.l cg_flickyricky
			dc.w $79E0
			dc.l unk_233512
			dc.w $7CE0
			dc.l unk_232FDA
			dc.w $8BE0
			dc.l unk_232604
			dc.w $8EA0
			dc.l unk_232CCC
			dc.w $9B80
ddev_0C:
ddev_0D:
			dc.w 13-1
			dc.l cg_rock
			dc.w $64C0
			dc.l cg_spikes
			dc.w $6740
			dc.l unk_23396C
			dc.w $6840
			dc.l unk_23256A
			dc.w $6AE0
			dc.l unk_231FF4
			dc.w $6C60
			dc.l unk_232190
			dc.w $6EA0
			dc.l unk_2320DA
			dc.w $7080
			dc.l cg_dspring
			dc.w $7420
			dc.l cg_flickyricky
			dc.w $79E0
			dc.l unk_233512
			dc.w $7CE0
			dc.l unk_23227E
			dc.w $8440
			dc.l unk_233AA4
			dc.w $92A0
			dc.l unk_232CCC
			dc.w $9B80
ddev_0E:
			dc.w 14-1
			dc.l cg_bridge
			dc.w $63C0
			dc.l cg_rock
			dc.w $64C0
			dc.l cg_spikes
			dc.w $6740
			dc.l unk_23396C
			dc.w $6840
			dc.l unk_23256A
			dc.w $6AE0
			dc.l unk_231FF4
			dc.w $6C60
			dc.l unk_232190
			dc.w $6EA0
			dc.l unk_2320DA
			dc.w $7080
			dc.l cg_dspring
			dc.w $7420
			dc.l cg_flickyricky
			dc.w $79E0
			dc.l unk_2328B2
			dc.w $7CE0
			dc.l unk_2331BE
			dc.w $8620
			dc.l unk_232FDA
			dc.w $8BE0
			dc.l unk_232CCC
			dc.w $9B80
ddev_0F:
			dc.w 14-1
			dc.l cg_bridge
			dc.w $63C0
			dc.l cg_rock
			dc.w $64C0
			dc.l cg_spikes
			dc.w $6740
			dc.l unk_23396C
			dc.w $6840
			dc.l unk_23256A
			dc.w $6AE0
			dc.l unk_231FF4
			dc.w $6C60
			dc.l unk_232190
			dc.w $6EA0
			dc.l unk_2320DA
			dc.w $7080
			dc.l cg_dspring
			dc.w $7420
			dc.l unk_2328B2
			dc.w $7CE0
			dc.l unk_2331BE
			dc.w $8620
			dc.l unk_232FDA
			dc.w $8BE0
			dc.l unk_232CCC
			dc.w $9B80
			dc.l cg_signpost
			dc.w $A060

			dc.l cg_dspring				; unused
			dc.w $67E0
			dc.l unk_2320DA
			dc.w $6DA0
			dc.l unk_23256A
			dc.w $6EA0
			dc.l unk_231FF4
			dc.w $7020
			dc.l unk_232190
			dc.w $7260
			dc.l cg_rock
			dc.w $7440
			dc.l cg_flickyricky
			dc.w $76C0
			dc.l unk_232FDA
			dc.w $79C0
			dc.l unk_2328B2
			dc.w $7C80
			dc.l unk_232CCC
			dc.w $85C0
			dc.l unk_233512
			dc.w $8C40

			dc.w 12-1
			dc.l cg_spikes
			dc.w $63C0
			dc.l unk_23396C
			dc.w $6540
			dc.l cg_dspring
			dc.w $67E0
			dc.l unk_2320DA
			dc.w $6DA0
			dc.l unk_23256A
			dc.w $6EA0
			dc.l unk_231FF4
			dc.w $7020
			dc.l unk_232190
			dc.w $7260
			dc.l cg_rock
			dc.w $7440
			dc.l cg_flickyricky
			dc.w $76C0
			dc.l unk_232FDA
			dc.w $79C0
			dc.l unk_2328B2
			dc.w $7C80
			dc.l unk_23227E
			dc.w $8D20

			dc.w 13-1
			dc.l cg_spikes
			dc.w $63C0
			dc.l unk_23396C
			dc.w $6540
			dc.l cg_dspring
			dc.w $67E0
			dc.l unk_2320DA
			dc.w $6DA0
			dc.l unk_23256A
			dc.w $6EA0
			dc.l unk_231FF4
			dc.w $7020
			dc.l unk_232190
			dc.w $7260
			dc.l cg_rock
			dc.w $7440
			dc.l cg_flickyricky
			dc.w $76C0
			dc.l unk_232FDA
			dc.w $79C0
			dc.l unk_2328B2
			dc.w $7C80
			dc.l unk_232CCC
			dc.w $85C0
			dc.l unk_233512
			dc.w $8C40

			dc.w 12-1
			dc.l cg_spikes
			dc.w $63C0
			dc.l unk_23396C
			dc.w $6540
			dc.l cg_dspring
			dc.w $67E0
			dc.l unk_2320DA
			dc.w $6DA0
			dc.l unk_23256A
			dc.w $6EA0
			dc.l unk_231FF4
			dc.w $7020
			dc.l unk_232190
			dc.w $7260
			dc.l cg_rock
			dc.w $7440
			dc.l unk_232FDA
			dc.w $79C0
			dc.l unk_2328B2
			dc.w $7C80
			dc.l unk_232CCC
			dc.w $85C0
			dc.l unk_233512
			dc.w $8C40

			incbin	"Leftovers/R11A__.MMD"
			even

chunkbuffer:
			incbin	"Leftovers/Chunks.unc"
			even

			incbin	"Unknown/Unk1.unc"
			even

			align	$10000

cg_player:
			incbin	"Art/Uncompressed/Sonic.unc"
			even

player_map:
			include	"Mappings/Sonic.asm"

dplc_player:
			include	"Mappings/Sonic DPLCs.asm"

unk_22E3AC:
			incbin	"Sound/Z80_3.bin"
			even
unk_22E3AC_end:

unk_22E3E4:
			incbin	"Sound/Z80_2.bin"
			even
unk_22E3E4_end:

unk_22EB40:
			incbin	"Sound/Z80_1.bin"
			even
unk_22EB40_end:

unk_22F628:
			incbin	"Art/Uncompressed/Shield.unc"
			even

unk_22FAA8:
			incbin	"Art/Uncompressed/Invincibility Stars.unc"
			even

unk_22FF28:
			incbin	"Art/Uncompressed/Time Travel Sparkles.unc"
			even

cg_dspring:
			incbin	"Art/Nemesis/Diagonal Spring.nem"
			even

cg_spring:
			incbin	"Art/Nemesis/Spring.nem"
			even

cg_monitortimesign:
			incbin	"Art/Nemesis/Monitor and Time Sign.nem"
			even

cg_explosion:
			incbin	"Art/Nemesis/Explosion.nem"
			even

cg_ring:
			incbin	"Art/Nemesis/Ring.nem"
			even

cg_hudicon:
			incbin	"Art/Uncompressed/HUD Icon.unc"
			even

cg_hudnumbersletters:
			incbin	"Art/Uncompressed/HUD Numbers and Letters.unc"
			even

cg_hud:
			incbin	"Art/Nemesis/HUD.nem"
			even

cg_flowers:
			incbin	"Art/Nemesis/Flowers.nem"
			even

cg_signpost:
			incbin	"Art/Nemesis/Signpost.nem"
			even

cg_rock:
			incbin	"Art/Nemesis/Rock.nem"
			even

unk_231FF4:
			incbin	"Art/Nemesis/Appearing Platform.nem"
			even

unk_2320DA:
			incbin	"Art/Nemesis/Wheels.nem"
			even

unk_232190:
			incbin	"Art/Nemesis/Spinning Platform.nem"
			even

unk_23227E:
			incbin	"Art/Nemesis/Splash.nem"
			even

unk_23256A:
			incbin	"Art/Nemesis/Flipper.nem"
			even

unk_232604:
			incbin	"Art/Nemesis/Splash 2.nem"
			even

unk_2328B2:
			incbin	"Art/Nemesis/Mosqui.nem"
			even

unk_232CCC:
			incbin	"Art/Nemesis/Pata-Bata.nem"
			even

unk_232FDA:
			incbin	"Art/Nemesis/Anton.nem"
			even

unk_2331BE:
			incbin	"Art/Nemesis/Taga-Taga.nem"
			even

unk_233512:
			incbin	"Art/Nemesis/Tamabboh.nem"
			even

unk_23396C:
			incbin	"Art/Nemesis/Elastic Pole.nem"
			even

unk_233AA4:
			incbin	"Art/Nemesis/Rotating Card.nem"
			even

cg_bridge:
			incbin	"Art/Nemesis/Bridge.nem"
			even

			incbin	"Art/Nemesis/Switch.nem"
			even

cg_spikes:
			incbin	"Art/Nemesis/Spikes.nem"
			even

cg_flickyricky:
			incbin	"Art/Nemesis/Flicky and Ricky.nem"
			even

			incbin	"Art/Nemesis/Swallow and Pecky.nem"
			even

			incbin	"Art/Nemesis/Canary and Pocky.nem"
			even

			incbin	"Art/Nemesis/Fish.nem"
			even

			incbin	"Art/Nemesis/Dove and Sheep.nem"
			even

			incbin	"Art/Nemesis/Spinning Platform.nem"
			even

			incbin	"Art/Nemesis/Spikes (Unused).nem"
			even

			incbin	"Art/Nemesis/Spikes (Unused 2).nem"
			even

unk_234A8A:
			incbin	"Collision/Angle Map.bin"
			even

unk_234B8A:
			incbin	"Collision/Collision Array 1.bin"
			even

unk_235B8A:
			incbin	"Collision/Collision Array 2.bin"
			even

spz_collision:
			incbin	"Collision/SPZ.bin"
			even

lvllayout_index:
			dc.w unk_236E8E-lvllayout_index
			dc.w unk_236F30-lvllayout_index
			dc.w unk_236F4E-lvllayout_index
			dc.w unk_236F52-lvllayout_index
			dc.w unk_237140-lvllayout_index
			dc.w unk_23701A-lvllayout_index
			dc.w unk_23701E-lvllayout_index
			dc.w unk_237140-lvllayout_index
			dc.w unk_237140-lvllayout_index
			dc.w unk_237144-lvllayout_index
			dc.w unk_237144-lvllayout_index
			dc.w unk_237144-lvllayout_index
			dc.w unk_236E8E-lvllayout_index
			dc.w unk_236F30-lvllayout_index
			dc.w unk_236F4E-lvllayout_index
			dc.w unk_236F52-lvllayout_index
			dc.w unk_237140-lvllayout_index
			dc.w unk_23701A-lvllayout_index
			dc.w unk_23701E-lvllayout_index
			dc.w unk_237140-lvllayout_index
			dc.w unk_237140-lvllayout_index
			dc.w unk_237144-lvllayout_index
			dc.w unk_237144-lvllayout_index
			dc.w unk_237144-lvllayout_index
			dc.w unk_236E8E-lvllayout_index
			dc.w unk_236F30-lvllayout_index
			dc.w unk_236F4E-lvllayout_index
			dc.w unk_236F52-lvllayout_index
			dc.w unk_237140-lvllayout_index
			dc.w unk_23701A-lvllayout_index
			dc.w unk_23701E-lvllayout_index
			dc.w unk_237140-lvllayout_index
			dc.w unk_237140-lvllayout_index
			dc.w unk_237144-lvllayout_index
			dc.w unk_237144-lvllayout_index
			dc.w unk_237144-lvllayout_index

unk_236E8E:
			incbin	"Layout/Foreground.bin"
			even
unk_236F30:
			incbin	"Layout/Background.bin"
			even
unk_236F4E:
			dc.l 0
unk_236F52:
			incbin	"Layout/GHZ2 Foreground (Sonic 1).bin"
			even
unk_23701A:
			dc.l 0
unk_23701E:
			incbin	"Layout/GHZ3 Foreground (Sonic 1).bin"
			even
unk_237140:
			dc.l 0
unk_237144:
			dc.l 0

spz_16x16:	incbin	"Blocks/Blocks.nem"
			even

spz_8x8:	incbin	"Art/Nemesis/8x8 - SPZ.nem"
			even

spz_256x256:
			incbin	"Chunks/Chunks.kos"
			even

			incbin	"Leftovers/Chunks.kos"
			even

			incbin	"Unknown/Unk2.kos"
			even

			incbin	"Unknown/Unk3.unc"
			even

	objend