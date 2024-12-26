all:
	ghdl -a src/*.vhd

	ghdl -a tb/tb.vhd

	ghdl -e ROM
	ghdl -e UC
	ghdl -e reg12bits
	ghdl -e reg19bits
	ghdl -e reg16bits
	ghdl -e registerFile
	ghdl -e ULA
	ghdl -e mux16
	ghdl -e main
	
	ghdl -r tb --wave=tb.ghw
	gtkwave tb.ghw

	rm -f *.o *.cf tb.ghw
