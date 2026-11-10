;	STARTER.BIN $4DCA-$4DDD (runtime $260CA-$260DD).
;
;	The SendCommandToMain name tag after filmcmd.asm.


	org	$260CA

	dc.b	$91,'SendCommandToMain',0,0
