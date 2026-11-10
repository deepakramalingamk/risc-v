module id_ex_register (
    input logic clk,
    input logic reset,
    input logic flush,
    
    input logic [31:0] pc_in,
    input logic [31:0] read_data1_in,
    input logic [31:0] read_data2_in,
    input logic [31:0] immediate_in,
    input logic [4:0] rs1_in,
    input logic [4:0] rs2_in,
    input logic [4:0] rd_in,
    input logic [2:0] funct3_in,
    input logic [3:0] alu_control_in,
    input logic RegWrite_in,
    input logic MemtoReg_in,
    input logic MemRead_in,
    input logic MemWrite_in,
    input logic ALUSrc_in,
    input logic Branch_in,

    output logic [31:0] pc_out,
    output logic [31:0] read_data1_out,
    output logic [31:0] read_data2_out,
    output logic [31:0] immediate_out,
    output logic [4:0] rs1_out,
    output logic [4:0] rs2_out,
    output logic [4:0] rd_out,
    output logic [2:0] funct3_out,
    output logic [3:0] alu_control_out,

    output logic RegWrite_out,
    output logic MemtoReg_out,
    output logic MemRead_out,
    output logic MemWrite_out,
    output logic ALUSrc_out,
    output logic Branch_out
);

    always_ff @(posedge clk) begin
        if (reset || flush) begin
            pc_out <= 32'b0;
            read_data1_out <= 32'b0;
            read_data2_out <= 32'b0;
            immediate_out <= 32'b0;
            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
            rd_out <= 5'b0;
            funct3_out <= 3'b0;
            alu_control_out <= 4'b0;

            RegWrite_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
            ALUSrc_out <= 1'b0;
            Branch_out <= 1'b0;
        end else begin
            pc_out <= pc_in;
            read_data1_out <= read_data1_in;
            read_data2_out <= read_data2_in;
            immediate_out <= immediate_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out <= rd_in;
            funct3_out <= funct3_in;
            alu_control_out <= alu_control_in;

            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            ALUSrc_out <= ALUSrc_in;
            Branch_out <= Branch_in;
        end
    end

endmodule
