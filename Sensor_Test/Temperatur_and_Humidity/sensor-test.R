
rm(list = ls())

#install.packages("Hmisc")
library(Hmisc)
#install.packages("hydroGOF")
library(hydroGOF)
setwd("C:/Users/marku/Desktop/Sensor-Test/Wetterhütte")

FRWRTM_0403<-read.csv("FRWRTM_MET_1min_2020-04-03.csv", header = FALSE, skip = 993, col.names = c("TIMESTAMP","RECORD","MET_PTB100_PressureSeaLevel_hPa_Avg","MET_PTB100_PressureActual_hPa_Avg","MET_CS215_AirTemperature_degC_Avg","MET_CS215_RelHumidity_percent_Avg","MET_CS215_DewPoint_degC_Avg","MET_CS215_VapourPressure_hPa_Avg","MET_CS215_VapPressDeficit_hPa_Avg","MET_CS215_MixingRatio_gKg_Avg","MET_CS107_SoilT05cm_degC_Avg","MET_CS107_SoilT20cm_degC_Avg"))
FRWRTM_0404<-read.csv("FRWRTM_MET_1min_2020-04-04.csv", header = FALSE, skip = 4, col.names = c("TIMESTAMP","RECORD","MET_PTB100_PressureSeaLevel_hPa_Avg","MET_PTB100_PressureActual_hPa_Avg","MET_CS215_AirTemperature_degC_Avg","MET_CS215_RelHumidity_percent_Avg","MET_CS215_DewPoint_degC_Avg","MET_CS215_VapourPressure_hPa_Avg","MET_CS215_VapPressDeficit_hPa_Avg","MET_CS215_MixingRatio_gKg_Avg","MET_CS107_SoilT05cm_degC_Avg","MET_CS107_SoilT20cm_degC_Avg"))
FRWRTM_0405<-read.csv("FRWRTM_MET_1min_2020-04-05.csv", header = FALSE, skip = 4, col.names = c("TIMESTAMP","RECORD","MET_PTB100_PressureSeaLevel_hPa_Avg","MET_PTB100_PressureActual_hPa_Avg","MET_CS215_AirTemperature_degC_Avg","MET_CS215_RelHumidity_percent_Avg","MET_CS215_DewPoint_degC_Avg","MET_CS215_VapourPressure_hPa_Avg","MET_CS215_VapPressDeficit_hPa_Avg","MET_CS215_MixingRatio_gKg_Avg","MET_CS107_SoilT05cm_degC_Avg","MET_CS107_SoilT20cm_degC_Avg"))
FRWRTM<-rbind(FRWRTM_0403,FRWRTM_0404,FRWRTM_0405)

FRWRTM<-FRWRTM[-c(3211:3331),]

class(FRWRTM)

Sensors_0403<-read.csv("Ta_RH_Test-2020-04-03.csv",header = TRUE)
Sensors_0404<-read.csv("Ta_RH_Test-2020-04-04.csv",header = TRUE)
Sensors_0405<-read.csv("Ta_RH_Test-2020-04-05.csv",header = TRUE)

sensors<- rbind(Sensors_0403,Sensors_0404,Sensors_0405)
sensors[,1]
sensors<-sensors[-c(0:25),]


time<- strptime(as.character(FRWRTM[,1]), format="%Y-%m-%d %H:%M:%S")
time2<- strptime(as.character(sensors$Time), format="%Y-%m-%d %H:%M:%S")

attach(FRWRTM)
attach(sensors)

#plot Time ~ Ta (all Sensors) raw

plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", lwd=2,ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")

lines(time2,sensors$AM2320_Ta, col="green")
lines(time2,sensors$X1_DHT22_Ta, col="red")
lines(time2,sensors$X2_DHT22_Ta, col="purple")
lines(time2,sensors$X1_HTU21D_Ta, col="blue")
lines(time2,sensors$X2_HTU21D_Ta, col="yellow")
lines(time2,sensors$X1_MCP9808, col="grey")
lines(time2,sensors$X2_MCP9808, col="brown")
lines(time2,sensors$X1_BME680_Ta, col="pink")
lines(time2,sensors$X2_BME680_Ta, col="cyan")
lines(time2,sensors$X1_BME280_Ta, col="orange")
lines(time2,sensors$X2_BME280_Ta, col="olivedrab")
legend(lty=1,inset=0.01, "topleft",legend=c("Climate Station", "AM2320", "1_DHT22","2_DHT22","1_HTU21D","2_HTU21D","1_MCP9808","2_MCP9808","1_BME680","2_BME680","1_BME280","2_BME280"), col =c("black","green","red","purple","blue","yellow","grey","brown","pink","cyan","orange","olivedrab"))
lines(time2,MET_CS215_AirTemperature_degC_Avg, col="black")
minor.tick(nx=0, ny=5)
#legend(lty=1,"topleft",legend=c("Climate Station", "AM2320", "1_DHT22","2_DHT22","1_HTU21D","2_HTU21D"), col =c("black","green","red","purple","blue","yellow"))
#legend(lty=1,x=("04.04.2020 08:00"),28,legend=c("1_MCP9808","2_MCP9808","1_BME680","2_BME680","1_BME280","2_BME280"),col=c("grey","brown","pink","cyan","orange","olivedrab"))


