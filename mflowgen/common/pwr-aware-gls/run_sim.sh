#!/bin/sh


# Default arguments
ARGS="-sv -timescale 1ns/1ns -access +rwc -notimingchecks"
ARGS="$ARGS -input cmd.tcl -ALLOWREDEFINITION"

# ADK for GLS
if [ -d "inputs/adk" ]; then
  ARGS="$ARGS inputs/adk/*pwr*.v"
fi

# Set-up testbench
ARGS="$ARGS -top tb_Tile_PECore"

# Grab all design/testbench files
for f in inputs/*.v; do
  [ -e "$f" ] || continue
  ARGS="$ARGS $f"
done

for f in inputs/*.sv; do
  [ -e "$f" ] || continue
  ARGS="$ARGS $f"
done

for f in *.v; do
  [ -e "$f" ] || continue
  ARGS="$ARGS $f"
done

# Run NC-SIM and print out the command
(
  set -x;
  irun $ARGS
)
