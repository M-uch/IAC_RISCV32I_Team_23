#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VDataMemory.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);

  VDataMemory * top = new VDataMemory;

  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("DataMemory.vcd");
 

  top->clk = 1;
  top->A = 0;
  top->WD = 0x55;
  top->WE = 1;  
  int i = 0;
  
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }

    if(i == 1){
      top->WD = 0x23;      
    }
    if(i == 2){
      top->A = 1;
      top->WD = 0x43;      
    }
    i++;

    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
