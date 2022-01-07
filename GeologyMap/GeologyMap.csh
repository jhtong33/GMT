#!/bin/csh
set grd=Armenia.grd
set int=Armenia.int


gmt begin GeologyMap pdf A+m1c
gmt set FORMAT_GEO_MAP ddd.x
gmt set FONT_LABEL 12p,4,black
gmt set FONT_TITLE 18p,26,black


gmt makecpt -Celevation -T0/4000/500 -D -Z
gmt basemap -JM7.5i  -R30/60/27/47 -Ba2f1 -BWNse -X+2 -Y+3 -U/0.5/17/"Tong"
gmt grdcut @earth_relief_30s -G$grd -R30/60/27/47
gmt grdimage $grd -I+d  -t40
gmt grdgradient $grd -A0/90 -G$int -Ne0.2
gmt coast -W1p -Dh -A150  -EAM,TR,IR,GE,RU,IQ,AZ,KZ,UZ,SY,JO+p0.5p,black,-- -S145/200/255 -t30 #-Lg44/46+c42+w1000+u

gmt plot PB2002_boundaries.dig.txt -W3p,darkbrown


gmt text -F+f18p,3,black+jLM <<EOF
38 35 Arabian Plate
47 35 Eurasian Plate
31 39 Anatolian Plate
32 33 Africa
32 32 Plate
EOF

echo 41 45 Caucasus Region | gmt text -F+f15p,5,black+jLM -Gred@30

gmt plot -W2p,red <<EOF
39 44.5
49.5 44.5
49.5 39
39 39 
39 44.5
EOF

###GPS
###Relative Velocity


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

gmt colorbar -C -Dx2.5c/-0.8c+w5c/0.5c+jTC+h -Bxaf+l"Topography" -By+lkm -N



gmt end show