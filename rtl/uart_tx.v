`timescale 1ns / 1ps
module uart_tx (
    input        clk,
    input        rst,
    input        tx_start,
    input  [7:0] tx_data,
    output reg   tx,
    output reg   tx_busy
);
reg [1:0]  state;
reg [12:0] baud_counter;
reg [3:0]  bit_counter;
reg [7:0]  shift_reg;

parameter CLK_FREQ  = 50000000;
parameter BAUD_RATE = 9600;

localparam BAUD_DIV = CLK_FREQ / BAUD_RATE;

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state        <= IDLE;
        tx           <= 1'b1;
        tx_busy      <= 1'b0;
        baud_counter <= 13'd0;
        bit_counter  <= 4'd0;
        shift_reg    <= 8'd0;
    end
    else
    begin
        case(state)

            IDLE:
            begin
                tx <= 1'b1;
                tx_busy <= 1'b0;
                baud_counter <= 13'd0;
                bit_counter <= 4'd0;

                if(tx_start)
                begin
                    tx_busy <= 1'b1;
                    shift_reg <= tx_data;
                    state <= START;
                end
            end

            START:
            begin
                tx <= 1'b0;

                if(baud_counter < BAUD_DIV - 1)
                begin
                    baud_counter <= baud_counter + 1;
                end
                else
                begin
                    baud_counter <= 0;
                    state <= DATA;
                end
            end

            DATA:
            begin
                tx <= shift_reg[0];

                if(baud_counter < BAUD_DIV - 1)
                begin
                    baud_counter <= baud_counter + 1;
                end
                else
                begin
                    baud_counter <= 0;
                    shift_reg <= shift_reg >> 1;

                    if(bit_counter < 7)
                    begin
                        bit_counter <= bit_counter + 1;
                    end
                    else
                    begin
                        bit_counter <= 0;
                        state <= STOP;
                    end
                end
            end

            STOP:
            begin
                tx <= 1'b1;

                if(baud_counter < BAUD_DIV - 1)
                begin
                    baud_counter <= baud_counter + 1;
                end
                else
                begin
                    baud_counter <= 0;
                    tx_busy <= 1'b0;
                    state <= IDLE;
                end
            end

            default:
            begin
                state <= IDLE;
            end

        endcase
    end
end
endmodule