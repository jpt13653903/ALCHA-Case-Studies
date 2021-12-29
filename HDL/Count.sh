echo ""
echo "Verilog: Full Implementation"
echo ""

Library=$(find Library -iname "*.v" -o -iname "*.vh" -o -iname "*.tcl" -o -iname "*.py")
SubSystems=$(find Radar/SubSystems -iname "*.v" -o -iname "*.vh")

py ../Python/LoC\ Counter/LoC_Counter.py \
    $Library                             \
    Radar/*.v                            \
    Radar/*.qsf                          \
    Radar/*.sdc                          \
    $SubSystems
echo ""
echo ""
#-------------------------------------------------------------------------------

echo "Verilog: Top-level Project"
echo ""

Files="        Radar/Radar.v"
Files=" $Files Radar/Radar.qsf"
Files=" $Files Radar/Radar.sdc"
Files=" $Files Radar/Platform/Platform.vh"
Files=" $Files Library/Platforms/DE0-Nano-SoC.vh"

py ../Python/LoC\ Counter/LoC_Counter.py $Files
echo ""
echo ""
#-------------------------------------------------------------------------------

echo "Verilog: Library Modules"
echo ""

Files="        Library/Clocking_and_Reset/DelayedReset.v"
Files=" $Files Library/Clocking_and_Reset/PLL_CycloneV.v"
Files=" $Files Library/Clocking_and_Reset/WatchDog.v"

Files=" $Files Library/Comms/I2C/I2C.v"
Files=" $Files Library/DSP/NCO.v"
Files=" $Files Library/DSP/SinCos.v"

Files=" $Files Library/Misc/MutEx.v"

Files=" $Files Library/Timing/TriggerGen.v"
Files=" $Files Library/Timing/TriggerDelay.v"

py ../Python/LoC\ Counter/LoC_Counter.py $Files
echo ""
echo ""
#-------------------------------------------------------------------------------

echo "Verilog: DSP Modules"
echo ""

Files="        Library/Memory/DualPortROM.v"
Files=" $Files Library/Memory/DualPortROM.py"
Files=" $Files Library/Memory/DualPortRAM.v"
Files=" $Files Library/Memory/FullDualPortRAM.v"

Files=" $Files Library/DSP/FIFO.v"
Files=" $Files Library/DSP/Window.v"
Files=" $Files Library/DSP/Window.py"
Files=" $Files Library/DSP/RealFFT.v"
Files=" $Files Library/DSP/Transpose.v"
Files=" $Files Library/DSP/FFT.v"
Files=" $Files Library/DSP/AlphaFilter.v"

py ../Python/LoC\ Counter/LoC_Counter.py $Files
echo ""
echo ""
#-------------------------------------------------------------------------------

echo "Verilog: Other Subsystems"
echo ""

Files="        Radar/SubSystems/SystemController.vh"

Files=" $Files Radar/SubSystems/RegistersDecoder.v"

Files=" $Files Library/Misc/FirmwareVersion.tcl"

Files=" $Files Radar/SubSystems/HardwareControl.v"
Files=" $Files Radar/SubSystems/WaveformGenerator.v"
Files=" $Files Radar/SubSystems/ReceiverAbstraction.v"
Files=" $Files Radar/SubSystems/DebugStreamer.v"
Files=" $Files Radar/SubSystems/RadarProcessor.v"

py ../Python/LoC\ Counter/LoC_Counter.py $Files
echo ""
echo ""
#-------------------------------------------------------------------------------

