module events();
// Declare a new event called ack
event ack; 
// Declare done as alias to ack 
event done = ack; 
// Event variable with no synchronization object
event empty = null; 

initial begin
  #1 -> ack;
  #1 -> empty;
  #1 -> done;
  #1 $finish;
end

always @ (ack)
begin
  $display("%g \t ack event emitted",$time);
end

always @ (done)
begin
  #1 $display("%g \t done event emitted",$time);
end


always @ (empty)
begin
  $display("%g \t empty event emitted",$time);
end


endmodule
