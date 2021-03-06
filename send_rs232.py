import serial

with serial.Serial('/dev/ttyUSB0', 115200, timeout=60) as s:
    print(s.name)
    print(s)

    # Writes the initial configurations. C0 is the default.
    s.write(b'\xC0')

    # Writes the size of the message to be transmited. Most significative byte first, then less significative.
    s.write(b'\x03\xec')

    # Writes the mesage to be transmitted.
    # 0x32 0x49 0x33 0x30 0x38
    #msg = (b'\x32\x39\x33\x30\x38')
    
    msg = (b'\x45\x50\x61\x35\x78\x4f\x58\x30\x57\x54\x69\x79\x43\x32\x39\x4b\x71\x66\x75\x76\x55\x77\x38\x38\x49\x72\x46\x43\x68\x6d\x79\x33\x48\x41\x72\x55\x33\x61\x61\x31\x73\x30\x70\x75\x39\x38\x4d\x42\x54\x4a\x39\x6c\x6b\x6f\x56\x48\x36\x74\x46\x6e\x74\x65\x79\x58\x73\x32\x45\x67\x45\x75\x55\x39\x58\x70\x5a\x46\x39\x4a\x6c\x33\x4e\x6d\x47\x4f\x45\x7a\x62\x56\x4f\x36\x41\x7a\x66\x32\x6f\x38\x62\x31\x53\x43\x65\x4a\x50\x6b\x54\x31\x6b\x67\x44\x70\x78\x48\x77\x4f\x76\x4e\x50\x59\x34\x39\x77\x51\x42\x50\x5a\x6c\x5a\x51\x36\x77\x42\x48\x32\x6c\x58\x39\x65\x37\x4d\x57\x6a\x47\x56\x54\x6b\x76\x52\x45\x37\x53\x4e\x42\x57\x43\x77\x52\x69\x72\x59\x6e\x6b\x38\x45\x75\x46\x49\x33\x52\x75\x35\x4f\x77\x44\x69\x78\x32\x76\x58\x55\x66\x66\x51\x36\x38\x31\x52\x4d\x57\x35\x51\x39\x41\x38\x4f\x68\x6e\x69\x6a\x6c\x33\x35\x4d\x62\x7a\x66\x46\x76\x36\x4a\x48\x55\x6a\x4e\x4d\x61\x74\x6d\x59\x4f\x59\x69\x56\x76\x74\x77\x45\x44\x7a\x6c\x4c\x70\x35\x5a\x30\x70\x77\x72\x4d\x36\x6e\x4a\x67\x4d\x31\x54\x63\x78\x71\x54\x52\x44\x72\x6d\x48\x62\x39\x56\x65\x6e\x53\x36\x72\x6e\x73\x6f\x65\x73\x4f\x37\x35\x31\x79\x38\x79\x55\x4c\x38\x55\x77\x42\x53\x4c\x46\x55\x6f\x36\x30\x59\x63\x52\x7a\x78\x5a\x30\x6e\x78\x53\x78\x4b\x77\x53\x4e\x50\x58\x46\x69\x35\x63\x48\x4b\x4b\x61\x34\x72\x53\x42\x68\x6a\x59\x56\x5a\x70\x52\x75\x44\x77\x62\x79\x4b\x55\x6d\x59\x6b\x72\x48\x61\x71\x54\x54\x44\x50\x49\x54\x58\x62\x75\x32\x68\x67\x6d\x63\x6a\x34\x37\x53\x4d\x77\x76\x63\x4f\x78\x49\x70\x53\x47\x41\x72\x49\x43\x77\x38\x77\x74\x69\x50\x52\x79\x58\x6e\x6a\x7a\x37\x5a\x43\x67\x51\x4e\x65\x4a\x76\x41\x39\x53\x72\x53\x73\x48\x54\x48\x36\x6f\x69\x47\x6a\x37\x30\x53\x6d\x37\x66\x6b\x63\x72\x6d\x66\x4a\x6d\x72\x70\x6f\x33\x4c\x48\x48\x79\x42\x78\x32\x48\x6e\x76\x61\x5a\x58\x71\x74\x39\x68\x6e\x70\x42\x36\x4c\x32\x6c\x61\x30\x6b\x6f\x70\x33\x4e\x66\x39\x4e\x4b\x51\x37\x37\x4c\x55\x50\x58\x7a\x39\x7a\x42\x53\x34\x75\x74\x77\x57\x61\x61\x77\x75\x42\x72\x73\x38\x55\x67\x68\x75\x6f\x57\x36\x33\x46\x51\x42\x39\x4d\x67\x78\x46\x44\x6a\x6a\x66\x69\x62\x36\x32\x71\x70\x57\x76\x7a\x52\x41\x58\x51\x39\x4a\x6a\x75\x65\x75\x6d\x76\x31\x42\x45\x6c\x57\x5a\x6d\x6b\x69\x68\x4f\x67\x4b\x36\x44\x34\x6b\x48\x72\x57\x39\x43\x45\x6c\x78\x33\x78\x73\x37\x62\x54\x6f\x62\x6c\x34\x76\x6f\x4a\x38\x36\x56\x35\x54\x43\x37\x4d\x7a\x4c\x32\x4f\x58\x32\x6c\x70\x52\x6d\x58\x6d\x42\x6a\x67\x63\x32\x52\x38\x4e\x59\x4b\x77\x32\x74\x74\x78\x62\x54\x6f\x4e\x4e\x39\x50\x66\x54\x55\x38\x76\x6c\x75\x49\x38\x67\x38\x61\x69\x69\x31\x4a\x77\x63\x6f\x49\x4e\x70\x56\x32\x53\x47\x6a\x48\x52\x45\x58\x58\x46\x62\x56\x75\x51\x69\x75\x37\x42\x4e\x47\x50\x34\x78\x49\x4d\x72\x72\x41\x65\x79\x42\x36\x4f\x57\x61\x76\x70\x6d\x62\x49\x30\x34\x5a\x77\x6d\x38\x4a\x55\x4c\x78\x63\x4c\x6d\x38\x31\x4a\x4c\x76\x70\x6a\x43\x6f\x58\x4d\x4a\x5a\x51\x59\x4e\x48\x77\x75\x63\x66\x6a\x63\x75\x66\x65\x35\x50\x34\x37\x62\x36\x6d\x52\x48\x45\x31\x52\x31\x63\x55\x53\x65\x76\x4e\x48\x4b\x51\x45\x30\x37\x70\x6c\x44\x34\x48\x34\x59\x62\x77\x79\x35\x7a\x56\x50\x6b\x55\x35\x73\x6f\x43\x32\x4f\x44\x58\x42\x62\x62\x30\x70\x68\x49\x31\x4a\x76\x63\x73\x4f\x44\x4f\x5a\x39\x63\x65\x39\x42\x39\x6f\x33\x63\x33\x45\x36\x5a\x33\x6d\x76\x43\x50\x33\x30\x50\x65\x58\x5a\x76\x46\x67\x56\x4c\x73\x6a\x50\x4a\x38\x35\x4f\x77\x4a\x70\x6f\x74\x59\x55\x55\x55\x6d\x71\x42\x4b\x63\x6a\x6b\x50\x6f\x39\x76\x65\x49\x49\x76\x31\x37\x62\x56\x70\x6b\x59\x6d\x48\x41\x37\x56\x32\x6e\x4a\x33\x68\x58\x53\x78\x46\x59\x41\x39\x76\x43\x56\x34\x33\x48\x35\x61\x62\x68\x32\x51\x79\x61\x68\x33\x57\x61\x53\x38\x67\x53\x33\x53\x50\x41\x67\x52\x76\x70\x48\x32\x49\x4f\x6f\x32\x6f\x78\x77\x42\x57\x41\x38\x68\x54\x32\x63\x74\x6a\x47\x30\x49\x66\x6e\x6e\x51\x46\x4c\x44\x62\x61\x63\x75\x4e\x44\x66\x51\x74\x45\x4c\x66\x32\x37\x67\x46\x32\x57\x65\x49\x73\x4e\x6b\x48\x44\x30\x51\x67\x45\x76\x65\x54\x6c\x55\x78\x51\x45\x41\x32\x7a\x6c\x76\x47\x38\x47\x62\x76\x34\x6e\x45\x34\x48\x73\x6a\x37\x50\x76\x49\x4b\x39\x78\x62\x48\x68\x4e\x37\x67\x32\x46\x37\x35\x53\x30\x39\x47\x46\x31\x4e\x7a\x4e\x6e\x6b\x6d\x73\x32\x52\x50\x69\x27\x3f\xbd\xd8')

    s.write(msg)

    s.close()

    print('over')

# http://pyserial.readthedocs.io/en/latest/shortintro.html

