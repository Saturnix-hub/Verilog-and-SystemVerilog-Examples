`timescale 1ns / 1ps

module rom_tb;

  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 8;
  parameter DEPTH = 256;

  reg                      clk;
  reg                      rst_n;
  reg                      cs;
  reg                      re;
  reg     [ADDR_WIDTH-1:0] addr;
  wire    [DATA_WIDTH-1:0] data;

  integer                  i;
  integer                  errors;

  rom #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH),
      .DEPTH(DEPTH)
  ) dut (
      .clk(clk),
      .rst_n(rst_n),
      .cs(cs),
      .re(re),
      .addr(addr),
      .data(data)
  );

  initial begin		// CLK
    clk = 0;
    forever #5 clk = ~clk;
  end

  task read_rom;	// Read Task

    input [ADDR_WIDTH-1:0] address;
    input [DATA_WIDTH-1:0] expected;

    begin

      @(negedge clk);
      cs   = 1;
      re   = 1;
      addr = address;

      @(posedge clk);
      #1;

      if (data === expected) $display("[PASS] Addr=%0d Data=%02h", address, data);
      else begin
        $display("[FAIL] Addr=%0d Expected=%02h Got=%02h", address, expected, data);
        errors = errors + 1;
      end

    end

  endtask

  initial begin

    errors = 0;

    rst_n = 0;
    cs    = 0;
    re    = 0;
    addr  = 0;

    $display("");
    $display("===========================================");
    $display("        ROM VERIFICATION STARTED");
    $display("===========================================");

    // TEST 1 : RESET

    @(posedge clk);
    rst_n = 1;

    @(posedge clk);

    if (data == 0) $display("[TEST 1] RESET                     PASS");
    else begin
      $display("[TEST 1] RESET                     FAIL");
      errors = errors + 1;
    end

    // TEST 2 : BASIC READS

    $display("");
    $display("[TEST 2] BASIC READS\n");

    read_rom(8'd0, 8'h00);
    read_rom(8'd1, 8'h01);
    read_rom(8'd20, 8'h14);
    read_rom(8'd50, 8'h32);
    read_rom(8'd100, 8'h64);
    read_rom(8'd255, 8'hFF);

    // TEST 3 : CHIP SELECT LOW

    $display("");
    $display("[TEST 3] CHIP SELECT \n");

    @(negedge clk);
    cs   = 0;
    re   = 1;
    addr = 8'd5;

    @(posedge clk);
    #1;

    if (data == 0) $display("[PASS] Output disabled.");
    else begin
      $display("[FAIL]");
      errors = errors + 1;
    end

    // TEST 4 : READ ENABLE LOW

    $display("");
    $display("[TEST 4] READ ENABLE LOW\n");

    @(negedge clk);
    cs   = 1;
    re   = 0;
    addr = 8'd10;

    @(posedge clk);
    #1;

    if (data == 0) $display("[PASS] Read disabled.");
    else begin
      $display("[FAIL]");
      errors = errors + 1;
    end

    // TEST 5 : SEQUENTIAL READ

    $display("");
    $display("[TEST 5] SEQUENTIAL READ (0-255)\n");

    for (i = 0; i < DEPTH; i = i + 1) read_rom(i, dut.rom[i]);

    // TEST 6 : RANDOM READ

    $display("");
    $display("[TEST 6] RANDOM READ\n");

    for (i = 0; i < 20; i = i + 1) begin
      addr = $urandom_range(0, DEPTH - 1);
      read_rom(addr, addr[7:0]);
    end

    $display("");
    $display("===========================================");

    if (errors == 0) $display("ALL TEST CASES PASSED");
    else $display("TOTAL FAILURES = %0d", errors);

    $display("===========================================");

    $finish;

  end

  initial begin		// Dump file 
    $dumpfile("rom.vcd");
    $dumpvars(0, rom_tb);
  end

endmodule
