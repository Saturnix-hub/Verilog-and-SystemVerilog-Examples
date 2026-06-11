module multiplier_8x8_gatelevel(
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] product
);

wire [7:0] pp0;
wire [7:0] pp1;
wire [7:0] pp2;
wire [7:0] pp3;
wire [7:0] pp4;
wire [7:0] pp5;
wire [7:0] pp6;
wire [7:0] pp7;

// Partial Product Row 0
and(pp0[0],a[0],b[0]);
and(pp0[1],a[1],b[0]);
and(pp0[2],a[2],b[0]);
and(pp0[3],a[3],b[0]);
and(pp0[4],a[4],b[0]);
and(pp0[5],a[5],b[0]);
and(pp0[6],a[6],b[0]);
and(pp0[7],a[7],b[0]);

// Partial Product Row 1
and(pp1[0],a[0],b[1]);
and(pp1[1],a[1],b[1]);
and(pp1[2],a[2],b[1]);
and(pp1[3],a[3],b[1]);
and(pp1[4],a[4],b[1]);
and(pp1[5],a[5],b[1]);
and(pp1[6],a[6],b[1]);
and(pp1[7],a[7],b[1]);

// Partial Product Row 2
and(pp2[0],a[0],b[2]);
and(pp2[1],a[1],b[2]);
and(pp2[2],a[2],b[2]);
and(pp2[3],a[3],b[2]);
and(pp2[4],a[4],b[2]);
and(pp2[5],a[5],b[2]);
and(pp2[6],a[6],b[2]);
and(pp2[7],a[7],b[2]);

// Partial Product Row 3
and(pp3[0],a[0],b[3]);
and(pp3[1],a[1],b[3]);
and(pp3[2],a[2],b[3]);
and(pp3[3],a[3],b[3]);
and(pp3[4],a[4],b[3]);
and(pp3[5],a[5],b[3]);
and(pp3[6],a[6],b[3]);
and(pp3[7],a[7],b[3]);

// Partial Product Row 4
and(pp4[0],a[0],b[4]);
and(pp4[1],a[1],b[4]);
and(pp4[2],a[2],b[4]);
and(pp4[3],a[3],b[4]);
and(pp4[4],a[4],b[4]);
and(pp4[5],a[5],b[4]);
and(pp4[6],a[6],b[4]);
and(pp4[7],a[7],b[4]);

// Partial Product Row 5
and(pp5[0],a[0],b[5]);
and(pp5[1],a[1],b[5]);
and(pp5[2],a[2],b[5]);
and(pp5[3],a[3],b[5]);
and(pp5[4],a[4],b[5]);
and(pp5[5],a[5],b[5]);
and(pp5[6],a[6],b[5]);
and(pp5[7],a[7],b[5]);

// Partial Product Row 6
and(pp6[0],a[0],b[6]);
and(pp6[1],a[1],b[6]);
and(pp6[2],a[2],b[6]);
and(pp6[3],a[3],b[6]);
and(pp6[4],a[4],b[6]);
and(pp6[5],a[5],b[6]);
and(pp6[6],a[6],b[6]);
and(pp6[7],a[7],b[6]);

// Partial Product Row 7
and(pp7[0],a[0],b[7]);
and(pp7[1],a[1],b[7]);
and(pp7[2],a[2],b[7]);
and(pp7[3],a[3],b[7]);
and(pp7[4],a[4],b[7]);
and(pp7[5],a[5],b[7]);
and(pp7[6],a[6],b[7]);
and(pp7[7],a[7],b[7]);

wire [15:0] row0,row1,row2,row3,row4,row5,row6,row7;

assign row0 = {8'b0,pp0};
assign row1 = {7'b0,pp1,1'b0};
assign row2 = {6'b0,pp2,2'b0};
assign row3 = {5'b0,pp3,3'b0};
assign row4 = {4'b0,pp4,4'b0};
assign row5 = {3'b0,pp5,5'b0};
assign row6 = {2'b0,pp6,6'b0};
assign row7 = {1'b0,pp7,7'b0};

// 3. Intermediate sums
wire [15:0] sum1,sum2,sum3,sum4,sum5,sum6;
wire c1,c2,c3,c4,c5,c6,c7;

// 4. Add rows
rcadder_16bit ADD1(row0,row1,1'b0,sum1,c1);
rcadder_16bit ADD2(sum1,row2,1'b0,sum2,c2);
rcadder_16bit ADD3(sum2,row3,1'b0,sum3,c3);
rcadder_16bit ADD4(sum3,row4,1'b0,sum4,c4);
rcadder_16bit ADD5(sum4,row5,1'b0,sum5,c5);
rcadder_16bit ADD6(sum5,row6,1'b0,sum6,c6);
rcadder_16bit ADD7(sum6,row7,1'b0,product,c7);

endmodule
