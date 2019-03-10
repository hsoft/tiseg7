; tihello
;
; This is an example of how to minimally display "Hello World" on a TI-84+.
; I went with a glyph size of 5x7 (6x8 with padding), which is what TIOS mostly
; displays.
; The screen being 95x63. that gives us a 16x8 screen, glyph-wise (the last
; line/col doesn't need a padding)

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

	; sleep until we press ON
	im	1		; we need to be in interrupt mode 1
	ei
	halt

main:
	call	lcdInit
	ld	a, 0
	call	lcdSetCol

	ld	hl, letterH
	call	lcdSendGlyph
	; no need to set col, it's been incremented already
	ld	hl, letterE
	call	lcdSendGlyph
	ld	hl, letterL
	call	lcdSendGlyph
	ld	hl, letterL
	call	lcdSendGlyph
	ld	hl, letterO
	call	lcdSendGlyph
	ld	hl, letterBlank
	call	lcdSendGlyph
	ld	hl, letterW
	call	lcdSendGlyph
	ld	hl, letterO
	call	lcdSendGlyph
	ld	hl, letterR
	call	lcdSendGlyph
	ld	hl, letterL
	call	lcdSendGlyph
	ld	hl, letterD
	call	lcdSendGlyph
	ld	hl, letterExclamation
	call	lcdSendGlyph
.loop:
	jr	.loop

#include "lcd.S"
#include "interrupt.S"

; Data
#include "letter.S"
