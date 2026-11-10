module hazard_unit (
    input logic [31:0] ifid_instruction,

    input logic idex_memread,
    input logic [4:0] idex_rd,
    input logic [4:0] idex_rs1,
    input logic [4:0] idex_rs2,

    input logic exmem_regwrite,
    input logic exmem_memtoreg,
    input logic [4:0] exmem_rd,

    input logic memwb_regwrite,
    input logic [4:0] memwb_rd,

    output logic stall,
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);

    logic [6:0] ifid_opcode;
    logic [4:0] ifid_rs1;
    logic [4:0] ifid_rs2;
    logic uses_rs1;
    logic uses_rs2;

    always_comb begin

        ifid_opcode = ifid_instruction[6:0];
        ifid_rs1 = ifid_instruction[19:15];
        ifid_rs2 = ifid_instruction[24:20];


        uses_rs1 = 1'b0;
        uses_rs2 = 1'b0;

        case (ifid_opcode)
            7'b0110011,
            7'b0010011,
            7'b0000011,
            7'b0100011,
            7'b1100011:
                uses_rs1 = 1'b1;
            default: ;
        endcase

        case (ifid_opcode)
            7'b0110011,
            7'b0100011,
            7'b1100011:
                uses_rs2 = 1'b1;
            default: ;
        endcase


        stall = idex_memread &&
                (idex_rd != 5'd0) &&
                ((uses_rs1 && (idex_rd == ifid_rs1)) ||
                 (uses_rs2 && (idex_rd == ifid_rs2)));

        forward_a = 2'b00;
        forward_b = 2'b00;

        if (exmem_regwrite &&
            !exmem_memtoreg &&
            (exmem_rd != 5'd0) &&
            (exmem_rd == idex_rs1))
            forward_a = 2'b10;
        else if (memwb_regwrite &&
                 (memwb_rd != 5'd0) &&
                 (memwb_rd == idex_rs1))
            forward_a = 2'b01;

        if (exmem_regwrite &&
            !exmem_memtoreg &&
            (exmem_rd != 5'd0) &&
            (exmem_rd == idex_rs2))
            forward_b = 2'b10;
        else if (memwb_regwrite &&
                 (memwb_rd != 5'd0) &&
                 (memwb_rd == idex_rs2))
            forward_b = 2'b01;
    end

endmodule
