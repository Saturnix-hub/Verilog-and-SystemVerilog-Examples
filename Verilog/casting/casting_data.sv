module casting_data();
int a = 0;
int b = 0;

initial begin

$display("new code");

  $monitor ("%g a = %d b = %h", $time, a , b);
  #1 a = int'(2.3 * 3.3);
  #1 b = int'({8'hDE,8'hAD,8'hBE,8'hEF});
  #1 $finish;
end
endmodule