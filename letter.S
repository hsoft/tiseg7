; Letters are sent in 6-bit mode. highest 2 bits are irrelevant. In addition
; to this, the first column is always empty, for padding. So, 5-bit wide glyphs.
letterBlank:
.db	0b00000
.db	0b00000
.db	0b00000
.db	0b00000
.db	0b00000
.db	0b00000
.db	0b00000

letterA:
.db	0b01110
.db	0b10001
.db	0b10001
.db	0b11111
.db	0b10001
.db	0b10001
.db	0b10001

letterD:
.db	0b11110
.db	0b10001
.db	0b10001
.db	0b10001
.db	0b10001
.db	0b10001
.db	0b11110

letterE:
.db	0b11111
.db	0b10000
.db	0b10000
.db	0b11100
.db	0b10000
.db	0b10000
.db	0b11111

letterH:
.db	0b10001
.db	0b10001
.db	0b10001
.db	0b11111
.db	0b10001
.db	0b10001
.db	0b10001

letterL:
.db	0b10000
.db	0b10000
.db	0b10000
.db	0b10000
.db	0b10000
.db	0b10000
.db	0b11111

letterO:
.db	0b01110
.db	0b10001
.db	0b10001
.db	0b10001
.db	0b10001
.db	0b10001
.db	0b01110

letterR:
.db	0b11110
.db	0b10001
.db	0b10001
.db	0b11110
.db	0b10001
.db	0b10001
.db	0b10001

letterW:
.db	0b10001
.db	0b10001
.db	0b10001
.db	0b10101
.db	0b10101
.db	0b10101
.db	0b01010

letterExclamation:
.db	0b00100
.db	0b01110
.db	0b01110
.db	0b01110
.db	0b00100
.db	0b00000
.db	0b00100

