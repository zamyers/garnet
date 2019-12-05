#!/bin/bash
# Uses buildkite scripts to run synthesis and layout locally
# PE+MEM version

# VERBOSE currently unused I think
VERBOSE=false
if   [ "$1" == "-v" ] ; then VERBOSE=true;  shift;
elif [ "$1" == "-q" ] ; then VERBOSE=false; shift;
fi

# Check to see if we're in the right place e.g. "tapeout_16" directory
# expr `pwd` : '.*/garnet/tapeout_16$' && rightplace=true || rightplace=false
expr `pwd` : '.*/tapeout_16$' > /dev/null && rightplace=true || rightplace=false
if [ $rightplace != true ] ; then
  echo ""
  echo "ERROR looks like you're in the wrong place"
  echo "- you are here:   `pwd`"
  echo "- should be here: .../tapeout_16"
  exit 13
fi

# # Use ./cache as the cache directory
# export CACHEDIR=`pwd`/cache

# And/or let's try /tmp/cache-steveri e.g.
export CACHEDIR=/tmp/cache-$USER

[ -e "$CACHEDIR" ] && /bin/rm -rf "$CACHEDIR"
mkdir -p $CACHEDIR

# Start at top level dir, just like buildkite would do
cd ..

.buildkite/GEN.sh -v

.buildkite/SYN.sh -q PE
.buildkite/SYN.sh -q MemCore

.buildkite/PNR.sh -q PE
.buildkite/PNR.sh -q MemCore

# Cleaning gup
/bin/rm -rf ./cache