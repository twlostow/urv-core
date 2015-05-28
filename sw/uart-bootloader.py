#!/usr/bin/python

our_port="/dev/ttyUSB0"

import sys
import time
import serial

ser = serial.Serial(port=our_port,baudrate=115200,timeout=1,rtscts=False)


fw = open(sys.argv[1], "rb").read()

while(ser.read(1) != 'B'):
	pass

while(ser.read(1) != 'o'):
	pass
	
while(ser.read(1) != 'o'):
	pass
	
while(ser.read(1) != 't'):
	pass
	
while(ser.read(1) != '?'):
	pass

time.sleep(0.01)

ser.write('Y')

while(ser.read(1) != 'O'):
	pass

while(ser.read(1) != 'K'):
	pass



time.sleep(10e-6);
l = len(fw)
print("Bootloader OK, writing %d bytes." % l)

ser.write(chr((l >> 24) & 0xff));
time.sleep(100e-6);
ser.write(chr((l >> 16) & 0xff));
time.sleep(100e-6);
ser.write(chr((l >> 8) & 0xff));
time.sleep(100e-6);
ser.write(chr((l >> 0) & 0xff));

n=0
for b in fw:
	n+=1
	ser.write(b)
	time.sleep(100e-6)
	if n % 10000 == 0:
		print("%d/%d bytes programmed." % (n,len(fw)))

while(ser.read(1) != 'G'):
	time.sleep(100e-6)

print("Programming done!")
