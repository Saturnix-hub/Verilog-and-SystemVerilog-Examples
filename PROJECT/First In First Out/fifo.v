module fifo
#(
    parameter DATA_WIDTH = 8
)
(
    input                       clk,
    input                       rst_n,
    input                       wr_en,
    input                       rd_en,
    input  [DATA_WIDTH-1:0]     data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output                      full,
    output                      empty
);

    reg [DATA_WIDTH-1:0] mem [0:15];

    reg [4:0] write_ptr;
    reg [4:0] read_ptr;

    assign empty = (write_ptr == read_ptr);

    assign full =
           (write_ptr[4]    != read_ptr[4])
        && (write_ptr[3:0] == read_ptr[3:0]);

    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            write_ptr <= 5'd0;
            read_ptr  <= 5'd0;
            data_out  <= {DATA_WIDTH{1'b0}};
        end
        else
        begin

            case ({wr_en, rd_en})

                2'b00:
                begin
                end

                2'b10:
                begin
                    if(!full)
                    begin
                        mem[write_ptr[3:0]] <= data_in;
                        write_ptr <= write_ptr + 1'b1;
                    end
                end

                2'b01:
                begin
                    if(!empty)
                    begin
                        data_out <= mem[read_ptr[3:0]];
                        read_ptr <= read_ptr + 1'b1;
                    end
                end

                2'b11:
                begin

                    if(!empty)
                    begin
                        data_out <= mem[read_ptr[3:0]];
                        read_ptr <= read_ptr + 1'b1;
                    end

                    if(!full || !empty)
                    begin
                        mem[write_ptr[3:0]] <= data_in;
                        write_ptr <= write_ptr + 1'b1;
                    end

                end

            endcase

        end
    end

endmodule
