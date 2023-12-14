#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VALU.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  VALU * top = new VALU;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("ALU.vcd");
 

  top->ALUop1 = 0xBF773776;       // random values for ALUop1 and ALUop2, tested repeatedly with different values
  top->ALUop2 = 0x00000001;
  top->ALUctrl = 0;
  int i = 0;
  
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->eval ();
    }
  i++;

  if (i == 1){
    top->ALUctrl = 0;    // test add
  }
  else if (i == 2){
    top->ALUctrl = 1;    // test sub
  }
  else if (i == 3){
    top->ALUctrl = 7;    // test and
  }
  else if (i == 4){
    top->ALUctrl = 6;    // test or
  }
  else if (i == 5){
    top->ALUctrl = 4;    // test xor
  }
  else if (i == 6){
    top->ALUctrl = 2;    // test sll
  }
  else if (i == 7){
    top->ALUctrl = 5;    // test slr
  }



    if (Verilated::gotFinish())  exit(0);
  }

  tfp->close(); 
  exit(0);
}
