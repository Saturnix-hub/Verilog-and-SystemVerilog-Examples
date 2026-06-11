module memory
#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 12
)
(
    input clk,
    input rst_n,
    input cs,
    input we,
    input re,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out
);

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    integer i;

    initial begin
        for(i = 0; i < (1<<ADDR_WIDTH); i = i + 1)
            mem[i] = '0;
    end

    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            data_out <= '0;

        else if(cs)
        begin
	    if(^addr === 1'bx)
            	$display("[%0t] ERROR: Unknown address detected", $time);
            else if(we)
                mem[addr] <= data_in;

            else if(re)
                data_out <= mem[addr];
        end
    end

endmodule
