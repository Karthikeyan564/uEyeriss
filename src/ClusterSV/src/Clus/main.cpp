// DESCRIPTION: Verilator: Verilog Clus module Test
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2023 by Karthikeyan Renga Rajan.
// SPDX-License-Identifier: CC0-1.0
//======================================================================

// For std::unique_ptr
#include <memory>
#include <bits/stdc++.h>

// Include common routines
#include <verilated.h>
#include "verilated_fst_c.h"
#include "verilated_vpi.h"

// Include model header, generated from Verilating "top.v"
#include "VClus.h"

//For IO routine
#include <iostream>

template<class module> class testbench {
    VerilatedFstC* trace = new VerilatedFstC;
    bool getDataNextCycle;

    public:
        const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
        const std::unique_ptr<VClus> core{new VClus{contextp.get(), "Clus"}};
        bool loaded = false;

        testbench() {
            Verilated::traceEverOn(true);
            Verilated::mkdir("logs");
            contextp->traceEverOn(true);
            core->trace(trace, 99);
            trace->open("logs/dump.fst");


            core->clk          = 0;

            core->reset        = 1;
            this->wait(3);
            core->reset        = 0;
            core->start        = 0;
        }

        ~testbench(void) {
            core->final();
            trace->close();
            trace = NULL;
        }

        virtual void tick(void) {

            contextp->timeInc(1); 
            core->clk = !core->clk;
            core->eval();
            // VerilatedVpi::callValueCbs();
            trace->dump(contextp->time());
            trace->flush();
        }

        virtual bool done(void) {
            return (Verilated::gotFinish());
        }

        void wait(int time){
            for (int i = 0; i < time; i++) {
                this->tick();
            }
        }
};

// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

int main(int argc, char** argv) {
    // Prevent unused variable warnings
    if (false && argc && argv) {}

    Verilated::commandArgs(argc, argv);
    auto *core = new testbench<VClus>;
    const int kernel_size = 3;
    const int act_size = 12;

    int data,addr;

    std::cout<<"----- Loading Begins: Weights -----\n\n";
    core->core->write_en_wght = 1;
    addr=0;
    FILE * kernel_1 = fopen("/home/karthikeyan/bachelor_thesis/uEyeriss/tests/kernel_5x5.txt", "r");
    for(int i=1; i<=kernel_size*kernel_size; i++){
        fscanf(kernel_1, "%d", & data);
        core->core->w_addr_wght = addr;
        core->core->w_data_wght = data;
        addr++;
        core->wait(2);
    }
    core->core->write_en_wght = 0;
    fclose(kernel_1);

    std::cout<<"----- Loading Begins: Activations -----\n\n";
    core->core->write_en_iact = 1;
    addr=0;
    FILE * act_1 = fopen("/home/karthikeyan/bachelor_thesis/uEyeriss/tests/act_7x7.txt", "r");
    for(int i=1; i<=act_size*act_size; i++){
        fscanf(act_1, "%d", & data);
        core->core->w_addr_iact = addr;
        core->core->w_data_iact = data;
        addr++;
        core->wait(2);
    } 
    core->core->write_en_iact = 0;
    fclose(act_1);

    core->wait(1);
    core->core->load_spad_ctrl_wght = 1;
    core->wait(2);
    core->core->load_spad_ctrl_wght = 0;

    while(core->core->load_done == 0){
        core->wait(1);
    }


    core->wait(1);
    core->core->load_spad_ctrl_iact = 1;
    core->wait(2);
    core->core->load_spad_ctrl_iact = 0;

    while(core->core->load_done == 0) {
        core->wait(1);
    }

    core->wait(1);
    core->core->start = 1;
    core->wait(2);
    std::cout<<"----- Reading & Computing Begins for iter 1 -----\n\n";
    core->core->start = 0;
    while(int(core->core->write_psum_ctrl) == 0) {
        core->wait(1);
    }
    std::cout<<"----- Final PSUM of Iteration 1: "<<(int)core->core->pe_out[0]<<" "<<(int)core->core->pe_out[1]<<" "<<(int)core->core->pe_out[2]<<"\n\n";

    int i;
    for(i=2;i<=30;i++){
    core->wait(2);
    core->core->start = 1;
    core->wait(2);
    std::cout<<"----- Reading & Computing Begins for iter "<<i<<" -----\n\n";
    core->core->start = 0;
    while(core->core->write_psum_ctrl == 0) {
        core->wait(1);
    }
    std::cout<<"----- Final PSUM of Iteration "<<i<<": "<<(int)core->core->pe_out[0]<<" "<<(int)core->core->pe_out[1]<<" "<<(int)core->core->pe_out[2]<<"\n\n";
    }
    for(;i<=40;i++){
    core->wait(2);
    core->core->start = 1;
    core->wait(2);
    std::cout<<"----- Reading & Computing Begins for iter "<<i<<" -----\n\n";
    core->core->start = 0;
    while(core->core->write_psum_ctrl == 0) {
        core->wait(1);
    }
    std::cout<<"----- Final PSUM of Iteration "<<i<<": "<<(int)core->core->pe_out[0]<<"\n\n";
    }
    core->wait(4);
    return 0;
}
