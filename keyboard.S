; This routine waits for a key to be pressed, but before that, it waits for
; all keys to be de-pressed. It does that to ensure that two calls to
; waitForKey only go through after two actual key presses (otherwise, the user
; doesn't have enough time to de-press the button before the next waitForKey
; routine registers the same key press as a second one).
; 
; Sending 0xff to the port resets the keyboard, and then we have to send groups
; we want to "listen" to, with a 0 in the group bit. Thus, to know if *any* key
; is pressed, we send 0xff to reset the keypad, then 0x00 to select all groups,
; if the result isn't 0xff, at least one key is pressed.
waitForKey:
	push	af

; loop until all keys are de-pressed
.loop1:
	ld	a, 0xff
	out	(PORT_KEYBOARD), a
	ld	a, 0x00
	out	(PORT_KEYBOARD), a
	in	a, (PORT_KEYBOARD)
	inc	a		; if a was 0xff, will become 0 (nz test)
	jr	nz, .loop1	; non-zero? something is pressed

; loop until a key is pressed
.loop2:
	ld	a, 0xff
	out	(PORT_KEYBOARD), a
	ld	a, 0x00
	out	(PORT_KEYBOARD), a
	in	a, (PORT_KEYBOARD)
	inc	a		; if a was 0xff, will become 0 (z test)
	jr	z, .loop2	; zero? nothing pressed

	pop	af
	ret

	
