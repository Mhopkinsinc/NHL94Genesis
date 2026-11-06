;	Small high-ROM helpers packed before the title screen: sflags8 bit 1,
;	attribute adjust, unused puck test, goalie-pulled, EndOneTimer. New in 94.
;	ROM-contiguous from SetSflags8Bit1 through EndOneTimer.

SetSflags8Bit1						;Always sets sflags8 bit 1 (the bclr is skipped).
									;Called from updateplayers
	bra.w	.set					;(the bclr below is always skipped)
	bclr	#1,(sflags8).w
	bra.w	.ex
.set								;set bit 1 of sflags8
	bset	#1,(sflags8).w			;set bit 1 of sflags8
.ex									;exit (also the end of the code above)
	rts
AttribAdjust						;An attribute under $32 becomes d0 / 2 + $19. Called from AttribRating,
									;PrintOverallRating and PrintMatchupRatings
	cmp.w	#$32,d0					;compare $32 to d0
	bge.w	.exit					;branch if greater than
	asr.w	#1,d0
	addi.w	#$19,d0					;add $19 (25 dec)
.exit								;exit (also the end of the code above)
	rts
PuckComingToward					;nothing calls it. Z clear when the puck is within $1E of player a3 and
									;moving toward him (x, then y); d0-d1 kept
	movem.w	d0-d1,-(sp)
	move.w	(puckx).w,d0
	sub.w	(a3),d0					;minus the player X
	cmp.w	#$1E,d0					;puck more than $1E ahead in X: no
	bgt.w	.x
	move.w	(puckvx).w,d1
	eor.w	d1,d0					;sign of dx against the puck's X speed
	andi.w	#$8000,d0
	beq.w	.x						;same sign: moving away
	move.w	(pucky).w,d0
	sub.w	Ypos(a3),d0				;minus the player Y
	cmp.w	#$1E,d0					;puck more than $1E ahead in Y: no
	bgt.w	.x
	move.w	(puckvy).w,d1
	eor.w	d1,d0					;sign of dy against the Y speed (Z clear = toward him)
	andi.w	#$8000,d0
.x									;(Z holds the answer)
	movem.w	(sp)+,d0-d1
	rts
ReadGoaliePulled					;Z clear when the team of a3 pulled its goalie ($26 of the team struct).
									;Called from doshot assdefo, asspuckc and assnearest
	movem.l	a1,-(sp)
	movea.l	#tmstruct,a1
	btst	#pfteam,pflags(a3)		;check if home or away 0=home 1=away
	beq.w	.chkgoalie
	movea.l	#awtmstruct,a1
.chkgoalie							;team chosen: tmgoalie 0 = goalie in (Z set)
	tst.w	tmgoalie(a1)
	movem.l	(sp)+,a1
	rts
EndOneTimer							;End a one-timer for a3: bits cleared, onetimerplayer = -1, SetSPA
									;SPAglide, then assexit (goalie) or Setplass. Called from assonetimer and
									;checkgoal (.setass)
	movem.l	d0/a0,-(sp)
	bclr	#pf3onetimer,pflags3(a3)
	bclr	#pfalock,pflags(a3)		;clear the a lock
	bclr	#pf2aip,pflags2(a3)		;clear the AI flag
	clr.w	(onetimerflags).w		;clear the one-timer flags
	st	(onetimerplayer).w
	move.w	d1,-(sp)
	move.w	#SPAglide,d1
	jsr	(SetSPA).l
	tst.w	position(a3)			;a goalie: back to his goalie logic
	bpl.w	.0
	jsr	(assexit).l					;a skater: normal assignment
	bra.w	.1
.0									;skater: give him a new assignment
	jsr	(Setplass).l
.1									;both: restart the animation
	clr.w	SPAnum(a3)				;first frame
	st	SPAcnt(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts
