`timescale 1ns / 1ps

include "cpu_constant_library.v";

module cs161_processor(
    clk ,
    rst ,   
	 // Debug signals 
    prog_count     , 
    instr_opcode   ,
    reg1_addr      ,
    reg1_data      ,
    reg2_addr      ,
    reg2_data      ,
    write_reg_addr ,
    write_reg_data  
    );

input wire clk ;
input wire rst ;
    
// Debug Signals

output reg[31:0] prog_count     ; 
output wire[5:0]  instr_opcode   ;
output wire[4:0]  reg1_addr      ;
output wire[31:0] reg1_data      ;
output wire[4:0]  reg2_addr      ;
output wire[31:0] reg2_data      ;
output wire[4:0]  write_reg_addr ;
output wire[31:0] write_reg_data ;

//-----Added functionalities-----
wire signed[31:0] pc_next, pc2;
wire [31:0] instruction;
wire reg_dst, mem_to_reg, jump, branch, mem_read, mem_write, alu_src, reg_write;
wire [1:0] alu_op;
wire [31:0] sign_ext_im, read_data2, zero_ext_im, imm_ext;
wire JRCOntrol;
wire [3:0] ALU_Control;
wire [31:0] ALU_out;
wire zero_flag;
wire signed[31:0] im_shift_2, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr; 
wire beq_control;
wire [30:0] jump_shift_2;
wire [31:0] mem_read_data;
wire[31:0] no_sign_ext;
wire sign_or_zero;

 //alu alu_inst( alu_control_in,  channel_a_in , channel_b_in , zero_out , alu_result_out  );
 //alu_control alu_control_inst(clk, reset,alu_op, instruction_5_0, alu_out);
 //cpu_registers cpu_registers_inst(clk, rst, reg_write , read_register_1 , read_register_2, write_register, write_data,  read_data_1, read_data_2);
 //cpumemory cpumemory_inst(clk, rst, instr_read_address, instr_instruction, data_mem_write, data_address, data_write_data, data_read_data);
 //control_unit control_unit_inst  (clk, reset,instr_op,reg_dst_cu, branch_cu, mem_read_cu, mem_to_reg_cu, alu_op_cu, mem_write_cu, alu_src_cu, reg_write_cu);
 gen_register gen_register_inst( clk, rst, write_en, 	data_in, data_out );
 //mux_2_1 mux_2_1_inst( select_in, datain1, datain2, data_out   );


cs161_datapath cs161_datapath(
    clk ,     
    rst ,     
    instr_op ,
    funct   , 
    reg_dst , 
    branch  , 
    mem_read , 
    mem_to_reg ,
    alu_op    , 
    mem_write  ,
    alu_src  ,  
    reg_write ,    
	 
    // Debug Signals
    /*prog_count ,  
    instr_opcode ,  
    reg1_addr   ,  
    reg1_data  ,   
    reg2_addr  ,   
    reg2_data  ,   
    write_reg_addr ,
    write_reg_data*/
    );

always @ (posedge clk or posedge rst)
begin: CS161_PROCESSOR
	if (rst)
		prog_count = 0;
	else
		prog_count = pc_next;
end

assign pc2 = prog_count + 32'd4;

//Instruction memory (fetch instruction)
cpumemory cpumemory_inst(.clk(clk), 
.rst(rst), 
.instr_read_address(prog_count[8:1]), 
.instr_instruction(instruction));

//Jump shift left 2
//assign jump_shift_2 = {instruction[28:0], 2'b00};

//control unit
control_unit control_unit_inst(.clk(clk), 
.reset(rst), 
.instr_op(instruction[31:26]), 
.reg_dst(reg_dst),
.mem_to_reg(mem_to_reg), 
.alu_op(alu_op), 
.branch(branch), 
.mem_read(mem_read), 
.mem_write(mem_write), 
.alu_src(alu_src), 
.reg_write(reg_write));

//registers
assign reg_1_addr = instruction[25:21];
assign reg_2_addr = instruction[20:16];

cpu_registers cpu_registers_inst(.clk(clk), 
.rst(rst), 
.write_register(write_reg_addr),
.write_data(write_reg_data),
.read_register_1(reg_1_addr),
.read_data_1(reg_1_data),
.read_register_2(reg_2_addr),
.read_data_2(reg_2_data),
.reg_write(reg_write));
 
 //sign extend
 assign sign_ext_im = {{16{instruction[15]}}, instruction[15:0]};
 assign zero_ext_im = {{16{1'b0}}, instruction[15:0]};
 assign imm_ext = sign_ext_im;
 
 //alu_control
alu_control alu_control_inst(.clk (clk), 
.reset (reset),
.alu_op(alu_op), 
.instruction_5_0(instruction[5:0]), 
.alu_out(ALU_Control));

//mux alu_src
mux_2_1 mux_2_1_inst( .select_in(alu_src), 
.datain1 (imm_ext), 
.datain2 (reg2_data), 
.data_out (read_data2));

//ALU
alu alu_inst( .alu_control_in (ALU_Control),  
.channel_a_in (reg_1_data), 
.channel_b_in (read_data2), 
.zero_out (zero_flag) , 
.alu_result_out (ALU_Out));


//immediate shift 2
assign im_shift_2 = {imm_ext[29:0], 2'b00};

//
assign no_sign_ext = ~(im_shift_2) + 1'b1;


//PC beq add
assign PC_beq = (im_shift_2[31] == 1'b1) ? (pc2 - no_sign_ext) : (pc2 + im_shift_2);

//Beq control
assign beq_control = branch & zero_flag;

//PC_beq
assign PC_4beq = (beq_control == 1'b1) ? PC_beq : pc2;

//PC_next
assign pc_next = PC_4beq;

cpumemory cpumemory_inst_datamem(
.data_mem_write (mem_write), 
.data_address (ALU_out), 
.data_write_data(reg_2_data), 
.data_read_data (mem_read_data));

//writeback mux
mux_2_1 mux_2_1_writeback( .select_in(mem_to_reg), 
.datain1 (mem_read_data), 
.datain2 (ALU_Out), 
.data_out (write_reg_data));


endmodule