#plot Time ~ RH (all Sensors) raw

plot(time2,FRWRTM$MET_CS215_RelHumidity_percent_Avg ,type="l", ylim=c(25,90),xaxt="n", ylab="Relative Humidity ( % )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")

lines(time2,sensors$AM2320RH, col="green")
lines(time2,sensors$X1_DHT22_RH, col="red")
lines(time2,sensors$X2_DHT22_RH, col="purple")
lines(time2,sensors$X1_HTU21D_RH, col="blue")
lines(time2,sensors$X2_HTU21D_RH, col="yellow")
lines(time2,sensors$X1_BME680_RH, col="pink")
lines(time2,sensors$X2_BME680_RH, col="cyan")
lines(time2,sensors$X1_BME280_RH, col="orange")
legend(lty=1,inset=0.01,"topright",legend=c("Climate Station", "AM2320", "1_DHT22","2_DHT22","1_HTU21D","2_HTU21D","1_BME680","2_BME680","1_BME280"), col =c("black","green","red","purple","blue","yellow","pink","cyan","orange"))
minor.tick(nx=0, ny=5)

# plot Time ~ VP (All Sensors) raw Clausius-Clapeyron

cs215_SVP_calculated <- 6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(FRWRTM$MET_CS215_AirTemperature_degC_Avg+273.15))))
cs215_VP_calculated<-(FRWRTM$MET_CS215_RelHumidity_percent_Avg/100)*cs215_SVP_calculated  #Clausius-Clapeyron-Gleichung

cs215_vP_tafel<-(FRWRTM$MET_CS215_RelHumidity_percent_Avg/100)*611*exp((17.27*FRWRTM$MET_CS215_AirTemperature_degC_Avg)/(237.3+FRWRTM$MET_CS215_AirTemperature_degC_Avg))/100  # Ansatz für VPmax in der Psychrometertafel



plot(FRWRTM$MET_CS215_VapourPressure_hPa_Avg~cs215_VP_calculated) 

FRWRTM$MET_CS215_VapourPressure_hPa_Avg[1] 
cs215_VP_calculated[1]


am2320_SVP<- 6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(sensors$AM2320_Ta+273.15))))
am2320_VP <- (sensors$AM2320RH/100)*am2320_SVP

am2320_SVP<- 6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(sensors$AM2320_Ta_c+273.15))))


am2320_vP_tafel<-(sensors$AM2320RH/100)*611*exp((17.27*sensors$AM2320_Ta)/(237.3+sensors$AM2320_Ta))/100  # Ansatz für VPmax in der Psychrometertafel

x1_DHT22_svp_raw <-6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(X1_DHT22_Ta+273.15))))
x1_DHT22_vp_raw <- (X1_DHT22_RH/100)*x1_DHT22_svp_raw

x2_DHT22_svp_raw <-6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(X2_DHT22_Ta+273.15))))
x2_DHT22_vp_raw <- (X2_DHT22_RH/100)*x2_DHT22_svp_raw

X1_HTU21D_svp_raw <-6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(X1_HTU21D_Ta+273.15))))
X1_HTU21D_vp_raw <- (X1_HTU21D_RH/100)*X1_HTU21D_svp_raw

X2_HTU21D_svp_raw <-6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(X2_HTU21D_Ta+273.15))))
X2_HTU21D_vp_raw <- (X2_HTU21D_RH/100)*X2_HTU21D_svp_raw

X1_BME680_svp_raw <-6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(X1_BME680_Ta+273.15))))
X1_BME680_vp_raw <- (X1_BME680_RH/100)*X1_BME680_svp_raw

X2_BME680_svp_raw <-6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(X2_BME680_Ta+273.15))))
X2_BME680_vp_raw <- (X2_BME680_RH/100)*X2_BME680_svp_raw

X1_BME280_svp_raw <-6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(X1_BME280_Ta+273.15))))
X1_BME280_vp_raw <- (X1_BME280_RH/100)*X1_BME280_svp_raw



plot(time2,FRWRTM$MET_CS215_VapourPressure_hPa_Avg ,type="l", ylim=c(5,9.5),xaxt="n", main="Vapor Pressure calculated with Clausius-Clapeyron and the raw Data of Ta and RH ", ylab="Vapor Pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")

lines(time2,am2320_VP, col="green")
lines(time2,x1_DHT22_vp_raw, col="red")
lines(time2,x2_DHT22_vp_raw, col="purple")
lines(time2,X1_HTU21D_vp_raw, col="blue")
lines(time2,X2_HTU21D_vp_raw, col="yellow")
lines(time2,X1_BME680_vp_raw, col="pink")
lines(time2,X2_BME680_vp_raw, col="cyan")
lines(time2,X1_BME280_vp_raw, col="orange")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station", "AM2320", "1_DHT22","2_DHT22","1_HTU21D","2_HTU21D","1_BME680","2_BME680","1_BME280"), col =c("black","green","red","purple","blue","yellow","pink","cyan","orange"))
minor.tick(nx=0, ny=5)


