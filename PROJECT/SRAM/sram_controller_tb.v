`timescale 1ns/1ps

module sram_controller_tb;

    //====================================================
    // Parameters
    //====================================================

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 12;

    //====================================================
    // Testbench Signals
    //====================================================

    reg                       clk;
    reg                       rst;

    // CPU Interface
    reg                       read_req;
    reg                       write_req;
    reg  [ADDR_WIDTH-1:0]     addr;
    reg  [DATA_WIDTH-1:0]     write_data;

    wire [DATA_WIDTH-1:0]     read_data;
    wire                      ready;
    wire                      busy;

    // SRAM Interface
    wire                      cs;
    wire                      we;
    wire                      oe;
    wire [ADDR_WIDTH-1:0]     sram_addr;
    wire [DATA_WIDTH-1:0]     sram_din;
    wire [DATA_WIDTH-1:0]     sram_dout;

    //====================================================
    // SRAM Controller Instance
    //====================================================

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

    //====================================================
    // SRAM Instance
    //====================================================

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

    //====================================================
    // Clock Generation
    //====================================================

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //====================================================
    // Reset Task
    //====================================================

    task reset_dut;
    begin
        rst = 1;
        read_req = 0;
        write_req = 0;
        addr = 0;
        write_data = 0;

        repeat(2) @(posedge clk);

        rst = 0;

        @(posedge clk);

        $display("\nRESET COMPLETED\n");
    end
    endtask

    //====================================================
    // Write Task
    //====================================================

    task write_sram;

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

        $display("[%0t] WRITE PASS : ADDR=%0d DATA=%h",
                  $time,address,data);

    end
    endtask

    //====================================================
    // Read Task
    //====================================================

    task read_sram;

        input [ADDR_WIDTH-1:0] address;
        input [DATA_WIDTH-1:0] expected;

    begin

        @(posedge clk);

        addr = address;
        read_req = 1;

        @(posedge clk);

        read_req = 0;

        wait(ready);

        @(posedge clk);

        if(read_data == expected)
        begin
            $display("[%0t] READ PASS : ADDR=%0d DATA=%h",
                     $time,address,read_data);
        end
        else
        begin
            $display("[%0t] READ FAIL : ADDR=%0d EXP=%h GOT=%h",
                     $time,address,expected,read_data);
        end

    end
    endtask

    //====================================================
    // Monitor
    //====================================================

    initial begin

        $monitor("T=%0t STATE Signals : CS=%b WE=%b OE=%b READY=%b BUSY=%b ADDR=%0d WD=%h RD=%h",
                 $time,
                 cs,we,oe,
                 ready,busy,
                 addr,
                 write_data,
                 read_data);

    end

    //====================================================
    // Test Sequence
    //====================================================

    initial begin

        reset_dut();

        //------------------------------------------
        // Single Write / Read
        //------------------------------------------

        write_sram(12'd10,8'hAA);
        read_sram (12'd10,8'hAA);

        //------------------------------------------
        // Multiple Writes
        //------------------------------------------

        write_sram(12'd20,8'h11);
        write_sram(12'd21,8'h22);
        write_sram(12'd22,8'h33);
        write_sram(12'd23,8'h44);

        //------------------------------------------
        // Multiple Reads
        //------------------------------------------

        read_sram(12'd20,8'h11);
        read_sram(12'd21,8'h22);
        read_sram(12'd22,8'h33);
        read_sram(12'd23,8'h44);

        //------------------------------------------
        // Back-to-Back Transactions
        //------------------------------------------

        write_sram(12'd100,8'hA5);
        read_sram (12'd100,8'hA5);

        write_sram(12'd200,8'h5A);
        read_sram (12'd200,8'h5A);

        //------------------------------------------
        // End Simulation
        //------------------------------------------

        #20;

        $display("\n==================================");
        $display(" ALL TESTS COMPLETED ");
        $display("==================================\n");

        $finish;

    end

endmodule
