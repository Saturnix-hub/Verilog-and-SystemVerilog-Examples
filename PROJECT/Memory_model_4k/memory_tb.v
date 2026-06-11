`timescale 1ns/1ps

module memory_tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 12;

    reg clk;
    reg rst_n;
    reg cs;
    reg we;
    reg re;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] data_in;

    wire [DATA_WIDTH-1:0]    data_out;

    memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .cs(cs),
        .we(we),
        .re(re),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin

    rst_n   = 0;
    cs      = 0;
    we      = 0;
    re      = 0;
    addr    = 0;
    data_in = 0;

    #20;
    rst_n = 1;

    #10;
    cs      = 1;
    we      = 1;
    addr    = 12'd10;
    data_in = 8'hAA;

    #10;
    we = 0;

    re = 1;

    #10;
    $display("Read Addr 10 = %h", data_out);

    re = 0;

    #10;
    we      = 1;
    addr    = 12'd20;
    data_in = 8'h55;

    #10;
    we = 0;

    #10;
    we      = 1;
    addr    = 12'd30;
    data_in = 8'hF0;

    #10;
    we = 0;

    #10;
    re   = 1;
    addr = 12'd20;

    #10;
    $display("Read Addr 20 = %h", data_out);

    re = 0;

    #10;
    re   = 1;
    addr = 12'd30;

    #10;
    $display("Read Addr 30 = %h", data_out);

    re = 0;

    #10;
    cs      = 0;
    we      = 1;
    addr    = 12'd40;
    data_in = 8'h99;

    #10;
    we = 0;

    $display("mem[40] = %h", dut.mem[40]);

    #10;
    cs      = 1;
    we      = 1;
    re      = 1;
    addr    = 12'd50;
    data_in = 8'h77;

    #10;
    we = 0;
    re = 0;

    $display("mem[50] = %h", dut.mem[50]);

    #10;
    re   = 1;
    addr = 12'd100;
    #10;
    $display("Read Addr 100 = %h", data_out);
    re = 0;
    #20;

    $display("=================================");
    $display("Verification Completed");
    $display("=================================");

    $finish;

end
endmodule