#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VDecodeToExecute.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  VDecodeToExecute * top = new VDecodeToExecute;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("DecodeToExecute.vcd");
 
  top->CLK = 1;
  top->CLR = 0;
  top->RegWriteD = 0x1;
  top->MemWriteD = 0x1;
  top->JumpD = 0x1;
  top->BranchD = 0x1;
  top->ALUSrcD = 0x1;
  top->ResultSrcD = 0x11;
  top->ALUControlD = 0x11;
  top->Rs1D = 0x11;
  top->Rs2D = 0x11;
  top->RdD = 0x11;
  top->RD1D = 0x11111111;
  top->RD2D = 0x11111111;
  top->PCD = 0x11111111;
  top->ImmExtD = 0x11111111;
  top->PCPlus4D = 0x11111111;

  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->CLK = !top->CLK;
      top->eval ();
    }
    top->CLR = 1;



    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
