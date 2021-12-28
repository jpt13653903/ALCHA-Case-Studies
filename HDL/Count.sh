echo ""
echo "Verilog: Full Implementation"
echo ""

Library=$(find Library -iname "*.v")
SubSystems=$(find Radar/SubSystems -iname "*.v")

py ../Python/LoC\ Counter/LoC_Counter.py \
    Radar/*.v                            \
    Radar/*.qsf                          \
    Radar/*.sdc                          \
    $Library                             \
    $SubSystems
echo ""
echo ""
#-------------------------------------------------------------------------------

echo "Verilog: Top-level Project"
echo ""

Files="        Radar/Radar.v"
Files=" $Files Radar/Radar.qsf"
Files=" $Files Radar/Radar.sdc"

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

echo "Verilog: Other Subsystems"
echo ""

Files="        Radar/SubSystems/RegistersDecoder.v"

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

