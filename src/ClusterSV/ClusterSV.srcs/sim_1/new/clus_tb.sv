`timescale 1ns / 1ps

module clus_tb();

    logic clk_n, clk_p, reset, start, read_req_psum, load_spad_ctrl_wght, load_spad_ctrl_iact, r_addr_psum, r_data_psum, write_psum_ctrl;

    top dut (.clk_n(clk_n), 
            .clk_p(clk_p), 
            .reset(reset),
            .start(start),	
            .read_req_psum(read_req_psum),
            .load_spad_ctrl_wght(load_spad_ctrl_wght),
            .load_spad_ctrl_iact(load_spad_ctrl_iact),
            .r_addr_psum(r_addr_psum),
            .r_data_psum(r_data_psum),
            .write_psum_ctrl(write_psum_ctrl));

    initial begin
        reset = 1; #20;
        reset = 0;
    end

    always begin  
       clk_p = 0; clk_n = 1; #10; 
       clk_p = 1; clk_n = 0; #10; 
    end
    
    initial begin
        load_spad_ctrl_wght = 0;
        load_spad_ctrl_iact = 0;
        #3000;
        load_spad_ctrl_wght = 1; 
        load_spad_ctrl_iact = 1; 
    end
    
endmodule

