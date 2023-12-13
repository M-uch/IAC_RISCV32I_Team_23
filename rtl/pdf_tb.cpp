#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VTop.h"
#include "vbuddy.cpp"    
#define MAX_SIM_CYC 1300000

int main(int argc, char **argv, char **env) {
  int i;     
  int clk;
  int plot;
  plot = 0;

  // VCD waveform dump
  Verilated::commandArgs(argc, argv);
  VTop* top = new VTop;
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("top.vcd");
 
  // init Vbuddy
  if (vbdOpen()!=1) return(-1);
  vbdHeader("PDF: Triangle");
  vbdSetMode(0); 

  top->clk = 0;
  top->rst = 0;

  // run simulation for many clock cycles
  for (int i=0; i<MAX_SIM_CYC; i++) {

    // dump variables into VCD file and toggle clock
    for (clk=0; clk<2; clk++) {
      tfp->dump (2*i+clk);
      top->clk = !top->clk;
      top->eval ();
    }

    if((top->A0 != 0)){ // starts plotting after an output is detected (skips vbuddy while still initialising PDF)
      plot = 1;
    } 

    if (plot) {
        vbdPlot(int(top->A0), 0, 255);
        vbdCycle(i);
    }
    

    /*
    if (i>50000) {
        vbdPlot(int(top->A0), 0, 255);
        vbdCycle(i);
    }
    */

    // exit simulation early with q 
    if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
      exit(0);
}

  vbdClose(); 
  tfp->close(); 
  printf("Exiting\n");
  exit(0);
}