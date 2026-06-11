`timescale 1ns/1ps
`include "udp_fulladder.v"


//udp_fulladder(adder_out,a,b,cin);
module full_adder(/*
adder_out,
a,
b,
cin */
);


reg  a , b , cin ;
wire adder_out;

udp_fulladder dut (adder_out,a,b,cin);

initial begin 
    $display("Time \t   A   |   B   |   C   |  OUT  ");
    $monitor(" %g  \t   %b  |  %b   |  %b   |   %b  ",$time,a,b,cin , adder_out);
    
    a = 0;
    b = 0;
    cin = 0;
    
    #2 cin = 1;
    #2 b = 1;
    #2 cin = 0;
    #2 b = 0;
    #2 a = 1;
    #2 cin = 1;
    #2 b = 1;
    #2 cin = 0;
    #4 $finish ;
end

/*
udp_fulladder DUT (
.adder_out(adder_out),
.a(a),
.b(b),
.cin(cin)
);
*/
endmodule