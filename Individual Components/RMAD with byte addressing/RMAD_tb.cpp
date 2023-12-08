#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VRMAD.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;    
  int tick;

  Verilated::commandArgs(argc, argv);
  VRMAD * top = new VRMAD;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("RMAD.vcd");
 
  top->clk = 0;       // tested repeatedly with multiple values
  top->A1 = 0;
  top->A2 = 0;
  top->A3 = 0;
  top->RegWrite = 1;
  top->trigger = 1;
  top->ImmExt = 0x1;
  top->ALUSrc = 1;
  top->ALUControl = 0;
  top->MemWrite = 1;
  top->ResultSrc = 0;
  top->PCPlus4 = 5;

  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }

    top->ALUControl = 1;
    top->trigger = 0;
    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
