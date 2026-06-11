module tristate_buffer(
data_in_0, data_in_1 , data_out , select
);

input data_in_0, data_in_1 , select;
output data_out ;

assign data_out = (select) ? data_in_1 : data_in_0;

endmodule
