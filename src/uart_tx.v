module uart_tx(
    input clk,
    input start,
    input [7:0] data,
    output reg tx,
    output reg busy
);

// FSM states
parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;
reg [2:0] bit_index;
reg [7:0] shift_reg;

// initialization (for simulation)
initial begin
    state = IDLE;
    bit_index = 0;
    shift_reg = 0;
    tx = 1;      // idle line = 1
    busy = 0;
end

always @(posedge clk) begin

    case(state)

        // ---------------- IDLE ----------------
        IDLE: begin
            tx <= 1;
            busy <= 0;

            if(start) begin
                shift_reg <= data;
                bit_index <= 0;
                busy <= 1;
                state <= START;
            end
        end

        // ---------------- START BIT ----------------
        START: begin
            tx <= 0;      // start bit
            state <= DATA;
        end

        // ---------------- DATA BITS ----------------
        DATA: begin
            tx <= shift_reg[bit_index];  // send LSB first
            bit_index <= bit_index + 1;

            if(bit_index == 7)
                state <= STOP;
        end

        // ---------------- STOP BIT ----------------
        STOP: begin
            tx <= 1;      // stop bit
            state <= IDLE;
        end

    endcase

end

endmodule
