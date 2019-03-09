; boot
	jp boot

; interrupt
.fill 0x0038-$
	reti		; unused

; Consts

PORT_LCD_CMD		.equ	0x10
LCD_CMD_ENABLE		.equ	0x03
LCD_CMD_COL		.equ	0x20
LCD_CMD_ROW		.equ	0x80
LCD_CMD_CONTRAST	.equ	0xc0

PORT_LCD_DATA		.equ	0x11

.fill 0x0064-$
; Code
boot:
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
