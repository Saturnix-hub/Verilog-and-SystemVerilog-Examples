 module fulladder_gatelevel (a_in,
		  b_in,
		  c_in,
		  sum_out,
		  carry_out);
		  
   input a_in,b_in,c_in;
   output sum_out,carry_out;
   
   wire w1,w2,w3;
   //instantiation of halfadder
 		 
   halfadder_gatelevel HA1(.a(a_in),
	          .b(b_in),
		  .sum(w1),
		  .carry(w2));
   halfadder_gatelevel HA2(.a(w1),
		  .b(c_in),
		  .sum(sum_out),
		  .carry(w3));							
										 
										 
	// or gate 
   or #1 or1(carry_out,w3,w2);

endmodule

