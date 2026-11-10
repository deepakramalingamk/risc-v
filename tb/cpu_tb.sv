`timescale 1ns/1ps

module tb_cpu;

    logic clk;
    logic reset;

    logic [31:0] instruction_address;
    logic [31:0] instruction;

    logic MemRead;
    logic MemWrite;
    logic [2:0] memory_funct3;
    logic [31:0] memory_address;
    logic [31:0] memory_write_data;
    logic [31:0] memory_read_data;

    cpu dut (
        .clk (clk),
        .reset (reset),
        .instruction_address (instruction_address),
        .instruction (instruction),
        .MemRead (MemRead),
        .MemWrite (MemWrite),
        .memory_funct3 (memory_funct3),
        .memory_address (memory_address),
        .memory_write_data (memory_write_data),
        .memory_read_data (memory_read_data)
    );

    
instruction_memory #(
    .WORDS(1024),
    .INIT_FILE("program.hex")
) imem (
    .read_addr (instruction_address),
    .instruction (instruction)
);

dmemory #(
    .BYTES(4096)
) dmem (
    .clk (clk),
    .MemWrite (MemWrite),
    .MemRead (MemRead),
    .address (memory_address),
    .write_data (memory_write_data),
    .funct3 (memory_funct3),
    .read_data (memory_read_data)
);
    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, tb_cpu);
    end

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        reset = 1'b1;

        

        @(posedge clk);
        #1 reset = 1'b0;

        
        repeat (7) @(posedge clk);
        #1;

        if (instruction_address !== 32'd28)
            $fatal(1, "PC check failed: expected 28, got %0d",
                   instruction_address);

        
     if ({dmem.mem[3], dmem.mem[2],
     dmem.mem[1], dmem.mem[0]} !== 32'h0000000c)
    $fatal(1, "Store check failed at address 0");

if ({dmem.mem[7], dmem.mem[6],
     dmem.mem[5], dmem.mem[4]} !== 32'h0000000c)
    $fatal(1, "Load/store check failed at address 4");
    
        $display("PASS");
        $finish;
    end

endmodule