# plot time Pressure
plot(time2,FRWRTM$MET_PTB100_PressureActual_hPa_Avg ,type="l", ylim=c(980,995),xaxt="n", main="actual pressure ", ylab="actual pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X1_BME680_P, col="green")
lines(time2,X2_BME680_P, col="red")
lines(time2,X1_BME280_P, col="orange")
lines(time2,X2_BME280_P, col="blue")
legend(lty=1,inset=0.01,"bottomright",legend=c("Climate Station", "1_BME680","2_BME680","1_BME280","2_BME280"), col =c("black","green","red","orange","blue"))
minor.tick(nx=0, ny=5)




lm(FRWRTM$MET_CS215_VapourPressure_hPa_Avg ~ cs215_VP_calculated)
lm(FRWRTM$MET_CS215_VapourPressure_hPa_Avg ~ cs215_vP_tafel)
lm(FRWRTM$MET_CS215_VapourPressure_hPa_Avg ~ am2320_VP)



rmse(cs215_vP_tafel, FRWRTM$MET_CS215_VapourPressure_hPa_Avg)
rmse(cs215_VP_calculated, FRWRTM$MET_CS215_VapourPressure_hPa_Avg)
rmse(am2320_vP_tafel, FRWRTM$MET_CS215_VapourPressure_hPa_Avg)


#Ta AM2320
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l",lwd=2, ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,sensors$AM2320_Ta, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "AM2320 (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~AM2320_Ta, main="AM2320 vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
lm(MET_CS215_AirTemperature_degC_Avg~AM2320_Ta)
rmse(AM2320_Ta, MET_CS215_AirTemperature_degC_Avg)
abline(-0.4452,1.0278,col="red", lwd=2)
text(c(7,5.5,5.7),c(18,17,16),labels=c("Ta (CS215) = 1.0278 * Ta (AM2320)  - 0.4452","RMSE(raw): 0.2107049 °C","RMSE(calib): 0.07954638 °C"), col=c("red","black","black"))

AM2320_Ta_calib=(1.0278*(AM2320_Ta)-0.4452)
rmse(AM2320_Ta_calib, MET_CS215_AirTemperature_degC_Avg)

#Ta x1_DHT22
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,X1_DHT22_Ta, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "1_DHT22 (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~X1_DHT22_Ta, main="1_DHT22 vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
lm(MET_CS215_AirTemperature_degC_Avg~X1_DHT22_Ta)
rmse(X1_DHT22_Ta, MET_CS215_AirTemperature_degC_Avg)
abline(-0.2868,1.0292,col="red", lwd=2)
text(c(7,5.5,5.7),c(18,17,16),labels=c("Ta (CS215) = 1.0292 * Ta (1_DHT22)  - 0.2868","RMSE(raw): 0.1750821 °C","RMSE(calib): 0.08961688 °C"), col=c("red","black","black"))

X1_DHT22_Ta_calib=(1.0292*(X1_DHT22_Ta)-0.2868)
rmse(X1_DHT22_Ta_calib, MET_CS215_AirTemperature_degC_Avg)

#Ta x2_DHT22
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,X2_DHT22_Ta, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "2_DHT22 (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~X2_DHT22_Ta, main="2_DHT22 vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
lm(MET_CS215_AirTemperature_degC_Avg~X2_DHT22_Ta)
rmse(X2_DHT22_Ta, MET_CS215_AirTemperature_degC_Avg)
abline(-0.382,1.030,col="red", lwd=2)
text(c(7,5.5,5.7),c(18,17,16),labels=c("Ta (CS215) = 1.030 * Ta (2_DHT22)  - 0.382","RMSE(raw): 0.1847389 °C","RMSE(calib): 0.09495004 °C"), col=c("red","black","black"))

X2_DHT22_Ta_calib=(1.030*(X2_DHT22_Ta)-0.382)
rmse(X2_DHT22_Ta_calib, MET_CS215_AirTemperature_degC_Avg)

#Ta x1_HTU21_D
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,X1_HTU21D_Ta, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "1_HTU21D_Ta (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~X1_HTU21D_Ta, main="1_HTU21D vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
rmse(X1_HTU21D_Ta, MET_CS215_AirTemperature_degC_Avg)
lm(MET_CS215_AirTemperature_degC_Avg~X1_HTU21D_Ta)
abline(+0.1769,1.0044 ,col="red", lwd=2)

X1_HTU21D_Ta_calib=(1.0044 *(X1_HTU21D_Ta)+0.1769)
rmse(X1_HTU21D_Ta_calib, MET_CS215_AirTemperature_degC_Avg)

text(c(7,5.5,5.7),c(18,17,16),labels=c("Ta (CS215) = 1.0044 * Ta (1_HTU21D)  + 0.1769","RMSE(raw): 0.2388976 °C","RMSE(calib): 0.07849901 °C"), col=c("red","black","black"))

#Ta x2_HTU21_D
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,X2_HTU21D_Ta, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "2_HTU21D_Ta (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~X2_HTU21D_Ta, main="2_HTU21D vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
rmse(X2_HTU21D_Ta, MET_CS215_AirTemperature_degC_Avg)
lm(MET_CS215_AirTemperature_degC_Avg~X2_HTU21D_Ta)
abline(+0.4499,1.0028 ,col="red", lwd=2)

X2_HTU21D_Ta_calib=(1.0028   *(X2_HTU21D_Ta)+0.4499)
rmse(X2_HTU21D_Ta_calib, MET_CS215_AirTemperature_degC_Avg)

text(c(7,5.5,5.7),c(18,17,16),labels=c("Ta (CS215) = 1.0028 * Ta (1_HTU21D)  + 0.4499","RMSE(raw): 0.4875104 °C","RMSE(calib): 0.08619138 °C"), col=c("red","black","black"))

#Ta x1_MCP9808
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,X1_MCP9808, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "1_MCP9808 (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~X1_MCP9808, main="1_MCP9808 vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
rmse(X1_MCP9808, MET_CS215_AirTemperature_degC_Avg)
lm(MET_CS215_AirTemperature_degC_Avg~X1_MCP9808)
abline(-0.2153,1.0115 ,col="red", lwd=2)

X1_MCP9808_calib=(1.0115 *(X1_MCP9808)-0.2153)
rmse(X1_MCP9808_calib, MET_CS215_AirTemperature_degC_Avg)

text(c(7,5.5,5.7),c(18,17,16),labels=c("Ta (CS215) = 1.0115 * Ta (1_MCP9808)  - 0.2153","RMSE(raw): 0.1523272 °C","RMSE(calib): 0.1096671 °C"), col=c("red","black","black"))

#Ta x2_MCP9808
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,X2_MCP9808, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "2_MCP9808 (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~X2_MCP9808, main="2_MCP9808 vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
rmse(X2_MCP9808, MET_CS215_AirTemperature_degC_Avg)
lm(MET_CS215_AirTemperature_degC_Avg~X2_MCP9808)
abline(0.01665,1.00716 ,col="red", lwd=2)

X2_MCP9808_calib=(1.00716 *(X2_MCP9808)+0.01665)
rmse(X2_MCP9808_calib, MET_CS215_AirTemperature_degC_Avg)

text(c(7,5.5,5.5),c(18,17,16),labels=c("Ta (CS215) = 1.00716 * Ta (2_MCP9808)  + 0.01665","RMSE(raw): 0.1587282  °C","RMSE(calib): 0.121885 °C"), col=c("red","black","black"))

#Ta x1_BME680
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,X1_BME680_Ta, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "1_BME680 (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~X1_BME680_Ta, main="1_BME680 vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
rmse(X1_BME680_Ta, MET_CS215_AirTemperature_degC_Avg)
lm(MET_CS215_AirTemperature_degC_Avg~X1_BME680_Ta)
abline(+0.05413,0.99297 ,col="red", lwd=2)

X1_BME680_Ta_calib=(0.99297 *(X1_BME680_Ta)+0.05413)
rmse(X1_BME680_Ta_calib, MET_CS215_AirTemperature_degC_Avg)

text(c(8,5.5,5.7),c(18,17,16),labels=c("Ta (CS215) = 0.99297 * Ta (1_BME680)  + 0.08693147","RMSE(raw): 0.1587282  °C","RMSE(calib): 0.07525701 °C"), col=c("red","black","black"))

#Ta X2_BME680
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,X2_BME680_Ta, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "2_BME680 (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~X2_BME680_Ta, main="2_BME680 vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
rmse(X2_BME680_Ta, MET_CS215_AirTemperature_degC_Avg)
lm(MET_CS215_AirTemperature_degC_Avg~X2_BME680_Ta)
abline(-0.08292,0.98992 ,col="red", lwd=2)

X2_BME680_Ta_calib=(0.98992 *(X2_BME680_Ta)-0.08292)
rmse(X2_BME680_Ta_calib, MET_CS215_AirTemperature_degC_Avg)

text(c(7.5,5.5,5.7),c(18,17,16),labels=c("Ta (CS215) = 0.98992 * Ta (2_BME680)  - 0.08292 ","RMSE(raw): 0.2188592  °C","RMSE(calib): 0.08245605 °C"), col=c("red","black","black"))

#Ta x1_BME280
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,X1_BME280_Ta, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "1_BME280 (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~X1_BME280_Ta, main="1_BME280 vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
rmse(X1_BME280_Ta, MET_CS215_AirTemperature_degC_Avg)
lm(MET_CS215_AirTemperature_degC_Avg~X1_BME280_Ta)
abline(0.9421,0.9998 ,col="red", lwd=2)

X1_BME280_Ta_calib=(0.9998 *(X1_BME280_Ta)+0.9421)
rmse(X1_BME280_Ta_calib, MET_CS215_AirTemperature_degC_Avg)

text(c(7,5.5,5.5),c(18,17,16),labels=c("Ta (CS215) = 0.9998 * Ta (1_BME280)  + 0.9421","RMSE(raw): 0.9483656 °C","RMSE(calib): 0.121885 °C"), col=c("red","black","black"))

#Ta X2_BME280
plot(time2,FRWRTM$MET_CS215_AirTemperature_degC_Avg ,type="l", ylim=c(2.5,23),xaxt="n", ylab="Air Temperatur ( °C )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
minor.tick(ny=5,nx=0)
lines(time2,X2_BME280_Ta, col="red")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "2_BME280 (raw)"), col =c("black","red"))

plot(MET_CS215_AirTemperature_degC_Avg~X2_BME280_Ta, main="2_BME280 vs CS215 ",ylab = "CS215_Ta")
minor.tick(nx=5, ny=5)
grid()
rmse(X2_BME280_Ta, MET_CS215_AirTemperature_degC_Avg)
lm(MET_CS215_AirTemperature_degC_Avg~X2_BME280_Ta)
abline(0.7338,1.0018 ,col="red", lwd=2)

X2_BME280_Ta_calib=(1.0018 *(X2_BME280_Ta)+0.7338)
rmse(X2_BME280_Ta_calib, MET_CS215_AirTemperature_degC_Avg)

text(c(7,5.5,5.5),c(18,17,16),labels=c("Ta (CS215) = 1.0018 * Ta (2_BME280)  + 0.7338","RMSE(raw): 0.7602216  °C","RMSE(calib): 0.1100378 °C"), col=c("red","black","black"))


#########################################################


#humidity AM2320
plot(time2,FRWRTM$MET_CS215_RelHumidity_percent_Avg ,type="l", ylim=c(25,95),xaxt="n", ylab="Relative Humidity ( % )",xlab="Time ( CEST )")
minor.tick(nx=0, ny=5)
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,AM2320RH, col="red")
legend(lty=1,inset=0.01,"topright",legend=c("Climate Station CS215", "AM2320"), col =c("black","red"))


