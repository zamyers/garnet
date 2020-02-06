#=========================================================================
# pin-assignments.tcl
#=========================================================================
# Author : 
# Date   : 

#-------------------------------------------------------------------------
# Pin Assignments
#-------------------------------------------------------------------------


editPin -layer M5 -pin [dbGet top.terms.name *_in*] -side TOP -spreadType SIDE
editPin -layer M5 -pin [dbGet top.terms.name *_out*] -side BOTTOM -spreadType SIDE
