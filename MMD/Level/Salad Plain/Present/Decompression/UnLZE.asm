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