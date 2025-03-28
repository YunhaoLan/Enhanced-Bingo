#!/bin/bash
set -e  # Exit immediately if any command fails

# echo "Building bimodal-no-bingo_16k.llc_pref..."
./build_champsim.sh bimodal no bingo_01k.llc_pref lru 1

# echo "Building bimodal-no-bingo_multitable_pc+addr_pc+offs.llc_pref..."
./build_champsim.sh bimodal no bingo_01k_en.llc_pref lru 1

# echo "Running simulation for bimodal-no-bingo_16k-lru-1core..."
./run_champsim.sh bimodal-no-bingo_01k-lru-1core 20 80 620.omnetpp_s-874B.champsimtrace.xz

# echo "Running simulation for bimodal-no-bingo_multitable_pc+addr_pc+offs-lru-1core..."
./run_champsim.sh bimodal-no-bingo_01k_en-lru-1core 20 80 620.omnetpp_s-874B.champsimtrace.xz

echo "All commands executed successfully."
