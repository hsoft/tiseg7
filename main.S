; tiseg7
;
; This program is designed to send a signal to my 7-segments multiplexer
; through custom, hacked cable of my own "design" (it wasn't really designed,
; it was hacked together). At first, I wanted the link cable to supply the
; multiplexer in power through the use of diodes and clever "always keep a pin
; up" scheme, but it turns out that you can't draw much power from the link.
;
; Therefore, the multiplexer is externally powered. In my cable, TIP is INCLK
; on the multiplexer and RING is INSER.

#include "const.S"

; Header

	jp	boot

.fill 0x18-$
	jp	boot		; reboot

.fill 0x38-$
	jp	handleInterrupt

.fill 0x53-$
	jp boot
; 0x0056
.db 0xFF, 0xA5, 0xFF

.fill 0x64-$
; Code
boot:
	di

	; enable ON key interrupt
	in a, (PORT_INT_MASK)
	set INT_MASK_ON, a
	out (PORT_INT_MASK), a

	im	1		; we need to be in interrupt mode 1
	ei

	; sleep until we press ON
	halt

main:
	; Disable link assist
	; We need to do that to control tip and ring directly
	in	a, (PORT_LINK_ASSIST)
	set	LINK_ASSIST_DISABLE, a
	out	(PORT_LINK_ASSIST), a

	call	waitForKey

	ld	a, 0
	set	LINK_RING, a

	call	clock
	call	delay50us
	call	delay50us
	call	delay50us
	call	delay50us

	ld	hl, DIGIT_TO_SEND
	ld	a, 4
	ld	(hl), a
	call	senddigit

	ld	a, 8
	ld	(hl), a
	call	senddigit

	ld	a, 2
	ld	(hl), a
	call	senddigit

	ld	a, 1
	ld	(hl), a
	call	senddigit

	ld	a, 15
	ld	(hl), a
	call	senddigit
	
	call	waitForKey
	jr	boot

; Send the 5 rightmost bits of (HL) in the link
senddigit:
	; In the operations below, we use general bit arithmetics. However,
	; when clocking that data, we need to invert the bit because a set
	; LINK_RING bit makes the ring line *low*. Because of that, we XOR
	; our value.
	ld	a, (hl)
	xor	0x1f
	ld	(hl), a

	; Let's start with the 5th bit. We want it to be on the 2nd position
	; (LINK_RING = 0x01). A is already loaded from xor above.
	rra
	rra
	rra
	; Alright! Now, let's clock!
	call	clock

	; Now for the 4th bit
	ld	a, (hl)
	rra
	rra
	call	clock

	; 3rd
	ld	a, (hl)
	rra
	call	clock

	; 2nd is easy :)
	ld	a, (hl)
	call	clock

	; and last
	ld	a, (hl)
	rla
	call	clock

	ret

; clock TIP up, then down so that we send the bit currently in RING down.
clock:
	set	LINK_TIP, a
	out	(PORT_LINK), a	; INCLK low
	call	delay50us
	res	LINK_TIP, a
	out	(PORT_LINK), a	; INCLK high
	call	delay50us
	ret

; at 15mhz, we need 750 cycles to delay by 50us. Each DJNZ unmet call is 13
; cycles, so we need to loop 57 times.
delay50us:
	ld	b, 0x39;
.loop:
	nop
	nop
	djnz	.loop
	ret

#include "keyboard.S"
#include "interrupt.S"
