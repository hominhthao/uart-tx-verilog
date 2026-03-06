SIM=uart_sim
SRC=src/uart_tx.v
TB=tb/uart_tx_tb.v

.PHONY: sim wave clean

sim:
	iverilog -o $(SIM) $(SRC) $(TB)
	vvp $(SIM)

wave:
	gtkwave uart_tx.vcd

clean:
	rm -f $(SIM) *.vcd
