`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

`define WORD_SIZE 32

module cs161_datapath(
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
   /* prog_count ,  
    instr_opcode ,  
    reg1_addr   ,  
    reg1_data  ,   
    reg2_addr  ,   
    reg2_data  ,   
    write_reg_addr ,
    write_reg_data*/
    );

 input wire  clk ; 
 input wire  rst ;
 
 output reg[5:0] instr_op ;
 output reg[5:0] funct  ;  
 
 input wire   reg_dst  ;
 input wire   branch   ;
 input wire   mem_read ;
 input wire   mem_to_reg ;
 input wire[3:0] alu_op  ;  
 input wire   mem_write ;
 input wire   alu_src   ; 
 input wire   reg_write  ;
 
// ----------------------------------------------
// Debug Signals
// ----------------------------------------------
 
/* 
 output wire[`WORD_SIZE-1:0]  prog_count ;
 output wire[5:0] instr_opcode   ;  
 output wire[4:0] reg1_addr     ;   
 output wire[`WORD_SIZE-1:0] reg1_data ;
 output wire[4:0] reg2_addr   ;   
 output wire[`WORD_SIZE-1:0] reg2_data ;
 output wire[4:0] write_reg_addr  ;
 output wire[`WORD_SIZE-1:0] write_reg_data ; 
 */
 
 /*
 alu alu_inst( alu_control_in,  channel_a_in , channel_b_in , zero_out , alu_result_out  );
 alu_control alu_control_inst(clk, reset,alu_op, instruction_5_0, alu_out);
 cpu_registers cpu_registers_inst(clk, rst, reg_write , read_register_1 , read_register_2, write_register, write_data,  read_data_1, read_data_2);
 cpumemory cpumemory_inst(clk, rst, instr_read_address, instr_instruction, data_mem_write, data_address, data_write_data, data_read_data);
 control_unit control_unit_inst  (clk, reset,instr_op,reg_dst_cu, branch_cu, mem_read_cu, mem_to_reg_cu, alu_op_cu, mem_write_cu, alu_src_cu, reg_write_cu);
 gen_register gen_register_inst( clk, rst, write_en, 	data_in, data_out );
 mux_2_1 mux_2_1_inst( select_in, datain1, datain2, data_out   );
*/

// Insert your solution below here.
always @(posedge clk)
begin: DATAPATH
	if ((reg_dst == 1'b1) && (alu_src == 1'b0) && (mem_to_reg == 1'b0) && (reg_write == 1'b1) && (mem_read == 1'b0) && (mem_write == 1'b0) && (branch == 1'b0)) begin
		instr_op = 6'b000000; //r-type
	end else if ((reg_dst == 1'b0) && (alu_src == 1'b1) && (mem_to_reg == 1'b1) && (reg_write == 1'b1) && (mem_read == 1'b1) && (mem_write == 1'b0) && (branch == 1'b0)) begin
		instr_op = 6'b100011; //lw
	end else if ((reg_dst == 1'bx) && (alu_src == 1'b0) && (mem_to_reg == 1'b0) && (reg_write == 1'b1) && (mem_read == 1'b0) && (mem_write == 1'b0) && (branch == 1'b0)) begin
		instr_op = 6'b101011; //sw
	end else if ((reg_dst == 1'bx) && (alu_src == 1'b0) && (mem_to_reg == 1'bx) && (reg_write == 1'b0) && (mem_read == 1'b0) && (mem_write == 1'b0) && (branch == 1'b1)) begin
		instr_op = 6'b000100; //beq
	end else if ((reg_dst == 1'b0) && (alu_src == 1'b1) && (mem_to_reg == 1'b0) && (reg_write == 1'b1) && (mem_read == 1'b0) && (mem_write == 1'b0) && (branch == 1'b0)) begin
		instr_op = 6'b001000; //imm
	end
	
	case(alu_op)
		4'b0010:
			begin
				if ((instr_op) == 6'b100011 || (instr_op) == 6'b101011)  
					funct = 6'bxxxxxx; //lw and sw
				else if ((instr_op) == 6'b100000)
					funct = 6'b100000; //add
				else
					funct = 6'b000000;
			end
		4'b0110:
		begin
			if ((instr_op) == 6'b000100)
				funct = 6'bxxxxxx; //beq
			else
				funct = 6'b100010; //sub
		end
		4'b0000:
		begin
			funct = 6'b100100; //and
		end
		4'b0001:
		begin
			funct = 6'b100101; //or
		end
		4'b1100:
		begin
			funct = 6'b100111; //nor
		end
		4'b0111:
		begin
			funct = 6'b101010; //set on less than
		end
		default: $display("default");
	endcase
end



endmodule


