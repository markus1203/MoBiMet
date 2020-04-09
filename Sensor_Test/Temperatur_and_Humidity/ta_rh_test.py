#! /usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import print_function
import math
import socket
import posix
from fcntl import ioctl
import Adafruit_DHT
import smbus
import Adafruit_MCP9808.MCP9808 as MCP9808
import os, sys, time, signal
import htu21d.htu21d as htu
import bme680



Zeit=time.strftime("%Y-%m-%d %H:%M:%S") 

# DHT22

dht22_pin1 = 4 # pin for DHT22 Data
dht22_sensor1 = Adafruit_DHT.DHT22

dht22_humidity1, dht22_temperature1 = Adafruit_DHT.read_retry(dht22_sensor1, dht22_pin1)

dht22_pin2 = 17 # pin for DHT22 Data
dht22_sensor2 = Adafruit_DHT.DHT22

dht22_humidity2, dht22_temperature2 = Adafruit_DHT.read_retry(dht22_sensor2, dht22_pin2)

#AM2320

class AM2320:
  I2C_ADDR = 0x5c
  I2C_SLAVE = 0x0703 

  def __init__(self, i2cbus = 1):
    self._i2cbus = i2cbus

  @staticmethod
  def _calc_crc16(data):
    crc = 0xFFFF
    for x in data:
      crc = crc ^ x
      for bit in range(0, 8):
        if (crc & 0x0001) == 0x0001:
          crc >>= 1
          crc ^= 0xA001
        else:
          crc >>= 1
    return crc

  @staticmethod
  def _combine_bytes(msb, lsb):
    return msb << 8 | lsb


  def readSensor(self):
    fd = posix.open("/dev/i2c-%d" % self._i2cbus, posix.O_RDWR)

    ioctl(fd, self.I2C_SLAVE, self.I2C_ADDR)
  
    # wake AM2320 up, goes to sleep to not warm up and affect the humidity sensor 
    # This write will fail as AM2320 won't ACK this write
    try:
      posix.write(fd, b'\0x00')
    except:
      pass
    time.sleep(0.001)  #Wait at least 0.8ms, at most 3ms
  
    # write at addr 0x03, start reg = 0x00, num regs = 0x04 */  
    posix.write(fd, b'\x03\x00\x04')
    time.sleep(0.0016) #Wait at least 1.5ms for result

    data = bytearray(posix.read(fd, 8))
  
    # Check data[0] and data[1]
    if data[0] != 0x03 or data[1] != 0x04:
      raise Exception("First two read bytes are a mismatch")

    # CRC check
    if self._calc_crc16(data[0:6]) != self._combine_bytes(data[7], data[6]):
      raise Exception("CRC failed")
    

    temp = self._combine_bytes(data[4], data[5])
    if temp & 0x8000:
      temp = -(temp & 0x7FFF)
    temp /= 10.0
  
    humi = self._combine_bytes(data[2], data[3]) / 10.0

    return (temp, humi)  

am2320 = AM2320(1)
(am2320t,am2320h) = am2320.readSensor()
#print("{0:.1f} %".format(am2320h),"{0:.1f} C".format(am2320t))

#HUT21D-F
sensor = htu.HTU21D()
htu_ta=sensor.read_temperature()
htu_rh=sensor.read_humidity()
sensor.dewpoint()
sensor.reset()

sensor2 = htu.HTU21D(4)
htu_2_ta=sensor2.read_temperature()
htu_2_rh=sensor2.read_humidity()
sensor2.dewpoint()
sensor2.reset()

#MCP9808
sensor_mcp1 = MCP9808.MCP9808()
mcp_1_ta = sensor_mcp1.readTempC()

sensor_mcp2 = MCP9808.MCP9808(address=0x18, busnum=4)
mcp_2_ta = sensor_mcp2.readTempC()


# BME680

sensor_bme680_1 = bme680.BME680(0x77)

sensor_bme680_1.set_humidity_oversample(bme680.OS_2X)
sensor_bme680_1.set_pressure_oversample(bme680.OS_4X)
sensor_bme680_1.set_temperature_oversample(bme680.OS_8X)
sensor_bme680_1.set_filter(bme680.FILTER_SIZE_3)

sensor_bme680_1.set_gas_status(bme680.ENABLE_GAS_MEAS)
sensor_bme680_1.set_gas_heater_temperature(320)
sensor_bme680_1.set_gas_heater_duration(150)
sensor_bme680_1.select_gas_heater_profile(0)

sensor_bme680_2 = bme680.BME680(0x76)

sensor_bme680_2.set_humidity_oversample(bme680.OS_2X)
sensor_bme680_2.set_pressure_oversample(bme680.OS_4X)
sensor_bme680_2.set_temperature_oversample(bme680.OS_8X)
sensor_bme680_2.set_filter(bme680.FILTER_SIZE_3)

sensor_bme680_2.set_gas_status(bme680.ENABLE_GAS_MEAS)
sensor_bme680_2.set_gas_heater_temperature(320)
sensor_bme680_2.set_gas_heater_duration(150)
sensor_bme680_2.select_gas_heater_profile(0)

# BME280

