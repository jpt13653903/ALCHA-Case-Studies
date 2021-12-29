import sys

sys.path.append('../../Library/Peripherals/Synth_and_DDS')
from ADF4159 import *
#-------------------------------------------------------------------------------

Synth = ADF4159()

Synth.SetRefFreq(100e6, True)
Synth.SetStart  (9.5e9)
Synth.SetRamp   (150e6, 1e-3, 50e-6)
#-------------------------------------------------------------------------------

Synth.PrintParameters()
#-------------------------------------------------------------------------------

