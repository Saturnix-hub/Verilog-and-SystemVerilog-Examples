module halfadder_gatelevel(
	input a,
	input b,
	output sum ,carry 
);

xor #2 (sum ,a,b);
and #1 (carry,a,b);

endmodule