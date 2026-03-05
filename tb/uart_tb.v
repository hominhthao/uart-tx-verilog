`timescale 1ns/1ps

module uart_tb;

reg clk;
reg start;
reg [7:0] data;

wire tx;
wire busy;

uart_tx uut(
    .clk(clk),
    .start(start),
    .data(data),
    .tx(tx),
    .busy(busy)
);

// clock generator
always #5 clk = ~clk;

initial begin

    clk = 0;
    start = 0;
    data = 8'h41; // ASCII 'A'

    #20
    start = 1;

    #10
    start = 0;

    #300
    $finish;

end

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);
end

endmodule
