module dmemory #(
    parameter int BYTES = 4096
) (
    input  logic        clk,
    input  logic        MemWrite,
    input  logic        MemRead,
    input  logic [31:0] address,
    input  logic [31:0] write_data,
    input  logic [31:0] instruction,
    output logic [31:0] read_data
);

    logic [7:0]  mem [0:BYTES-1];
    logic [15:0] halfword;
    logic [31:0] word_data;
    int i;

    always_comb begin
        halfword  = {mem[address + 1], mem[address]};
        word_data = {
            mem[address + 3],
            mem[address + 2],
            mem[address + 1],
            mem[address]
        };

        read_data = 32'b0;

        if (MemRead) begin
            case (instruction[14:12])
                3'b001: read_data = {{16{halfword[15]}}, halfword}; // LH
                3'b101: read_data = {16'b0, halfword};              // LHU
                3'b010: read_data = word_data;                      // LW
                default: read_data = 32'b0;
            endcase
        end
    end

    always_ff @(posedge clk) begin
        if (MemWrite) begin
            case (instruction[14:12])
                3'b001: begin // SH
                    mem[address]     <= write_data[7:0];
                    mem[address + 1] <= write_data[15:8];
                end

                3'b010: begin // SW
                    for (i = 0; i < 4; i = i + 1)
                        mem[address + i] <= write_data[i*8 +: 8];
                end

                default: begin
                    // No write for unsupported store types.
                end
            endcase
        end
    end

endmodule
