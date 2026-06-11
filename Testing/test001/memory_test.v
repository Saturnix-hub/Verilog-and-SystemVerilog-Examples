module memory_test;

reg [7:0] mem [0:15];

initial begin
    mem[0] = 8'hAA;
    mem[1] = 8'h55;

    $display("mem[0] = %h", mem[0]);
    $display("mem[1] = %h", mem[1]);
end

endmodule
