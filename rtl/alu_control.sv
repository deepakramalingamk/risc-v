module alu_control (
input logic [31:0] instruction,
input logic [1:0] ALUOp,

output logic [4:0] alu_control
);


localparam logic [3:0] ALU_AND = 4'b0000;
    localparam logic [3:0] ALU_OR  = 4'b0001;
    localparam logic [3:0] ALU_ADD = 4'b0010;
    localparam logic [3:0] ALU_SUB = 4'b0110;

    always_comb begin
        alu_control = ALU_ADD;

        case (ALUOp)
            2'b00: alu_control = ALU_ADD;
            2'b01: alu_control = ALU_SUB;

            2'b10: begin
                case (instruction[14:12]) 
                    3'b000:
                        alu_control = instruction[30] ? ALU_SUB : ALU_ADD;
                    3'b111: alu_control = ALU_AND;
                    3'b110: alu_control = ALU_OR;
                    default: alu_control = ALU_ADD;
                endcase
            end

            default: alu_control = ALU_ADD;
        endcase
    end

endmodule
