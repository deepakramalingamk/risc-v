module ex_mem_reg (
input logic RegWrite_in,
input logic MemWrite_in,
input logic MemRead_in,
input logic MemtoReg_in,

input logic clk,
input logic reset,



input logic [31:0] alu_result_in,
input logic [31:0] write_data_in,
input logic [4:0] rd_in,
input logic [2:0] funct3_in,

output logic RegWrite_out,
output logic MemWrite_out,
output logic MemRead_out,
output logic MemtoReg_out,

output logic [31:0] alu_result_out,
output logic [31:0] write_data_out,
output logic [4:0] rd_out,
output logic [2:0] funct3_out




);
always_ff @(posedge clk) begin
        if (reset) begin
            alu_result_out <= 32'b0;
            write_data_out <= 32'b0;
            rd_out <= 5'b0;
            funct3_out <= 3'b0;

            RegWrite_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in;
            write_data_out <= write_data_in;
            rd_out <= rd_in;
            funct3_out <= funct3_in;

            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
        end
    end

endmodule
