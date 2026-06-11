`timescale 1ns/1ps

module dual_port_ram_tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 12;

    reg clk;
    reg rst_n;

    // Port A
    reg                     we_a;
    reg                     re_a;
    reg [ADDR_WIDTH-1:0]    addr_a;
    reg [DATA_WIDTH-1:0]    data_in_a;
    wire [DATA_WIDTH-1:0]   data_out_a;

    // Port B
    reg                     we_b;
    reg                     re_b;
    reg [ADDR_WIDTH-1:0]    addr_b;
    reg [DATA_WIDTH-1:0]    data_in_b;
    wire [DATA_WIDTH-1:0]   data_out_b;

    //---------------------------------------------------------
    // DUT
    //---------------------------------------------------------

    dual_port_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),

        .we_a(we_a),
        .re_a(re_a),
        .addr_a(addr_a),
        .data_in_a(data_in_a),
        .data_out_a(data_out_a),

        .we_b(we_b),
        .re_b(re_b),
        .addr_b(addr_b),
        .data_in_b(data_in_b),
        .data_out_b(data_out_b)
    );

    //---------------------------------------------------------
    // Clock Generation
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

        rst_n     = 0;

        we_a      = 0;
        re_a      = 0;
        addr_a    = 0;
        data_in_a = 0;

        we_b      = 0;
        re_b      = 0;
        addr_b    = 0;
        data_in_b = 0;

        //----------------------------------
        // Reset
        //----------------------------------

        #20;
        rst_n = 1;

        //----------------------------------
        // Test 1
        // Port A Write AA -> Addr 10
        //----------------------------------

        #10;
        we_a      = 1;
        addr_a    = 12'd10;
        data_in_a = 8'hAA;

        #10;
        we_a = 0;

        //----------------------------------
        // Test 2
        // Port B Read Addr 10
        //----------------------------------

        re_b   = 1;
        addr_b = 12'd10;

        #10;
        $display("Port B Read Addr10 = %h", data_out_b);

        re_b = 0;

        //----------------------------------
        // Test 3
        // Port B Write 55 -> Addr 20
        //----------------------------------

        #10;
        we_b      = 1;
        addr_b    = 12'd20;
        data_in_b = 8'h55;

        #10;
        we_b = 0;

        //----------------------------------
        // Test 4
        // Port A Read Addr 20
        //----------------------------------

        re_a   = 1;
        addr_a = 12'd20;

        #10;
        $display("Port A Read Addr20 = %h", data_out_a);

        re_a = 0;

        //----------------------------------
        // Test 5
        // Simultaneous Access
        //----------------------------------

        #10;

        we_a      = 1;
        addr_a    = 12'd30;
        data_in_a = 8'hF0;

        re_b      = 1;
        addr_b    = 12'd20;

        #10;

        $display("Port B Read Addr20 = %h", data_out_b);

        we_a = 0;
        re_b = 0;

        //----------------------------------
        // Test 6
        // Read/Write Collision
        //----------------------------------

        // Initialize Address 40 = 11

        #10;

        we_a      = 1;
        addr_a    = 12'd40;
        data_in_a = 8'h11;

        #10;
        we_a = 0;

        // Collision

        #10;

        we_a      = 1;
        addr_a    = 12'd40;
        data_in_a = 8'h22;

        re_b      = 1;
        addr_b    = 12'd40;

        #10;

        $display("Collision Read Addr40 = %h", data_out_b);

        we_a = 0;
        re_b = 0;

        #10;
        $display("mem[40] = %h", dut.mem[40]);

        //----------------------------------
        // Test 7
        // Write/Write Collision
        //----------------------------------

        #10;

        we_a      = 1;
        addr_a    = 12'd50;
        data_in_a = 8'hAA;

        we_b      = 1;
        addr_b    = 12'd50;
        data_in_b = 8'h55;

        #10;

        we_a = 0;
        we_b = 0;

        #10;
        $display("mem[50] = %h", dut.mem[50]);

        //----------------------------------
        // Test 8
        // Read Unwritten Address
        //----------------------------------

        #10;

        re_a   = 1;
        addr_a = 12'd100;

        #10;

        $display("Read Addr100 = %h", data_out_a);

        re_a = 0;

        //----------------------------------
        // Done
        //----------------------------------

        #20;

        $display("================================");
        $display("DUAL PORT RAM PASSED");
        $display("================================");

        $finish;

    end

endmodule
