#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VMux.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  VMux * top = new VMux;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("Mux.vcd");
 

  top->in1 = 2;
  top->in0 = 1;
  top->select = 0;

  
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->eval ();
    }

    top->select = 1;


    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
