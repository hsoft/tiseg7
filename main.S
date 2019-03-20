; tiseg7
;

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

	; Set link "tip" and reset "ring"
	in	a, (PORT_LINK)
	set	LINK_TIP, a
	res	LINK_RING, a
	out	(PORT_LINK), a

	call	waitForKey

	; Do the opposite
	in	a, (PORT_LINK)
	res	LINK_TIP, a
	set	LINK_RING, a
	out	(PORT_LINK), a

	jr	boot

#include "keyboard.S"
#include "interrupt.S"
