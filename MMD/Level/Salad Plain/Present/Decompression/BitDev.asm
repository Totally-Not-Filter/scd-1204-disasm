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