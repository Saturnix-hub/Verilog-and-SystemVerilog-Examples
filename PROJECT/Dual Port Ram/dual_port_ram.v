module dual_port_ram
#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 12
)
(
    input clk,
    input rst_n,

    // Port A
    input                       we_a,
    input                       re_a,
    input  [ADDR_WIDTH-1:0]     addr_a,
    input  [DATA_WIDTH-1:0]     data_in_a,
    output reg [DATA_WIDTH-1:0] data_out_a,

    // Port B
    input                       we_b,
    input                       re_b,
    input  [ADDR_WIDTH-1:0]     addr_b,
    input  [DATA_WIDTH-1:0]     data_in_b,
    output reg [DATA_WIDTH-1:0] data_out_b
);

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    integer i;

    initial begin
        for(i=0; i<(1<<ADDR_WIDTH); i=i+1)
            mem[i] = '0;
    end

    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            data_out_a <= '0;
            data_out_b <= '0;
        end
        else
        begin

            // Port A
            if(we_a)
                mem[addr_a] <= data_in_a;
            else if(re_a)
                data_out_a <= mem[addr_a];

            // Port B
            if(we_b)
                mem[addr_b] <= data_in_b;
            else if(re_b)
                data_out_b <= mem[addr_b];

        end
    end

endmodule