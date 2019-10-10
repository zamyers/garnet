#!/bin/bash
if [ -d "genesis_verif/" ]; then
  rm -rf genesis_verif
fi
cd ../
if [ -d "genesis_verif/" ]; then
  rm -rf genesis_verif
fi

# This filter keeps Genesis output
#   "--- Genesis Is Starting Work On Your Design ---"
# from being an expandable category in kite log =>
#   "=== Genesis Is Starting Work On Your Design ==="
dash_filter='s/^--- /=== /;s/ ---$/ ===/'

nobuf='stdbuf -oL -eL'
function filter {
  set +x # echo OFF
  VERBOSE=true
  if [ $VERBOSE == true ] ;
    then $nobuf cat $1
    else $nobuf egrep 'from\ module|^Running' $1 \
       | $nobuf sed '/^Running/s/ .input.*//'
  fi
}

$nobuf python3 garnet.py --width 32 --height 16 -v --no_sram_stub \
  |& $nobuf sed "$dash_filter" \
  |& $nobuf tee do_gen.log \
  |& filter || exit
set +x # echo OFF

# |& $nobuf cat || exit 13

echo ""
echo Checking for errors
grep -i error do_gen.log
echo ""

cp tapeout_16/clockgated_genesis_verif/garnet.sv genesis_verif/garnet.sv

cp -r genesis_verif/ tapeout_16/

cd tapeout_16/
