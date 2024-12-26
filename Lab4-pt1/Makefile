all:
	ghdl -a src/*.vhd

	ghdl -a tb/tb.vhd

	ghdl -e ROM
	ghdl -e UC
	ghdl -e reg6bits
	ghdl -e main
	
	ghdl -r tb --wave=tb.ghw
	gtkwave tb.ghw

clean:
	rm -f *.o *.cf tb.ghw
