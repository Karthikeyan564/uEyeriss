// verilator lint_off TIMESCALEMOD
module PE_cluster #(parameter DATA_WIDTH = 16,
					parameter ADDR_WIDTH = 9,
					
					parameter X_dim = 3,
					parameter Y_dim = 3,
   
					parameter kernel_size = 3,
					parameter act_size = 5,
					
					parameter W_READ_ADDR = 0,  
					parameter A_READ_ADDR = 100,
					
					parameter W_LOAD_ADDR = 0,  
					parameter A_LOAD_ADDR = 100,
					
					parameter PSUM_ADDR = 500
					)
					( 
					input clk, reset,
					input [DATA_WIDTH-1:0] act_in,
					input [DATA_WIDTH-1:0] filt_in,
					input load_en_wght, load_en_act,
					input start,
					output logic [DATA_WIDTH-1:0] pe_out[0 : X_dim-1],
					output logic compute_done,
			        output logic load_done_wght,
                    output logic load_done_iact);
		
		logic [DATA_WIDTH-1:0] psum_out[0 : X_dim*Y_dim-1];
		
		logic cluster_done[0 : X_dim*Y_dim-1];
		logic cluster_load_done_wght[0 : X_dim*Y_dim-1];
		logic cluster_load_done_iact[0 : X_dim*Y_dim-1];
		
		generate
		genvar i;
		for(i=0; i<X_dim; i++) 
			begin:gen_X
				genvar j;
				for(j=0; j<Y_dim; j++)
					begin:gen_Y
					
						PE #( 	.DATA_WIDTH(DATA_WIDTH),
								.ADDR_WIDTH(ADDR_WIDTH),
								.kernel_size(kernel_size),
								.act_size(act_size),
								.W_READ_ADDR(W_READ_ADDR + kernel_size*j),  
								.A_READ_ADDR(A_READ_ADDR + act_size*j + i),
								.W_LOAD_ADDR(W_LOAD_ADDR),  
								.A_LOAD_ADDR(A_LOAD_ADDR),
								.PSUM_ADDR(PSUM_ADDR),
                .X_dim(X_dim),
                .Y_dim(Y_dim)
							)
						pe (	
								.clk(clk),
								.reset(reset),
								.act_in(act_in),
								.filt_in(filt_in),
//								.load_en(load_en),
								.load_en_wght(load_en_wght),
								.load_en_act(load_en_act),
								.start(start),
								.pe_out(psum_out[i*Y_dim+j]),
								.compute_done(cluster_done[i*Y_dim+j]),
								.load_done_wght(cluster_load_done_wght[i*Y_dim+j]),
								.load_done_iact(cluster_load_done_iact[i*Y_dim+j])
							);
					
					end
			end
		endgenerate
		
    assign pe_out[0] = reset? 0 : psum_out[0] + psum_out[1] + psum_out[2];
    assign pe_out[1] = reset? 0 : psum_out[3] + psum_out[4] + psum_out[5];
    assign pe_out[2] = reset? 0 : psum_out[6] + psum_out[7] + psum_out[8];
  /*   genvar j; */
  /*   generate */
  /*     for(i=0; i<X_dim; i++) begin */
  /*       for(j=0; j<Y_dim; j++) begin */
  /*          pe_out[i] = pe_out[i] + psum_out[Y_dim*i+j]; */
  /*         ha kk(pe_out[i],psum_out[Y_dim*i+j],pe_out[i]); */
  /*       end */
  /*     end */
  /* endgenerate */



		
		assign compute_done = cluster_done[0];
		assign load_done_wght = cluster_load_done_wght[0];
		assign load_done_iact = cluster_load_done_iact[0];
			  
endmodule