plot(time2,FRWRTM$MET_CS215_VapourPressure_hPa_Avg ,type="l", ylim=c(5,9.5),xaxt="n", ylab="Vapor Pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "AM2320"), col =c("black","red"))
minor.tick(nx=0, ny=5)
lines(time2,am2320_VP, col="red")

#am2320_SVP_calib<- 6.113*exp((2501000.0/461.5)*((1.0/273.15)-(1.0/(AM2320_Ta_calib+273.15))))
#am2320_VP <- (sensors$AM2320RH/100)*am2320_SVP_calib

plot(MET_CS215_VapourPressure_hPa_Avg~am2320_VP, main="AM2320 vs CS215 ",ylab = "CS215_VP")
minor.tick(nx=5, ny=5)
grid()
rmse(am2320_VP, MET_CS215_VapourPressure_hPa_Avg)
lm(MET_CS215_VapourPressure_hPa_Avg~am2320_VP)
abline(0.8477,0.7493 ,col="red", lwd=2)

am2320_VP_calib=(0.7493 *(am2320_VP)+0.8477)
rmse(am2320_VP_calib, MET_CS215_VapourPressure_hPa_Avg)

text(c(7.4,7.1,7.14),c(8,7.8,7.6),labels=c("VP (CS215) = 0.7493 * VP (AM2320)  + 0.8477","RMSE(raw): 1.189864  °C","RMSE(calib): 0.2317108"), col=c("red","black","black"))

#humidity x1_DHT22
plot(time2,FRWRTM$MET_CS215_RelHumidity_percent_Avg ,type="l", ylim=c(25,95),xaxt="n", ylab="Relative Humidity ( % )",xlab="Time ( CEST )")
minor.tick(nx=0, ny=5)
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X1_DHT22_RH, col="red")
legend(lty=1,inset=0.01,"topright",legend=c("Climate Station CS215", "1_DHT22"), col =c("black","red"))


