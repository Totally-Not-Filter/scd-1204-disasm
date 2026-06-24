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
MMD_ERROR:
			jmp	(error).l
; ---------------------------------------------------------------------------
MMD_HINT:
			jmp	(hint).l
; ---------------------------------------------------------------------------
MMD_VINT:
			jmp	(vint).l
; ---------------------------------------------------------------------------
error:
			nop
			nop
			bra.s	error
; ---------------------------------------------------------------------------
init:
			btst	#6,(cont_3).l
			beq.s	loc_200136
			cmpi.l	#"init",(init_f).l
			beq.w	loc_200162
loc_200136:
			lea	(stackwk).l,a6
			moveq	#0,d7
			move.w	#(stackwk_end-stackwk)/4-1,d6
loc_200142:
			move.l	d7,(a6)+
			dbf	d6,loc_200142

			move.b	(version).l,d0
			andi.b	#$C0,d0
			move.b	d0,(mdstatus).l
			move.l	#"init",(init_f).l
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
			lea	(spz_pal_cycle).l,a0
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
spz_pal_cycle:
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
.loop:
			move.l	(a2)+,(a3)+
			dbf	d7,.loop

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
.loop:
			move.l	(a2)+,(a3)+
			dbf	d7,.loop

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
			move.b	obj.height(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.width(a0),d0
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
			move.b	obj.height(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.width(a0),d0
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
			move.b	obj.width(a0),d0
			ext.w	d0
			neg.w	d0
			add.w	d0,d2
			move.b	obj.height(a0),d0
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
			move.b	obj.width(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.height(a0),d0
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
			move.b	obj.height(a0),d0
			ext.w	d0
			sub.w	d0,d2
			eori.w	#$F,d2
			move.b	obj.width(a0),d0
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
			move.b	obj.height(a0),d0
			ext.w	d0
			sub.w	d0,d2
			eori.w	#$F,d2
			move.b	obj.width(a0),d0
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
			move.b	obj.width(a0),d0
			ext.w	d0
			sub.w	d0,d2
			move.b	obj.height(a0),d0
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
			move.b	obj.width(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.height(a0),d0
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
			move.l	#chunkwk,d1
			lea	(lvllayoutwk).w,a1
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
			cmpi.l	#chunkwk,d1
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
			cmpi.l	#chunkwk,d1
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
			cmpi.l	#chunkwk,d1
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
			cmpi.l	#chunkwk,d1
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
			tst.w	(lvl_reset).l
			beq.s	loc_201256
			move.w	#0,(lvl_reset).l
			rts
; ---------------------------------------------------------------------------
loc_20122C:
			bsr.w	sub_2002C2
			cmpi.w	#2,(lvl_reset).l
			bne.s	loc_201244
			move.w	#0,(lvl_reset).l
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
			move.w	#(byte_FFF800-dword_FFF700)/4-1,d1
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
			move.b	#objid_1C,(byte_FFD080).w
			move.b	#objid_1C,(byte_FFD0C0).w
			move.b	#1,(byte_FFD0C0+obj.subtype).w
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
			move.w	d0,(lvl_reset).l
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
			tst.w	(lvl_reset).l
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
			moveq	#objid_01,d0
			tst.b	(byte_FF1219).l
			beq.s	loc_201490
			lea	(byte_FFD040).w,a1
			moveq	#objid_02,d0
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
			move.b	#objid_1F,obj.id(a2)
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
			subq.b	#1,(ring_time).l
			bpl.s	loc_20155E
			move.b	#7,(ring_time).l
			addq.b	#1,(ring_frame).l
			andi.b	#3,(ring_frame).l
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
			btst	#6,(mdstatus).l
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
			btst	#6,(mdstatus).l
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
			tst.w	(generictimer).w
			beq.w	locret_201788
			subq.w	#1,(generictimer).w
locret_201788:
			rts
; ---------------------------------------------------------------------------
vint04:
			bsr.w	sub_201B1A
			bsr.w	sub_202A76
			bsr.w	sub_2020F0
			tst.w	(generictimer).w
			beq.w	locret_2017A2
			subq.w	#1,(generictimer).w
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
			DMA68K	hscrollwk,(hscrollwk_end-hscrollwk),4,hscroll_vram
			DMA68K	byte_FFF800,(byte_FFF800_end-byte_FFF800),4,sprtbl_vram
			lea	(actwk).w,a0
			bsr.w	sub_20532E
			tst.b	(byte_FFF767).w
			beq.s	loc_201892
			DMA68K	playwrtwk,(playwrtwk_end-playwrtwk),4,$780<<5
			move.b	#0,(byte_FFF767).w
loc_201892:
			lea	(byte_FFD040).w,a0
			bsr.w	sub_20532E
			tst.b	(byte_FFF767).w
			beq.s	loc_2018CA
			DMA68K	playwrtwk,(playwrtwk_end-playwrtwk),4,$797<<5
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
			tst.w	(generictimer).w
			beq.w	locret_201928
			subq.w	#1,(generictimer).w
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
			DMA68K	hscrollwk,(hscrollwk_end-hscrollwk),4,hscroll_vram
			DMA68K	byte_FFF800,(byte_FFF800_end-byte_FFF800),4,sprtbl_vram
			lea	(actwk).w,a0
			bsr.w	sub_20532E
			tst.b	(byte_FFF767).w
			beq.s	loc_201A0A
			DMA68K	playwrtwk,(playwrtwk_end-playwrtwk),4,$780<<5
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
			DMA68K	byte_FFF800,(byte_FFF800_end-byte_FFF800),4,sprtbl_vram
			DMA68K	hscrollwk,(hscrollwk_end-hscrollwk),4,hscroll_vram
			jsr	(STARTZ80BUS).l
			lea	(actwk).w,a0
			bsr.w	sub_20532E
			tst.b	(byte_FFF767).w
			beq.s	loc_201B0C
			DMA68K	playwrtwk,(playwrtwk_end-playwrtwk),4,$780<<5
			move.b	#0,(byte_FFF767).w
loc_201B0C:
			tst.w	(generictimer).w
			beq.w	locret_201B18
			subq.w	#1,(generictimer).w
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
			DMA68K	byte_FFF800,(byte_FFF800_end-byte_FFF800),4,sprtbl_vram
			DMA68K	hscrollwk,(hscrollwk_end-hscrollwk),4,hscroll_vram
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
			move.b	d0,(cont_1).l
			move.b	d0,(cont_2).l
			move.b	d0,(cont_3).l
			bra.w	STARTZ80BUS
; End of function initjoypads
; =============== S U B R O U T I N E =======================================
readjoypads:
			lea	(word_FFF604).w,a0
			lea	(port_1).l,a1
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

			lea	(hscrollwk).w,a1
			moveq	#0,d0
			move.w	#(hscrollwk_end_padded-hscrollwk)/4,d1
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

			include	"Decompression/BitDev.asm"
			include	"Decompression/MapDev.asm"
			include	"Decompression/UnLZE.asm"

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

			lea	(hscrollwk).w,a1
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
sub_202716:
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
loc_202742:
			bset	#3,(dword_FFF754).w
locret_202748:
			rts
; End of function sub_202716
; =============== S U B R O U T I N E =======================================
sub_20274A:
			move.w	obj.xpos(a6),d0
			sub.w	(dword_FFF700).w,d0
			subi.w	#$90,d0
			blt.s	loc_20278E
			subi.w	#$10,d0
			bge.s	loc_202764
			clr.w	(word_FFF73A).w
			rts
; ---------------------------------------------------------------------------
loc_202764:
			cmpi.w	#16,d0
			blt.s	loc_20276E
			move.w	#16,d0
loc_20276E:
			add.w	(dword_FFF700).w,d0
			cmp.w	(dword_FFF728+2).w,d0
			blt.s	loc_20277C
			move.w	(dword_FFF728+2).w,d0
loc_20277C:
			move.w	d0,d1
			sub.w	(dword_FFF700).w,d1
			asl.w	#8,d1
			move.w	d0,(dword_FFF700).w
			move.w	d1,(word_FFF73A).w
			rts
; ---------------------------------------------------------------------------
loc_20278E:
			cmpi.w	#-16,d0
			bge.s	loc_202798
			move.w	#-16,d0
loc_202798:
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
loc_2027B2:
			move.w	#2,d0
			bra.s	loc_202764
; =============== S U B R O U T I N E =======================================
sub_2027B8:
			moveq	#0,d1
			move.w	obj.ypos(a6),d0
			sub.w	(dword_FFF704).w,d0
			btst	#2,obj.status(a6)
			beq.s	loc_2027CC
			subq.w	#5,d0
loc_2027CC:
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
loc_2027EC:
			sub.w	(word_FFF73E).w,d0
			bne.s	loc_2027FE
			tst.b	(byte_FFF75C).w
			bne.s	loc_20284A
loc_2027F8:
			clr.w	(word_FFF73C).w
			rts
; ---------------------------------------------------------------------------
loc_2027FE:
			cmpi.w	#$60,(word_FFF73E).w
			bne.s	loc_202826
			move.w	obj.inertia(a6),d1
			bpl.s	loc_20280E
			neg.w	d1
loc_20280E:
			cmpi.w	#$800,d1
			bcc.s	loc_202838
			move.w	#$600,d1
			cmpi.w	#6,d0
			bgt.s	loc_202898
			cmpi.w	#-6,d0
			blt.s	loc_202862
			bra.s	loc_202850
; ---------------------------------------------------------------------------
loc_202826:
			move.w	#$200,d1
			cmpi.w	#2,d0
			bgt.s	loc_202898
			cmpi.w	#-2,d0
			blt.s	loc_202862
			bra.s	loc_202850
; ---------------------------------------------------------------------------
loc_202838:
			move.w	#$1000,d1
			cmpi.w	#$10,d0
			bgt.s	loc_202898
			cmpi.w	#-$10,d0
			blt.s	loc_202862
			bra.s	loc_202850
; ---------------------------------------------------------------------------
loc_20284A:
			moveq	#0,d0
			move.b	d0,(byte_FFF75C).w
loc_202850:
			moveq	#0,d1
			move.w	d0,d1
			add.w	(dword_FFF704).w,d1
			tst.w	d0
			bpl.w	loc_2028A2
			bra.w	loc_20286E
; ---------------------------------------------------------------------------
loc_202862:
			neg.w	d1
			ext.l	d1
			asl.l	#8,d1
			add.l	(dword_FFF704).w,d1
			swap	d1
loc_20286E:
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
loc_202892:
			move.w	(dword_FFF72C).w,d1
			bra.s	loc_2028C6
; ---------------------------------------------------------------------------
loc_202898:
			ext.l	d1
			asl.l	#8,d1
			add.l	(dword_FFF704).w,d1
			swap	d1
loc_2028A2:
			cmp.w	(dword_FFF72C+2).w,d1
			blt.s	loc_2028C6
			subi.w	#$800,d1
			bcs.s	loc_2028C2
			andi.w	#$7FF,obj.ypos(a6)
			subi.w	#$800,(dword_FFF704).w
			andi.w	#$3FF,(dword_FFF70C).w
			bra.s	loc_2028C6
; ---------------------------------------------------------------------------
loc_2028C2:
			move.w	(dword_FFF72C+2).w,d1
loc_2028C6:
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
loc_202902:
			bset	#1,(dword_FFF754).w
locret_202908:
			rts
; End of function sub_2027B8
; =============== S U B R O U T I N E =======================================
sub_20290A:
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
loc_202938:
			bset	#3,(dword_FFF754+2).w
loc_20293E:
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
loc_20296C:
			bset	#1,(dword_FFF754+2).w
locret_202972:
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
loc_2029A2:
			bset	#5,(dword_FFF754+2).w
locret_2029A8:
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
loc_2029D2:
			bset	#1,(dword_FFF754+2).w
locret_2029D8:
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
loc_202A06:
			addq.b	#1,d6
			bset	d6,(dword_FFF754+2).w
locret_202A0C:
			rts
; =============== S U B R O U T I N E =======================================
sub_202A0E:
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
loc_202A3A:
			addq.b	#1,d6
			bset	d6,(word_FFF758).w
locret_202A40:
			rts
; End of function sub_202A0E
; =============== S U B R O U T I N E =======================================
sub_202A42:
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
loc_202A6E:
			addq.b	#1,d6
			bset	d6,(word_FFF75A).w
locret_202A74:
			rts
; End of function sub_202A42
; =============== S U B R O U T I N E =======================================
sub_202A76:
			lea	(vdpctrl).l,a5
			lea	(vdpdata).l,a6
			lea	(dword_FFF754+2).w,a2
			lea	(dword_FFF708).w,a3
			lea	(lvllayoutwk+$40).w,a4
			move.w	#$6000,d2
			bsr.w	sub_202B60
			lea	(word_FFF758).w,a2
			lea	(dword_FFF710).w,a3
			bra.w	nullsub_1
; End of function sub_202A76
; =============== S U B R O U T I N E =======================================
sub_202AA2:
			lea	(vdpctrl).l,a5
			lea	(vdpdata).l,a6
			lea	(dword_FF1330+2).l,a2
			lea	(dword_FF1318).l,a3
			lea	(lvllayoutwk+$40).w,a4
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
			lea	(lvllayoutwk).w,a4
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
loc_202B14:
			bclr	#1,(a2)
			beq.s	loc_202B2E
			move.w	#224,d4
			moveq	#-16,d5
			bsr.w	sub_202E6E
			move.w	#224,d4
			moveq	#-16,d5
			bsr.w	sub_202C48
loc_202B2E:
			bclr	#2,(a2)
			beq.s	loc_202B44
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	sub_202E6E
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	sub_202C9E
loc_202B44:
			bclr	#3,(a2)
			beq.s	locret_202B5E
			moveq	#-16,d4
			move.w	#320,d5
			bsr.w	sub_202E6E
			moveq	#-16,d4
			move.w	#320,d5
			bsr.w	sub_202C9E
locret_202B5E:
			rts
; End of function sub_202AA2
; =============== S U B R O U T I N E =======================================
sub_202B60:
			lea	(unk_202F26).l,a0
			adda.w	#1,a0
			moveq	#-16,d4
			bclr	#0,(a2)
			bne.s	loc_202B7C
			bclr	#1,(a2)
			beq.s	loc_202BC6
			move.w	#224,d4
loc_202B7C:
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
loc_202BAE:
			moveq	#0,d5
			move.l	a0,-(sp)
			movem.l d4-d5,-(sp)
			bsr.w	sub_202E70
			movem.l (sp)+,d4-d5
			moveq	#$1F,d6
			bsr.w	sub_202C74
			movea.l (sp)+,a0
loc_202BC6:
			tst.b	(a2)
			bne.s	loc_202BCC
			rts
; ---------------------------------------------------------------------------
loc_202BCC:
			moveq	#-16,d4
			moveq	#-16,d5
			move.b	(a2),d0
			andi.b	#$A8,d0
			beq.s	loc_202BE0
			lsr.b	#1,d0
			move.b	d0,(a2)
			move.w	#320,d5
loc_202BE0:
			move.w	(dword_FFF70C).w,d0
			andi.w	#$FFF0,d0
			asr.w	#4,d0
			suba.w	#1,a0
			lea	(a0,d0.w),a0
			bra.w	loc_202C06
; ---------------------------------------------------------------------------
off_202BF6:
			dc.l dword_FF1318
			dc.l dword_FF1318
			dc.l byte_FF1320
			dc.l byte_FF1328
; ---------------------------------------------------------------------------
loc_202C06:
			moveq	#$F,d6
			move.l	#$800000,d7
loc_202C0E:
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
loc_202C38:
			addi.w	#$10,d4
			dbf	d6,loc_202C0E
			clr.b	(a2)
			rts
; End of function sub_202B60
; =============== S U B R O U T I N E =======================================
nullsub_1:

			rts
; End of function nullsub_1
; =============== S U B R O U T I N E =======================================
nullsub_2:
			rts
; End of function nullsub_2
; =============== S U B R O U T I N E =======================================
sub_202C48:
			moveq	#$15,d6
loc_202C4A:
			move.l	#$800000,d7
			move.l	d0,d1
loc_202C52:
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
sub_202C74:
			move.l	#$800000,d7
			move.l	d0,d1
loc_202C7C:
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
sub_202C9E:
			moveq	#$F,d6
			move.l	#$800000,d7
			move.l	d0,d1
loc_202CA8:
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
sub_202CCC:

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
loc_202CE8:
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
loc_202D08:
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
loc_202D2A:
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
sub_202D4A:
			add.w	(a3),d5
; End of function sub_202D4A
; =============== S U B R O U T I N E =======================================
sub_202D4C:
			add.w	4(a3),d4
loc_202D50:
			lea	(blkwk).w,a1
			move.w	d4,d3
			lsr.w	#1,d3
			andi.w	#$380,d3
			lsr.w	#3,d5
			move.w	d5,d0
			lsr.w	#5,d0
			andi.w	#$7F,d0
			add.w	d3,d0
			move.l	#chunkwk,d3
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
locret_202D98:
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
			move.l	#chunkwk,d3
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
sub_202DD2:
			move.l	a0,-(sp)
			lea	(lvllayoutwk).w,a4
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
loc_202DFE:
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
loc_202E26:
			movea.l (sp)+,a0
			rts
; End of function sub_202DD2
; =============== S U B R O U T I N E =======================================
sub_202E2A:
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
loc_202E6A:

			moveq	#1,d0
			rts
; End of function sub_202E2A
; =============== S U B R O U T I N E =======================================
sub_202E6E:
			add.w	(a3),d5
; End of function sub_202E6E
; =============== S U B R O U T I N E =======================================
sub_202E70:
			add.w	4(a3),d4
loc_202E74:
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
sub_202EA6:
			lea	(vdpctrl).l,a5
			lea	(vdpdata).l,a6
			lea	(dword_FFF700).w,a3
			lea	(lvllayoutwk).w,a4
			move.w	#$4000,d2
			bsr.s	sub_202ED0
			lea	(dword_FFF708).w,a3
			lea	(lvllayoutwk+$40).w,a4
			move.w	#$6000,d2
			bra.w	loc_202EF8
; End of function sub_202EA6
; =============== S U B R O U T I N E =======================================
sub_202ED0:
			moveq	#-16,d4
			moveq	#16-1,d6
loc_202ED4:
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

loc_202EF8:
			moveq	#-16,d4
			moveq	#16-1,d6
loc_202EFC:
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
; ---------------------------------------------------------------------------
unk_202F26: dc.b   0

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
			even
off_202F48:
			dc.l dword_FFF708&$FFFFFF
			dc.l dword_FFF708&$FFFFFF
			dc.l dword_FFF710&$FFFFFF
			dc.l dword_FFF718&$FFFFFF
; =============== S U B R O U T I N E =======================================
sub_202F58:
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
loc_202F7A:
			moveq	#0,d5
			movem.l d4-d5,-(sp)
			bsr.w	sub_202E70
			movem.l (sp)+,d4-d5
			moveq	#$20-1,d6
			bsr.w	sub_202C74
locret_202F8E:
			rts
; End of function sub_202F58
; =============== S U B R O U T I N E =======================================
sub_202F90:
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
			lea	(chunkwk).l,a1
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
loc_202FD6:
			moveq	#0,d0
			move.b	(a2),d0
			beq.s	locret_202FE0
			bsr.w	sub_20202E
locret_202FE0:
			rts
; End of function sub_202F90
; =============== S U B R O U T I N E =======================================
layoutload:
			lea	(lvllayoutwk).w,a3
			move.w	#(lvllayoutwk_end-lvllayoutwk)/2-1,d1
			moveq	#0,d0
loc_202FEC:
			move.l	d0,(a3)+
			dbf	d1,loc_202FEC

			lea	(lvllayoutwk).w,a3
			moveq	#0,d1
			bsr.w	sub_203002
			lea	(lvllayoutwk+$40).w,a3
			moveq	#2,d1
; End of function layoutload
; =============== S U B R O U T I N E =======================================
sub_203002:
			moveq	#0,d0
			add.w	d1,d0
			lea	(lvllayout_index).l,a1
			move.w	(a1,d0.w),d0
			lea	(a1,d0.w),a1
			moveq	#0,d1
			move.w	d1,d2
			move.b	(a1)+,d1
			move.b	(a1)+,d2
loc_20301C:
			move.w	d1,d0
			movea.l a3,a0
loc_203020:
			move.b	(a1)+,(a0)+
			dbf	d0,loc_203020

			lea	$80(a3),a3
			dbf	d2,loc_20301C

			rts
; End of function sub_203002
; =============== S U B R O U T I N E =======================================
sub_203030:
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
loc_20306A:
			add.w	d1,(dword_FFF72C+2).w
			move.b	#1,(byte_FFF75C).w
locret_203074:
			rts
; ---------------------------------------------------------------------------
loc_203076:
			move.w	(dword_FFF704).w,d0
			addq.w	#8,d0
			cmp.w	(dword_FFF72C+2).w,d0
			bcs.s	loc_20308E
			btst	#1,obj.status(a6)
			beq.s	loc_20308E
			add.w	d1,d1
			add.w	d1,d1
loc_20308E:
			add.w	d1,(dword_FFF72C+2).w
			move.b	#1,(byte_FFF75C).w
			rts
; End of function sub_203030
; ---------------------------------------------------------------------------
off_20309A:
			dc.w loc_2030AA-off_20309A
			dc.w loc_2030AA-off_20309A
			dc.w loc_2030CA-off_20309A
			dc.w loc_2030EA-off_20309A
			dc.w loc_2030EA-off_20309A
			dc.w loc_2030EA-off_20309A
			dc.w loc_2030EA-off_20309A
			dc.w loc_2030EA-off_20309A
; ---------------------------------------------------------------------------
loc_2030AA:
			moveq	#0,d0
			move.b	(act).l,d0
			add.w	d0,d0
			move.w	off_2030BC(pc,d0.w),d0
			jmp	off_2030BC(pc,d0.w)
; ---------------------------------------------------------------------------
off_2030BC:
			dc.w loc_2030C2-off_2030BC
			dc.w loc_2030C2-off_2030BC
			dc.w loc_2030C2-off_2030BC
; ---------------------------------------------------------------------------
loc_2030C2:
			move.w	#$310,(dword_FFF724+2).w
			rts
; ---------------------------------------------------------------------------
loc_2030CA:
			moveq	#0,d0
			move.b	(act).l,d0
			add.w	d0,d0
			move.w	off_2030DC(pc,d0.w),d0
			jmp	off_2030DC(pc,d0.w)
; ---------------------------------------------------------------------------
off_2030DC:
			dc.w loc_2030E2-off_2030DC
			dc.w loc_2030E2-off_2030DC
			dc.w loc_2030E2-off_2030DC
; ---------------------------------------------------------------------------
loc_2030E2:
			move.w	#$510,(dword_FFF724+2).w
			rts
; ---------------------------------------------------------------------------
loc_2030EA:
			move.w	#$710,(dword_FFF724+2).w
			rts
; =============== S U B R O U T I N E =======================================
sub_2030F2:
			lea	(actwk).w,a0
			moveq	#(byte_FFD800_end-actwk)/obj-1,d7
			moveq	#0,d0
loc_2030FA:
			move.b	(a0),d0
			beq.s	loc_203110
			add.w	d0,d0
			add.w	d0,d0
			lea	(off_2034AE).l,a1
			movea.l -4(a1,d0.w),a1
			jsr	(a1)
			moveq	#0,d0
loc_203110:
			lea	obj(a0),a0
			dbf	d7,loc_2030FA
			rts
; End of function sub_2030F2
; ---------------------------------------------------------------------------
			moveq	#(byte_FFD800-actwk)/obj-1,d7
			bsr.s	loc_2030FA
			moveq	#$1800/obj-1,d7
loc_203120:
			moveq	#0,d0
			move.b	(a0),d0
			beq.s	loc_203130
			tst.b	obj.render(a0)
			bpl.s	loc_203130
			bsr.w	displaysprite
loc_203130:
			lea	obj(a0),a0
			dbf	d7,loc_203120
			rts
; =============== S U B R O U T I N E =======================================
sub_20313A:
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
sub_203166:
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
			cmpi.b	#objid_1E,obj.id(a1)
			bne.s	loc_2031A2
			move.w	#-$100,d1
			btst	#0,obj.status(a1)
			beq.s	loc_2031A0
			neg.w	d1
loc_2031A0:
			add.w	d1,d0
loc_2031A2:
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
displaysprite:
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
			move.b	obj.height(a0),d0
			move.w	obj.ypos(a0),d3
			sub.w	(dword_FFF704).w,d3
			move.w	d3,d1
			add.w	d0,d1
			bmi.s	locret_203220
			move.w	d3,d1
			sub.w	d0,d1
			cmpi.w	#224,d1
			bge.s	locret_203220
loc_203204:
			lea	(spr_list).w,a1
			move.w	obj.priority(a0),d0
			lsr.w	#1,d0
			andi.w	#$380,d0
			adda.w	d0,a1
			cmpi.w	#$7E,(a1)
			bcc.s	locret_203220
			addq.w	#2,(a1)
			adda.w	(a1),a1
			move.w	a0,(a1)
locret_203220:
			rts
; End of function displaysprite
; ---------------------------------------------------------------------------
			lea	(spr_list).w,a2
			move.w	obj.priority(a1),d0
			lsr.w	#1,d0
			andi.w	#$380,d0
			adda.w	d0,a2
			cmpi.w	#$7E,(a2)
			bcc.s	locret_20323E
			addq.w	#2,(a2)
			adda.w	(a2),a2
			move.w	a1,(a2)
locret_20323E:
			rts
; ---------------------------------------------------------------------------
deleteobj:
			movea.l a0,a1
			moveq	#0,d1
			moveq	#obj/4-1,d0
loc_203246:
			move.l	d1,(a1)+
			dbf	d0,loc_203246

			rts
; ---------------------------------------------------------------------------
dword_20324E:
			dc.l 0
			dc.l dword_FFF700&$FFFFFF
			dc.l dword_FFF708&$FFFFFF
			dc.l dword_FFF718&$FFFFFF
; =============== S U B R O U T I N E =======================================
sub_20325E:
			lea	(byte_FFF800).w,a2
			moveq	#0,d5
			lea	(spr_list).w,a4
			moveq	#7,d7
loc_20326A:
			tst.w	(a4)
			beq.w	loc_203302
			moveq	#2,d6
loc_203272:
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
			move.b	obj.height(a0),d0
			move.w	obj.ypos(a0),d2
			sub.w	4(a1),d2
			addi.w	#128,d2
			bra.s	loc_2032D2
; ---------------------------------------------------------------------------
loc_2032B0:
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
loc_2032D2:
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
loc_2032F0:
			bsr.w	sub_203324
loc_2032F4:
			bset	#7,obj.render(a0)
loc_2032FA:
			addq.w	#2,d6
			subq.w	#2,(a4)
			bne.w	loc_203272
loc_203302:
			lea	$80(a4),a4
			dbf	d7,loc_20326A

			move.b	d5,(byte_FFF62C).w
			cmpi.b	#80,d5
			beq.s	loc_20331C
			move.l	#0,(a2)
			rts
; ---------------------------------------------------------------------------
loc_20331C:
			move.b	#0,-5(a2)
			rts
; End of function sub_20325E
; =============== S U B R O U T I N E =======================================
sub_203324:
			movea.w obj.vram(a0),a3
			btst	#0,d4
			bne.s	loc_20336A
			btst	#1,d4
			bne.w	loc_2033B8
loc_203336:
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
loc_203362:
			move.w	d0,(a2)+
			dbf	d1,loc_203336

locret_203368:
			rts
; ---------------------------------------------------------------------------
loc_20336A:
			btst	#1,d4
			bne.w	loc_2033FE
loc_203372:
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
loc_2033B0:
			move.w	d0,(a2)+
			dbf	d1,loc_203372

locret_2033B6:
			rts
; ---------------------------------------------------------------------------
loc_2033B8:
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
loc_2033F6:
			move.w	d0,(a2)+
			dbf	d1,loc_2033B8

locret_2033FC:
			rts
; ---------------------------------------------------------------------------
loc_2033FE:
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
loc_20344A:
			move.w	d0,(a2)+
			dbf	d1,loc_2033FE

locret_203450:
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
loc_203476:
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
loc_2034AA:
			moveq	#1,d0
			rts
; ---------------------------------------------------------------------------

obj_ptr	macro
\1_ptr:
	dc.l \1
	endm

off_2034AE:
			obj_ptr obj01
			obj_ptr obj02
			obj_ptr obj03
			obj_ptr obj04
			obj_ptr obj05
			obj_ptr obj06
			obj_ptr obj07
			obj_ptr obj08
			obj_ptr obj09
			obj_ptr obj0A
			obj_ptr obj0B
			obj_ptr obj0C
			obj_ptr obj0D
			obj_ptr obj0E
			obj_ptr obj0F
			obj_ptr obj10
			obj_ptr obj11
			obj_ptr obj12
			obj_ptr obj13
			obj_ptr obj14
			obj_ptr obj15
			obj_ptr obj16
			obj_ptr obj17
			obj_ptr obj18
			obj_ptr obj19
			obj_ptr obj1A
			obj_ptr obj1B
			obj_ptr obj1C
			obj_ptr obj1D
			obj_ptr obj1E
			obj_ptr obj1F
			obj_ptr obj20
			obj_ptr obj21
			obj_ptr obj22
			obj_ptr obj23
			obj_ptr obj24
			obj_ptr obj25
			obj_ptr obj26
			obj_ptr obj27
			obj_ptr obj28
			obj_ptr obj29
; ---------------------------------------------------------------------------
objNull:
obj1D:
obj1E:
obj25:
			move.b	#objid_00,(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_203558:
			lea	(word_FFF780).w,a1
			cmpi.b	#objid_01,obj.id(a0)
			beq.s	loc_203568
			lea	(word_FFF782).w,a1
loc_203568:
			cmpi.b	#5,obj.ani(a0)
			beq.s	loc_203576
			move.w	#0,(a1)
			rts
; ---------------------------------------------------------------------------
loc_203576:
			tst.w	(a1)
			bne.s	loc_203580
			move.b	#1,obj.render(a1)
loc_203580:
			cmpi.w	#$2A30,(a1)
			bcs.s	locret_2035AE
			move.w	#0,(a1)
			move.b	#$2B,obj.ani(a0)
			move.w	#-$500,obj.yvel(a0)
			move.w	#$100,obj.xvel(a0)
			btst	#0,obj.status(a0)
			beq.s	loc_2035A8
			neg.w	obj.xvel(a0)
loc_2035A8:
			move.w	#0,obj.inertia(a0)
locret_2035AE:
			rts
; End of function sub_203558
; =============== S U B R O U T I N E =======================================
sub_2035B0:
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
loc_2035DC:
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
locret_203614:
			rts
; End of function sub_2035B0
; ---------------------------------------------------------------------------
obj01:
obj02:
			move.b	obj.field_2A(a0),d0
			beq.s	loc_20362C
			addq.b	#1,d0
			cmpi.b	#60,d0
			bcs.s	loc_203628
			move.b	#60,d0
loc_203628:
			move.b	d0,obj.field_2A(a0)
loc_20362C:
			bsr.s	sub_2035B0
			clr.b	obj.field_29(a0)
			moveq	#0,d0
			move.b	obj.id(a0),d0
			subq.b	#1,d0
			cmp.b	(byte_FF1219).l,d0
			bne.s	loc_203648
			move.b	#1,obj.field_29(a0)
loc_203648:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_203656(pc,d0.w),d1
			jmp	off_203656(pc,d1.w)
; ---------------------------------------------------------------------------
off_203656: dc.w loc_2036BE-off_203656
			dc.w loc_203CB8-off_203656
			dc.w loc_204CF2-off_203656
			dc.w loc_204D5E-off_203656
			dc.w loc_204DBA-off_203656
; ---------------------------------------------------------------------------
			tst.b	obj.field_29(a0)
			beq.s	locret_203674
			move.b	#1,(byte_FF122C).l
			move.b	#3,(byte_FFD180).w
locret_203674:
			rts
; ---------------------------------------------------------------------------

loc_203676:
			tst.b	(byte_FFD300).w
			bne.s	locret_2036BA
			tst.b	obj.field_29(a0)
			beq.s	locret_2036BA
			move.b	#1,(byte_FF122F).l
			move.b	#objid_03,(byte_FFD300).w
			move.b	#5,(byte_FFD300+obj.ani).w
			move.b	#objid_03,(byte_FFD340).w
			move.b	#6,(byte_FFD340+obj.ani).w
			move.b	#objid_03,(byte_FFD380).w
			move.b	#7,(byte_FFD380+obj.ani).w
			move.b	#objid_03,(byte_FFD3C0).w
			move.b	#8,(byte_FFD3C0+obj.ani).w
locret_2036BA:

			rts
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_2036BE:
			addq.b	#2,obj.routine(a0)
			move.b	#$13,obj.height(a0)
			move.b	#9,obj.width(a0)
			tst.b	(chibi_flag).w
			beq.s	loc_2036E0
			move.b	#$A,obj.height(a0)
			move.b	#5,obj.width(a0)
loc_2036E0:
			move.l	#player_map,obj.mappings(a0)
			move.w	#$780,obj.vram(a0)
			cmpi.b	#objid_01,obj.id(a0)
			beq.s	loc_2036FC
			move.w	#$797,obj.vram(a0)
loc_2036FC:
			move.b	#2,obj.priority(a0)
			move.b	#$18,obj.field_19(a0)
			move.b	#4,obj.render(a0)
			move.w	#$600,(word_FFF760).w
			move.w	#$C,(word_FFF762).w
			move.w	#$80,(word_FFF764).w
; =============== S U B R O U T I N E =======================================
sub_203720:
			tst.b	(zone).l
			bne.s	locret_203786
			move.b	(word_FF1204+1).l,d0
			andi.b	#3,d0
			bne.s	locret_203786
			move.b	obj.height(a0),d2
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
			move.b	#objid_0E,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			moveq	#1,d0
			tst.w	obj.xvel(a0)
			bmi.s	loc_20377E
			moveq	#0,d0
loc_20377E:
			move.b	d0,obj.render(a1)
			move.b	d0,obj.status(a1)
locret_203786:
			rts
; ---------------------------------------------------------------------------
locret_203788:
			rts
; End of function sub_203720
; ---------------------------------------------------------------------------
			move.b	obj.height(a0),d2
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
loc_2037A8:
			cmpi.b	#$21,d1
			bne.s	locret_203786
			cmpi.w	#$2A0,d2
			bcc.s	locret_203786
			cmpi.w	#$298,d2
			bcs.s	locret_203786
loc_2037BA:
			tst.w	obj.inertia(a0)
			beq.s	locret_203786
			jsr	(findfreeobj).l
			bne.s	locret_203786
			move.b	#objid_0B,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			andi.w	#$FFF8,d2
			move.w	d2,obj.ypos(a1)
			move.b	#1,obj.subtype(a1)
			move.w	obj.inertia(a0),d0
			bpl.s	loc_2037EA
			neg.w	d0
loc_2037EA:
			cmpi.w	#$600,d0
			bcc.s	loc_2037F6
			move.b	#2,obj.subtype(a1)
loc_2037F6:
			move.w	#$A1,d0
			jmp	(queuesound2).l
; =============== S U B R O U T I N E =======================================
sub_203800:
			move.w	d2,d0
			lsr.w	#1,d0
			andi.w	#$380,d0
			move.w	d3,d1
			lsr.w	#8,d1
			andi.w	#$7F,d1
			add.w	d1,d0
			move.l	#chunkwk,d1
			lea	(lvllayoutwk).w,a1
			move.b	(a1,d0.w),d1
			andi.b	#$7F,d1
			rts
; End of function sub_203800
; =============== S U B R O U T I N E =======================================
sub_203826:
			cmpi.b	#zoneid_MZ,(zone).l
			beq.s	loc_203832
			rts
; ---------------------------------------------------------------------------
loc_203832:
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
			move.b	obj.height(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.width(a0),d0
			ext.w	d0
			sub.w	d0,d3
			bsr.w	sub_203954
			bne.s	locret_20389A
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.height(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.width(a0),d0
			ext.w	d0
			add.w	d0,d3
			bra.w	sub_203954
; ---------------------------------------------------------------------------
locret_20389A:
			rts
; ---------------------------------------------------------------------------
loc_20389C:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.height(a0),d0
			ext.w	d0
			sub.w	d0,d2
			move.b	obj.width(a0),d0
			ext.w	d0
			sub.w	d0,d3
			bsr.w	sub_203954
			bne.s	locret_2038D6
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.height(a0),d0
			ext.w	d0
			sub.w	d0,d2
			move.b	obj.width(a0),d0
			ext.w	d0
			add.w	d0,d3
			bra.w	sub_203954
; ---------------------------------------------------------------------------
locret_2038D6:
			rts
; ---------------------------------------------------------------------------
loc_2038D8:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.width(a0),d0
			ext.w	d0
			add.w	d0,d3
			move.b	obj.height(a0),d0
			subq.b	#6,d0
			ext.w	d0
			sub.w	d0,d2
			bsr.w	sub_203954
			bne.s	locret_203914
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.width(a0),d0
			ext.w	d0
			add.w	d0,d3
			move.b	obj.height(a0),d0
			ext.w	d0
			add.w	d0,d2
			bra.w	sub_203954
; ---------------------------------------------------------------------------
locret_203914:
			rts
; ---------------------------------------------------------------------------
loc_203916:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.width(a0),d0
			ext.w	d0
			sub.w	d0,d3
			move.b	obj.height(a0),d0
			subq.b	#6,d0
			ext.w	d0
			sub.w	d0,d2
			bsr.w	sub_203954
			bne.s	locret_203952
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			move.b	obj.width(a0),d0
			ext.w	d0
			sub.w	d0,d3
			move.b	obj.height(a0),d0
			ext.w	d0
			add.w	d0,d2
			bra.w	sub_203954
; ---------------------------------------------------------------------------
locret_203952:
			rts
; End of function sub_203826
; =============== S U B R O U T I N E =======================================
sub_203954:
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
loc_203978:
			add.w	d1,d1
			move.w	off_203998(pc,d1.w),d1
			lea	off_203998(pc,d1.w),a1
			moveq	#0,d6
			move.w	(a1)+,d6
			moveq	#0,d1
loc_203988:
			cmp.w	(a1,d1.w),d0
			beq.s	loc_203A0C
			addq.w	#2,d1
			dbf	d6,loc_203988

loc_203994:
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
off_203998:
			dc.w word_2039C2-off_203998
			dc.w word_2039A0-off_203998
			dc.w word_2039EA-off_203998
			dc.w word_2039C8-off_203998
word_2039A0:
			dc.w 16-1
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
word_2039C2:
			dc.w 2-1
			dc.w $145
			dc.w $146
word_2039C8:
			dc.w 16-1
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
word_2039EA:
			dc.w 16-1
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
loc_203A0C:
			move.b	#0,(byte_FF1886).l
			move.w	off_203A2C(pc,d1.w),d0
			jsr	off_203A2C(pc,d0.w)
			tst.b	(byte_FF1886).l
			beq.s	loc_203A28
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_203A28:
			moveq	#1,d0
			rts
; End of function sub_203954
; ---------------------------------------------------------------------------
off_203A2C:
			dc.w loc_203A4C-off_203A2C
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
loc_203A4C:
			andi.w	#$FFF0,d2
			tst.b	d1
			bne.s	loc_203A58
			addi.w	#$10,d2
loc_203A58:
			andi.w	#$FFF0,d3
			btst	#$B,d4
			bne.s	loc_203A66
			addi.w	#$10,d3
loc_203A66:
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
loc_203ADA:
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
loc_203B14:
			bset	#1,obj.status(a0)
			bclr	#4,obj.status(a0)
			bclr	#5,obj.status(a0)
			clr.b	obj.field_3C(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_203B2C:
			move.w	#$700,d0
			tst.w	obj.yvel(a0)
			bmi.s	loc_203B38
			neg.w	d0
loc_203B38:
			move.w	d0,obj.yvel(a0)
			bra.s	loc_203B14
; End of function sub_203B2C
; =============== S U B R O U T I N E =======================================
sub_203B3E:
			move.w	#$700,d0
			tst.w	obj.xvel(a0)
			bmi.s	loc_203B4A
			neg.w	d0
loc_203B4A:
			move.w	d0,obj.xvel(a0)
			bra.s	loc_203B14
; End of function sub_203B3E
; =============== S U B R O U T I N E =======================================
sub_203B50:
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
sub_203B88:
			move.w	d3,d1
			andi.w	#$F,d1
			cmpi.b	#8,d1
			bcc.s	loc_203B9C
			btst	#$B,d4
			bne.s	sub_203B3E
			bra.s	sub_203B2C
; ---------------------------------------------------------------------------
loc_203B9C:
			btst	#$B,d4
			bne.s	sub_203B2C
			bra.s	sub_203B3E
; End of function sub_203B88
; =============== S U B R O U T I N E =======================================
sub_203BA4:
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
loc_203BC6:
			cmp.b	(a1,d3.w),d2
			bcc.s	loc_203BD6
			move.b	#1,(byte_FF1886).l
			rts
; ---------------------------------------------------------------------------
loc_203BD6:
			move.w	obj.xvel(a0),d1
			move.w	obj.yvel(a0),d2
			jsr	(calcangle).l
			addi.b	#$80,d0
			neg.b	d0
			subi.b	#$20,d0
			btst	#$B,d4
			beq.s	loc_203BF8
			addi.b	#$40,d0
loc_203BF8:
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
off_203C16:
			dc.w unk_203C1C-off_203C16
			dc.w unk_203C2C-off_203C16
			dc.w unk_203C3C-off_203C16
unk_203C1C:
			dc.b   1
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
			even

unk_203C2C:
			dc.b   6
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
			even

unk_203C3C:
			dc.b  $B
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
			even
; ---------------------------------------------------------------------------
loc_203C4C:
			move.w	d3,d1
			andi.w	#$F,d1
			cmpi.b	#8,d1
			bcc.s	loc_203C64
			btst	#$B,d4
			bne.w	sub_203B3E
			bra.w	sub_203BA4
; ---------------------------------------------------------------------------
loc_203C64:
			btst	#$B,d4
			bne.w	sub_203B2C
			bra.w	sub_203BA4
; ---------------------------------------------------------------------------
loc_203C70:
			move.w	d3,d1
			andi.w	#$F,d1
			cmpi.b	#8,d1
			bcc.s	loc_203C88
			btst	#$B,d4
			bne.w	sub_203B2C
			bra.w	sub_203B50
; ---------------------------------------------------------------------------
loc_203C88:
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
loc_203CAC:
			btst	#$C,d4
			bne.w	sub_203B50
			bra.w	sub_203B3E
; ---------------------------------------------------------------------------
loc_203CB8:
			bsr.w	sub_203720
			tst.w	(word_FF13FA).l
			beq.s	loc_203CD6
			btst	#4,(word_FFF604+1).w
			beq.s	loc_203CD6
			move.b	#1,(word_FF1208).l
			rts
; ---------------------------------------------------------------------------
loc_203CD6:
			tst.b	(byte_FFF7CC).w
			bne.s	loc_203CF0
			move.w	(word_FFF604).w,(word_FFF602).w
			cmpi.b	#objid_01,obj.id(a0)
			beq.s	loc_203CF0
			move.w	(word_FFF606).w,(word_FFF602).w
loc_203CF0:
			btst	#0,obj.field_2C(a0)
			bne.s	loc_203D0E
			moveq	#0,d0
			move.b	obj.status(a0),d0
			andi.w	#6,d0
			move.w	off_203D52(pc,d0.w),d1
			jsr	off_203D52(pc,d1.w)
			bsr.w	sub_203826
loc_203D0E:
			bsr.s	sub_203D60
			tst.b	obj.field_29(a0)
			beq.s	loc_203D1A
			bsr.w	sub_203E5A
loc_203D1A:
			move.b	(byte_FFF768).w,obj.field_36(a0)
			move.b	(byte_FFF76A).w,obj.field_37(a0)
			tst.b	(byte_FFF7C7).w
			beq.s	loc_203D38
			tst.b	obj.ani(a0)
			bne.s	loc_203D38
			move.b	obj.prevani(a0),obj.ani(a0)
loc_203D38:
			bsr.w	sub_204EF4
			tst.b	obj.field_2C(a0)
			bmi.s	loc_203D48
			jsr	(sub_2063B8).l
loc_203D48:
			bsr.w	sub_204E18
			bsr.w	sub_203E16
			rts
; ---------------------------------------------------------------------------
off_203D52:
			dc.w loc_203FB2-off_203D52
			dc.w loc_20401A-off_203D52
			dc.w loc_204048-off_203D52
			dc.w loc_20406C-off_203D52

unk_203D5A:
			dc.b musid_GHZ
			dc.b musid_LZ
			dc.b musid_MZ
			dc.b musid_SLZ
			dc.b musid_SYZ
			dc.b musid_SBZ
			even
; =============== S U B R O U T I N E =======================================
sub_203D60:
			cmpi.w	#$D2,(word_FFF786).w
			bcc.s	loc_203D8C
			move.w	obj.field_30(a0),d0
			beq.s	loc_203D76
			subq.w	#1,obj.field_30(a0)
			lsr.w	#3,d0
			bcc.s	loc_203D8C
loc_203D76:
			tst.b	obj.field_29(a0)
			bne.s	loc_203D86
			btst	#0,(dword_FF120C+3).l
			beq.s	loc_203D8C
loc_203D86:
			jsr	(displaysprite).l
loc_203D8C:
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
loc_203DC4:
			lea	(unk_203D5A).l,a1
			move.b	(a1,d0.w),d0
			jsr	(queuesound1).l
loc_203DD4:
			move.b	#0,(byte_FF122D).l
loc_203DDC:
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
locret_203E14:

			rts
; End of function sub_203D60
; =============== S U B R O U T I N E =======================================
sub_203E16:
			tst.b	obj.field_29(a0)
			bne.s	locret_203E58
			move.w	(dword_FFF700).w,d0
			subi.w	#$80,d0
			bcs.s	loc_203E2E
			cmp.w	obj.xpos(a0),d0
			bhi.w	deleteobj
loc_203E2E:
			addi.w	#$240,d0
			cmp.w	obj.xpos(a0),d0
			blt.w	deleteobj
			move.w	(dword_FFF704).w,d0
			subi.w	#$60,d0
			bcs.s	loc_203E4C
			cmp.w	obj.ypos(a0),d0
			bhi.w	deleteobj
loc_203E4C:
			addi.w	#$180,d0
			cmp.w	obj.ypos(a0),d0
			blt.w	deleteobj
locret_203E58:
			rts
; End of function sub_203E16
; =============== S U B R O U T I N E =======================================
sub_203E5A:
			move.w	(word_FFF7A8).w,d0
			lea	(playposiwk).w,a1
			lea	(a1,d0.w),a1
			move.w	obj.xpos(a0),(a1)+
			move.w	obj.ypos(a0),(a1)+
			addq.b	#4,(word_FFF7A8+1).w
			rts
; End of function sub_203E5A
; =============== S U B R O U T I N E =======================================
sub_203E74:
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
sub_203F00:
			tst.b	obj.field_2A(a0)
			bne.w	locret_203FB0
			tst.b	(byte_FFF784).w
			beq.w	locret_203FB0
			move.w	(word_FFF760).w,d2
			moveq	#0,d0
			move.w	obj.inertia(a0),d0
			bpl.s	loc_203F1E
			neg.w	d0
loc_203F1E:
			tst.w	(word_FFF786).w
			bne.s	loc_203F2A
			move.w	#1,(word_FFF786).w
loc_203F2A:
			move.w	(word_FFF786).w,d1
			cmpi.w	#$E6,d1
			bcs.s	loc_203F40
			move.b	#1,(lvl_reset).l
			bra.w	loc_205400
; ---------------------------------------------------------------------------
loc_203F40:
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
loc_203F66:
			cmpi.b	#3,d0
			bcs.s	loc_203F6E
			moveq	#2,d0
loc_203F6E:
			bset	#7,d0
			move.b	d0,(byte_FF123D).l
			bsr.w	sub_203E74
			move.b	#2,(byte_FF1230).l
locret_203F84:
			rts
; ---------------------------------------------------------------------------
loc_203F86:
			cmpi.w	#$5A,d1
			bcc.s	loc_203F9E
			cmp.w	d2,d0
			bcc.w	loc_203676
			clr.w	(word_FFF786).w
			clr.b	(byte_FF122F).l
			rts
; ---------------------------------------------------------------------------
loc_203F9E:
			cmp.w	d2,d0
			bcc.s	locret_203FB0
			clr.w	(word_FFF786).w
			clr.b	(byte_FFF784).w
			clr.b	(byte_FF122F).l
locret_203FB0:
			rts
; End of function sub_203F00
; ---------------------------------------------------------------------------
loc_203FB2:
			tst.b	(byte_FFF75F).w
			beq.s	loc_203FC4
			cmpi.b	#5,obj.ani(a0)
			bne.s	locret_204018
			clr.b	(byte_FFF75F).w
loc_203FC4:
			bsr.w	sub_203558
			cmpi.b	#$2B,obj.ani(a0)
			bne.s	loc_203FF2
			tst.b	(chibi_flag).w
			beq.s	loc_203FE0
			cmpi.b	#$79,obj.frame(a0)
			bne.s	locret_204018
			bra.s	loc_203FE8
; ---------------------------------------------------------------------------
loc_203FE0:
			cmpi.b	#$17,obj.frame(a0)
			bne.s	locret_204018
loc_203FE8:
			bsr.w	sub_20477E
			jmp	(sub_20313A).l
; ---------------------------------------------------------------------------
loc_203FF2:
			bsr.w	sub_203F00
			bsr.w	sub_20484C
			bsr.w	sub_2049B0
			bsr.w	sub_20409A
			bsr.w	sub_2047DC
			bsr.w	sub_20477E
			jsr	(sub_203166).l
			bsr.w	sub_200A9E
			bsr.w	sub_204A2E
locret_204018:
			rts
; ---------------------------------------------------------------------------
loc_20401A:
			bsr.w	sub_203F00
			bsr.w	sub_20496E
			bsr.w	sub_2046BC
			bsr.w	sub_20477E
			jsr	(sub_20313A).l
			btst	#6,obj.status(a0)
			beq.s	loc_20403E
			subi.w	#$28,obj.yvel(a0)
loc_20403E:
			bsr.w	sub_204A70
			bsr.w	sub_204A8C
			rts
; ---------------------------------------------------------------------------
loc_204048:
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
loc_20406C:
			bsr.w	sub_203F00
			bsr.w	sub_20496E
			bsr.w	sub_2046BC
			bsr.w	sub_20477E
			jsr	(sub_20313A).l
			btst	#6,obj.status(a0)
			beq.s	loc_204090
			subi.w	#$28,obj.yvel(a0)
loc_204090:
			bsr.w	sub_204A70
			bsr.w	sub_204A8C
			rts
; =============== S U B R O U T I N E =======================================
sub_20409A:
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
loc_2040C2:
			btst	#3,(word_FFF602).w
			beq.s	loc_2040CE
			bsr.w	sub_204498
loc_2040CE:
			move.b	obj.angle(a0),d0
			addi.b	#$20,d0
			andi.b	#$C0,d0
			bne.w	loc_204330
			tst.w	obj.inertia(a0)
			beq.s	loc_2040EC
			tst.b	obj.field_2A(a0)
			beq.w	loc_204330
loc_2040EC:
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
			cmpi.b	#objid_1E,obj.id(a1)
			bne.s	loc_204128
			move.b	#0,obj.ani(a0)
			bra.w	loc_204330
; ---------------------------------------------------------------------------
loc_204128:
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
loc_204148:
			jsr	(sub_20611C).l
			cmpi.w	#$C,d1
			blt.s	loc_20417C
			cmpi.b	#3,obj.field_36(a0)
			bne.s	loc_204164
loc_20415C:
			bclr	#0,obj.status(a0)
			bra.s	loc_204172
; ---------------------------------------------------------------------------
loc_204164:
			cmpi.b	#3,obj.field_37(a0)
			bne.s	loc_20417C
loc_20416C:
			bset	#0,obj.status(a0)
loc_204172:
			move.b	#6,obj.ani(a0)
			bra.w	loc_204330
; ---------------------------------------------------------------------------
loc_20417C:
			tst.b	obj.field_29(a0)
			beq.w	loc_2041E4
			move.b	(byte_FFF788).w,d0
			andi.b	#$F,d0
			beq.s	loc_204198
			addq.b	#1,(byte_FFF788).w
			andi.b	#$CF,(byte_FFF788).w
loc_204198:
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
loc_2041D0:
			btst	#0,(word_FFF602+1).w
			beq.w	loc_2041E4
			move.b	#1,(byte_FFF788).w
			bra.w	loc_204354
; ---------------------------------------------------------------------------
loc_2041E4:
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
loc_20420A:
			add.w	d0,obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_204210:
			move.b	(word_FFF602+1).w,d0
			andi.b	#$70,d0
			beq.s	loc_204220
			move.b	#1,obj.field_2A(a0)
loc_204220:
			bra.w	loc_204354
; ---------------------------------------------------------------------------
loc_204224:
			cmpi.b	#$3C,obj.field_2A(a0)
			beq.s	loc_20423A
			move.b	#0,obj.field_2A(a0)
			move.w	#0,obj.inertia(a0)
			bra.s	loc_20428C
; ---------------------------------------------------------------------------
loc_20423A:
			move.b	#$3D,obj.field_2A(a0)
			move.w	(word_FFF760).w,d6
			move.w	(word_FFF762).w,d5
			move.w	(word_FFF764).w,d4
			btst	#0,obj.status(a0)
			bne.s	loc_20425C
			bsr.w	sub_204498
			bra.w	loc_204330
; ---------------------------------------------------------------------------
loc_20425C:
			bsr.w	sub_204410
			bra.w	loc_204330
; ---------------------------------------------------------------------------
loc_204264:
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
loc_20428C:
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
loc_2042B6:
			btst	#1,(word_FFF602+1).w
			beq.s	loc_2042C8
			move.b	#1,(byte_FFF788).w
			bra.w	loc_204354
; ---------------------------------------------------------------------------
loc_2042C8:
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
loc_2042FE:
			move.w	#$9C,d0
			jsr	(queuesound2).l
			bsr.w	sub_204804
loc_20430C:
			bra.s	loc_204354
; ---------------------------------------------------------------------------
loc_20430E:
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
loc_204330:
			cmpi.w	#$60,(word_FFF73E).w
			bne.s	loc_20434A
			move.b	(byte_FFF788).w,d0
			andi.b	#$F,d0
			bne.s	loc_204354
			move.b	#0,(byte_FFF788).w
			bra.s	loc_204354
; ---------------------------------------------------------------------------
loc_20434A:
			bcc.s	loc_204350
			addq.w	#4,(word_FFF73E).w
loc_204350:
			subq.w	#2,(word_FFF73E).w
loc_204354:
			move.b	(word_FFF602).w,d0
			andi.b	#$C,d0
			bne.s	loc_204380
			move.w	obj.inertia(a0),d0
			beq.s	loc_204380
			bmi.s	loc_204374
			sub.w	d5,d0
			bcc.s	loc_20436E
			move.w	#0,d0
loc_20436E:
			move.w	d0,obj.inertia(a0)
			bra.s	loc_204380
; ---------------------------------------------------------------------------
loc_204374:
			add.w	d5,d0
			bcc.s	loc_20437C
			move.w	#0,d0
loc_20437C:
			move.w	d0,obj.inertia(a0)
loc_204380:
			move.b	obj.angle(a0),d0
			jsr	(calcsine).l
			muls.w	obj.inertia(a0),d1
			asr.l	#8,d1
			move.w	d1,obj.xvel(a0)
			muls.w	obj.inertia(a0),d0
			asr.l	#8,d0
			move.w	d0,obj.yvel(a0)
loc_20439E:
			move.b	obj.angle(a0),d0
			addi.b	#$40,d0
			bmi.s	locret_20440E
			move.b	#$40,d1
			tst.w	obj.inertia(a0)
			beq.s	locret_20440E
			bmi.s	loc_2043B6
			neg.w	d1
loc_2043B6:
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
loc_2043F2:
			sub.w	d1,obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_2043F8:
			sub.w	d1,obj.xvel(a0)
			bset	#5,obj.status(a0)
			move.w	#0,obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_20440A:
			add.w	d1,obj.yvel(a0)
locret_20440E:
			rts
; End of function sub_20409A
; =============== S U B R O U T I N E =======================================
sub_204410:
			move.w	obj.inertia(a0),d0
			beq.s	loc_204418
			bpl.s	loc_204460
loc_204418:
			tst.b	obj.field_2A(a0)
			beq.s	loc_204434
			cmpi.b	#$3D,obj.field_2A(a0)
			bne.s	locret_204496
			bset	#2,(word_FFF602).w
			lsl.w	#7,d5
			move.b	#0,obj.field_2A(a0)
loc_204434:
			bset	#0,obj.status(a0)
			bne.s	loc_204448
			bclr	#5,obj.status(a0)
			move.b	#1,obj.prevani(a0)
loc_204448:
			sub.w	d5,d0
			move.w	d6,d1
			neg.w	d1
			cmp.w	d1,d0
			bgt.s	loc_204454
			move.w	d1,d0
loc_204454:
			move.w	d0,obj.inertia(a0)
			move.b	#0,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_204460:
			sub.w	d4,d0
			bcc.s	loc_204468
			move.w	#-$80,d0
loc_204468:
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
locret_204496:
			rts
; End of function sub_204410
; =============== S U B R O U T I N E =======================================
sub_204498:
			move.w	obj.inertia(a0),d0
			bmi.s	loc_2044E2
			tst.b	obj.field_2A(a0)
			beq.s	loc_2044BA
			cmpi.b	#$3D,obj.field_2A(a0)
			bne.s	locret_204518
			bset	#3,(word_FFF602).w
			lsl.w	#7,d5
			move.b	#0,obj.field_2A(a0)
loc_2044BA:
			bclr	#0,obj.status(a0)
			beq.s	loc_2044CE
			bclr	#5,obj.status(a0)
			move.b	#1,obj.prevani(a0)
loc_2044CE:
			add.w	d5,d0
			cmp.w	d6,d0
			blt.s	loc_2044D6
			move.w	d6,d0
loc_2044D6:
			move.w	d0,obj.inertia(a0)
			move.b	#0,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_2044E2:
			add.w	d4,d0
			bcc.s	loc_2044EA
			move.w	#$80,d0
loc_2044EA:
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
locret_204518:
			rts
; End of function sub_204498
; =============== S U B R O U T I N E =======================================
sub_20451A:
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
loc_204546:
			btst	#3,(word_FFF602).w
			beq.s	loc_204552
			bsr.w	sub_20469A
loc_204552:
			tst.b	obj.field_2A(a0)
			beq.w	loc_2045E8
			move.w	#$19,d0
			move.w	(word_FFF760).w,d1
			asl.w	#1,d1
			btst	#0,obj.status(a0)
			beq.s	loc_204570
			neg.w	d0
			neg.w	d1
loc_204570:
			add.w	d0,obj.inertia(a0)
			move.w	obj.inertia(a0),d0
			cmp.w	d1,d0
			bgt.s	loc_20457E
			move.w	d1,d0
loc_20457E:
			move.w	d0,obj.inertia(a0)
			btst	#1,(word_FFF602).w
			beq.s	loc_2045BA
			move.b	(word_FFF602+1).w,d0
			andi.b	#$70,d0
			beq.s	locret_2045E6
loc_204594:
			move.w	#$AB,d0
			jsr	(queuesound2).l
			move.b	#0,obj.field_2A(a0)
			move.w	#0,obj.inertia(a0)
			move.w	#0,obj.xvel(a0)
			move.w	#0,obj.yvel(a0)
			bra.w	loc_204610
; ---------------------------------------------------------------------------
loc_2045BA:
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
loc_2045E0:
			bsr.w	sub_204676
			bra.s	loc_2045E8
; ---------------------------------------------------------------------------
locret_2045E6:
			rts
; ---------------------------------------------------------------------------
loc_2045E8:
			move.w	obj.inertia(a0),d0
			beq.s	loc_20460A
			bmi.s	loc_2045FE
			sub.w	d5,d0
			bcc.s	loc_2045F8
			move.w	#0,d0
loc_2045F8:
			move.w	d0,obj.inertia(a0)
			bra.s	loc_20460A
; ---------------------------------------------------------------------------
loc_2045FE:
			add.w	d5,d0
			bcc.s	loc_204606
			move.w	#0,d0
loc_204606:
			move.w	d0,obj.inertia(a0)
loc_20460A:
			tst.w	obj.inertia(a0)
			bne.s	loc_204640
loc_204610:
			bclr	#2,obj.status(a0)
			tst.b	(chibi_flag).w
			beq.s	loc_20462A
			move.b	#$A,obj.height(a0)
			move.b	#5,obj.width(a0)
			bra.s	loc_20463A
; ---------------------------------------------------------------------------
loc_20462A:
			move.b	#$13,obj.height(a0)
			move.b	#9,obj.width(a0)
			subq.w	#5,obj.ypos(a0)
loc_20463A:
			move.b	#5,obj.ani(a0)
loc_204640:
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
loc_204664:
			cmpi.w	#-$1000,d1
			bge.s	loc_20466E
			move.w	#-$1000,d1
loc_20466E:
			move.w	d1,obj.xvel(a0)
			bra.w	loc_20439E
; End of function sub_20451A
; =============== S U B R O U T I N E =======================================
sub_204676:
			move.w	obj.inertia(a0),d0
			beq.s	loc_20467E
			bpl.s	loc_20468C
loc_20467E:
			bset	#0,obj.status(a0)
			move.b	#2,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_20468C:
			sub.w	d4,d0
			bcc.s	loc_204694
			move.w	#-$80,d0
loc_204694:
			move.w	d0,obj.inertia(a0)
			rts
; End of function sub_204676
; =============== S U B R O U T I N E =======================================
sub_20469A:
			move.w	obj.inertia(a0),d0
			bmi.s	loc_2046AE
			bclr	#0,obj.status(a0)
			move.b	#2,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_2046AE:
			add.w	d4,d0
			bcc.s	loc_2046B6
			move.w	#$80,d0
loc_2046B6:
			move.w	d0,obj.inertia(a0)
			rts
; End of function sub_20469A
; =============== S U B R O U T I N E =======================================
sub_2046BC:
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
loc_2046EC:
			btst	#3,(word_FFF602).w
			beq.s	loc_204702
			bclr	#0,obj.status(a0)
			add.w	d5,d0
			cmp.w	d6,d0
			blt.s	loc_204702
			move.w	d6,d0
loc_204702:
			move.w	d0,obj.xvel(a0)
loc_204706:
			tst.b	obj.field_29(a0)
			beq.s	loc_20471E
			cmpi.w	#$60,(word_FFF73E).w
			beq.s	loc_20471E
			bcc.s	loc_20471A
			addq.w	#4,(word_FFF73E).w
loc_20471A:
			subq.w	#2,(word_FFF73E).w
loc_20471E:
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
loc_20473A:
			move.w	d0,obj.xvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_204740:
			sub.w	d1,d0
			bcs.s	loc_204748
			move.w	#0,d0
loc_204748:
			move.w	d0,obj.xvel(a0)
locret_20474C:
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
locret_20477C:
			rts
; =============== S U B R O U T I N E =======================================
sub_20477E:
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
loc_2047AC:
			cmp.w	d1,d0
			bls.s	loc_2047C4
loc_2047B0:
			move.w	(dword_FFF72C+2).w,d0
			addi.w	#224,d0
			cmp.w	obj.ypos(a0),d0
			blt.s	loc_2047C0
			rts
; ---------------------------------------------------------------------------
loc_2047C0:
			bra.w	loc_206668
; ---------------------------------------------------------------------------
loc_2047C4:

			move.w	d0,obj.xpos(a0)
			move.w	#0,obj.scrypos(a0)
			move.w	#0,obj.xvel(a0)
			move.w	#0,obj.inertia(a0)
			bra.s	loc_2047B0
; End of function sub_20477E
; =============== S U B R O U T I N E =======================================
sub_2047DC:
			tst.b	(byte_FFF7CA).w
			bne.s	locret_204802
			move.w	obj.inertia(a0),d0
			bpl.s	loc_2047EA
			neg.w	d0
loc_2047EA:
			cmpi.w	#$80,d0
			bcs.s	locret_204802
			move.b	(word_FFF602).w,d0
			andi.b	#$C,d0
			bne.s	locret_204802
			btst	#1,(word_FFF602).w
			bne.s	sub_204804
locret_204802:
			rts
; End of function sub_2047DC
; =============== S U B R O U T I N E =======================================
sub_204804:
			btst	#2,obj.status(a0)
			beq.s	loc_20480E
			rts
; ---------------------------------------------------------------------------
loc_20480E:
			bset	#2,obj.status(a0)
			tst.b	(chibi_flag).w
			beq.s	loc_204828
			move.b	#$A,obj.height(a0)
			move.b	#5,obj.width(a0)
			bra.s	loc_204838
; ---------------------------------------------------------------------------
loc_204828:
			move.b	#$E,obj.height(a0)
			move.b	#7,obj.width(a0)
			addq.w	#5,obj.ypos(a0)
loc_204838:
			move.b	#2,obj.ani(a0)
			tst.w	obj.inertia(a0)
			bne.s	locret_20484A
			move.w	#$200,obj.inertia(a0)
locret_20484A:
			rts
; End of function sub_204804
; =============== S U B R O U T I N E =======================================
sub_20484C:
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
loc_204876:
			move.b	(word_FFF602).w,d0
			andi.b	#3,d0
			beq.s	loc_204888
			tst.w	obj.inertia(a0)
			beq.w	locret_204964
loc_204888:
			move.b	(word_FFF602+1).w,d0
			andi.b	#$70,d0
			beq.w	locret_204964
			btst	#3,obj.status(a0)
			beq.s	loc_2048A4
			jsr	(sub_205394).l
			beq.s	loc_2048D4
loc_2048A4:
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
loc_2048CA:
			moveq	#0,d0
			move.b	obj.angle(a0),d0
			subi.b	#$40,d0
loc_2048D4:
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
			tst.b	(chibi_flag).w
			beq.s	loc_204920
			move.b	#$A,obj.height(a0)
			move.b	#5,obj.width(a0)
			bra.s	loc_20492C
; ---------------------------------------------------------------------------
loc_204920:
			move.b	#$13,obj.height(a0)
			move.b	#9,obj.width(a0)
loc_20492C:
			btst	#2,obj.status(a0)
			bne.s	loc_204966
			tst.b	(chibi_flag).w
			beq.s	loc_204948
			move.b	#$A,obj.height(a0)
			move.b	#5,obj.width(a0)
			bra.s	loc_204958
; ---------------------------------------------------------------------------
loc_204948:
			move.b	#$E,obj.height(a0)
			move.b	#7,obj.width(a0)
			addq.w	#5,obj.ypos(a0)
loc_204958:
			bset	#2,obj.status(a0)
			move.b	#2,obj.ani(a0)
locret_204964:
			rts
; ---------------------------------------------------------------------------
loc_204966:
			bset	#4,obj.status(a0)
			rts
; End of function sub_20484C
; =============== S U B R O U T I N E =======================================
sub_20496E:
			tst.b	obj.field_3C(a0)
			beq.s	loc_2049A0
			move.w	#-$400,d1
			btst	#6,obj.status(a0)
			beq.s	loc_204984
			move.w	#-$200,d1
loc_204984:
			cmp.w	obj.yvel(a0),d1
			ble.s	locret_20499E
			move.b	(word_FFF602).w,d0
			andi.b	#$70,d0
			bne.s	locret_20499E
			move.b	#0,obj.field_2A(a0)
			move.w	d1,obj.yvel(a0)
locret_20499E:
			rts
; ---------------------------------------------------------------------------
loc_2049A0:
			cmpi.w	#-$FC0,obj.yvel(a0)
			bge.s	locret_2049AE
			move.w	#-$FC0,obj.yvel(a0)
locret_2049AE:
			rts
; End of function sub_20496E
; =============== S U B R O U T I N E =======================================
sub_2049B0:
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
locret_2049E4:
			rts
; ---------------------------------------------------------------------------
loc_2049E6:
			add.w	d0,obj.inertia(a0)
locret_2049EA:
			rts
; End of function sub_2049B0
; =============== S U B R O U T I N E =======================================
sub_2049EC:
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
loc_204A1C:
			add.w	d0,obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_204A22:
			tst.w	d0
			bmi.s	loc_204A28
			asr.l	#2,d0
loc_204A28:
			add.w	d0,obj.inertia(a0)
locret_204A2C:

			rts
; End of function sub_2049EC
; =============== S U B R O U T I N E =======================================
sub_204A2E:
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
loc_204A52:
			cmpi.w	#$280,d0
			bcc.s	locret_204A68
			clr.w	obj.inertia(a0)
			bset	#1,obj.status(a0)
			move.w	#30,obj.field_3E(a0)
locret_204A68:
			rts
; ---------------------------------------------------------------------------
loc_204A6A:
			subq.w	#1,obj.field_3E(a0)
			rts
; End of function sub_204A2E
; =============== S U B R O U T I N E =======================================
sub_204A70:
			move.b	obj.angle(a0),d0
			beq.s	locret_204A8A
			bpl.s	loc_204A80
			addq.b	#2,d0
			bcc.s	loc_204A7E
			moveq	#0,d0
loc_204A7E:
			bra.s	loc_204A86
; ---------------------------------------------------------------------------
loc_204A80:
			subq.b	#2,d0
			bcc.s	loc_204A86
			moveq	#0,d0
loc_204A86:
			move.b	d0,obj.angle(a0)
locret_204A8A:
			rts
; End of function sub_204A70
; =============== S U B R O U T I N E =======================================
sub_204A8C:
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
loc_204ADE:
			bsr.w	sub_2061BE
			tst.w	d1
			bpl.s	loc_204AF0
			add.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
loc_204AF0:
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
loc_204B0E:
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
loc_204B3E:
			move.w	#0,obj.yvel(a0)
			move.w	obj.xvel(a0),obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_204B4C:
			move.w	#0,obj.xvel(a0)
			cmpi.w	#$FC0,obj.yvel(a0)
			ble.s	loc_204B60
			move.w	#$FC0,obj.yvel(a0)
loc_204B60:
			move.w	obj.yvel(a0),obj.inertia(a0)
			tst.b	d3
			bpl.s	locret_204B6E
			neg.w	obj.inertia(a0)
locret_204B6E:
			rts
; ---------------------------------------------------------------------------
loc_204B70:
			bsr.w	sub_20635C
			tst.w	d1
			bpl.s	loc_204B8A
			sub.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
			move.w	obj.yvel(a0),obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_204B8A:
			bsr.w	sub_206216
			tst.w	d1
			bpl.s	loc_204BA4
			sub.w	d1,obj.ypos(a0)
			tst.w	obj.yvel(a0)
			bpl.s	locret_204BA2
			move.w	#0,obj.yvel(a0)
locret_204BA2:
			rts
; ---------------------------------------------------------------------------
loc_204BA4:
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
locret_204BD0:
			rts
; ---------------------------------------------------------------------------
loc_204BD2:
			bsr.w	sub_20635C
			tst.w	d1
			bpl.s	loc_204BE4
			sub.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
loc_204BE4:
			bsr.w	sub_2061BE
			tst.w	d1
			bpl.s	loc_204BF6
			add.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
loc_204BF6:
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
loc_204C16:
			move.b	d3,obj.angle(a0)
			bsr.w	sub_204C90
			move.w	obj.yvel(a0),obj.inertia(a0)
			tst.b	d3
			bpl.s	locret_204C2C
			neg.w	obj.inertia(a0)
locret_204C2C:
			rts
; ---------------------------------------------------------------------------
loc_204C2E:
			bsr.w	sub_2061BE
			tst.w	d1
			bpl.s	loc_204C48
			add.w	d1,obj.xpos(a0)
			move.w	#0,obj.xvel(a0)
			move.w	obj.yvel(a0),obj.inertia(a0)
			rts
; ---------------------------------------------------------------------------
loc_204C48:
			bsr.w	sub_206216
			tst.w	d1
			bpl.s	loc_204C62
			sub.w	d1,obj.ypos(a0)
			tst.w	obj.yvel(a0)
			bpl.s	locret_204C60
			move.w	#0,obj.yvel(a0)
locret_204C60:
			rts
; ---------------------------------------------------------------------------
loc_204C62:
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
locret_204C8E:
			rts
; End of function sub_204A8C
; =============== S U B R O U T I N E =======================================
sub_204C90:
			btst	#4,obj.status(a0)
			beq.s	loc_204C9A
			nop
loc_204C9A:
			bclr	#5,obj.status(a0)
			bclr	#1,obj.status(a0)
			bclr	#4,obj.status(a0)
			btst	#2,obj.status(a0)
			beq.s	loc_204CE4
			bclr	#2,obj.status(a0)
			tst.b	(chibi_flag).w
			beq.s	loc_204CCE
			move.b	#$A,obj.height(a0)
			move.b	#5,obj.width(a0)
			bra.s	loc_204CDE
; ---------------------------------------------------------------------------
loc_204CCE:
			move.b	#$13,obj.height(a0)
			move.b	#9,obj.width(a0)
			subq.w	#5,obj.ypos(a0)
loc_204CDE:
			move.b	#0,obj.ani(a0)
loc_204CE4:
			move.b	#0,obj.field_3C(a0)
			move.w	#0,(word_FFF7D0).w
			rts
; End of function sub_204C90
; ---------------------------------------------------------------------------
loc_204CF2:
			jsr	(sub_203166).l
			addi.w	#$30,obj.yvel(a0)
			btst	#6,obj.status(a0)
			beq.s	loc_204D0C
			subi.w	#$20,obj.yvel(a0)
loc_204D0C:
			bsr.w	sub_204D22
			bsr.w	sub_20477E
			bsr.w	sub_203E5A
			bsr.w	sub_204EF4
			jmp	(displaysprite).l
; =============== S U B R O U T I N E =======================================
sub_204D22:
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
locret_204D5C:
			rts
; End of function sub_204D22
; ---------------------------------------------------------------------------
loc_204D5E:
			bsr.w	sub_204D76
			jsr	(sub_20313A).l
			bsr.w	sub_203E5A
			bsr.w	sub_204EF4
			jmp	(displaysprite).l
; =============== S U B R O U T I N E =======================================
sub_204D76:
			move.w	(dword_FFF72C+2).w,d0
			addi.w	#$100,d0
			cmp.w	obj.ypos(a0),d0
			bcc.w	locret_204DB8
			move.w	#-$38,obj.yvel(a0)
			addq.b	#2,obj.routine(a0)
			clr.b	(byte_FF121E).l
			addq.b	#1,(byte_FF121C).l
			subq.b	#1,(byte_FF1212).l
loc_204DA2:
			move.w	#60,obj.field_3A(a0)
			tst.b	(byte_FF121A).l
			beq.s	locret_204DB8
			move.w	#0,obj.field_3A(a0)
			bra.s	loc_204DA2
; ---------------------------------------------------------------------------
locret_204DB8:
			rts
; End of function sub_204D76
; ---------------------------------------------------------------------------
loc_204DBA:
			tst.w	obj.field_3A(a0)
			beq.s	locret_204E16
			subq.w	#1,obj.field_3A(a0)
			bne.s	locret_204E16
			move.w	#1,(lvl_reset).l
			lea	(byte_FFD040).w,a5
			cmpi.b	#objid_01,obj.id(a0)
			beq.s	loc_204DDE
			lea	(actwk).w,a5
loc_204DDE:
			tst.b	obj.id(a5)
			beq.w	loc_204DFA
			move.w	#0,(lvl_reset).l
			eori.b	#1,(byte_FF1219).l
			bra.w	deleteobj
; ---------------------------------------------------------------------------
loc_204DFA:
			clr.l	(dword_FF1880).l
			move.w	#scpu_fadeCDA,d0
			tst.b	(byte_FF1212).l
			beq.s	loc_204E12
			clr.w	(word_FF12F4).l
loc_204E12:
			bra.w	sub_205404
; ---------------------------------------------------------------------------
locret_204E16:
			rts
; =============== S U B R O U T I N E =======================================
sub_204E18:
			cmpi.b	#zoneid_SLZ,(zone).l
			beq.s	loc_204E2C
			tst.b	(zone).l
			bne.w	locret_204EE2
loc_204E2C:
			move.w	obj.ypos(a0),d0
			lsr.w	#1,d0
			andi.w	#$380,d0
			move.b	obj.xpos(a0),d1
			andi.w	#$7F,d1
			add.w	d1,d0
			lea	(lvllayoutwk).w,a1
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
loc_204E6A:
			cmp.b	(dword_FFF7AC+3).w,d1
			beq.w	loc_204EE4
loc_204E72:
			cmp.b	(dword_FFF7AC).w,d1
			beq.s	loc_204E96
			cmp.b	(dword_FFF7AC+1).w,d1
			beq.s	loc_204E86
			bclr	#6,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_204E86:
			btst	#1,obj.status(a0)
			beq.s	loc_204E96
			bclr	#6,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_204E96:
			move.w	obj.xpos(a0),d2
			cmpi.b	#$2C,d2
			bcc.s	loc_204EA8
			bclr	#6,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_204EA8:
			cmpi.b	#$E0,d2
			bcs.s	loc_204EB6
			bset	#6,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_204EB6:
			btst	#6,obj.render(a0)
			bne.s	loc_204ED2
			move.b	obj.angle(a0),d1
			beq.s	locret_204EE2
			cmpi.b	#$80,d1
			bhi.s	locret_204EE2
			bset	#6,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_204ED2:
			move.b	obj.angle(a0),d1
			cmpi.b	#$80,d1
			bls.s	locret_204EE2
			bclr	#6,obj.render(a0)
locret_204EE2:
			rts
; ---------------------------------------------------------------------------
loc_204EE4:
			move.w	#$9C,d0
			jsr	(queuesound2).l
			jmp	(sub_204804).l
; End of function sub_204E18
; =============== S U B R O U T I N E =======================================
sub_204EF4:
			lea	(play_ani).l,a1
			moveq	#0,d0
			move.b	obj.ani(a0),d0
			cmp.b	obj.prevani(a0),d0
			beq.s	loc_204F16
			move.b	d0,obj.prevani(a0)
			move.b	#0,obj.aniframe(a0)
			move.b	#0,obj.time(a0)
loc_204F16:
			bsr.w	sub_205132
			add.w	d0,d0
			adda.w	(a1,d0.w),a1
			move.b	(a1),d0
			bmi.s	loc_204F8E
			move.b	obj.status(a0),d1
			andi.b	#1,d1
			andi.b	#$FC,obj.render(a0)
			or.b	d1,obj.render(a0)
			subq.b	#1,obj.time(a0)
			bpl.s	locret_204F5C
			move.b	d0,obj.time(a0)
; End of function sub_204EF4
; =============== S U B R O U T I N E =======================================
sub_204F40:
			moveq	#0,d1
			move.b	obj.aniframe(a0),d1
			move.b	1(a1,d1.w),d0
			beq.s	loc_204F54
			bpl.s	loc_204F54
			cmpi.b	#$FD,d0
			bge.s	loc_204F5E
loc_204F54:
			move.b	d0,obj.frame(a0)
			addq.b	#1,obj.aniframe(a0)
locret_204F5C:
			rts
; ---------------------------------------------------------------------------
loc_204F5E:
			addq.b	#1,d0
			bne.s	loc_204F6E
			move.b	#0,obj.aniframe(a0)
			move.b	1(a1),d0
			bra.s	loc_204F54
; ---------------------------------------------------------------------------
loc_204F6E:
			addq.b	#1,d0
			bne.s	loc_204F82
			move.b	2(a1,d1.w),d0
			sub.b	d0,obj.aniframe(a0)
			sub.b	d0,d1
			move.b	1(a1,d1.w),d0
			bra.s	loc_204F54
; ---------------------------------------------------------------------------
loc_204F82:
			addq.b	#1,d0
			bne.s	locret_204F8C
			move.b	2(a1,d1.w),obj.ani(a0)
locret_204F8C:
			rts
; End of function sub_204F40
; ---------------------------------------------------------------------------
loc_204F8E:
			subq.b	#1,obj.time(a0)
			bpl.s	locret_204F5C
			addq.b	#1,d0
			bne.w	loc_205016
			tst.b	(chibi_flag).w
			bne.w	loc_2050BC
			moveq	#0,d1
			move.b	obj.angle(a0),d0
			move.b	obj.status(a0),d2
			andi.b	#1,d2
			bne.s	loc_204FB4
			not.b	d0
loc_204FB4:
			addi.b	#$10,d0
			bpl.s	loc_204FBC
			moveq	#3,d1
loc_204FBC:
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
loc_204FE0:
			lea	(unk_2051DE).l,a1
			cmpi.w	#$600,d2
			bcc.s	loc_204FF8
			lea	(unk_2051D6).l,a1
			move.b	d0,d1
			lsr.b	#1,d1
			add.b	d1,d0
loc_204FF8:
			add.b	d0,d0
			move.b	d0,d3
			neg.w	d2
			addi.w	#$800,d2
			bpl.s	loc_205006
			moveq	#0,d2
loc_205006:
			lsr.w	#8,d2
			move.b	d2,obj.time(a0)
			bsr.w	sub_204F40
			add.b	d3,obj.frame(a0)
			rts
; ---------------------------------------------------------------------------
loc_205016:
			addq.b	#1,d0
			bne.s	loc_205066
			move.w	obj.inertia(a0),d2
			bpl.s	loc_205022
			neg.w	d2
loc_205022:
			lea	(unk_2052B4).l,a1
			tst.b	(chibi_flag).w
			bne.s	loc_205040
			lea	(unk_2051EE).l,a1
			cmpi.w	#$600,d2
			bcc.s	loc_205040
			lea	(unk_2051E6).l,a1
loc_205040:
			neg.w	d2
			addi.w	#$400,d2
			bpl.s	loc_20504A
			moveq	#0,d2
loc_20504A:
			lsr.w	#8,d2
			move.b	d2,obj.time(a0)
			move.b	obj.status(a0),d1
			andi.b	#1,d1
			andi.b	#$FC,obj.render(a0)
			or.b	d1,obj.render(a0)
			bra.w	sub_204F40
; ---------------------------------------------------------------------------
loc_205066:
			addq.b	#1,d0
			bne.s	loc_2050A8
loc_20506A:
			move.w	obj.inertia(a0),d2
			bmi.s	loc_205072
			neg.w	d2
loc_205072:
			addi.w	#$800,d2
			bpl.s	loc_20507A
			moveq	#0,d2
loc_20507A:
			lsr.w	#6,d2
			move.b	d2,obj.time(a0)
			lea	(unk_2052C6).l,a1
			tst.b	(chibi_flag).w
			bne.s	loc_205092
			lea	(unk_2051F6).l,a1
loc_205092:
			move.b	obj.status(a0),d1
			andi.b	#1,d1
			andi.b	#$FC,obj.render(a0)
			or.b	d1,obj.render(a0)
			bra.w	sub_204F40
; ---------------------------------------------------------------------------
loc_2050A8:
			moveq	#0,d1
			move.b	obj.aniframe(a0),d1
			move.b	1(a1,d1.w),obj.frame(a0)
			move.b	#0,obj.time(a0)
			rts
; ---------------------------------------------------------------------------
loc_2050BC:
			moveq	#0,d1
			move.b	obj.angle(a0),d0
			move.b	obj.status(a0),d2
			andi.b	#1,d2
			bne.s	loc_2050CE
			not.b	d0
loc_2050CE:
			addi.b	#$10,d0
			bpl.s	loc_2050D6
			moveq	#0,d1
loc_2050D6:
			andi.b	#$FC,obj.render(a0)
			or.b	d2,obj.render(a0)
			addi.b	#$30,d0
			cmpi.b	#$60,d0
			bcs.s	loc_205104
			bset	#2,obj.status(a0)
			move.b	#$A,obj.height(a0)
			move.b	#5,obj.width(a0)
			move.b	#$FF,d0
			bra.w	loc_205016
; ---------------------------------------------------------------------------
loc_205104:
			move.w	obj.inertia(a0),d2
			bpl.s	loc_20510C
			neg.w	d2
loc_20510C:
			lea	(unk_2052AE).l,a1
			cmpi.w	#$600,d2
			bcc.s	loc_20511E
			lea	(unk_2052A8).l,a1
loc_20511E:
			neg.w	d2
			addi.w	#$800,d2
			bpl.s	loc_205128
			moveq	#0,d2
loc_205128:
			lsr.w	#8,d2
			move.b	d2,$1E(a0)
			bra.w	sub_204F40
; =============== S U B R O U T I N E =======================================
sub_205132:
			tst.b	(chibi_flag).w
			beq.s	locret_20513C
			move.b	byte_20513E(pc,d0.w),d0
locret_20513C:
			rts
; End of function sub_205132
; ---------------------------------------------------------------------------
byte_20513E:
			dc.b $21
			dc.b $18
			dc.b $23
			dc.b $23
			dc.b $27
			dc.b $1F
			dc.b $26
			dc.b $28
			dc.b $20
			dc.b   9
			dc.b  $A
			dc.b  $B
			dc.b  $C
			dc.b $24
			dc.b  $E
			dc.b  $F
			dc.b $28
			dc.b $11
			dc.b $12
			dc.b $13
			dc.b $14
			dc.b $15
			dc.b $16
			dc.b $17
			dc.b $18
			dc.b $19
			dc.b $25
			dc.b $25
			dc.b $1C
			dc.b $1D
			dc.b $1E
			dc.b $1F
			dc.b $20
			dc.b $21
			dc.b $22
			dc.b $23
			dc.b $24
			dc.b $25
			dc.b $26
			dc.b $27
			dc.b $28
			dc.b $29
			dc.b $2A
			dc.b $30
			dc.b $2C
			dc.b $2D
			dc.b $2E
			dc.b $2F
			even
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
unk_2051D6: dc.b $FF
			dc.b $35
			dc.b $36
			dc.b $37
			dc.b $38
			dc.b $33
			dc.b $34
			dc.b $FF
			even
unk_2051DE: dc.b $FF
			dc.b $4B
			dc.b $4C
			dc.b $4D
			dc.b $4E
			dc.b $FF
			dc.b $FF
			dc.b $FF
			even
unk_2051E6: dc.b $FE
			dc.b $2D
			dc.b $2E
			dc.b $2F
			dc.b $30
			dc.b $31
			dc.b $FF
			dc.b $FF
			even
unk_2051EE: dc.b $FE
			dc.b $2D
			dc.b $2E
			dc.b $31
			dc.b $2F
			dc.b $30
			dc.b $31
			dc.b $FF
			even
unk_2051F6: dc.b $FD
			dc.b $64
			dc.b $65
			dc.b $66
			dc.b $67
			dc.b $FF
			dc.b $FF
			dc.b $FF
			even
unk_2051FE: dc.b $17
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
			even
unk_205214: dc.b $1F
			dc.b $6D
			dc.b $6E
			dc.b $FF
			even
unk_205218: dc.b $3F
			dc.b   5
			dc.b $FF
			even
unk_20521C: dc.b $3F
			dc.b $60
			dc.b $FF
			even
unk_205220: dc.b $3F
			dc.b $33
			dc.b $FF
			even
unk_205224: dc.b $3F
			dc.b $34
			dc.b $FF
			even
unk_205228: dc.b $3F
			dc.b $35
			dc.b $FF
			even
unk_20522C: dc.b $3F
			dc.b $36
			dc.b $FF
			even
unk_205230: dc.b   7
			dc.b $5B
			dc.b $5C
			dc.b $FF
			even
unk_205234: dc.b   7
			dc.b $3C
			dc.b $3F
			dc.b $FF
			even
unk_205238: dc.b   7
			dc.b $3C
			dc.b $3D
			dc.b $53
			dc.b $3E
			dc.b $54
			dc.b $FF
			even
unk_205240: dc.b $2F
			dc.b $32
			dc.b $FD
			dc.b   0
			even
unk_205244: dc.b   4
			dc.b $6B
			dc.b $6C
			dc.b $FF
			even
unk_205248: dc.b  $F
			dc.b $43
			dc.b $43
			dc.b $43
			dc.b $FE
			dc.b   1
			even
unk_20524E: dc.b  $F
			dc.b $43
			dc.b $44
			dc.b $FE
			dc.b   1
			even
unk_205254: dc.b $3F
			dc.b $49
			dc.b $FF
			even
unk_205258: dc.b  $B
			dc.b $5F
			dc.b $5F
			dc.b $37
			dc.b $38
			dc.b $FD
			dc.b   0
			even
unk_205260: dc.b $20
			dc.b $68
			dc.b $FF
			even
unk_205264: dc.b $2F
			dc.b $69
			dc.b $FF
			even
unk_205268: dc.b   3
			dc.b $6A
			dc.b $FF
			even
unk_20526C: dc.b   3
			dc.b $4E
			dc.b $4F
			dc.b $50
			dc.b $51
			dc.b $52
			dc.b   0
			dc.b $FE
			dc.b   1
			even
unk_205276: dc.b   3
			dc.b $5D
			dc.b $FF
			even
unk_20527A: dc.b   7
			dc.b $5D
			dc.b $5E
			dc.b $FF
unk_20527E: dc.b $77
			dc.b   0
			dc.b $FD
			dc.b   0
			even
unk_205282: dc.b   3
			dc.b $3C
			dc.b $3D
			dc.b $53
			dc.b $3E
			dc.b $54
			dc.b $FF
			even
unk_20528A: dc.b   3
			dc.b $3C
			dc.b $FD
			dc.b   0
			even
unk_20528E: dc.b $17
			dc.b $6F
			dc.b $6F
			dc.b $6F
			dc.b $6F
			dc.b $6F
			dc.b $6F
			dc.b $6F
			dc.b $6F
			dc.b $6F
			dc.b $6F
			dc.b $6F
			dc.b $6F
			dc.b $70
			dc.b $70
			dc.b $70
			dc.b $71
			dc.b $70
			dc.b $71
			dc.b $FE
			dc.b   2
			even
unk_2052A4: dc.b $3F
			dc.b $72
			dc.b $FF
			even
unk_2052A8: dc.b $FF
			dc.b $73
			dc.b $74
			dc.b $75
			dc.b $74
			dc.b $FF
			even
unk_2052AE: dc.b $FF
			dc.b $76
			dc.b $77
			dc.b $FF
			dc.b $FF
			dc.b $FF
			even
unk_2052B4: dc.b $FE
			dc.b $7C
			dc.b $7D
			dc.b $7E
			dc.b $FF
			dc.b $FF
			even
unk_2052BA: dc.b   7
			dc.b $78
			dc.b $78
			dc.b $FF
			even
unk_2052BE: dc.b   3
			dc.b $79
			dc.b $FF
			even
unk_2052C2: dc.b $1F
			dc.b $7A
			dc.b $7B
			dc.b $FF
			even
unk_2052C6: dc.b $FD
			dc.b $73
			dc.b $74
			dc.b $75
			dc.b $FF
			dc.b $FF
			dc.b $FF
			even
unk_2052CE: dc.b $3F
			dc.b $6F
			dc.b $FF
			even
unk_2052D2: dc.b $3F
			dc.b   6
			dc.b $FF
			even
unk_2052D6: dc.b   3
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
			even
unk_2052E6: dc.b   9
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
			even
unk_20530C: dc.b   4
			dc.b $18
			dc.b $19
			dc.b $FF
			even
unk_205310: dc.b $FC
			dc.b $1A
			dc.b $1B
			dc.b $1C
			dc.b $1F
			dc.b $1D
			dc.b $1E
			dc.b $FF
			even
unk_205318: dc.b $FF
			dc.b  $D
			dc.b  $E
			dc.b  $F
			dc.b $10
			dc.b  $B
			dc.b  $C
			dc.b $FF
			even
unk_205320: dc.b $FF
			dc.b $61
			dc.b $62
			dc.b $63
			dc.b $FF
			even
unk_205326: dc.b $13
			dc.b $70
			dc.b $6F
			dc.b $70
			dc.b $79
			dc.b $FE
			dc.b   1
			even
; =============== S U B R O U T I N E =======================================
sub_20532E:
			lea	(byte_FFF766).w,a2
			cmpi.b	#objid_01,obj.id(a0)
			beq.s	loc_20533E
			lea	(byte_FFF75D).w,a2
loc_20533E:
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
			lea	(playwrtwk).w,a3
			move.b	#1,(byte_FFF767).w
loc_205368:
			moveq	#0,d2
			move.b	(a2)+,d2
			move.w	d2,d0
			lsr.b	#4,d0
			lsl.w	#8,d2
			move.b	(a2)+,d2
			lsl.w	#5,d2
			lea	(cg_player).l,a1
			adda.l	d2,a1
loc_20537E:
			movem.l (a1)+,d2-d6/a4-a6
			movem.l d2-d6/a4-a6,(a3)
			lea	$20(a3),a3
			dbf	d0,loc_20537E
			dbf	d1,loc_205368
locret_205392:
			rts
; End of function sub_20532E
; =============== S U B R O U T I N E =======================================
sub_205394:
			moveq	#0,d0
			move.b	obj.field_3D(a0),d0
			lsl.w	#6,d0
			addi.l	#actwk&$FFFFFF,d0
			movea.l d0,a1
			cmpi.b	#objid_1E,obj.id(a1)
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
loc_2053EC:
			move.w	#-$A00,d2
			move.w	d2,d1
			ext.l	d1
			muls.w	d3,d1
			divs.w	#$40,d1
			add.w	d1,d2
			moveq	#0,d1
locret_2053FE:
			rts
; End of function sub_205394
; ---------------------------------------------------------------------------

loc_205400:
			move.w	#scpu_fadeCDA,d0
; =============== S U B R O U T I N E =======================================
sub_205404:

			move.w	d0,(scpu_commcmd0).l
loc_20540A:
			tst.w	(scpu_commstats).l
			beq.s	loc_20540A
			move.w	#0,(scpu_commcmd0).l
loc_20541A:
			tst.w	(scpu_commstats).l
			bne.s	loc_20541A
			rts
; End of function sub_205404
; =============== S U B R O U T I N E =======================================
animateobj:
			tst.b	obj.render(a0)
			bpl.s	locret_205486
			moveq	#0,d0
			move.b	obj.ani(a0),d0
			cmp.b	obj.prevani(a0),d0
			beq.s	loc_205446
			move.b	d0,obj.prevani(a0)
			move.b	#0,obj.aniframe(a0)
			move.b	#0,obj.time(a0)
loc_205446:
			subq.b	#1,obj.time(a0)
			bpl.s	locret_205486
			add.w	d0,d0
			adda.w	(a1,d0.w),a1
			move.b	(a1),obj.time(a0)
			moveq	#0,d1
			move.b	obj.aniframe(a0),d1
			move.b	1(a1,d1.w),d0
			bmi.s	loc_205488
loc_205462:
			move.b	d0,d1
			andi.b	#$1F,d0
			move.b	d0,obj.frame(a0)
			move.b	obj.status(a0),d0
			rol.b	#3,d1
			eor.b	d0,d1
			andi.b	#3,d1
			andi.b	#$FC,obj.render(a0)
			or.b	d1,obj.render(a0)
			addq.b	#1,obj.aniframe(a0)
locret_205486:
			rts
; ---------------------------------------------------------------------------
loc_205488:
			addq.b	#1,d0
			bne.s	loc_205498
			move.b	#0,obj.aniframe(a0)
			move.b	1(a1),d0
			bra.s	loc_205462
; ---------------------------------------------------------------------------
loc_205498:
			addq.b	#1,d0
			bne.s	loc_2054AC
			move.b	2(a1,d1.w),d0
			sub.b	d0,obj.aniframe(a0)
			sub.b	d0,d1
			move.b	1(a1,d1.w),d0
			bra.s	loc_205462
; ---------------------------------------------------------------------------
loc_2054AC:
			addq.b	#1,d0
			bne.s	loc_2054B6
			move.b	2(a1,d1.w),obj.ani(a0)
loc_2054B6:
			addq.b	#1,d0
			bne.s	loc_2054BE
			addq.b	#2,obj.routine(a0)
loc_2054BE:
			addq.b	#1,d0
			bne.s	loc_2054CC
			move.b	#0,obj.aniframe(a0)
			clr.b	obj.routine2(a0)
loc_2054CC:
			addq.b	#1,d0
			bne.s	locret_2054D4
			addq.b	#2,obj.routine2(a0)
locret_2054D4:
			rts
; End of function animateobj
; ---------------------------------------------------------------------------
obj06:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2054E4(pc,d0.w),d0
			jmp	off_2054E4(pc,d0.w)
; ---------------------------------------------------------------------------
off_2054E4:
			dc.w loc_2054E8-off_2054E4
			dc.w loc_20551C-off_2054E4
; ---------------------------------------------------------------------------
loc_2054E8:
			btst	#7,obj.status(a0)
			bne.w	deleteobj
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.l	#obj06_map,obj.mappings(a0)
			move.w	#$541,obj.vram(a0)
			move.w	obj.xpos(a0),obj.field_30(a0)
			move.b	#6,obj.colflag(a0)
loc_20551C:
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
obj18:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_205558(pc,d0.w),d0
			jmp	off_205558(pc,d0.w)
; ---------------------------------------------------------------------------
off_205558:
			dc.w loc_20555E-off_205558
			dc.w loc_205588-off_205558
			dc.w loc_205598-off_205558
; ---------------------------------------------------------------------------
loc_20555E:
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.w	#$680,obj.vram(a0)
			move.l	#obj18_map,obj.mappings(a0)
			move.b	#0,obj.colflag(a0)
			move.w	#1,obj.ani(a0)
loc_205588:
			lea	(obj18_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_205598:
			tst.b	obj.routine2(a0)
			beq.s	loc_2055A4
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_2055A4:
			move.b	#objid_1F,obj.id(a0)
			move.b	#0,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
obj1F:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2055C6(pc,d0.w),d0
			jsr	off_2055C6(pc,d0.w)
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
off_2055C6:
			dc.w loc_2055D0-off_2055C6
			dc.w loc_20561A-off_2055C6
			dc.w loc_20565C-off_2055C6
			dc.w loc_2056AC-off_2055C6
			dc.w loc_2056BA-off_2055C6
; ---------------------------------------------------------------------------
loc_2055D0:
			ori.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#0,obj.height(a0)
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
loc_20561A:
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
loc_205658:
			addq.w	#2,obj.ypos(a0)
loc_20565C:
			lea	(obj1F_ani).l,a1
			bra.w	animateobj
; =============== S U B R O U T I N E =======================================
sub_205666:
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
sub_20568C:
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
loc_2056AC:
			move.w	#$46D6,obj.vram(a0)
			move.b	#2,obj.ani(a0)
			bra.s	loc_20565C
; ---------------------------------------------------------------------------
loc_2056BA:
			move.b	#3,obj.ani(a0)
			move.b	#4,obj.routine(a0)
			bra.s	loc_20565C
; ---------------------------------------------------------------------------
obj0E:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2056D6(pc,d0.w),d0
			jmp	off_2056D6(pc,d0.w)
; ---------------------------------------------------------------------------
off_2056D6:
			dc.w loc_2056DC-off_2056D6
			dc.w loc_2056FA-off_2056D6
			dc.w loc_20570A-off_2056D6
; ---------------------------------------------------------------------------
loc_2056DC:
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.l	#obj0E_map,obj.mappings(a0)
			move.w	#$31E,obj.vram(a0)
			move.b	#1,obj.priority(a0)
loc_2056FA:
			lea	(obj0E_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20570A:
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
obj0D:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20572A(pc,d0.w),d0
			jsr	off_20572A(pc,d0.w)
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20572A:
			dc.w loc_205782-off_20572A
			dc.w loc_2057AE-off_20572A
			dc.w loc_2057BE-off_20572A
			dc.w loc_2057C8-off_20572A
; =============== S U B R O U T I N E =======================================
sub_205732:
			tst.w	obj.yvel(a1)
			bpl.s	loc_205774
			bsr.w	obj0C
			beq.s	loc_205774
			move.b	#4,obj.routine(a0)
			tst.b	obj.subtype(a0)
			bne.s	locret_205772
			jsr	(findfreeobj).l
			bne.s	locret_205772
			move.b	#objid_0B,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			subq.w	#4,obj.ypos(a1)
			move.w	#$A4,d0
			jmp	(queuesound2).l
; ---------------------------------------------------------------------------
locret_205772:

			rts
; ---------------------------------------------------------------------------
loc_205774:
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_205732
; ---------------------------------------------------------------------------
loc_205782:
			addq.b	#2,obj.routine(a0)
			move.l	#obj0D_map,obj.mappings(a0)
			move.b	#1,obj.priority(a0)
			ori.b	#4,obj.render(a0)
			move.b	#$2C,obj.field_19(a0)
			move.b	#8,obj.height(a0)
			moveq	#$C,d0
			jsr	(sub_20DC4C).l
loc_2057AE:
			lea	(actwk).w,a1
			bsr.w	sub_205732
			lea	(byte_FFD040).w,a1
			bra.w	sub_205732
; ---------------------------------------------------------------------------
loc_2057BE:
			lea	(obj0D_ani).l,a1
			bra.w	animateobj
; ---------------------------------------------------------------------------
loc_2057C8:
			move.b	#1,obj.prevani(a0)
			move.b	#0,obj.frame(a0)
			subq.b	#4,obj.routine(a0)
			rts
; =============== S U B R O U T I N E =======================================
obj0C:
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
			move.b	obj.height(a0),d1
			add.w	d1,d0
			bmi.s	loc_20580E
			add.w	d1,d1
			cmp.w	d1,d0
			bcc.s	loc_20580E
			moveq	#1,d0
			rts
; ---------------------------------------------------------------------------
loc_20580E:
			moveq	#0,d0
			rts
; End of function obj0C
; ---------------------------------------------------------------------------
obj0B:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_205820(pc,d0.w),d0
			jmp	off_205820(pc,d0.w)
; ---------------------------------------------------------------------------
off_205820:
			dc.w loc_205826-off_205820
			dc.w loc_205862-off_205820
			dc.w loc_205872-off_205820
; ---------------------------------------------------------------------------
loc_205826:
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.l	#obj0B_map,obj.mappings(a0)
			move.b	obj.subtype(a0),obj.ani(a0)
			moveq	#$D,d0
			jsr	(sub_20DC4C).l
			move.w	#$A2,d0
			cmpi.b	#2,obj.subtype(a0)
			bcs.s	loc_20585C
			move.w	#$A1,d0
loc_20585C:
			jsr	(queuesound2).l
loc_205862:
			lea	(obj0B_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_205872:
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
obj03:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_205886(pc,d0.w),d1
			jmp	off_205886(pc,d1.w)
; ---------------------------------------------------------------------------
off_205886:
			dc.w loc_20588E-off_205886
			dc.w loc_2058CA-off_205886
			dc.w loc_205912-off_205886
			dc.w loc_20592A-off_205886
; ---------------------------------------------------------------------------
loc_20588E:
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
locret_2058C8:
			rts
; ---------------------------------------------------------------------------
loc_2058CA:
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
locret_20590A:
			rts
; ---------------------------------------------------------------------------
loc_20590C:
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_205912:
			tst.b	(byte_FF122F).l
			beq.s	loc_20591C
			rts
; ---------------------------------------------------------------------------
loc_20591C:
			tst.b	(byte_FF122D).l
			bne.s	loc_205938
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_20592A:
			tst.b	(byte_FF122F).l
			bne.s	loc_205938
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_205938:
			move.w	(word_FFF7A8).w,d0
			move.b	obj.ani(a0),d1
			subq.b	#1,d1
			cmpi.b	#4,d1
			bcs.s	loc_20594A
			subq.b	#4,d1
loc_20594A:
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
loc_205966:
			move.b	d1,obj.field_30(a0)
			lea	(playposiwk).w,a1
			lea	(a1,d0.w),a1
			move.w	(a1)+,obj.xpos(a0)
			move.w	(a1)+,obj.ypos(a0)
			jsr	(sub_2023EA).l
			move.b	obj.status(a6),obj.status(a0)
			lea	(obj06_ani).l,a1
			jsr	(animateobj).l
loc_205992:
			move.b	(byte_FF127B).l,d0
			andi.b	#7,d0
			cmp.b	obj.routine(a0),d0
			beq.s	loc_2059B2
			move.b	obj.routine(a0),(byte_FF127B).l
			bset	#7,(byte_FF127B).l
loc_2059B2:
			jmp	(displaysprite).l
; =============== S U B R O U T I N E =======================================
sub_2059B8:
			bclr	#7,(byte_FF127B).l
			beq.s	locret_205A06
			moveq	#0,d0
			move.b	(byte_FF127B).l,d0
			subq.b	#2,d0
			add.w	d0,d0
			movea.l off_205A08(pc,d0.w),a1
			lea	(powerupwrtwk).l,a2
			move.w	#(powerupwrtwk_end-powerupwrtwk)/4-1,d0
loc_2059DC:
			move.l	(a1)+,(a2)+
			dbf	d0,loc_2059DC

			DMA68K	powerupwrtwk,(powerupwrtwk_dma_end-powerupwrtwk),4,$544<<5

locret_205A06:
			rts
; End of function sub_2059B8
; ---------------------------------------------------------------------------
off_205A08:
			dc.l cg_shield
			dc.l cg_stars
			dc.l cg_timetravel
obj06_ani:
			dc.w unk_205A26-obj06_ani
			dc.w unk_205A2E-obj06_ani
			dc.w unk_205A34-obj06_ani
			dc.w unk_205A4E-obj06_ani
			dc.w unk_205A68-obj06_ani
			dc.w unk_205A82-obj06_ani
			dc.w unk_205A8E-obj06_ani
			dc.w unk_205AC8-obj06_ani
			dc.w unk_205B02-obj06_ani
unk_205A26: dc.b   1
			dc.b   1
			dc.b   0
			dc.b   2
			dc.b   0
			dc.b   3
			dc.b   0
			dc.b $FF
			even
unk_205A2E: dc.b   5
			dc.b   4
			dc.b   5
			dc.b   6
			dc.b   7
			dc.b $FF
			even
unk_205A34: dc.b   0
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
			even
unk_205A4E: dc.b   0
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
			even
unk_205A68: dc.b   0
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
			even
unk_205A82: dc.b   0
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
			even
unk_205A8E: dc.b   0
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
			even
unk_205AC8: dc.b   0
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
			even
unk_205B02: dc.b   0
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
			even

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
byte_205B56:	dc.b 4
			dc.b $E8, $A,  0,  0,$E8
			dc.b $E8, $A,  0,  9,  0
			dc.b   0, $A,$10,  0,$E8
			dc.b   0, $A,$10,  9,  0
byte_205B6B:	dc.b 4
			dc.b $E8, $A,  0,$12,$E8
			dc.b $E8, $A,  0,$1B,  0
			dc.b   0, $A,$10,$12,$E8
			dc.b   0, $A,$10,$1B,  0
byte_205B80:	dc.b 4
			dc.b $E8, $A,  8,  9,$E8
			dc.b $E8, $A,  8,  0,  0
			dc.b   0, $A,$18,  9,$E8
			dc.b   0, $A,$18,  0,  0
byte_205B95:	dc.b 4
			dc.b $E8, $A,  0,  0,$E8
			dc.b $E8, $A,  0,  9,  0
			dc.b   0, $A,$18,  9,$E8
			dc.b   0, $A,$18,  0,  0
byte_205BAA:	dc.b 4
			dc.b $E8, $A,  8,  9,$E8
			dc.b $E8, $A,  8,  0,  0
			dc.b   0, $A,$10,  0,$E8
			dc.b   0, $A,$10,  9,  0
byte_205BBF:	dc.b 4
			dc.b $E8, $A,  0,$12,$E8
			dc.b $E8, $A,  0,$1B,  0
			dc.b   0, $A,$18,$1B,$E8
			dc.b   0, $A,$18,$12,  0
byte_205BD4:	dc.b 4
			dc.b $E8, $A,  8,$1B,$E8
			dc.b $E8, $A,  8,$12,  0
			dc.b   0, $A,$10,$12,$E8
			dc.b   0, $A,$10,$1B,  0
			even
byte_205BEA:	dc.b 4
			dc.b $F0,  5,  0,  0,$F0
			dc.b $F0,  5,  8,  0,  0
			dc.b   0,  5,$10,  0,$F0
			dc.b   0,  5,$18,  0,  0
			even
byte_205C00:	dc.b 4
			dc.b $F0,  5,  0,  4,$F0
			dc.b $F0,  5,  8,  4,  0
			dc.b   0,  5,$10,  4,$F0
			dc.b   0,  5,$18,  4,  0
			even
byte_205C16:	dc.b 4
			dc.b $E8, $A,  0,  8,$E8
			dc.b $E8, $A,  8,  8,  0
			dc.b   0, $A,$10,  8,$E8
			dc.b   0, $A,$18,  8,  0
			even
byte_205C2C:	dc.b 4
			dc.b $F0,  5,  0,$11,$F0
			dc.b $F0,  5,  0,$15,  0
			dc.b   0,  5,$18,$15,$F0
			dc.b   0,  5,$18,$11,  0
			even
byte_205C42:	dc.b 2
			dc.b $F4,  6,  0,$19,$F0
			dc.b $F4,  6,  8,$19,  0
			even

obj0B_ani:
			dc.w unk_205C54-obj0B_ani
			dc.w unk_205C5C-obj0B_ani
			dc.w unk_205C62-obj0B_ani
unk_205C54: dc.b   3
			dc.b   0
			dc.b   4
			dc.b   3
			dc.b   1
			dc.b   2
			dc.b $FC
			even
unk_205C5C: dc.b   3
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b $FC
			even
unk_205C62: dc.b   3
			dc.b   6
			dc.b   5
			dc.b $FC
			even

obj0B_map:
			dc.w byte_205C74-obj0B_map
			dc.w byte_205C80-obj0B_map
			dc.w byte_205C8C-obj0B_map
			dc.w byte_205C92-obj0B_map
			dc.w byte_205CA8-obj0B_map
			dc.w byte_205CBE-obj0B_map
			dc.w byte_205CC4-obj0B_map
byte_205C74:	dc.b 2
			dc.b $F0,  5,  0,  0,$FC
			dc.b $F8,  0,  0,  4,$F4
			even
byte_205C80:	dc.b 2
			dc.b $E0,  0,  0,  5,$F8
			dc.b $E8, $E,  0,  6,$F0
			even
byte_205C8C:	dc.b 1
			dc.b $E0, $F,  0,$12,$F0
byte_205C92:	dc.b 4
			dc.b $D0,  6,  0,$22,$F8
			dc.b $D8,  0,  0,$28,$F0
			dc.b $E0,  0,  0,$29,  8
			dc.b $E8, $E,  0,$2A,$F0
			even
byte_205CA8:	dc.b 4
			dc.b $C0,  0,  0,$36,$F8
			dc.b $C8,  6,  0,$37,$F8
			dc.b $D8,  0,  0,$3D,$F0
			dc.b $E0, $F,  0,$3E,$F0
			even
byte_205CBE:	dc.b 1
			dc.b $F0,  9,  0,$4E,$F4
byte_205CC4:	dc.b 1
			dc.b $F8,  4,  0,$54,$F8

obj0D_ani:
			dc.w unk_205CCC-obj0D_ani
unk_205CCC: dc.b   0
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
			even

obj0D_map:
			dc.w byte_205CE8-obj0D_map
			dc.w byte_205CDC-obj0D_map
byte_205CDC:	dc.b 2
			dc.b $D0,  3,  0,  0,$E4
			dc.b $F0,  1,  0,  4,$E4
			even
byte_205CE8:	dc.b 2
			dc.b $F8, $C,  0,  6,$E8
			dc.b $F8,  4,  0, $A,  8
			even

obj0E_ani:
			dc.w unk_205CF6-obj0E_ani
unk_205CF6: dc.b   3
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b $FC
			even

obj0E_map:
			dc.w byte_205D02-obj0E_map
			dc.w byte_205D08-obj0E_map
			dc.w byte_205D0E-obj0E_map
byte_205D02:	dc.b 1
			dc.b $F0, $F,  0,  0,$F0
byte_205D08:	dc.b 1
			dc.b $F4, $A,  0,$10,$F4
byte_205D0E:	dc.b 1
			dc.b $F8,  5,  0,$19,$F8

obj18_ani:
			dc.w unk_205D18-obj18_ani
			dc.w unk_205D20-obj18_ani
unk_205D18: dc.b   3
			dc.b   0
			dc.b   5
			dc.b   6
			dc.b   3
			dc.b   4
			dc.b $FC
			even
unk_205D20: dc.b   3
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b $FC
			even

obj18_map:
			dc.w byte_205D36-obj18_map
			dc.w byte_205D42-obj18_map
			dc.w byte_205D52-obj18_map
			dc.w byte_205D68-obj18_map
			dc.w byte_205D7E-obj18_map
			dc.w byte_205D94-obj18_map
			dc.w byte_205DA4-obj18_map
byte_205D36:	dc.b 2
			dc.b $F8,  5,  0,  0,$F0
			dc.b $F8,  5,  8,  0,  0
			even
byte_205D42:	dc.b 3
			dc.b $F0, $D,  0,  4,$F0
			dc.b   0,  5,  0, $C,$F0
			dc.b   0,  5,  8, $C,  0
byte_205D52:	dc.b 4
			dc.b $F0,  5,  0,$10,$F0
			dc.b $F0,  5,  0,$14,  0
			dc.b   0,  5,  0,$18,$F0
			dc.b   0,  5,$18,$10,  0
			even
byte_205D68:	dc.b 4
			dc.b $E8, $A,  0,$1C,$E8
			dc.b $E8, $A,  8,$1C,  0
			dc.b   0, $A,$10,$1C,$E8
			dc.b   0, $A,$18,$1C,  0
			even
byte_205D7E:	dc.b 4
			dc.b $E8, $A,  0,$25,$E8
			dc.b $E8, $A,  8,$25,  0
			dc.b   0, $A,$10,$25,$E8
			dc.b   0, $A,$18,$25,  0
			even
byte_205D94:	dc.b 3
			dc.b $F0, $D,  0,$2E,$F0
			dc.b   0,  5,  0,$36,$F0
			dc.b   0,  5,  8,$36,  0
byte_205DA4:	dc.b 4
			dc.b $F0,  5,  0,$3A,$F0
			dc.b $F0,  5,  0,$3E,  0
			dc.b   0,  5,  0,$42,$F0
			dc.b   0,  5,$18,$3A,  0
			even

obj1F_ani:
			dc.w unk_205DC2-obj1F_ani
			dc.w unk_205DC6-obj1F_ani
			dc.w unk_205DCC-obj1F_ani
			dc.w unk_205DD2-obj1F_ani
unk_205DC2: dc.b   3
			dc.b   0
			dc.b   1
			dc.b $FF
			even
unk_205DC6: dc.b   3
			dc.b   2
			dc.b   3
			dc.b   2
			dc.b   3
			dc.b $FC
			even
unk_205DCC: dc.b   1
			dc.b   5
			dc.b   5
			dc.b   4
			dc.b   6
			dc.b $FC
			even
unk_205DD2: dc.b $13
			dc.b   6
			dc.b   7
			dc.b $FF
			even

obj1F_map:
			dc.w byte_205DE6-obj1F_map
			dc.w byte_205DEC-obj1F_map
			dc.w byte_205DF2-obj1F_map
			dc.w byte_205DF8-obj1F_map
			dc.w byte_205DFE-obj1F_map
			dc.w byte_205E0A-obj1F_map
			dc.w byte_205E10-obj1F_map
			dc.w byte_205E20-obj1F_map
byte_205DE6:	dc.b 1
			dc.b $F0,  1,  0,  0,$FC
byte_205DEC:	dc.b 1
			dc.b $F0,  1,  8,  0,$FC
byte_205DF2:	dc.b 1
			dc.b $F0,  5,  0,  2,$F8
byte_205DF8:	dc.b 1
			dc.b $F0,  5,  0,  6,$F8
byte_205DFE:	dc.b 2
			dc.b $E8,  9,  0,$1C,$F4
			dc.b $F8,  0,  0,$22,$FC
			even
byte_205E0A:	dc.b 1
			dc.b $F0,  5,  0,$23,$F8
byte_205E10:	dc.b 3
			dc.b $D0, $A,  0, $A,$F4
			dc.b $E8,  9,  0,$1C,$F4
			dc.b $F8,  0,  0,$22,$FC
byte_205E20:	dc.b 3
			dc.b $D0, $A,  0,$13,$F4
			dc.b $E8,  9,  0,$1C,$F4
			dc.b $F8,  0,  0,$22,$FC
; ---------------------------------------------------------------------------

loc_205E30:
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
loc_205ECC:
			tst.b	(byte_FF1230).l
			bpl.s	locret_205EE2
			move.w	(word_FF1256).l,d0
			subi.w	#160,d0
			move.w	d0,(dword_FFF728).w
locret_205EE2:
			rts
; =============== S U B R O U T I N E =======================================
sub_205EE4:
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
loc_205FC4:
			tst.b	(byte_FF1230).l
			bpl.s	locret_205FDA
			move.w	(word_FF1232).l,d0
			subi.w	#160,d0
			move.w	d0,(dword_FFF728).w
locret_205FDA:
			rts
; End of function sub_205EE4
; =============== S U B R O U T I N E =======================================
sub_205FDC:
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
loc_206012:
			addi.b	#$20,d0
			bra.s	loc_206022
; ---------------------------------------------------------------------------
loc_206018:
			move.b	d1,d0
			bpl.s	loc_20601E
			addq.b	#1,d0
loc_20601E:
			addi.b	#$1F,d0
loc_206022:
			andi.b	#$C0,d0
			beq.w	loc_2060F2
			cmpi.b	#$80,d0
			beq.w	loc_20628E
			andi.b	#$38,d1
			bne.s	loc_20603A
			addq.w	#8,d2
loc_20603A:
			cmpi.b	#$40,d0
			beq.w	loc_206364
			bra.w	loc_2061C6
; End of function sub_205FDC
; =============== S U B R O U T I N E =======================================
sub_206046:
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
loc_20606E:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.height(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.width(a0),d0
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
			move.b	obj.height(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.width(a0),d0
			ext.w	d0
			sub.w	d0,d3
			lea	(byte_FFF76A).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$D,d5
			jsr	(sub_200E82).l
			move.w	(sp)+,d0
			move.b	#0,d2
loc_2060D2:
			move.b	(byte_FFF76A).w,d3
			cmp.w	d0,d1
			ble.s	loc_2060E0
			move.b	(byte_FFF768).w,d3
			exg.l	d0,d1
loc_2060E0:
			btst	#0,d3
			beq.s	locret_2060E8
			move.b	d2,d3
locret_2060E8:
			rts
; End of function sub_206046
; ---------------------------------------------------------------------------
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3

loc_2060F2:
			addi.w	#$A,d2
			lea	(byte_FFF768).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$E,d5
			jsr	(sub_200E82).l
			move.b	#0,d2
loc_20610E:
			move.b	(byte_FFF768).w,d3
			btst	#0,d3
			beq.s	locret_20611A
			move.b	d2,d3
locret_20611A:
			rts
; =============== S U B R O U T I N E =======================================
sub_20611C:
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d2
			moveq	#0,d0
			move.b	obj.height(a0),d0
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
locret_206154:
			rts
; End of function sub_20611C
; ---------------------------------------------------------------------------
loc_206156:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.width(a0),d0
			ext.w	d0
			sub.w	d0,d2
			move.b	obj.height(a0),d0
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
			move.b	obj.width(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.height(a0),d0
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
sub_2061BE:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
; End of function sub_2061BE

loc_2061C6:
			addi.w	#$A,d3
			lea	(byte_FFF768).w,a4
			movea.w #$10,a3
			move.w	#0,d6
			moveq	#$E,d5
			jsr	(sub_200FF2).l
			move.b	#-$40,d2
			bra.w	loc_20610E
; =============== S U B R O U T I N E =======================================
sub_2061E6:
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
locret_206214:
			rts
; End of function sub_2061E6
; =============== S U B R O U T I N E =======================================
sub_206216:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.height(a0),d0
			ext.w	d0
			sub.w	d0,d2
			eori.w	#$F,d2
			move.b	obj.width(a0),d0
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
			move.b	obj.height(a0),d0
			ext.w	d0
			sub.w	d0,d2
			eori.w	#$F,d2
			move.b	obj.width(a0),d0
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

loc_20628E:
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
sub_2062B2:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.height(a0),d0
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
locret_2062EA:
			rts
; End of function sub_2062B2
; ---------------------------------------------------------------------------
loc_2062EC:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
			moveq	#0,d0
			move.b	obj.width(a0),d0
			ext.w	d0
			sub.w	d0,d2
			move.b	obj.height(a0),d0
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
			move.b	obj.width(a0),d0
			ext.w	d0
			add.w	d0,d2
			move.b	obj.height(a0),d0
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
sub_20635C:
			move.w	obj.ypos(a0),d2
			move.w	obj.xpos(a0),d3
; End of function sub_20635C
loc_206364:
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
sub_206388:
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
locret_2063B6:
			rts
; End of function sub_206388
; =============== S U B R O U T I N E =======================================
sub_2063B8:
			nop
			move.w	obj.xpos(a0),d2
			move.w	obj.ypos(a0),d3
			subq.w	#8,d2
			moveq	#0,d5
			move.b	obj.height(a0),d5
			subq.b	#3,d5
			sub.w	d5,d3
			cmpi.b	#$39,obj.frame(a0)
			bne.s	loc_2063DC
			addi.w	#$C,d3
			moveq	#$A,d5
loc_2063DC:
			move.w	#$10,d4
			add.w	d5,d5
			lea	(byte_FFD800).w,a1
			move.w	#$5F,d6
loc_2063EA:
			tst.b	obj.render(a1)
			bpl.s	loc_2063F6
			move.b	obj.colflag(a1),d0
			bne.s	loc_20644A
loc_2063F6:
			lea	obj(a1),a1
			dbf	d6,loc_2063EA
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
byte_206042:
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
			even
; ---------------------------------------------------------------------------
loc_20644A:
			andi.w	#$3F,d0
			add.w	d0,d0
			lea	byte_206042-2(pc,d0.w),a2
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
loc_20646C:
			cmp.w	d4,d0
			bhi.w	loc_2063F6
loc_206472:
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
loc_20648A:
			cmp.w	d5,d0
			bhi.w	loc_2063F6
loc_206490:
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
locret_2064C6:
			rts
; ---------------------------------------------------------------------------
loc_2064C8:
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
loc_2064F2:
			cmpi.b	#2,obj.ani(a0)
			bne.s	locret_206502
			neg.w	obj.yvel(a0)
			addq.b	#2,obj.routine(a1)
locret_206502:
			rts
; ---------------------------------------------------------------------------
loc_206504:
			tst.b	(byte_FF122D).l
			bne.s	loc_206516
			cmpi.b	#2,obj.ani(a0)
			bne.w	loc_2065C0
loc_206516:
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
locret_20653E:
			rts
; ---------------------------------------------------------------------------
loc_206540:
			bset	#7,obj.status(a1)
			moveq	#0,d0
			move.w	(word_FFF7D0).w,d0
			addq.w	#2,(word_FFF7D0).w
			cmpi.w	#6,d0
			bcs.s	loc_206558
			moveq	#6,d0
loc_206558:
			move.w	d0,obj.field_3E(a1)
			move.w	word_2065B2(pc,d0.w),d0
			cmpi.w	#$20,(word_FFF7D0).w
			bcs.s	loc_206572
			move.w	#1000,d0
			move.w	#$A,obj.field_3E(a1)
loc_206572:
			bsr.w	sub_209810
			move.w	#$9E,d0
			jsr	(queuesound2).l
			move.b	#objid_18,obj.id(a1)
			move.b	#0,obj.routine(a1)
			tst.w	obj.yvel(a0)
			bmi.s	loc_2065A2
			move.w	obj.ypos(a0),d0
			cmp.w	obj.ypos(a1),d0
			bcc.s	loc_2065AA
			neg.w	obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_2065A2:
			addi.w	#$100,obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_2065AA:
			subi.w	#$100,obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
word_2065B2:
			dc.w 10
			dc.w 20
			dc.w 50
			dc.w 100
; ---------------------------------------------------------------------------
loc_2065BA:
			bset	#7,obj.status(a1)
loc_2065C0:
			tst.b	(byte_FF122D).l
			beq.s	loc_2065CC
loc_2065C8:
			moveq	#-1,d0
			rts
; ---------------------------------------------------------------------------
loc_2065CC:
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
			move.b	#objid_11,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
loc_206602:
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
loc_20663A:
			move.w	obj.xpos(a0),d0
			cmp.w	obj.xpos(a2),d0
			bcs.s	loc_206648
			neg.w	obj.xvel(a0)
loc_206648:
			move.w	#0,obj.inertia(a0)
			move.b	#$1A,obj.ani(a0)
			move.w	#120,obj.field_30(a0)
			moveq	#-1,d0
			rts
; ---------------------------------------------------------------------------
loc_20665E:
			tst.w	(word_FF13FA).l
			bne.w	loc_206602
loc_206668:
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
loc_2066BE:
			moveq	#-1,d0
			rts
; ---------------------------------------------------------------------------
loc_2066C2:
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
			cmpi.b	#$21,d1
			beq.s	loc_206720
			rts
; ---------------------------------------------------------------------------
loc_2066EA:
			bra.w	loc_2065BA
; ---------------------------------------------------------------------------
loc_2066EE:
			sub.w	d0,d5
			cmpi.w	#8,d5
			bcc.s	loc_20671C
			move.w	obj.xpos(a1),d0
			subq.w	#4,d0
			btst	#0,obj.status(a1)
			beq.s	loc_206708
			subi.w	#$10,d0
loc_206708:
			sub.w	d2,d0
			bcc.s	loc_206714
			addi.w	#$18,d0
			bcs.s	loc_206718
			bra.s	loc_20671C
; ---------------------------------------------------------------------------
loc_206714:
			cmp.w	d4,d0
			bhi.s	loc_20671C
loc_206718:
			bra.w	loc_2065C0
; ---------------------------------------------------------------------------
loc_20671C:
			bra.w	loc_206504
; ---------------------------------------------------------------------------
loc_206720:
			addq.b	#1,obj.field_21(a1)
			cmpa.w	#actwk,a0
			beq.s	locret_20672E
			addq.b	#1,obj.field_21(a1)
locret_20672E:
			rts
; End of function sub_2063B8
; ---------------------------------------------------------------------------
obj04:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_206750(pc,d0.w),d0
			jsr	off_206750(pc,d0.w)
			lea	(obj04_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
off_206750:
			dc.w loc_206754-off_206750
			dc.w loc_20678C-off_206750
; ---------------------------------------------------------------------------
loc_206754:
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
loc_20678C:
			move.w	obj.ypos(a0),d0
			addq.w	#4,d0
			cmp.w	obj.field_2A(a0),d0
			bcs.s	loc_20679E
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_20679E:
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
loc_2067BE:
			jsr	(sub_202DD2).l
			addi.w	#$10,d5
			dbf	d6,loc_2067BE
locret_2067CC:
			rts
; ---------------------------------------------------------------------------
obj08:
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
loc_20680A:
			lea	(unk_FF1400).l,a2
			moveq	#0,d0
			move.b	obj.field_23(a0),d0
			beq.s	loc_20681E
			bclr	#7,2(a2,d0.w)
loc_20681E:
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
off_206824:
			dc.w loc_206828-off_206824
			dc.w loc_206846-off_206824
; ---------------------------------------------------------------------------
loc_206828:
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.l	#obj06_map,obj.mappings(a0)
			move.w	#$541,obj.vram(a0)
loc_206846:
			lea	(actwk).w,a1
			bsr.w	sub_206886
			bcs.s	loc_20685A
			lea	(byte_FFD040).w,a1
			bsr.w	sub_206886
			bcc.s	locret_206884
loc_20685A:
			move.b	#0,obj.routine(a0)
			move.b	#objid_05,obj.id(a0)
			move.w	#$1940,obj.xpos(a0)
			move.w	#$2D0,obj.ypos(a0)
			move.b	#9,obj.field_2E(a0)
			move.b	#$17,obj.field_2C(a0)
			move.b	#$2B,obj.field_2A(a0)
locret_206884:
			rts
; =============== S U B R O U T I N E =======================================
sub_206886:
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
locret_2068AA:
			rts
; End of function sub_206886
; ---------------------------------------------------------------------------
obj05:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2068BA(pc,d0.w),d0
			jmp	off_2068BA(pc,d0.w)
; ---------------------------------------------------------------------------
off_2068BA: dc.w loc_2068BE-off_2068BA
			dc.w loc_2068C8-off_2068BA
; ---------------------------------------------------------------------------
loc_2068BE:
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
loc_2068C8:
			move.b	(dword_FF120C+3).l,d0
			andi.b	#$F,d0
			bne.s	locret_206930
			subq.b	#1,obj.field_2E(a0)
			bne.s	loc_2068E0
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_2068E0:
			lea	(lvllayoutwk).w,a4
			move.w	obj.ypos(a0),d4
			moveq	#0,d0
			move.b	obj.field_2A(a0),d0
loc_2068EE:
			movem.l d0/a0,-(sp)
			move.w	obj.xpos(a0),d5
			moveq	#0,d6
			move.b	obj.field_2C(a0),d6
loc_2068FC:
			movem.l d4-d5,-(sp)
			subi.w	#$10,d4
			jsr	(loc_202D50).l
			bne.s	loc_206910
			moveq	#0,d3
			bra.s	loc_206912
; ---------------------------------------------------------------------------
loc_206910:
			move.w	(a0),d3
loc_206912:
			movem.l (sp)+,d4-d5
			jsr	(sub_202DD2).l
			addi.w	#$10,d5
			dbf	d6,loc_2068FC
			movem.l (sp)+,d0/a0
			subi.w	#$10,d4
			dbf	d0,loc_2068EE
locret_206930:
			rts
; ---------------------------------------------------------------------------
			movem.l (sp)+,d4-d5
			movem.l (sp)+,d0/a0
			rts
; ---------------------------------------------------------------------------
obj04_ani:
			dc.w unk_20693E-obj04_ani
unk_20693E: dc.b   4
			dc.b   0
			dc.b   1
			dc.b $FF
			even

obj04_map:
			dc.w byte_206946-obj04_map
			dc.w byte_206966-obj04_map
byte_206946:	dc.b 6
			dc.b $F0, $F,  0,  0,$A0
			dc.b $F0, $F,  0,  0,$C0
			dc.b $F0, $F,  0,  0,$E0
			dc.b $F0, $F,  0,  0,  0
			dc.b $F0, $F,  0,  0,$20
			dc.b $F0, $F,  0,  0,$40
			even
byte_206966:	dc.b 6
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
loc_20699C:
			addi.l	#$2000,(dword_206B16).l
			cmpi.l	#$80000,(dword_206B16).l
			bls.s	loc_2069BC
			move.l	#$80000,(dword_206B16).l
loc_2069BC:
			move.l	(dword_206B16).l,d0
			btst	#0,(word_FFF604).w
			beq.s	loc_2069CE
			sub.l	d0,obj.ypos(a0)
loc_2069CE:
			btst	#1,(word_FFF604).w
			beq.s	loc_2069DA
			add.l	d0,obj.ypos(a0)
loc_2069DA:
			btst	#2,(word_FFF604).w
			beq.s	loc_2069E6
			sub.l	d0,obj.xpos(a0)
loc_2069E6:
			btst	#3,(word_FFF604).w
			beq.s	loc_2069F2
			add.l	d0,obj.xpos(a0)
loc_2069F2:
			move.w	obj.ypos(a0),d2
			move.b	obj.height(a0),d0
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
loc_206A2E:
			move.b	d1,(byte_FF1206).l
loc_206A34:
			btst	#7,(word_FFF604+1).w
			beq.s	loc_206A54
			moveq	#0,d1
			move.b	(byte_FF1206).l,d1
			subq.b	#1,d1
			cmpi.b	#$FF,d1
			bne.s	loc_206A4E
			move.b	(a2),d1
loc_206A4E:
			move.b	d1,(byte_FF1206).l
loc_206A54:
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
			move.b	$A(a2,d1.w),obj.subtype(a1)
			move.b	$C(a2,d1.w),obj.field_29(a1)
			move.b	$D(a2,d1.w),obj.frame(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.b	obj.render(a0),d0
			andi.b	#3,d0
			move.b	d0,obj.render(a1)
			move.b	d0,obj.status(a1)
loc_206AE0:
			btst	#4,(word_FFF604+1).w
			beq.s	loc_206B10
			move.b	#0,(word_FF1208).l
			move.l	#player_map,obj.mappings(a0)
			move.w	#$780,obj.vram(a0)
			move.b	#2,obj.priority(a0)
			move.b	#0,obj.frame(a0)
			move.b	#4,obj.render(a0)
loc_206B10:
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
dword_206B16:
			dc.l $4000
byte_206B1A:
			dc.b $37
			dc.b   0
			dc.b $25
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
			dc.b $26
			dc.b   1
			dc.l obj26_map
			dc.w $33A
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $28
			dc.b   1
			dc.l obj28_map
			dc.w $342
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $28
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
			dc.b $27
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
			dc.b $21
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
			dc.b $24
			dc.b   1
			dc.l obj24_map
			dc.w $3C7
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b $24
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
			dc.b $22
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
sub_206DB0:
			moveq	#0,d0
			move.b	(byte_FFF76C).w,d0
			move.w	off_206DBE(pc,d0.w),d0
			jmp	off_206DBE(pc,d0.w)
; End of function sub_206DB0
; ---------------------------------------------------------------------------
off_206DBE:
			dc.w loc_206DC2-off_206DBE
			dc.w loc_206E50-off_206DBE
; ---------------------------------------------------------------------------
loc_206DC2:
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
loc_206DF2:
			clr.l	(a2)+
			dbf	d0,loc_206DF2

			lea	(unk_FF1400).l,a2
			moveq	#0,d2
			move.w	(dword_FFF700).w,d6
			subi.w	#$80,d6
			bcc.s	loc_206E0C
			moveq	#0,d6
loc_206E0C:
			andi.w	#$FF80,d6
			movea.l (dword_FFF770).w,a0
loc_206E14:
			cmp.w	(a0),d6
			bls.s	loc_206E26
			tst.b	4(a0)
			bpl.s	loc_206E22
			move.b	(a2),d2
			addq.b	#1,(a2)
loc_206E22:
			addq.w	#8,a0
			bra.s	loc_206E14
; ---------------------------------------------------------------------------
loc_206E26:
			move.l	a0,(dword_FFF770).w
			movea.l (dword_FFF774).w,a0
			subi.w	#$80,d6
			bcs.s	loc_206E46
loc_206E34:
			cmp.w	(a0),d6
			bls.s	loc_206E46
			tst.b	4(a0)
			bpl.s	loc_206E42
			addq.b	#1,1(a2)
loc_206E42:
			addq.w	#8,a0
			bra.s	loc_206E34
; ---------------------------------------------------------------------------
loc_206E46:
			move.l	a0,(dword_FFF774).w
			move.w	#$FFFF,(word_FFF76E).w
loc_206E50:
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
loc_206E78:
			cmp.w	-8(a0),d6
			bge.s	loc_206EA4
			subq.w	#8,a0
			tst.b	4(a0)
			bpl.s	loc_206E8E
			subq.b	#1,1(a2)
			move.b	1(a2),d2
loc_206E8E:
			bsr.w	sub_206F2C
			bne.s	loc_206E98
			subq.w	#8,a0
			bra.s	loc_206E78
; ---------------------------------------------------------------------------
loc_206E98:
			tst.b	4(a0)
			bpl.s	loc_206EA2
			addq.b	#1,1(a2)
loc_206EA2:
			addq.w	#8,a0
loc_206EA4:
			move.l	a0,(dword_FFF774).w
			movea.l (dword_FFF770).w,a0
			addi.w	#$300,d6
loc_206EB0:
			cmp.w	-8(a0),d6
			bgt.s	loc_206EC2
			tst.b	-4(a0)
			bpl.s	loc_206EBE
			subq.b	#1,(a2)
loc_206EBE:
			subq.w	#8,a0
			bra.s	loc_206EB0
; ---------------------------------------------------------------------------
loc_206EC2:
			move.l	a0,(dword_FFF770).w
			rts
; ---------------------------------------------------------------------------
loc_206EC8:
			move.w	d6,(word_FFF76E).w
			movea.l (dword_FFF770).w,a0
			addi.w	#$280,d6
loc_206ED4:
			cmp.w	(a0),d6
			bls.s	loc_206EE8
			tst.b	4(a0)
			bpl.s	loc_206EE2
			move.b	(a2),d2
			addq.b	#1,(a2)
loc_206EE2:
			bsr.w	sub_206F2C
			beq.s	loc_206ED4
loc_206EE8:
			move.l	a0,(dword_FFF770).w
			movea.l (dword_FFF774).w,a0
			subi.w	#$300,d6
			bcs.s	loc_206F08
loc_206EF6:
			cmp.w	(a0),d6
			bls.s	loc_206F08
			tst.b	4(a0)
			bpl.s	loc_206F04
			addq.b	#1,1(a2)
loc_206F04:
			addq.w	#8,a0
			bra.s	loc_206EF6
; ---------------------------------------------------------------------------
loc_206F08:
			move.l	a0,(dword_FFF774).w
locret_206F0C:
			rts
; =============== S U B R O U T I N E =======================================
sub_206F0E:
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
sub_206F2C:
			bsr.s	sub_206F0E
			beq.s	loc_206F3E
			tst.b	4(a0)
			bpl.s	loc_206F44
			bset	#7,2(a2,d3.w)
			beq.s	loc_206F44
loc_206F3E:
			addq.w	#8,a0
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_206F44:
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
loc_206F74:
			move.b	d0,obj.id(a1)
			move.b	(a0)+,obj.subtype(a1)
			move.b	(a0)+,d0
			move.b	(a0)+,obj.field_29(a1)
			moveq	#0,d0
locret_206F84:
			rts
; End of function sub_206F2C
; =============== S U B R O U T I N E =======================================
findfreeobj:
			lea	(byte_FFD800).w,a1
			move.w	#(byte_FFD800_end-byte_FFD800)/obj-1,d0
loc_206F8E:
			tst.b	(a1)
			beq.s	locret_206F9A
			lea	obj(a1),a1
			dbf	d0,loc_206F8E
locret_206F9A:
			rts
; End of function findfreeobj
; =============== S U B R O U T I N E =======================================
sub_206F9C:
			movea.l a0,a1
			move.w	#byte_FFD800_end,d0
			sub.w	a0,d0
			lsr.w	#6,d0
			subq.w	#1,d0
			bcs.s	locret_206FB6
loc_206FAA:
			tst.b	(a1)
			beq.s	locret_206FB6
			lea	obj(a1),a1
			dbf	d0,loc_206FAA
locret_206FB6:

			rts
; End of function sub_206F9C
; ---------------------------------------------------------------------------

loc_206FB8:
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
loc_206FF8:
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
locret_206FFE:
			rts
; ---------------------------------------------------------------------------
unk_207000: incbin	"Object Positions/ObjPos.bin"
			even
; ---------------------------------------------------------------------------
obj07:
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
locret_207B70:
			rts
; ---------------------------------------------------------------------------
loc_207B72:
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
off_207B78:
			dc.w loc_207B80-off_207B78
			dc.w loc_207BC6-off_207B78
			dc.w loc_207C3E-off_207B78
			dc.w loc_207C52-off_207B78
; ---------------------------------------------------------------------------
loc_207B80:
			move.l	#obj06_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.w	#$541,obj.vram(a0)
			addq.b	#2,obj.routine(a0)
			move.b	obj.subtype(a0),d0
			add.w	d0,d0
			andi.w	#$1E,d0
			lea	off_207D7C(pc),a2
			adda.w	(a2,d0.w),a2
			move.w	(a2)+,obj.field_3A(a0)
			move.l	a2,obj.field_3C(a0)
			move.w	(a2)+,obj.field_36(a0)
			move.w	(a2)+,obj.field_38(a0)
loc_207BC6:
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
locret_207C3C:
			rts
; ---------------------------------------------------------------------------
loc_207C3E:
			bsr.w	sub_207CCC
			addq.b	#2,obj.routine(a0)
			move.w	#$91,d0
			jsr	(queuesound2).l
			rts
; ---------------------------------------------------------------------------
loc_207C52:
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
loc_207C78:
			move.b	d1,obj.field_3A(a0)
			movea.l obj.field_3C(a0),a2
			move.w	(a2,d1.w),obj.field_36(a0)
			move.w	2(a2,d1.w),obj.field_38(a0)
			bra.w	sub_207CCC
; ---------------------------------------------------------------------------
loc_207C90:
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
loc_207CB6:
			andi.w	#$7FF,obj.ypos(a6)
			clr.b	obj.routine(a0)
			clr.b	obj.field_2C(a6)
			move.w	#2,obj.routine(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_207CCC:
			moveq	#0,d0
			move.w	obj.inertia(a6),d2
			move.w	obj.inertia(a6),d3
			move.w	obj.field_36(a0),d0
			sub.w	obj.xpos(a6),d0
			bge.s	loc_207CE4
			neg.w	d0
			neg.w	d2
loc_207CE4:
			moveq	#0,d1
			move.w	obj.field_38(a0),d1
			sub.w	obj.ypos(a6),d1
			bge.s	loc_207CF4
			neg.w	d1
			neg.w	d3
loc_207CF4:
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
loc_207D16:
			move.w	d0,obj.xvel(a6)
			move.w	d3,obj.yvel(a6)
			tst.w	d1
			bpl.s	loc_207D24
			neg.w	d1
loc_207D24:
			move.w	d1,obj.field_2E(a0)
			rts
; ---------------------------------------------------------------------------
loc_207D2A:
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
loc_207D48:
			move.w	d1,obj.yvel(a6)
			move.w	d2,obj.xvel(a6)
			tst.w	d0
			bpl.s	loc_207D56
			neg.w	d0
loc_207D56:
			move.w	d0,obj.field_2E(a0)
			rts
; End of function sub_207CCC
; =============== S U B R O U T I N E =======================================
sub_207D5C:
			moveq	#0,d0
			move.b	obj.subtype(a0),d0
			add.w	d0,d0
			move.w	word_207D74(pc,d0.w),d0
			cmp.w	obj.inertia(a6),d0
			ble.s	locret_207D72
			move.w	d0,obj.inertia(a6)
locret_207D72:
			rts
; End of function sub_207D5C
; ---------------------------------------------------------------------------
word_207D74:
			dc.w $1000
			dc.w $C00
			dc.w $C00
			dc.w $800
off_207D7C:
			dc.w unk_207D8C-off_207D7C
			dc.w unk_207E16-off_207D7C
			dc.w unk_207E5C-off_207D7C
			dc.w sub_207EA2-off_207D7C
			dc.w sub_207EA2-off_207D7C
			dc.w sub_207EA2-off_207D7C
			dc.w sub_207EA2-off_207D7C
			dc.w sub_207EA2-off_207D7C
unk_207D8C: dc.b   0
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
unk_207E16: dc.b   0
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
			dc.b $30
			dc.b   1
			dc.b $C8
unk_207E5C: dc.b   0
			dc.b $44
			dc.b $16
			dc.b $30
			dc.b   2
			dc.b $90
			dc.b $16
			dc.b $30
			dc.b   3
			dc.b $18
			dc.b $16
			dc.b $38
			dc.b   3
			dc.b $38
			dc.b $16
			dc.b $D0
			dc.b   3
			dc.b $D0
			dc.b $17
			dc.b   0
			dc.b   3
			dc.b $E0
			dc.b $17
			dc.b $38
			dc.b   3
			dc.b $C8
			dc.b $17
			dc.b $58
			dc.b   3
			dc.b $90
			dc.b $17
			dc.b $38
			dc.b   3
			dc.b $58
			dc.b $16
			dc.b $F8
			dc.b   3
			dc.b $40
			dc.b $16
			dc.b $C0
			dc.b   3
			dc.b $60
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
			dc.b $38
			dc.b   3
			dc.b $C8
			dc.b $17
			dc.b $B8
			dc.b   3
			dc.b $48
			dc.b $17
			dc.b $D0
			dc.b   3
			dc.b $20
			dc.b $17
			dc.b $D0
			dc.b   2
			dc.b $78
; =============== S U B R O U T I N E =======================================
sub_207EA2:
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
locret_207EDA:
			rts
; End of function sub_207EA2
; =============== S U B R O U T I N E =======================================
sub_207EDC:
			clr.b	obj.routine2(a0)
			clr.b	obj.field_3C(a1)
			bset	#3,obj.status(a0)
			bne.s	loc_207F0A
			bclr	#2,obj.status(a1)
			beq.s	loc_207F0A
			move.b	#$13,obj.height(a1)
			move.b	#9,obj.width(a1)
			subq.w	#5,obj.ypos(a1)
			move.b	#0,obj.ani(a1)
loc_207F0A:
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
loc_207F2C:
			move.w	a0,d0
			subi.w	#actwk,d0
			lsr.w	#6,d0
			andi.w	#$7F,d0
			move.b	d0,obj.field_3D(a1)
			move.b	#0,obj.angle(a1)
			move.w	#0,obj.yvel(a1)
			move.w	obj.xvel(a1),obj.inertia(a1)
			bclr	#1,obj.status(a1)
locret_207F54:
			rts
; End of function sub_207EDC
; =============== S U B R O U T I N E =======================================
sub_207F56:
			cmpi.b	#4,obj.routine(a1)
			bcc.w	loc_20805C
			cmpi.b	#$2B,obj.ani(a1)
			beq.w	loc_20805C
			tst.b	obj.id(a1)
			beq.w	loc_20805C
			tst.b	obj.render(a0)
			bpl.w	loc_20805C
			tst.b	(word_FF1208).l
			bne.w	loc_20805C
			moveq	#0,d1
			moveq	#0,d2
			move.b	obj.height(a0),d2
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
loc_207FD0:
			btst	#1,obj.render(a0)
			beq.s	loc_207FE2
			tst.w	obj.yvel(a1)
			bpl.w	loc_20805C
			bra.s	loc_207FEA
; ---------------------------------------------------------------------------
loc_207FE2:
			tst.w	obj.yvel(a1)
			bmi.w	loc_20805C
loc_207FEA:
			move.w	obj.ypos(a1),d0
			moveq	#0,d1
			move.b	obj.height(a1),d1
			btst	#1,obj.render(a0)
			beq.s	loc_208000
			sub.w	d1,d0
			bra.s	loc_208002
; ---------------------------------------------------------------------------
loc_208000:
			add.w	d1,d0
loc_208002:
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
loc_208028:
			sub.w	d2,obj.ypos(a1)
loc_20802C:
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
loc_20805C:
			bsr.w	sub_207EA2
			clr.b	obj.routine2(a0)
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_208068:
			bsr.w	sub_207EA2
			btst	#1,obj.status(a1)
			bne.s	loc_2080DA
			subq.w	#2,d2
			move.w	obj.ypos(a1),d0
			add.b	obj.height(a1),d0
			sub.w	d4,d0
			add.w	d2,d0
			bmi.s	loc_2080DA
			add.b	obj.height(a1),d2
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
loc_20809E:
			tst.w	obj.xvel(a1)
			bmi.s	loc_2080B2
loc_2080A4:
			bclr	#5,obj.status(a1)
			bclr	#5,obj.status(a0)
			bra.s	loc_2080BE
; ---------------------------------------------------------------------------
loc_2080B2:
			bset	#5,obj.status(a1)
			bset	#5,obj.status(a0)
loc_2080BE:
			cmp.w	d5,d6
			bcc.s	loc_2080C6
			add.w	d6,d6
			sub.w	d6,d5
loc_2080C6:
			sub.w	d5,obj.xpos(a1)
			move.w	#0,obj.inertia(a1)
			move.w	#0,obj.xvel(a1)
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_2080DA:
			bclr	#5,obj.status(a1)
			bclr	#5,obj.status(a0)
			moveq	#0,d0
			rts
; End of function sub_207F56
; =============== S U B R O U T I N E =======================================
sub_2080EA:
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_2080EA
; ---------------------------------------------------------------------------
obj09:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_208124(pc,d0.w),d0
			jsr	off_208124(pc,d0.w)
			tst.w	(word_FF1278).l
			bne.s	loc_208118
			lea	(obj09_ani).l,a1
			bsr.w	animateobj
loc_208118:
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_208124: dc.w loc_208128-off_208124
			dc.w loc_208152-off_208124
; ---------------------------------------------------------------------------
loc_208128:
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#4,obj.priority(a0)
			move.l	#obj09_map,obj.mappings(a0)
			moveq	#6,d0
			jsr	sub_20DC4C(pc)
			move.b	#$10,obj.field_19(a0)
			move.b	#8,obj.height(a0)
loc_208152:
			tst.b	obj.render(a0)
			bpl.w	locret_2081BC
			lea	(actwk).w,a1
			bsr.s	sub_2080EA
			beq.s	loc_208166
			bsr.s	sub_208172
			bra.s	loc_208168
; ---------------------------------------------------------------------------
loc_208166:
			bsr.s	sub_2081A6
loc_208168:
			lea	(byte_FFD040).w,a1
			bsr.w	sub_2080EA
			beq.s	sub_2081A6
; =============== S U B R O U T I N E =======================================
sub_208172:
			tst.w	(word_FF1278).l
			bne.s	locret_2081BC
			bset	#0,obj.field_2C(a1)
			bne.s	loc_2081A4
			move.b	#$2D,obj.ani(a1)
			moveq	#0,d0
			move.b	d0,obj.field_2B(a1)
			move.w	obj.xpos(a1),d0
			sub.w	obj.xpos(a0),d0
			bcc.s	loc_2081A0
			neg.w	d0
			move.b	#$80,obj.field_2B(a1)
loc_2081A0:
			move.b	d0,obj.field_39(a1)
loc_2081A4:
			bra.s	loc_2081BE
; End of function sub_208172
; =============== S U B R O U T I N E =======================================
sub_2081A6:
			moveq	#0,d0
			move.b	obj.field_3D(a1),d0
			lsl.w	#6,d0
			addi.l	#actwk&$FFFFFF,d0
			cmpa.w	d0,a0
			bne.s	locret_2081BC
			clr.b	obj.field_2C(a1)
locret_2081BC:
			rts
; End of function sub_2081A6
; ---------------------------------------------------------------------------

loc_2081BE:
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
			move.b	byte_20821C(pc,d0.w),obj.aniframe(a1)
			andi.b	#$3F,d1
			bne.s	loc_2081FE
			addq.b	#1,obj.field_39(a1)
loc_2081FE:
			move.w	(word_FFF604).w,(word_FFF602).w
			cmpi.b	#objid_01,obj.id(a1)
			beq.s	loc_208212
			move.w	(word_FFF606).w,(word_FFF602).w
loc_208212:
			bsr.w	sub_20822C
			bra.w	loc_20827E
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
byte_20821C:
			dc.b 0
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
sub_20822C:
			move.w	obj.xpos(a1),d0
			sub.w	obj.xpos(a0),d0
			bcc.s	loc_20825A
			btst	#2,(word_FFF602).w
			beq.s	loc_208244
			addq.b	#1,obj.field_39(a1)
			bra.s	locret_20827C
; ---------------------------------------------------------------------------
loc_208244:
			btst	#3,(word_FFF602).w
			beq.s	locret_20827C
			subq.b	#1,obj.field_39(a1)
			bcc.s	locret_20827C
			move.b	#0,obj.field_39(a1)
			bra.s	locret_20827C
; ---------------------------------------------------------------------------
loc_20825A:
			btst	#3,(word_FFF602).w
			beq.s	loc_208268
			addq.b	#1,obj.field_39(a1)
			bra.s	locret_20827C
; ---------------------------------------------------------------------------
loc_208268:
			btst	#2,(word_FFF602).w
			beq.s	locret_20827C
			subq.b	#1,obj.field_39(a1)
			bcc.s	locret_20827C
			move.b	#0,obj.field_39(a1)
locret_20827C:
			rts
; End of function sub_20822C
; ---------------------------------------------------------------------------
loc_20827E:
			move.b	(word_FFF602+1).w,d0
			andi.b	#$70,d0
			beq.w	locret_208332
			move.w	#$680,d2
			btst	#6,obj.status(a0)
			beq.s	loc_20829A
			move.w	#$380,d2
loc_20829A:
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
			tst.b	(chibi_flag).w
			beq.s	loc_2082EE
			move.b	#$A,obj.height(a1)
			move.b	#5,obj.width(a1)
			bra.s	loc_2082FA
; ---------------------------------------------------------------------------
loc_2082EE:
			move.b	#$13,obj.height(a1)
			move.b	#9,obj.width(a1)
loc_2082FA:
			btst	#2,obj.status(a1)
			bne.s	loc_208334
			tst.b	(chibi_flag).w
			beq.s	loc_208316
			move.b	#$A,obj.height(a1)
			move.b	#5,obj.width(a1)
			bra.s	loc_208326
; ---------------------------------------------------------------------------
loc_208316:
			move.b	#$E,obj.height(a1)
			move.b	#7,obj.width(a1)
			addq.w	#5,obj.ypos(a1)
loc_208326:
			bset	#2,obj.status(a1)
			move.b	#2,obj.ani(a1)
locret_208332:
			rts
; ---------------------------------------------------------------------------
loc_208334:
			bset	#4,obj.status(a1)
			rts
; ---------------------------------------------------------------------------
obj09_ani:
			dc.w unk_20833E-obj09_ani
unk_20833E: dc.b   1
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b $FF
			even
obj09_map:
			dc.w byte_20834A-obj09_map
			dc.w byte_208356-obj09_map
			dc.w byte_208362-obj09_map
byte_20834A:	dc.b 2
			dc.b $F8,  5,  0,  0,$F0
			dc.b $F8,  5,  8,  0,  0
			even
byte_208356:	dc.b 2
			dc.b $F8,  5,  0,  0,$F0
			dc.b $F8,  5,  8,  0,  0
			even
byte_208362:	dc.b 1
			dc.b $F8, $D,  0,  4,$F0
; ---------------------------------------------------------------------------
obj1B:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_208382(pc,d0.w),d0
			jsr	off_208382(pc,d0.w)
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_208382: dc.w loc_208386-off_208382
			dc.w loc_2083B8-off_208382
; ---------------------------------------------------------------------------
loc_208386:
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.b	#4,obj.priority(a0)
			move.l	#obj1B_map,obj.mappings(a0)
			move.b	#$10,obj.field_19(a0)
			move.b	#$10,obj.height(a0)
			move.b	#0,obj.frame(a0)
			moveq	#$B,d0
			jsr	(sub_20DC4C).l
loc_2083B8:
			tst.b	obj.render(a0)
			bpl.s	locret_2083D8
			lea	(actwk).w,a1
			bsr.w	sub_2083CA
			lea	(byte_FFD040).w,a1
; =============== S U B R O U T I N E =======================================
sub_2083CA:
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_2083CA
; ---------------------------------------------------------------------------
locret_2083D8:
			rts
; ---------------------------------------------------------------------------
obj1B_map:
			dc.w byte_2083DC-obj1B_map

byte_2083DC:	dc.b 2
			dc.b $F8,  2,  0,  0,$EC
			dc.b $F0, $F,  0,  3,$F4
			even
; ---------------------------------------------------------------------------
obj0F:
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
off_208416: dc.w loc_20841C-off_208416
			dc.w loc_20848A-off_208416
			dc.w loc_2084AA-off_208416
; ---------------------------------------------------------------------------
loc_20841C:
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.b	#4,obj.priority(a0)
			move.l	#obj0F_map,obj.mappings(a0)
			move.b	#8,obj.field_19(a0)
			move.b	#8,obj.height(a0)
			move.w	obj.xpos(a0),obj.field_36(a0)
			move.w	#$180,obj.xvel(a0)
			moveq	#$E,d0
			jsr	(sub_20DC4C).l
			jsr	(findfreeobj).l
			beq.s	loc_208462
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_208462:
			move.b	#objid_0A,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			subi.w	#$10,obj.ypos(a1)
			move.b	#$F0,obj.field_39(a1)
			move.w	a0,obj.field_34(a1)
			move.b	obj.subtype(a0),obj.subtype(a1)
loc_20848A:
			jsr	(sub_20611C).l
			tst.w	d1
			bpl.s	loc_2084A4
			add.w	d1,obj.ypos(a0)
			move.w	obj.ypos(a0),obj.field_32(a0)
			addq.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_2084A4:
			addq.w	#1,obj.ypos(a0)
			rts
; ---------------------------------------------------------------------------
loc_2084AA:
			tst.w	(word_FF1278).l
			bne.s	loc_2084E0
			jsr	(sub_20611C).l
			add.w	d1,obj.ypos(a0)
			move.w	obj.field_32(a0),d0
			sub.w	obj.ypos(a0),d0
			cmpi.w	#$C,d0
			bcs.s	loc_2084CE
			neg.w	obj.xvel(a0)
loc_2084CE:
			jsr	(sub_203166).l
			lea	(off_2089C0).l,a1
			jsr	(animateobj).l
loc_2084E0:
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
obj0A:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			beq.s	loc_2084F4
			tst.b	obj.render(a0)
			bpl.s	loc_2084FC
loc_2084F4:
			move.w	off_20854E(pc,d0.w),d1
			jsr	off_20854E(pc,d1.w)
loc_2084FC:
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
loc_20852E:
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
off_20854E: dc.w loc_208568-off_20854E
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
loc_208568:
			addq.b	#2,obj.routine(a0)
			move.l	#obj0A_map,obj.mappings(a0)
			move.w	#$520,obj.vram(a0)
			ori.b	#4,obj.render(a0)
			move.b	#$10,obj.field_19(a0)
			move.b	#8,obj.height(a0)
			move.w	obj.xpos(a0),obj.field_36(a0)
			move.b	#4,obj.priority(a0)
			move.b	obj.subtype(a0),d0
			btst	#2,d0
			beq.s	loc_2085BE
			move.b	#8,obj.routine(a0)
			move.b	#8,obj.field_19(a0)
			move.b	#$10,obj.height(a0)
			move.l	#obj0A_map_2,obj.mappings(a0)
			bra.s	loc_2085FA
; ---------------------------------------------------------------------------
loc_2085BE:
			btst	#3,d0
			beq.s	loc_2085E6
			move.b	#$14,obj.routine(a0)
			move.b	#$10,obj.height(a0)
			move.l	#obj0A_map_3,obj.mappings(a0)
			move.l	d0,-(sp)
			moveq	#$F,d0
			jsr	(sub_20DC4C).l
			move.l	(sp)+,d0
			bra.s	loc_2085FA
; ---------------------------------------------------------------------------
loc_2085E6:
			btst	#1,obj.render(a0)
			beq.s	loc_2085FA
			move.b	#$E,obj.routine(a0)
			bset	#1,obj.status(a0)
loc_2085FA:
			btst	#1,d0
			beq.s	loc_208606
			bset	#5,obj.vram(a0)
loc_208606:
			andi.w	#2,d0
			move.w	word_208612(pc,d0.w),obj.field_30(a0)
			rts
; ---------------------------------------------------------------------------
word_208612:
			dc.w $F000
			dc.w $F600
; =============== S U B R O U T I N E =======================================
sub_208616:
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_208616
; ---------------------------------------------------------------------------
loc_208624:
			tst.b	obj.render(a0)
			bpl.s	locret_20863C
			lea	(actwk).w,a1
			bsr.s	sub_208616
			beq.s	loc_208634
			bsr.s	sub_20863E
loc_208634:
			lea	(byte_FFD040).w,a1
			bsr.s	sub_208616
			bne.s	sub_20863E
locret_20863C:
			rts
; =============== S U B R O U T I N E =======================================
sub_20863E:
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
loc_208670:
			lea	(actwk).w,a1
			bsr.s	sub_208616
			lea	(byte_FFD040).w,a1
			bsr.s	sub_208616
			lea	(off_20891C).l,a1
			bra.w	animateobj
; ---------------------------------------------------------------------------
loc_208686:
			bclr	#3,obj.status(a0)
			move.b	#1,obj.prevani(a0)
			subq.b	#4,obj.routine(a0)
			move.b	#0,obj.frame(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_20869E:
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_20869E
; ---------------------------------------------------------------------------
loc_2086AC:
			tst.b	obj.render(a0)
			bpl.s	locret_2086D0
			lea	(actwk).w,a1
			bsr.s	sub_20869E
			btst	#5,obj.status(a0)
			beq.s	loc_2086C2
			bsr.s	sub_2086D2
loc_2086C2:
			lea	(byte_FFD040).w,a1
			bsr.s	sub_20869E
			btst	#5,obj.status(a0)
			bne.s	sub_2086D2
locret_2086D0:
			rts
; =============== S U B R O U T I N E =======================================
sub_2086D2:
			move.b	#$A,obj.routine(a0)
			move.w	obj.field_30(a0),obj.xvel(a1)
			addq.w	#8,obj.xpos(a1)
			bset	#0,obj.status(a1)
			btst	#0,obj.status(a0)
			bne.s	loc_208700
			subi.w	#$10,obj.xpos(a1)
			neg.w	obj.xvel(a1)
			bclr	#0,obj.status(a1)
loc_208700:
			move.w	#$F,obj.field_3E(a1)
			move.w	obj.xvel(a1),obj.inertia(a1)
			btst	#2,obj.status(a1)
			bne.s	loc_20871A
			move.b	#0,obj.ani(a1)
loc_20871A:
			clr.b	obj.angle(a1)
			bclr	#5,obj.status(a0)
			bclr	#5,obj.status(a1)
			move.w	#$98,d0
			jmp	(queuesound2).l
; End of function sub_2086D2
; ---------------------------------------------------------------------------
loc_208734:
			lea	(actwk).w,a1
			bsr.w	sub_20869E
			lea	(byte_FFD040).w,a1
			bsr.w	sub_20869E
			lea	(off_20891C).l,a1
			bra.w	animateobj
; ---------------------------------------------------------------------------
loc_20874E:
			move.b	#1,obj.prevani(a0)
			subq.b	#4,obj.routine(a0)
			move.b	#0,obj.frame(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_208760:

			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jmp	(sub_207F56).l
; End of function sub_208760
; ---------------------------------------------------------------------------
loc_20876E:
			tst.b	obj.render(a0)
			bpl.s	locret_208786
			lea	(actwk).w,a1
			bsr.s	sub_208760
			beq.s	loc_20877E
			bsr.s	sub_208788
loc_20877E:
			lea	(byte_FFD040).w,a1
			bsr.s	sub_208760
			bne.s	sub_208788
locret_208786:
			rts
; =============== S U B R O U T I N E =======================================
sub_208788:
			move.b	#$10,obj.routine(a0)
			subq.w	#8,obj.ypos(a1)
			move.w	obj.field_30(a0),obj.yvel(a1)
			neg.w	obj.yvel(a1)
			bset	#1,obj.status(a1)
			bclr	#3,obj.status(a1)
			bclr	#3,obj.status(a0)
			move.w	#$98,d0
			jsr	(queuesound2).l
loc_2087B8:
			lea	(actwk).w,a1
			bsr.s	sub_208760
			lea	(byte_FFD040).w,a1
			bsr.s	sub_208760
			lea	(off_20891C).l,a1
			bra.w	animateobj
; End of function sub_208788
; ---------------------------------------------------------------------------
loc_2087CE:
			move.b	#1,obj.prevani(a0)
			subq.b	#4,obj.routine(a0)
			move.b	#0,obj.frame(a0)
			rts
; ---------------------------------------------------------------------------
loc_2087E0:
			tst.b	obj.render(a0)
			bpl.s	locret_20880C
			lea	(actwk).w,a1
			bsr.w	sub_208760
			bne.s	loc_2087F8
			btst	#5,obj.status(a0)
			beq.s	loc_2087FA
loc_2087F8:
			bsr.s	sub_20880E
loc_2087FA:
			lea	(byte_FFD040).w,a1
			bsr.w	sub_208760
			bne.s	sub_20880E
			btst	#5,obj.status(a0)
			bne.s	sub_20880E
locret_20880C:
			rts
; =============== S U B R O U T I N E =======================================
sub_20880E:
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
loc_20884C:
			bclr	#0,obj.status(a1)
			subq.w	#8,obj.xpos(a1)
			btst	#0,obj.status(a0)
			beq.s	loc_20886E
			addi.w	#$10,obj.xpos(a1)
			bset	#0,obj.status(a1)
			neg.w	obj.xvel(a1)
loc_20886E:
			bset	#1,obj.status(a1)
			bclr	#3,obj.status(a1)
			bclr	#5,obj.status(a1)
			bclr	#3,obj.status(a0)
			bclr	#5,obj.status(a0)
			move.w	#$98,d0
			jsr	(queuesound2).l
loc_208896:
			lea	(off_20891C).l,a1
			bra.w	animateobj
; End of function sub_20880E
; ---------------------------------------------------------------------------
loc_2088A0:
			move.b	#1,obj.prevani(a0)
			subq.b	#4,obj.routine(a0)
			move.b	#0,obj.frame(a0)
			rts
; ---------------------------------------------------------------------------
off_2088B2:
			dc.w unk_2088B6-off_2088B2
			dc.w unk_2088C2-off_2088B2
unk_2088B6: dc.b   0
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
			even
unk_2088C2: dc.b   0
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
			even
off_2088CE:
			dc.w byte_2088DA-off_2088CE
			dc.w byte_2088E5-off_2088CE
			dc.w byte_2088EB-off_2088CE
			dc.w byte_2088FB-off_2088CE
			dc.w byte_208901-off_2088CE
			dc.w byte_208907-off_2088CE
byte_2088DA:	dc.b 2
			dc.b $F8, $C,  0,  0,$F0
			dc.b   0, $C,  0,  4,$F0
byte_2088E5:	dc.b 1
			dc.b   0, $C,  0,  0,$F0
byte_2088EB:	dc.b 3
			dc.b $E8, $C,  0,  0,$F0
			dc.b $F0,  5,  0,  8,$F8
			dc.b   0, $C,  0, $C,$F0
byte_2088FB:	dc.b 1
			dc.b $F0,  7,  0,  0,$F8
byte_208901:	dc.b 1
			dc.b $F0,  3,  0,  4,$F8
byte_208907:	dc.b 4
			dc.b $F0,  3,  0,  4,$10
			dc.b $F8,  9,  0,  8,$F8
			dc.b $F0,  0,  0,  0,$F8
			dc.b   8,  0,  0,  3,$F8
off_20891C:
			dc.w unk_20891E-off_20891C
unk_20891E: dc.b   0
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
			even
obj0A_map:
			dc.w byte_208936-obj0A_map
			dc.w byte_208942-obj0A_map
			dc.w byte_208948-obj0A_map
obj0A_map_2:
			dc.w byte_208958-obj0A_map_2
			dc.w byte_208964-obj0A_map_2
			dc.w byte_20896A-obj0A_map_2
byte_208936:	dc.b 2
			dc.b $F8, $C,  0,  0,$F0
			dc.b   0, $C,  0,  4,$F0
			even
byte_208942:	dc.b 1
			dc.b   0, $C,  0,  0,$F0
byte_208948:	dc.b 3
			dc.b $E0, $C,  0,  0,$F0
			dc.b $E8,  6,  0,  8,$F8
			dc.b   0, $C,  0, $E,$F0
byte_208958:	dc.b 2
			dc.b $F0,  3,  0,$12,  0
			dc.b $F0,  3,  0,$16,$F8
			even
byte_208964:	dc.b 1
			dc.b $F0,  3,  0,$12,$F8
byte_20896A:	dc.b 3
			dc.b $F0,  3,  0,$12,$18
			dc.b $F8,  9,  0,$1A,  0
			dc.b $F0,  3,  0,$20,$F8
obj0A_map_3:
			dc.w byte_208980-obj0A_map_3
			dc.w byte_208990-obj0A_map_3
			dc.w byte_2089A6-obj0A_map_3
byte_208980:	dc.b 3
			dc.b $F0,  8,  0,  0,$F0
			dc.b $F8, $D,  0,  3,$F0
			dc.b   8,  8,  0, $B,$F8
byte_208990:	dc.b 4
			dc.b $F0,  5,  0, $E,$F0
			dc.b $F8,  0,  0,$12,  0
			dc.b   0,  0,  0,$13,$F0
			dc.b   0,  9,  0,$14,$F8
			even
byte_2089A6:	dc.b 5
			dc.b $E0,  8,  0,  0,  0
			dc.b $E8, $E,  0,$1A,  0
			dc.b $F0,  1,  0,$26,$F8
			dc.b $F8,  1,  0,$28,$F0
			dc.b   0,  5,  0,$2A,$F8
off_2089C0:
			dc.w unk_2089C2-off_2089C0
unk_2089C2: dc.b   8
			dc.b   0
			dc.b   1
			dc.b $FF
			even
obj0F_map:
			dc.w byte_2089CA-obj0F_map
			dc.w byte_2089D0-obj0F_map
byte_2089CA:	dc.b 1
			dc.b $F8,  5,  0,  0,$F8
byte_2089D0:	dc.b 1
			dc.b $F8,  5,  0,  4,$F8
; ---------------------------------------------------------------------------
obj10:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2089E4(pc,d0.w),d1
			jmp	off_2089E4(pc,d1.w)
; ---------------------------------------------------------------------------
off_2089E4: dc.w loc_208A0E-off_2089E4
			dc.w loc_208AFE-off_2089E4
			dc.w loc_208B30-off_2089E4
			dc.w loc_208B6A-off_2089E4
			dc.w loc_208B78-off_2089E4
byte_2089EE:
			dc.b $10,  0
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
loc_208A0E:
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
			move.b	obj.subtype(a0),d1
			moveq	#0,d0
			move.b	d1,d0
			andi.w	#7,d1
			cmpi.w	#7,d1
			bne.s	loc_208A44
			moveq	#6,d1
loc_208A44:
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
loc_208A70:
			move.b	-(a3),d4
			lsr.b	d1,d4
			bcs.s	loc_208AEA
			dbf	d0,loc_208A70
			bclr	#7,(a2)
			bra.s	loc_208AA2
; ---------------------------------------------------------------------------
loc_208A80:
			swap	d1
			lea	1(a2),a3
			moveq	#0,d0
			move.b	(byte_FF123D).l,d0
loc_208A8E:
			move.b	-(a3),d4
			lsr.b	d1,d4
			bcs.s	loc_208AEA
			dbf	d0,loc_208A8E
			bclr	#7,(a2)
			bsr.w	findfreeobj
			bne.s	loc_208AF6
loc_208AA2:
			move.b	#objid_10,obj.id(a1)
			addq.b	#2,obj.routine(a1)
			move.w	d2,obj.xpos(a1)
			move.w	obj.xpos(a0),obj.field_32(a1)
			move.w	d3,obj.ypos(a1)
			move.l	#ring_map,obj.mappings(a1)
			move.w	#$A7AE,obj.vram(a1)
			move.b	#4,obj.render(a1)
			move.b	#2,obj.priority(a1)
			move.b	#$47,obj.colflag(a1)
			move.b	#8,obj.field_19(a1)
			move.b	obj.field_23(a0),obj.field_23(a1)
			move.b	d1,obj.field_34(a1)
loc_208AEA:
			addq.w	#1,d1
			add.w	d5,d2
			add.w	d6,d3
			swap	d1
			dbf	d1,loc_208A80
loc_208AF6:
			btst	#0,(a2)
			bne.w	deleteobj
loc_208AFE:
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
			move.b	(ring_frame).l,obj.frame(a0)
loc_208B2C:
			bra.w	displaysprite
; ---------------------------------------------------------------------------
loc_208B30:
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
loc_208B6A:
			lea	(ring_ani).l,a1
			bsr.w	animateobj
			bra.w	displaysprite
; ---------------------------------------------------------------------------
loc_208B78:
			bra.w	deleteobj
; =============== S U B R O U T I N E =======================================
sub_208B7C:
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
loc_208BB6:
			addq.b	#1,(byte_FF1212).l
			addq.b	#1,(byte_FF121C).l
			move.w	#$88,d0
loc_208BC6:
			jmp	(queuesound2).l
; End of function sub_208B7C
; ---------------------------------------------------------------------------
obj11:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_208BDA(pc,d0.w),d1
			jmp	off_208BDA(pc,d1.w)
; ---------------------------------------------------------------------------
off_208BDA: dc.w loc_208BE4-off_208BDA
			dc.w loc_208CB0-off_208BDA
			dc.w loc_208D08-off_208BDA
			dc.w loc_208D1C-off_208BDA
			dc.w loc_208D2A-off_208BDA
; ---------------------------------------------------------------------------
loc_208BE4:
			movea.l a0,a1
			moveq	#0,d5
			move.w	(word_FF1220).l,d5
			moveq	#$20,d0
			cmp.w	d0,d5
			bcs.s	loc_208BF6
			move.w	d0,d5
loc_208BF6:
			subq.w	#1,d5
			move.w	#$288,d4
			bra.s	loc_208C06
; ---------------------------------------------------------------------------
loc_208BFE:
			bsr.w	findfreeobj
			bne.w	loc_208C8E
loc_208C06:
			move.b	#objid_11,obj.id(a1)
			addq.b	#2,obj.routine(a1)
			move.b	#8,obj.height(a1)
			move.b	#8,obj.width(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.l	#ring_map,obj.mappings(a1)
			move.w	#$A7AE,obj.vram(a1)
			move.b	#4,obj.render(a1)
			move.b	#3,obj.priority(a1)
			move.b	#$47,obj.colflag(a1)
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
loc_208C7E:
			move.w	d2,obj.xvel(a1)
			move.w	d3,obj.yvel(a1)
			neg.w	d2
			neg.w	d4
			dbf	d5,loc_208BFE
loc_208C8E:
			move.w	#0,(word_FF1220).l
			move.b	#$80,(byte_FF121D).l
			move.b	#0,(byte_FF121B).l
			move.w	#$94,d0
			jsr	(queuesound2).l
loc_208CB0:
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
loc_208CEE:
			tst.b	(byte_FF12C6).l
			beq.s	loc_208D2A
			move.w	(dword_FFF72C+2).w,d0
			addi.w	#224,d0
			cmp.w	obj.ypos(a0),d0
			bcs.s	loc_208D2A
			bra.w	displaysprite
; ---------------------------------------------------------------------------
loc_208D08:
			addq.b	#2,obj.routine(a0)
			move.b	#0,obj.colflag(a0)
			move.b	#1,obj.priority(a0)
			bsr.w	sub_208B7C
loc_208D1C:
			lea	(ring_ani).l,a1
			bsr.w	animateobj
			bra.w	displaysprite
; ---------------------------------------------------------------------------
loc_208D2A:
			bra.w	deleteobj
; ---------------------------------------------------------------------------
ring_ani:
			dc.w unk_208D30-ring_ani

unk_208D30: dc.b   5
			dc.b   4
			dc.b   5
			dc.b   6
			dc.b   7
			dc.b $FC
			even
ring_map:
			dc.w byte_208D48-ring_map
			dc.w byte_208D4E-ring_map
			dc.w byte_208D54-ring_map
			dc.w byte_208D5A-ring_map
			dc.w byte_208D60-ring_map
			dc.w byte_208D66-ring_map
			dc.w byte_208D6C-ring_map
			dc.w byte_208D72-ring_map
			dc.w byte_208D78-ring_map
byte_208D48:	dc.b 1
			dc.b $F8,  5,  0,  0,$F8
byte_208D4E:	dc.b 1
			dc.b $F8,  5,  0,  4,$F8
byte_208D54:	dc.b 1
			dc.b $F8,  1,  0,  8,$FC
byte_208D5A:	dc.b 1
			dc.b $F8,  5,  8,  4,$F8
byte_208D60:	dc.b 1
			dc.b $F8,  5,  0, $A,$F8
byte_208D66:	dc.b 1
			dc.b $F8,  5,$18, $A,$F8
byte_208D6C:	dc.b 1
			dc.b $F8,  5,$10, $A,$F8
byte_208D72:	dc.b 1
			dc.b $F8,  5,  8, $A,$F8
byte_208D78:	dc.b 0
			even
off_208D7A: dc.w byte_208D82-off_208D7A
			dc.w byte_208DB5-off_208D7A
			dc.w byte_208DDE-off_208D7A
			dc.w byte_208DF3-off_208D7A
byte_208D82:	dc.b $A
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
byte_208DB5:	dc.b 8
			dc.b $E0, $C,  0,$2C,$F0
			dc.b $E8,  8,  0,$30,$E8
			dc.b $E8,  9,  0,$33,  0
			dc.b $F0,  7,  0,$39,$E8
			dc.b $F8,  5,  0,$41,  8
			dc.b   8,  9,  0,$45,  0
			dc.b $10,  8,  0,$4B,$E8
			dc.b $18, $C,  0,$4E,$F0
byte_208DDE:	dc.b 4
			dc.b $E0,  7,  0,$52,$F4
			dc.b $E0,  3,  8,$52,  4
			dc.b   0,  7,  0,$5A,$F4
			dc.b   0,  3,  8,$5A,  4
byte_208DF3:	dc.b 8
			dc.b $E0, $C,  8,$2C,$F0
			dc.b $E8,  8,  8,$30,  0
			dc.b $E8,  9,  8,$33,$E8
			dc.b $F0,  7,  8,$39,  8
			dc.b $F8,  5,  8,$41,$E8
			dc.b   8,  9,  8,$45,$E8
			dc.b $10,  8,  8,$4B,  0
			dc.b $18, $C,  8,$4E,$F0
off_208E1C: dc.w byte_208E2C-off_208E1C
			dc.w byte_208E37-off_208E1C
			dc.w byte_208E4C-off_208E1C
			dc.w byte_208E61-off_208E1C
			dc.w byte_208E76-off_208E1C
			dc.w byte_208E8B-off_208E1C
			dc.w byte_208EA0-off_208E1C
			dc.w byte_208EAB-off_208E1C
byte_208E2C:	dc.b 2
			dc.b $E0, $F,  0,  0,  0
			dc.b   0, $F,$10,  0,  0
byte_208E37:	dc.b 4
			dc.b $E0, $F,  0,$10,$F0
			dc.b $E0,  7,  0,$20,$10
			dc.b   0, $F,$10,$10,$F0
			dc.b   0,  7,$10,$20,$10
byte_208E4C:	dc.b 4
			dc.b $E0, $F,  0,$28,$E8
			dc.b $E0, $B,  0,$38,  8
			dc.b   0, $F,$10,$28,$E8
			dc.b   0, $B,$10,$38,  8
byte_208E61:	dc.b 4
			dc.b $E0, $F,  8,$34,$E0
			dc.b $E0, $F,  0,$34,  0
			dc.b   0, $F,$18,$34,$E0
			dc.b   0, $F,$10,$34,  0
byte_208E76:	dc.b 4
			dc.b $E0, $B,  8,$38,$E0
			dc.b $E0, $F,  8,$28,$F8
			dc.b   0, $B,$18,$38,$E0
			dc.b   0, $F,$18,$28,$F8
byte_208E8B:	dc.b 4
			dc.b $E0,  7,  8,$20,$E0
			dc.b $E0, $F,  8,$10,$F0
			dc.b   0,  7,$18,$20,$E0
			dc.b   0, $F,$18,$10,$F0
byte_208EA0:	dc.b 2
			dc.b $E0, $F,  8,  0,$E0
			dc.b   0, $F,$18,  0,$E0
byte_208EAB:	dc.b 4
			dc.b $E0, $F,  0,$44,$E0
			dc.b $E0, $F,  8,$44,  0
			dc.b   0, $F,$10,$44,$E0
			dc.b   0, $F,$18,$44,  0
; ---------------------------------------------------------------------------
obj12:
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
off_208EEE: dc.w loc_208EFC-off_208EEE
			dc.w loc_208F2E-off_208EEE
			dc.w loc_208F72-off_208EEE
			dc.w loc_208F94-off_208EEE
			dc.w loc_208FB8-off_208EEE
			dc.w loc_208FE6-off_208EEE
			dc.w loc_208FFA-off_208EEE
; ---------------------------------------------------------------------------
loc_208EFC:
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.l	#obj12_map,obj.mappings(a0)
			moveq	#5,d0
			jsr	(sub_20DC4C).l
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			move.b	#4,obj.height(a0)
			move.b	#5,obj.frame(a0)
loc_208F2E:
			bsr.w	sub_209002
			tst.b	(byte_FF123D).l
			beq.s	loc_208F68
			cmpi.b	#2,(byte_FF123D).l
			bne.s	loc_208F4E
			btst	#3,obj.status(a0)
			bne.s	loc_208F6E
			bra.s	loc_208F68
; ---------------------------------------------------------------------------
loc_208F4E:
			move.b	#0,obj.frame(a0)
			btst	#3,obj.status(a0)
			beq.s	loc_208F68
			move.b	#6,obj.routine(a0)
			move.b	#1,obj.ani(a0)
loc_208F68:
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_208F6E:
			addq.b	#2,obj.routine(a0)
loc_208F72:
			bsr.w	sub_209002
			addq.w	#2,obj.ypos(a0)
			move.w	(dword_FFF704).w,d0
			addi.w	#224,d0
			cmp.w	obj.ypos(a0),d0
			bcc.s	loc_208F8E
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_208F8E:
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_208F94:
			bsr.w	sub_209002
			btst	#3,obj.status(a0)
			bne.s	loc_208FA8
			move.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_208FA8:
			lea	(obj12_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_208FB8:
			move.b	#0,obj.ani(a0)
			bsr.w	sub_209002
			btst	#3,obj.status(a0)
			bne.s	loc_208FD6
			addq.b	#2,obj.routine(a0)
			move.b	#2,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_208FD6:
			lea	(obj12_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_208FE6:
			bsr.w	sub_209002
			lea	(obj12_ani).l,a1
			bsr.w	animateobj
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_208FFA:
			move.b	#2,obj.routine(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_209002:
			lea	(actwk).w,a1
			bsr.w	sub_20900E
			lea	(byte_FFD040).w,a1
; End of function sub_209002
; =============== S U B R O U T I N E =======================================
sub_20900E:
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			subq.w	#8,d4
			jmp	(sub_207F56).l
; End of function sub_20900E
; ---------------------------------------------------------------------------
obj12_ani:	dc.w unk_209024-obj12_ani
			dc.w unk_209028-obj12_ani
			dc.w unk_209032-obj12_ani
unk_209024: dc.b   2
			dc.b   5
			dc.b $FF
			even
unk_209028: dc.b   2
			dc.b   1
			dc.b   5
			dc.b   2
			dc.b   5
			dc.b   3
			dc.b   5
			dc.b   4
			dc.b   5
			dc.b $FC
			even
unk_209032: dc.b   2
			dc.b   1
			dc.b   0
			dc.b   2
			dc.b   0
			dc.b   3
			dc.b   0
			dc.b   4
			dc.b   0
			dc.b $FC
			even
obj12_map:	dc.w byte_209048-obj12_map
			dc.w byte_20904A-obj12_map
			dc.w byte_20905A-obj12_map
			dc.w byte_20906A-obj12_map
			dc.w byte_209076-obj12_map
			dc.w byte_209082-obj12_map
byte_209048:	dc.b 0
			even
byte_20904A:	dc.b 3
			dc.b $F4,  9,  0,  0,$F4
			dc.b   4,  0,  0,  0,$FC
			dc.b   4,  0,  0,  0,  4
byte_20905A:	dc.b 3
			dc.b $F4,  9,  8,  0,$F4
			dc.b   4,  0,  8,  0,$F4
			dc.b   4,  0,  8,  0,$FC
byte_20906A:	dc.b 2
			dc.b $F4,  9,$18,  0,$F4
			dc.b   4,  0,$18,  0,$FC
			even
byte_209076:	dc.b 2
			dc.b $F4,  9,$10,  0,$F4
			dc.b   4,  0,$10,  0,$FC
			even
byte_209082:	dc.b 1
			dc.b $F4, $A,  0,  6,$F4
; ---------------------------------------------------------------------------
loc_209088:
			tst.b	(byte_FF0580_ext).l
			beq.s	loc_209096
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_209096:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2090B0(pc,d0.w),d0
			jsr	off_2090B0(pc,d0.w)
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_2090B0: dc.w loc_2090B8-off_2090B0
			dc.w loc_209124-off_2090B0
			dc.w loc_209154-off_2090B0
			dc.w locret_20917A-off_2090B0
; ---------------------------------------------------------------------------
loc_2090B8:
			addq.b	#2,obj.routine(a0)
			move.b	#$E,obj.height(a0)
			move.b	#$E,obj.width(a0)
			move.l	#monitor_map,obj.mappings(a0)
			move.w	#$5A8,obj.vram(a0)
			move.b	#4,obj.render(a0)
			move.b	#3,obj.priority(a0)
			move.b	#$F,obj.field_19(a0)
			move.b	obj.subtype(a0),obj.ani(a0)
			bsr.w	sub_20917C
			bclr	#7,2(a2,d0.w)
			move.b	#$A,obj.frame(a0)
			cmpi.b	#8,obj.subtype(a0)
			beq.s	loc_20910A
			addq.b	#2,obj.frame(a0)
loc_20910A:
			btst	#0,2(a2,d0.w)
			beq.s	loc_20911E
			addq.b	#1,obj.frame(a0)
			move.b	#6,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20911E:
			move.b	#$DF,obj.colflag(a0)
loc_209124:
			tst.b	obj.field_21(a0)
			beq.s	locret_209152
			move.b	#$3C,obj.field_2A(a0)
			addq.b	#2,obj.routine(a0)
			bsr.w	sub_20917C
			bset	#0,2(a2,d0.w)
			move.b	#$FF,(byte_FFF784).w
			cmpi.b	#8,obj.subtype(a0)
			beq.s	locret_209152
			move.b	#1,(byte_FFF784).w
locret_209152:
			rts
; ---------------------------------------------------------------------------
loc_209154:
			subq.b	#1,obj.field_2A(a0)
			beq.s	loc_209164
			lea	(monitor_ani).l,a1
			bra.w	animateobj
; ---------------------------------------------------------------------------
loc_209164:
			addq.b	#2,obj.routine(a0)
			move.b	#$B,obj.frame(a0)
			cmpi.b	#8,obj.subtype(a0)
			beq.s	locret_20917A
			addq.b	#2,obj.frame(a0)
locret_20917A:
			rts
; =============== S U B R O U T I N E =======================================
sub_20917C:
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
sub_20919A:
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			move.b	#1,obj.routine2(a0)
			jmp	(sub_207F56).l
; End of function sub_20919A
; ---------------------------------------------------------------------------
obj19:
			cmpi.b	#8,obj.subtype(a0)
			bcc.w	loc_209088
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2091C6(pc,d0.w),d1
			jmp	off_2091C6(pc,d1.w)
; ---------------------------------------------------------------------------
off_2091C6: dc.w loc_2091D0-off_2091C6
			dc.w loc_20922C-off_2091C6
			dc.w loc_20928C-off_2091C6
			dc.w loc_209270-off_2091C6
			dc.w loc_209282-off_2091C6
; ---------------------------------------------------------------------------
loc_2091D0:
			addq.b	#2,obj.routine(a0)
			move.b	#$E,obj.height(a0)
			move.b	#$E,obj.width(a0)
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
loc_209220:
			move.b	#$46,obj.colflag(a0)
			move.b	obj.subtype(a0),obj.ani(a0)
loc_20922C:
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
loc_20925A:
			tst.b	obj.render(a0)
			bpl.s	loc_209270
			lea	(actwk).w,a1
			bsr.w	sub_20919A
			lea	(byte_FFD040).w,a1
			bsr.w	sub_20919A
loc_209270:
			tst.w	(word_FF1278).l
			bne.s	loc_209282
			lea	(monitor_ani).l,a1
			bsr.w	animateobj
loc_209282:
			bsr.w	displaysprite
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
loc_20928C:
			move.w	#$96,d0
			jsr	(queuesound2).l
			addq.b	#4,obj.routine(a0)
			move.b	#0,obj.colflag(a0)
			bsr.w	findfreeobj
			bne.s	loc_2092BE
			move.b	#objid_1A,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.b	obj.ani(a0),obj.ani(a1)
loc_2092BE:
			bsr.w	findfreeobj
			bne.s	loc_2092DC
			move.b	#objid_18,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.b	#1,obj.routine2(a1)
loc_2092DC:
			bsr.w	sub_20917C
			bset	#0,2(a2,d0.w)
			move.b	#$11,obj.frame(a0)
			bra.w	displaysprite
; ---------------------------------------------------------------------------
obj1A:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_209302(pc,d0.w),d1
			jsr	off_209302(pc,d1.w)
			bra.w	displaysprite
; ---------------------------------------------------------------------------
off_209302: dc.w loc_209308-off_209302
			dc.w loc_209346-off_209302
			dc.w loc_2094A2-off_209302
; ---------------------------------------------------------------------------
loc_209308:
			addq.b	#2,obj.routine(a0)
			move.w	#$5A8,obj.vram(a0)
			move.b	#$24,obj.render(a0)
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
loc_209346:
			tst.w	obj.yvel(a0)
			bpl.w	loc_20935A
			bsr.w	sub_203166
			addi.w	#$18,obj.yvel(a0)
			rts
; ---------------------------------------------------------------------------
loc_20935A:
			addq.b	#2,obj.routine(a0)
			move.w	#29,obj.time(a0)
			jsr	(sub_2023EA).l
			move.b	obj.ani(a0),d0
			bne.s	loc_209386
loc_209370:
			addq.b	#1,(byte_FF1212).l
			addq.b	#1,(byte_FF121C).l
			move.w	#$88,d0
			jmp	(queuesound1).l
; ---------------------------------------------------------------------------
loc_209386:
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
loc_2093C8:
			move.w	#$B5,d0
			jmp	(queuesound1).l
; ---------------------------------------------------------------------------
loc_2093D2:
			cmpi.b	#2,d0
			bne.s	loc_2093F0
; =============== S U B R O U T I N E =======================================
sub_2093D8:
			move.b	#1,(byte_FF122C).l
			move.b	#3,(byte_FFD180).w
			move.w	#$AF,d0
			jmp	(queuesound1).l
; End of function sub_2093D8
; ---------------------------------------------------------------------------
loc_2093F0:
			cmpi.b	#3,d0
			bne.s	loc_209450
; =============== S U B R O U T I N E =======================================
sub_2093F6:
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
locret_20944E:

			rts
; End of function sub_2093F6
; ---------------------------------------------------------------------------
loc_209450:
			cmpi.b	#4,d0
			bne.s	loc_209480
loc_209456:
			move.b	#1,(byte_FF122E).l
			move.w	#1200,obj.field_34(a6)
			move.w	#$C00,(word_FFF760).w
			move.w	#$18,(word_FFF762).w
			move.w	#$80,(word_FFF764).w
			move.w	#$E2,d0
			jmp	(queuesound1).l
; ---------------------------------------------------------------------------
loc_209480:
			cmpi.b	#5,d0
			bne.s	loc_209490
			move.w	#$12C,(word_FF1278).l
			rts
; ---------------------------------------------------------------------------
loc_209490:
			cmpi.b	#6,d0
			bne.s	loc_209498
			nop
loc_209498:
			bsr.w	sub_2093D8
			bsr.w	sub_2093F6
			bra.s	loc_209456
; ---------------------------------------------------------------------------
loc_2094A2:
			subq.w	#1,obj.time(a0)
			bmi.w	deleteobj
			rts
; ---------------------------------------------------------------------------
monitor_ani:
			dc.w unk_2094C0-monitor_ani
			dc.w unk_2094CC-monitor_ani
			dc.w unk_2094D8-monitor_ani
			dc.w unk_2094E4-monitor_ani
			dc.w unk_2094F0-monitor_ani
			dc.w unk_2094FC-monitor_ani
			dc.w unk_209508-monitor_ani
			dc.w unk_209514-monitor_ani
			dc.w unk_209520-monitor_ani
			dc.w unk_20952A-monitor_ani
unk_2094C0: dc.b   1
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
			even
unk_2094CC: dc.b   1
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
			even
unk_2094D8: dc.b   1
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
			even
unk_2094E4: dc.b   1
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
			even
unk_2094F0: dc.b   1
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
			even
unk_2094FC: dc.b   1
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
			even
unk_209508: dc.b   1
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
			even
unk_209514: dc.b   1
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
			even
unk_209520: dc.b   1
			dc.b  $A
			dc.b  $E
			dc.b  $F
			dc.b  $E
			dc.b  $B
			dc.b  $E
			dc.b  $F
			dc.b  $E
			dc.b $FF
			even
unk_20952A: dc.b   1
			dc.b  $C
			dc.b  $E
			dc.b  $F
			dc.b  $E
			dc.b  $D
			dc.b  $E
			dc.b  $F
			dc.b  $E
			dc.b $FF
			even
monitor_map:	dc.w byte_209558-monitor_map
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
byte_209558:	dc.b 4
			dc.b $F6,  5,  0,$12,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_20956E:	dc.b 4
			dc.b $F6,  5,  0,$16,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_209584:	dc.b 4
			dc.b $F6,  5,  0,$1A,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_20959A:	dc.b 4
			dc.b $F6,  5,  0,$1E,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_2095B0:	dc.b 4
			dc.b $F6,  5,  0,$22,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_2095C6:	dc.b 4
			dc.b $F6,  5,  0,$26,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_2095DC:	dc.b 4
			dc.b $F6,  5,  0,$2A,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_2095F2:	dc.b 4
			dc.b $F6,  5,  0,$2E,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_209608:	dc.b 4
			dc.b $F6,  5,  0,$48,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_20961E:	dc.b 4
			dc.b $F6,  5,  8,$48,$F8
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
			even
byte_209634:	dc.b 5
			dc.b $D8, $D,  0,$32,$F0
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_20964E:	dc.b 5
			dc.b $D8, $D,  8,$32,$F0
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_209668:	dc.b 5
			dc.b $D8, $D,  0,$3A,$F0
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_209682:	dc.b 5
			dc.b $D8, $D,  8,$3A,$F0
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_20969C:	dc.b 5
			dc.b $D8,  5,  0,$42,$F8
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_2096B6:	dc.b 5
			dc.b $D8,  1,  0,$46,$FC
			dc.b $E8,  3,  0,$4C,$F8
			dc.b $E8,  3,  8,$4C,  0
			dc.b   8,  1,  0,$50,$F8
			dc.b   8,  1,  8,$50,  0
byte_2096D0:	dc.b 3
			dc.b $F0,  6,  0,  0,$F0
			dc.b $F0,  6,  8,  0,  0
			dc.b   8, $C,  0,  6,$F0
byte_2096E0:	dc.b 1
			dc.b   0, $D,  0, $A,$F0
; ---------------------------------------------------------------------------
obj1C:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_2096F4(pc,d0.w),d0
			jmp	off_2096F4(pc,d0.w)
; ---------------------------------------------------------------------------
off_2096F4: dc.w loc_2096F8-off_2096F4
			dc.w loc_20973C-off_2096F4
; ---------------------------------------------------------------------------
loc_2096F8:
			addq.b	#2,obj.routine(a0)
			move.l	#hud_map,obj.mappings(a0)
			move.w	#$8568,obj.vram(a0)
			move.w	#$90,obj.xpos(a0)
			move.w	#$88,obj.scrypos(a0)
			tst.w	(word_FF13FA).l
			beq.s	loc_209724
			move.b	#2,obj.frame(a0)
loc_209724:
			tst.b	obj.subtype(a0)
			beq.s	loc_20973C
			move.w	#$90,obj.xpos(a0)
			move.w	#$148,obj.scrypos(a0)
			move.b	#1,obj.frame(a0)
loc_20973C:
			tst.b	obj.subtype(a0)
			bne.s	loc_209756
			move.b	#0,obj.frame(a0)
			tst.w	(word_FF13FA).l
			beq.s	loc_209756
			move.b	#2,obj.frame(a0)
loc_209756:
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
hud_map:	dc.w byte_209762-hud_map
			dc.w byte_2097B8-hud_map
			dc.w byte_2097C8-hud_map
byte_209762:	dc.b 17
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
byte_2097B8:	dc.b 3
			dc.b   0,  5,  0,$37,  0
			dc.b   8,  0,  0,$1A,$10
			dc.b   0,  1,  0,$3B,$18
			even
byte_2097C8:	dc.b 14
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
sub_209810:
			move.b	#1,(byte_FF121F).l
			lea	(dword_FF1226).l,a3
			add.l	d0,(a3)
			move.l	#999999,d1
			cmp.l	(a3),d1
			bhi.s	loc_20982C
			move.l	d1,(a3)
loc_20982C:
			move.l	(a3),d0
			rts
; End of function sub_209810
; =============== S U B R O U T I N E =======================================
sub_209830:
			tst.w	(word_FF13FA).l
			beq.s	loc_209852
			bsr.w	sub_2099C0
			move.l	#$73200002,d0
			moveq	#0,d1
			move.b	(byte_FF188A).l,d1
			bsr.w	sub_209AEA
			bra.w	loc_209896
; ---------------------------------------------------------------------------
loc_209852:
			tst.b	(byte_FF121F).l
			beq.s	loc_209870
			clr.b	(byte_FF121F).l
			move.l	#$70600002,d0
			move.l	(dword_FF1226).l,d1
			bsr.w	sub_2099E8
loc_209870:
			tst.b	(byte_FF121D).l
			beq.s	loc_209896
			bpl.s	loc_20987E
			bsr.w	sub_209952
loc_20987E:
			clr.b	(byte_FF121D).l
			move.l	#$73200002,d0
			moveq	#0,d1
			move.w	(word_FF1220).l,d1
			bsr.w	sub_2099DE
loc_209896:
			tst.w	(word_FF13FA).l
			bne.w	loc_209924
			tst.b	(byte_FF121E).l
			beq.s	loc_209924
			tst.w	(word_FFF63A).w
			bne.s	loc_209924
			lea	(byte_FF1222).l,a1
			cmpi.l	#hudmscs(9,59,59),(a1)+
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
loc_2098DE:
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
loc_209924:
			tst.b	(byte_FF121C).l
			beq.s	locret_209936
			clr.b	(byte_FF121C).l
			bsr.w	sub_209AD4
locret_209936:
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
sub_209952:
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
loc_209982:
			lea	(cg_hudnumbersletters).l,a1
loc_209988:
			move.w	#16-1,d1
			move.b	(a2)+,d0
			bmi.s	loc_2099A4
			ext.w	d0
			lsl.w	#5,d0
			lea	(a1,d0.w),a3
loc_209998:
			move.l	(a3)+,(a6)
			dbf	d1,loc_209998
loc_20999E:
			dbf	d2,loc_209988
			rts
; ---------------------------------------------------------------------------
loc_2099A4:

			move.l	#0,(a6)
			dbf	d1,loc_2099A4
			bra.s	loc_20999E
; End of function sub_209952
; ---------------------------------------------------------------------------
unk_2099B0: dc.b $16
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
unk_2099BC: dc.b $FF
			dc.b $FF
			dc.b   0
			dc.b   0
; =============== S U B R O U T I N E =======================================
sub_2099C0:
			move.l	#$70E00002,d0
			moveq	#0,d1
			move.w	(actwk+obj.xpos).w,d1
			bsr.w	sub_209ACA
			move.l	#$72200002,d0
			move.w	(actwk+obj.ypos).w,d1
			bra.w	sub_209ACA
; End of function sub_2099C0
; =============== S U B R O U T I N E =======================================
sub_2099DE:
			lea	(dword_209AAE).l,a2
			moveq	#3-1,d6
			bra.s	loc_2099F0
; End of function sub_2099DE
; =============== S U B R O U T I N E =======================================
sub_2099E8:
			lea	(dword_209AA2).l,a2
			moveq	#6-1,d6
loc_2099F0:
			moveq	#0,d4
			lea	(cg_hudnumbersletters).l,a1
loc_2099F8:
			moveq	#0,d2
			move.l	(a2)+,d3
loc_2099FC:
			sub.l	d3,d1
			bcs.s	loc_209A04
			addq.w	#1,d2
			bra.s	loc_2099FC
; ---------------------------------------------------------------------------
loc_209A04:
			add.l	d3,d1
			tst.w	d2
			beq.s	loc_209A0E
			move.w	#1,d4
loc_209A0E:
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
loc_209A3C:
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
loc_209A68:
			moveq	#0,d2
			move.l	(a2)+,d3
loc_209A6C:
			sub.l	d3,d1
			bcs.s	loc_209A74
			addq.w	#1,d2
			bra.s	loc_209A6C
; ---------------------------------------------------------------------------
loc_209A74:
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
dword_209AA2:	dc.l 100000
			dc.l 10000
			dc.l 1000
dword_209AAE:	dc.l 100
dword_209AB2:	dc.l 10

dword_209AB6:	dc.l 1

dword_209ABA:	dc.l $1000
			dc.l $100
			dc.l $10
			dc.l 1
; =============== S U B R O U T I N E =======================================
sub_209ACA:

			moveq	#4-1,d6
			lea	(dword_209ABA).l,a2
			bra.s	loc_209B06
; End of function sub_209ACA
; =============== S U B R O U T I N E =======================================
sub_209AD4:

			move.l	#$74600002,d0
			moveq	#0,d1
			move.b	(byte_FF1212).l,d1
			cmpi.b	#9,d1
			bcs.s	sub_209AEA
			moveq	#9,d1
; End of function sub_209AD4
; =============== S U B R O U T I N E =======================================
sub_209AEA:

			lea	(dword_209AB6).l,a2
			moveq	#1-1,d6
			bra.s	loc_209B06
; End of function sub_209AEA
; =============== S U B R O U T I N E =======================================
sub_209AF4:
			lea	(dword_209AB6).l,a2
			moveq	#1-1,d6
			bra.s	loc_209B06
; End of function sub_209AF4
; =============== S U B R O U T I N E =======================================
sub_209AFE:

			lea	(dword_209AB2).l,a2
			moveq	#2-1,d6
loc_209B06:

			moveq	#0,d4
			lea	(cg_hudnumbersletters).l,a1
loc_209B0E:
			moveq	#0,d2
			move.l	(a2)+,d3
loc_209B12:
			sub.l	d3,d1
			bcs.s	loc_209B1A
			addq.w	#1,d2
			bra.s	loc_209B12
; ---------------------------------------------------------------------------
loc_209B1A:
			add.l	d3,d1
			tst.w	d2
			beq.s	loc_209B24
			move.w	#1,d4
loc_209B24:
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
obj13:
			move.b	obj.subtype(a0),d0
			bmi.w	loc_209DD4
			bra.w	loc_209C32
; ---------------------------------------------------------------------------
obj14:
			move.b	obj.subtype(a0),d0
			bmi.w	loc_209F7C
			bra.w	loc_20A18E
; ---------------------------------------------------------------------------
obj15:
			move.b	obj.subtype(a0),d0
			bmi.w	loc_20A51E
			bra.w	loc_20A3A0
; ---------------------------------------------------------------------------
obj16:
			move.b	obj.subtype(a0),d0
			bmi.w	loc_20A814
			bra.w	loc_20A702
; ---------------------------------------------------------------------------
obj22:
			move.b	obj.subtype(a0),d0
			bmi.w	loc_20AC58
			bra.w	loc_20A926
; ---------------------------------------------------------------------------
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_209BA4(pc,d0.w),d0
			jmp	off_209BA4(pc,d0.w)
; ---------------------------------------------------------------------------
off_209BA4: dc.w loc_209BA8-off_209BA4
			dc.w loc_209BFC-off_209BA4
; ---------------------------------------------------------------------------
loc_209BA8:
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
loc_209BFC:
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
loc_209C32:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			beq.s	loc_209C4C
			tst.b	obj.render(a0)
			bmi.s	loc_209C4C
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
loc_209C4C:
			move.w	off_209C5A(pc,d0.w),d0
			jsr	off_209C5A(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_209C5A: dc.w loc_209C66-off_209C5A
			dc.w loc_209CA2-off_209C5A
			dc.w loc_209CEA-off_209C5A
			dc.w loc_209D5C-off_209C5A
			dc.w loc_209D8A-off_209C5A
			dc.w loc_209DC0-off_209C5A
; ---------------------------------------------------------------------------
loc_209C66:
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
loc_209CA2:
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
loc_209CD2:
			bsr.w	loc_209D2A
			lea	(obj13_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209CEA:

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
loc_209D12:
			bsr.w	loc_209D2A
			lea	(obj13_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209D2A:
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
locret_209D5A:
			rts
; ---------------------------------------------------------------------------
loc_209D5C:
			move.w	obj.field_2A(a0),d0
			subq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			bne.w	loc_209D76
			move.b	#8,obj.routine(a0)
			move.b	#3,obj.ani(a0)
loc_209D76:
			lea	(obj13_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209D8A:
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
loc_209DB8:
			move.b	#$A,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_209DC0:
			lea	(obj13_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209DD4:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			beq.s	loc_209DEE
			tst.b	obj.render(a0)
			bmi.s	loc_209DEE
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
loc_209DEE:
			move.w	off_209DFC(pc,d0.w),d0
			jsr	off_209DFC(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_209DFC: dc.w loc_209E08-off_209DFC
			dc.w loc_209E4A-off_209DFC
			dc.w loc_209E92-off_209DFC
			dc.w loc_209F04-off_209DFC
			dc.w loc_209F32-off_209DFC
			dc.w loc_209F68-off_209DFC
; ---------------------------------------------------------------------------
loc_209E08:
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
loc_209E4A:
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
loc_209E7A:
			bsr.w	sub_209ED2
			lea	(obj13b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209E92:
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
loc_209EBA:
			bsr.w	sub_209ED2
			lea	(obj13b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; =============== S U B R O U T I N E =======================================
sub_209ED2:
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
locret_209F02:
			rts
; End of function sub_209ED2
; ---------------------------------------------------------------------------
loc_209F04:
			move.w	obj.field_2A(a0),d0
			subq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			bne.w	loc_209F1E
			move.b	#8,obj.routine(a0)
			move.b	#3,obj.ani(a0)
loc_209F1E:
			lea	(obj13b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_209F32:
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
loc_209F60:
			move.b	#$A,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_209F68:
			lea	(obj13b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------

loc_209F7C:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_209F90(pc,d0.w),d0
			jsr	off_209F90(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_209F90: dc.w loc_209F9A-off_209F90
			dc.w loc_209FE8-off_209F90
			dc.w loc_20A11C-off_209F90
			dc.w loc_20A072-off_209F90
			dc.w loc_20A11C-off_209F90
; ---------------------------------------------------------------------------
loc_209F9A:
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
loc_209FE8:
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
loc_20A040:
			move.w	obj.field_2A(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			cmpi.w	#$300,d0
			bne.w	loc_20A060
			move.w	#0,obj.field_2A(a0)
			move.b	#6,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A060:
			lea	(obj14_ani).l,a1
			jsr	(animateobj).l
loc_20A06C:
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20A072:
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
loc_20A0C8:
			move.w	obj.field_2A(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			cmpi.w	#$300,d0
			bne.w	loc_20A0E6
			move.w	#0,obj.field_2A(a0)
			move.b	#2,obj.routine(a0)
loc_20A0E6:
			lea	(obj14_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; =============== S U B R O U T I N E =======================================
sub_20A0FA:
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
loc_20A11C:
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
loc_20A14A:
			move.l	obj.ypos(a0),d2
			add.l	d1,d2
			move.l	d2,obj.ypos(a0)
			lea	(obj14_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A168:
			move.w	#0,obj.field_30(a0)
			move.b	obj.routine(a0),d0
			cmpi.b	#4,d0
			beq.w	loc_20A17E
			bra.w	loc_20A186
; ---------------------------------------------------------------------------
loc_20A17E:
			move.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A186:
			move.b	#6,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------

loc_20A18E:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20A1A2(pc,d0.w),d0
			jsr	off_20A1A2(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20A1A2: dc.w loc_20A1AC-off_20A1A2
			dc.w loc_20A1FA-off_20A1A2
			dc.w loc_20A32E-off_20A1A2
			dc.w loc_20A286-off_20A1A2
			dc.w loc_20A32E-off_20A1A2
; ---------------------------------------------------------------------------
loc_20A1AC:
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
loc_20A1FA:
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
loc_20A254:
			move.w	obj.field_2A(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			cmpi.w	#$300,d0
			bne.w	loc_20A274
			move.w	#0,obj.field_2A(a0)
			move.b	#6,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A274:
			lea	(obj14b_ani).l,a1
			jsr	(animateobj).l
loc_20A280:
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20A286:
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
loc_20A2DC:
			move.w	obj.field_2A(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			cmpi.w	#$300,d0
			bne.w	loc_20A2FA
			move.w	#0,obj.field_2A(a0)
			move.b	#2,obj.routine(a0)
loc_20A2FA:
			lea	(obj14b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; =============== S U B R O U T I N E =======================================
sub_20A30C:
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
loc_20A32E:
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
loc_20A35C:
			move.l	obj.ypos(a0),d2
			add.l	d1,d2
			move.l	d2,obj.ypos(a0)
			lea	(obj14b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A37A:
			move.w	#0,obj.field_30(a0)
			move.b	obj.routine(a0),d0
			cmpi.b	#4,d0
			beq.w	loc_20A390
			bra.w	loc_20A398
; ---------------------------------------------------------------------------
loc_20A390:
			move.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A398:
			move.b	#6,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------

loc_20A3A0:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			beq.s	loc_20A3BA
			tst.b	obj.render(a0)
			bmi.s	loc_20A3BA
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
loc_20A3BA:
			move.w	off_20A3C8(pc,d0.w),d0
			jsr	off_20A3C8(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20A3C8: dc.w loc_20A3D0-off_20A3C8
			dc.w loc_20A404-off_20A3C8
			dc.w loc_20A43E-off_20A3C8
			dc.w loc_20A4AE-off_20A3C8
; ---------------------------------------------------------------------------
loc_20A3D0:
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
loc_20A404:
			move.l	obj.ypos(a0),d0
			addi.l	#$20000,d0
			move.l	d0,obj.ypos(a0)
			move.b	#$12,obj.height(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			bmi.w	loc_20A436
			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20A436:
			move.b	#4,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A43E:
			move.b	#$12,obj.height(a0)
			subi.l	#$10000,obj.xpos(a0)
			moveq	#8,d3
			jsr	(sub_206388).l
			tst.b	d1
			bne.w	loc_20A45E
			bra.w	loc_20A498
; ---------------------------------------------------------------------------
loc_20A45E:
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
loc_20A484:
			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A498:

			move.b	#6,obj.routine(a0)
			bset	#0,obj.status(a0)
			bset	#0,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A4AE:
			move.b	#$12,obj.height(a0)
			addi.l	#$10000,obj.xpos(a0)
			moveq	#8,d3
			jsr	(sub_2061E6).l
			tst.b	d1
			bne.w	loc_20A4CE
			bra.w	loc_20A508
; ---------------------------------------------------------------------------
loc_20A4CE:
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
loc_20A4F4:
			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A508:

			move.b	#4,obj.routine(a0)
			bclr	#0,obj.status(a0)
			bclr	#0,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------

loc_20A51E:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			beq.s	loc_20A538
			tst.b	obj.render(a0)
			bmi.s	loc_20A538
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
loc_20A538:
			move.w	off_20A546(pc,d0.w),d0
			jsr	off_20A546(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20A546: dc.w loc_20A552-off_20A546
			dc.w loc_20A58C-off_20A546
			dc.w loc_20A5C6-off_20A546
			dc.w loc_20A642-off_20A546
			dc.w loc_20A686-off_20A546
			dc.w loc_20A664-off_20A546
; ---------------------------------------------------------------------------
loc_20A552:
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
loc_20A58C:
			move.l	obj.ypos(a0),d0
			addi.l	#$10000,d0
			move.l	d0,obj.ypos(a0)
			move.b	#$12,obj.height(a0)
			jsr	(sub_20611C).l
			tst.w	d1
			bmi.w	loc_20A5BE
			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20A5BE:
			move.b	#4,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A5C6:
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$F0,d0
			beq.w	loc_20A634
			move.b	#$12,obj.height(a0)
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
loc_20A60C:

			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A620:

			move.b	#8,obj.routine(a0)
			bset	#0,obj.status(a0)
			bset	#0,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A634:
			move.w	#0,obj.field_3E(a0)
			move.b	#6,obj.routine(a0)
			bra.s	loc_20A60C
; ---------------------------------------------------------------------------
loc_20A642:
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$3C,d0
			beq.w	loc_20A656
			bra.s	loc_20A60C
; ---------------------------------------------------------------------------
loc_20A656:
			move.w	#0,obj.field_3E(a0)
			move.b	#4,obj.routine(a0)
			bra.s	loc_20A60C
; ---------------------------------------------------------------------------
loc_20A664:
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$3C,d0
			beq.w	loc_20A678
			bra.s	loc_20A60C
; ---------------------------------------------------------------------------
loc_20A678:
			move.w	#0,obj.field_3E(a0)
			move.b	#8,obj.routine(a0)
			bra.s	loc_20A60C
; ---------------------------------------------------------------------------
loc_20A686:
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$F0,d0
			beq.w	loc_20A6F4
			move.b	#$12,obj.height(a0)
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
loc_20A6CC:

			lea	(off_20B11C).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A6E0:

			move.b	#4,obj.routine(a0)
			bclr	#0,obj.status(a0)
			bclr	#0,obj.render(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A6F4:
			move.w	#0,obj.field_3E(a0)
			move.b	#$A,obj.routine(a0)
			bra.s	loc_20A6CC
; ---------------------------------------------------------------------------

loc_20A702:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20A716(pc,d0.w),d0
			jsr	off_20A716(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20A716: dc.w loc_20A71E-off_20A716
			dc.w loc_20A75A-off_20A716
			dc.w loc_20A7AA-off_20A716
			dc.w loc_20A802-off_20A716
; ---------------------------------------------------------------------------
loc_20A71E:
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
loc_20A75A:
			addi.l	#$1000,obj.field_2A(a0)
			move.l	obj.ypos(a0),d0
			move.l	obj.field_2A(a0),d1
			add.l	d1,d0
			move.l	d0,obj.ypos(a0)
			tst.l	d1
			bpl.w	loc_20A79C
			cmpi.l	#$FFFFA000,d1
			bpl.w	loc_20A794
loc_20A780:
			lea	(obj16_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A794:
			move.b	#2,obj.ani(a0)
			bra.s	loc_20A780
; ---------------------------------------------------------------------------
loc_20A79C:
			move.b	#4,obj.routine(a0)
			move.b	#3,obj.ani(a0)
			bra.s	loc_20A780
; ---------------------------------------------------------------------------
loc_20A7AA:
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
loc_20A7D8:
			lea	(obj16_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A7EC:
			move.b	#6,obj.routine(a0)
			move.w	#$C8,obj.field_2E(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A7FA:
			move.b	#1,obj.ani(a0)
			bra.s	loc_20A7D8
; ---------------------------------------------------------------------------
loc_20A802:
			subq.w	#1,obj.field_2E(a0)
			beq.w	loc_20A80C
			rts
; ---------------------------------------------------------------------------
loc_20A80C:
			move.b	#0,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------

loc_20A814:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20A828(pc,d0.w),d0
			jsr	off_20A828(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20A828: dc.w loc_20A830-off_20A828
			dc.w loc_20A86C-off_20A828
			dc.w loc_20A8BC-off_20A828
			dc.w loc_20A914-off_20A828
; ---------------------------------------------------------------------------
loc_20A830:
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
loc_20A86C:
			addi.l	#$2000,obj.field_2A(a0)
			move.l	obj.ypos(a0),d0
			move.l	obj.field_2A(a0),d1
			add.l	d1,d0
			move.l	d0,obj.ypos(a0)
			tst.l	d1
			bpl.w	loc_20A8AE
			cmpi.l	#$FFFF0000,d1
			bpl.w	loc_20A8A6
loc_20A892:
			lea	(obj16_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A8A6:
			move.b	#6,obj.ani(a0)
			bra.s	loc_20A892
; ---------------------------------------------------------------------------
loc_20A8AE:
			move.b	#4,obj.routine(a0)
			move.b	#7,obj.ani(a0)
			bra.s	loc_20A892
; ---------------------------------------------------------------------------
loc_20A8BC:
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
loc_20A8EA:
			lea	(obj16_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A8FE:
			move.b	#6,obj.routine(a0)
			move.w	#$C8,obj.field_2E(a0)
			rts
; ---------------------------------------------------------------------------
loc_20A90C:
			move.b	#5,obj.ani(a0)
			bra.s	loc_20A8EA
; ---------------------------------------------------------------------------
loc_20A914:
			subq.w	#1,obj.field_2E(a0)
			beq.w	loc_20A91E
			rts
; ---------------------------------------------------------------------------
loc_20A91E:
			move.b	#0,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------

loc_20A926:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20A93A(pc,d0.w),d0
			jsr	off_20A93A(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20A93A: dc.w loc_20A946-off_20A93A
			dc.w loc_20A992-off_20A93A
			dc.w loc_20A9EA-off_20A93A
			dc.w loc_20AA90-off_20A93A
			dc.w loc_20ABA4-off_20A93A
			dc.w loc_20AB36-off_20A93A
; ---------------------------------------------------------------------------
loc_20A946:
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
loc_20A992:
			move.b	#1,obj.ani(a0)
			move.l	obj.ypos(a0),d0
			addi.l	#$10000,d0
			move.l	d0,obj.ypos(a0)
			move.b	#$E,obj.height(a0)
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
loc_20A9D0:

			move.b	#4,obj.routine(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20A9EA:
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$120,d0
			beq.w	loc_20AA5C
			bclr	#0,obj.render(a0)
			bclr	#0,obj.status(a0)
			move.b	#1,obj.ani(a0)
			move.b	#$E,obj.height(a0)
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
loc_20AA3A:
			move.l	obj.xpos(a0),d0
			subi.l	#$C000,d0
			move.l	d0,obj.xpos(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AA5C:

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
loc_20AA90:
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$120,d0
			beq.w	loc_20AB02
			bset	#0,obj.render(a0)
			bset	#0,obj.status(a0)
			move.b	#1,obj.ani(a0)
			move.b	#$E,obj.height(a0)
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
loc_20AAE0:
			move.l	obj.xpos(a0),d0
			addi.l	#$C000,d0
			move.l	d0,obj.xpos(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AB02:

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
loc_20AB36:
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
loc_20AB60:

			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AB74:
			move.w	#0,obj.field_3E(a0)
			move.b	#6,obj.routine(a0)
			bra.s	loc_20AB60
; ---------------------------------------------------------------------------
loc_20AB82:
			move.b	#3,obj.ani(a0)
			bra.s	loc_20AB60
; ---------------------------------------------------------------------------
loc_20AB8A:
			move.b	#2,obj.ani(a0)
			bset	#0,obj.render(a0)
			bset	#0,obj.status(a0)
			bra.s	loc_20AB60
; ---------------------------------------------------------------------------
loc_20AB9E:
			bsr.w	sub_20AC12
			bra.s	loc_20AB60
; ---------------------------------------------------------------------------
loc_20ABA4:
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
loc_20ABCE:

			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20ABE2:
			move.w	#0,obj.field_3E(a0)
			move.b	#4,obj.routine(a0)
			bra.s	loc_20ABCE
; ---------------------------------------------------------------------------
loc_20ABF0:
			move.b	#3,obj.ani(a0)
			bra.s	loc_20ABCE
; ---------------------------------------------------------------------------
loc_20ABF8:
			move.b	#2,obj.ani(a0)
			bclr	#0,obj.render(a0)
			bclr	#0,obj.status(a0)
			bra.s	loc_20ABCE
; ---------------------------------------------------------------------------
loc_20AC0C:
			bsr.w	sub_20AC12
			bra.s	loc_20ABCE
; =============== S U B R O U T I N E =======================================
sub_20AC12:

			move.b	#1,d6
			bsr.w	sub_20AC24
			move.b	#2,d6
			bsr.w	sub_20AC24
			rts
; End of function sub_20AC12
; =============== S U B R O U T I N E =======================================
sub_20AC24:

			jsr	(sub_20B4D8).l
			tst.b	d0
			beq.w	locret_20AC56
			move.b	d6,obj.subtype(a2)
			move.b	#objid_23,obj.id(a2)
			move.l	obj.xpos(a0),d1
			addi.l	#0,d1
			move.l	d1,obj.xpos(a2)
			move.l	obj.ypos(a0),d1
			addi.l	#$FFF00000,d1
			move.l	d1,obj.ypos(a2)
locret_20AC56:
			rts
; End of function sub_20AC24
; ---------------------------------------------------------------------------

loc_20AC58:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20AC6C(pc,d0.w),d0
			jsr	off_20AC6C(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20AC6C: dc.w loc_20AC78-off_20AC6C
			dc.w loc_20ACC4-off_20AC6C
			dc.w loc_20AD1C-off_20AC6C
			dc.w loc_20ADC2-off_20AC6C
			dc.w loc_20AED6-off_20AC6C
			dc.w loc_20AE68-off_20AC6C
; ---------------------------------------------------------------------------
loc_20AC78:
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
loc_20ACC4:
			move.b	#4,obj.ani(a0)
			move.l	obj.ypos(a0),d0
			addi.l	#$10000,d0
			move.l	d0,obj.ypos(a0)
			move.b	#$E,obj.height(a0)
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
loc_20AD02:

			move.b	#4,obj.routine(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AD1C:
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$1B0,d0
			beq.w	loc_20AD8E
			bclr	#0,obj.render(a0)
			bclr	#0,obj.status(a0)
			move.b	#4,obj.ani(a0)
			move.b	#$E,obj.height(a0)
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
loc_20AD6C:
			move.l	obj.xpos(a0),d0
			subi.l	#$5000,d0
			move.l	d0,obj.xpos(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AD8E:

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
loc_20ADC2:
			move.w	obj.field_3E(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_3E(a0)
			cmpi.w	#$1B0,d0
			beq.w	loc_20AE34
			bset	#0,obj.render(a0)
			bset	#0,obj.status(a0)
			move.b	#4,obj.ani(a0)
			move.b	#$E,obj.height(a0)
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
loc_20AE12:
			move.l	obj.xpos(a0),d0
			addi.l	#$5000,d0
			move.l	d0,obj.xpos(a0)
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AE34:
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
loc_20AE68:
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
loc_20AE92:
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AEA6:
			move.w	#0,obj.field_3E(a0)
			move.b	#6,obj.routine(a0)
			bra.s	loc_20AE92
; ---------------------------------------------------------------------------
loc_20AEB4:
			move.b	#3,obj.ani(a0)
			bra.s	loc_20AE92
; ---------------------------------------------------------------------------
loc_20AEBC:
			move.b	#2,obj.ani(a0)
			bset	#0,obj.render(a0)
			bset	#0,obj.status(a0)
			bra.s	loc_20AE92
; ---------------------------------------------------------------------------
loc_20AED0:
			bsr.w	sub_20AF44
			bra.s	loc_20AE92
; ---------------------------------------------------------------------------
loc_20AED6:
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
loc_20AF00:
			lea	(obj22_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20AF14:
			move.w	#0,obj.field_3E(a0)
			move.b	#4,obj.routine(a0)
			bra.s	loc_20AF00
; ---------------------------------------------------------------------------
loc_20AF22:
			move.b	#3,obj.ani(a0)
			bra.s	loc_20AF00
; ---------------------------------------------------------------------------
loc_20AF2A:
			move.b	#2,obj.ani(a0)
			bclr	#0,obj.render(a0)
			bclr	#0,obj.status(a0)
			bra.s	loc_20AF00
; ---------------------------------------------------------------------------
loc_20AF3E:
			bsr.w	sub_20AF44
			bra.s	loc_20AF00
; =============== S U B R O U T I N E =======================================
sub_20AF44:
			move.b	#3,d6
			bsr.w	sub_20AF56
			move.b	#4,d6
			bsr.w	sub_20AF56
			rts
; End of function sub_20AF44
; =============== S U B R O U T I N E =======================================
sub_20AF56:
			jsr	(sub_20B4D8).l
			tst.b	d0
			beq.w	locret_20AF88
			move.b	d6,obj.subtype(a2)
			move.b	#objid_23,obj.id(a2)
			move.l	obj.xpos(a0),d1
			addi.l	#0,d1
			move.l	d1,obj.xpos(a2)
			move.l	obj.ypos(a0),d1
			addi.l	#$FFF00000,d1
			move.l	d1,obj.ypos(a2)
locret_20AF88:
			rts
; End of function sub_20AF56
; ---------------------------------------------------------------------------
obj13_ani:	dc.w unk_20AF92-obj13_ani
			dc.w unk_20AF9A-obj13_ani
			dc.w unk_20AF9E-obj13_ani
			dc.w unk_20AFAE-obj13_ani
unk_20AF92: dc.b $13
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b $FF
			even
unk_20AF9A: dc.b   1
			dc.b   0
			dc.b   1
			dc.b $FF
			even
unk_20AF9E: dc.b   6
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
unk_20AFAE: dc.b   0
			dc.b   4
			dc.b $FF
			even
obj13_map:	dc.w byte_20AFBC-obj13_map
			dc.w byte_20AFC7-obj13_map
			dc.w byte_20AFD2-obj13_map
			dc.w byte_20AFE2-obj13_map
			dc.w byte_20AFF2-obj13_map
byte_20AFBC:	dc.b 2
			dc.b $F4, $A,  0,  0,$F8
			dc.b $FC,  0,  0,  9,$F0
byte_20AFC7:	dc.b 2
			dc.b $FC,  9,  0, $A,$F8
			dc.b $FC,  0,  0,  9,$F0
byte_20AFD2:	dc.b 3
			dc.b $F0,  6,  0,$10,  0
			dc.b   8,  4,  0,$16,$F0
			dc.b   0,  0,  0,$18,$F8
byte_20AFE2:	dc.b 3
			dc.b $F0,  9,  0,$19,$F8
			dc.b   0,  4,  0,$1F,$F8
			dc.b   8,  0,  0,$21,$F8
byte_20AFF2:	dc.b 3
			dc.b $F0,  6,  0,$22,$F4
			dc.b   8,  0,  0,$28,$FC
			dc.b $F0,  0,  0,$29,  4
			even
obj13b_ani: dc.w unk_20B00A-obj13b_ani
			dc.w unk_20B012-obj13b_ani
			dc.w unk_20B016-obj13b_ani
			dc.w unk_20B020-obj13b_ani
unk_20B00A: dc.b $13
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b $FF
			even
unk_20B012: dc.b   4
			dc.b   0
			dc.b   1
			dc.b $FF
			even
unk_20B016: dc.b  $E
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b   4
			dc.b $FF
			even
unk_20B020: dc.b   0
			dc.b   4
			dc.b $FF
			even
obj13b_map: dc.w byte_20B02E-obj13b_map
			dc.w byte_20B039-obj13b_map
			dc.w byte_20B03F-obj13b_map
			dc.w byte_20B04F-obj13b_map
			dc.w byte_20B05F-obj13b_map
byte_20B02E:	dc.b 2
			dc.b $F4, $A,  0,$2A,$F8
			dc.b $FC,  1,  0,$33,$F0
byte_20B039:	dc.b 1
			dc.b $FC, $D,  0,$35,$F0
byte_20B03F:	dc.b 3
			dc.b $F0,  6,  0,$10,  0
			dc.b   0,  1,  0,$3D,$F8
			dc.b   8,  0,  0,$3F,$F0
byte_20B04F:	dc.b 3
			dc.b $F0,  9,  0,$19,$F8
			dc.b   0,  4,  0,$40,$F8
			dc.b   8,  0,  0,$42,$F8
byte_20B05F:	dc.b 3
			dc.b $F0,  6,  0,$43,$F4
			dc.b   8,  0,  0,$49,$FC
			dc.b $F0,  0,  0,$29,  4
			even
obj14b_ani: dc.w unk_20B07A-obj14b_ani
			dc.w unk_20B082-obj14b_ani
			dc.b $13
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   1
			dc.b $FF
			even
unk_20B07A: dc.b   4
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   1
			dc.b $FF
			even
unk_20B082: dc.b   4
			dc.b   3
			dc.b   3
			dc.b   4
			dc.b   5
			dc.b   4
			dc.b $FF
			even
obj14_map:	dc.w byte_20B096-obj14_map
			dc.w byte_20B0A6-obj14_map
			dc.w byte_20B0B6-obj14_map
			dc.w byte_20B096-obj14_map
			dc.w byte_20B0A6-obj14_map
			dc.w byte_20B0B6-obj14_map
byte_20B096:	dc.b 3
			dc.b $F0,  8,  0,  0,$F8
			dc.b $F8, $D,  0,  3,$F0
			dc.b   8,  8,  0, $B,$F0
			even
byte_20B0A6:	dc.b 3
			dc.b $F8,  9,  0, $E,$F0
			dc.b   0,  0,  0,$14,  8
			dc.b   8,  0,  0,$15,  0
			even
byte_20B0B6:	dc.b 3
			dc.b $F0,  0,  0,$16,$F0
			dc.b $F8,  8,  0,$17,$F0
			dc.b   0, $D,  0,$1A,$F0
			even
obj14_ani:	dc.w unk_20B0D0-obj14_ani
			dc.w unk_20B0D8-obj14_ani
			dc.b $13
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   1
			dc.b $FF
			even
unk_20B0D0: dc.b   4
			dc.b   0
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   1
			dc.b $FF
			even
unk_20B0D8: dc.b   4
			dc.b   3
			dc.b   3
			dc.b   4
			dc.b   5
			dc.b   4
			dc.b $FF
			even
off_20B0E0: dc.w byte_20B0EC-off_20B0E0
			dc.w byte_20B0FC-off_20B0E0
			dc.w byte_20B10C-off_20B0E0
			dc.w byte_20B0EC-off_20B0E0
			dc.w byte_20B0FC-off_20B0E0
			dc.w byte_20B10C-off_20B0E0
byte_20B0EC:	dc.b 3
			dc.b $F0,  8,  0,  0,$F8
			dc.b $F8, $D,  0,$22,$F0
			dc.b   8,  8,  0, $B,$F0
			even
byte_20B0FC:	dc.b 3
			dc.b $F8,  9,  0, $E,$F0
			dc.b   0,  0,  0,$14,  8
			dc.b   8,  0,  0,$15,  0
			even
byte_20B10C:	dc.b 3
			dc.b $F0,  0,  0,$16,$F0
			dc.b $F8,  8,  0,$17,$F0
			dc.b   0, $D,  0,$2A,$F0
			even
off_20B11C: dc.w unk_20B132-off_20B11C
			dc.w unk_20B136-off_20B11C
			dc.w unk_20B12E-off_20B11C
			dc.w unk_20B124-off_20B11C
unk_20B124: dc.b $13
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
unk_20B12E: dc.b $13
			dc.b   0
			dc.b $FF
			even
unk_20B132: dc.b   3
			dc.b   6
			dc.b   7
			dc.b $FF
			even
unk_20B136: dc.b   3
			dc.b   8
			dc.b   9
			dc.b $FF
			even
obj15_map:	dc.w byte_20B1B6-obj15_map
			dc.w byte_20B1C6-obj15_map
			dc.w byte_20B1CC-obj15_map
			dc.w byte_20B1D2-obj15_map
			dc.w byte_20B1D8-obj15_map
			dc.w byte_20B1DE-obj15_map
			dc.w byte_20B14E-obj15_map
			dc.w byte_20B168-obj15_map
			dc.w byte_20B182-obj15_map
			dc.w byte_20B19C-obj15_map
byte_20B14E:	dc.b 5
			dc.b $EA,  5,  0,  0,$F4
			dc.b $FA,  0,  0,  4,$F4
			dc.b $FA,  5,  0,  5,$FC
			dc.b   2,  5,  0,  9,$F8
			dc.b $FA,  0,  0,$11, $E
			even
byte_20B168:	dc.b 5
			dc.b $EB,  5,  0,  0,$F4
			dc.b $FB,  0,  0,  4,$F4
			dc.b $FB,  5,  0,  5,$FC
			dc.b   2,  5,  0, $D,$F8
			dc.b $FA,  0,  0,$11,$12
			even
byte_20B182:	dc.b 5
			dc.b $EA,  5,  0,$12,$F4
			dc.b $FA,  0,  0,  4,$F4
			dc.b $FA,  5,  0,  5,$FC
			dc.b   2,  5,  0,  9,$F8
			dc.b $FA,  0,  0,$11, $E
			even
byte_20B19C:	dc.b 5
			dc.b $EB,  5,  0,$12,$F4
			dc.b $FB,  0,  0,  4,$F4
			dc.b $FB,  5,  0,  5,$FC
			dc.b   2,  5,  0, $D,$F8
			dc.b $FA,  0,  0,$11,$12
			even
byte_20B1B6:	dc.b 3
			dc.b $F0,  5,  0,  0,$F4
			dc.b   0,  0,  0,  4,$F4
			dc.b   0,  5,  0,  5,$FC
			even
byte_20B1C6:	dc.b 1
			dc.b $F8,  5,  0,  9,$F8
			even
byte_20B1CC:	dc.b 1
			dc.b $F8,  5,  0, $D,$F8
			even
byte_20B1D2:	dc.b 1
			dc.b $FC,  0,  0,$11,$FC
			even
byte_20B1D8:	dc.b 1
			dc.b $FC,  0,  0,$11,  0
			even
byte_20B1DE:	dc.b 3
			dc.b $F0,  5,  0,$12,$F4
			dc.b   0,  0,  0,  4,$F4
			dc.b   0,  5,  0,  5,$FC
			even
obj16_ani:	dc.w unk_20B202-obj16_ani
			dc.w unk_20B206-obj16_ani
			dc.w unk_20B20A-obj16_ani
			dc.w unk_20B20E-obj16_ani
			dc.w unk_20B212-obj16_ani
			dc.w unk_20B216-obj16_ani
			dc.w unk_20B21A-obj16_ani
			dc.w unk_20B21E-obj16_ani
			dc.w unk_20B222-obj16_ani
			dc.w unk_20B22A-obj16_ani
unk_20B202: dc.b   9
			dc.b   6
			dc.b   7
			dc.b $FF
			even
unk_20B206: dc.b   9
			dc.b   8
			dc.b   9
			dc.b $FF
			even
unk_20B20A: dc.b $27
			dc.b  $A
			dc.b $FF
			even
unk_20B20E: dc.b $27
			dc.b  $B
			dc.b $FF
			even
unk_20B212: dc.b   9
			dc.b   6
			dc.b   7
			dc.b $FF
			even
unk_20B216: dc.b   9
			dc.b  $C
			dc.b  $D
			dc.b $FF
			even
unk_20B21A: dc.b $27
			dc.b  $A
			dc.b $FF
			even
unk_20B21E: dc.b $27
			dc.b  $E
			dc.b $FF
			even
unk_20B222: dc.b $27
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b   3
			dc.b   4
			dc.b   5
			dc.b $FF
			even
unk_20B22A: dc.b   9
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
obj16_map:	dc.w byte_20B25C-obj16_map
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
byte_20B25C:	dc.b 4
			dc.b $F0,  3,  0,  0,$F8
			dc.b $F8,  0,  0,  4,$F0
			dc.b $F0,  3,  8,  0,  0
			dc.b $F8,  0,  8,  4,  8
byte_20B271:	dc.b 4
			dc.b $F0,  6,  0,  5,$F0
			dc.b   8,  0,  0, $B,$F8
			dc.b $F0,  6,  8,  5,  0
			dc.b   8,  0,  8, $B,  0
byte_20B286:	dc.b 4
			dc.b $F8,  6,  0, $C,$F0
			dc.b $F0,  0,  0,$12,$F8
			dc.b $F8,  6,  8, $C,  0
			dc.b $F0,  0,  8,$12,  0
byte_20B29B:	dc.b 4
			dc.b $F0,  3,  0,$13,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$13,  0
			dc.b   0,  0,$18,  4,  8
byte_20B2B0:	dc.b 2
			dc.b $F4,  6,  0,$17,$F0
			dc.b $F4,  6,  8,$17,  0
byte_20B2BB:	dc.b 2
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
byte_20B2F0:	dc.b 6
			dc.b $F0,  3,  0,  0,$F8
			dc.b $F8,  0,  0,  4,$F0
			dc.b $F0,  3,  8,  0,  0
			dc.b $F8,  0,  8,  4,  8
			dc.b $E5,  6,  0,$17,$F0
			dc.b $E5,  6,  8,$17,  0
			even
byte_20B310:	dc.b 6
			dc.b $F0,  3,  0,  0,$F8
			dc.b $F8,  0,  0,  4,$F0
			dc.b $F0,  3,  8,  0,  0
			dc.b $F8,  0,  8,  4,  8
			dc.b $E5,  6,  0,$1D,$F0
			dc.b $E5,  6,  8,$1D,  0
			even
byte_20B330:	dc.b 6
			dc.b $F0,  3,  0,$13,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$13,  0
			dc.b   0,  0,$18,  4,  8
			dc.b   3,  6,$10,$17,$F0
			dc.b   3,  6,$18,$17,  0
			even
byte_20B350:	dc.b 6
			dc.b $F0,  3,  0,$13,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$13,  0
			dc.b   0,  0,$18,  4,  8
			dc.b   3,  6,$10,$1D,$F0
			dc.b   3,  6,$18,$1D,  0
			even
byte_20B370:	dc.b 4
			dc.b $F0,  6,  0,  5,$F0
			dc.b   8,  0,  0, $B,$F8
			dc.b $F0,  6,  8,  5,  0
			dc.b   8,  0,  8, $B,  0
			even
byte_20B386:	dc.b 4
			dc.b $F8,  6,  0, $C,$F0
			dc.b $F0,  0,  0,$12,$F8
			dc.b $F8,  6,  8, $C,  0
			dc.b $F0,  0,  8,$12,  0
byte_20B39B:	dc.b 6
			dc.b $F0,  3,  0,$2A,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$2A,  0
			dc.b   0,  0,$18,  4,  8
			dc.b   3,  6,$10,$17,$F0
			dc.b   3,  6,$18,$17,  0
			even
byte_20B3BA:	dc.b 6
			dc.b $F0,  3,  0,$2A,$F8
			dc.b   0,  0,$10,  4,$F0
			dc.b $F0,  3,  8,$2A,  0
			dc.b   0,  0,$18,  4,  8
			dc.b   3,  6,$10,$1D,$F0
			dc.b   3,  6,$18,$1D,  0
byte_20B3D9:	dc.b 4
			dc.b $F8,  6,  0,$23,$F0
			dc.b $F0,  0,  0,$29,$F8
			dc.b $F8,  6,  8,$23,  0
			dc.b $F0,  0,  8,$29,  0
			even
obj22_ani:	dc.w unk_20B3F8-obj22_ani
			dc.w unk_20B434-obj22_ani
			dc.w unk_20B43A-obj22_ani
			dc.w unk_20B43E-obj22_ani
			dc.w unk_20B442-obj22_ani
unk_20B3F8: dc.b $13
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
unk_20B434: dc.b $13
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   1
			dc.b $FF
			even
unk_20B43A: dc.b $13
			dc.b   0
			dc.b   0
			dc.b $FF
			even
unk_20B43E: dc.b   9
			dc.b   2
			dc.b   2
			dc.b $FF
			even
unk_20B442: dc.b   5
			dc.b   1
			dc.b   7
			dc.b   1
			dc.b   7
			dc.b $FF
			even
obj22_map:	dc.w byte_20B458-obj22_map
			dc.w byte_20B46D-obj22_map
			dc.w byte_20B482-obj22_map
			dc.w byte_20B48D-obj22_map
			dc.w byte_20B493-obj22_map
			dc.w byte_20B499-obj22_map
			dc.w byte_20B49F-obj22_map
			dc.w byte_20B4A5-obj22_map
byte_20B458:	dc.b 4
			dc.b $F0,  9,  0,  0,$F8
			dc.b   0,  9,  0,  6,$F8
			dc.b $F8,  0,  0, $C,$F0
			dc.b   0,  0,  0, $D,$F0
byte_20B46D:	dc.b 4
			dc.b $F1,  9,  0,  0,$F8
			dc.b   1,  9,  0, $E,$F8
			dc.b $F9,  0,  0, $C,$F0
			dc.b   1,  0,  0, $D,$F0
byte_20B482:	dc.b 2
			dc.b $F0,  8,  0,$14,$F8
			dc.b $F8, $E,  0,$17,$F0
byte_20B48D:	dc.b 1
			dc.b $FC,  0,  0,$23,$FC
byte_20B493:	dc.b 1
			dc.b $FC,  0,  0,$24,$FC
byte_20B499:	dc.b 1
			dc.b $F8,  5,  0,$25,$F8
byte_20B49F:	dc.b 1
			dc.b $F8,  5,  0,$29,$F8
byte_20B4A5:	dc.b 3
			dc.b $EF,  9,  0,$2D,$F8
			dc.b $F7,  0,  0, $C,$F0
			dc.b $FF, $D,  0,$33,$F0
			even
off_20B4B6: dc.w unk_20B4BC-off_20B4B6
			dc.w unk_20B4C0-off_20B4B6
			dc.w unk_20B4C4-off_20B4B6
unk_20B4BC: dc.b $1D
			dc.b   0
			dc.b   1
			dc.b $FF
			even
unk_20B4C0: dc.b   0
			dc.b   0
			dc.b $FF
			even
unk_20B4C4: dc.b   0
			dc.b   1
			dc.b $FF
			even
off_20B4C8: dc.w byte_20B4CC-off_20B4C8
			dc.w byte_20B4D2-off_20B4C8
byte_20B4CC:	dc.b 1
			dc.b $F8,  5,  0,  0,$F8
byte_20B4D2:	dc.b 1
			dc.b $F8,  5,  0,  4,$F8
			even
; =============== S U B R O U T I N E =======================================
sub_20B4D8:
			lea	(unk_FFD400).w,a2
			moveq	#0,d0
loc_20B4DE:
			move.b	obj.id(a2),d1
			beq.w	loc_20B4F6
			addq.w	#1,d0
			lea	obj(a2),a2
			cmpi.w	#$3C,d0
			bne.s	loc_20B4DE
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_20B4F6:
			moveq	#-1,d0
			rts
; End of function sub_20B4D8
; ---------------------------------------------------------------------------
obj23:
			moveq	#0,d0
			move.b	obj.subtype(a0),d0
			andi.w	#$7F,d0
			add.w	d0,d0
			move.w	off_20B510(pc,d0.w),d0
			jmp	off_20B510(pc,d0.w)
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
off_20B510: dc.w locret_20B524-off_20B510
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
locret_20B524:

			rts
; ---------------------------------------------------------------------------
loc_20B526:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20B534(pc,d0.w),d0
			jmp	off_20B534(pc,d0.w)
; ---------------------------------------------------------------------------
off_20B534: dc.w loc_20B538-off_20B534
			dc.w loc_20B578-off_20B534
; ---------------------------------------------------------------------------
loc_20B538:
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#4,obj.width(a0)
			move.b	#4,obj.height(a0)
			move.w	#$2400,obj.vram(a0)
			move.l	#obj23_map,obj.mappings(a0)
			move.l	#$10000,obj.field_2A(a0)
			move.b	obj.field_3F(a0),d0
			bpl.w	locret_20B576
			neg.l	obj.field_2A(a0)
locret_20B576:
			rts
; ---------------------------------------------------------------------------
loc_20B578:
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
obj23_map:	dc.w byte_20B59E-obj23_map
			dc.w byte_20B5B3-obj23_map
byte_20B59E:	dc.b 4
			dc.b $F8,  0,  0,$2A,$F8
			dc.b $F8,  0,  8,$2A,  0
			dc.b   0,  0,$10,$2A,$F8
			dc.b   0,  0,$18,$2A,  0
byte_20B5B3:	dc.b 4
			dc.b $F8,  0,  0,$2B,$F8
			dc.b $F8,  0,  8,$2B,  0
			dc.b   0,  0,$10,$2B,$F8
			dc.b   0,  0,$18,$2B,  0
			even
; ---------------------------------------------------------------------------
			movea.l a0,a1
			moveq	#obj-1,d0
			moveq	#0,d1
loc_20B5CE:
			move.b	d1,(a1)+
			dbf	d0,loc_20B5CE
			rts
; ---------------------------------------------------------------------------
			move.l	d1,-(sp)
			move.l	(dword_FFF636).w,d1
			bne.s	loc_20B5E4
			move.l	#$2A6D365A,d1
loc_20B5E4:
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
off_20B60E: dc.w loc_20B612-off_20B60E
			dc.w loc_20B654-off_20B60E
; ---------------------------------------------------------------------------
loc_20B612:
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
loc_20B654:
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
sub_20B684:

			lea	(actwk).w,a1
			move.w	obj.yvel(a1),d1
			bmi.w	loc_20B694
			bra.w	loc_20B6EC
; ---------------------------------------------------------------------------
loc_20B694:
			moveq	#0,d1
			bclr	#3,obj.status(a0)
			rts
; ---------------------------------------------------------------------------
			lea	(actwk).w,a1
			move.w	obj.yvel(a1),d1
			bpl.w	loc_20B6AE
			bra.w	loc_20B6EC
; ---------------------------------------------------------------------------
loc_20B6AE:
			moveq	#0,d1
			bclr	#3,obj.status(a0)
			rts
; ---------------------------------------------------------------------------
			lea	(actwk).w,a1
			move.w	obj.xvel(a1),d1
			bmi.w	loc_20B6C8
			bra.w	loc_20B6EC
; ---------------------------------------------------------------------------
loc_20B6C8:
			moveq	#0,d1
			bclr	#3,obj.status(a0)
			rts
; ---------------------------------------------------------------------------
			lea	(actwk).w,a1
			move.w	obj.xvel(a1),d1
			bpl.w	loc_20B6E2
			bra.w	loc_20B6EC
; ---------------------------------------------------------------------------
loc_20B6E2:
			moveq	#0,d1
			bclr	#3,obj.status(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B6EC:
			lea	(byte_20B7B6).l,a2
			move.l	d0,d1
			andi.w	#$FF00,d0
			cmpi.w	#$100,d0
			bne.w	loc_20B706
			lea	(byte_20B806).l,a2
loc_20B706:
			cmpi.w	#$200,d0
			bne.w	loc_20B714
			lea	(byte_20B80A).l,a2
loc_20B714:
			cmpi.w	#$300,d0
			bne.w	loc_20B722
			lea	(byte_20B80E).l,a2
loc_20B722:
			move.w	d1,d0
			andi.w	#$FF,d0
			asl.w	#2,d0
			lea	(a2,d0.w),a2
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d0
			move.w	obj.xpos(a1),d1
			move.b	obj.width(a1),d3
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
			move.b	obj.height(a1),d3
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
loc_20B7AC:
			moveq	#0,d1
			bclr	#3,obj.status(a0)
			rts
; End of function sub_20B684
; ---------------------------------------------------------------------------
byte_20B7B6:	dc.b $10,$F0,$10,$F0
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
byte_20B806:	dc.b $10,$F0,$10,$F0
byte_20B80A:	dc.b $10,$F0,$10,$F0
byte_20B80E:	dc.b $10,$F0,$10,$F0
; ---------------------------------------------------------------------------
obj28:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20B826(pc,d0.w),d0
			jsr	off_20B826(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20B826: dc.w loc_20B834-off_20B826
			dc.w loc_20B888-off_20B826
			dc.w loc_20B8C8-off_20B826
			dc.w loc_20B9B4-off_20B826
			dc.w loc_20B908-off_20B826
			dc.w loc_20B9FC-off_20B826
			dc.w loc_20B950-off_20B826
; ---------------------------------------------------------------------------
loc_20B834:
			move.l	#obj28_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#7,d0
			jsr	sub_20DC4C(pc)
			move.b	#$18,obj.width(a0)
			move.b	#4,obj.height(a0)
			move.b	obj.subtype(a0),d0
			cmpi.b	#1,d0
			beq.w	loc_20B87A
			move.b	#3,obj.ani(a0)
			move.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B87A:
			move.b	#4,obj.ani(a0)
			move.b	#4,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B888:
			moveq	#5,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20B8B6
			lea	(actwk).w,a1
			move.l	obj.ypos(a0),d0
			moveq	#0,d1
			move.b	obj.height(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
			move.b	#$A,obj.routine(a0)
			move.b	#3,obj.ani(a0)
loc_20B8B6:
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20B8C8:
			moveq	#3,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20B8F6
			lea	(actwk).w,a1
			move.l	obj.ypos(a0),d0
			moveq	#0,d1
			move.b	obj.height(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
			move.b	#$C,obj.routine(a0)
			move.b	#4,obj.ani(a0)
loc_20B8F6:
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20B908:
			moveq	#3,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20B926
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20B926:
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
			move.b	#4,obj.routine(a0)
			btst	#1,obj.status(a1)
			bne.w	loc_20B942
			rts
; ---------------------------------------------------------------------------
loc_20B942:
			move.w	#$64,obj.field_2A(a0)
			move.b	#$C,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B950:
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
loc_20B97A:
			neg.w	d0
			move.w	d0,obj.yvel(a1)
			move.w	#$64,obj.field_2A(a0)
loc_20B986:
			move.w	obj.field_2A(a0),d0
			subq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			bne.w	loc_20B9A2
			move.b	#4,obj.routine(a0)
			move.b	#4,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B9A2:
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20B9B4:
			moveq	#5,d0
			bsr.w	sub_20B684
			tst.b	d1
			beq.w	loc_20B9D2
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20B9D2:
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
			move.b	#2,obj.routine(a0)
			btst	#1,obj.status(a1)
			bne.w	loc_20B9EE
			rts
; ---------------------------------------------------------------------------
loc_20B9EE:
			move.w	#$64,obj.field_2A(a0)
			move.b	#$A,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
loc_20B9FC:
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
loc_20BA26:
			neg.w	d0
			move.w	d0,obj.yvel(a1)
			move.w	#$64,obj.field_2A(a0)
loc_20BA32:
			move.w	obj.field_2A(a0),d0
			subq.w	#1,d0
			move.w	d0,obj.field_2A(a0)
			bne.w	loc_20BA4E
			move.b	#2,obj.routine(a0)
			move.b	#3,obj.ani(a0)
			rts
; ---------------------------------------------------------------------------
loc_20BA4E:
			lea	(obj28_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
obj27:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20BA74(pc,d0.w),d0
			jsr	off_20BA74(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20BA74: dc.w loc_20BA7C-off_20BA74
			dc.w loc_20BAA2-off_20BA74
			dc.w loc_20BAE4-off_20BA74
			dc.w loc_20BBA8-off_20BA74
; ---------------------------------------------------------------------------
loc_20BA7C:
			addq.b	#2,obj.routine(a0)
			move.l	#obj27_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#8,d0
			jsr	sub_20DC4C(pc)
			rts
; ---------------------------------------------------------------------------
loc_20BAA2:
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
loc_20BAD2:
			lea	(obj27_ani).l,a1
			jsr	(animateobj).l
loc_20BADE:
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20BAE4:
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
loc_20BB0C:
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d2
			move.w	obj.xpos(a1),d3
			move.w	obj.xvel(a1),d4
			beq.w	loc_20BB3C
			bmi.w	loc_20BB28
			bpl.w	loc_20BB32
loc_20BB28:
			cmp.w	d2,d3
			bpl.w	loc_20BB4A
			bra.w	loc_20BB3C
; ---------------------------------------------------------------------------
loc_20BB32:
			cmp.w	d2,d3
			bmi.w	loc_20BB4A
			bra.w	loc_20BB3C
; ---------------------------------------------------------------------------
loc_20BB3C:
			move.l	obj.ypos(a1),d0
			addi.l	#$8000,d0
			move.l	d0,obj.ypos(a1)
loc_20BB4A:
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
loc_20BB7C:
			divu.w	#2,d0
			move.b	(a2,d0.w),d1
			move.b	d1,obj.ani(a0)
			cmpi.b	#6,d1
			bne.w	loc_20BB96
			bclr	#3,obj.status(a1)
loc_20BB96:
			lea	(obj27_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20BBA8:
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
loc_20BBD8:
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
loc_20BC06:
			move.b	#2,obj.routine(a0)
			lea	(obj27_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
unk_20BC1E: dc.b   1
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
unk_20BC34: dc.b   7
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
unk_20BC4A: dc.b   0
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
loc_20BC80:
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
locret_20BCA2:
			rts
; ---------------------------------------------------------------------------
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20BCB2(pc,d0.w),d0
			jmp	off_20BCB2(pc,d0.w)
; ---------------------------------------------------------------------------
off_20BCB2: dc.w loc_20BCD4-off_20BCB2
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
loc_20BCD4:
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
loc_20BD0E:
			jsr	(findfreeobj).l
			bne.w	loc_20BDB6
			move.b	#objid_25,obj.id(a1)
			move.b	#2,obj.routine(a1)
			move.w	a0,obj.field_3E(a1)
			move.b	d7,obj.field_3C(a1)
			addq.w	#1,d7
			cmpi.w	#8,d7
			bne.s	loc_20BD0E
			jsr	(findfreeobj).l
			bne.w	loc_20BDB6
			move.b	#objid_25,obj.id(a1)
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
			move.b	#objid_25,obj.id(a1)
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
loc_20BDB6:
			tst.b	obj.subtype(a0)
			beq.w	locret_20BDC4
			move.b	#$1C,obj.routine(a0)
locret_20BDC4:
			rts
; =============== S U B R O U T I N E =======================================
sub_20BDC6:
			move.b	#6,obj.routine(a0)
			move.l	#off_20CEE2,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#9,d0
			jsr	sub_20DC4C(pc)
			move.b	#1,obj.ani(a0)
			movea.w obj.field_3E(a0),a2
			tst.b	obj.subtype(a2)
			beq.w	loc_20BE04
			move.b	#$1A,obj.routine(a0)
loc_20BE04:
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
loc_20BE6A:
			move.b	#8,obj.routine(a0)
			move.l	#off_20CEE2,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#9,d0
			jsr	sub_20DC4C(pc)
			movea.w obj.field_3E(a0),a2
			tst.b	obj.subtype(a2)
			beq.w	loc_20BEC0
			move.b	#$1E,obj.routine(a0)
			move.b	obj.field_3C(a0),d0
			cmpi.b	#$FE,d0
			beq.w	loc_20BEC0
			move.w	obj.ypos(a0),d1
			addi.w	#$70,d1
			move.w	d1,obj.ypos(a0)
			ori.w	#$800,obj.vram(a0)
loc_20BEC0:
			move.w	obj.ypos(a0),d0
			move.w	d0,obj.field_38(a0)
			move.w	d0,obj.field_34(a0)
			moveq	#0,d1
			addi.w	#$60,d0
			move.w	d0,obj.field_36(a0)
			rts
; ---------------------------------------------------------------------------
loc_20BED8:
			movea.w obj.field_3E(a0),a2
			move.b	obj.routine(a2),d0
			cmpi.b	#$18,d0
			bne.w	loc_20BEEE
			move.b	#$E,obj.routine(a0)
loc_20BEEE:
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
			move.b	obj.height(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
loc_20BF42:
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
unk_20BF8E: dc.b   0
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
sub_20BFCE:
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
loc_20C00A:
			cmpi.w	#$C0,d1
			bmi.w	loc_20C014
			moveq	#0,d1
loc_20C014:
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
loc_20C038:
			move.w	obj.field_38(a0),d3
			move.w	d3,obj.ypos(a0)
			rts
; End of function sub_20BFCE
; =============== S U B R O U T I N E =======================================
sub_20C042:
			btst	#0,(byte_FFF7DC).w
			beq.w	locret_20C04C
locret_20C04C:
			rts
; End of function sub_20C042
; ---------------------------------------------------------------------------
unk_20C04E: dc.b   0
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
loc_20C0FE:
			move.b	obj.field_31(a0),obj.field_30(a0)
			move.b	#0,obj.field_31(a0)
			btst	#0,(byte_FFF7DC).w
			beq.w	loc_20C11A
			move.b	#$18,obj.routine(a0)
loc_20C11A:
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
locret_20C14A:
			rts
; ---------------------------------------------------------------------------
loc_20C14C:
			movea.w obj.field_3E(a0),a2
			move.b	obj.routine(a2),d0
			cmpi.b	#$18,d0
			bne.w	loc_20C162
			move.b	#$16,obj.routine(a0)
loc_20C162:
			moveq	#$F,d0
			bsr.w	loc_20B6EC
			tst.b	d1
			beq.w	loc_20C178
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
loc_20C178:
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C18C:
			lea	(obj26_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
loc_20C19E:
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$64,d0
			bne.w	loc_20C1B8
			nop
			move.b	#$12,obj.routine(a0)
loc_20C1B8:
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
loc_20C1FA:
			btst	#3,obj.status(a0)
			beq.w	locret_20C14A
			bclr	#3,obj.status(a1)
			bclr	#3,obj.status(a0)
locret_20C210:
			rts
; ---------------------------------------------------------------------------
loc_20C212:
			movea.w obj.field_3E(a0),a2
			move.b	obj.routine(a2),d0
			cmpi.b	#$18,d0
			beq.w	loc_20C228
			move.b	#$14,obj.routine(a0)
loc_20C228:
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
loc_20C24E:
			moveq	#$F,d0
			bsr.w	loc_20B6EC
			tst.b	d1
			beq.w	loc_20C264
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
loc_20C264:
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C278:
			moveq	#$F,d0
			bsr.w	loc_20B6EC
			tst.b	d1
			beq.w	loc_20C28E
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
loc_20C28E:
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C2A2:
			movea.w obj.field_3E(a0),a2
			move.b	obj.routine(a2),d0
			cmpi.b	#$18,d0
			beq.w	loc_20C2C2
			move.b	#$10,obj.routine(a0)
			move.w	obj.field_36(a0),obj.field_38(a0)
			bra.w	loc_20C32E
; ---------------------------------------------------------------------------
loc_20C2C2:
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
			move.b	obj.height(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
loc_20C32E:
			bsr.w	sub_20C042
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C346:
			btst	#1,(byte_FFF7DC).w
			beq.w	loc_20C35A
			move.b	obj.field_3C(a0),d0
			move.b	#$1A,obj.routine(a0)
loc_20C35A:
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
			move.b	obj.height(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
loc_20C394:
			bsr.w	sub_20C042
			bsr.w	sub_20BFCE
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C3B0:
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
loc_20C3F2:
			btst	#3,obj.status(a0)
			beq.w	locret_20C14A
			bclr	#3,obj.status(a1)
			bclr	#3,obj.status(a0)
locret_20C408:
			rts
; ---------------------------------------------------------------------------
loc_20C40A:
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
			move.b	obj.height(a1),d1
			swap	d1
			sub.l	d1,d0
			move.l	d0,obj.ypos(a1)
loc_20C448:
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; =============== S U B R O U T I N E =======================================
sub_20C45C:
			move.b	obj.field_3C(a0),d0
			cmpi.b	#7,d0
			bpl.w	loc_20C4FC
			cmpi.b	#5,d0
			bpl.w	loc_20C582
			bra.w	loc_20C478
; ---------------------------------------------------------------------------
			dc.b $12
			dc.b $34
			dc.b $56
			dc.b $78
; ---------------------------------------------------------------------------
loc_20C478:
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
locret_20C4DA:
			rts
; End of function sub_20C45C
; =============== S U B R O U T I N E =======================================
sub_20C4DC:
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
loc_20C4FC:
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
locret_20C55E:
			rts
; =============== S U B R O U T I N E =======================================
sub_20C560:

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
loc_20C582:
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
loc_20C5B2:
			add.w	d0,d1
			move.w	d1,obj.xpos(a0)
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$26,d0
			bne.w	locret_20C5D2
			move.b	#$20,obj.routine(a0)
			bsr.s	sub_20C560
locret_20C5D2:
			rts
; ---------------------------------------------------------------------------
loc_20C5D4:
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20C5E8:
			lea	(off_20CED0).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
locret_20C5FC:
			rts
; ---------------------------------------------------------------------------
unk_20C5FE: dc.b   0
			dc.b   0
			dc.b  $F
			dc.b $F8
			dc.b $1F
			dc.b $F0
			dc.b $2F ; /
			dc.b $E8
			dc.b $3F ; ?
			dc.b $E0
			dc.b $4F
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
			dc.b $27
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
			dc.b $21
			dc.b $3F ; ?
			dc.b $29 ; )
			dc.b $4F
			dc.b $31 ; 1
			dc.b $5F ; _
			dc.b   0
			dc.b   0
			dc.b   6
			dc.b $10
			dc.b  $D
			dc.b $21
			dc.b $14
			dc.b $31 ; 1
			dc.b $1B
			dc.b $42 ; B
			dc.b $21
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
			dc.b $21
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
unk_20C708: dc.b   0
			dc.b   0
			dc.b  $F
			dc.b   7
			dc.b $1F
			dc.b  $F
			dc.b $2F ; /
			dc.b $17
			dc.b $3F ; ?
			dc.b $1F
			dc.b $4F
			dc.b $27
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
			dc.b $27
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
			dc.b $24
			dc.b $27
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
			dc.b $24
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
			dc.b $21
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
obj26:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20C820(pc,d0.w),d0
			jmp	off_20C820(pc,d0.w)
; ---------------------------------------------------------------------------
off_20C820: dc.w loc_20C824-off_20C820
			dc.w loc_20C88A-off_20C820
; ---------------------------------------------------------------------------
loc_20C824:
			addq.b	#2,obj.routine(a0)
			move.l	#obj26_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			moveq	#$A,d0
			jsr	sub_20DC4C(pc)
			move.b	obj.subtype(a0),d0
			andi.b	#7,d0
			move.b	d0,obj.ani(a0)
			move.b	#$86,obj.colflag(a0)
			move.b	#$10,obj.field_19(a0)
			move.b	#$C,obj.height(a0)
			cmpi.b	#3,d0
			bne.w	loc_20C874
			move.b	#2,obj.field_19(a0)
			move.b	#$C,obj.height(a0)
loc_20C874:
			cmpi.b	#4,d0
			bmi.w	locret_20C888
			move.b	#$10,obj.field_19(a0)
			move.b	#3,obj.height(a0)
locret_20C888:
			rts
; ---------------------------------------------------------------------------
loc_20C88A:
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			jsr	(sub_207F56).l
			lea	(obj26_ani).l,a1
			jsr	(animateobj).l
			jsr	(displaysprite).l
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
obj29:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20C8C2(pc,d0.w),d0
			jmp	off_20C8C2(pc,d0.w)
; ---------------------------------------------------------------------------
off_20C8C2: dc.w loc_20C8CA-off_20C8C2
			dc.w loc_20C9AC-off_20C8C2
			dc.w loc_20CB98-off_20C8C2
			dc.w loc_20CC02-off_20C8C2
; ---------------------------------------------------------------------------
loc_20C8CA:
			addq.b	#2,obj.routine(a0)
			move.l	#obj29_map,obj.mappings(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#$10,obj.field_19(a0)
			moveq	#$11,d0
			jsr	(sub_20DC4C).l
			move.b	obj.field_3D(a0),d0
			bne.s	loc_20C92E
			move.b	obj.subtype(a0),d6
			andi.w	#$F,d6
			jsr	sub_20C93C(pc)
			move.b	obj.field_3D(a1),d0
			ori.b	#$80,d0
			move.b	d0,obj.field_3D(a1)
			movea.w a2,a4
			subq.w	#1,d6
loc_20C912:
			jsr	sub_20C93C(pc)
			subq.w	#1,d6
			bne.s	loc_20C912
			move.b	obj.subtype(a0),d0
			andi.b	#$70,d0
			cmpi.b	#$70,d0
			bne.s	locret_20C92C
			jsr	sub_20C966(pc)
locret_20C92C:
			rts
; ---------------------------------------------------------------------------
loc_20C92E:
			move.b	obj.field_3D(a0),d0
			bpl.s	locret_20C93A
			move.b	#4,obj.routine(a0)
locret_20C93A:
			rts
; =============== S U B R O U T I N E =======================================
sub_20C93C:
			jsr	(findfreeobj).l
			bne.s	locret_20C964
			move.b	obj.subtype(a0),obj.subtype(a1)
			move.b	#objid_29,obj.id(a1)
			move.w	a0,obj.field_3E(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.b	d6,obj.field_3D(a1)
locret_20C964:
			rts
; End of function sub_20C93C
; =============== S U B R O U T I N E =======================================
sub_20C966:
			jsr	(findfreeobj).l
			bne.s	locret_20C964
			move.b	#objid_13,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			move.w	a4,obj.field_3E(a1)
			move.b	#1,obj.field_3D(a1)
			rts
; End of function sub_20C966
; ---------------------------------------------------------------------------
unk_20C98C: dc.b   1
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
loc_20C9AC:
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
loc_20C9DA:
			moveq	#0,d0
			move.b	obj.subtype(a0),d0
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
off_20CA06: dc.l loc_20CA26
			dc.l loc_20CA32
			dc.l loc_20CA3E
			dc.l loc_20CA6E
			dc.l loc_20CA9E
			dc.l loc_20CAD4
			dc.l loc_20CB0A
			dc.l loc_20CA32
; ---------------------------------------------------------------------------
loc_20CA26:
			move.b	obj.field_3C(a0),d0
			addq.w	#1,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA32:
			move.b	obj.field_3C(a0),d0
			subq.w	#1,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA3E:
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			andi.w	#$FF,d0
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$80,d0
			bpl.w	loc_20CA58
			bmi.w	loc_20CA62
loc_20CA58:
			addi.w	#$40,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA62:
			not.w	d0
			addi.w	#$40,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA6E:
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			andi.w	#$FF,d0
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$80,d0
			bpl.w	loc_20CA88
			bmi.w	loc_20CA92
loc_20CA88:
			addi.w	#$C0,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA92:
			not.w	d0
			addi.w	#$C0,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CA9E:
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			cmpi.w	#$300,d0
			bmi.w	loc_20CAAE
			moveq	#0,d0
loc_20CAAE:
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$180,d0
			bpl.w	loc_20CABE
			bmi.w	loc_20CAC8
loc_20CABE:
			addi.w	#$C0,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CAC8:
			not.w	d0
			addi.w	#$C0,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CAD4:
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			cmpi.w	#$200,d0
			bmi.w	loc_20CAE4
			moveq	#0,d0
loc_20CAE4:
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$100,d0
			bpl.w	loc_20CAF4
			bmi.w	loc_20CAFE
loc_20CAF4:
			addi.w	#$80,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CAFE:
			addi.w	#$80,d0
			not.w	d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CB0A:
			move.w	obj.field_32(a0),d0
			addq.w	#1,d0
			cmpi.w	#$80,d0
			bmi.w	loc_20CB1A
			moveq	#0,d0
loc_20CB1A:
			move.w	d0,obj.field_32(a0)
			cmpi.w	#$40,d0
			bpl.w	loc_20CB2A
			bmi.w	loc_20CB34
loc_20CB2A:
			addi.w	#$A0,d0
			move.b	d0,obj.field_3C(a0)
			rts
; ---------------------------------------------------------------------------
loc_20CB34:
			addi.w	#$E0,d0
			not.w	d0
			move.b	d0,obj.field_3C(a0)
			rts
; =============== S U B R O U T I N E =======================================
sub_20CB40:
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
loc_20CB98:
			move.b	#3,obj.ani(a0)
			bsr.s	sub_20CB40
			move.b	#$18,obj.field_19(a0)
			move.b	#8,obj.height(a0)
			move.b	#8,obj.height(a0)
			lea	(actwk).w,a1
			bsr.w	sub_20B684
			beq.w	loc_20CBEE
			bsr.w	sub_20CC4C
			bne.w	loc_20CBEE
			move.w	obj.ypos(a0),d0
			moveq	#0,d1
			move.b	obj.height(a1),d1
			sub.w	d1,d0
			move.b	obj.height(a0),d1
			sub.w	d1,d0
			move.w	d0,obj.ypos(a1)
			bset	#3,obj.status(a1)
			bclr	#1,obj.status(a1)
			move.b	#6,obj.routine(a0)
loc_20CBEE:
			lea	(obj29_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20CC02:
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
loc_20CC3E:
			bclr	#3,obj.status(a1)
			move.b	#4,obj.routine(a0)
			bra.s	loc_20CBEE
; =============== S U B R O U T I N E =======================================
sub_20CC4C:
			lea	(actwk).w,a1
			moveq	#0,d2
			moveq	#0,d3
			move.b	obj.height(a0),d2
			move.b	obj.height(a1),d3
			move.w	obj.ypos(a0),d0
			move.w	obj.ypos(a1),d1
			add.w	d2,d0
			add.w	d3,d1
			cmp.w	d0,d1
			bpl.w	loc_20CC72
			bmi.w	loc_20CC76
loc_20CC72:
			moveq	#-1,d1
			rts
; ---------------------------------------------------------------------------
loc_20CC76:
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
obj28_ani:	dc.w unk_20CCC0-obj28_ani
			dc.w unk_20CCD0-obj28_ani
			dc.w unk_20CCDA-obj28_ani
			dc.w unk_20CCE4-obj28_ani
			dc.w unk_20CCE8-obj28_ani
unk_20CCC0: dc.b   2
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
unk_20CCD0: dc.b   2
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b   2
			dc.b   0
			dc.b   1
			dc.b   0
			dc.b $FF
			even
unk_20CCDA: dc.b   2
			dc.b   3
			dc.b   4
			dc.b   3
			dc.b   5
			dc.b   3
			dc.b   4
			dc.b   3
			dc.b $FF
			even
unk_20CCE4: dc.b   0
			dc.b   0
			dc.b $FF
			even
unk_20CCE8: dc.b   0
			dc.b   3
			dc.b $FF
			even
obj28_map:	dc.w byte_20CCF8-obj28_map
			dc.w byte_20CD04-obj28_map
			dc.w byte_20CD10-obj28_map
			dc.w byte_20CD1C-obj28_map
			dc.w byte_20CD28-obj28_map
			dc.w byte_20CD34-obj28_map
byte_20CCF8:	dc.b 2
			dc.b $FC,  1,  0,  0,$F8
			dc.b $FC,  8,  0,  2,  0
			even
byte_20CD04:	dc.b 2
			dc.b $FC,  5,  0,  5,$F8
			dc.b   0,  5,  0,  9,  8
			even
byte_20CD10:	dc.b 2
			dc.b $FC,  5,  0, $D,$F8
			dc.b $F0,  5,  0,$11,  8
			even
byte_20CD1C:	dc.b 2
			dc.b $FC,  1,  8,  0,  0
			dc.b $FC,  8,  8,  2,$E8
			even
byte_20CD28:	dc.b 2
			dc.b $FC,  5,  8,  5,$F8
			dc.b   0,  5,  8,  9,$E8
			even
byte_20CD34:	dc.b 2
			dc.b $FC,  5,  8, $D,$F8
			dc.b $F0,  5,  8,$11,$E8
			even
obj27_ani:	dc.w unk_20CD5C-obj27_ani
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
unk_20CD5C: dc.b   9
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
unk_20CD6C: dc.b   0
			dc.b   0
			dc.b $FF
			even
unk_20CD70: dc.b   0
			dc.b   1
			dc.b $FF
			even
unk_20CD74: dc.b   0
			dc.b   2
			dc.b $FF
			even
unk_20CD78: dc.b   0
			dc.b   3
			dc.b $FF
			even
unk_20CD7C: dc.b   0
			dc.b   4
			dc.b $FF
			even
unk_20CD80: dc.b   0
			dc.b   5
			dc.b $FF
			even
unk_20CD84: dc.b   0
			dc.b   6
			dc.b $FF
			even
unk_20CD88: dc.b   0
			dc.b   7
			dc.b $FF
			even
unk_20CD8C: dc.b   0
			dc.b   8
			dc.b $FF
			even
unk_20CD90: dc.b   0
			dc.b   9
			dc.b $FF
			even
unk_20CD94: dc.b   0
			dc.b  $A
			dc.b $FF
			even
unk_20CD98: dc.b   0
			dc.b  $B
			dc.b $FF
			even
unk_20CD9C: dc.b   0
			dc.b  $C
			dc.b $FF
			even
obj27_map:	dc.w byte_20CDBA-obj27_map
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
byte_20CDBA:	dc.b 3
			dc.b $F0, $C,  0,  0,  0
			dc.b   8, $C,$18,  0,$E0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CDCA:	dc.b 5
			dc.b $F0, $C,  0,  4,  0
			dc.b $E8,  0,  0,  8,$18
			dc.b   8, $C,$18,  4,$E0
			dc.b $10,  0,$18,  8,$E0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CDE4:	dc.b 3
			dc.b $E8, $D,  0,  9,  0
			dc.b   8, $D,$18,  9,$E0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CDF4:	dc.b 7
			dc.b $E8, $D,  0,$11,  0
			dc.b $E0,  0,  0,$19,$10
			dc.b $F0,  0,  0,$1A,$F8
			dc.b   8, $D,$18,$11,$E0
			dc.b $18,  0,$18,$19,$E8
			dc.b   8,  0,$18,$1A,  0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE18:	dc.b 5
			dc.b $E0, $E,  0,$1B,  0
			dc.b $F0,  0,  0,$27,$F8
			dc.b   8, $E,$18,$1B,$E0
			dc.b   8,  0,$18,$27,  0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE32:	dc.b 3
			dc.b $E0,  6,  0,$28,$F8
			dc.b   8,  6,$10,$28,$F8
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE42:	dc.b 3
			dc.b $F0, $C,  8,  0,$E0
			dc.b   8, $C,$10,  0,  0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE52:	dc.b 5
			dc.b $F0, $C,  8,  4,$E0
			dc.b $E8,  0,  8,  8,$E0
			dc.b   8, $C,$10,  4,  0
			dc.b $10,  0,$10,  8,$18
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE6C:	dc.b 3
			dc.b $E8, $D,  8,  9,$E0
			dc.b   8, $D,$10,  9,  0
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CE7C:	dc.b 7
			dc.b $E8, $D,  8,$11,$E0
			dc.b $E0,  0,  8,$19,$E8
			dc.b $F0,  0,  8,$1A,  0
			dc.b   8, $D,$10,$11,  0
			dc.b $18,  0,$10,$19,$10
			dc.b   8,  0,$10,$1A,$F8
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CEA0:	dc.b 5
			dc.b $E0, $E,  8,$1B,$E0
			dc.b $F0,  0,  8,$27,  0
			dc.b   8, $E,$10,$1B,  0
			dc.b   8,  0,$10,$27,$F8
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CEBA:	dc.b 3
			dc.b $E0,  6,  8,$28,$F8
			dc.b   8,  6,$18,$28,$F8
			dc.b $FC,  0,$C0,$2E,$FC
			even
byte_20CECA:	dc.b 1
			dc.b $FC,  0,$C0,$2E,$FC
			even
off_20CED0: dc.w unk_20CED6-off_20CED0
			dc.w unk_20CEDA-off_20CED0
			dc.w unk_20CEDE-off_20CED0
unk_20CED6: dc.b $1D
			dc.b   0
			dc.b   1
			dc.b $FF
unk_20CEDA: dc.b   0
			dc.b   0
			dc.b $FF
			even
unk_20CEDE: dc.b   0
			dc.b   1
			dc.b $FF
			even
off_20CEE2: dc.w byte_20CEE6-off_20CEE2
			dc.w byte_20CEEC-off_20CEE2
byte_20CEE6:	dc.b 1
			dc.b $F8,  5,  0,  0,$F8
			even
byte_20CEEC:	dc.b 1
			dc.b $F8,  5,  0,  4,$F8
			even
obj26_ani:	dc.w unk_20CEFE-obj26_ani
			dc.w unk_20CF02-obj26_ani
			dc.w unk_20CF06-obj26_ani
			dc.w unk_20CF0A-obj26_ani
			dc.w unk_20CF0E-obj26_ani
			dc.w unk_20CF12-obj26_ani
unk_20CEFE: dc.b $1D
			dc.b   0
			dc.b $FF
			even
unk_20CF02: dc.b $1D
			dc.b   1
			dc.b $FF
			even
unk_20CF06: dc.b $1D
			dc.b   2
			dc.b $FF
			even
unk_20CF0A: dc.b $1D
			dc.b   3
			dc.b $FF
			even
unk_20CF0E: dc.b $1D
			dc.b   4
			dc.b $FF
			even
unk_20CF12: dc.b $1D
			dc.b   5
			dc.b $FF
			even
off_20CF16: dc.w byte_20CF1C-off_20CF16
			dc.w byte_20CF27-off_20CF16
			dc.w byte_20CF32-off_20CF16
byte_20CF1C:	dc.b 2
			dc.b $F0,  7,  0,  0,$F0
			dc.b $F0,  7,  0,  0,  0
byte_20CF27:	dc.b 2
			dc.b $F0, $D,  0,  8,$F0
			dc.b   0, $D,  0,  8,$F0
			even
byte_20CF32:	dc.b 2
			dc.b $F0, $D,  8,  8,$F0
			dc.b   0, $D,  8,  8,$F0
			even
off_20CF3E: dc.w byte_20CF46-off_20CF3E
			dc.w byte_20CF5B-off_20CF3E
			dc.w byte_20CF70-off_20CF3E
			dc.w byte_20CF85-off_20CF3E
byte_20CF46:	dc.b 4
			dc.b $F0,  3,  0,  0,$F0
			dc.b $F1,  3,  0,  0,$F8
			dc.b $F2,  3,  0,  0,  0
			dc.b $F3,  3,  0,  0,  8
byte_20CF5B:	dc.b 4
			dc.b $F0, $C,  0,  4,$F0
			dc.b $F8, $C,  0,  4,$F1
			dc.b   0, $C,  0,  4,$F2
			dc.b   8, $C,  0,  4,$F3
			even
byte_20CF70:	dc.b 4
			dc.b $F0, $C,  8,  4,$F3
			dc.b $F8, $C,  8,  4,$F2
			dc.b   0, $C,  8,  4,$F1
			dc.b   8, $C,  8,  4,$F0
byte_20CF85:	dc.b 2
			dc.b $F0,  3,  0,  0,$F4
			dc.b $F0,  3,  0,  0,  4
			even
obj26_map:	dc.w byte_20CF9C-obj26_map
			dc.w byte_20CFA7-obj26_map
			dc.w byte_20CFBC-obj26_map
			dc.w byte_20CFD1-obj26_map
			dc.w byte_20CFD8-obj26_map
			dc.w byte_20CFDE-obj26_map
byte_20CF9C:	dc.b 2
			dc.b $F0,  7,  0,  0,$F0
			dc.b $F0,  7,  0,  0,  0
byte_20CFA7:	dc.b 4
			dc.b $F0, $C,  0,  8,$F0
			dc.b $F8, $C,  0,  8,$F0
			dc.b   0, $C,  0,  8,$F0
			dc.b   8, $C,  0,  8,$F0
			even
byte_20CFBC:	dc.b 4
			dc.b $F0, $C,  8,  8,$F0
			dc.b $F8, $C,  8,  8,$F0
			dc.b   0, $C,  8,  8,$F0
			dc.b   8, $C,  8,  8,$F0
byte_20CFD1:	dc.b 1
			dc.b $F0,  3,  0,  0,$FC
			even
byte_20CFD8:	dc.b 1
			dc.b $FC, $C,  0,  8,$F0
			even
byte_20CFDE:	dc.b 1
			dc.b $FC, $C,  8,  8,$F0
			even
obj29_ani:	dc.w unk_20CFEC-obj29_ani
			dc.w unk_20CFF2-obj29_ani
			dc.w unk_20CFF6-obj29_ani
			dc.w unk_20CFFA-obj29_ani
unk_20CFEC: dc.b $1D
			dc.b   0
			dc.b   1
			dc.b   2
			dc.b $FF
			even
unk_20CFF2: dc.b $1D
			dc.b   0
			dc.b $FF
			even
unk_20CFF6: dc.b $1D
			dc.b   1
			dc.b $FF
			even
unk_20CFFA: dc.b $1D
			dc.b   2
			dc.b $FF
			even
obj29_map:	dc.w byte_20D004-obj29_map
			dc.w byte_20D00A-obj29_map
			dc.w byte_20D010-obj29_map
byte_20D004:	dc.b 1
			dc.b $F8,  5,  0,  0,$F8
			even
byte_20D00A:	dc.b 1
			dc.b $F8,  5,  0,  4,$F8
			even
byte_20D010:	dc.b 2
			dc.b $F8,  9,  0,  8,$E8
			dc.b $F8,  9,  8,  8,  0
			even
; ---------------------------------------------------------------------------
obj20:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20D030(pc,d0.w),d0
			jsr	off_20D030(pc,d0.w)
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
off_20D030: dc.w loc_20D038-off_20D030
			dc.w loc_20D0AC-off_20D030
			dc.w loc_20D0F2-off_20D030
			dc.w loc_20D136-off_20D030
; ---------------------------------------------------------------------------
loc_20D038:
			addq.b	#2,obj.routine(a0)
			ori.b	#4,obj.render(a0)
			move.b	#3,obj.priority(a0)
			move.w	#$4000,obj.vram(a0)
			lea	off_20D34C(pc),a1
			lea	off_20D3C2(pc),a2
			move.b	obj.subtype(a0),d0
			bpl.w	loc_20D066
			lea	off_20D418(pc),a1
			lea	off_20D5B0(pc),a2
loc_20D066:
			move.l	a1,obj.mappings(a0)
			btst	#4,d0
			beq.w	loc_20D07E
			bset	#0,obj.render(a0)
			bset	#0,obj.status(a0)
loc_20D07E:
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
loc_20D0A2:
			addq.b	#1,d1
			asl.b	#3,d1
			addq.b	#2,d1
			move.b	d1,obj.height(a0)
loc_20D0AC:
			tst.b	obj.render(a0)
			bpl.s	locret_20D0E0
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			lea	(actwk).w,a3
			lea	(byte_FFD040).w,a1
			move.b	(byte_FF1219).l,d0
			beq.w	loc_20D0CE
			exg.l	a1,a3
loc_20D0CE:
			jsr	(sub_207F56).l
			exg.l	a1,a3
			jsr	(sub_207F56).l
			bne.w	loc_20D0E2
locret_20D0E0:
			rts
; ---------------------------------------------------------------------------
loc_20D0E2:
			addq.b	#2,obj.routine(a0)
			move.b	obj.subtype(a0),d0
			bpl.w	loc_20D170
			bra.w	loc_20D262
; ---------------------------------------------------------------------------
loc_20D0F2:
			lea	obj.field_2A(a0),a3
			addi.w	#-1,(a3)
			bne.w	loc_20D102
			addq.b	#2,obj.routine(a0)
loc_20D102:
			move.b	obj.field_3E(a0),d0
			beq.w	locret_20D134
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			lea	(actwk).w,a1
			bsr.w	sub_20D11E
			lea	(byte_FFD040).w,a1
; =============== S U B R O U T I N E =======================================
sub_20D11E:
			jsr	(sub_207F56).l
			beq.w	locret_20D134
			tst.w	(a3)
			bne.w	locret_20D134
			bclr	#3,obj.status(a1)
locret_20D134:

			rts
; End of function sub_20D11E
; ---------------------------------------------------------------------------
loc_20D136:
			move.l	obj.field_2C(a0),d0
			add.l	d0,obj.ypos(a0)
			addi.l	#$4000,obj.field_2C(a0)
			move.w	obj.ypos(a0),d0
			lea	(actwk).w,a1
			move.b	(byte_FF1219).l,d1
			beq.w	loc_20D15C
			lea	(byte_FFD040).w,a1
loc_20D15C:
			sub.w	obj.ypos(a1),d0
			cmpi.w	#$200,d0
			bgt.w	loc_20D16A
			rts
; ---------------------------------------------------------------------------
loc_20D16A:
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_20D170:
			move.b	obj.subtype(a0),d0
			suba.l	a4,a4
			btst	#4,d0
			beq.w	loc_20D182
			lea	loc_20D170(pc),a4
loc_20D182:
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
loc_20D1AC:
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
loc_20D1CE:
			move.w	a5,d5
			move.w	a2,d3
			move.w	d2,d1
loc_20D1D4:
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
loc_20D22A:
			tst.w	d6
			bne.w	loc_20D240
			st	obj.field_3E(a1)
			move.b	#8,obj.field_19(a1)
			move.b	#9,obj.height(a1)
loc_20D240:
			move.w	d4,obj.ypos(a1)
			move.w	d3,obj.xpos(a1)
			move.w	d1,obj.field_2A(a1)
loc_20D24C:
			add.w	a3,d3
			addi.w	#$C,d1
			dbf	d5,loc_20D1D4
			addi.w	#-$10,d4
			addq.w	#5,d2
			dbf	d6,loc_20D1CE
locret_20D260:
			rts
; ---------------------------------------------------------------------------
loc_20D262:
			move.b	obj.subtype(a0),d2
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
loc_20D2A2:
			lea	(actwk).w,a1
			move.b	(byte_FF1219).l,d0
			beq.w	loc_20D2B4
			lea	(byte_FFD040).w,a1
loc_20D2B4:
			move.w	obj.xvel(a1),d0
			btst	#5,d2
			beq.w	loc_20D2C2
			neg.w	d0
loc_20D2C2:
			tst.w	d0
loc_20D2C4:
			bpl.w	loc_20D2D2
			lea	(a6,d5.w),a6
			neg.w	d4
			neg.w	d3
			neg.w	d6
loc_20D2D2:
			add.w	obj.xpos(a0),d4
			move.w	#9,d2
			move.b	obj.id(a0),obj.field_3F(a0)
			clr.b	obj.id(a0)
loc_20D2E4:
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
			move.b	d1,obj.height(a1)
			move.b	(a6),obj.frame(a1)
			lea	(a6,d6.w),a6
			move.w	d4,obj.xpos(a1)
			add.w	d3,d4
			move.w	d2,obj.field_2A(a1)
			addi.w	#$C,d2
			dbf	d5,loc_20D2E4
locret_20D34A:
			rts
; ---------------------------------------------------------------------------
off_20D34C: dc.w byte_20D34E-off_20D34C
byte_20D34E:	dc.b 23
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
off_20D3C2: dc.w unk_20D3C4-off_20D3C2
unk_20D3C4: dc.b   4
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
obj20_map:	dc.w byte_20D3E8-obj20_map
			dc.w byte_20D3EE-obj20_map
			dc.w byte_20D3F4-obj20_map
			dc.w byte_20D3FA-obj20_map
			dc.w byte_20D400-obj20_map
			dc.w byte_20D406-obj20_map
			dc.w byte_20D40C-obj20_map
byte_20D3E8:	dc.b 1
			dc.b $F8,  5,  0,$19,$F8
			even
byte_20D3EE:	dc.b 1
			dc.b $F8,  5,  8,$25,$F8
			even
byte_20D3F4:	dc.b 1
			dc.b $F8,  5,  0,$1D,$F8
			even
byte_20D3FA:	dc.b 1
			dc.b $F8,  5,  0,$21,$F8
			even
byte_20D400:	dc.b 1
			dc.b $F8,  5,  8,$1D,$F8
			even
byte_20D406:	dc.b 1
			dc.b $F8,  5,  8,$15,$F8
			even
byte_20D40C:	dc.b 2
			dc.b $E8,  5,  8, $D,$F8
			dc.b $F8,  5,  8,$11,$F8
			even
off_20D418: dc.w byte_20D424-off_20D418
			dc.w byte_20D424-off_20D418
			dc.w byte_20D47F-off_20D418
			dc.w byte_20D4E4-off_20D418
			dc.w byte_20D549-off_20D418
			dc.w byte_20D57C-off_20D418
byte_20D424:	dc.b 18
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
byte_20D47F:	dc.b 20
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
byte_20D4E4:	dc.b 20
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
byte_20D549:	dc.b 10
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
byte_20D57C:	dc.b 10
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
off_20D5B0: dc.w unk_20D5BC-off_20D5B0
			dc.w unk_20D5BC-off_20D5B0
			dc.w unk_20D5C4-off_20D5B0
			dc.w unk_20D5CA-off_20D5B0
			dc.w unk_20D5D0-off_20D5B0
			dc.w unk_20D5D4-off_20D5B0
unk_20D5BC: dc.b   5
			dc.b   1
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			dc.b   0
			even
unk_20D5C4: dc.b   3
			dc.b   3
			dc.b   1
			dc.b   2
			dc.b   2
			dc.b   2
			even
unk_20D5CA: dc.b   3
			dc.b   3
			dc.b   2
			dc.b   2
			dc.b   2
			dc.b   2
			even
unk_20D5D0: dc.b   1
			dc.b   3
			dc.b   3
			dc.b   5
			even
unk_20D5D4: dc.b   1
			dc.b   3
			dc.b   5
			dc.b   4
			even
obj20b_map: dc.w byte_20D5E4-obj20b_map
			dc.w byte_20D5F4-obj20b_map
			dc.w byte_20D60E-obj20b_map
			dc.w byte_20D628-obj20b_map
			dc.w byte_20D642-obj20b_map
			dc.w byte_20D65C-obj20b_map
byte_20D5E4:	dc.b 3
			dc.b $E0,  5,  0, $D,$F8
			dc.b $F0,  5,  0,$11,$F8
			dc.b   0,  5,  0,$15,$F8
			even
byte_20D5F4:	dc.b 5
			dc.b $D0,  5,  0, $D,$F8
			dc.b $E0,  5,  0,$11,$F8
			dc.b $F0,  5,  0,$15,$F8
			dc.b   0,  5,  0,$29,$F8
			dc.b $10,  5,  0,$31,$F8
			even
byte_20D60E:	dc.b 5
			dc.b $D0,  5,  0, $D,$F8
			dc.b $E0,  5,  0,$11,$F8
			dc.b $F0,  5,  0,$15,$F8
			dc.b   0,  5,  0,$33,$F8
			dc.b $10,  5,  0,$2B,$F8
			even
byte_20D628:	dc.b 5
			dc.b $D0,  5,  0, $D,$F8
			dc.b $E0,  5,  0,$11,$F8
			dc.b $F0,  5,  0,$15,$F8
			dc.b   0,  5,  0,$1D,$F8
			dc.b $10,  5,  0,$19,$F8
			even
byte_20D642:	dc.b 5
			dc.b $D0,  5,  0, $D,$F8
			dc.b $E0,  5,  0,$11,$F8
			dc.b $F0,  5,  0,$15,$F8
			dc.b   0,  5,  8,$1D,$F8
			dc.b $10,  5,  0,$19,$F8
			even
byte_20D65C:	dc.b 5
			dc.b $D0,  5,  0, $D,$F8
			dc.b $E0,  5,  0,$11,$F8
			dc.b $F0,  5,  0,$15,$F8
			dc.b   0,  5,  0,$21,$F8
			dc.b $10,  5,  0,$19,$F8
			even
; ---------------------------------------------------------------------------
obj21:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20D68C(pc,d0.w),d0
			jsr	off_20D68C(pc,d0.w)
			jsr	(displaysprite).l
			rts
; ---------------------------------------------------------------------------
off_20D68C: dc.w loc_20D6A4-off_20D68C
			dc.w loc_20D776-off_20D68C
; =============== S U B R O U T I N E =======================================
sub_20D690:
			lea	(actwk).w,a1
			move.w	obj.xpos(a0),d3
			move.w	obj.ypos(a0),d4
			subq.w	#4,d4
			jmp	(sub_207F56).l
; End of function sub_20D690
; ---------------------------------------------------------------------------
loc_20D6A4:
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
loc_20D6EE:
			move.l	d0,obj.mappings(a0)
			move.b	obj.subtype(a0),d0
			move.b	d0,d1
			andi.w	#3,d0
			move.b	d0,obj.frame(a0)
			move.b	byte_20D76E(pc,d0.w),obj.field_19(a0)
			move.b	#4,obj.height(a0)
			lsr.b	#2,d1
			andi.w	#3,d1
			move.b	byte_20D772(pc,d1.w),obj.field_2D(a0)
			move.b	obj.field_29(a0),d0
			beq.s	loc_20D768
			jsr	(findfreeobj).l
			beq.s	loc_20D72C
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
loc_20D72C:
			move.b	#objid_0A,obj.id(a1)
			move.w	obj.xpos(a0),obj.xpos(a1)
			move.w	obj.ypos(a0),obj.ypos(a1)
			subi.w	#$10,obj.ypos(a1)
			move.b	#$F0,obj.field_39(a1)
			move.w	a0,obj.field_34(a1)
			move.b	obj.field_29(a0),d0
			move.b	d0,d1
			andi.b	#2,d1
			move.b	d1,obj.subtype(a1)
			andi.b	#$F8,d0
			move.b	d0,obj.field_38(a1)
			add.w	d0,obj.xpos(a1)
loc_20D768:
			addq.b	#2,obj.routine(a0)
			rts
; ---------------------------------------------------------------------------
byte_20D76E:
			dc.b $10
			dc.b $20
			dc.b $30
			dc.b   0
			even
byte_20D772:
			dc.b $20
			dc.b $30
			dc.b $40
			dc.b $60
			even
; ---------------------------------------------------------------------------
loc_20D776:
			tst.w	(word_FF1278).l
			beq.s	loc_20D782
			bra.w	sub_20D690
; ---------------------------------------------------------------------------
loc_20D782:
			move.b	obj.subtype(a0),d0
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
locret_20D7B8:
			rts
; ---------------------------------------------------------------------------
off_20D7BA: dc.w loc_20D7CE-off_20D7BA
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
loc_20D7CE:
			addq.b	#1,obj.field_2A(a0)
			jsr	sub_20DAB6(pc)
			add.w	obj.field_3A(a0),d0
			move.w	d0,obj.ypos(a0)
			jmp	(sub_20D690).l
; ---------------------------------------------------------------------------
loc_20D7E4:
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
loc_20D808:
			move.l	(sp)+,d0
			move.l	obj.xpos(a0),d1
			sub.l	d0,d1
			asr.l	#8,d1
			move.w	d1,obj.xvel(a0)
loc_20D816:
			jsr	sub_20D690(pc)
			beq.s	loc_20D82E
			move.b	obj.field_2C(a0),d0
			cmpi.b	#8,d0
			bcc.s	loc_20D82A
			addq.b	#1,obj.field_2C(a0)
loc_20D82A:
			moveq	#1,d0
			rts
; ---------------------------------------------------------------------------
loc_20D82E:
			moveq	#0,d0
			move.b	obj.field_2C(a0),d0
			beq.s	loc_20D83A
			subq.b	#1,obj.field_2C(a0)
loc_20D83A:
			moveq	#0,d0
			rts
; ---------------------------------------------------------------------------
loc_20D83E:
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
loc_20D862:
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
sub_20D888:
			moveq	#0,d0
			move.b	obj.field_2C(a0),d0
			asr.b	#1,d0
			add.w	obj.field_3A(a0),d0
			move.w	d0,obj.ypos(a0)
			bra.w	loc_20D816
; End of function sub_20D888
; ---------------------------------------------------------------------------
loc_20D89C:
			move.b	obj.field_2B(a0),d0
			bne.s	loc_20D8B4
			jsr	sub_20D888(pc)
			bne.s	loc_20D8AA
			rts
; ---------------------------------------------------------------------------
loc_20D8AA:
			move.b	#$1E,obj.field_2E(a0)
			addq.b	#2,obj.field_2B(a0)
loc_20D8B4:
			move.b	obj.field_2E(a0),d0
			beq.s	loc_20D8C2
			subq.b	#1,obj.field_2E(a0)
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20D8C2:
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
loc_20D8E8:
			jsr	(sub_20611C).l
			tst.w	d1
			bpl.s	loc_20D8FC
			lea	(actwk).w,a1
			bclr	#3,obj.status(a1)
loc_20D8FC:
			move.w	(dword_FFF704).w,d0
			addi.w	#224,d0
			cmp.w	obj.ypos(a0),d0
			bcc.s	locret_20D910
			jmp	(deleteobj).l
; ---------------------------------------------------------------------------
locret_20D910:
			rts
; ---------------------------------------------------------------------------
loc_20D912:
			move.b	obj.field_2B(a0),d0
			andi.w	#$FF,d0
			move.w	off_20D922(pc,d0.w),d0
			jmp	off_20D922(pc,d0.w)
; ---------------------------------------------------------------------------
off_20D922: dc.w loc_20D928-off_20D922
			dc.w loc_20D934-off_20D922
			dc.w loc_20D962-off_20D922
; ---------------------------------------------------------------------------
loc_20D928:
			jsr	sub_20D888(pc)
			bne.s	loc_20D930
			rts
; ---------------------------------------------------------------------------
loc_20D930:
			addq.b	#2,obj.field_2B(a0)
loc_20D934:
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
loc_20D958:
			move.w	obj.ypos(a0),obj.field_3A(a0)
			addq.b	#2,obj.field_2B(a0)
loc_20D962:
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20D966:
			move.b	obj.field_2B(a0),d0
			andi.w	#$FF,d0
			move.w	off_20D976(pc,d0.w),d0
			jmp	off_20D976(pc,d0.w)
; ---------------------------------------------------------------------------
off_20D976: dc.w loc_20D97C-off_20D976
			dc.w loc_20D98E-off_20D976
			dc.w loc_20D9C2-off_20D976
; ---------------------------------------------------------------------------
loc_20D97C:
			jsr	sub_20D888(pc)
			bne.s	loc_20D984
			rts
; ---------------------------------------------------------------------------
loc_20D984:
			addq.b	#2,obj.field_2B(a0)
			move.b	#$3C,obj.field_2E(a0)
loc_20D98E:
			move.b	obj.field_2E(a0),d0
			beq.s	loc_20D99C
			subq.b	#1,obj.field_2E(a0)
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20D99C:
			jsr	(sub_203166).l
			subq.w	#8,obj.yvel(a0)
			jsr	(sub_2062B2).l
			tst.w	d1
			bmi.s	loc_20D9B4
			bra.w	loc_20D816
; ---------------------------------------------------------------------------
loc_20D9B4:
			sub.w	d1,obj.ypos(a0)
			move.w	obj.ypos(a0),obj.field_3A(a0)
			addq.b	#2,obj.field_2B(a0)
loc_20D9C2:
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20D9C6:
			move.b	obj.field_2B(a0),d0
			andi.w	#$FF,d0
			move.w	off_20D9D6(pc,d0.w),d0
			jmp	off_20D9D6(pc,d0.w)
; ---------------------------------------------------------------------------
off_20D9D6: dc.w loc_20D9DC-off_20D9D6
			dc.w loc_20D9EE-off_20D9D6
			dc.w loc_20DA3A-off_20D9D6
; ---------------------------------------------------------------------------
loc_20D9DC:
			jsr	sub_20D888(pc)
			bne.s	loc_20D9E4
			rts
; ---------------------------------------------------------------------------
loc_20D9E4:
			addq.b	#2,obj.field_2B(a0)
			move.b	#$3C,obj.field_2E(a0)
loc_20D9EE:
			move.b	obj.field_2E(a0),d0
			beq.s	loc_20D9FC
			subq.b	#1,obj.field_2E(a0)
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20D9FC:
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
loc_20DA30:
			move.w	obj.xpos(a0),obj.field_38(a0)
			addq.b	#2,obj.field_2B(a0)
loc_20DA3A:
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20DA3E:
			move.b	obj.field_2B(a0),d0
			andi.w	#$FF,d0
			move.w	off_20DA4E(pc,d0.w),d0
			jmp	off_20DA4E(pc,d0.w)
; ---------------------------------------------------------------------------
off_20DA4E: dc.w loc_20DA54-off_20DA4E
			dc.w loc_20DA66-off_20DA4E
			dc.w loc_20DAB2-off_20DA4E
; ---------------------------------------------------------------------------
loc_20DA54:
			jsr	sub_20D888(pc)
			bne.s	loc_20DA5C
			rts
; ---------------------------------------------------------------------------
loc_20DA5C:
			addq.b	#2,obj.field_2B(a0)
			move.b	#$3C,obj.field_2E(a0)
loc_20DA66:
			move.b	obj.field_2E(a0),d0
			beq.s	loc_20DA74
			subq.b	#1,obj.field_2E(a0)
			bra.w	sub_20D888
; ---------------------------------------------------------------------------
loc_20DA74:
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
loc_20DAA8:
			move.w	obj.xpos(a0),obj.field_38(a0)
			addq.b	#2,obj.field_2B(a0)
loc_20DAB2:
			bra.w	sub_20D888
; =============== S U B R O U T I N E =======================================
sub_20DAB6:
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
obj21_map:	dc.w byte_20DAD4-obj21_map
			dc.w byte_20DAEA-obj21_map
			dc.w byte_20DB14-obj21_map
byte_20DAD4:	dc.b 4
			dc.b $F0,  5,  0,  1,$F0
			dc.b $F0,  5,  8,  1,  0
			dc.b   0,  5,  0,  5,$F0
			dc.b   0,  5,  8,  5,  0
			even
byte_20DAEA:	dc.b 8
			dc.b $F0,  5,  0,  1,$E0
			dc.b $F0,  5,  0,  1,$F0
			dc.b $F0,  5,  0,  1,  0
			dc.b $F0,  5,  0,  1,$10
			dc.b   0,  5,  0,  5,$E0
			dc.b   0,  5,  0,  9,$F0
			dc.b   0,  5,  0,  9,  0
			dc.b   0,  5,  8,  5,$10
			even
byte_20DB14:	dc.b $C
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
obj21b_map: dc.w byte_20DB58-obj21b_map
			dc.w byte_20DB6E-obj21b_map
			dc.w byte_20DB98-obj21b_map
byte_20DB58:	dc.b 4
			dc.b $F0,  5,  0,$31,$F0
			dc.b $F0,  5,  8,$31,  0
			dc.b   0,  5,  0,$35,$F0
			dc.b   0,  5,  8,$35,  0
			even
byte_20DB6E:	dc.b 8
			dc.b $F0,  5,  0,$31,$E0
			dc.b $F0,  5,  8,$31,$F0
			dc.b   0,  5,  0,$35,$E0
			dc.b   0,  5,  8,$35,$F0
			dc.b $F0,  5,  0,$31,  0
			dc.b $F0,  5,  8,$31,$10
			dc.b   0,  5,  0,$35,  0
			dc.b   0,  5,  8,$35,$10
			even
byte_20DB98:	dc.b 12
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
loc_20DBD6:
			lea	word_20DC28(pc),a1
			moveq	#0,d0
			moveq	#0,d1
			move.w	(dword_FFF700).w,d0
loc_20DBE2:
			cmp.w	(a1)+,d0
			bcs.s	loc_20DBEA
			addq.b	#2,d1
			bra.s	loc_20DBE2
; ---------------------------------------------------------------------------
loc_20DBEA:
			move.b	d1,(word_FF12F4).l
			move.w	word_20DC40(pc,d1.w),d0
			jmp	(sub_20202E).l

; =============== S U B R O U T I N E =======================================
sub_20DBFA:
			lea	word_20DC28(pc),a1
			moveq	#0,d0
			moveq	#0,d1
			move.w	(dword_FFF700).w,d0
loc_20DC06:
			cmp.w	(a1)+,d0
			bcs.s	loc_20DC0E
			addq.b	#2,d1
			bra.s	loc_20DC06
; ---------------------------------------------------------------------------
loc_20DC0E:
			cmp.b	(word_FF12F4).l,d1
			bne.s	loc_20DC18
			rts
; ---------------------------------------------------------------------------
loc_20DC18:
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
sub_20DC4C:
			lea	(off_20DC6E).l,a1
			add.w	d0,d0
			move.w	off_20DC6E(pc,d0.w),d4
			lea	off_20DC6E(pc,d4.w),a2
			moveq	#0,d1
			move.b	obj.field_29(a0),d1
			add.w	d1,d1
			move.w	(a2,d1.w),d5
			move.w	d5,obj.vram(a0)
			rts
; End of function sub_20DC4C
; ---------------------------------------------------------------------------
off_20DC6E: dc.w word_20DC92-off_20DC6E
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
word_20DC92:	dc.w $23E7
word_20DC94:	dc.w $24DC
word_20DC96:	dc.w $245F
word_20DC98:	dc.w $2431
word_20DC9A:	dc.w $23E7
word_20DC9C:	dc.w $4363
word_20DC9E:	dc.w $33A
word_20DCA0:	dc.w $342
word_20DCA2:	dc.w $431E
word_20DCA4:	dc.w $4495
word_20DCA6:	dc.w $375
word_20DCA8:	dc.w $326
word_20DCAA:	dc.w $8357
word_20DCAC:	dc.w $475
word_20DCAE:	dc.w $384
word_20DCB0:	dc.w $3A1
word_20DCB2:	dc.w $422
word_20DCB4:	dc.w 0
; ---------------------------------------------------------------------------
obj24:
			moveq	#0,d0
			move.b	obj.subtype(a0),d0
			add.w	d0,d0
			move.w	off_20DCCC(pc,d0.w),d0
			jsr	off_20DCCC(pc,d0.w)
			jmp	(loc_206FB8).l
; ---------------------------------------------------------------------------
off_20DCCC:
			dc.w loc_20DCD0-off_20DCCC
			dc.w loc_20DDCA-off_20DCCC
; ---------------------------------------------------------------------------
loc_20DCD0:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20DCDE(pc,d0.w),d0
			jmp	off_20DCDE(pc,d0.w)
; ---------------------------------------------------------------------------
off_20DCDE:
			dc.w loc_20DCE4-off_20DCDE
			dc.w loc_20DD22-off_20DCDE
			dc.w loc_20DD72-off_20DCDE
; ---------------------------------------------------------------------------
loc_20DCE4:
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#8,obj.width(a0)
			move.b	#8,obj.height(a0)
			move.w	#$3CF,obj.vram(a0)
			move.l	#obj24_map,obj.mappings(a0)
			move.l	obj.xpos(a0),obj.field_2A(a0)
			move.l	obj.ypos(a0),obj.field_2E(a0)
			move.b	#1,obj.field_32(a0)
			rts
; ---------------------------------------------------------------------------
loc_20DD22:
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
loc_20DD58:
			lea	(obj24_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20DD6C:
			addq.b	#2,obj.routine(a0)
			bra.s	loc_20DD58
; ---------------------------------------------------------------------------
loc_20DD72:
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
loc_20DDAC:
			addi.b	#-2,obj.routine(a0)
			bra.s	loc_20DD58
; ---------------------------------------------------------------------------
obj24_ani:
			dc.w unk_20DDB6-obj24_ani
unk_20DDB6: dc.b $13
			dc.b   0
			dc.b   1
			dc.b $FF
			even
obj24_map:
			dc.w byte_20DDBE-obj24_map
			dc.w byte_20DDC4-obj24_map
byte_20DDBE:	dc.b 1
			dc.b $F8,  5,  0,  0,$F8
			even
byte_20DDC4:	dc.b 1
			dc.b $F8,  5,  0,  4,$F8
			even
; ---------------------------------------------------------------------------
loc_20DDCA:
			moveq	#0,d0
			move.b	obj.routine(a0),d0
			move.w	off_20DDD8(pc,d0.w),d0
			jmp	off_20DDD8(pc,d0.w)
; ---------------------------------------------------------------------------
off_20DDD8:
			dc.w loc_20DDDE-off_20DDD8
			dc.w loc_20DE12-off_20DDD8
			dc.w loc_20DE6E-off_20DDD8
; ---------------------------------------------------------------------------
loc_20DDDE:
			addq.b	#2,obj.routine(a0)
			move.b	#4,obj.render(a0)
			move.b	#1,obj.priority(a0)
			move.b	#8,obj.width(a0)
			move.b	#8,obj.height(a0)
			move.w	#$3CF,obj.vram(a0)
			move.l	#obj24b_map,obj.mappings(a0)
			move.l	#$FFFC0000,obj.field_2A(a0)
			rts
; ---------------------------------------------------------------------------
loc_20DE12:
			move.w	#$3CF,obj.vram(a0)
			addi.l	#$10000,obj.xpos(a0)
			move.l	obj.field_2A(a0),d0
			add.l	d0,obj.ypos(a0)
			move.b	#0,obj.ani(a0)
			addi.l	#$2000,obj.field_2A(a0)
			bmi.w	loc_20DE40
			move.b	#1,obj.ani(a0)
loc_20DE40:
			jsr	(sub_20611C).l
			tst.w	d1
			bmi.w	loc_20DE60
loc_20DE4C:
			lea	(obj24b_ani).l,a1
			jsr	(animateobj).l
			jmp	(displaysprite).l
; ---------------------------------------------------------------------------
			rts
; ---------------------------------------------------------------------------
loc_20DE60:
			addq.b	#2,obj.routine(a0)
			move.l	#$FFFC0000,obj.field_2A(a0)
			bra.s	loc_20DE4C
; ---------------------------------------------------------------------------
loc_20DE6E:
			move.w	#$BCF,obj.vram(a0)
			addi.l	#$FFFF0000,obj.xpos(a0)
			move.l	obj.field_2A(a0),d0
			add.l	d0,obj.ypos(a0)
			move.b	#0,obj.ani(a0)
			addi.l	#$2000,obj.field_2A(a0)
			bmi.w	loc_20DE9C
			move.b	#1,obj.ani(a0)
loc_20DE9C:
			jsr	(sub_20611C).l
			tst.w	d1
			bmi.w	loc_20DEAA
			bra.s	loc_20DE4C
; ---------------------------------------------------------------------------
loc_20DEAA:
			addi.b	#-2,obj.routine(a0)
			move.l	#$FFFC0000,obj.field_2A(a0)
			bra.s	loc_20DE4C
; ---------------------------------------------------------------------------
obj24b_ani:
			dc.w unk_20DEBE-obj24b_ani
			dc.w unk_20DEC2-obj24b_ani
unk_20DEBE:
			dc.b $13
			dc.b   1
			dc.b $FF
			even
unk_20DEC2:
			dc.b $13
			dc.b   0
			dc.b $FF
			even
obj24b_map:
			dc.w byte_20DECA-obj24b_map
			dc.w byte_20DED0-obj24b_map
byte_20DECA:
			dc.b 1
			dc.b $F8,  9,  0,  8,$F4
			even
byte_20DED0:
			dc.b 1
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
			dc.w musid_GHZ
			dc.b palid_spz,palid_spz
			even

ddev_ptr	macro
\1_ptr:	dc.w \1-divdev_index
	endm

ddev_header	macro
	dc.w (\1)/6-1
	endm

ddev_entry	macro
	dc.l \1
	dc.w \2<<5
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
			ddev_header ddev_00_end-ddev_00
			ddev_entry spz_8x8,0
ddev_00_end:

ddev_01:
			ddev_header ddev_01_end-ddev_01
			ddev_entry cg_rock,$326
			ddev_entry cg_spikes,$33A
			ddev_entry cg_pole,$342
			ddev_entry cg_flipper,$357
			ddev_entry cg_platform,$363
			ddev_entry cg_spinplatform,$375
			ddev_entry cg_wheels,$384
			ddev_entry cg_dspring,$3A1
			ddev_entry cg_spring,$520
			ddev_entry cg_hud,$568
			ddev_entry cg_monitortimesign,$5A8
			ddev_entry cg_explosion,$680
			ddev_entry cg_flowers,$6D6
			ddev_entry cg_ring,$7AE
ddev_01_end:

ddev_02:
			ddev_header ddev_02_end-ddev_02
			ddev_entry cg_bridge,$31E
			ddev_entry cg_flickyricky,$3CF
			ddev_entry cg_mosqui,$3E7
			ddev_entry cg_tagataga,$431
			ddev_entry cg_anton,$45F
			ddev_entry cg_splash2,$475
			ddev_entry cg_patabata,$4DC
ddev_02_end:

ddev_04:
			ddev_header ddev_04_end-ddev_04
			ddev_entry cg_mosqui,$3E7
			ddev_entry cg_tagataga,$431
ddev_04_end:

ddev_05:
			ddev_header ddev_05_end-ddev_05
			ddev_entry cg_bridge,$31E
			ddev_entry cg_tamabboh,$3E7
			ddev_entry cg_anton,$45F
			ddev_entry cg_splash2,$475
ddev_05_end:

ddev_06:
			ddev_header ddev_06_end-ddev_06
			ddev_entry cg_splash,$422
			ddev_entry cg_card,$495
ddev_06_end:

ddev_07:
			ddev_header ddev_07_end-ddev_07
			ddev_entry cg_tamabboh,$3E7
			ddev_entry cg_splash,$422
ddev_07_end:

ddev_08:
			ddev_header ddev_08_end-ddev_08
			ddev_entry cg_bridge,$31E
			ddev_entry cg_flickyricky,$3CF
			ddev_entry cg_mosqui,$3E7
			ddev_entry cg_tagataga,$431
			ddev_entry cg_anton,$45F
			ddev_entry cg_signpost,$503
ddev_08_end:

ddev_09:
			ddev_header ddev_09_end-ddev_09
			ddev_entry cg_signpost,$503
ddev_09_end:

ddev_0A:
			ddev_header ddev_0A_end-ddev_0A
			ddev_entry cg_bridge,$31E
			ddev_entry cg_rock,$326
			ddev_entry cg_spikes,$33A
			ddev_entry cg_pole,$342
			ddev_entry cg_flipper,$357
			ddev_entry cg_platform,$363
			ddev_entry cg_spinplatform,$375
			ddev_entry cg_wheels,$384
			ddev_entry cg_dspring,$3A1
			ddev_entry cg_flickyricky,$3CF
			ddev_entry cg_mosqui,$3E7
			ddev_entry cg_tagataga,$431
			ddev_entry cg_anton,$45F
			ddev_entry cg_splash2,$475
			ddev_entry cg_patabata,$4DC
ddev_0A_end:

ddev_0B:
			ddev_header ddev_0B_end-ddev_0B
			ddev_entry cg_bridge,$31E
			ddev_entry cg_rock,$326
			ddev_entry cg_spikes,$33A
			ddev_entry cg_pole,$342
			ddev_entry cg_flipper,$357
			ddev_entry cg_platform,$363
			ddev_entry cg_spinplatform,$375
			ddev_entry cg_wheels,$384
			ddev_entry cg_dspring,$3A1
			ddev_entry cg_flickyricky,$3CF
			ddev_entry cg_tamabboh,$3E7
			ddev_entry cg_anton,$45F
			ddev_entry cg_splash2,$475
			ddev_entry cg_patabata,$4DC
ddev_0B_end:

ddev_0C:
ddev_0D:
			ddev_header ddev_0C_end-ddev_0C
			ddev_entry cg_rock,$326
			ddev_entry cg_spikes,$33A
			ddev_entry cg_pole,$342
			ddev_entry cg_flipper,$357
			ddev_entry cg_platform,$363
			ddev_entry cg_spinplatform,$375
			ddev_entry cg_wheels,$384
			ddev_entry cg_dspring,$3A1
			ddev_entry cg_flickyricky,$3CF
			ddev_entry cg_tamabboh,$3E7
			ddev_entry cg_splash,$422
			ddev_entry cg_card,$495
			ddev_entry cg_patabata,$4DC
ddev_0C_end:

ddev_0E:
			ddev_header ddev_0E_end-ddev_0E
			ddev_entry cg_bridge,$31E
			ddev_entry cg_rock,$326
			ddev_entry cg_spikes,$33A
			ddev_entry cg_pole,$342
			ddev_entry cg_flipper,$357
			ddev_entry cg_platform,$363
			ddev_entry cg_spinplatform,$375
			ddev_entry cg_wheels,$384
			ddev_entry cg_dspring,$3A1
			ddev_entry cg_flickyricky,$3CF
			ddev_entry cg_mosqui,$3E7
			ddev_entry cg_tagataga,$431
			ddev_entry cg_anton,$45F
			ddev_entry cg_patabata,$4DC
ddev_0E_end:

ddev_0F:
			ddev_header ddev_0F_end-ddev_0F
			ddev_entry cg_bridge,$31E
			ddev_entry cg_rock,$326
			ddev_entry cg_spikes,$33A
			ddev_entry cg_pole,$342
			ddev_entry cg_flipper,$357
			ddev_entry cg_platform,$363
			ddev_entry cg_spinplatform,$375
			ddev_entry cg_wheels,$384
			ddev_entry cg_dspring,$3A1
			ddev_entry cg_mosqui,$3E7
			ddev_entry cg_tagataga,$431
			ddev_entry cg_anton,$45F
			ddev_entry cg_patabata,$4DC
			ddev_entry cg_signpost,$503
ddev_0F_end:

; unused
			ddev_entry cg_dspring,$33F
			ddev_entry cg_wheels,$36D
			ddev_entry cg_flipper,$375
			ddev_entry cg_platform,$381
			ddev_entry cg_spinplatform,$393
			ddev_entry cg_rock,$3A2
			ddev_entry cg_flickyricky,$3B6
			ddev_entry cg_anton,$3CE
			ddev_entry cg_mosqui,$3E4
			ddev_entry cg_patabata,$42E
			ddev_entry cg_tamabboh,$462

ddev_unused_0:
			ddev_header ddev_unused_0_end-ddev_unused_0
			ddev_entry cg_spikes,$31E
			ddev_entry cg_pole,$32A
			ddev_entry cg_dspring,$33F
			ddev_entry cg_wheels,$36D
			ddev_entry cg_flipper,$375
			ddev_entry cg_platform,$381
			ddev_entry cg_spinplatform,$393
			ddev_entry cg_rock,$3A2
			ddev_entry cg_flickyricky,$3B6
			ddev_entry cg_anton,$3CE
			ddev_entry cg_mosqui,$3E4
			ddev_entry cg_splash,$469
ddev_unused_0_end:

ddev_unused_1:
			ddev_header ddev_unused_1_end-ddev_unused_1
			ddev_entry cg_spikes,$31E
			ddev_entry cg_pole,$32A
			ddev_entry cg_dspring,$33F
			ddev_entry cg_wheels,$36D
			ddev_entry cg_flipper,$375
			ddev_entry cg_platform,$381
			ddev_entry cg_spinplatform,$393
			ddev_entry cg_rock,$3A2
			ddev_entry cg_flickyricky,$3B6
			ddev_entry cg_anton,$3CE
			ddev_entry cg_mosqui,$3E4
			ddev_entry cg_patabata,$42E
			ddev_entry cg_tamabboh,$462
ddev_unused_1_end:

ddev_unused_2:
			ddev_header ddev_unused_2_end-ddev_unused_2
			ddev_entry cg_spikes,$31E
			ddev_entry cg_pole,$32A
			ddev_entry cg_dspring,$33F
			ddev_entry cg_wheels,$36D
			ddev_entry cg_flipper,$375
			ddev_entry cg_platform,$381
			ddev_entry cg_spinplatform,$393
			ddev_entry cg_rock,$3A2
			ddev_entry cg_anton,$3CE
			ddev_entry cg_mosqui,$3E4
			ddev_entry cg_patabata,$42E
			ddev_entry cg_tamabboh,$462
ddev_unused_2_end:

			incbin	"Leftovers/R11A__.MMD"
			even

chunkwk:
			incbin	"Leftovers/Chunks.unc"
			even

			align	$210000+chunksize*$6C

			incbin	"Unknown/Unk1.unc"
			even

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

cg_shield:
			incbin	"Art/Uncompressed/Shield.unc"
			even

cg_stars:
			incbin	"Art/Uncompressed/Invincibility Stars.unc"
			even

cg_timetravel:
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

cg_platform:
			incbin	"Art/Nemesis/Appearing Platform.nem"
			even

cg_wheels:
			incbin	"Art/Nemesis/Wheels.nem"
			even

cg_spinplatform:
			incbin	"Art/Nemesis/Spinning Platform.nem"
			even

cg_splash:
			incbin	"Art/Nemesis/Splash.nem"
			even

cg_flipper:
			incbin	"Art/Nemesis/Flipper.nem"
			even

cg_splash2:
			incbin	"Art/Nemesis/Splash 2.nem"
			even

cg_mosqui:
			incbin	"Art/Nemesis/Mosqui.nem"
			even

cg_patabata:
			incbin	"Art/Nemesis/Pata-Bata.nem"
			even

cg_anton:
			incbin	"Art/Nemesis/Anton.nem"
			even

cg_tagataga:
			incbin	"Art/Nemesis/Taga-Taga.nem"
			even

cg_tamabboh:
			incbin	"Art/Nemesis/Tamabboh.nem"
			even

cg_pole:
			incbin	"Art/Nemesis/Elastic Pole.nem"
			even

cg_card:
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
			dc.w spz_fg-lvllayout_index, spz_bg-lvllayout_index, spz_z-lvllayout_index
			dc.w ghz2_fg-lvllayout_index, unk_237140-lvllayout_index, unk_23701A-lvllayout_index
			dc.w ghz3_fg-lvllayout_index, unk_237140-lvllayout_index, unk_237140-lvllayout_index
			dc.w unk_237144-lvllayout_index, unk_237144-lvllayout_index, unk_237144-lvllayout_index
			dc.w spz_fg-lvllayout_index, spz_bg-lvllayout_index, spz_z-lvllayout_index
			dc.w ghz2_fg-lvllayout_index, unk_237140-lvllayout_index, unk_23701A-lvllayout_index
			dc.w ghz3_fg-lvllayout_index, unk_237140-lvllayout_index, unk_237140-lvllayout_index
			dc.w unk_237144-lvllayout_index, unk_237144-lvllayout_index, unk_237144-lvllayout_index
			dc.w spz_fg-lvllayout_index, spz_bg-lvllayout_index, spz_z-lvllayout_index
			dc.w ghz2_fg-lvllayout_index, unk_237140-lvllayout_index, unk_23701A-lvllayout_index
			dc.w ghz3_fg-lvllayout_index, unk_237140-lvllayout_index, unk_237140-lvllayout_index
			dc.w unk_237144-lvllayout_index, unk_237144-lvllayout_index, unk_237144-lvllayout_index

spz_fg:
			incbin	"Layout/Foreground.bin"
			even
spz_bg:
			incbin	"Layout/Background.bin"
			even
spz_z:
			dc.l 0
ghz2_fg:
			incbin	"Layout/GHZ2 Foreground (Sonic 1).bin"
			even
unk_23701A:
			dc.l 0
ghz3_fg:
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