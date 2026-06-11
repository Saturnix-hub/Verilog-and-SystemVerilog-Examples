module always_comb_process();

reg [7:0] sum,a,b;
reg       parity;

initial begin
  $monitor ("@%g a = %h b = %h sum = %h parity = %b", 
   $time, a, b, sum, parity);
  #1 a = 1;
  #1 b = 1;
  #5 a = 10;
  #1 $finish;
end

always_comb
begin : ADDER
  sum = b + a;
  parity = ^sum;
end

endmodule