plot(time2,FRWRTM$MET_CS215_VapourPressure_hPa_Avg ,type="l", ylim=c(5,9.5),xaxt="n", ylab="Vapor Pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "1_DHT22"), col =c("black","red"))
minor.tick(nx=0, ny=5)
lines(time2,x1_DHT22_vp_raw, col="red")

plot(MET_CS215_VapourPressure_hPa_Avg~x1_DHT22_vp_raw, main="1_DHT22 vs CS215 Vapor Pressure (hPa)",ylab = "CS215_VP")
minor.tick(nx=5, ny=5)
grid()
rmse(x1_DHT22_vp_raw, MET_CS215_VapourPressure_hPa_Avg)
lm(MET_CS215_VapourPressure_hPa_Avg~x1_DHT22_vp_raw)
abline(0.6247,0.9436 ,col="red", lwd=2)

X1_DHT22_VP_calib=(0.9436 *(x1_DHT22_vp_raw)+0.6247)
rmse(X1_DHT22_VP_calib, MET_CS215_VapourPressure_hPa_Avg)

text(c(6.3,6,6.03),c(8,7.8,7.6),labels=c("VP (CS215) = 0.9436 * VP (1_DHT22)  + 0.6247","RMSE(raw): 0.2714386","RMSE(calib): 0.08744526"), col=c("red","black","black"))

#humidity x2_DHT22
plot(time2,FRWRTM$MET_CS215_RelHumidity_percent_Avg ,type="l", ylim=c(25,95),xaxt="n", ylab="Relative Humidity ( % )",xlab="Time ( CEST )")
minor.tick(nx=0, ny=5)
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X2_DHT22_RH, col="red")
legend(lty=1,inset=0.01,"topright",legend=c("Climate Station CS215", "2_DHT22"), col =c("black","red"))


