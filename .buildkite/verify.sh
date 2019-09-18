#!/bin/bash

# Exit on error in any stage of any pipeline
set -eo pipefail

VERBOSE=false
if   [ "$1" == "-v" ] ; then VERBOSE=true;  shift;
elif [ "$1" == "-q" ] ; then VERBOSE=false; shift;
fi

# little hack
LITTLE=''
if [ "$1" == "--LITTLE" ] ; then LITTLE="$1"; shift; fi


##############################################################################
echo "--- SETUP AND VERIFY ENVIRONMENT"
# (Probably could/should skip this step for buildkite)
#   - set -x; cd tapeout_16; set +x; source test/module_loads.sh; set -x

set +x
  if [ "$VERBOSE" == true ];
    then bin/requirements_check.sh -v
    else bin/requirements_check.sh -q
  fi

echo ""
