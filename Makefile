PLATFORM = TI84p
BINDIR = kosenv/build/bin
AS = $(BINDIR)/scas
EMU = $(BINDIR)/z80e-sdl
MKTIUPGRADE = $(BINDIR)/mktiupgrade
MKROM = $(BINDIR)/mkrom
ROMLEN = 0x100000

SOURCES = main.S

.PHONY: all
all: tihello.rom

tihello.bin: $(SOURCES)
	$(AS) $< $@

tihello.rom: tihello.bin
	$(MKROM) $@ $(ROMLEN) $<:0x0000

.PHONY: run
run: tihello.rom
	$(EMU) -d $(PLATFORM) --no-rom-check $<

tihello.8xu: tihello.rom
	$(MKTIUPGRADE) -p -k kosenv/kernel/keys/0A.key -d TI-84+ $< $@ 00

.PHONY: send
send: tihello.8xu
	tilp -n --calc ti84+ --cable DirectLink $<
