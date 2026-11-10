module cpu (
    input logic clk,
    input logic reset,

    output logic [31:0] instruction_address,
    input logic [31:0] instruction,

    output logic MemRead,
    output logic MemWrite,
    output logic [2:0] memory_funct3,
    output logic [31:0] memory_address,
    output logic [31:0] memory_write_data,
    input logic [31:0] memory_read_data
);
    logic hazard_stall;
    logic [1:0] forward_a;
    logic [1:0] forward_b;
    logic [31:0] forwarded_read_data1_ex;
    logic [31:0] forwarded_read_data2_ex;
    logic [31:0] read_data_wb;
    logic [31:0] alu_result_wb;
    logic [4:0] rd_wb;
    logic RegWrite_wb;
    logic MemtoReg_wb;
        
    logic [31:0] PC;
    logic [31:0] next_PC;
    logic [31:0] PC_plus_4;
    logic [31:0] branch_target;
    
        logic [31:0] alu_result_mem, write_data_mem;
    logic [4:0] rd_mem;
    logic [2:0] funct3_mem;
    logic RegWrite_mem, MemtoReg_mem;
    logic MemRead_mem, MemWrite_mem;
    
    
    logic [31:0] if_id_instruction;
    logic [31:0] if_id_pc;


    logic [31:0] read_data1_id;
    logic [31:0] read_data2_id;
    logic [31:0] immediate_id;
    logic [3:0] alu_control_id;

    logic Branch_id;
    logic RegWrite_id;
    logic ALUSrc_id;
    logic MemtoReg_id;
    logic MemRead_id;
    logic MemWrite_id;
    logic [1:0] ALUOp_id;


    logic [31:0] id_ex_pc;
    logic [31:0] read_data1_ex;
    logic [31:0] read_data2_ex;
    logic [31:0] immediate_ex;

    logic [4:0] rs1_ex;
    logic [4:0] rs2_ex;
    logic [4:0] rd_ex;
    logic [2:0] funct3_ex;
    logic [3:0] alu_control_ex;

    logic RegWrite_ex;
    logic MemtoReg_ex;
    logic MemRead_ex;
    logic MemWrite_ex;
    logic ALUSrc_ex;
    logic Branch_ex;
    
    


    logic [31:0] alu_operand2;
    logic [31:0] alu_result;
    logic [31:0] register_write_data;
    logic Zero;
    logic PCSrc;

    assign instruction_address = PC;
    
    if_id_reg if_id_stage (
        .clk (clk),
        .reset (reset),
         .enable (!hazard_stall),
        .flush (PCSrc),
        .pc_in (PC),
        .instruction_in (instruction),
        .pc_out (if_id_pc),
        .instruction_out (if_id_instruction)
    );

    control control_unit (
        .instruction (if_id_instruction),
        .branch (Branch_id),
        .RegWrite (RegWrite_id),
        .ALUSrc (ALUSrc_id),
        .MemRead (MemRead_id),
        .MemWrite (MemWrite_id),
        .MemtoReg (MemtoReg_id),
        .ALUOp (ALUOp_id)
    );

    register_file registers (
        .clk (clk),
        .write_enable (RegWrite_wb),
        .read_addr1 (if_id_instruction[19:15]),
        .read_addr2 (if_id_instruction[24:20]),
        .write_addr (rd_wb),
        .write_data (register_write_data),
        .read_data1 (read_data1_id),
        .read_data2 (read_data2_id)
    );

    immgen immediate_generator (
        .instruction (if_id_instruction),
        .immediate (immediate_id)
    );

    alu_control alu_decoder (
        .ALUOp (ALUOp_id),
        .instruction (if_id_instruction),
        .alu_control (alu_control_id)
    );

    id_ex_register id_ex (
        .clk (clk),
        .reset (reset),
    .flush (hazard_stall || PCSrc),
        .pc_in (if_id_pc),
        .read_data1_in (read_data1_id),
        .read_data2_in (read_data2_id),
        .immediate_in (immediate_id),
        .rs1_in (if_id_instruction[19:15]),
        .rs2_in (if_id_instruction[24:20]),
        .rd_in (if_id_instruction[11:7]),
        .funct3_in (if_id_instruction[14:12]),
        .alu_control_in (alu_control_id),

        .RegWrite_in (RegWrite_id),
        .MemtoReg_in (MemtoReg_id),
        .MemRead_in (MemRead_id),
        .MemWrite_in (MemWrite_id),
        .ALUSrc_in (ALUSrc_id),
        .Branch_in (Branch_id),

        .pc_out (id_ex_pc),
        .read_data1_out (read_data1_ex),
        .read_data2_out (read_data2_ex),
        .immediate_out (immediate_ex),
        .rs1_out (rs1_ex),
        .rs2_out (rs2_ex),
        .rd_out (rd_ex),
        .funct3_out (funct3_ex),
        .alu_control_out (alu_control_ex),

        .RegWrite_out (RegWrite_ex),
        .MemtoReg_out (MemtoReg_ex),
        .MemRead_out (MemRead_ex),
        .MemWrite_out (MemWrite_ex),
        .ALUSrc_out (ALUSrc_ex),
        .Branch_out (Branch_ex)
    );
    
    
