primitive udp_fulladder(
adder_out,
a,
b,
cin
);

output adder_out;
input a,b,cin;


//wire a,b,cin,adder_out;

table
    0 0 0 : 0;
    0 0 1 : 1;
    0 1 0 : 1;
    0 1 1 : 0;
    1 0 0 : 1;
    1 0 1 : 0;
    1 1 0 : 0;
    1 1 1 : 1;
endtable 
endprimitive