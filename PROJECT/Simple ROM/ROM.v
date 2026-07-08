`timescale 1ns/1ps

module rom #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8,
    parameter DEPTH      = 256
)(
    input                       clk,
    input                       rst_n,
    input                       cs,
    input                       re,
    input  [ADDR_WIDTH-1:0]     addr,
    output reg [DATA_WIDTH-1:0] data
);

    // Memory
    reg [DATA_WIDTH-1:0] rom [0:DEPTH-1];

    // Importing memory file
    initial begin
        $readmemh("rom.mem", rom);
    end

    // Simple Read logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data <= {DATA_WIDTH{1'b0}};
        else if (cs && re)
            data <= rom[addr];
        else
            data <= {DATA_WIDTH{1'b0}};
    end

endmodule
