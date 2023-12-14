# LUI Test #

In order to prove that our LUI instruction works as intended, given that it is not included in our final reference program, we tested it seperately.

### Folder Contents: ###

| File Name             | File Description                      |
| :-------:             | :--------------:                      |
| testLUI.s             | Assembly code for test program        |      
| testLUI.s.hex         | Translated assembly code              |
| LUI_Prog_Waveform.png | Picture of waveform from test program | 

### Test Method ###

To test the LUI instruction we ran the following code:

```
addi a0, zero, 0x1
LUI a0, 0x1
```

This code performs the arithmetic 0+1 and writes the result into a0, this should then produce the result a0 = 0x1.

Then the 'LUI' instruction takes the imm value 0x1 and shifts up by 12 bits, and replaces the LSBs with 0s. This should give the result 0x00001000.