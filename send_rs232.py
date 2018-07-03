import serial

with serial.Serial('/dev/ttyUSB0', 115200, timeout=60) as s:
    print(s.name)
    print(s)

    # Writes the initial configurations. C0 is the default.
    s.write(b'\xC0')

    # Writes the size of the message to be transmited. Most significative byte first, then less significative.
    s.write(b'\x00\x05')

    # Writes the mesage to be transmitted.
    # 0x32 0x49 0x33 0x30 0x38
    s.write(b'\x32\x39\x33\x30\x38') #  ')

    s.close()

    print('over')

# http://pyserial.readthedocs.io/en/latest/shortintro.html

