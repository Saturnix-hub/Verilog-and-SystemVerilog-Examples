`timescale 1ns/1ps

module sram_controller_tb01;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 12;

    // Cpu interface signals

    reg                       clk;
    reg                       rst;
    reg                       read_req;
    reg                       write_req;
    reg  [ADDR_WIDTH-1:0]     addr;
    reg  [DATA_WIDTH-1:0]     write_data;
    wire [DATA_WIDTH-1:0]     read_data;

    wire                      ready;
    wire                      busy;

    // SRAM Interface Signals

    wire                      cs;
    wire                      we;
    wire                      oe;

    wire [ADDR_WIDTH-1:0]     sram_addr;
    wire [DATA_WIDTH-1:0]     sram_din;
    wire [DATA_WIDTH-1:0]     sram_dout;

    // Verification Counters

    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    // SRAM Controller Instantiation
    sram_controller #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),

        .read_req(read_req),
        .write_req(write_req),

        .addr(addr),
        .write_data(write_data),

        .read_data(read_data),

        .ready(ready),
        .busy(busy),

        .cs(cs),
        .we(we),
        .oe(oe),

        .sram_addr(sram_addr),
        .sram_din(sram_din),
        .sram_dout(sram_dout)
    );

    // SRAM Instantiation
    sram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) mem (
        .clk(clk),

        .cs(cs),
        .we(we),
        .oe(oe),

        .addr(sram_addr),

        .din(sram_din),
        .dout(sram_dout)
    );

    //clk
    initial begin  
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        $display("");
        $display("======================================================");
        $display("          SRAM CONTROLLER VERIFICATION");
        $display("======================================================");
        $display("");

    end

task report_test;	// Report task

    input [200*8:1] test_name;
    input result;

begin

    total_tests = total_tests + 1;

    if(result)
    begin
        passed_tests = passed_tests + 1;
        $display("[TEST %0d] %-30s PASS",
                  total_tests,
                  test_name);
    end
    else
    begin
        failed_tests = failed_tests + 1;
        $display("[TEST %0d] %-30s FAIL",
                  total_tests,
                  test_name);
    end
end
endtask


task reset_dut;		// Reset DUT

begin

    rst        = 1;
    read_req   = 0;
    write_req  = 0;
    addr       = 0;
    write_data = 0;

    repeat(2) @(posedge clk);

    rst = 0;

    @(posedge clk);

    report_test("RESET",1);

end
endtask



task write_sram;	// Write SRAM

input [ADDR_WIDTH-1:0] address;
input [DATA_WIDTH-1:0] data;

begin

    @(posedge clk);

    addr       = address;
    write_data = data;
    write_req  = 1;

    @(posedge clk);

    write_req = 0;
    wait(ready);

    @(posedge clk);

end
endtask



task read_sram;		// Read SRAM

input [ADDR_WIDTH-1:0] address;
input [DATA_WIDTH-1:0] expected;
input [200*8:1] test_name;

begin

    @(posedge clk);

    addr = address;
    read_req = 1;

    @(posedge clk);

    read_req = 0;
    wait(ready);

    @(posedge clk);

    if(read_data == expected)
        report_test(test_name,1);
    else
        report_test(test_name,0);

end
endtask



task summary;		// Verification summary

begin

    $display("");
    $display("====================================================");
    $display("              VERIFICATION SUMMARY");
    $display("====================================================");

    $display("Total Tests : %0d", total_tests);
    $display("Passed      : %0d", passed_tests);
    $display("Failed      : %0d", failed_tests);

    $display("----------------------------------------------------");

    if(failed_tests == 0)
    begin
        $display("OVERALL RESULT : PASS");
    end
    else
    begin
        $display("OVERALL RESULT : FAIL");
    end

    $display("====================================================");
    $display("");

end
endtask



initial begin  // Test Sequence

    reset_dut();


    // TEST 01 : Single Write / Read

    write_sram(12'd10, 8'hAA);
    read_sram (12'd10, 8'hAA, "SINGLE WRITE / READ");


    // TEST 02 : Multiple Writes / Reads

    write_sram(12'd20, 8'h11);
    write_sram(12'd21, 8'h22);
    write_sram(12'd22, 8'h33);
    write_sram(12'd23, 8'h44);

    read_sram(12'd20, 8'h11, "MULTI READ 20");
    read_sram(12'd21, 8'h22, "MULTI READ 21");
    read_sram(12'd22, 8'h33, "MULTI READ 22");
    read_sram(12'd23, 8'h44, "MULTI READ 23");

    // TEST 03 : Back-to-Back Transactions

    write_sram(12'd100, 8'hA5);
    read_sram (12'd100, 8'hA5, "BACK TO BACK 100");

    write_sram(12'd200, 8'h5A);
    read_sram (12'd200, 8'h5A, "BACK TO BACK 200");

    // TEST 04 : Overwrite Existing Address

    write_sram(12'd50, 8'h12);
    write_sram(12'd50, 8'h34);

    read_sram(12'd50, 8'h34, "OVERWRITE ADDRESS");

    // TEST 05 : Boundary Address Test

    write_sram(12'd0, 8'h55);
    read_sram (12'd0, 8'h55, "LOWEST ADDRESS");

    write_sram(12'd4095, 8'hAA);
    read_sram (12'd4095, 8'hAA, "HIGHEST ADDRESS");

    // TEST 06 : Sequential Address Test

    write_sram(12'd30, 8'h01);
    write_sram(12'd31, 8'h02);
    write_sram(12'd32, 8'h03);

    read_sram(12'd30, 8'h01, "SEQUENTIAL 30");
    read_sram(12'd31, 8'h02, "SEQUENTIAL 31");
    read_sram(12'd32, 8'h03, "SEQUENTIAL 32");

    summary();

    #20;

    $finish;

end
endmodule