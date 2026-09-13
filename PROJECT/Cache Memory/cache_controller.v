`timescale 1ns/1ps

module cache_controller #(
    parameter DATA_WIDTH  = 8,
    parameter ADDR_WIDTH  = 12,
    parameter CACHE_LINES = 16,
    parameter INDEX_WIDTH = 4,
    parameter TAG_WIDTH   = 8
)(
    input                           clk,
    input                           rst_n,

    input                           cpu_cs,
    input                           cpu_we,
    input                           cpu_re,
    input      [ADDR_WIDTH-1:0]     cpu_addr,
    input      [DATA_WIDTH-1:0]     cpu_din,

    output reg [DATA_WIDTH-1:0]     cpu_dout,
    output reg                      hit,
    output reg                      miss,

    output reg                      sram_cs,
    output reg                      sram_we,
    output reg                      sram_oe,
    output reg [INDEX_WIDTH-1:0]    sram_addr,
    output reg [DATA_WIDTH-1:0]     sram_din,
    input      [DATA_WIDTH-1:0]     sram_dout,

    output reg                      mem_cs,
    output reg                      mem_we,
    output reg                      mem_re,
    output reg [ADDR_WIDTH-1:0]     mem_addr,
    output reg [DATA_WIDTH-1:0]     mem_din,
    input      [DATA_WIDTH-1:0]     mem_dout
);

    sram #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (INDEX_WIDTH)
    ) cache_sram (
        .clk  (clk),
        .cs   (sram_cs),
        .we   (sram_we),
        .oe   (sram_oe),
        .addr (sram_addr),
        .din  (sram_din),
        .dout (sram_dout)
    );

    memory #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) main_memory (
        .clk      (clk),
        .rst_n    (rst_n),
        .cs       (mem_cs),
        .we       (mem_we),
        .re       (mem_re),
        .addr     (mem_addr),
        .data_in  (mem_din),
        .data_out (mem_dout)
    );

    // Cache Metadata Arrays

    reg [TAG_WIDTH-1:0] tag_array [0:CACHE_LINES-1];
    reg                 valid_array [0:CACHE_LINES-1];

    // FSM States
    localparam IDLE      = 3'd0,
               CHECK     = 3'd1,
               MEM_READ  = 3'd2,
               MEM_WAIT  = 3'd3,
               REFILL    = 3'd4,
               RESPOND   = 3'd5,
               WAIT_CPU  = 3'd6; 

    reg [2:0] state;

    // Latched CPU Request registers
    reg [ADDR_WIDTH-1:0] addr_reg;
    reg [DATA_WIDTH-1:0] din_reg;
    reg                  we_reg;
    reg                  re_reg;
    reg                  hit_reg;
    reg                  miss_reg;
    
    wire [INDEX_WIDTH-1:0] index_reg = addr_reg[INDEX_WIDTH-1:0];
    wire [TAG_WIDTH-1:0]   tag_reg   = addr_reg[ADDR_WIDTH-1:INDEX_WIDTH];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;

            for(i=0; i<CACHE_LINES; i=i+1) begin
                valid_array[i] <= 1'b0;
                tag_array[i]   <= {TAG_WIDTH{1'b0}};
            end

            cpu_dout  <= 0;
            hit       <= 0;
            miss      <= 0;
            addr_reg  <= 0;
            din_reg   <= 0;
            we_reg    <= 0;
            re_reg    <= 0;
            hit_reg   <= 0;
            miss_reg  <= 0;	

            sram_cs   <= 0;
            sram_we   <= 0;
            sram_oe   <= 0;
            sram_addr <= 0;
            sram_din  <= 0;

            mem_cs    <= 0;
            mem_we    <= 0;
            mem_re    <= 0;
            mem_addr  <= 0;
            mem_din   <= 0;
        end
        else begin
            // Default Outputs
            sram_cs   <= 0;
            sram_we   <= 0;
            sram_oe   <= 0;
            sram_din  <= 0;
            sram_addr <= 0;

            mem_cs    <= 0;
            mem_we    <= 0;
            mem_re    <= 0;
            mem_din   <= 0;
            mem_addr  <= 0; 

            case(state)
                IDLE: begin
                    if(cpu_cs && (cpu_re || cpu_we)) begin
                        hit      <= 1'b0;
                        miss     <= 1'b0;
                        addr_reg <= cpu_addr;
                        din_reg  <= cpu_din;
                        we_reg   <= cpu_we;
                        re_reg   <= cpu_re;
                        state    <= CHECK;
                    end
                end

                CHECK: begin
                    if(valid_array[index_reg] && (tag_array[index_reg] == tag_reg)) begin
                        hit_reg   <= 1'b1;
                        miss_reg  <= 1'b0;
                        sram_cs   <= 1'b1;
                        sram_oe   <= 1'b1;
                        sram_addr <= index_reg;
                        state     <= RESPOND;
                    end
                    else begin
                        hit_reg   <= 1'b0;
                        miss_reg  <= 1'b1;
                        state     <= MEM_READ;
                    end
                end

                MEM_READ: begin
                    mem_cs   <= 1'b1;
                    mem_re   <= 1'b1;
                    mem_addr <= addr_reg;
                    state    <= MEM_WAIT;
                end

                MEM_WAIT: begin
                    state    <= REFILL;
                end	

                REFILL: begin
                    sram_cs   <= 1'b1;
                    sram_we   <= 1'b1;
                    sram_addr <= index_reg;
                    sram_din  <= mem_dout;

                    tag_array[index_reg]   <= tag_reg;
                    valid_array[index_reg] <= 1'b1;
                    state     <= RESPOND;
                end

                RESPOND: begin
                    hit  <= hit_reg;
                    miss <= miss_reg;

                    if(hit_reg) begin
                        sram_cs   <= 1'b1;
                        sram_oe   <= 1'b1;
                        sram_addr <= index_reg;
                        cpu_dout  <= sram_dout;
                    end
                    else begin
                        cpu_dout  <= mem_dout;
                    end
                    state <= WAIT_CPU; 
                end

                WAIT_CPU: begin
                    if (!cpu_cs) begin
                        hit      <= 1'b0;
                        miss     <= 1'b0;
                        hit_reg  <= 1'b0;
                        miss_reg <= 1'b0;
                        state    <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
