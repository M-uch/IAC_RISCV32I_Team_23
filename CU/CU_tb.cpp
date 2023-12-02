#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VCU.h"

#include "vbuddy.cpp"     // include vbuddy code
#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int i;     
  int clk;       

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  VCU* top = new VCU;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("CU.vcd");
 
  // init Vbuddy
  if (vbdOpen()!=1) return(-1);
  vbdHeader("CU:Testing");
  //vbdSetMode(1);        // Flag mode set to one-shot

  // initialize simulation input 
  top->clk = 1;
  top->rst = 0;

  vbdSetMode(1);

  // run simulation for i clock cycles
  for (int i=0; i<MAX_SIM_CYC; i++) {

    // dump variables into VCD file and toggle clock
    for (clk=0; clk<2; clk++) {
      tfp->dump (2*i+clk);
      top->clk = !top->clk;
      top->eval ();
    }

    vbdHex(4, (int(top->A0) >> 16) & 0xF);
    vbdHex(3, (int(top->A0) >> 8)  & 0xF);
    vbdHex(2, (int(top->A0) >> 4)  & 0xF);
    vbdHex(1, (int(top->A0)) & 0xF);

    // either simulation finished, or 'q' is pressed
    if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
      exit(0);
  }

  vbdClose();     // ++++
  tfp->close(); 
  printf("Exiting\n");
  exit(0);
}
