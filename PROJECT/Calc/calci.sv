module calci(
	input [7:0] a,
	input [7:0] b,
	input [2:0] sel,
	output reg [15:0] result
);

always@(*) begin 
	case(sel)
		
	3'b000 : result = a+b;
	3'b001 : result = a-b;
	3'b010 : result = a*b;
	3'b011 : begin 
	if (b!=0)begin
	result = a / b;
	end else begin 
	result = 16'hFFFF;
	$display("\nerror code : %h Denominator is zero in Division.\n",result);
	end
	end
	3'b100 : begin 
	if (b!=0) begin 
	result = a % b;
	end else begin 
	result = 16'hFFFF;
	$display("\nerror code : %h Denominator is zero during Modulus.\n",result);
end
end
	default : result = 16'd0;
	endcase

end
endmodule