plot(time2,FRWRTM$MET_CS215_VapourPressure_hPa_Avg ,type="l", ylim=c(5,9.5),xaxt="n", ylab="Vapor Pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "2_DHT22"), col =c("black","red"))
minor.tick(nx=0, ny=5)
lines(time2,x2_DHT22_vp_raw, col="red")

plot(MET_CS215_VapourPressure_hPa_Avg~x2_DHT22_vp_raw, main="2_DHT22 vs CS215 Vapor Pressure (hPa)",ylab = "CS215_VP")
minor.tick(nx=5, ny=5)
grid()
rmse(x2_DHT22_vp_raw, MET_CS215_VapourPressure_hPa_Avg)
lm(MET_CS215_VapourPressure_hPa_Avg~x2_DHT22_vp_raw)
abline(0.6745,0.8905 ,col="red", lwd=2)

X2_DHT22_VP_calib=(0.8905 *(x2_DHT22_vp_raw)+0.6745)
rmse(X2_DHT22_VP_calib, MET_CS215_VapourPressure_hPa_Avg)

text(c(6.6,6.3,6.34),c(8,7.8,7.6),labels=c("VP (CS215) = 0.8905 * VP (AM2320)  + 0.6745","RMSE(raw): 0.1458398","RMSE(calib): 0.09409951"), col=c("red","black","black"))

#humidity x1_HTU21D
plot(time2,FRWRTM$MET_CS215_RelHumidity_percent_Avg ,type="l", ylim=c(25,95),xaxt="n", ylab="Relative Humidity ( % )",xlab="Time ( CEST )")
minor.tick(nx=0, ny=5)
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X1_HTU21D_RH, col="red")
legend(lty=1,inset=0.01,"topright",legend=c("Climate Station CS215", "1_HTU21D"), col =c("black","red"))


plot(time2,FRWRTM$MET_CS215_VapourPressure_hPa_Avg ,type="l", ylim=c(5,9.5),xaxt="n", ylab="Vapor Pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "1_HTU21D"), col =c("black","red"))
minor.tick(nx=0, ny=5)
lines(time2,X1_HTU21D_vp_raw, col="red")

plot(MET_CS215_VapourPressure_hPa_Avg~X1_HTU21D_vp_raw, main="1_HTU21D vs CS215 Vapor Pressure",ylab = "CS215_VP")
minor.tick(nx=5, ny=5)
grid()
rmse(X1_HTU21D_vp_raw, MET_CS215_VapourPressure_hPa_Avg)
lm(MET_CS215_VapourPressure_hPa_Avg~X1_HTU21D_vp_raw)
abline(0.3980,0.9598 ,col="red", lwd=2)

X1_HTU21D_VP_calib=(0.9598 *(X1_HTU21D_vp_raw)+0.3980)
rmse(X1_HTU21D_VP_calib, MET_CS215_VapourPressure_hPa_Avg)

text(c(6.4,6.01,6.03),c(8,7.8,7.6),labels=c("VP (CS215) = 0.9598 * VP (1_HTU21D)  + 0.3980","RMSE(raw): 0.1908347","RMSE(calib): 0.1382632"), col=c("red","black","black"))


#humidity x2_HTU21D
plot(time2,FRWRTM$MET_CS215_RelHumidity_percent_Avg ,type="l", ylim=c(25,95),xaxt="n", ylab="Relative Humidity ( % )",xlab="Time ( CEST )")
minor.tick(nx=0, ny=5)
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X2_HTU21D_RH, col="red")
legend(lty=1,inset=0.01,"topright",legend=c("Climate Station CS215", "2_HTU21D"), col =c("black","red"))


plot(time2,FRWRTM$MET_CS215_VapourPressure_hPa_Avg ,type="l", ylim=c(5,9.5),xaxt="n", ylab="Vapor Pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "2_HTU21D"), col =c("black","red"))
minor.tick(nx=0, ny=5)
lines(time2,X2_HTU21D_vp_raw, col="red")

plot(MET_CS215_VapourPressure_hPa_Avg~X2_HTU21D_vp_raw, main="2_HTU21D vs CS215 Vapor Pressure",ylab = "CS215_VP")
minor.tick(nx=5, ny=5)
grid()
rmse(X2_HTU21D_vp_raw, MET_CS215_VapourPressure_hPa_Avg)
lm(MET_CS215_VapourPressure_hPa_Avg~X2_HTU21D_vp_raw)
abline(0.4823,0.9558 ,col="red", lwd=2)

X2_HTU21D_VP_calib=(0.9558 *(X2_HTU21D_vp_raw)+0.4823)
rmse(X2_HTU21D_VP_calib, MET_CS215_VapourPressure_hPa_Avg)

text(c(6.4,6.01,6.04),c(8,7.8,7.6),labels=c("VP (CS215) = 0.9558 * VP (2_HTU21D)  + 0.4823","RMSE(raw): 0.232505","RMSE(calib): 0.1318549"), col=c("red","black","black"))


#humidity X1_BME680
plot(time2,FRWRTM$MET_CS215_RelHumidity_percent_Avg ,type="l", ylim=c(25,95),xaxt="n", ylab="Relative Humidity ( % )",xlab="Time ( CEST )")
minor.tick(nx=0, ny=5)
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X1_BME680_RH, col="red")
legend(lty=1,inset=0.01,"topright",legend=c("Climate Station CS215", "1_BME680"), col =c("black","red"))


