#=========================================================================
# globalnetconnect.tcl
#=========================================================================
# Author : 
# Date   : 

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------

# Connect VNW / VPW if any cells have these pins

# TODO: Make this not error out if PWR_AWARE doesn't exist
if $::env(PWR_AWARE) {
   # TODO: Make sure file named correctly
   read_power_intent -1801 upf.tcl
   commit_power_intent
   write_power_intent -1801 upf.out

   globalNetConnect VDD_SW -type tiehi -powerdomain TOP
   globalNetConnect VDD    -type tiehi -powerdomain AON
   globalNetConnect VSS -type tielo
   globalNetConnect VDD -type pgpin -pin VPP -inst *
   globalNetConnect VSS -type pgpin -pin VBB -inst *
} else {
   globalNetConnect VDD -type pgpin -pin VDD -inst *
   globalNetConnect VDD -type tiehi
   globalNetConnect VSS -type pgpin -pin VSS -inst *
   globalNetConnect VSS -type tielo
   globalNetConnect VDD -type pgpin -pin VPP -inst *
   globalNetConnect VSS -type pgpin -pin VBB -inst *
}

