;	The Manual Goalie pause-menu item. New in 94.

ManualGoalieMenu					;"x Manual Goalie" menu item (menu lists; PrintMenuItem prints Manual /
									;Auto Goalie from the same words): with OptNOP set, toggle the goalie mode
									;of the pause pad (goaliemode2 for pad 2, sflags bit 1, else goaliemode1;
									;both when the pads are on one team). In a penalty shot or shootout
									;(gmode2 bit 0, BA_PS_flags bit 2) the pad then takes player 0 / 6 or 5 /
									;$B by its mode, when BA_Sktr_SCnum is on its side (setc1player /
									;setc2player)
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).w				;goalie option set?
	beq.w	.chkso					;no goalie option: switch only
	move.w	(cont1team).w,d0
	cmp.w	(cont2team).w,d0		;same team?
	bne.w	.0						;pads on different teams
	eori.w	#1,(goaliemode2).w		;toggle pad 2's goalie mode
	bra.w	.g1						;same team: pad 1 too
.0									;d0 <> cont2team
	btst	#sfpj,(sflags).w		;which pad paused?
	beq.w	.g1						;pad 1 paused
	eori.w	#1,(goaliemode2).w		;toggle pad 2's goalie mode
	bra.w	.chkso
.g1									;pad 1's goalie mode
	eori.w	#1,(goaliemode1).w		;toggle pad 1's goalie mode
.chkso								;shootout or penalty shot?
	btst	#0,(gmode2).w			;shootout?
	bne.w	.so
	btst	#2,(BA_PS_flags).w		;penalty shot?
	beq.w	.x
.so									;shootout or penalty shot: switch the pad's player
	btst	#sfpj,(sflags).w		;which pad paused?
	bne.w	.p2						;pad 2 paused
	cmpi.w	#2,(OptNOP).w			;OptNOP 2?
	bne.w	.4
	cmpi.w	#5,(BA_Sktr_SCnum).w	;visiting shooter?
	bgt.w	.x						;skater on the other side
	bra.w	.5
.4									;OptNOP <> 2
	cmpi.w	#5,(BA_Sktr_SCnum).w	;home shooter?
	ble.w	.x						;skater on the other side
.5									;pad 1: goalie or skater
	move.w	#0,d0					;goalie slot 0
	cmpi.w	#2,(OptNOP).w
	bne.w	.6						;not OptNOP 2
	move.w	#6,d0					;OptNOP 2: slot 6
.6									;goalie slot chosen
	tst.w	(goaliemode1).w			;goalie mode of pad 1
	bne.w	.set1					;manual: the goalie
	move.w	#5,d0					;skater slot 5
	cmpi.w	#2,(OptNOP).w
	bne.w	.set1
	move.w	#$B,d0					;OptNOP 2: skater slot $B
.set1								;set pad 1's player
	jsr	(setc1player).l
	bra.w	.x
.p2									;sfpj set
	cmpi.w	#2,(OptNOP).w			;OptNOP 2?
	bne.w	.9
	cmpi.w	#5,(BA_Sktr_SCnum).w	;home shooter?
	ble.w	.x						;skater on the other side
	bra.w	.10
.9									;OptNOP <> 2
	cmpi.w	#5,(BA_Sktr_SCnum).w	;visiting shooter?
	bgt.w	.x						;skater on the other side
.10									;pad 2: goalie or skater
	move.w	#6,d0					;goalie slot 6
	tst.w	(goaliemode2).w			;goalie mode of pad 2
	bne.w	.set2					;manual: the goalie
	move.w	#$B,d0					;skater slot
.set2								;set pad 2's player
	jsr	(setc2player).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
