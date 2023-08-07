`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2023 23:30:11
// Design Name: 
// Module Name: vedic16x16_tb
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


module vedic16x16_tb();

reg [15:0] a,b;
reg enable;
//reg clk;
wire [31:0] out;

vedic_16x16 dut1 (.a(a), .b(b), .out(out), .enable(enable));

//always #5 clk = ~clk;
initial begin

//clk <= 0;
enable = 0;
a = 32;
b = 65534;
#10 enable = 1;
#10 enable = 0;
a = 100;
b = 1;
#10 enable =1;
#10 enable =0;
a=65534;
b=65534;
#10 enable = 1;


end

endmodule
