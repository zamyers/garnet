#!/bin/bash

VERBOSE=false
if [ "$1" == "-v" ]; then VERBOSE=true;  shift; fi
if [ "$1" == "-q" ]; then VERBOSE=false; shift; fi

TILE=$1

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

$nobuf ./run_synthesis.csh Tile_${TILE} ${PWR_AWARE} \
  | ${filter[*]} \
  || exit 13
pwd

ls synth/Tile_${TILE}
ls synth/Tile_${TILE}/results_syn

echo "--- final_area.rpt"
cat synth/Tile_${TILE}/results_syn/final_area.rpt

echo "--- syn.area"
cat synth/Tile_${TILE}/syn.area

echo "--- syn.area1"
cat synth/Tile_${TILE}/syn.area1

echo "--- syn.area2"
cat synth/Tile_${TILE}/syn.area2

cd ../
