`timescale 1ns/1ps

module async_fifo_tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    reg clk_wr;
    reg clk_rd;
    reg rst_n;

    reg wr_en;
    reg rd_en;

    reg  [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;

    wire full;
    wire empty;

    //-------------------------------------------------
    // DUT
    //-------------------------------------------------

    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk_wr(clk_wr),
        .clk_rd(clk_rd),
        .rst_n(rst_n),

        .wr_en(wr_en),
        .rd_en(rd_en),

        .data_in(data_in),
        .data_out(data_out),

        .full(full),
        .empty(empty)
    );

    //-------------------------------------------------
    // Write Clock
    //-------------------------------------------------

    initial begin
        clk_wr = 0;
        forever #5 clk_wr = ~clk_wr;
    end

    //-------------------------------------------------
    // Read Clock
    //-------------------------------------------------

    initial begin
        clk_rd = 0;
        forever #8 clk_rd = ~clk_rd;
    end

    //-------------------------------------------------
    // Stimulus
    //-------------------------------------------------

    initial begin

        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 0;

        //---------------------------------
        // Reset
        //---------------------------------

        #20;
        rst_n = 1;

        $display("Reset Released");
        $display("empty=%0d full=%0d",empty,full);

        //---------------------------------
        // Write AA
        //---------------------------------

        @(posedge clk_wr);

        wr_en   = 1;
        data_in = 8'hAA;

        @(posedge clk_wr);

        wr_en = 0;

        //---------------------------------
        // Write 55
        //---------------------------------

        @(posedge clk_wr);

        wr_en   = 1;
        data_in = 8'h55;

        @(posedge clk_wr);

        wr_en = 0;

        //---------------------------------
        // Write F0
        //---------------------------------

        @(posedge clk_wr);

        wr_en   = 1;
        data_in = 8'hF0;

        @(posedge clk_wr);

        wr_en = 0;
	#1;
        $display("Three Writes Completed");

        //---------------------------------
        // Wait for Synchronizers
        //---------------------------------

        repeat(4) @(posedge clk_rd);

        //---------------------------------
        // Read AA
        //---------------------------------

        rd_en = 1;

        @(posedge clk_rd);
	#1;
        $display("Read = %h",data_out);

        //---------------------------------
        // Read 55
        //---------------------------------

        @(posedge clk_rd);
	#1;
        $display("Read = %h",data_out);

        //---------------------------------
        // Read F0
        //---------------------------------

        @(posedge clk_rd);
	#1;
        $display("Read = %h",data_out);

        rd_en = 0;

        //---------------------------------
        // Wait
        //---------------------------------

        repeat(4) @(posedge clk_rd);
	#1;
        $display("empty=%0d full=%0d",
                 empty,full);

        //---------------------------------
        // Finish
        //---------------------------------

        #50;

        $display("====================");
        $display("ASYNC FIFO PASSED");
        $display("====================");

        $finish;

    end

endmodule
