#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VHazardUnit.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  VHazardUnit * top = new VHazardUnit;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("HazardUnit.vcd");

  top->Rs1D = 1;
  top->Rs2D = 5; 
  top->Rs1E = 0;
  top->Rs2E = 3;
  top->RdM = 0;
  top->RdW = 3;
  top->RdE = 2;
  top->RegWriteM = 1;
  top->RegWriteW = 1;          // expect FlushE = FlushD = 0
  top->PCSrcE = 0;             // expect StallD = StallF = 0
  top->ResultSrcE = 1;         // expect ForwardAE = 0, expect ForwardBE = 1
  int i = 0;
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->eval ();
    }
 i++;
 if(i == 1){
  top->Rs1D = 1;
  top->Rs2D = 5;
  top->Rs1E = 3;
  top->Rs2E = 3;
  top->RdM = 0;
  top->RdW = 3;
  top->RdE = 5;
  top->RegWriteM = 0;
  top->RegWriteW = 1;        // expect FlushE = 1, FlushD = 0
  top->PCSrcE = 0;           // expect StallD = StallF = 1
  top->ResultSrcE = 1;       // expect ForwardAE = 1, expect ForwardBE = 1
 }
 if(i == 2){
  top->Rs1D = 1;
  top->Rs2D = 5;
  top->Rs1E = 1;
  top->Rs2E = 3;
  top->RdM = 1;
  top->RdW = 3;
  top->RdE = 5;
  top->RegWriteM = 1;
  top->RegWriteW = 1;        // expect FlushE = 1, FlushD = 1
  top->PCSrcE = 1;           // expect StallD = StallF = 0
  top->ResultSrcE = 0;       // expect ForwardAE = 2, expect ForwardBE = 1
 }

    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
