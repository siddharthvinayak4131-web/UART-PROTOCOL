module uart_rx #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input        clk,
    input        rst,
    input        rx,
    output reg [7:0] rx_data,
    output reg       rx_done
);

localparam BAUD_DIV = CLK_FREQ / BAUD_RATE;

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0]  state;
reg [12:0] baud_counter;
reg [3:0]  bit_counter;
reg [7:0]  shift_reg;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state        <= IDLE;
        baud_counter <= 0;
        bit_counter  <= 0;
        shift_reg    <= 0;
        rx_data      <= 0;
        rx_done      <= 0;
    end
    else
    begin
        rx_done <= 1'b0;

        case(state)

            IDLE:
            begin
                baud_counter <= 0;
                bit_counter  <= 0;

                if(rx == 1'b0)
                begin
                    state <= START;
                end
            end

            START:
            begin
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
                if(baud_counter < BAUD_DIV - 1)
                begin
                    baud_counter <= baud_counter + 1;
                end
                else
                begin
                    baud_counter <= 0;

                    shift_reg[bit_counter] <= rx;

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
                if(baud_counter < BAUD_DIV - 1)
                begin
                    baud_counter <= baud_counter + 1;
                end
                else
                begin
                    baud_counter <= 0;

                    rx_data <= shift_reg;
                    rx_done <= 1'b1;

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