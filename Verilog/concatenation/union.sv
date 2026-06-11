module Union;

typedef union {
int a;
bit b;
byte c;
} data_type;

data_type u1;

initial begin 
u1.a = 10;
$display ("printing u1 : %d",u1.a);
end
endmodule

