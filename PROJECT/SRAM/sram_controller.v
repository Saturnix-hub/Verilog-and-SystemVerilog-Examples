module sram_controller #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 12
)(
    input                          clk,
    input                          rst,

    // CPU Interface
    input                          read_req,
    input                          write_req,
    input      [ADDR_WIDTH-1:0]    addr,
    input      [DATA_WIDTH-1:0]    write_data,

    output reg [DATA_WIDTH-1:0]    read_data,
    output reg                     ready,
    output reg                     busy,

    // SRAM Interface
    output reg                     cs,
    output reg                     we,
    output reg                     oe,
    output reg [ADDR_WIDTH-1:0]    sram_addr,
    output reg [DATA_WIDTH-1:0]    sram_din,
    input      [DATA_WIDTH-1:0]    sram_dout
);

    //====================================================
    // State Encoding
    //====================================================

    localparam IDLE           = 3'd0,
               READ_SETUP     = 3'd1,
               READ_ACCESS    = 3'd2,
               READ_COMPLETE  = 3'd3,
               WRITE_SETUP    = 3'd4,
               WRITE_ACCESS   = 3'd5,
               WRITE_COMPLETE = 3'd6;

    reg [2:0] current_state;
    reg [2:0] next_state;

    //====================================================
    // State Register
    //====================================================

    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    //====================================================
    // Next State Logic
    //====================================================

    always @(*) begin

        next_state = current_state;

        case(current_state)

            IDLE:
                if(read_req)
                    next_state = READ_SETUP;
                else if(write_req)
                    next_state = WRITE_SETUP;

            READ_SETUP:
                next_state = READ_ACCESS;

            READ_ACCESS:
                next_state = READ_COMPLETE;

            READ_COMPLETE:
                next_state = IDLE;

            WRITE_SETUP:
                next_state = WRITE_ACCESS;

            WRITE_ACCESS:
                next_state = WRITE_COMPLETE;

            WRITE_COMPLETE:
                next_state = IDLE;

            default:
                next_state = IDLE;

        endcase

    end

    //====================================================
    // Output Logic
    //====================================================

    always @(*) begin

        cs        = 0;
        we        = 0;
        oe        = 0;

        ready     = 0;
        busy      = 0;

        sram_addr = addr;
        sram_din  = write_data;

        case(current_state)

            IDLE: begin
            end

            READ_SETUP: begin
                busy = 1;
                cs   = 1;
            end

            READ_ACCESS: begin
                busy = 1;
                cs   = 1;
                oe   = 1;
            end

            READ_COMPLETE: begin
                ready = 1;
            end

            WRITE_SETUP: begin
                busy = 1;
                cs   = 1;
            end

            WRITE_ACCESS: begin
                busy = 1;
                cs   = 1;
                we   = 1;
            end

            WRITE_COMPLETE: begin
                ready = 1;
            end

        endcase

    end

    //====================================================
    // Read Data Capture
    //====================================================

    always @(posedge clk or posedge rst) begin

        if(rst)
            read_data <= 0;

        else if(current_state == READ_ACCESS)
            read_data <= sram_dout;

    end

endmodule