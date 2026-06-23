module ArithmeticLogicUnit_8bit (
    input [7:0] a,
    input [7:0] b,
    input [1:0] sel,
    output reg [15:0] result
);

wire [7:0] add_result;
wire [7:0] sub_result;
wire [15:0] mult_result; 	
wire add_cout;
wire sub_cout;
wire [7:0] b_comp;

not (b_comp[0], b[0]);
not (b_comp[1], b[1]);
not (b_comp[2], b[2]);
not (b_comp[3], b[3]);
not (b_comp[4], b[4]);
not (b_comp[5], b[5]);
not (b_comp[6], b[6]);
not (b_comp[7], b[7]);

rcadder_8bit ADD(
    .a(a),
    .b(b),
    .cin(1'b0),
    .sum(add_result),
    .cout(add_cout)
);

rcadder_8bit SUB(
    .a(a),
    .b(b_comp),
    .cin(1'b1),
    .sum(sub_result),
    .cout(sub_cout)
);

multiplier_8x8_gatelevel MUL(
    .a(a),
    .b(b),
    .product(mult_result)
);



always @(*)
begin
    case(sel)

    2'b00:
        result = {8'b0,add_result};

    2'b01:
        result = {8'b0,sub_result};

    2'b10:
        result = mult_result;

    2'b11:
        result = (b!=0) ? (a/b) : 16'hFFFF;

    endcase
end

endmodule
