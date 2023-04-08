all: rom.bin

rom.bin: xaa.bin xab.bin xac.bin xad.bin xae.bin xaf.bin xag.bin xah.bin
	mkdir -p $$PWD/out ; \
	for i in out/x*.bin; do dd if=$$i of=$$i-pad bs=256 conv=sync status=none; done; \
	cat out/x*.bin-pad > out/rom.bin; \
	rm -f out/x*.bin out/x*.bin-pad out/*.o

xaa.o: xaa.s
	ca65 --target apple2 --list-bytes 0 -DOPT0 -o out/$@ $<

xab.o: passthrough.s
	ca65 --target apple2 --list-bytes 0 -DOPT1 -o out/$@ $<

xac.o: smart.s
	ca65 --target apple2 --list-bytes 0 -DOPT2 -o out/$@ $<

xad.o: smart.s
	ca65 --target apple2 --list-bytes 0 -DOPT3 -DW_BUSY -o out/$@ $<

xae.o: smart.s
	ca65 --target apple2 --list-bytes 0 -DOPT4 -o out/$@ $<

xaf.o: passthrough.s
	ca65 --target apple2 --list-bytes 0 -DNO_STRIP -o out/$@ $<

xag.o: smart.s
	ca65 --target apple2 --list-bytes 0 -DOPTA -DTYPER -o out/$@ $<

xah.o: smart.s
	ca65 --target apple2 --list-bytes 0 -DTYPER -DW_BUSY -o out/$@ $<

%.o: %.s
	ca65 --target apple2 --list-bytes 0 -o out/$@ $<

%.bin: %.o
	ld65 --config apple2-asm.cfg -o out/$@ out/$<

clean:
	rm -f out/*.o out/*.bin out/*.bin-pad
