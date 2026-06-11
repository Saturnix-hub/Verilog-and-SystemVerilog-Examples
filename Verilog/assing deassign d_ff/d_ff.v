// D Flip-Flop model
module d_ff (clk,rst,d,q);
input clk,rst,d;
output q;
reg q;

always @ (posedge clk)
if (rst) begin
  q <= 0;
end else begin
  q <= d;
end

endmodule