always_comb begin
    case (forward_a)
        2'b10: forwarded_read_data1_ex = alu_result_mem;
        2'b01: forwarded_read_data1_ex = register_write_data;
        default: forwarded_read_data1_ex = read_data1_ex;
    endcase

    case (forward_b)
        2'b10: forwarded_read_data2_ex = alu_result_mem;
        2'b01: forwarded_read_data2_ex = register_write_data;
        default: forwarded_read_data2_ex = read_data2_ex;
    endcase
end


ex_mem_reg ex_mem (
    .clk (clk),
    .reset (reset),

    .alu_result_in (alu_result),
    .write_data_in (forwarded_read_data2_ex),
    .rd_in (rd_ex),
    .funct3_in (funct3_ex),

    .RegWrite_in (RegWrite_ex),
    .MemtoReg_in (MemtoReg_ex),
    .MemRead_in (MemRead_ex),
    .MemWrite_in (MemWrite_ex),

    .alu_result_out(alu_result_mem),
    .write_data_out(write_data_mem),
    .rd_out (rd_mem),
    .funct3_out (funct3_mem),

    .RegWrite_out (RegWrite_mem),
    .MemtoReg_out (MemtoReg_mem),
    .MemRead_out (MemRead_mem),
    .MemWrite_out (MemWrite_mem)
);
   assign alu_operand2 =
    ALUSrc_ex ? immediate_ex : forwarded_read_data2_ex;

alu arithmetic_logic_unit (
    .a (forwarded_read_data1_ex),
    .b (alu_operand2),
    .alu_op (alu_control_ex),
    .result (alu_result),
    .zero (Zero)
);
    
    mem_wb_reg mem_wb (
    .clk (clk),
    .reset (reset),
    
    .read_data_in (memory_read_data),
    .alu_res_in (alu_result_mem),
    .MemtoReg_in (MemtoReg_mem),
    .rd_in (rd_mem),
    .RegWrite_in (RegWrite_mem),
    
    .read_data_out (read_data_wb),
    .alu_res_out (alu_result_wb),
    .MemtoReg_out (MemtoReg_wb),
    .rd_out (rd_wb),
    .RegWrite_out (RegWrite_wb)
    
    
    );

 hazard_unit hazards (
    .ifid_instruction (if_id_instruction),

    .idex_memread (MemRead_ex),
    .idex_rd (rd_ex),
    .idex_rs1 (rs1_ex),
    .idex_rs2 (rs2_ex),

    .exmem_regwrite (RegWrite_mem),
    .exmem_memtoreg (MemtoReg_mem),
    .exmem_rd (rd_mem),

    .memwb_regwrite (RegWrite_wb),
    .memwb_rd (rd_wb),

    .stall (hazard_stall),
    .forward_a (forward_a),
    .forward_b (forward_b)
);

    assign MemRead = MemRead_mem;
    assign MemWrite = MemWrite_mem;
    assign memory_funct3 = funct3_mem;
    assign memory_address = alu_result_mem;
    assign memory_write_data = write_data_mem;

    
    assign register_write_data =
        MemtoReg_wb ? read_data_wb : alu_result_wb;

    assign PCSrc = Branch_ex & Zero;
    assign PC_plus_4 = PC + 32'd4;
    assign branch_target = id_ex_pc + immediate_ex;

always_ff @(posedge clk) begin
    if (reset)
        PC <= 32'b0;
    else if (PCSrc)
        PC <= branch_target;
    else if (!hazard_stall)
        PC <= PC_plus_4;
end

endmodule
