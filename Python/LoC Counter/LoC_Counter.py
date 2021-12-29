import sys
import re
#-------------------------------------------------------------------------------

def Help():
    print("")
    print("Line-of-Code Counter")
    print("")
    print("Usage: py LoC_Counter.py File.ext ...")
    print("")
    print("Supported extensions are:")
    print("  'alc', 'v', 'vh', 'qsf', 'sdc', 'tcl' and 'py'")
    print("")
    exit()
#-------------------------------------------------------------------------------

def Dos2Unix(Buffer):
    Buffer = re.sub(b'\r\n', b'\n', Buffer)
    Buffer = re.sub(b'\n\r', b'\n', Buffer)
    Buffer = re.sub(b'\r'  , b'\n', Buffer)
    return Buffer;
#-------------------------------------------------------------------------------

def Alcha(f):
    with open(f, 'rb') as File:
        Buffer = Dos2Unix(File.read())

    # Comments
    Buffer = re.sub(rb'//.*\n'        , b'', Buffer)
    Buffer = re.sub(rb'!!.*\n'        , b'', Buffer)
    Buffer = re.sub(rb'/\*(.|\n)*?\*/', b'', Buffer)

    # Strings
    Buffer = re.sub(b'".*?"', b'', Buffer)

    # Matched brackets
    o = 1
    n = 0
    while(o != n):
        o = len(Buffer)
        # Remove matched round brackets that are not concatenations,
        # but keep the contents so that they are still counted as lines
        Buffer = re.sub(rb'([^:])\(([^(]*?)\)', rb'\1\2', Buffer)
        # Remove matched square brackets, including the contents
        Buffer = re.sub(rb'\[[^[]*?\]'      , rb''  , Buffer)
        n = len(Buffer)

    # Concatenations
    o = 1
    n = 0
    while(o != n):
        o = len(Buffer)
        Buffer = re.sub(rb':\([^(]*?\)', rb'', Buffer)
        n = len(Buffer)

    # Empty lines
    Buffer = re.sub(b'(?m)^\\s*\n', b'', Buffer)

    # Count semicolons, commas and opening braces
    return len(re.sub(b'[;,{]', b';', Buffer).split(b';')) - 1
#-------------------------------------------------------------------------------

def Verilog(f):
    with open(f, 'rb') as File:
        Buffer = Dos2Unix(File.read())

    # Comments
    Buffer = re.sub(rb'//.*\n'        , b'', Buffer)
    Buffer = re.sub(rb'/\*(.|\n)*?\*/', b'', Buffer)

    # Strings
    Buffer = re.sub(b'".*?"', b'', Buffer)

    # Matched brackets
    o = 1
    n = 0
    while(o != n):
        o = len(Buffer)
        Buffer = re.sub(rb'(?<!struct)\s*\{[^{]*?\}', b'', Buffer)
        n = len(Buffer)

    # Empty lines
    Buffer = re.sub(b'(?m)^\\s*\n', b'', Buffer)

    # Count semicolons, commas, "begin" and "case" keywords
    return len(re.sub(rb';|,|(\bbegin\b)|(\bcase\b)', b';', Buffer).split(b';')) - 1
#-------------------------------------------------------------------------------

def Script(f):
    with open(f, 'rb') as File:
        Buffer = Dos2Unix(File.read())

    # Strings
    Buffer = re.sub(b'".*?"', b'', Buffer)
    Buffer = re.sub(b"'.*?'", b'', Buffer)

    # Comments and empty lines
    Buffer = re.sub(b'#.*\n'         , b'', Buffer)
    Buffer = re.sub(b'"""(.|\n)*?"""', b'', Buffer)
    Buffer = re.sub(b'(?m)^\\s*\n'   , b'', Buffer)

    # Escaped newlines
    Buffer = re.sub(b'\\\\\n', b'', Buffer)

    # Count semicolon and newline characters
    return len(re.sub(rb';|\n', b';', Buffer).split(b';')) - 1
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
        case 'vh' : Count = Verilog(f)
        case 'qsf': Count = Script(f)
        case 'sdc': Count = Script(f)
        case 'tcl': Count = Script(f)
        case 'py' : Count = Script(f)
        case _    : Help()

    print(f'{f}'.ljust(50) + f'{Count}'.rjust(5))
    Total += Count

print('-------------------------------------------------------')
print(f'Total'.ljust(50) + f'{Total}'.rjust(5))
#-------------------------------------------------------------------------------

sys.stdout.flush()
#-------------------------------------------------------------------------------

