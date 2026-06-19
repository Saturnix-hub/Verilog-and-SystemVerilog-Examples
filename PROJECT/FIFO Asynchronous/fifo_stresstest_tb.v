
`timescale 1ns/1ps

module fifo_stresstest_tb;

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

    async_fifo #(      //DUT
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

    initial begin     // Write clock
        clk_wr = 0;
        forever #5 clk_wr = ~clk_wr;
    end

    initial begin     // Read clock 
        clk_rd = 0;
        forever #8 clk_rd = ~clk_rd;
    end

    initial begin

        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 0;

        #20;          // Reset Deactivate
        rst_n = 1;

        $display("Reset Released");
        $display("empty=%0d full=%0d",empty,full);

        // Write AA
	@(posedge clk_wr);

        wr_en   = 1;
        data_in = 8'hAA;

        @(posedge clk_wr);

        wr_en = 0;

        // Write 55
        @(posedge clk_wr);

        wr_en   = 1;
        data_in = 8'h55;

        @(posedge clk_wr);

        wr_en = 0;

        // Write F0
        @(posedge clk_wr);

        wr_en   = 1;
        data_in = 8'hF0;

        @(posedge clk_wr);

        wr_en = 0;
	#1;
        $display("Three Writes Completed");

        repeat(4) @(posedge clk_rd);     // Wait Synchronizers

        // Read AA
        rd_en = 1;

        @(posedge clk_rd);
	#1;
        $display("Read = %h",data_out);

        // Read 55
        @(posedge clk_rd);
	#1;
        $display("Read = %h",data_out);


        // Read FF
        @(posedge clk_rd);
	#1;
        $display("Read = %h",data_out);

        rd_en = 0;


        repeat(4) @(posedge clk_rd);   // Wait
	#1;
        $display("empty=%0d full=%0d",
                 empty,full);

        // Finish


$display("\n---- FILL FIFO ----");

repeat(16)
begin
    @(posedge clk_wr);
    wr_en   = 1;
    data_in = data_in + 1;
end

@(posedge clk_wr);
wr_en = 0;

repeat(4) @(posedge clk_wr);

$display("FULL=%0d EMPTY=%0d", full, empty);


        #50;

        $display("====================");
        $display("ASYNC FIFO PASSED");
        $display("====================");

        $finish;

    end

endmodule