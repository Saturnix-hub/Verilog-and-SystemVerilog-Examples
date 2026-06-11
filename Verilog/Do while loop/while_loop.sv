module while_loop ();
/*

byte a = 0;

initial begin
  do begin
    $display ("Current value of a = %g", a);
    a ++;
  end while  (a < 10);
  #1 $finish;
end

*/

int b = 0;

initial begin 

while (b <= 10)
begin 
	$display("The value of b : %d",b);
	b++;
end 


end
endmodule
