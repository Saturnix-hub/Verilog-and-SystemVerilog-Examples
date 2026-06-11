module test;

reg [7:0] mem [0:255];
reg [7:0] data,addr;
reg clk;

initial begin 
clk =0;
// write the memory 
data = 8'hff;
#2 addr = 8'd22;
#2 addr = 8'd25;
#2 addr = 8'd28;
#2 addr = 8'd40;
#2 addr = 8'd48;
#2 addr = 8'd59;
#2 addr = 8'd100;
#2 addr = 8'd150;
#2 addr = 8'd120;
#2 addr = 8'd122;
#2 addr = 8'd125;
#2 addr = 8'd126;
#2 addr = 8'd128;
#2 addr = 8'd130;
#2 addr = 8'd135;
#2 addr = 8'd139;
#2 addr = 8'd200;
#2 addr = 8'd220;
#2 addr = 8'd229;
#2 addr = 8'd211;
#2 addr = 8'd215;
#2 addr = 8'd219;
#2 addr = 8'd240;
#2 addr = 8'd250;
#2 addr = 8'd221;
#2 addr = 8'd253;
#2 $finish;

end

always @(addr) begin 
mem[addr] = data;
end

always #1 clk = ~clk;

endmodule 
