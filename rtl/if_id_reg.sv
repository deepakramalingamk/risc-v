module if_id_reg (
input logic clk,
input logic reset,
input logic [31:0] pc_in,
input logic enable,
input logic flush,
input logic [31:0] instruction_in,
output logic [31:0] instruction_out,
output logic [31:0] pc_out

);

always_ff @(posedge clk) begin
        if (reset || flush) begin
            instruction_out <= 32'b0;
            pc_out <= 32'b0;
        end else if (enable) begin
            instruction_out <= instruction_in;
            pc_out <= pc_in;
        end
    end

endmodule
