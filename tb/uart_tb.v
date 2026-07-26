`timescale 1ns / 1ps

module uart_tb;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;

    wire [7:0] rx_data;
    wire rx_done;
    wire tx;
    wire tx_busy;
    uart_top uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .tx(tx),
        .tx_busy(tx_busy)
    );
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst      = 1;
        tx_start = 0;
        tx_data  = 8'h00;

        #200;    
        rst = 0;
        send_byte(8'b10110111);
        wait(rx_done);
        $display("TC1 Sent     = %b", 8'b10110111);
        $display("TC1 Received = %b", rx_data);
        #2000000; // 2 ms
        send_byte(8'b00000000);
        wait(rx_done);
        $display("TC2 Sent     = %b", 8'b00000000);
        $display("TC2 Received = %b", rx_data);
        #2000000; // 2 ms
        send_byte(8'b11111111);
        wait(rx_done);
        $display("TC3 Sent     = %b", 8'b11111111);
        $display("TC3 Received = %b", rx_data);

        // Finish
        #1000000;
        $finish;
    end
    task send_byte(input [7:0] data);
    begin
        tx_data  = data;
        tx_start = 1;
        #40;             // keep start high for 2 cycles
        tx_start = 0;
    end
    endtask

endmodule
