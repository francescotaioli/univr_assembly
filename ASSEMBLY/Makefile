OUT     = progetto2
AS      = as
LD      = ld
ASFLAGS = -gstabs
SOURCES = $(wildcard *.s)
OBJ     = $(SOURCES:.s=.o)

$(OUT): $(OBJ)
	$(LD) $(OBJ) -o $(OUT)
%.o : %.s
	$(AS) $(ASFLAGS) $< -o $@

cleanall: clean
	rm -f $(wildcard *~)

clean:
	rm -f $(OBJ) $(OUT)

