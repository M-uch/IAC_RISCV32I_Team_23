#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VExecuteToMemory.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  VExecuteToMemory * top = new VExecuteToMemory;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("ExecuteToMemory.vcd");
 
  top->CLK = 1;
  top->RegWriteE = 1;
  top->MemWriteE = 1;
  top->ResultSrcE = 1;
  top->RdE = 1;
  top->ALUResultE = 1;
  top->WriteDataE = 1;
  top->PCPlus4E = 1;

  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->CLK = !top->CLK;
      top->eval ();
    }
  top->RegWriteE = 0;
  top->MemWriteE = 0;
  top->ResultSrcE = 2;
  top->RdE = 2;
  top->ALUResultE = 2;
  top->WriteDataE = 2;
  top->PCPlus4E = 2;


    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
