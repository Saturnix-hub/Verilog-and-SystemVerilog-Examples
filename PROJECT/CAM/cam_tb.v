`timescale 1ns/1ps

module cam_tb;

    parameter DATA_WIDTH = 8;
    parameter DEPTH      = 16;
    parameter ADDR_WIDTH = 4;

    reg clk;
    reg rst_n;

    reg wr_en;
    reg [ADDR_WIDTH-1:0] wr_addr;
    reg [DATA_WIDTH-1:0] wr_data;

    reg del_en;
    reg [ADDR_WIDTH-1:0] del_addr;

    reg search_en;
    reg [DATA_WIDTH-1:0] search_data;

    wire match;
    wire [ADDR_WIDTH-1:0] match_addr;
    wire multiple_match;
    integer i;


    cam #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),

        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),

        .del_en(del_en),
        .del_addr(del_addr),

        .search_en(search_en),
        .search_data(search_data),

        .match(match),
        .match_addr(match_addr),
        .multiple_match(multiple_match)
    );


    initial begin		// CLK
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_cam;
    begin
        rst_n      = 0;
        wr_en      = 0;
        del_en     = 0;
        search_en  = 0;
        wr_addr    = 0;
        wr_data    = 0;
        del_addr   = 0;
        search_data= 0;

        repeat(2) @(posedge clk);

        rst_n = 1;

        @(posedge clk);
    end
    endtask


    task write_cam;

        input [ADDR_WIDTH-1:0] addr;
        input [DATA_WIDTH-1:0] data;

    begin

        @(posedge clk);

        wr_en   = 1;
        wr_addr = addr;
        wr_data = data;

        @(posedge clk);

	@(posedge clk);

        wr_en   = 0;

    end
    endtask

    task delete_cam;

        input [ADDR_WIDTH-1:0] addr;

    begin

        @(posedge clk);

        del_en   = 1;
        del_addr = addr;

        @(posedge clk);

	@(posedge clk);

        del_en   = 0;

    end
    endtask

    task search_cam;

        input [DATA_WIDTH-1:0] data;

    begin

        @(posedge clk);

        search_en   = 1;
        search_data = data;

        @(posedge clk);

    end
    endtask

    task check_result;
        input exp_match;
        input [ADDR_WIDTH-1:0] exp_addr;
        input exp_multi;

    begin
        #1; 

        if(match!==exp_match)
            $display("[FAIL] Match Expected=%0d Got=%0d",
                     exp_match,match);
        else if(match_addr!==exp_addr)
            $display("[FAIL] Address Expected=%0d Got=%0d",
                     exp_addr,match_addr);
        else if(multiple_match!==exp_multi)
            $display("[FAIL] Multi Expected=%0d Got=%0d",
                     exp_multi,multiple_match);
        else
            $display("[PASS] Match=%0d Addr=%0d Multi=%0d",
                     match,match_addr,multiple_match);
    end
    endtask

    initial begin

        $display("");
        $display("========================================");
        $display("      CAM VERIFICATION STARTED");
        $display("========================================");

        // Test 1 : Reset

        $display("");
        $display("[TEST 1] RESET\n");

        reset_cam();

        if(match==0 && multiple_match==0)
            $display("[PASS] Reset Successful");
        else
            $display("[FAIL] Reset Failed");

        // Test 2 : Single Write/Search

        $display("");
        $display("[TEST 2] SINGLE WRITE / SEARCH\n");

        write_cam(4,8'h55);

        search_cam(8'h55);

        check_result(1,4,0);
	@(negedge clk);
	search_en = 0;

        // Test 3 : Search Miss

        $display("");
        $display("[TEST 3] SEARCH MISS\n");

        search_cam(8'hAA);

        check_result(0,0,0);

	@(negedge clk);
	search_en = 0;

        // Test 4 : Delete Entry

        $display("");
        $display("[TEST 4] DELETE ENTRY\n");

        delete_cam(4);

        search_cam(8'h55);

        check_result(0,0,0);
	@(negedge clk);
	search_en = 0;
	
        // Test 5 : Overwrite Existing Entry

        $display("");
        $display("[TEST 5] OVERWRITE ENTRY\n");

        write_cam(6, 8'h11);
        search_cam(8'h11);
        check_result(1, 6, 0);

	@(negedge clk);
	search_en = 0;
	

        write_cam(6, 8'h77);
        search_cam(8'h77);
        check_result(1, 6, 0);

	@(negedge clk);
	search_en = 0;
	

        search_cam(8'h11);
        check_result(0, 0, 0);

	@(negedge clk);
	search_en = 0;
	
        // Test 6 : Multiple Match Detection

        $display("");
        $display("[TEST 6] MULTIPLE MATCH\n");

        write_cam(2, 8'hAA);
        write_cam(9, 8'hAA);

        search_cam(8'hAA);

        check_result(1, 2, 1);
	@(negedge clk);
	search_en = 0;
	
        // Test 7 : Boundary Addresses

        $display("");
        $display("[TEST 7] BOUNDARY ADDRESS\n");

        write_cam(0, 8'h10);
        write_cam(15, 8'hF0);

        search_cam(8'h10);
        check_result(1, 0, 0);

	@(negedge clk);
	search_en = 0;
	

        search_cam(8'hF0);
        check_result(1, 15, 0);

	@(negedge clk);
	search_en = 0;
	
        // Test 8 : Fill Entire CAM

        $display("");
        $display("[TEST 8] FILL COMPLETE CAM\n");
	
        for(i=0; i<DEPTH; i=i+1)
        begin
            write_cam(i[ADDR_WIDTH-1:0], i + 8'h20);
        end

        for(i=0; i<DEPTH; i=i+1)
        begin
            search_cam(i + 8'h20);
            check_result(1, i[ADDR_WIDTH-1:0], 0);

	@(negedge clk);
	search_en = 0;


        end

        // Test 9 : Delete Multiple Entries

        $display("");
        $display("[TEST 9] DELETE MULTIPLE\n");

        delete_cam(5);
        delete_cam(10);

        search_cam(8'h25);
        check_result(0, 0, 0);

	@(negedge clk);
	search_en = 0;


        search_cam(8'h2A);
        check_result(0, 0, 0);

	@(negedge clk);
	search_en = 0;

        // Test 10 : Search Invalid Data

        $display("");
        $display("[TEST 10] INVALID SEARCH\n");

        search_cam(8'hFF);
        check_result(0, 0, 0);

	@(negedge clk);
	search_en = 0;


        $display("");
        $display("========================================");
        $display("     CAM VERIFICATION COMPLETED");
        $display("========================================");

        #20;
        $finish;
    end

endmodule
