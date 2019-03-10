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

; Consts

PORT_INT_MASK		.equ	0x03
INT_MASK_ON		.equ	0x00

PORT_INT_TRIG		.equ	0x04
INT_TRIG_ON		.equ	0x00

PORT_LCD_CMD		.equ	0x10
LCD_CMD_ENABLE		.equ	0x03
LCD_CMD_COL		.equ	0x20
LCD_CMD_ROW		.equ	0x80
LCD_CMD_CONTRAST	.equ	0xc0

PORT_LCD_DATA		.equ	0x11

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
	call	lcdFill
.loop:
	jr	.loop

; Wait until the lcd is ready to receive a command
lcdWait:
	push	af
.loop:
	in	a, (PORT_LCD_CMD)
	; When 7th bit is cleared, we can send a new command
	rla
	jr	c, .loop
	pop	af
	ret

lcdInit:
	; Enable the LCD
	ld	a, LCD_CMD_ENABLE
	call	lcdWait
	out	(PORT_LCD_CMD), a

	; Hack to get LCD to work. According to WikiTI, we're to sure why TIOS
	; sends these, but it sends it, and it is required to make the LCD
	; work. So...
	ld	a, 0x17
	call	lcdWait
	out	(PORT_LCD_CMD), a
	ld	a, 0x0b
	call	lcdWait
	out	(PORT_LCD_CMD), a

	; Set some usable contrast
	ld	a, LCD_CMD_CONTRAST + 0x34
	call	lcdWait
	out	(PORT_LCD_CMD), a
	ret

lcdFill:
	; place our "RAM cursor" at pos (0, 0)
	ld	a, LCD_CMD_COL + 0
	call	lcdWait
	out	(PORT_LCD_CMD), a
	ld	a, LCD_CMD_ROW + 0
	call	lcdWait
	out	(PORT_LCD_CMD), a

	; fill all 8 pixels at that pos
	ld	a, 0xff
	call	lcdWait
	out	(PORT_LCD_DATA), a
	ret

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
