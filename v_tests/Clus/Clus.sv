// verilator lint_off TIMESCALEMOD
// verilator lint_off CASEINCOMPLETE
// verilator lint_off WIDTH
module Clus#(
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
	)
	(
  input clk,
  input reset,
	
	input start,

	output load_done,
	
	//logic for GLB cluster
	input read_req_psum,

  input write_en_iact,
	input write_en_wght,

	input load_spad_ctrl_wght,
	input load_spad_ctrl_iact,
		
    input [ADDR_BITWIDTH-1 : 0] r_addr_psum,
	output logic [DATA_BITWIDTH-1 : 0] r_data_psum,
	
    input [ADDR_BITWIDTH-1 : 0] w_addr_iact,
	input [ADDR_BITWIDTH-1 : 0] w_addr_wght,

    input [DATA_BITWIDTH-1 : 0] w_data_iact,
	input [DATA_BITWIDTH-1 : 0] w_data_wght,
  output logic write_psum_ctrl,

	output [DATA_BITWIDTH-1:0]pe_out[0:X_dim-1]
	
	);

  logic [DATA_BITWIDTH-1:0]w_data_psum;
  logic [ADDR_BITWIDTH-1:0]w_addr_psum;
  logic load_en_wght;
  logic [DATA_BITWIDTH-1:0]filt_in;
  logic read_req_wght;
  logic [ADDR_BITWIDTH-1:0]r_addr_wght;
  logic load_en_act;
  logic [DATA_BITWIDTH-1:0]act_in;
  logic read_req_iact;
  logic [ADDR_BITWIDTH-1:0]r_addr_iact;
  logic [DATA_BITWIDTH-1:0]r_data_glb_wght;
  logic [DATA_BITWIDTH-1:0]r_data_glb_iact;
  logic write_en_psum; 
  logic [DATA_BITWIDTH-1:0] r_data_spad_psum[0:kernel_size-1];


	//GLB cluster initialization
	GLB_cluster 
			#(	.DATA_BITWIDTH(DATA_BITWIDTH),
				.ADDR_BITWIDTH(ADDR_BITWIDTH),
				.NUM_GLB_IACT(NUM_GLB_IACT),
				.NUM_GLB_PSUM(NUM_GLB_PSUM),
				.NUM_GLB_WGHT(NUM_GLB_WGHT)
			)
	GLB_cluster_0
			(
				.clk(clk),   //TestBench/Controller
				.reset(reset),  //TestBench/Controller
				
				//Signals for reading from GLB
				.read_req_iact(read_req_iact),
				.read_req_psum(read_req_psum), //Read by testbench/controller
				.read_req_wght(read_req_wght),
				
			    .r_data_iact(r_data_glb_iact),
			    .r_data_psum(r_data_psum), //Read by testbench/controller
				.r_data_wght(r_data_glb_wght),
				
				.r_addr_iact(r_addr_iact),
			    .r_addr_psum(r_addr_psum), //testbench for reading final psums
				.r_addr_wght(r_addr_wght),

				
				//Signals for writing to GLB
			    .w_addr_iact(w_addr_iact), //testbench for writing
			    .w_addr_psum(w_addr_psum),
				.w_addr_wght(w_addr_wght), //testbench for writing
 
			    .w_data_iact(w_data_iact), //testbench for writing
			    .w_data_psum(w_data_psum),
				.w_data_wght(w_data_wght), //testbench for writing

				.write_en_iact(write_en_iact), //testbench for writing
				.write_en_psum(write_en_psum),
				.write_en_wght(write_en_wght) //testbench for writing
			
			);

			
	
	//Router Cluster Instantiation
	router_cluster#(.DATA_BITWIDTH(DATA_BITWIDTH),
	                .ADDR_BITWIDTH_GLB(ADDR_BITWIDTH_GLB),
	                .ADDR_BITWIDTH_SPAD(ADDR_BITWIDTH_SPAD),

	                .kernel_size(kernel_size),
	                .act_size(act_size),

	                .NUM_ROUTER_PSUM(NUM_ROUTER_PSUM),
	                .NUM_ROUTER_IACT(NUM_ROUTER_IACT),
	                .NUM_ROUTER_WGHT(NUM_ROUTER_WGHT),

	                .A_READ_ADDR(A_READ_ADDR), 
	                .A_LOAD_ADDR(A_LOAD_ADDR),

	                .W_READ_ADDR(W_READ_ADDR), 
	                .W_LOAD_ADDR(W_LOAD_ADDR),

	                .PSUM_READ_ADDR(PSUM_READ_ADDR),
	                .PSUM_LOAD_ADDR(PSUM_LOAD_ADDR)
					)
	router_cluster_0
					(
					.clk(clk),  //TestBench/Controller
					.reset(reset),  //TestBench/Controller
					
					//Signals for activation router
					.r_data_glb_iact(r_data_glb_iact),
					.r_addr_glb_iact(r_addr_iact),
					.read_req_glb_iact(read_req_iact),

					.w_data_spad_iact(act_in),
					.load_en_spad_iact(load_en_act),
					
					.load_spad_ctrl_iact(load_spad_ctrl_iact), //TestBench/Controller
					
					
					//Signals for weight router
					.r_data_glb_wght(r_data_glb_wght),
					.r_addr_glb_wght(r_addr_wght),
					.read_req_glb_wght(read_req_wght),
					
					.w_data_spad_wght(filt_in),
					.load_en_spad_wght(load_en_wght),

					.load_spad_ctrl_wght(load_spad_ctrl_wght), //TestBench/Controller

					
					//Signals for psum router
					.r_data_spad_psum(r_data_spad_psum),
					
					.w_addr_glb_psum(w_addr_psum),
					.write_en_glb_psum(write_en_psum),
					.w_data_glb_psum(w_data_psum),
					
					.write_psum_ctrl(write_psum_ctrl) //Connected to compute done of PE
					);
	

//Declarations for PE_cluster
				

	
//PE_cluster Instantiation
	PE_cluster #(
					.DATA_WIDTH(DATA_WIDTH),
					.ADDR_WIDTH(ADDR_WIDTH),
					
					.kernel_size(kernel_size),
					.act_size(act_size),
					
					.X_dim(X_dim),
					.Y_dim(Y_dim)
    			)
	pe_cluster_0
    			(
					.clk(clk), 	   //TestBench/Controller
				    .reset(reset), //TestBench/Controller
					.start(start), //TestBench/Controller
					
				  .act_in(act_in),
					.filt_in(filt_in),
					
					.load_en_wght(load_en_wght),
					.load_en_act(load_en_act),
					
          .pe_out(r_data_spad_psum),
					.compute_done(write_psum_ctrl),
					.load_done(load_done) //TestBench/Controller
    			);

assign pe_out = router_cluster_0.r_data_spad_psum;
endmodule
