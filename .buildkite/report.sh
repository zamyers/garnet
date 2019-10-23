#echo "--- AREA SUMMARY"
#python ./.buildkite/parse.py --input=tapeout_16/synth/$1/syn.area
#echo "--- area dump"
#cat tapeout_16/synth/$1/syn.area

FILES=tapeout_16/synth/$1/*.power
for f in $FILES
do
    echo "--- $f SUMMARY"
    python ./.buildkite/parse.py --input=$f
#    echo "--- $f dump"
#    cat $f
done
