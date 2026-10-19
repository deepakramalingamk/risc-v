module program_counter (
    input  logic        clk,
    input  logic        PCSrc,
    input  logic [31:0] branch_imm,
    output logic [31:0] PC
);

    logic [31:0] PC_plus_4;
    logic [31:0] shifted_branch_imm;
    logic [31:0] branch_target;
    logic [31:0] next_PC;

    always_comb begin
        PC_plus_4          = PC + 32'd4;
        shifted_branch_imm = {branch_imm[30:0], 1'b0};
        branch_target      = PC + shifted_branch_imm;

        if (PCSrc)
            next_PC = branch_target;
        else
            next_PC = PC_plus_4;
    end

    always_ff @(posedge clk) begin
        PC <= next_PC;
    end

endmodule
