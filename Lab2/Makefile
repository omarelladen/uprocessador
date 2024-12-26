all:
	ghdl -a src/*.vhd
	ghdl -a tb/tb.vhd
	ghdl -e ULA
	ghdl -e mux16
	ghdl -e tb
	ghdl -r tb --wave=tb.ghw
	gtkwave tb.ghw

clean:
	rm -f *.o *.cf tb.ghw
