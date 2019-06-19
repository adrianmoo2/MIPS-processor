`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:	03:44:53 02/07/2019
// Design Name:
// Module Name:	alu_control
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
module alu_control(
    clk,
    reset,
    alu_op,
    instruction_5_0,
    alu_out
	);
    
//------Input ports-----
    input [1:0] alu_op;
    input [5:0] instruction_5_0;
    input clk;
    input reset;
//-----Output ports-----
    output [3:0] alu_out;
//-----Input ports data type-----
    wire clk;
    wire reset;
    wire [1:0] alu_op;
    wire [5:0] instruction_5_0;
//-----Output ports data type-----
    reg [3:0] alu_out;

always @(posedge clk)
begin: alu_control
    
    /*if (alu_op == 2'b00 && instruction_5_0 == 6'bxxxxxx)
   	 alu_out = 4'b0010;
    else if (alu_op == 2'bx1 && instruction_5_0 == 6'bxxxxxx)
   	 alu_out = 4'b0110;
    else if (alu_op == 2'b1x && instruction_5_0 == 6'bxx0000)
   	 alu_out = 4'b0010; //6'bxx0000
    else if (alu_op == 2'b1x && instruction_5_0 == 6'bxx0010)
   	 alu_out = 4'b0110; //6'bxx0010
    else if (alu_op == 2'b1x && instruction_5_0 == 6'bxx0100)
   	 alu_out = 4'b0000; //6'bxx0100
    else if (alu_op == 2'b1x && instruction_5_0 == 6'bxx0101)
   	 alu_out = 4'b0001; //6'bxx0101
    else if (alu_op == 2'b1x && instruction_5_0 == 6'bxx1010)
   	 alu_out = 4'b0111; //6'bxx1010
    else if (alu_op == 2'b1x && instruction_5_0 == 6'bxx0111)
   	 alu_out = 4'b1100; //6'bxx0111
    else
   	 alu_out = 4'b0000;*/
    case(alu_op)
   	 2'b00:
   	 begin
   		 alu_out = 4'b0010; //lw & sw
   	 end
   	 2'b01:
   	 begin
   		 alu_out = 4'b0110; //beq
   	 end
   	 2'b10:
   	 begin
   		 case (instruction_5_0)
   			 6'b100000:
   			 begin
   				 alu_out = 4'b0010; //add
   			 end
   			 6'b100010:
   			 begin
   				 alu_out = 4'b0110; //sub
   			 end
   			 6'b100100:
   			 begin
   				 alu_out = 4'b0000; //and
   			 end
   			 6'b100101:
   			 begin
   				 alu_out = 4'b0001; //or
   			 end
   			 6'b100111:
   			 begin
   				 alu_out = 4'b1100; //nor
   			 end
   			 6'b101010:
   			 begin
   				 alu_out = 4'b0111; //set on less than
   			 end
   			 default:
   			 begin
   				 alu_out = 4'b0000;
   			 end
   		 endcase
   	 end
   	 default:
   	 begin
   		 alu_out = 4'bxxxx;
   	 end
    endcase
   	 
end

endmodule



