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