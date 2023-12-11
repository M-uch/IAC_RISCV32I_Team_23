#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VFetchToDecode.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  VFetchToDecode * top = new VFetchToDecode;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("FetchToDecode.vcd");
 
  top->CLK = 1;
  top->CLR = 0;
  top->EN = 0;
  top->InstrF = 5;
  top->PCPlus4F = 5;
  top->PCF = 5;
  int i = 0;

  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->CLK = !top->CLK;
      top->eval ();
    }

    top->CLR = 1;
    i ++;
    if(i == 2){
      top->CLR = 0;
      top->EN = 1;
    }
    if(i == 3){
      top->CLR = 1;
    }

    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
