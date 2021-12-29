import sys
from math import *
#-------------------------------------------------------------------------------

sys.path.append('../Memory')
import DualPortROM
#-------------------------------------------------------------------------------

def Help():
    print('')
    print('Window Generator')
    print('')
    print('Usage: py Window.py Type Length')
    print('')
    print('Exmple: py Window.py Hann 256')
    print('')
    exit()
#-------------------------------------------------------------------------------

if(len(sys.argv) != 3): Help()

Function =     sys.argv[1]
Length   = int(sys.argv[2])

N = range(Length)

match Function:
    case "Hann":
        Initial = [ (sin(pi*n/Length))**2 for n in N ]

    case "Hamming":
        a = 25/46
        Initial = [ a - (1-a)*cos(2*pi*n/Length) for n in N ]

    case _:
        Initial = [ 1 for n in N ]
#-------------------------------------------------------------------------------

Sum = 0;
for c in Initial:
    Sum += c

for n in N:
    Initial[n] /= Sum

Max = 1e-24
for c in Initial:
    if(Max < c): Max = c

Fullscale = 1;
while Fullscale > Max: Fullscale /= 2
while Fullscale < Max: Fullscale *= 2

for n in N:
    Initial[n] = round(Initial[n] * ((2**18-1) / Fullscale))
#-------------------------------------------------------------------------------

DualPortROM.GenerateMIF("Window.mif", 18, Initial)
#-------------------------------------------------------------------------------

