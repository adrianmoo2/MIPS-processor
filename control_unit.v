`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:	01:38:51 02/07/2019
// Design Name:
// Module Name:	control_unit
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module control_unit  (
   	 clk,
   	 reset,
   	 instr_op,
   	 reg_dst,
   	 branch,
   	 mem_read,
   	 mem_to_reg,
   	 alu_op,
   	 mem_write,
   	 alu_src,
   	 reg_write
	);
    
//------Input ports-----
    input [5:0] instr_op;
    input clk;
    input reset;
//------Output ports-----
    output reg_dst;
    output branch;
    output mem_read;
    output mem_to_reg;
    output [1:0] alu_op;
    output mem_write;
    output alu_src;
    output reg_write;
//-----Input ports data type-----
    wire clk;
    wire reset;
    wire [5:0] instr_op;
//-----Output ports data type-----
    reg reg_dst;
    reg branch;
    reg mem_read;
    reg mem_to_reg;
    reg [1:0] alu_op;
    reg mem_write;
    reg alu_src;
    reg reg_write;
    
always @ (posedge clk)
begin: LAB03
    case (instr_op)
   	 6'b000000: //R-format
   		 begin
   			 reg_dst = 1'b1;
   			 alu_src = 1'b0;
   			 mem_to_reg = 1'b0;
   			 reg_write = 1'b1;
   			 mem_read = 1'b0;
   			 mem_write = 1'b0;
   			 branch = 1'b0;
   			 alu_op = 2'b10;
   		 end
   	 6'b100011: //lw
   		 begin
   			 reg_dst = 1'b0;
   			 alu_src = 1'b1;
   			 mem_to_reg = 1'b1;
   			 reg_write = 1'b1;
   			 mem_read = 1'b1;
   			 mem_write = 1'b0;
   			 branch = 1'b0;
   			 alu_op = 2'b00;
   		 end
   	 6'b101011: //sw
   		 begin
   			 reg_dst = 1'bx;
   			 alu_src = 1'b1;
   			 mem_to_reg = 1'bx;
   			 reg_write = 1'b0;
   			 mem_read = 1'b0;
   			 mem_write = 1'b1;
   			 branch = 1'b0;
   			 alu_op = 2'b00;
   		 end
   	 6'b000100: //beq
   		 begin
   			 reg_dst = 1'bx;
   			 alu_src = 1'b0;
   			 mem_to_reg = 1'bx;
   			 reg_write = 1'b0;
   			 mem_read = 1'b0;
   			 mem_write = 1'b0;
   			 branch = 1'b1;
   			 alu_op = 2'b01;
   		 end
   	 6'b001000: //imm
   		 begin
   			 reg_dst = 1'b0;
   			 alu_src = 1'b1;
   			 mem_to_reg = 1'b0;
   			 reg_write = 1'b1;
   			 mem_read = 1'b0;
   			 mem_write = 1'b0;
   			 branch = 1'b0;
   			 alu_op = 2'b00;
   		 end
   	 default: begin
   		 reg_dst = 1'b0;
   		 alu_src = 1'b0;
   		 mem_to_reg = 1'b0;
   		 reg_write = 1'b0;
   		 mem_read = 1'b0;
   		 mem_write = 1'b0;
   		 branch = 1'b0;
   		 alu_op = 2'b00;
   	 end
    endcase
end
    
endmodule



