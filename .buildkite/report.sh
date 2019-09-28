FILES=tapeout_16/synth/Tile_MemCore/*.power
for f in $FILES
do
    echo "--- $f"
    cat $f
done
