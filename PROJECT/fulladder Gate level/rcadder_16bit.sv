module rcadder_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input         cin,

    output [15:0] sum,
    output        cout
);

wire c1,c2,c3,c4,c5,c6,c7,c8;
wire c9,c10,c11,c12,c13,c14,c15;

fulladder_gatelevel FA0 (
    .a_in(a[0]),
    .b_in(b[0]),
    .c_in(cin),
    .sum_out(sum[0]),
    .carry_out(c1)
);

fulladder_gatelevel FA1 (
    .a_in(a[1]),
    .b_in(b[1]),
    .c_in(c1),
    .sum_out(sum[1]),
    .carry_out(c2)
);

fulladder_gatelevel FA2 (
    .a_in(a[2]),
    .b_in(b[2]),
    .c_in(c2),
    .sum_out(sum[2]),
    .carry_out(c3)
);

fulladder_gatelevel FA3 (
    .a_in(a[3]),
    .b_in(b[3]),
    .c_in(c3),
    .sum_out(sum[3]),
    .carry_out(c4)
);

fulladder_gatelevel FA4 (
    .a_in(a[4]),
    .b_in(b[4]),
    .c_in(c4),
    .sum_out(sum[4]),
    .carry_out(c5)
);

fulladder_gatelevel FA5 (
    .a_in(a[5]),
    .b_in(b[5]),
    .c_in(c5),
    .sum_out(sum[5]),
    .carry_out(c6)
);

fulladder_gatelevel FA6 (
    .a_in(a[6]),
    .b_in(b[6]),
    .c_in(c6),
    .sum_out(sum[6]),
    .carry_out(c7)
);

fulladder_gatelevel FA7 (
    .a_in(a[7]),
    .b_in(b[7]),
    .c_in(c7),
    .sum_out(sum[7]),
    .carry_out(c8)
);

fulladder_gatelevel FA8 (
    .a_in(a[8]),
    .b_in(b[8]),
    .c_in(c8),
    .sum_out(sum[8]),
    .carry_out(c9)
);

fulladder_gatelevel FA9 (
    .a_in(a[9]),
    .b_in(b[9]),
    .c_in(c9),
    .sum_out(sum[9]),
    .carry_out(c10)
);

fulladder_gatelevel FA10 (
    .a_in(a[10]),
    .b_in(b[10]),
    .c_in(c10),
    .sum_out(sum[10]),
    .carry_out(c11)
);

fulladder_gatelevel FA11 (
    .a_in(a[11]),
    .b_in(b[11]),
    .c_in(c11),
    .sum_out(sum[11]),
    .carry_out(c12)
);

fulladder_gatelevel FA12 (
    .a_in(a[12]),
    .b_in(b[12]),
    .c_in(c12),
    .sum_out(sum[12]),
    .carry_out(c13)
);

fulladder_gatelevel FA13 (
    .a_in(a[13]),
    .b_in(b[13]),
    .c_in(c13),
    .sum_out(sum[13]),
    .carry_out(c14)
);

fulladder_gatelevel FA14 (
    .a_in(a[14]),
    .b_in(b[14]),
    .c_in(c14),
    .sum_out(sum[14]),
    .carry_out(c15)
);

fulladder_gatelevel FA15 (
    .a_in(a[15]),
    .b_in(b[15]),
    .c_in(c15),
    .sum_out(sum[15]),
    .carry_out(cout)
);

endmodule