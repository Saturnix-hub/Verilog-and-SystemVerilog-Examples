module calculator_tb;
reg [7:0] a,b;
reg [2:0] sel;
wire [15:0] result;

calci DUT ( 
	.a(a),
	.b(b),
	.sel(sel),
	.result(result)
);

initial begin

    a = 10; b = 5; sel = 3'b000; #10;
    a = 10; b = 5; sel = 3'b001; #10;
    a = 10; b = 5; sel = 3'b010; #10;
    a = 10; b = 5; sel = 3'b011; #10;
    a = 10; b = 3; sel = 3'b100; #10;
    a = 10; b = 0; sel = 3'b011; #10;
    $finish;
end

initial begin
    $monitor("a=%d b=%d sel=%b result=%d",
              a,b,sel,result);
end
endmodule
