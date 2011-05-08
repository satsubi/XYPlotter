#!/usr/bin/env python


import serial, os.path, time, subprocess

while 1:
   ls = os.listdir('/var/spool/plot/')

   if ls != []:
      f = ls.pop()
      spool = '/var/spool/plot/' + f
      tmp = '/tmp/' + f
      subprocess.Popen(['/usr/local/bin/pstoedit', '-f', 'hpgl', spool, tmp])
      time.sleep(15)
      ser = serial.Serial('/dev/ttyUSB0', 9600, timeout=10)
      time.sleep(1)
      with open('/tmp/' + f, 'r') as hpgl:
         for cmd in hpgl:
            ser.write(cmd[0:-1])
            print cmd[0:-1]
            ser.read(1)
      ser.close()
      os.remove('/var/spool/plot/' + f)
      os.remove('/tmp/' + f)
      time.sleep(10)

   time.sleep(2)

