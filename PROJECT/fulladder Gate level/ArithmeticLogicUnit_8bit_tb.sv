module ArithmeticLogicUnit_8bit_tb();

reg  [7:0] a;
reg  [7:0] b;
reg  [1:0] sel;

wire [15:0] result;
ArithmeticLogicUnit_8bit DUT(
    .a(a),
    .b(b),
    .sel(sel),
    .result(result)
);

initial
begin
    a   = 8'd15;
    b   = 8'd10;
    sel = 2'b00;
    #20;

    a   = 8'd15;
    b   = 8'd10;
    sel = 2'b01;
    #20;

    a   = 8'd13;
    b   = 8'd5;
    sel = 2'b10;
    #20;

    a   = 8'd20;
    b   = 8'd4;
    sel = 2'b11;
    #20;

    $finish;
end

initial
begin
    $monitor("Time=%0t  sel=%b  a=%d  b=%d  result=%d",
              $time, sel, a, b, result);
end
endmodule
