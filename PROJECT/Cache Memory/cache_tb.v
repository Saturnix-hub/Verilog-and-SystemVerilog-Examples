`timescale 1ns/1ps

module cache_tb;
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 12;

    reg clk;
    reg rst_n;
    reg                     cpu_cs;
    reg                     cpu_we;
    reg                     cpu_re;
    reg [ADDR_WIDTH-1:0]    cpu_addr;
    reg [DATA_WIDTH-1:0]    cpu_din;

    wire [DATA_WIDTH-1:0]   cpu_dout;
    wire                    hit;
    wire                    miss;

    cache_controller #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .cpu_cs   (cpu_cs),
        .cpu_we   (cpu_we),
        .cpu_re   (cpu_re),
        .cpu_addr (cpu_addr),
        .cpu_din  (cpu_din),
        .cpu_dout (cpu_dout),
        .hit      (hit),
        .miss     (miss)
    );

    initial begin // clk
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        #5000; 
        $display("\n[ERROR] SIMULATION TIMEOUT: Deadlock detected.");
        $finish;
    end

    initial begin
        // Initialize
        rst_n    = 0;
        cpu_cs   = 0;
        cpu_we   = 0;
        cpu_re   = 0;
        cpu_addr = 0;
        cpu_din  = 0;

        #20;
        rst_n = 1;

        $display("\n========================================");
        $display("       CACHE VERIFICATION START");
        $display("========================================");

        // TEST 1 : First Read (Miss)

        @(negedge clk);
        cpu_cs   = 1;
        cpu_re   = 1;
        cpu_addr = 12'h010;

        wait(hit || miss);
        $display("TEST1 : Addr=%h Data=%h Hit=%b Miss=%b", cpu_addr,cpu_dout,hit,miss);

        @(negedge clk);
        cpu_cs = 0;
        cpu_re = 0;
        wait(!hit && !miss); 

        // TEST 2 : Read Same Address (Hit)

        @(negedge clk);
        cpu_cs   = 1;
        cpu_re   = 1;
        cpu_addr = 12'h010;

        wait(hit || miss);
        $display("TEST2 : Addr=%h Data=%h Hit=%b Miss=%b", cpu_addr,cpu_dout,hit,miss);

        @(negedge clk);
        cpu_cs = 0;
        cpu_re = 0;
        wait(!hit && !miss);

        // TEST 3 : Different Address (Miss)

        @(negedge clk);
        cpu_cs   = 1;
        cpu_re   = 1;
        cpu_addr = 12'h120;

        wait(hit || miss);
        $display("TEST3 : Addr=%h Data=%h Hit=%b Miss=%b", cpu_addr,cpu_dout,hit,miss);

        @(negedge clk);
        cpu_cs = 0;
        cpu_re = 0;
        wait(!hit && !miss);

        // TEST 4 : Read Same Address (Hit)

        @(negedge clk);
        cpu_cs   = 1;
        cpu_re   = 1;
        cpu_addr = 12'h120;

        wait(hit || miss);
        $display("TEST4 : Addr=%h Data=%h Hit=%b Miss=%b", cpu_addr,cpu_dout,hit,miss);

        @(negedge clk);
        cpu_cs = 0;
        cpu_re = 0;
        wait(!hit && !miss);

        #20;
        $display("\n========================================");
        $display("       CACHE VERIFICATION END");
        $display("========================================");
        $finish;
    end
endmodule
