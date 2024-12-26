all:
	ghdl -a src/*.vhd
	ghdl -a tb/tb.vhd
	ghdl -e ULA
	ghdl -e mux16
	ghdl -e reg16bits
	ghdl -e registerFile
	ghdl -e main
	ghdl -e tb
	ghdl -r tb --wave=tb.ghw
	gtkwave tb.ghw

clean:
	rm -f *.o *.cf tb.ghw
