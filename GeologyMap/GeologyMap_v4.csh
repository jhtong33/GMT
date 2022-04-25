#!/bin/csh
set grd=Armenia.grd
set int=Armenia.int
set event=2010-2020LargeRangeEvents.txt
set GPS=/Volumes/home/Research/DataBase/Iran_GPS_velocity.csv
set RGPS=/Volumes/home/Research/DataBase/03_Reilinger_R_etal_GPS_relativeEurasia/jgrb14718-sup-0002-ts01.txt
set AGPS=/Volumes/home/Research/DataBase/01_Armenia/03_Armenia_GPS_velocity.csv

set region=39/50/36/45
set Volcano=/Volumes/home/Research/DataBase/01_Armenia/02_Volcano_list.csv
set SmoothF=/Volumes/home/Research/DataBase/01_Armenia/00_smooth_fault_7.txt

gmt begin GeologyMap_v4 pdf A+m1c
gmt set FORMAT_GEO_MAP ddd.x
gmt set FONT_LABEL 12p,4,black
gmt set FONT_TITLE 18p,26,black


gmt makecpt -Celevation -T0/4000/500 -D -Z
gmt basemap -JM7.5i  -R$region -Ba1f0.5 -BWNse -X+2 -Y+3 -U/0.5/22/"Tong"
gmt grdcut @earth_relief_30s -G$grd -R$region
gmt grdimage $grd -I+d  -t40
gmt grdgradient $grd -A0/90 -G$int -Ne0.2
gmt coast -W1p -Dh -A150  -EAM,TR,IR,GE,RU,IQ,AZ,KZ,UZ,SY,JO+p0.5p,black,-- -S145/200/255  -Lg40/44.7+jLC+c42+w100+f+u

gmt plot PB2002_boundaries.dig.txt -W3p,darkbrown
###Event 
awk '{if ($6<5) {print $1,$2}}' $event | gmt plot -Sc0.1c -G160 -W0.05p,120
awk '{if (5<=$6 && $6<6) {print $1,$2}}' $event | gmt plot -Sc0.15c -G110 -W0.05p,120
awk '{if (6<=$6) {print $1,$2}}' $event | gmt plot -Sa0.5c -Ggold1 -W0.05p,120


###GPS
#Relative Velocity
set color=white
set scale=0.1c
awk -F, 'NR>1 {print $2,$3,$4,$5,$6,$7,$8}' $GPS > temp.out
gmt psvelo temp.out -Se$scale/0.95/4 -G$color -W1p,150 -A0.5c+p1.2p+e -t40
awk 'NR>1 {print $2,$3,$4,$5,$6,$7,$8}' $RGPS > temp3.out
gmt psvelo temp3.out -Se$scale/0.95/4  -G$color -W1p,150  -A0.5c+p1.2p+e  -t40
awk -F, 'NR>1 {print $1,$2,$3,$4,$5,$6,$7}' $AGPS >temp4.out
gmt psvelo temp4.out -Se$scale/0.95/4  -G$color -W1p,150  -A0.5c+p1.2p+e  -t40
#Arabian plate
##GSRM v2.1, speed 17.98 mm/yr N17.73 E-2.97
echo 41 37.7 350.50 2c | gmt plot -SV1c+ea -W10p,50 -G50 
echo 40.93 37.98 -80 17.98mm/yr | gmt text -F+a -F+f7.5p,1,white

gmt text -F+f18p,3,black+jLM <<EOF
38 35 Arabian Plate
47 35 Eurasian Plate
EOF
#Anatolian block
##Volcano
cat $Volcano | awk -F, 'NR>1 {if ($7 == "1") print $3,$2}' | gmt plot -Skvolcano/0.3 -Gdarkred -W0.5p,black
cat $Volcano | awk -F, 'NR>1 {if ($7 == "2") print $3,$2}' | gmt plot -Skvolcano/0.3 -Gblack -W0.5p,black
cat $Volcano | awk -F, 'NR>1 {if ($7 == "3") print $3,$2}' | gmt plot -Skvolcano/0.3 -Ggrey -W0.5p,black

##Geology
gmt text -F+a -F+f18p,7,black=~1.5,white+jLM <<EOF
42.5 43.3 -18 Greater Caucasus 
43.6 41.35 -22 Lesser Caucasus
39.5 40.5 0 NE Anatolian Plateau
46 38 0 NW Iran Plateau
48 33.5 -37 Zargos
55.5 37.8 0 Kopeh dagu
56 36.8 0 Binalud
EOF
##Sea
gmt text -F+f15p,9,50+jLM <<EOF
39.5 42 Black Sea
47.8 43 Capsian Sea
EOF
##Conutry name
gmt text -F+a -F+f15p,32,230=~1.5,30+jLM <<EOF
41.5 41 0 Turkey
43.6 40.85 0 Aremina
45.5 41.6 -23 Georgia
46 42.6 -27 Russia
45.5 41.2 -20 Azerbaijan
45.9 38.7 0 Iran
EOF

###Plate name
gmt text -F+f18p,3,darkbrown+jLM -W1.5p,darkbrown <<EOF
40 36.5 Arabian Plate
43 44 Eurasian Plate
EOF
##Legend
gmt colorbar -C -Dx2.5c/-1c+w5c/0.3c+jTC+h+ml -Bxaf+l"Topography" -By+lm -N

##GPS
echo 42.5 35.7 GPS Velocity |gmt text  -F+f10.5p,5,50+jLM -N
echo 42.5 35.45 relative to EU |gmt text  -F+f10p,5,50+jLM -N
gmt text -F+f8.5p,5,50+jLM -N <<EOF
43.2 35.2 10mm/yr
EOF
gmt psvelo -Se$scale/0.95/4  -G$color -W1p,100  -A0.5c+p1.2p+e -N<<EOF
42.5 35.2 10 0 0 0 0
EOF

##Earthquake
echo 44.6 35.7 Earthquakes | gmt text  -F+f10p,5,50+jLM -N
echo 44.6 35.5 | gmt plot -Sc0.1c -G160 -W0.05p,120 -N
echo 44.6 35.2 | gmt plot -Sc0.15c -G110 -W0.05p,120 -N
echo 44.6 34.9 | gmt plot -Sa0.5c -Ggold1 -W0.05p,120 -N
gmt text -F+f8.5p,5,50+jLM -N <<EOF
44.7 35.5 4.0 @~\243@~ ML< 5.0
44.7 35.2 5.0 @~\243@~ ML< 6.0
44.75 34.9 6.0 @~\243@~ ML
EOF

##Volcano
echo 46.2 35.7 Volcanos | gmt text  -F+f10p,5,50+jLM -N
echo 46.3 35.5 |gmt plot -Skvolcano/0.45 -Gdarkred -W0.5p,black -N
echo 46.3 35.2 |gmt plot -Skvolcano/0.45 -Gblack -W0.5p,black -N
echo 46.3 34.9 |gmt plot -Skvolcano/0.45 -Ggrey -W0.5p,black -N

gmt text -F+f8.5p,5,50+jLM -N <<EOF
46.5 35.5 Last eruption< 10000yrs
46.5 35.2 Holocene
46.5 34.9 Pleistocene
EOF

gmt end show

rm -f temp*.out