# Requirements

## Architectural Abstraction

- Clock domains
    - Use the "alias" keyword to choose the current global clock.  Scope it by 
      means of a namespace, or group.
    - Use a company naming convention for clocks: and hook up the clocks in the
      top level (which is fine: it is a system-wide parameter)
        - Processor clock (make it 250 MHz from the PCIe bus).  The fact that
          this is PCIe should be hidden from the top level: simply expose the
          Avalon bus interface (PCIe or FPGA can be master: expose both
          interfaces).
        - DSP clock (make it 200 MHz from the ADC sampling rate)
        - Control and timing clock (make it 12.5 MHz from the output sampling rate)
- External RAM interfaces, with caching
    - Yet another clock domain
    - The caches run two clock domains, one to fetch, and the other on the
      "user" clock (i.e. DSP or control or whatever)
- Global resources:
    - Timing generator
    - Register handler
    - Implement figure 2.5: i.e. the overview block diagram
- Pin declarations: investigate multiple options:
    - Declare in the leaf module, with pin numbers as parameters (this is part 
      of the class, which is a new notion: originally pins were strictly global)
    - Global resource, with a "platform include"
- I2C bus, with units attaching themselves to the bus
    - Include arbitration, and automatically attach to the arbiter
    - Have multiple buses, and therefore multiple arbiters
    - Make sure to hide as much detail as possible: leverage the ALCHA model.
    - The I2C should have a "quiet" feature so that it is only active during
      radar transmission, or FMCW dead time.
- Storage:
    - Include a storage abstraction: SD-Card, NVMe, etc. should look the same

## Control Flow Abstraction

- SPI interface example
- SD-Card: especially the SD-Card's internal state machine management
    - External pins hidden in abstraction
    - PCB and Device timing constraints
    - Functional programming model for the initialisation stage
    - Functional programming for the transactions on the two buses
    - etc.

## Fixed-point Abstraction

- DSP chain:
    - Digital downconverter, including NCO, mixer, FIR filter and subsampler
    - Pulse compressor or Range FFT (the interface should be generic so that
      the two units can be swapped out, making the general DSP chain
      multi-purpose).
    - Include the CORDIC algoritm example from SiPS-2018 (to do the NCO)
- Use functions to implement the DSP chain:
    - See listing 6.1 in the thesis (i.e. "Example showing how to build a DSP
      chain using overloaded operators").
    - The FFT has a corner-turn in the middle that runs via the external RAM.
    - The FFT module must be able to add it to the list of external RAM users.
      The interface must then add all arbitration, etc. circuitry automatically.
    - The FFT must be written such that it can easily be swapped out with a
      pulse-compressor : Doppler FFT instead.

## Design Constraints

- Pin definition
- Timing constraints of the external SD-Card interface
- Timing constraints of multi-FPGA interfaces?  Like the command-and-control
  infrastructure of MrSR?

## Generalisation

- Registers
    - Include the auto-gen of C++ and LaTeX files.
    - A module must be able to add its own registers.  The exposed interface
      on the registers module should auto-assign addresses, etc.
- FIR filter implementation by specifying the filter parameters, not the
  actual coefficients.
    - Maybe not do all the calculations inside ALCHA: maybe call an
      external python script?  But isn't the whole point to use the
      internal scripting engine?
    - Auto-gen the FIR filter report (i.e. generate a PDF with the filter
      response).