plot(time2,FRWRTM$MET_CS215_VapourPressure_hPa_Avg ,type="l", ylim=c(5,9.5),xaxt="n", ylab="Vapor Pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "1_BME680"), col =c("black","red"))
minor.tick(nx=0, ny=5)
lines(time2,X1_BME680_vp_raw, col="red")

plot(MET_CS215_VapourPressure_hPa_Avg~X1_BME680_vp_raw, main="1_BME680 vs CS215 Vapor Pressure",ylab = "CS215_VP")
minor.tick(nx=5, ny=5)
grid()
rmse(X1_BME680_vp_raw, MET_CS215_VapourPressure_hPa_Avg)
lm(MET_CS215_VapourPressure_hPa_Avg~X1_BME680_vp_raw)
abline(1.538,0.796 ,col="red", lwd=2)

X1_BME680_VP_calib=(0.796 *(X1_BME680_vp_raw)+1.538)
rmse(X1_BME680_VP_calib, MET_CS215_VapourPressure_hPa_Avg)

text(c(6.3,6.01,6.03),c(8,7.8,7.6),labels=c("VP (CS215) = 0.796 * VP (1_BME680)  + 1.538","RMSE(raw): 0.2779574","RMSE(calib): 0.1360564"), col=c("red","black","black"))



#humidity X2_BME680
plot(time2,FRWRTM$MET_CS215_RelHumidity_percent_Avg ,type="l", ylim=c(25,95),xaxt="n", ylab="Relative Humidity ( % )",xlab="Time ( CEST )")
minor.tick(nx=0, ny=5)
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X2_BME680_RH, col="red")
legend(lty=1,inset=0.01,"topright",legend=c("Climate Station CS215", "2_BME680"), col =c("black","red"))


plot(time2,FRWRTM$MET_CS215_VapourPressure_hPa_Avg ,type="l", ylim=c(5,9.5),xaxt="n", ylab="Vapor Pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "2_BME680"), col =c("black","red"))
minor.tick(nx=0, ny=5)
lines(time2,X2_BME680_vp_raw, col="red")

plot(MET_CS215_VapourPressure_hPa_Avg~X2_BME680_vp_raw, main="2_BME680 vs CS215 Vapor Pressure",ylab = "CS215_VP")
minor.tick(nx=5, ny=5)
grid()
rmse(X2_BME680_vp_raw, MET_CS215_VapourPressure_hPa_Avg)
lm(MET_CS215_VapourPressure_hPa_Avg~X2_BME680_vp_raw)
abline( 1.5892,0.7963 ,col="red", lwd=2)

X2_BME680_VP_calib=(0.7963 *(X2_BME680_vp_raw)+ 1.5892)
rmse(X2_BME680_VP_calib, MET_CS215_VapourPressure_hPa_Avg)

text(c(6.3,6.01,6.03),c(8,7.8,7.6),labels=c("VP (CS215) = 0.7963 * VP (2_BME680)  +  1.5892","RMSE(raw): 0.3271391","RMSE(calib): 0.1397137"), col=c("red","black","black"))




#humidity X1_BME280
plot(time2,FRWRTM$MET_CS215_RelHumidity_percent_Avg ,type="l", ylim=c(25,95),xaxt="n", ylab="Relative Humidity ( % )",xlab="Time ( CEST )")
minor.tick(nx=0, ny=5)
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X1_BME280_RH, col="red")
legend(lty=1,inset=0.01,"topright",legend=c("Climate Station CS215", "1_BME280"), col =c("black","red"))


