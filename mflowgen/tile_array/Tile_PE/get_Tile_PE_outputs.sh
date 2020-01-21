#!/bin/bash
../../configure --design $GARNET_HOME/mflowgen/Tile_PE/
make synopsys-ptpx-genlibdb
mkdir -p outputs
cp -L *synopsys-ptpx-genlibdb/outputs/design.lib outputs/Tile_PE_tt.lib
cp -L *synopsys-ptpx-genlibdb/outputs/design.db outputs/Tile_PE.db
cp -L *cadence-innovus-signoff/outputs/design.lef outputs/Tile_PE.lef
cp -L *cadence-innovus-signoff/outputs/design.gds.gz outputs/Tile_PE.gds.gz

