module multiplier_tb;

reg [7:0] a,b;
wire [15:0] product;

multiplier_8x8_gatelevel DUT(
    .a(a),
    .b(b),
    .product(product)
);

initial begin

    a = 8'd13;
    b = 8'd5;
    #100;

    $display("a=%d b=%d product=%d",a,b,product);

    $finish;
end

endmodule
