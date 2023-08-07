`timescale 1ns / 1ps

module top#(
    parameter DATA_BITWIDTH = 16,
    parameter ADDR_BITWIDTH = 10,
    
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 9,
    
    // GLB Cluster parameters. This TestBench uses only 1 of each
    parameter NUM_GLB_IACT = 1,
    parameter NUM_GLB_PSUM = 1,
    parameter NUM_GLB_WGHT = 1,
    
    parameter ADDR_BITWIDTH_GLB = 10,
    parameter ADDR_BITWIDTH_SPAD = 9,
    
    parameter NUM_ROUTER_PSUM = 1,
    parameter NUM_ROUTER_IACT = 1,
    parameter NUM_ROUTER_WGHT = 1,
            
    parameter int kernel_size = 3,
    parameter int act_size = 12,
    
    parameter int X_dim = 3,
    parameter int Y_dim = 3,
    
    parameter W_READ_ADDR = 0, 
    parameter A_READ_ADDR = 0,
  
    parameter W_LOAD_ADDR = 0,  
    parameter A_LOAD_ADDR = 0,
    
    parameter PSUM_READ_ADDR = 0,
	parameter PSUM_LOAD_ADDR = 0
	)(
    input clk_n,
    input clk_p,
    
    input reset,
	input start,	
	
	input read_req_psum,

	input load_spad_ctrl_wght,
	input load_spad_ctrl_iact,
		
    input [ADDR_BITWIDTH-1 : 0] r_addr_psum,
	output logic [DATA_BITWIDTH-1 : 0] r_data_psum,
	
    output logic write_psum_ctrl);
	
	logic clk;
	
	  
    IBUFDS #(
    .DIFF_TERM("FALSE"), // Differential Termination
    .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
    .IOSTANDARD("DEFAULT") // Specify the input I/O standard
    ) IBUFDS_inst (
    .O(clk), // Buffer output
    .I(clk_p), // Diff_p buffer input (connect directly to top-level port)
    .IB(clk_n) // Diff_n buffer input (connect directly to top-level port)
    );
    
      logic load_done_wght, load_done_iact;
      logic [ADDR_BITWIDTH-1 : 0] w_addr_iact;
      logic [ADDR_BITWIDTH-1 : 0] w_addr_wght;
      logic [DATA_BITWIDTH-1 : 0] w_data_iact;
      logic [DATA_BITWIDTH-1 : 0] w_data_wght;
      
      logic write_en_iact;
      logic write_en_wght;
      logic [7:0] cout_iact;                                                                                                                                                                                                                                                                                                                                                                                                                                         
      logic [7:0] cout_wght;
      
      initial begin
        w_addr_iact <= 0;
        w_addr_wght <= 0;
        w_data_iact <= 0;
        w_data_wght <= 0;
        cout_iact <= 0;
        cout_wght <= 0;
      end
      
      always @(posedge clk) begin
          if(reset) begin
                w_addr_iact <= 0;
                w_addr_wght <= -1;
                w_data_iact <= 0;
                w_data_wght <= 0;
                cout_iact <= 0;
                cout_wght <= 0;
          end else begin
              if(cout_wght<=(kernel_size*kernel_size-1)) begin
                  write_en_wght <= 1;
                  w_addr_wght <= w_addr_wght + 1;
                  w_data_wght <= 1;
                  cout_wght <= cout_wght + 1;
              end else begin
                  write_en_wght <=0;
              end
              
              if(cout_iact<=(act_size*act_size-1)) begin
                  write_en_iact <= 1;
                  w_addr_iact <= w_addr_iact + 1;
                  w_data_iact <= 1;
                  cout_iact <= cout_iact + 1;
              end else begin
                 write_en_iact <=0;
              end
          end
      end
      
      Clus clus(.clk(clk),//
                .reset(reset),//
                .start(start), //
                .load_done_wght(load_done_wght),
                .load_done_iact(load_done_iact),
                .read_req_psum(read_req_psum),//
                .write_en_iact(write_en_iact),
                .write_en_wght(write_en_wght),
                .load_spad_ctrl_wght(load_spad_ctrl_wght),//
                .load_spad_ctrl_iact(load_spad_ctrl_iact),//
                .r_addr_psum(r_addr_psum),//DIP
                .r_data_psum(r_data_psum),//LED
                .w_addr_iact(w_addr_iact),
                .w_addr_wght(w_addr_wght),
                .w_data_iact(w_data_iact),
                .w_data_wght(w_data_wght),
                .write_psum_ctrl(write_psum_ctrl));
     
endmodule
