import sys
import re
#-------------------------------------------------------------------------------

def Help():
    print("")
    print("Line-of-Code Counter")
    print("")
    print("Usage: py locCounter File.ext ...")
    print("")
    print("Supported extensions are: 'alc', 'v', 'qsf', 'sdc' and 'tcl'")
    print("")
    exit()
#-------------------------------------------------------------------------------

def Alcha(f):
    with open(f, 'rb') as File:
        Buffer = File.read()

    # DOS and MAC to Unix
    Buffer = re.sub(b'\r\n', b'\n', Buffer)
    Buffer = re.sub(b'\n\r', b'\n', Buffer)

    # Comments
    Buffer = re.sub(b'//.*\n'        , b'', Buffer)
    Buffer = re.sub(b'!!.*\n'        , b'', Buffer)
    Buffer = re.sub(b'/\*(.|\n)*?\*/', b'', Buffer)

    # Strings
    Buffer = re.sub(b'".*?"', b'', Buffer)

    # Matched brackets
    o = 1
    n = 0
    while(o != n):
        o = len(Buffer)
        Buffer = re.sub(b'\([^(]*?\)', b'', Buffer)
        Buffer = re.sub(b'\[[^[]*?\]', b'', Buffer)
        n = len(Buffer)

    # Empty lines
    Buffer = re.sub(b'(?m)^ *\n', b'', Buffer)

    # Count semicolons, commas and opening braces
    return len(re.sub(b'[;,{]', b';', Buffer).split(b';')) - 1
#-------------------------------------------------------------------------------

def Verilog(f):
    with open(f, 'rb') as File:
        Buffer = File.read()

    # DOS and MAC to Unix
    Buffer = re.sub(b'\r\n', b'\n', Buffer)
    Buffer = re.sub(b'\n\r', b'\n', Buffer)

    # Comments
    Buffer = re.sub(b'//.*\n'        , b'', Buffer)
    Buffer = re.sub(b'/\*(.|\n)*?\*/', b'', Buffer)

    # Strings
    Buffer = re.sub(b'".*?"', b'', Buffer)

    # Matched brackets
    o = 1
    n = 0
    while(o != n):
        o = len(Buffer)
        Buffer = re.sub(b'(?<!struct) *\{[^{]*?\}', b'', Buffer)
        n = len(Buffer)

    # Empty lines
    Buffer = re.sub(b'(?m)^ *\n', b'', Buffer)

    # Count semicolons, commas, "begin" and "case" keywords
    return len(re.sub(rb';|,|(\bbegin\b)|(\bcase\b)', b';', Buffer).split(b';')) - 1
#-------------------------------------------------------------------------------

def TCL(f):
    with open(f, 'rb') as File:
        Buffer = File.read()

    # DOS and MAC to Unix
    Buffer = re.sub(b'\r\n', b'\n', Buffer)
    Buffer = re.sub(b'\n\r', b'\n', Buffer)

    # Comments and empty lines
    Buffer = re.sub(b'(?m)^ *#.*\n' , b''  , Buffer)
    Buffer = re.sub(b'(?m)^ *\n', b'', Buffer)

    # Escaped newlines
    Buffer = re.sub(b'\\\\\n', b'', Buffer)

    # Count lines
    return len(Buffer.split(b'\n')) - 1
#-------------------------------------------------------------------------------

if(len(sys.argv) < 2):
    Help()

Total = 0

for f in sys.argv[1:]:
    Ext = f.split('.')
    Ext = Ext[-1]

    match Ext:
        case 'alc': Count = Alcha(f)
        case 'v'  : Count = Verilog(f)
        case 'qsf': Count = TCL(f)
        case 'sdc': Count = TCL(f)
        case 'tcl': Count = TCL(f)
        case _    : Help()

    print(f'{f}'.ljust(50) + f'{Count}'.rjust(5))
    Total += Count

print('-------------------------------------------------------')
print(f'Total'.ljust(50) + f'{Total}'.rjust(5))
#-------------------------------------------------------------------------------

sys.stdout.flush()
#-------------------------------------------------------------------------------

