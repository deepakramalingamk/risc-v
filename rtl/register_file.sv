module register_file (
	input logic clk,
	input logic write_enable,
	input logic [4:0] read_addr1,
	input logic [4:0] read_addr2,
	input logic [4:0] write_addr,
	input logic [31:0] write_data,
	output logic [31:0] read_data1,
	output logic [31:0] read_data2
);
logic [31:0] regs [0:31];

always_comb begin
    read_data1 = (read_addr1 == 5'd0) ? 32'b0 : regs[read_addr1];
    read_data2 = (read_addr2 == 5'd0) ? 32'b0 : regs[read_addr2];
end

always_ff @(posedge clk) begin
    if (write_enable && (write_addr != 5'd0))
        regs[write_addr] <= write_data;
end
endmodule

