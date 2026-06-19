`timescale 1ns/1ps

module async_fifo
#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)
(
    input                       clk_wr,
    input                       clk_rd,
    input                       rst_n,

    input                       wr_en,
    input                       rd_en,

    input  [DATA_WIDTH-1:0]     data_in,
    output reg [DATA_WIDTH-1:0] data_out,

    output                      full,
    output                      empty
);

    //---------------------------------------------------------
    // Memory
    //---------------------------------------------------------

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    //---------------------------------------------------------
    // Binary Pointers
    //---------------------------------------------------------

    reg [ADDR_WIDTH:0] wr_ptr_bin;
    reg [ADDR_WIDTH:0] rd_ptr_bin;

    //---------------------------------------------------------
    // Gray Pointers
    //---------------------------------------------------------

    reg [ADDR_WIDTH:0] wr_ptr_gray;
    reg [ADDR_WIDTH:0] rd_ptr_gray;

    //---------------------------------------------------------
    // Synchronizers
    //---------------------------------------------------------

    reg [ADDR_WIDTH:0] rd_ptr_gray_sync1;
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync2;

    reg [ADDR_WIDTH:0] wr_ptr_gray_sync1;
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync2;

    //---------------------------------------------------------
    // Binary to Gray Conversion
    //---------------------------------------------------------

    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    //---------------------------------------------------------
    // Synchronize Read Pointer into Write Domain
    //---------------------------------------------------------

    always @(posedge clk_wr or negedge rst_n)
    begin
        if(!rst_n)
        begin
            rd_ptr_gray_sync1 <= 0;
            rd_ptr_gray_sync2 <= 0;
        end
        else
        begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    //---------------------------------------------------------
    // Synchronize Write Pointer into Read Domain
    //---------------------------------------------------------

    always @(posedge clk_rd or negedge rst_n)
    begin
        if(!rst_n)
        begin
            wr_ptr_gray_sync1 <= 0;
            wr_ptr_gray_sync2 <= 0;
        end
        else
        begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

    //---------------------------------------------------------
    // Full Detection
    //---------------------------------------------------------

    wire [ADDR_WIDTH:0] wr_ptr_bin_next;
    wire [ADDR_WIDTH:0] wr_ptr_gray_next;

    assign wr_ptr_bin_next =
        wr_ptr_bin + (wr_en ? 1'b1 : 1'b0);

    assign wr_ptr_gray_next =
        bin2gray(wr_ptr_bin_next);

    assign full =
        (wr_ptr_gray_next ==
        {
            ~rd_ptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1],
             rd_ptr_gray_sync2[ADDR_WIDTH-2:0]
        });

    //---------------------------------------------------------
    // Empty Detection
    //---------------------------------------------------------

    assign empty =
        (rd_ptr_gray == wr_ptr_gray_sync2);

    //---------------------------------------------------------
    // Write Domain Logic
    //---------------------------------------------------------

    always @(posedge clk_wr or negedge rst_n)
    begin
        if(!rst_n)
        begin
            wr_ptr_bin  <= 0;
            wr_ptr_gray <= 0;
        end
        else
        begin
            if(wr_en && !full)
            begin
                mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= data_in;

                wr_ptr_bin  <= wr_ptr_bin + 1'b1;
                wr_ptr_gray <= bin2gray(wr_ptr_bin + 1'b1);
            end
        end
    end

    //---------------------------------------------------------
    // Read Domain Logic
    //---------------------------------------------------------

    always @(posedge clk_rd or negedge rst_n)
    begin
        if(!rst_n)
        begin
            rd_ptr_bin  <= 0;
            rd_ptr_gray <= 0;
            data_out    <= 0;
        end
        else
        begin
            if(rd_en && !empty)
            begin
                data_out <= mem[rd_ptr_bin[ADDR_WIDTH-1:0]];

                rd_ptr_bin  <= rd_ptr_bin + 1'b1;
                rd_ptr_gray <= bin2gray(rd_ptr_bin + 1'b1);
            end
        end
    end

endmodule
