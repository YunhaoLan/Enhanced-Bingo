# Bingo

This repository contains the source code accompanying the following paper:
```
@inproceedings{Bingo,
  title={Bingo Spatial Data Prefetcher},
  author={Mohammad Bakhshalipour, Mehran Shakerinava, Pejman Lotfi-Kamran, Hamid Sarbazi-Azad},
  booktitle={International Symposium on High-Performance Computer Architecture (HPCA)},
  year={2019}
}
```
<br/>

This source code includes the implementation of our proposal, named **Bingo**, as well as the implementation of competing methods such as **BOP**, **SPP**, **VLDP**, **AMPM**, and **SMS**. Everything is implemented on top of a modified version of the [ChampSim](https://github.com/ChampSim/ChampSim) simulator. Several scripts for running simulations and gathering results are also provided in this repo. Enjoy! :)
<br/>

*Please cite our paper if you use this code in your own work.*

![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) UPDATE: Bingo was recognized as the **best** data prefetching approach for multi-core processors in the [Third Data Prefetching Championship (DPC-3)](https://dpc3.compas.cs.stonybrook.edu/slides/dpc3_closing.pdf), co-located with International Symposium on Computer Architecture (ISCA), 2019.

<p align="center">
  <h1 align="center"> ======= ChampSim ======= </h1>
  <p> ChampSim is a trace-based simulator for a microarchitecture study. You can sign up to the public mailing list by sending an empty mail to champsim+subscribe@googlegroups.com. Traces for the 3rd Data Prefetching Championship (DPC-3) can be found from here (https://dpc3.compas.cs.stonybrook.edu/?SW_IS). A set of traces used for the 2nd Cache Replacement Championship (CRC-2) can be found from this link. (http://bit.ly/2t2nkUj) <p>
</p>

# Clone ChampSim repository
```
git clone https://github.com/ChampSim/ChampSim.git
```

# Compile

ChampSim takes seven parameters: Branch predictor, L1I prefetcher, L1D prefetcher, L2C prefetcher, LLC prefetcher, LLC replacement policy, and the number of cores. 
For example, `./build_champsim.sh bimodal no no no next_line lru 1` builds a single-core processor with bimodal branch predictor, no L1 instruction prefetcher, no L1/L2 data prefetchers, ip-stride LLC prefetcher and the baseline LRU replacement policy for the LLC.
```
$ ./build_champsim.sh bimodal no no no next_line lru 1

$ ./build_champsim.sh ${BRANCH} ${L1I_PREFETCHER} ${L1D_PREFETCHER} ${L2C_PREFETCHER} ${LLC_PREFETCHER} ${LLC_REPLACEMENT} ${NUM_CORE}
```

# Download DPC-3 trace

Professor Daniel Jimenez at Texas A&M University kindly provided traces for DPC-3. Use the following script to download these traces (~20GB size and max simpoint only).
```
$ cd scripts

$ ./download_dpc3_traces.sh
```

# Run simulation

Execute `run_champsim.sh` with proper input arguments. The default `TRACE_DIR` in `run_champsim.sh` is set to `$PWD/dpc3_traces`. <br>

* Single-core simulation: Run simulation with `run_champsim.sh` script.

```
Usage: ./run_champsim.sh [BINARY] [N_WARM] [N_SIM] [TRACE] [OPTION]
$ ./run_champsim.sh bimodal-no-no-no-next_line-lru-1core 1 10 600.perlbench_s-210B.champsimtrace.xz

${BINARY}: ChampSim binary compiled by "build_champsim.sh" (bimodal-no-no-no-next_line-lru-1core)
${N_WARM}: number of instructions for warmup (1 million)
${N_SIM}:  number of instructinos for detailed simulation (10 million)
${TRACE}: trace name (600.perlbench_s-210B.champsimtrace.xz)
${OPTION}: extra option for "-low_bandwidth" (src/main.cc)
```
Simulation results will be stored under "results_${N_SIM}M" as a form of "${TRACE}-${BINARY}-${OPTION}.txt".<br> 

* Multi-core simulation: Run simulation with `run_4core.sh` script. <br>
```
Usage: ./run_4core.sh [BINARY] [N_WARM] [N_SIM] [N_MIX] [TRACE0] [TRACE1] [TRACE2] [TRACE3] [OPTION]
$ ./run_4core.sh bimodal-no-no-no-next_line-lru-4core 1 10 0 600.perlbench_s-210B.champsimtrace.xz \\
  401.bzip2-38B.champsimtrace.xz 403.gcc-17B.champsimtrace.xz 410.bwaves-945B.champsimtrace.xz
```
Note that we need to specify multiple trace files for `run_4core.sh`. `N_MIX` is used to represent a unique ID for mixed multi-programmed workloads. 


# Add your own branch predictor, data prefetchers, and replacement policy
**Copy an empty template**
```
$ cp branch/branch_predictor.cc branch/mybranch.bpred
$ cp prefetcher/l1i_prefetcher.cc prefetcher/mypref.l1i_pref
$ cp prefetcher/l1d_prefetcher.cc prefetcher/mypref.l1d_pref
$ cp prefetcher/l2c_prefetcher.cc prefetcher/mypref.l2c_pref
$ cp prefetcher/llc_prefetcher.cc prefetcher/mypref.llc_pref
$ cp replacement/llc_replacement.cc replacement/myrepl.llc_repl
```

**Work on your algorithms with your favorite text editor**
```
$ vim branch/mybranch.bpred
$ vim prefetcher/mypref.l1i_pref
$ vim prefetcher/mypref.l1d_pref
$ vim prefetcher/mypref.l2c_pref
$ vim prefetcher/mypref.llc_pref
$ vim replacement/myrepl.llc_repl
```

**Compile and test**
```
$ ./build_champsim.sh mybranch mypref mypref mypref mypref myrepl 1
$ ./run_champsim.sh mybranch-myperf-mypref-mypref-mypref-myrepl-1core 1 10 bzip2_183B
```

# How to create traces

We have included only 4 sample traces, taken from SPEC CPU 2006. These 
traces are short (10 million instructions), and do not necessarily cover the range of behaviors your 
replacement algorithm will likely see in the full competition trace list (not
included).  We STRONGLY recommend creating your own traces, covering
a wide variety of program types and behaviors.

The included Pin Tool champsim_tracer.cpp can be used to generate new traces.
We used Pin 3.2 (pin-3.2-81205-gcc-linux), and it may require 
installing libdwarf.so, libelf.so, or other libraries, if you do not already 
have them. Please refer to the Pin documentation (https://software.intel.com/sites/landingpage/pintool/docs/81205/Pin/html/)
for working with Pin 3.2.

Get this version of Pin:
```
wget http://software.intel.com/sites/landingpage/pintool/downloads/pin-3.2-81205-gcc-linux.tar.gz
```

**Note on compatibility**: If you are using newer linux kernels/Ubuntu versions (eg. 20.04LTS), you might run into issues (such as [[1](https://github.com/ChampSim/ChampSim/issues/102)],[[2](https://stackoverflow.com/questions/55698095/intel-pin-tools-32-bit-processsectionheaders-560-assertion-failed)],[[3](https://stackoverflow.com/questions/43589174/pin-tool-segmentation-fault-for-ubuntu-17-04)]) with the PIN3.2. ChampSim tracer works fine with newer PIN tool versions that can be downloaded from [here](https://software.intel.com/content/www/us/en/develop/articles/pin-a-binary-instrumentation-tool-downloads.html). PIN3.17 is [confirmed](https://github.com/ChampSim/ChampSim/issues/102) to work with Ubuntu 20.04.1 LTS.

Once downloaded, open tracer/make_tracer.sh and change PIN_ROOT to Pin's location.
Run ./make_tracer.sh to generate champsim_tracer.so.

**Use the Pin tool like this**
```
pin -t obj-intel64/champsim_tracer.so -- <your program here>
```

The tracer has three options you can set:
```
-o
Specify the output file for your trace.
The default is default_trace.champsim

-s <number>
Specify the number of instructions to skip in the program before tracing begins.
The default value is 0.

-t <number>
The number of instructions to trace, after -s instructions have been skipped.
The default value is 1,000,000.
```
For example, you could trace 200,000 instructions of the program ls, after
skipping the first 100,000 instructions, with this command:
```
pin -t obj/champsim_tracer.so -o traces/ls_trace.champsim -s 100000 -t 200000 -- ls
```
Traces created with the champsim_tracer.so are approximately 64 bytes per instruction,
but they generally compress down to less than a byte per instruction using xz compression.

# Evaluate Simulation

ChampSim measures the IPC (Instruction Per Cycle) value as a performance metric. <br>
There are some other useful metrics printed out at the end of simulation. <br>

Good luck and be a champion! <br>