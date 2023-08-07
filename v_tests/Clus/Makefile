######################################################################
#
# DESCRIPTION: Verilator Example: Small Makefile
#
# This calls the object directory makefile.  That allows the objects to
# be placed in the "current directory" which simplifies the Makefile.
#
# This file ONLY is placed under the Creative Commons Public Domain, for
# any use, without warranty, 2020 by Wilson Snyder.
# SPDX-License-Identifier: CC0-1.0
#
######################################################################
# Check for sanity to avoid later confusion

ifneq ($(words $(CURDIR)),1)
 $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

######################################################################
# Set up variables

# If $VERILATOR_ROOT isn't in the environment, we assume it is part of a
# package install, and verilator is in your path. Otherwise find the
# binary relative to $VERILATOR_ROOT (such as when inside the git sources).
ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
VERILATOR_COVERAGE = verilator_coverage
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
VERILATOR_COVERAGE = $(VERILATOR_ROOT)/bin/verilator_coverage
endif

# Generate C++ in executable form
VERILATOR_FLAGS += -cc --exe
# Generate makefile dependencies (not shown as complicates the Makefile)
#VERILATOR_FLAGS += -MMD
# Optimize
VERILATOR_FLAGS += -x-assign fast
# Warn abount lint issues; may not want this on less solid designs
VERILATOR_FLAGS += --top-module Clus
# Make waveforms
VERILATOR_FLAGS += --trace-fst  #--Wall
# Check SystemVerilog assertions
VERILATOR_FLAGS += --assert --vpi --threads 5
# Generate coverage analysis
VERILATOR_FLAGS += --coverage --build -j 15
#Run Verilator in debug mode
#VERILATOR_FLAGS += --debug
#Add this trace to get a backtrace in gdb
#VERILATOR_FLAGS += --gdbbt

# Input files for Verilator
VERILATOR_INPUT = Clus.sv PE_cluster.sv MAC.sv PE.sv SPad.sv main.cpp router_cluster.sv router_iact.sv router_psum.sv router_weight.sv GLB_cluster.sv glb_iact.sv glb_psum.sv glb_weight.sv

######################################################################
default: run

run:
	@echo
	@echo "-- Verilator PE Testbench"

	@echo
	@echo "-- VERILATE ----------------"
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT)

# 	@echo
# 	@echo "-- BUILD -------------------"
# # To compile, we can either
# # 1. Pass --build to Verilator by editing VERILATOR_FLAGS above.
# # 2. Or, run the make rules Verilator does:
# #	$(MAKE) -j -C obj_dir -f Vtop.mk
# # 3. Or, call a submakefile where we can override the rules ourselves:
# 	$(MAKE) -j -C obj_dir -f Vmetis.mk

# 	@echo
# 	@echo "-- RUN ---------------------"
# 	@rm -rf logs
# 	@mkdir -p logs
	obj_dir/VClus +trace

# 	@echo
# 	@echo "-- COVERAGE ----------------"
# 	@rm -rf logs/annotated
# 	$(VERILATOR_COVERAGE) --annotate logs/annotated logs/coverage.dat

	@echo
	@echo "-- DONE --------------------"
	@echo "To see waveforms, open vlt_dump.vcd in a waveform viewer"
	@echo


######################################################################
# Other targets

show-config:
	$(VERILATOR) -V

maintainer-copy::
clean mostlyclean distclean maintainer-clean::
	-rm -rf obj_dir logs *.log *.dmp *.vpd coverage.dat core
