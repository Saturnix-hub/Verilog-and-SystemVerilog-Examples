module tristate_buffer_tb(
);
reg data_in_0 , data_in_1 , select;
wire data_out;

initial begin
  $monitor("TIME = %g SEL = %b DATA0 = %b DATA1 = %b OUT = %b",$time,select,data_in_0,data_in_1,data_out);
  data_in_0 = 0;
  data_in_1 = 0;
  select = 0;
  #10 select = 1;
  #10 $finish;
end
always
 #1 data_in_0 = ~data_in_0;

always
 #2 data_in_1 = ~data_in_1;

tristate_buffer dut (
.data_in_0(data_in_0),
.data_in_1(data_in_1),
.data_out(data_out),
.select(select)
);

endmodule