module instruction_memory #(
parameter int WORDS = 1024,
parameter INIT_FILE = ""
)
(
input logic [31:0] read_addr,

output logic [31:0] instruction
);
    logic [31:0] ins_mem [0:WORDS -1];
    
    initial begin
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, ins_mem);
    end

always_comb begin
    instruction = ins_mem[read_addr[31:2]];
    end
endmodule
