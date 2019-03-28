PLATFORM = TI84p
BINDIR = kosenv/build/bin
AS = $(BINDIR)/scas
EMU = $(BINDIR)/z80e-sdl
MKTIUPGRADE = $(BINDIR)/mktiupgrade
MKROM = $(BINDIR)/mkrom
ROMLEN = 0x100000

SOURCES = main.S
INCLUDES = const.S interrupt.S keyboard.S

.PHONY: all
all: tiseg7.rom

tiseg7.bin: $(SOURCES) $(INCLUDES)
	$(AS) $< $@

tiseg7.rom: tiseg7.bin
	$(MKROM) $@ $(ROMLEN) $<:0x0000

.PHONY: run
run: tiseg7.rom
	$(EMU) -d $(PLATFORM) --no-rom-check $<

tiseg7.8xu: tiseg7.rom
	$(MKTIUPGRADE) -p -k kosenv/kernel/keys/0A.key -d TI-84+ $< $@ 00

.PHONY: send
send: tiseg7.8xu
	tilp -n --calc ti84+ --cable DirectLink $<
