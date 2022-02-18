#!/bin/csh
set grd=Armenia.grd
set int=Armenia.int
set event=2010-2020LargeRangeEvents.txt
set GPS=/Volumes/home/Research/DataBase/Iran_GPS_velocity.csv
set RGPS=/Volumes/home/Research/DataBase/03_Reilinger_R_etal_GPS_relativeEurasia/jgrb14718-sup-0002-ts01.txt
set AGPS=/Volumes/home/Research/DataBase/01_Armenia/03_Armenia_GPS_velocity.csv
set region=40/47.5/38.5/43.5
set Volcano=/Volumes/home/Research/DataBase/01_Armenia/02_Volcano_list.csv
set SmoothF=/Volumes/home/Research/DataBase/01_Armenia/00_smooth_fault_7.txt

gmt begin GeologyMap_v2 pdf A+m1c
gmt set FORMAT_GEO_MAP ddd.x
gmt set FONT_LABEL 12p,4,black
gmt set FONT_TITLE 18p,26,black


gmt makecpt -Celevation -T0/4000/500 -D -Z
gmt basemap -JM7.5i  -R$region -Ba1f0.5 -BWNse -X+2 -Y+3 -U/0.5/18/"Tong"
gmt grdcut @earth_relief_30s -G$grd -R$region
gmt grdimage $grd -I+d  -t40
gmt grdgradient $grd -A0/90 -G$int -Ne0.2
gmt coast -W1p -Dh -A150  -EAM,TR,IR,GE,RU,IQ,AZ,KZ,UZ,SY,JO+p0.5p,black,-- -S145/200/255 -t30 #-Lg44/46+c42+w1000+u

gmt plot $SmoothF -W1p,brown

###Event 
awk '{if ($6<5) {print $1,$2}}' $event | gmt plot -Sc0.1c -G160 -W0.05p,120
awk '{if (5<=$6 && $6<6) {print $1,$2}}' $event | gmt plot -Sc0.2c -G100 -W0.05p,120
awk '{if (6<=$6) {print $1,$2}}' $event | gmt plot -Sa0.5c -Ggold1 -W0.05p,120


###GPS
#Relative Velocity
set Rcolor=black
set scale=0.1c
awk -F, 'NR>1 && $9 ~ /Raeesi/ {print $2,$3,$4,$5,$6,$7,$8}' $GPS > temp.out
gmt psvelo temp.out -Se$scale/0.95/4 -G$Rcolor -W1.5p,$Rcolor -A0.2c+p1.2p+e -t20
awk -F, 'NR>1 && $9 ~ /IPGN/ {print $2,$3,$4,$5,$6,$7,$8}' $GPS > temp2.out
gmt psvelo temp2.out -Se$scale/0.95/4  -Gdarkred  -W1.5p,darkred -A0.2c+p1.2p+e  -t20
awk 'NR>1 {print $2,$3,$4,$5,$6,$7,$8}' $RGPS > temp3.out
gmt psvelo temp3.out -Se$scale/0.95/4  -Gblue -W1.5p,blue -A0.2c+p1.2p+e  -t20
awk -F, 'NR>1 {print $1,$2,$3,$4,$5,$6,$7}' $AGPS >temp4.out
gmt psvelo temp4.out -Se$scale/0.95/4  -Gdodgerblue1 -W1p,dodgerblue1 -A0.2c+p1.2p+e  -t20


##Volcano
cat $Volcano | awk -F, 'NR>1 {if ($7 == "1") print $3,$2}' | gmt plot -Skvolcano/0.45 -Gdarkred -W0.5p,black
cat $Volcano | awk -F, 'NR>1 {if ($7 == "2") print $3,$2}' | gmt plot -Skvolcano/0.45 -Gblack -W0.5p,black
cat $Volcano | awk -F, 'NR>1 {if ($7 == "3") print $3,$2}' | gmt plot -Skvolcano/0.45 -Ggrey -W0.5p,black

##Geology
gmt text -F+a -F+f20p,7,black=~1.5,white+jLM <<EOF
42.5 43.1 -21 Greater Caucasus 
44 41.35 -22 Lesser Caucasus
40.5 40.5 0 NE Anatolian Plateau
EOF
##Sea
gmt text -F+f14p,9,50+jLM <<EOF
40.3 42 Black Sea
EOF
##Conutry name
gmt text -F+a -F+f15p,32,200=~1,50+jLM <<EOF
42.9 40.6 0 Turkey
44.6 40.85 0 Aremina
45.5 41.6 -23 Georgia
46 42.3 -33 Russia
45.5 41.2 -20 Azerbaijan
45.9 38.7 0 Iran
EOF


##Legend
gmt colorbar -C -Dx2.5c/-1c+w5c/0.3c+jTC+h+ml -Bxaf+l"Topography" -By+lm -N

##GPS
echo 42.5 38.35 GPS Velocity relative to EU|gmt text  -F+f10p,5,50+jLM -N
echo 42.5 37.6 10mm/yr | gmt text -F+f8p,5,50+jLM -N
gmt text -F+f8.5p,5,50+jLM -N <<EOF
42.9 38.2 IPGN
42.9 38.05 Raeesi et al., (2017)
42.9 37.9 Relinger et al., (2006)
42.9 37.75 Karakhanyan, A et al., (2013)
EOF
gmt psvelo -Se$scale/0.95/4  -G$Rcolor -W0.5p,$Rcolor -A0.3c+p1.2p+e  -N<<EOF
42.5 38.2 10 0 0 0 0
EOF
gmt psvelo -Se$scale/0.95/4  -Gdarkred -W0.5p,darkred -A0.3c+p1.2p+e  -N<<EOF
42.5 38.05 10 0 0 0 0
EOF
gmt psvelo -Se$scale/0.95/4  -Gblue -W0.5p,blue -A0.3c+p1.2p+e  -N<<EOF
42.5 37.9 10 0 0 0 0
EOF
gmt psvelo -Se$scale/0.95/4  -Gdodgerblue1 -W0.5p,dodgerblue1 -A0.3c+p1.2p+e -N <<EOF
42.5 37.75 10 0 0 0 0
EOF

##Earthquake
echo 44.75 38.35 Earthquakes | gmt text  -F+f10p,5,50+jLM -N
echo 44.75 38.2 | gmt plot -Sc0.1c -G160 -W0.05p,120 -N
echo 44.75 38.0 | gmt plot -Sc0.2c -G100 -W0.05p,120 -N
echo 44.75 37.8 | gmt plot -Sa0.5c -Ggold1 -W0.05p,120 -N
gmt text -F+f8.5p,5,50+jLM -N <<EOF
44.85 38.2 4.0 @~\243@~ Mag< 5.0
44.85 38.0 5.0 @~\243@~ Mag< 6.0
44.85 37.8 6.0 @~\243@~ Mag
EOF

##Volcano
echo 45.9 38.35 Volcanos | gmt text  -F+f10p,5,50+jLM -N
echo 46 38.2 |gmt plot -Skvolcano/0.45 -Gdarkred -W0.5p,black -N
echo 46 38.0 |gmt plot -Skvolcano/0.45 -Gblack -W0.5p,black -N
echo 46 37.8 |gmt plot -Skvolcano/0.45 -Ggrey -W0.5p,black -N

gmt text -F+f8.5p,5,50+jLM -N <<EOF
46.2 38.2 Last eruption< 10000yrs
46.2 38.0 Holocene
46.2 37.8 Pleistocene
EOF

gmt end show

rm -f temp*.out