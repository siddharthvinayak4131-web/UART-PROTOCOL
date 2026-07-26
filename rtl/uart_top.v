module uart_top #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input        clk,
    input        rst,
    input        tx_start,
    input  [7:0] tx_data,

    output [7:0] rx_data,
    output       rx_done,
    output       tx,
    output       tx_busy
);

wire serial_line;

uart_tx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
)
tx_inst (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

assign serial_line = tx;

uart_rx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
)
rx_inst (
    .clk(clk),
    .rst(rst),
    .rx(serial_line),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

endmodule