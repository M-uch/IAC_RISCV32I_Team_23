#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VMemoryToWriteback.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  VMemoryToWriteback * top = new VMemoryToWriteback;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("MemoryToWriteback.vcd");
 
  top->CLK = 1;
  top->RegWriteM = 1;
  top->ResultSrcM = 0x2;
  top->RdM = 0x1F;
  top->ALUResultM = 1;
  top->ReadDataM = 1;
  top->PCPlus4M = 1;


  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->CLK = !top->CLK;
      top->eval ();
    }
  top->RegWriteM = 0;
  top->ResultSrcM =0;
  top->RdM = 0;
  top->ALUResultM = 0;
  top->ReadDataM = 0;
  top->PCPlus4M = 0;


    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
