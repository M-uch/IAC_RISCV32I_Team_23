#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VMux3.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  VMux3 * top = new VMux3;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("Mux3.vcd");
 

  top->in0 = 0;
  top->in1 = 1;
  top->in2 = 2;
  top->select = 0;
  int i = 0;
  
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->eval ();
    }

    if(i == 0){
  top->select = 0;
    }
    if(i == 1){
  top->select = 1;
    }
    if(i == 2){
  top->select = 2;
    }
    i++;



    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
