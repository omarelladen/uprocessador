all:
	ghdl -a src/*.vhd

	ghdl -a tb/tb.vhd

	ghdl -e ROM
	ghdl -e RAM
	ghdl -e UC
	ghdl -e reg12bits
	ghdl -e reg1bit
	ghdl -e reg19bits
	ghdl -e reg16bits
	ghdl -e registerFile
	ghdl -e ULA
	ghdl -e main
	
	ghdl -r tb --wave=tb.ghw
	gtkwave tb.ghw

	rm -f *.o *.cf *.ghw
