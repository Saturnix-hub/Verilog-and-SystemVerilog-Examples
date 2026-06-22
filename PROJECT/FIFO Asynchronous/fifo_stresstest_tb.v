
`timescale 1ns / 1ps

module fifo_stresstest_tb;

  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 4;

  reg clk_wr;
  reg clk_rd;
  reg rst_n;

  reg wr_en;
  reg rd_en;

  reg [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;

  wire full;
  wire empty;

  async_fifo #(  //DUT
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
      .clk_wr(clk_wr),
      .clk_rd(clk_rd),
      .rst_n (rst_n),

      .wr_en(wr_en),
      .rd_en(rd_en),

      .data_in (data_in),
      .data_out(data_out),

      .full (full),
      .empty(empty)
  );

  initial begin  // Write clock
    clk_wr = 0;
    forever #5 clk_wr = ~clk_wr;
  end

  initial begin  // Read clock 
    clk_rd = 0;
    forever #8 clk_rd = ~clk_rd;
  end

  initial begin

    rst_n   = 0;
    wr_en   = 0;
    rd_en   = 0;
    data_in = 0;

    #20;  // Reset Deactivate
    rst_n = 1;

    $display("Reset Released");
    $display("empty=%0d full=%0d", empty, full);

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

    repeat (4) @(posedge clk_rd);  // Wait Synchronizers

    // Read AA
    rd_en = 1;

    @(posedge clk_rd);
    #1;
    $display("Read = %h", data_out);

    // Read 55
    @(posedge clk_rd);
    #1;
    $display("Read = %h", data_out);


    // Read FF
    @(posedge clk_rd);
    #1;
    $display("Read = %h", data_out);

    rd_en = 0;


    repeat (4) @(posedge clk_rd);  // Wait
    #1;
    $display("empty=%0d full=%0d", empty, full);


    // Alternate Write / Read Test

    $display("\n---- WRITE READ ALTERNATE TEST ----");

    // Write 11
    @(posedge clk_wr);
    wr_en   = 1;
    data_in = 8'h11;

    @(posedge clk_wr);
    wr_en = 0;

    repeat (3) @(posedge clk_rd);

    @(posedge clk_rd);
    rd_en = 1;

    @(posedge clk_rd);
    #1;
    $display("DATA=%h", data_out);

    rd_en = 0;


    // Write 22
    @(posedge clk_wr);
    wr_en   = 1;
    data_in = 8'h22;

    @(posedge clk_wr);
    wr_en = 0;

    repeat (3) @(posedge clk_rd);

    @(posedge clk_rd);
    rd_en = 1;

    @(posedge clk_rd);
    #1;
    $display("DATA=%h", data_out);

    rd_en = 0;


    // Write 33
    @(posedge clk_wr);
    wr_en   = 1;
    data_in = 8'h33;

    @(posedge clk_wr);
    wr_en = 0;

    repeat (3) @(posedge clk_rd);

    @(posedge clk_rd);
    rd_en = 1;

    @(posedge clk_rd);
    #1;
    $display("DATA=%h", data_out);

    rd_en = 0;

    repeat (4) @(posedge clk_rd);

    $display("FULL=%0d EMPTY=%0d", full, empty);

    // Finish

    #10;
    rst_n = 0;
    #5;
    rst_n = 1;
    #5;

    // Fill FIFO

    $display("\n---- FILL FIFO ----");

    repeat (16) begin
      @(posedge clk_wr);
      wr_en   = 1;
      data_in = data_in + 1;
    end

    @(posedge clk_wr);
    wr_en = 0;

    repeat (4) @(posedge clk_wr);

	/*
	$display("wr_bin   = %b", dut.wr_ptr_bin);        // Use to know the pointer values.
	$display("wr_gray  = %b", dut.wr_ptr_gray);
	$display("rd_sync  = %b", dut.rd_ptr_gray_sync2);

	$display("expected = %b",
	{
	    ~dut.rd_ptr_gray_sync2[4:3],
	     dut.rd_ptr_gray_sync2[2:0]
	});
	*/

    $display("FULL=%0d EMPTY=%0d", full, empty);

    //  Write when FIFO is Full

    $display("\n---- WRITE WHEN FULL ----");

    @(posedge clk_wr);
    wr_en   = 1;
    data_in = 8'hFF;

    @(posedge clk_wr);
    wr_en = 0;

    repeat (2) @(posedge clk_wr);

    $display("FULL=%0d EMPTY=%0d", full, empty);


    // Read Entire FIFO

    $display("\n---- READ ALL DATA ----");

    repeat (16) begin

      //@(posedge clk_rd);
      rd_en = 1;

      @(posedge clk_rd);
      #1;
      $display("DATA=%h", data_out);
    end

    rd_en = 0;

    //#10;

    // Check empty

    repeat (4) @(posedge clk_rd);

    $display("FULL=%0d EMPTY=%0d", full, empty);

    // Try to Read when Empty

    $display("\n---- READ WHEN EMPTY ----");

    @(posedge clk_rd);
    rd_en = 1;

    @(posedge clk_rd);
    rd_en = 0;

    repeat (2) @(posedge clk_rd);

    $display("FULL=%0d EMPTY=%0d", full, empty);

    // Wrap Around Test

    $display("\n---- WRAP AROUND TEST ----");

    repeat (8) begin
      @(posedge clk_wr);
      wr_en   = 1;
      data_in = $random;
    end

    @(posedge clk_wr);
    wr_en = 0;

    repeat (8) begin
      //@(posedge clk_rd);
      rd_en = 1;

      @(posedge clk_rd);
      #1;
      $display("WRAP DATA=%h", data_out);
    end

    rd_en = 0;

    // Finish Stress Test 

    repeat (4) @(posedge clk_rd);

    $display("--------------------------------");
    $display("ASYNC FIFO STRESS TEST PASSED");
    $display("--------------------------------");

    $finish;

  end


  always @(posedge clk_wr) begin
    if (wr_en) $display("WRITE accepted @ %0t ptr=%0d data=%h", $time, dut.wr_ptr_bin, data_in);
  end
endmodule
