#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VTop.h"
#include "vbuddy.cpp"    
#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
  int i;     
  int clk;

  // VCD waveform dump
  Verilated::commandArgs(argc, argv);
  VTop* top = new VTop;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("top.vcd");
 
  // init Vbuddy
  if (vbdOpen()!=1) return(-1);
  vbdHeader("F1 Lights");
  vbdSetMode(1); // apply flag state as trigger to register t0 in one shot mode

  top->clk = 1;
  top->rst = 0;  

  // run simulation for i clock cycles
  for (int i=0; i<MAX_SIM_CYC; i++) {

    // dump variables into VCD file and toggle clock
    for (clk=0; clk<2; clk++) {
      tfp->dump (2*i+clk);
      top->clk = !top->clk;
      top->eval ();
    }

    // display lEDS
    vbdBar((top->a0) & 0xFF);

    vbdHex(4, (int(top->a0) >> 16) & 0xF);
    vbdHex(3, (int(top->a0) >> 8)  & 0xF);
    vbdHex(2, (int(top->a0) >> 4)  & 0xF);
    vbdHex(1, (int(top->a0)) & 0xF);

    top->trigger = vbdFlag(); // need to add direct signal to t0 address in register to toggle f1 sequence 

    // display cycle count
    vbdCycle(i);

    // exit simulation early with q 
    if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
      exit(0);
  }

  vbdClose(); 
  tfp->close(); 
  printf("Exiting\n");
  exit(0);
}