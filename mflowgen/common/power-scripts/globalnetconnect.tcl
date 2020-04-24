#=========================================================================
# globalnetconnect.tcl
#=========================================================================
# Author : 
# Date   : 

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------

# Connect VNW / VPW if any cells have these pins

if $::env(PWR_AWARE) {
   globalNetConnect VDD_SW -type tiehi -powerdomain TOP
   globalNetConnect VDD    -type tiehi -powerdomain AON
   globalNetConnect VSS    -type tielo
   globalNetConnect VDD    -type pgpin -pin VPP -inst *
   globalNetConnect VSS    -type pgpin -pin VBB -inst *
   globalNetConnect VDD    -type pgpin -pin TVDD -inst *HDR*

} else {
   globalNetConnect VDD -type pgpin -pin VDD -inst *
   globalNetConnect VDD -type tiehi
   globalNetConnect VSS -type pgpin -pin VSS -inst *
   globalNetConnect VSS -type tielo
   globalNetConnect VDD -type pgpin -pin VPP -inst *
   globalNetConnect VSS -type pgpin -pin VBB -inst *
}

