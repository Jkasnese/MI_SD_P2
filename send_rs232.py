import serial

with serial.Serial('/dev/ttyUSB0', 115200, timeout=60) as s:
    print(s.name)
    print(s)
    s.write(b'\x53')
    s.close()

# http://pyserial.readthedocs.io/en/latest/shortintro.html

