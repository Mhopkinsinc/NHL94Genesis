;	HOCKEY.BIN $10614-$10B1D (runtime $2B614-$2BB1D): hockey94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 1 of hockey94 (parts 2 and 3 are hockey94_2.asm and hockey94_3.asm). StartGame, the period
;	start and the clock are the cartridge code. CD: VBjsr and Begin (the cold start) are not here (the game
;	starts at file $7096); BIOS calls ($5F22, $6044) and the sub CPU flag ($FF800F bit 5) replace the
;	interrupt masking around screen setups.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

LoadCrowdRec	equ	$22E38
Create_HotCold_Table	equ	$2308E
ChooseSong	equ	$2A478
DoGameFrame	equ	$2BB8E
PeriodOver_sp	equ	$35A94
assreplace	equ	$362E4
randomd0	equ	$37050
ReadJoy1	equ	$374F0
InitSaveRAM	equ	$37598
InitScores	equ	$3CB50
setupice	equ	$3E91C
clearTeamStats	equ	$3F11E
p_turnoff	equ	$47DAC

	org	$2B614

Begin						;CD: its first lines have no twin; the rest of it starts here
	jsr	(InitSaveRAM).l
;CD: no cartridge twin
	move.w	#$D,d7
	jsr	$6044.w
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$60,d0
	jsr	$6044.w
	move.l	a0,$47DA0.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$47DA0.l,a1
	lea	$223D6.l,a2
	lea	$222EA.l,a3
	move.w	#$8,d7
	jsr	$6044.w
	jsr	(InitSaveRAM).l
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$1,d0
	jsr	$6044.w
	move.l	a0,$47D60.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$47D60.l,a0
	move.l	a0,d0
	move.l	(a0)+,$47D3C.l
	add.l	d0,$47D3C.l
	move.l	(a0)+,$47D18.l
	add.l	d0,$47D18.l
	move.l	(a0)+,$47D40.l
	add.l	d0,$47D40.l
	move.l	(a0)+,$47D2C.l
	add.l	d0,$47D2C.l
	move.l	(a0)+,$47D38.l
	add.l	d0,$47D38.l
	move.l	(a0)+,$47D4C.l
	add.l	d0,$47D4C.l
	move.l	(a0)+,$47D34.l
	add.l	d0,$47D34.l
	move.l	(a0)+,$47D30.l
	add.l	d0,$47D30.l
	move.l	(a0)+,$47D1C.l
	add.l	d0,$47D1C.l
	move.l	(a0)+,$47D20.l
	add.l	d0,$47D20.l
	move.l	(a0)+,$47D44.l
	add.l	d0,$47D44.l
	move.l	(a0)+,$47D10.l
	add.l	d0,$47D10.l
	move.l	(a0)+,$47D58.l
	add.l	d0,$47D58.l
	move.l	(a0)+,$47D14.l
	add.l	d0,$47D14.l
	move.l	(a0)+,$47D28.l
	add.l	d0,$47D28.l
	move.l	(a0)+,$47D0C.l
	add.l	d0,$47D0C.l
	move.l	(a0)+,$47D64.l
	add.l	d0,$47D64.l
	move.l	(a0)+,$47D68.l
	add.l	d0,$47D68.l
	move.l	(a0)+,$47D6C.l
	add.l	d0,$47D6C.l
	move.l	(a0)+,$47D70.l
	add.l	d0,$47D70.l
	move.l	(a0)+,$47D80.l
	add.l	d0,$47D80.l
	move.l	(a0)+,$47D84.l
	add.l	d0,$47D84.l
	move.l	(a0)+,$47D98.l
	add.l	d0,$47D98.l
	move.l	(a0)+,$47D9C.l
	add.l	d0,$47D9C.l
	move.l	(a0)+,$47DA8.l
	add.l	d0,$47DA8.l
	lea	$2A9FA.l,a2
	move.w	(HomeTeam).l,d0
	asl.w	#$2,d0
	movea.l	(a2,d0.w),a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$47D90.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$2,d0
	jsr	$6044.w
	move.l	a0,$47D24.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.w	#$2,d0
	jsr	$5F22.w
	rts
	move.w	#$2,d0
	jsr	$5F22.w
	bclr.b	#$5,$FF800F.l

StartGame							;reset game state for a new game, then start the first period
	st.b	(arenaanim).l
	clr.l	(homepresses).l
	clr.l	(awaypresses).l
	clr.l	(homedirpresses).l
	clr.l	(awaydirpresses).l
;CD: no cartridge twin
	clr.w	$191CE.l
	jsr	(InitSaveRAM).l
	jsr	$376F2.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L2B850
	move.w	#$1,-(a6)
	bra.s	.L2B854
.L2B850
	move.w	#$0,-(a6)
.L2B854
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jsr	(Begin).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L2B880
	bset.b	#$5,$FF800F.l
	bra.s	.L2B888
.L2B880
	bclr.b	#$5,$FF800F.l
.L2B888
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jsr	$37752.l
	lea	$1746A.l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	#$2,d0
	jsr	$5F22.w
.L2B8AC
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.L2B8AC
.L2B8B8
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.s	.L2B8B8
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea	$19364.l,a0
	jsr	$5F22.w
	jsr	(ReadJoy1).l				;pad 1 = $E0 at game start forces 30 second periods
	cmpi.b	#$E0,d3
	bne.w	.chkpen
	move.w	#3,(Optperlen).l		;period length index 3 = 30 seconds
