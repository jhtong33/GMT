#!/bin/csh
set grd=Armenia.grd
set int=Armenia.int
set event=2010-2020LargeRangeEvents.txt
set GPS=/Volumes/home/Research/DataBase/Iran_GPS_velocity.csv
set RGPS=/Volumes/home/Research/DataBase/03_Reilinger_R_etal_GPS_relativeEurasia/jgrb14718-sup-0002-ts01.txt
set AGPS=/Volumes/home/Research/DataBase/01_Armenia/03_Armenia_GPS_velocity.csv

gmt begin GeologyMap_v1 pdf A+m1c
gmt set FORMAT_GEO_MAP ddd.x
gmt set FONT_LABEL 12p,4,black
gmt set FONT_TITLE 18p,26,black


gmt makecpt -Celevation -T0/4000/500 -D -Z
gmt basemap -JM7.5i  -R30/60/30/47 -Ba2f1 -BWNse -X+2 -Y+3 -U/0.5/15/"Tong"
gmt grdcut @earth_relief_30s -G$grd -R30/60/30/47
gmt grdimage $grd -I+d  -t40
gmt grdgradient $grd -A0/90 -G$int -Ne0.2
gmt coast -W1p -Dh -A150  -EAM,TR,IR,GE,RU,IQ,AZ,KZ,UZ,SY,JO+p0.5p,black,-- -S145/200/255 -t30 #-Lg44/46+c42+w1000+u

gmt plot PB2002_boundaries.dig.txt -W3p,darkbrown

###Event 
awk '{if ($6<5) {print $1,$2}}' $event | gmt plot -Sc0.08c -G160 -W0.05p,120
awk '{if (5<=$6 && $6<6) {print $1,$2}}' $event | gmt plot -Sc0.1c -G140 -W0.05p,120
awk '{if (6<=$6) {print $1,$2}}' $event | gmt plot -Sa0.3c -Ggold1 -W0.05p,120

###Plate relative motion
#Arabian plate
##GSRM v2.1, speed 17.98 mm/yr N17.73 E-2.97
echo 41 36 350.50 2c | gmt plot -SV1c+ea -W8p,50 -G50 
echo 40.8 37 -80 17.98mm/yr | gmt text -F+a -F+f6.5p,1,white
#Anatolian block

###GPS
#Relative Velocity
set Rcolor=black
set scale=0.05c
awk -F, 'NR>1 && $9 ~ /Raeesi/ {print $2,$3,$4,$5,$6,$7,$8}' $GPS > temp.out
gmt psvelo temp.out -Se$scale/0.95/4 -G$Rcolor -W0.5p,$Rcolor -A0.2c+p1.2p+e -t40
awk -F, 'NR>1 && $9 ~ /IPGN/ {print $2,$3,$4,$5,$6,$7,$8}' $GPS > temp2.out
gmt psvelo temp2.out -Se$scale/0.95/4  -Gdarkred  -W0.5p,darkred -A0.2c+p1.2p+e  -t40
awk 'NR>1 {print $2,$3,$4,$5,$6,$7,$8}' $RGPS > temp3.out
gmt psvelo temp3.out -Se$scale/0.95/4  -Gblue -W0.5p,blue -A0.2c+p1.2p+e  -t40
awk -F, 'NR>1 {print $1,$2,$3,$4,$5,$6,$7}' $AGPS >temp4.out
gmt psvelo temp4.out -Se$scale/0.95/4  -Gdodgerblue1 -W0.3p,dodgerblue1 -A0.2c+p2p+e  -t40

###Plate name
gmt text -F+f18p,3,black+jLM <<EOF
38 35 Arabian Plate
47 35 Eurasian Plate
31 39 Anatolian Block
32 33 Africa
32 32 Plate
EOF

###Red box for Caucasus
echo 41 45 Caucasus Region | gmt text -F+f15p,5,black+jLM -Gred@30
gmt plot -W2p,red <<EOF
39 44.5
49.5 44.5
49.5 39
39 39 
39 44.5
EOF



gmt text -F+a -F+f14p,7,black=~1.5,white+jLM <<EOF
42 43.5 -23 Greater Caucasus 
41.8 41.8 -22 Lesser Caucasus
50 34 0 Iranian Plateau
48 33.5 -37 Zargos
55.5 37.8 0 Kopeh dagu
56 36.8 0 Binalud
EOF

gmt text -F+f14p,9,50+jLM <<EOF
49.8 39 Caspian
50.3 38 Sea
33 43 Black Sea
EOF


##Legend
gmt colorbar -C -Dx2.5c/-1c+w5c/0.3c+jTC+h+ml -Bxaf+l"Topography" -By+lm -N

##GPS
echo 40 29.5 GPS Velocity relative to EU|gmt text  -F+f10p,5,50+jLM -N
echo 40.5 25.7 10mm/yr | gmt text -F+f8p,5,50+jCM -N
gmt text -F+f8.5p,5,50+jLM -N <<EOF
41.2 28.7 IPGN
41.2 27.9 Raeesi et al., (2017)
41.2 27.1 Relinger et al., (2006)
41.2 26.3 Karakhanyan, A et al., (2013)
EOF
gmt psvelo -Se$scale/0.95/4  -G$Rcolor -W0.5p,$Rcolor -A0.3c+p1.2p+e  -N<<EOF
40 28.7 10 0 0 0 0  
EOF
gmt psvelo -Se$scale/0.95/4  -Gdarkred -W0.5p,darkred -A0.3c+p1.2p+e  -N<<EOF
40 27.9 10 0 0 0 0
EOF
gmt psvelo -Se$scale/0.95/4  -Gblue -W0.5p,blue -A0.3c+p1.2p+e  -N<<EOF
40 27.1 10 0 0 0 0
EOF
gmt psvelo -Se$scale/0.95/4  -Gdodgerblue1 -W0.5p,dodgerblue1 -A0.3c+p1.2p+e -N <<EOF
40 26.3 10 0 0 0 0
EOF
##Plate
echo 48 29.5 Plate motion relative to EU|gmt text  -F+f10p,5,50+jLM -N
echo 48 28.7 90 1.5c | gmt plot -SV1c+ea -W8p,50 -G50 -N
echo 50.5 28.7 Model: GSRMv2.1 | gmt text -F+f8p,5,50+jLM -N
echo 50.5 28.0 Kreemer et al., 2014 | gmt text -F+f8p,5,50+jLM -N
##Earthquake
echo 56 29.5 Earthquakes | gmt text  -F+f10p,5,50+jLM -N
echo 56 28.7 | gmt plot -Sc0.08c -G160 -W0.05p,120 -N
echo 56 27.9 | gmt plot -Sc0.1c -G140 -W0.05p,120 -N
echo 56 27.1 | gmt plot -Sa0.3c -Ggold1 -W0.05p,120 -N
gmt text -F+f8.5p,5,50+jLM -N <<EOF
56.5 28.7 4.0 @~\243@~ Mag< 5.0
56.5 27.9 5.0 @~\243@~ Mag< 6.0
56.5 27.1 6.0 @~\243@~ Mag
EOF




gmt end show

rm -f temp*.out