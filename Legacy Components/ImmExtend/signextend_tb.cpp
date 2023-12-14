#include "Vsignextend.h" // ignore source error, since files are created upon code execution 
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env) {
    int i;
    int j = 0;
    int clk;

    Verilated::commandArgs(argc, argv);
    Vsignextend* top = new Vsignextend;
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("signextend.vcd");

    top->clk = 1;
    top->code = 0xFFF00000;
    top->immscr = 0;

    for (i= 0; i<300; i++) {

        for (clk=0; clk<2; clk++) {
            tfp->dump (2*i+clk);
            top->clk = !top->clk;
            top->eval ();
        }

        if (i == 10){
            top->code = 0x00FFFFFF;
        }
        if (i == 20){
            top->code = 0xF0F00000;
        }
        if (i == 100){
            top->code = 0x80000F00;
            top->immscr = 1;
        }

        if (i == 110){
            top->code = 0x7E080;
            top->immscr = 1;
        }

        if (Verilated::gotFinish()) exit(0);
    }
    tfp->close();
    exit(0);
}