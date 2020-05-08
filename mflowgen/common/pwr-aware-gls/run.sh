#!/bin/sh

# Add DW IP blocks as includes
cp include inputs/include.v

# remove design.vcs.v
rm inputs/design.vcs.v

# Default arguments
ARGS="-timescale 1ns/1ns -access +rwc -notimingchecks"
ARGS="$ARGS -input cmd.tcl -ALLOWREDEFINITION"

# ADK for GLS
if [ -d "inputs/adk" ]; then
  ARGS="$ARGS inputs/adk/tcbn*.v"
fi

# Set-up testbench
ARGS="$ARGS -top $testbench_name"

# Grab all design/testbench files
for f in inputs/*.v; do
  [ -e "$f" ] || continue
  ARGS="$ARGS $f"
done

for f in inputs/*.sv; do
  [ -e "$f" ] || continue
  ARGS="$ARGS $f"
done


# Run NC-SIM and print out the command
(
  set -x;
  irun $ARGS
)