import bme280_b3
bme280_1_ta,bme280_1_p,bme280_1_rh = bme280_b3.readBME280All()
import bme280_b4
bme280_2_ta,bme280_2_p,bme280_2_rh = bme280_b4.readBME280All()



print ("Time: "+ str(Zeit)+"\n"+ "AM2320 Ta: " + str(round(am2320t,5)) + " AM2320 RH: " + str(round(am2320h,5)) +"\n"+"DHT22_1 Ta: " + str(round(dht22_temperature1,5)) + " DHT22_1 RH: " + str(round(dht22_humidity1,5)) + " // " + " DHT22_2 Ta: " + str(round(dht22_temperature2,5)) + " DHT22_2 RH: " + str(round(dht22_humidity2,5))+ "\n"+"HTU21D_1 Ta: " +str(round(htu_ta,3)) +" HTU21D_1 RH: "+str(round(htu_rh,3)) +" // "+ " HTU21D_2 Ta: " +str(round(htu_2_ta,3)) +" HTU21D_2 RH: " +str(round(htu_2_rh,3)) + "\n"+"MCP9808_1 Ta: " + str(round(mcp_1_ta,3))+" MCP9808_2 Ta: " + str(round(mcp_2_ta,3))+ "\n"+"BME280_1_Ta : "+str(round(bme280_1_ta,3))+" BME280_1_RH : "+str(round(bme280_1_rh,3))+" // "+" BME280_2_Ta : "+str(round(bme280_2_ta,3))+" BME280_2_RH : "+str(round(bme280_2_rh,3))+ "\n"+ "BME680_1 Ta: "+str(round(sensor_bme680_1.data.temperature,3))+" BME680_1 RH: "+str(round(sensor_bme680_1.data.humidity,3)) + " // " + " BME680_2 Ta: "+str(round(sensor_bme680_2.data.temperature,3))+" BME680_2 RH: "+str(round(sensor_bme680_2.data.humidity,3)))

logfile_path = "/home/pi/Desktop/"
logfile = logfile_path+"Ta_RH_Test-"+time.strftime("%Y-%m-%d")+".csv"

if os.path.exists(logfile):
    f0=open(logfile,"a")
    f0.write(str(Zeit)+","+str(am2320t)+","+str(am2320h)+","+str(dht22_temperature1)+","+str(dht22_humidity1)+","+str(dht22_temperature2)+","+str(dht22_humidity2)+","+str(htu_ta)+","+str(htu_rh)+","+str(htu_2_ta)+","+str(htu_2_rh)+","+str(mcp_1_ta)+","+str(mcp_2_ta)+","+str(sensor_bme680_1.data.temperature)+","+str(sensor_bme680_1.data.humidity)+","+ str(sensor_bme680_1.data.pressure)+","+str(sensor_bme680_1.data.gas_resistance)+","+str(sensor_bme680_2.data.temperature)+","+str(sensor_bme680_2.data.humidity)+","+ str(sensor_bme680_2.data.pressure)+","+str(sensor_bme680_2.data.gas_resistance)+","+str(bme280_1_ta)+","+str(bme280_1_rh)+","+str(bme280_1_p)+","+str(bme280_2_ta)+","+str(bme280_2_rh)+","+str(bme280_2_p)+"\n")
    f0.close()
    print("Data in logfile")
else:
    f0=open(logfile,"w")
    f0.write("Time,AM2320_Ta,AM2320RH,1_DHT22_Ta,1_DHT22_RH,2_DHT22_Ta,2_DHT22_RH,1_HTU21D_Ta,1_HTU21D_RH,2_HTU21D_Ta,2_HTU21D_RH,1_MCP9808,2_MCP9808,1_BME680_Ta,1_BME680_RH,1_BME680_P,1_BME680_q,2_BME680_Ta,2_BME680_RH,2_BME680_P,2_BME680_q,1_BME280_Ta,1_BME280_RH,1_BME280_P,2_BME280_Ta,2_BME280_RH,2_BME280_P\n")
    f0.close()
    f0=open(logfile,"a")
    f0.write(str(Zeit)+","+str(am2320t)+","+str(am2320h)+","+str(dht22_temperature1)+","+str(dht22_humidity1)+","+str(dht22_temperature2)+","+str(dht22_humidity2)+","+str(htu_ta)+","+str(htu_rh)+","+str(htu_2_ta)+","+str(htu_2_rh)+","+str(mcp_1_ta)+","+str(mcp_2_ta)+","+str(sensor_bme680_1.data.temperature)+","+str(sensor_bme680_1.data.humidity)+","+ str(sensor_bme680_1.data.pressure)+","+str(sensor_bme680_1.data.gas_resistance)+","+str(sensor_bme680_2.data.temperature)+","+str(sensor_bme680_2.data.humidity)+","+ str(sensor_bme680_2.data.pressure)+","+str(sensor_bme680_2.data.gas_resistance)+","+str(bme280_1_ta)+","+str(bme280_1_rh)+","+str(bme280_1_p)+","+str(bme280_2_ta)+","+str(bme280_2_rh)+","+str(bme280_2_p)+"\n")
    f0.close()
    print("New Logfile / Data in logfile")