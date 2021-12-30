echo ""
echo "Alcha: Full Implementation"
echo ""
find -iname "*.alc" -exec py ../Python/LoC\ Counter/LoC_Counter.py {} +
echo ""
echo ""
#-------------------------------------------------------------------------------

echo "Alcha: Top-level Project"
echo ""

Files="        main.alc"
Files=" $Files SubSystems/MasterTrigger.alc"
Files=" $Files Library/Platforms/DE0-Nano-SoC.alc"
Files=" $Files Platform/Platform.alc"

py ../Python/LoC\ Counter/LoC_Counter.py $Files
echo ""
echo ""
#-------------------------------------------------------------------------------

echo "Alcha: Library Modules"
echo ""

Files="        Library/Peripherals/Synth_and_DDS/AD9915.alc"
Files=" $Files Library/Peripherals/Synth_and_DDS/ADF4159.alc"
Files=" $Files Library/Peripherals/ADC_and_BIM/ADS7056.alc"
Files=" $Files Library/Interfaces/AvalonInterface.alc"
Files=" $Files Library/Interfaces/AvalonMaster.alc"
Files=" $Files Library/Interfaces/AvalonSlave.alc"
Files=" $Files Library/Clocking_and_Reset/DelayedReset.alc"
Files=" $Files Library/Comms/I2C/I2C.alc"
Files=" $Files Library/Peripherals/ADC_and_BIM/LTC2991.alc"
Files=" $Files Library/Misc/MutEx.alc"
Files=" $Files Library/DSP/NCO.alc"
Files=" $Files Library/Clocking_and_Reset/PLL_CycloneV.alc"
Files=" $Files Library/DSP/SinCos.alc"
Files=" $Files Library/Timing/TriggerDelay.alc"
Files=" $Files Library/Timing/TriggerGen.alc"
Files=" $Files Library/Clocking_and_Reset/WatchDog.alc"

py ../Python/LoC\ Counter/LoC_Counter.py $Files
echo ""
echo ""
#-------------------------------------------------------------------------------

echo "Alcha: DSP Modules"
echo ""

Files="        Library/Memory/DualPortROM.alc"
Files=" $Files Library/Memory/DualPortRAM.alc"
Files=" $Files Library/Memory/FullDualPortRAM.alc"

Files=" $Files Library/DSP/FIFO.alc"
Files=" $Files Library/DSP/Window.alc"
Files=" $Files Library/DSP/FFT.alc"
Files=" $Files Library/DSP/Transpose.alc"
Files=" $Files Library/DSP/AlphaFilter.alc"

py ../Python/LoC\ Counter/LoC_Counter.py $Files
echo ""
echo ""
#-------------------------------------------------------------------------------

echo "Alcha: Other Subsystems"
echo ""

Files="        SubSystems/SystemController.alc"

Files=" $Files Library/Interfaces/RegistersDecoder.alc"

Files=" $Files Library/Misc/FirmwareVersion.alc"

Files=" $Files SubSystems/HardwareControl.alc"
Files=" $Files SubSystems/WaveformGenerator.alc"
Files=" $Files SubSystems/ReceiverAbstraction.alc"
Files=" $Files SubSystems/DebugStreamer.alc"
Files=" $Files SubSystems/RadarProcessor.alc"
Files=" $Files Library/DSP/Streams.alc"

py ../Python/LoC\ Counter/LoC_Counter.py $Files
echo ""
echo ""
#-------------------------------------------------------------------------------

