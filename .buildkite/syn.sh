#!/bin/bash

VERBOSE=false
if [ "$1" == "-v" ]; then VERBOSE=true;  shift; fi
if [ "$1" == "-q" ]; then VERBOSE=false; shift; fi

TILE=$1
TOP=$2
APP=$3

mkdir tapeout_16/power_reports
ls

cd tapeout_16

echo "--- ${TILE} SYNTHESIS"

set +x; source test/module_loads.sh
set -x

PWR_AWARE=1
nobuf='stdbuf -oL -eL'
if [ "$VERBOSE" == true ];
  then filter=($nobuf cat)                         # VERBOSE
  else filter=($nobuf ./test/run_synthesis.filter) # QUIET
fi
# pwd; ls -l genesis_verif

$nobuf ./run_synthesis.csh ${TILE} ${PWR_AWARE} ${APP} ${TOP} \
  | ${filter[*]} \
  || exit 13
pwd

#ls synth/Tile_${TILE}
#ls synth/Tile_${TILE}/results_syn

#echo "--- final_area.rpt"
#cat synth/Tile_${TILE}/results_syn/final_area.rpt

#echo "--- syn.area"
#cat synth/Tile_${TILE}/syn.area

#echo "--- syn.area1"
#cat synth/Tile_${TILE}/syn.area1

#echo "--- syn.area2"
#cat synth/Tile_${TILE}/syn.area2

#echo "--- syn.power1"
#cat synth/Tile_${TILE}/syn.power1

cd ../
