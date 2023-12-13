#include "Vinstrmem.h" // ignore source error, since files are created upon code execution 
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env) {
    int i;
    int j = 0;
    int clk;

    Verilated::commandArgs(argc, argv);
    Vinstrmem* top = new Vinstrmem;
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("instrmem.vcd");

    top->clk = 1;
    top->addr = 0;

    for (i= 0; i<500; i++) {

        for (clk=0; clk<2; clk++) {
            tfp->dump (2*i+clk);
            top->clk = !top->clk;
            top->eval ();
        }

    if ((i<8)){ // PC = 0 for 8 cycles 
        top->addr = i*4; // increment PC in multiples of 4
    }

        if (Verilated::gotFinish()) exit(0);
    }
    tfp->close();
    exit(0);
}
