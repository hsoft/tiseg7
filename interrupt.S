handleInterrupt:
	di
	push	af

	; did we push the ON button?
	in	a, (PORT_INT_TRIG)
	bit	INT_TRIG_ON, a
	jp	z, .done		; no? we're done

	; yes? acknowledge and boot
	in a, (PORT_INT_MASK)
	res INT_MASK_ON, a		; acknowledge interrupt
	out (PORT_INT_MASK), a

	pop	af
	ei
	jp	main
	
.done:
	pop	af
	ei
	reti

