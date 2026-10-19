module cpu (
    input  logic        clk,
    input  logic        reset,


    output logic [31:0] instruction_address,
    input  logic [31:0] instruction,


    output logic       MemRead,
    output logic MemWrite,
    output logic [2:0]  memory_funct3,
    output logic [31:0] memory_address,
    output logic [31:0] memory_write_data,
    input  logic [31:0] memory_read_data
);

    logic [31:0] PC;
    logic [31:0] next_PC;
    logic [31:0] PC_plus_4;
    logic [31:0] branch_target;

    logic Branch;
    logic PCSrc;
    logic RegWrite;
    logic ALUSrc;
    logic MemtoReg;
    logic [1:0] ALUOp;

    logic [31:0] read_data1;
    logic [31:0] read_data2;
    logic [31:0] immediate;
    logic [31:0] alu_operand2;
    logic [31:0] alu_result;
    logic [31:0] register_write_data;
    logic [3:0]  alu_control_signal;
    logic        Zero;


    assign instruction_address = PC;


    control control (
        .instruction   (instruction),
        .branch   (Branch),
        .RegWrite (RegWrite),
        .ALUSrc   (ALUSrc),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .MemtoReg (MemtoReg),
        .ALUOp    (ALUOp)
    );


    assign PCSrc = Branch & Zero;

    register_file registers (
        .clk          (clk),
        .write_enable (RegWrite),
        .read_addr1   (instruction[19:15]),
        .read_addr2   (instruction[24:20]),
        .write_addr   (instruction[11:7]),
        .write_data   (register_write_data),
        .read_data1   (read_data1),
        .read_data2   (read_data2)
    );

    immgen immediate_generator (
        .instruction (instruction),
        .immediate   (immediate)
    );


    alu_control alu_decoder (
        .ALUOp               (ALUOp),
        .instruction          (instruction),
        .alu_control         (alu_control_signal)
    );

    assign alu_operand2 = ALUSrc ? immediate : read_data2;

    alu arithmetic_logic_unit (
        .a      (read_data1),
        .b      (alu_operand2),
        .alu_op (alu_control_signal),
        .result (alu_result),
        .zero   (Zero)
    );

   
    assign memory_address    = alu_result;
    assign memory_write_data = read_data2;
    assign memory_funct3     = instruction[14:12];

 
    assign register_write_data =
        MemtoReg ? memory_read_data : alu_result;


    assign PC_plus_4    = PC + 32'd4;
    assign branch_target = PC + immediate;
    assign next_PC      = PCSrc ? branch_target : PC_plus_4;

    always_ff @(posedge clk) begin
        if (reset)
            PC <= 32'b0;
        else
            PC <= next_PC;
    end

endmodule
