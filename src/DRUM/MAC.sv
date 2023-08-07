`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2019 09:39:19 AM
// Design Name: 
// Module Name: MAC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MAC #( parameter IN_BITWIDTH = 16,
			  parameter OUT_BITWIDTH = 32 )
			( input [IN_BITWIDTH-1 : 0] a_in,
			  input [IN_BITWIDTH-1 : 0] w_in,
			  input [IN_BITWIDTH-1 : 0] sum_in,
			  input en, clk,
			  output logic [OUT_BITWIDTH-1 : 0] out
			);
	
	logic [OUT_BITWIDTH-1:0] mult_out;
	//logic [OUT_BITWIDTH-1:0] sum_temp;
	
	//vedic_16x16 mult (.a(a_in), .b(w_in), .out(mult_out), .enable(en));
	
	drum mult(.a(a_in), .b(w_in), .r(mult_out), .enable(en));
	//adder32_8 apadd(.a(mult_out), .b(sum_in), .sum(sum_temp));
	always@(posedge clk) begin
		if(en) begin
			out <= mult_out+sum_in;
		end
	end
	
endmodule
