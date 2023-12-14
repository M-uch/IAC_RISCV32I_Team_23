# Testing the F1 Program

## You can simulate the CPU and run the F1 program using the following steps. 

1. Connect Vbuddy to WSL and ensure that the correct [USB Port](vbuddy.cfg) is written into the config file (typically /dev/ttyUSB0)

2. Open an integrated terminal by right clicking on the "F1_Test" folder and run the following shell script.

```bash
$ ./doit.sh
```
3. When the program begins, pressing VBuddy's rotary encoder button will initiate the F1 light sequence once. The light sequence can be run many times, and each instance will have a random turnoff delay when all lEDs are on.

4. the full waveform vcd file "top.vcd" will be generated in "F1_Test"

## Notes

- The F1 light sequence can vary in speeds depending on the processor speed of the computer it is run on. Faster CPU clock speeds result in shorter delays between the LED lights turning on, and an overall shorter delay between all LEDs on and turning off. This can be tuned by editing the initial loaded values of registers s4 and s5 in the [F1 Program](<../Legacy Components/F1 Code/myprog/F1ProgramTest.s>)

- The F1 Program assembly can be found in [F1 Code](<../Legacy Components/F1 Code>), which contains an commented version describing the process in detail, and the newer compiled version in "myprog". The two programs differ slightly however should function exactly the same. 