plot(time2,FRWRTM$MET_CS215_VapourPressure_hPa_Avg ,type="l", ylim=c(5,9.5),xaxt="n", ylab="Vapor Pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
legend(lty=1,inset=0.01,"topleft",legend=c("Climate Station CS215", "1_BME280"), col =c("black","red"))
minor.tick(nx=0, ny=5)
lines(time2,X1_BME280_vp_raw, col="red")

plot(MET_CS215_VapourPressure_hPa_Avg~X1_BME280_vp_raw, main="1_BME280 vs CS215 Vapor Pressure",ylab = "CS215_VP")
minor.tick(nx=5, ny=5)
grid()
rmse(X1_BME280_vp_raw, MET_CS215_VapourPressure_hPa_Avg)
lm(MET_CS215_VapourPressure_hPa_Avg~X1_BME280_vp_raw)
abline(-0.04929,1.16144,col="red", lwd=2)
X1_BME280_VP_calib=(1.16144  *(X1_BME280_vp_raw)-0.04929)
rmse(X1_BME280_VP_calib, MET_CS215_VapourPressure_hPa_Avg)

text(c(5.7,5.41,5.43),c(8,7.8,7.6),labels=c("VP (CS215) = 1.16144  * VP (1_BME280)  - 0.04929","RMSE(raw): 0.9195801","RMSE(calib): 0.1349748"), col=c("red","black","black"))


####################  Pressure


plot(time2,FRWRTM$MET_PTB100_PressureActual_hPa_Avg ,type="l", ylim=c(980,995),xaxt="n", main="Actual Pressure 1_BME680 ", ylab="actual pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X1_BME680_P, col="red")
legend(lty=1,inset=0.01,"bottomright",legend=c("Climate Station PBT100", "1_BME680"), col =c("black","red"))
minor.tick(nx=0, ny=5)

plot(MET_PTB100_PressureActual_hPa_Avg~X1_BME680_P, main="1_BME680 vs PTB100 Pressure Actual (hPa)",ylab = "PBT100_P")
minor.tick(nx=5, ny=5)
grid()
rmse(X1_BME680_P, MET_PTB100_PressureActual_hPa_Avg)
lm(MET_PTB100_PressureActual_hPa_Avg~X1_BME680_P)
abline(53.7062,0.9431,col="red", lwd=2)
X1_BME680_P_calib=(0.9431  *(X1_BME680_P)+53.7062)
rmse(X1_BME680_P_calib, MET_PTB100_PressureActual_hPa_Avg)

text(c(987.5,986.88,987),c(987.75,987.5,987.25),labels=c("P (PBT100) = 0.9431  * P (1_BME680)  + 53.7062","RMSE(raw): 2.582043","RMSE(calib): 0.08572349"), col=c("red","black","black"))

############################

plot(time2,FRWRTM$MET_PTB100_PressureActual_hPa_Avg ,type="l", ylim=c(980,995),xaxt="n", main="Actual Pressure 2_BME680 ", ylab="actual pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X2_BME680_P, col="red")
legend(lty=1,inset=0.01,"bottomright",legend=c("Climate Station PBT100", "2_BME680"), col =c("black","red"))
minor.tick(nx=0, ny=5)

plot(MET_PTB100_PressureActual_hPa_Avg~X2_BME680_P, main="2_BME680 vs PTB100 Pressure Actual (hPa)",ylab = "PBT100_P")
minor.tick(nx=5, ny=5)
grid()
rmse(X2_BME680_P, MET_PTB100_PressureActual_hPa_Avg)
lm(MET_PTB100_PressureActual_hPa_Avg~X2_BME680_P)
abline(90.7679,0.9042,col="red", lwd=2)
X2_BME680_P_calib=(0.9042  *(X2_BME680_P)+90.7679)
rmse(X2_BME680_P_calib, MET_PTB100_PressureActual_hPa_Avg)

text(c(989.2,988.43,988.5),c(987.75,987.5,987.25),labels=c("P (PBT100) = 0.9042  * P (2_BME680)  + 90.7679","RMSE(raw): 4.176867","RMSE(calib): 0.1304444"), col=c("red","black","black"))

############################################

plot(time2,FRWRTM$MET_PTB100_PressureActual_hPa_Avg ,type="l", ylim=c(980,995),xaxt="n", main="Actual Pressure 1_BME280 ", ylab="actual pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X1_BME280_P, col="red")
legend(lty=1,inset=0.01,"bottomright",legend=c("Climate Station PBT100", "1_BME280"), col =c("black","red"))
minor.tick(nx=0, ny=5)

plot(MET_PTB100_PressureActual_hPa_Avg~X1_BME280_P, main="1_BME280 vs PTB100 Pressure Actual (hPa)",ylab = "PBT100_P")
minor.tick(nx=5, ny=5)
grid()
rmse(X1_BME280_P, MET_PTB100_PressureActual_hPa_Avg)
lm(MET_PTB100_PressureActual_hPa_Avg~X1_BME280_P)
abline(56.7623,0.9403,col="red", lwd=2)
X1_BME280_P_calib=(0.9403  *(X1_BME280_P)+56.7623)
rmse(X1_BME280_P_calib, MET_PTB100_PressureActual_hPa_Avg)

text(c(987.5,986.88,987),c(987.75,987.5,987.25),labels=c("P (PBT100) = 0.9403  * P (1_BME280)  + 56.7623","RMSE(raw): 2.320534","RMSE(calib): 0.09050464"), col=c("red","black","black"))

##################################################

plot(time2,FRWRTM$MET_PTB100_PressureActual_hPa_Avg ,type="l", ylim=c(980,995),xaxt="n", main="Actual Pressure 2_BME280 ", ylab="actual pressure ( hPa )",xlab="Time ( CEST )")
axis.POSIXct(1,las=1, time2, at = seq(from=time2[91], to=time2[3210], by = (60*60*12)), format="%d.%m.%Y %H:%M")
lines(time2,X2_BME280_P, col="red")
legend(lty=1,inset=0.01,"bottomright",legend=c("Climate Station PBT100", "2_BME280"), col =c("black","red"))
minor.tick(nx=0, ny=5)

plot(MET_PTB100_PressureActual_hPa_Avg~X2_BME280_P, main="2_BME280 vs PTB100 Pressure Actual (hPa)",ylab = "PBT100_P")
minor.tick(nx=5, ny=5)
grid()
rmse(X2_BME280_P, MET_PTB100_PressureActual_hPa_Avg)
lm(MET_PTB100_PressureActual_hPa_Avg~X2_BME280_P)
abline(54.7224,0.9419,col="red", lwd=2)
X2_BME280_P_calib=(0.9419  *(X2_BME280_P)+54.7224)
rmse(X2_BME280_P_calib, MET_PTB100_PressureActual_hPa_Avg)

text(c(987.7,987,987.125),c(987.75,987.5,987.25),labels=c("P (PBT100) = 0.9419  * P (2_BME280)  + 54.7224","RMSE(raw): 2.794057","RMSE(calib):  0.08769271"), col=c("red","black","black"))

