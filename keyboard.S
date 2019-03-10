; Sending 0xff to the port resets the keyboard, and then we have to send groups
; we want to "listen" to, with a 0 in the group bit. Thus, to know if *any* key
; is pressed, we send 0xff to reset the keypad, then 0x00 to select all groups,
; if the result isn't 0xff, at least one key is pressed.
waitForKey:
	push	af

	ld	a, 0xff
	out	(PORT_KEYBOARD), a
	ld	a, 0x00
	out	(PORT_KEYBOARD), a

.loop:
	in	a, (PORT_KEYBOARD)
	inc	a		; if a was 0xff, will become 0 (z test)
	jr	z, .loop	; zero? nothing pressed

	pop	af
	ret

	
