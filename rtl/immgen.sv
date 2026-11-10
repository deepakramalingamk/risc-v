module immgen(
input logic [31:0] instruction,
output logic [31:0] immediate
);
always_comb begin
    immediate = 32'b0;
    case(instruction[6:0])
        7'b0000011, // I type instructions - load and addi type
        7'b0010011: immediate = {{20{instruction[31]}}, instruction[31:20]};
        
        7'b0100011: immediate = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
// S-type instrcutions
        
        7'b1100011: immediate = {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};// SB-type instructions - branch
        7'b0010111, // for U type instructions
        7'b0110111: immediate = {instruction[31:12],12'b0};
        
        7'b1101111: immediate = {{11{instruction[31]}},instruction[31], instruction[19:12],instruction[20],instruction[30:21],1'b0};// for UJ type instructions
        default: immediate = 32'b0;
        endcase
    end
endmodule
         

