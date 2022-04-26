#!/bin/csh
set grd=Armenia.grd
set int=Armenia.int
set event=2010-2020LargeRangeEvents.txt
set GPS=/Volumes/home/Research/DataBase/Iran_GPS_velocity.csv
set RGPS=/Volumes/home/Research/DataBase/03_Reilinger_R_etal_GPS_relativeEurasia/jgrb14718-sup-0002-ts01.txt
set AGPS=/Volumes/home/Research/DataBase/01_Armenia/03_Armenia_GPS_velocity.csv
set Volcano=/Volumes/home/Research/DataBase/01_Armenia/02_Volcano_list.csv

set region=36/52/35/45

gmt begin GeologyMap_v5 pdf A+m1c
gmt set FORMAT_GEO_MAP ddd.x
gmt set FONT_LABEL 12p,4,black
gmt set FONT_TITLE 18p,26,black


gmt makecpt -Celevation -T0/4000/500 -D -Z
gmt basemap -JM7.5i  -R$region -Ba2f1 -BWNse -X+2 -Y+3 -U/0.5/17/"Tong"
# gmt grdcut @earth_relief_30s -G$grd -R$region
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
echo 41 36 350.50 3c | gmt plot -SV2c+ea -W12p,50 -G50 
echo 40.8 37 -80 17.98mm/yr | gmt text -F+a -F+f6.5p,1,white
#Anatolian block

###GPS
#Relative Velocity
set Rcolor=150
set scale=0.05c
# awk -F, 'NR>1 {print $2,$3,$4,$5,$6,$7,$8}' $GPS > temp.out
# gmt psvelo temp.out -Se$scale/0.95/4 -Gwhite -W0.5p,blue -A0.35c+p1.3p+e -t20
# awk -F, 'NR>1 && $9 ~ /IPGN/ {print $2,$3,$4,$5,$6,$7,$8}' $GPS > temp2.out
# gmt psvelo temp2.out -Se$scale/0.95/4  -Gdarkred  -W0.5p,darkred -A0.2c+p1.2p+e  -t40
# awk 'NR>1 {print $2,$3,$4,$5,$6,$7,$8}' $RGPS > temp3.out
# gmt psvelo temp3.out -Se$scale/0.95/4  -Gwhite -W0.5p,lightblue  -A0.35c+p1.3p+e -t20
# awk -F, 'NR>1 {print $1,$2,$3,$4,$5,$6,$7}' $AGPS >temp4.out
# gmt psvelo temp4.out -Se$scale/0.95/4  -Gdodgerblue1 -W0.3p,dodgerblue1 -A0.2c+p2p+e  -t40

##Volcano
cat $Volcano | awk -F, 'NR>1 {if ($7 == "1") print $3,$2}' | gmt plot -Skvolcano/0.4 -Gdarkred -W0.5p,black
cat $Volcano | awk -F, 'NR>1 {if ($7 == "2") print $3,$2}' | gmt plot -Skvolcano/0.4 -Gblack -W0.5p,black
cat $Volcano | awk -F, 'NR>1 {if ($7 == "3") print $3,$2}' | gmt plot -Skvolcano/0.4 -Ggrey -W0.5p,black

###Plate name
gmt text -F+f18p,3,darkbrown+jLM -W1.5p,darkbrown  <<EOF
39 35.7 Arabian Plate
42 44.2 Eurasian Plate
EOF
gmt text -F+f18p,3,black+jLM <<EOF
36.3 39.5 Anatolian
36.87 38.8 Block
EOF

gmt text -F+a -F+f18p,7,black=~1.5,white+jLM <<EOF
42 43.5 -23 Greater Caucasus 
41.8 41.8 -22 Lesser Caucasus
40.5 39.5 -32 Bitlis-Zagros Suture
EOF

gmt text -F+a -F+f15p,7,50=~1.5,white+jLM <<EOF
45.7 37 0 Iranian Plateau
40 40.4 0 Eastern Anatolian
EOF

gmt text -F+f18p,9,50+jLM <<EOF
49.8 39 Caspian
50.3 38.4 Sea
37 42.3 Black Sea
EOF


##Legend
gmt colorbar -C -Dx2.5c/-1c+w5c/0.3c+jTC+h+ml -Bxaf+l"Topography" -By+lm -N
##Plate
echo 42 34.5 Plate motion relative to EU|gmt text  -F+f10p,5,50+jLM -N
echo 42 34.0 90 1.5c | gmt plot -SV1c+ea -W8p,50 -G50 -N
echo 43.5 34.1 Model: GSRMv2.1 | gmt text -F+f8p,5,50+jLM -N
echo 43.5 33.8 Kreemer et al., 2014 | gmt text -F+f8p,5,50+jLM -N
##Earthquake
echo 46 34.5 Earthquakes | gmt text  -F+f10p,5,50+jLM -N
echo 46 34.1 | gmt plot -Sc0.08c -G160 -W0.05p,120 -N
echo 46 33.8 | gmt plot -Sc0.1c -G140 -W0.05p,120 -N
echo 46 33.5 | gmt plot -Sa0.3c -Ggold1 -W0.05p,120 -N
gmt text -F+f8.5p,5,50+jLM -N <<EOF
46.5 34.1 4.0 @~\243@~ Mag< 5.0
46.5 33.8 5.0 @~\243@~ Mag< 6.0
46.5 33.5 6.0 @~\243@~ Mag
EOF
##Volcano
echo 49 34.5 Volcanos | gmt text  -F+f10p,5,50+jLM -N
echo 49.2 34.1 |gmt plot -Skvolcano/0.3 -Gdarkred -W0.5p,black -N
echo 49.2 33.7 |gmt plot -Skvolcano/0.3 -Gblack -W0.5p,black -N
echo 49.2 33.3 |gmt plot -Skvolcano/0.3 -Ggrey -W0.5p,black -N

gmt text -F+f8.5p,5,50+jLM -N <<EOF
49.5 34.1 Last eruption< 10000yrs
49.5 33.7 Holocene
49.5 33.3 Pleistocene
EOF

gmt end show

rm -f temp*.out