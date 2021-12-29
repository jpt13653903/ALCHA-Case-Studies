def GenerateMIF(MIF_File, Width, Initial):
    with open(MIF_File, 'w', encoding='utf-8', newline='\n') as File:
        File.write( '-- Autogenerated by DualPortROM.py\n')
        File.write( '\n')
        File.write(f'WIDTH={Width};\n')
        File.write(f'DEPTH={len(Initial)};\n')
        File.write( '\n')
        File.write( 'ADDRESS_RADIX=HEX;\n')
        File.write( 'DATA_RADIX=HEX;\n')
        File.write( '\n')
        File.write( 'CONTENT BEGIN\n')

        n = 0;
        for Value in Initial:
            File.write(f'  {n:04X}: {Value:08X};\n')
            n += 1;

        File.write("END;\n");
#-------------------------------------------------------------------------------

