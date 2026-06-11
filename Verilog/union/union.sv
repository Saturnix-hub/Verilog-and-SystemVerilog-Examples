module Union;

typedef union {
int a;
int b;
byte c;
} data_type;

typedef union tagged {
int a;
int b;
} data;


data_type u1;
data u2;


initial begin 
u1.a = 10;
$display ("printing u1 a : %d",u1.a);
u1.b = 20;
$display ("printing u1 b : %d",u1.b);
$display ("printing u1 a : %d",u1.a);

u2 = tagged a 100;
$display ("printing u1 a : %d",u2.a);

#2;
$display ("printing u1 b : %d",u2.b);

u2.b = 20;
$display ("printing u1 b : %d",u2.b);
$display ("printing u1 a : %d",u2.a);

end
endmodule

