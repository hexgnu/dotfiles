#!/bin/bash
#
CURRENT_DPI=192

xrdb -merge <<< "Xft.dpi: 96"

zoom &

sleep 10

xrdb -merge <<< "Xft.dpi: 192"

wait $!
