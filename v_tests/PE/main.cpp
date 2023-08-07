// DESCRIPTION: Verilator: Verilog PE module Test
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
#include "VPE.h"

//For IO routine
#include <iostream>

template<class module> class testbench {
    VerilatedFstC* trace = new VerilatedFstC;
    bool getDataNextCycle;

    public:
        const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
        const std::unique_ptr<VPE> core{new VPE{contextp.get(), "PE"}};
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
    auto *core = new testbench<VPE>;
    const int kernel_size = 3;
    const int act_size = 5;
    std::cout<<"----- Loading Begins: Weights -----\n\n";
    core->core->load_en_wght = 1;

    for(int i=1; i<=kernel_size*kernel_size; i++){
        core->core->filt_in = i;
        core->wait(2);
        core->core->load_en_wght = 0;
    }
    core->wait(5);
    std::cout<<"----- Loading Begins: Activations -----\n\n";
    core->core->load_en_act = 1;

    for(int i=1; i<=act_size*act_size; i++){
        core->core->act_in = i+1;
        core->wait(2);
        core->core->load_en_act = 0;
    } 
    core->wait(2);
    core->core->start = 1;
    core->wait(3);
    std::cout<<"----- Reading & Computing Begins for iter 1 -----\n\n";
    core->core->start = 0;
    while(int(core->core->compute_done) == 0) {
        core->wait(1);
    }
    std::cout<<"----- Final PSUM of Iteration 1: "<<(int)core->core->pe_out<<"\n\n";

    core->wait(4);
    core->core->start = 1;
    core->wait(3);
    std::cout<<"----- Reading & Computing Begins for iter 2 -----\n\n";
    core->core->start = 0;
    while(core->core->compute_done == 0) {
        core->wait(1);
    }
    std::cout<<"----- Final PSUM of Iteration 2: "<<(int)core->core->pe_out<<"\n\n";

    core->wait(4);
    core->core->start = 1;
    core->wait(3);
    std::cout<<"----- Reading & Computing Begins for iter 2 -----\n\n";
    core->core->start = 0;
    while(core->core->compute_done == 0) {
        core->wait(1);
    }
    std::cout<<"----- Final PSUM of Iteration 3: "<<(int)core->core->pe_out<<"\n\n";

    // core->wait(4);
    // core->core->start = 1;
    // core->wait(3);
    // std::cout<<"----- Reading & Computing Begins for iter 4 -----\n\n";
    // core->core->start = 0;
    // while(core->core->compute_done == 0) {
    //     core->wait(1);
    // }
    // std::cout<<"----- Final PSUM of Iteration 4: "<<(int)core->core->pe_out<<"\n\n";

    // core->wait(4);
    // core->core->start = 1;
    // core->wait(3);
    // std::cout<<"----- Reading & Computing Begins for iter 4 -----\n\n";
    // core->core->start = 0;
    // while(core->core->compute_done == 0) {
    //     core->wait(1);
    // }
    // std::cout<<"----- Final PSUM of Iteration 4: "<<(int)core->core->pe_out<<"\n\n";

    core->wait(4);
    return 0;
}