.chkpen	clr.b	(gmode).l			;clear the game mode
	cmpi.w	#1,(OptPen).l
	bne.w	.0
	bset.b	#gmoffs,(gmode).l		;gmoffs: offsides pen. is active
.0	cmpi.w	#1,(OptPlayMode).l		;OptPlayMode test (shot buffer)
	ble.w	.1						;OptPlayMode 0-1 keep the shot buffer
	bsr.w	ClearShotData
.1	jsr	(clearTeamStats).l			;reset team stats
	btst.b	#0,(gmode2).l
	beq.w	.noso
	move.l	a0,-(sp)
	movea.l	#tmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	#awtmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
.noso	clr.w	(ScoreSumbytes).l	;no shootout: clear the summaries
	clr.w	(PenSumLength).l
	clr.w	(gsp).l					;first period
	clr.w	(ChkCnt).l
	bsr.w	restoreteams
	jsr	(InitScores).l
	jsr	(setupice).l
	jsr	(LoadCrowdRec).l
	jmp	(PeriodOver_sp).l				;on to period start
;CD: no cartridge twin
ClearShotData						;CD: placed where the disc branches to it
	move.w	#$71,d0
	movea.l	#(outputbuffer-M68K_RAM),a0	;shot data buffer
.0	clr.w	(a0)+					;clear one word
	dbf	d0,.0
	rts

restoreteams						;Put both teams' rosters on the bench
	movea.l	#(tmstruct-M68K_RAM),a2	;team 1
	bsr.w	.r
	adda.w	#tmsize,a2				;team 2
.r									;reset one team struct (a2), falls in for team 2
	move.w	#6,tmap(a2)				;tmap: no players in pen. box
	moveq	#(maxros-1)*2,d0		;(maxros-1)*2
.0	move.w	#$FFFE,tmpdst(a2,d0.w)	;tmpdst: -2 = all players on bench
	subi.w	#2,d0
	bpl.w	.0
	rts

ResetClock							;set period length and stop clock
	bsr.w	GetPeriodTime			;d0 = period length in seconds
	cmpi.w	#3,(gsp).l				;overtime?
	blt.w	.0
	tst.w	(OptPlayMode).l
	bne.w	.0
	move.w	#$258,d0				;OptPlayMode 0 overtime is always 10:00
.0	move.w	d0,(gameclock).l		;set the clock
	move.w	d0,(PerTimeTotal).l
	move.w	d0,(periodendtime).l	;CheckLateGameSong trigger time =
	asr.w	#1,d0
	jsr	(randomd0).l
	sub.w	d0,(periodendtime).l	;length - random(length/2)
	bset.b	#gmclock,(gmode).l		;gmclock: stop clock
	rts

GetPeriodTime						;Return d0 = period length in seconds for the period length option
	move.w	(Optperlen).l,d0
	asl.w	#1,d0
	lea	.timetab(pc),a0
	move.w	(a0,d0.w),d0
	rts
.timetab							;Period length in seconds: 5, 10, 20 min, 30 sec
	dc.w	5*60,10*60,20*60,30
;CD: no cartridge twin
	bclr.b	#$5,$FF800F.l
	move.w	#$FFFF,(palcount).l
	move.w	#$8400,d1
	move.w	#$85,d0
	jsr	$5F22.w

StartPer							;start a period: reset stack, rink and clock, face off, run the game loop
	cmpi.w	#3,(gsp).l
	bne.w	.reg
	bset.b	#1,(sflags7).l			;overtime
.reg	st.b	(faceoffanim).l			;start the faceoff
	jsr	(p_turnoff).l				;sound off
	jsr	(setupice).l
	bsr.w	ResetClock
	ori.w	#$F000,(PadControlBits).l
	st.b	(c1playernum).l				;no controlled player yet
	st.b	(c2playernum).l
	movea.l	#(puckx-M68K_RAM),a3	;puck
	clr.w	(fox).l					;face off at center ice
	clr.w	(foy).l
	btst.b	#0,(gmode2).l
	beq.w	.fo
	move.w	#$1E,d0
	move.w	#8,(BA_Skater_Offset).l
	move.w	#$B,(BA_Goalie_SCnum).l
	bra.w	.ass
.fo	moveq	#$1B,d0					;pfaceoff
.ass	jsr	(assreplace).l			;face off starts period
	bset.b	#sf2drec,(sflags2).l	;sf2drec: don't record
	bclr.b	#sfwrap,(sflags).l		;sfwrap: reset replay stuff
	move.w	#$FFFF,(lastsfx).l
	move.l	#replaystart,(recbpr).l	;replaystart
	move.w	(Vcount).l,(OldVcount).l
	bsr.w	DoGameFrame				;run two frames before the loop
	move.w	#$FFFF,(palcount).l
	bsr.w	DoGameFrame
	move.w	(gamelevel).l,d0
	asl.w	#4,d0
	move.w	d0,(CwdExciteLvl).l		;starting excitement = gamelevel*16
	clr.w	(CurCrowdMeter).l
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#SngPeriodStart,(SongIndex).l
	jsr	(ChooseSong).l
