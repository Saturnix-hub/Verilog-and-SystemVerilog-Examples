module concatenation;

int  var1,var2,var3,var4;

initial begin
$display ("displaying variable values : %d %d %d",var1,var2,var3);
#2 var1 = 10;
#2 var2 = 20;
#2 var3 = 30;
#2 var4 = 40;
$display ("displaying variable values : %d %d %d %d",var1,var2,var3,var4);
{var1,var2,var3}=  1290;
$display ("displaying variable values : %d %d %d %d",var1,var2,var3,var4);

end
endmodule
