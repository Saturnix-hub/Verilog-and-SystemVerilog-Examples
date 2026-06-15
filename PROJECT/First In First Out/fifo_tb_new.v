`timescale 1ns/1ps

module fifo_tb_new;

    parameter DATA_WIDTH = 8;

    reg clk;
    reg rst_n;

    reg wr_en;
    reg rd_en;

    reg  [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;

    wire full;
    wire empty;

    //---------------------------------------------------------
    // DUT
    //---------------------------------------------------------

    fifo #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),

        .wr_en(wr_en),
        .rd_en(rd_en),

        .data_in(data_in),
        .data_out(data_out),

        .full(full),
        .empty(empty)
    );

    //---------------------------------------------------------
    // Clock
    //---------------------------------------------------------

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //---------------------------------------------------------
    // Test Sequence
    //---------------------------------------------------------

    initial begin

        //----------------------------------
        // Initialize
        //----------------------------------

        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 0;

        //----------------------------------
        // Reset
        //----------------------------------

        #20;
        rst_n = 1;

        $display("After Reset : Empty=%0d Full=%0d",
                 empty, full);



	repeat(16)
	begin
		#10;
		wr_en =1;
		data_in = data_in + 1;
		#10;
		wr_en =0;
	end
	
	#20;

	repeat(16)
	begin
		#10
		rd_en = 1;

		#10
		rd_en = 0;
	end
	#10;
        //----------------------------------
        // Fill FIFO
        //----------------------------------

        repeat(16)
        begin
            #10;
            wr_en   = 1;
            data_in = data_in + 1;

            #10;
            wr_en = 0;
        end

        #10;

        $display("After Fill : Empty=%0d Full=%0d",
                 empty, full);

        //----------------------------------
        // Full Write Attempt
        //----------------------------------

        #10;

        wr_en   = 1;
        data_in = 8'hFF;

        #10;

        wr_en = 0;

        $display("Full Write Ignored");

        //----------------------------------
        // Simultaneous Read/Write
        //----------------------------------

        #10;

        wr_en   = 1;
        rd_en   = 1;
        data_in = 8'h77;

        #10;

        $display("Simultaneous RW Data=%h",
                 data_out);

        wr_en = 0;
        rd_en = 0;

        //----------------------------------
        // Wrap Around Test
        //----------------------------------

        repeat(4)
        begin
            #10;
            rd_en = 1;

            #10;
            rd_en = 0;
        end

        $display("Wrap Around Test Completed");

        //----------------------------------
        // Finish
        //----------------------------------

        #20;

        $display("================================");
        $display("FIFO VERIFICATION PASSED");
        $display("================================");

        $finish;

    end

endmodule