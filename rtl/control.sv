module control (
    input  logic [31:0] instruction,

    output logic       branch,
    output logic       MemRead,
    output logic       MemtoReg,
    output logic [1:0] ALUOp,
    output logic       MemWrite,
    output logic       ALUSrc,
    output logic       RegWrite
);

    always_comb begin
        // Defaults to stop latches
        branch   = 1'b0;
        MemRead  = 1'b0;
        MemtoReg = 1'b0;
        ALUOp    = 2'b00;
        MemWrite = 1'b0;
        ALUSrc   = 1'b0;
        RegWrite = 1'b0;

        case (instruction[6:0])
            7'b0110011: begin 
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end

            7'b0010011: begin 
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b00;
            end

            7'b0000011: begin // Loads
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                MemtoReg = 1'b1;
                ALUOp    = 2'b00;
            end

            7'b0100011: begin // Stores
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                ALUOp    = 2'b00;
            end

            7'b1100011: begin // Branches
                branch = 1'b1;
                ALUOp  = 2'b01;
            end

            default: begin // defaults
            end
        endcase
    end

endmodule
