#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VRegFile.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  VRegFile * top = new VRegFile;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("RegFile.vcd");
 

  top->clk = 1;
  top->A1 = 0;
  top->A2 = 0;
  top->A3 = 10;
  top->W3 = 0x55;
  top->WE3 = 1;  
  top->trigger = 0;
  int i = 0;
  
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }
    if(i == 1){
      top->AD3 = 5;
      top->AD1 = 5;
      top->trigger = 1;
    }
    else{
      top->AD3 = 0;
      top->trigger = 0;
    }
    i++;

    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
