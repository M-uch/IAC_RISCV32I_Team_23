# Testing the F1 Program

Please clone and open this repository in VSCode. 

## You can simulate the CPU and run the F1 program following these steps

1. Connect Vbuddy to WSL and ensure that the correct USB port is specified in the [config file](vbuddy.cfg) (typically /dev/ttyUSB0).

2. Right click on the "F1_Test" folder to open an integrated terminal and run the following shell script.

```bash
$ ./doit.sh
```
3. When the program begins, pressing VBuddy's rotary encoder button will initiate the F1 light sequence once. The light sequence can be run many times, and each instance will have a random turnoff delay when all LEDs are on. 

4. The simulation will end when entering "q" into the terminal, or when it has run for 100000 cycles. The full waveform vcd file "top.vcd" will be generated in "F1_Test".

## Notes

- The F1 light sequence can vary in speeds depending on the processor speed of the computer it is run on. Faster CPU clock speeds result in shorter delays between the LED lights turning on, and an overall shorter delay between all LEDs on and turning off. 

- This can be tuned by editing the initial loaded values of registers s4 (delay between LEDs) and s5 (fixed delay when all LEDs on) in the [F1 Program](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Legacy%20Components/F1%20Code/myprog/F1ProgramTest.s). Then recompiling the program and inserting the machine code into [F1.mem](F1.mem).

- The F1 Program assembly can be found in [F1 Code](https://github.com/M-uch/IAC_RISCV32I_Team_23/tree/main/Legacy%20Components/F1%20Code), which contains an commented version describing the process in detail, and the newer compiled version in "myprog". The two programs differ slightly in register use and the latter uses BNEs for unconditional branching instead of BEQs however should function exactly the same. 