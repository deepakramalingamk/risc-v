module mem_wb_reg (
    input logic clk,
    input logic reset,
    input logic [31:0] read_data_in,
    input logic [31:0] alu_res_in,
    input logic RegWrite_in,
    input logic MemtoReg_in,
    input logic [4:0] rd_in,
    
    output logic [31:0] read_data_out,
    output logic [31:0] alu_res_out,
    output logic RegWrite_out,
    output logic MemtoReg_out,
    output logic [4:0] rd_out
);

always_ff @(posedge clk) begin
    if(reset) begin
        read_data_out <= 32'b0;
         alu_res_out <= 32'b0;
         rd_out <= 5'b0;
         RegWrite_out <= 1'b0;
         MemtoReg_out <= 1'b0;

        end
    else begin
        read_data_out <= read_data_in;
        alu_res_out <= alu_res_in;
        MemtoReg_out <= MemtoReg_in;
        rd_out <= rd_in;
        RegWrite_out <= RegWrite_in;
        
    end
end
endmodule
