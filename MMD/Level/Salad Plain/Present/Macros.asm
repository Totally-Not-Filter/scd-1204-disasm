DMA68K	macro	src,len,ram,type
	lea	(vdpctrl).l,a5
	move.l	#($9400+((len/2)&$FF00)>>8)<<16+$9300+(len/2)&$FF,(a5)
	move.l	#($9600+((src/2)&$FF00)>>8)<<16+$9500+(src/2)&$FF,(a5)
	move.w	#$9700+((src/2)&$7F0000)>>16,(a5)
	move.w	#ram<<12+(type&$3FFF),(a5)
	move.w	#$80+((type&$C000)>>14),(word_FFF640).w
	move.w	(word_FFF640).w,(a5)
	endm