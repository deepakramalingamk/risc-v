module alu (
input logic [31:0] a,
input logic [31:0] b,
input logic [4:0] alu_op,
output logic [31:0] result,
output logic zero
); 
    localparam logic [3:0] ALU_ADD  = 4'b0010;
    localparam logic [3:0] ALU_SUB  = 4'b0110;
    localparam logic [3:0] ALU_AND  = 4'b0000;
    localparam logic [3:0] ALU_OR   = 4'b0001;
always_comb begin
	result = 32'b0;
	
	case(alu_op)
		ALU_ADD: result = a + b;
		ALU_SUB: result = a - b;
		ALU_AND: result = a & b;
		ALU_OR: result = a | b;
		default :result = 32'b0;
		endcase
		end
	assign zero = (result == 32'b0);
endmodule
