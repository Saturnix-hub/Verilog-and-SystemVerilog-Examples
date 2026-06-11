module arrays_data();

// 2 dimension array of Verilog 2001
reg [7:0] mem [0:3] = '{8'h0,8'h1,8'h2,8'h3};
// one more example of multi dimention array
reg [7:0] mem1 [0:1] [0:3] = 
   '{'{8'h0,8'h1,8'h2,8'h3},'{8'h4,8'h5,8'h6,8'h7}};
// One more example of multi dimention array
reg [7:0] [0:4] mem2 [0:1] = 
   '{{8'h0,8'h1,8'h2,8'h3},{8'h4,8'h5,8'h6,8'h7}};
// One more example of multi dimention array
reg [7:0] [0:4] mem3 [0:1] [0:1]  = '{'{'{8'h0,8'h1,8'h2,8'h3,8'h4,8'h5,8'h6,8'h7},'{8'h8,8'h9,8'h10,8'h11,8'h12,8'h13,8'h14,8'h15}},
  '{'{8'h0,8'h1,8'h2,8'h3,8'h4,8'h5,8'h6,8'h7},'{8'h8,8'h9,8'h10,8'h11,8'h12,8'h13,8'h14,8'h15}}};
/*

   '{'{{8'h0,8'h1,8'h2,8'h3},{8'h4,8'h5,8'h6,8'h7}},
   '{{8'h0,8'h1,8'h2,8'h3},{8'h4,8'h5,8'h6,8'h7}}};

*/
// Multi arrays in same line declaration
bit [7:0] [31:0] mem4 [1:5] [1:10], mem5 [0:255]; 

initial begin
  $display ("mem[0]            = %b", mem[0]);
  $display ("mem[1][0]         = %b", mem[1][0]);
  $display ("mem1[0][1]        = %b", mem1[0][1]);
  $display ("mem1[1][1]        = %b", mem1[1][1]);
  $display ("mem3[1][0][0]     = %b", mem3[1][0][0]);
  $display ("mem3[1][0][0][2]  = %b", mem3[1][0][0][2]);

  #1 $finish;
end

endmodule
