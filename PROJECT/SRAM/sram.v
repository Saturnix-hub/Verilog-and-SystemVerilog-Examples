module sram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 12
)(
    input  wire                    clk,
    input  wire                    cs,
    input  wire                    we,
    input  wire                    oe,
    input  wire [ADDR_WIDTH-1:0]   addr,
    input  wire [DATA_WIDTH-1:0]   din,
    output reg  [DATA_WIDTH-1:0]   dout
);

    reg [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];

    // Write Operation
    always @(posedge clk) begin
        if (cs && we)
            memory[addr] <= din;
    end

    // Read Operation
    always @(*) begin
        if (cs && oe && !we)
            dout = memory[addr];
        else
            dout = {DATA_WIDTH{1'b0}};
    end

endmodule