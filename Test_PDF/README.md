# Testing the PDF Program

Please clone and open this repository in VSCode. 

## You can simulate the CPU and run the PDF program following these steps

1. Connect Vbuddy to WSL and ensure that the correct USB port is specified in the [config file](vbuddy.cfg) (typically /dev/ttyUSB0).

2. Right click on the "Test_PDF" folder to open an integrated terminal and run the following shell script.

```bash
$ ./doit.sh
```

**Verilator warnings may occur, this is due to some partially unused inputs in the CPU. This should not impact the test in any way.**

3. Vbuddy's display should plot the PDF for the corresponding function loaded into the data memory, the data memory loaded by default is gaussian.mem. You can change this by changing the .mem file loaded in the [data memory](DataMemory.sv).

```bash
$readmemh("EXAMPLE.mem", data_array, 32'h00010000, 32'h0001FFFF);
```

4. The simulation will end when entering "q" into the terminal, or when it has run for 1300000 cycles. The full waveform vcd file "top.vcd" will be generated in "Test_PDF".

## Notes

- The assembly code being run for the [PDF program](<../Legacy Components/PDF Codes/myprog/pdfMod.s>) and all related files can be found [here](<../Legacy Components/PDF Codes>). 