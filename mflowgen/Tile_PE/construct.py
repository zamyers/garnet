#! /usr/bin/env python
#=========================================================================
# construct.py
#=========================================================================
# Author : 
# Date   : 
#

import os
import sys

from mflowgen.components import Graph, Step

def construct():

  g = Graph()

  #-----------------------------------------------------------------------
  # Parameters
  #-----------------------------------------------------------------------

  pwr_aware = True 

  if os.environ.get('TECH_LIB') == '16':
    adk_name = 'tsmc16'
    adk_view = 'stdview'
  else:
    adk_name = 'freepdk-45nm'
    adk_view = 'view-standard'

  parameters = {
    'construct_path'    : __file__,
    'design_name'       : 'Tile_PE',
    'clock_period'      : 1.15,
    'adk'               : adk_name,
    'adk_view'          : adk_view,
    # Synthesis
    'flatten_effort'    : 3,
    'topographical'     : True,
    # RTL Generation
    'interconnect_only' : True,
    # Power Domains
    'PWR_AWARE'         : pwr_aware,

    'saif_instance'     : 'TilePETb/Tile_PE_inst',

    'testbench_name'    : 'TilePETb',
    'strip_path'        : 'TilePETb/Tile_PE_inst'
  }

  #-----------------------------------------------------------------------
  # Create nodes
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # ADK step

  g.set_adk( adk_name )
  adk = g.get_adk_step()

  # RTL power estimation
  rtl_power = False;

  # Custom steps

  rtl                  = Step( this_dir + '/rtl'                                   )
  constraints          = Step( this_dir + '/constraints'                           )
  custom_init          = Step( this_dir + '/custom-init'                           )
  custom_power         = Step( this_dir + '/../common/custom-power-leaf'           )
  genlibdb_constraints = Step( this_dir + '/../common/custom-genlibdb-constraints' )
  testbench            = Step( this_dir + '/testbench'                             )
  vcs_sim              = Step( this_dir + '/../common/synopsys-vcs-sim'            )
  if rtl_power:
    rtl_sim              = vcs_sim.clone()
    rtl_sim.set_name( 'rtl-sim' )
    pt_power_rtl         = Step( this_dir + '/../common/synopsys-ptpx-rtl'         )
  gl_sim               = vcs_sim.clone()
  gl_sim.set_name( 'gl-sim' )
  pt_power_gl          = Step( this_dir + '/../common/synopsys-ptpx-gl'            )
  parse_power_gl       = Step( this_dir + '/parse-power-gl'                        )

  # Power aware setup
  if pwr_aware: 
      power_domains = Step( this_dir + '/../common/power-domains' )
      #pwr_aware_gls = Step( this_dir + '/../common/pwr-aware-gls' )
  # Default steps

  info         = Step( 'info',                          default=True )
  #constraints  = Step( 'constraints',                   default=True )
  dc           = Step( 'synopsys-dc-synthesis',         default=True )
  iflow        = Step( 'cadence-innovus-flowsetup',     default=True )
  init         = Step( 'cadence-innovus-init',          default=True )
  power        = Step( 'cadence-innovus-power',         default=True )
  place        = Step( 'cadence-innovus-place',         default=True )
  cts          = Step( 'cadence-innovus-cts',           default=True )
  postcts_hold = Step( 'cadence-innovus-postcts_hold',  default=True )
  route        = Step( 'cadence-innovus-route',         default=True )
  postroute    = Step( 'cadence-innovus-postroute',     default=True )
  signoff      = Step( 'cadence-innovus-signoff',       default=True )
  pt_signoff   = Step( 'synopsys-pt-timing-signoff',    default=True )
  genlibdb     = Step( 'synopsys-ptpx-genlibdb',        default=True )
  gdsmerge     = Step( 'mentor-calibre-gdsmerge',       default=True )
  drc          = Step( 'mentor-calibre-drc',            default=True )
  lvs          = Step( 'mentor-calibre-lvs',            default=True )
  debugcalibre = Step( 'cadence-innovus-debug-calibre', default=True )

  # Add extra input edges to innovus steps that need custom tweaks

  init.extend_inputs( custom_init.all_outputs() )
  power.extend_inputs( custom_power.all_outputs() )
  genlibdb.extend_inputs( genlibdb_constraints.all_outputs() )

  # Extra input to DC for constraints
  dc.extend_inputs( ["common.tcl", "reporting.tcl"] )

  # Power aware setup
  if pwr_aware: 
      dc.extend_inputs(['designer-interface.tcl', 'upf_Tile_PE.tcl', 'pe-constraints.tcl', 'pe-constraints-2.tcl', 'dc-dont-use-constraints.tcl'])
      init.extend_inputs(['upf_Tile_PE.tcl', 'pe-load-upf.tcl', 'dont-touch-constraints.tcl', 'pd-pe-floorplan.tcl', 'pe-add-endcaps-welltaps-setup.tcl', 'pd-add-endcaps-welltaps.tcl', 'pe-power-switches-setup.tcl', 'add-power-switches.tcl'])
      place.extend_inputs(['place-dont-use-constraints.tcl'])
      power.extend_inputs(['pd-globalnetconnect.tcl'] )
      cts.extend_inputs(['conn-aon-cells-vdd.tcl'])
      postcts_hold.extend_inputs(['conn-aon-cells-vdd.tcl'] )
      route.extend_inputs(['conn-aon-cells-vdd.tcl'] ) 
      postroute.extend_inputs(['conn-aon-cells-vdd.tcl'] )
      signoff.extend_inputs(['conn-aon-cells-vdd.tcl', 'pd-generate-lvs-netlist.tcl'] ) 
      #pwr_aware_gls.extend_inputs(['design.vcs.pg.v']) 
  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info                     )
  g.add_step( rtl                      )
  g.add_step( testbench                )
  g.add_step( constraints              )
  g.add_step( dc                       )
  g.add_step( iflow                    )
  g.add_step( init                     )
  g.add_step( custom_init              )
  g.add_step( power                    )
  g.add_step( custom_power             )
  g.add_step( place                    )
  g.add_step( cts                      )
  g.add_step( postcts_hold             )
  g.add_step( route                    )
  g.add_step( postroute                )
  g.add_step( signoff                  )
  g.add_step( pt_signoff               )
  g.add_step( genlibdb_constraints     )
  g.add_step( genlibdb                 )
  g.add_step( gdsmerge                 )
  g.add_step( drc                      )
  g.add_step( lvs                      )
  g.add_step( debugcalibre             )

  if rtl_power:
    g.add_step( rtl_sim                )
    g.add_step( pt_power_rtl           )
  g.add_step( gl_sim                   )
  g.add_step( pt_power_gl              )
  g.add_step( parse_power_gl           )

  # Power aware step
  if pwr_aware:
      g.add_step( power_domains            )
      #g.add_step( pwr_aware_gls            )
  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  # Dynamically add edges

  # Connect by name

  g.connect_by_name( adk,      dc           )
  g.connect_by_name( adk,      iflow        )
  g.connect_by_name( adk,      init         )
  g.connect_by_name( adk,      power        )
  g.connect_by_name( adk,      place        )
  g.connect_by_name( adk,      cts          )
  g.connect_by_name( adk,      postcts_hold )
  g.connect_by_name( adk,      route        )
  g.connect_by_name( adk,      postroute    )
  g.connect_by_name( adk,      signoff      )
  g.connect_by_name( adk,      gdsmerge     )
  g.connect_by_name( adk,      drc          )
  g.connect_by_name( adk,      lvs          )
  g.connect_by_name( adk,      pt_power_gl  )

  if rtl_power:
    rtl_sim.extend_inputs(['design.v'])
    g.connect_by_name( adk,      rtl_sim      )
    g.connect_by_name( adk,      pt_power_rtl )
    # To generate namemap
    g.connect_by_name( rtl_sim,     dc       ) # run.saif
    g.connect_by_name( rtl,          rtl_sim      ) # design.v
    g.connect_by_name( testbench,    rtl_sim      ) # testbench.sv
    g.connect_by_name( dc,       pt_power_rtl ) # design.namemap
    g.connect_by_name( signoff,      pt_power_rtl ) # design.vcs.v, design.spef.gz, design.pt.sdc
    g.connect_by_name( rtl_sim,      pt_power_rtl ) # run.saif

  g.connect_by_name( rtl,         dc        )
  g.connect_by_name( constraints, dc        )

  g.connect_by_name( dc,       iflow        )
  g.connect_by_name( dc,       init         )
  g.connect_by_name( dc,       power        )
  g.connect_by_name( dc,       place        )
  g.connect_by_name( dc,       cts          )

  g.connect_by_name( iflow,    init         )
  g.connect_by_name( iflow,    power        )
  g.connect_by_name( iflow,    place        )
  g.connect_by_name( iflow,    cts          )
  g.connect_by_name( iflow,    postcts_hold )
  g.connect_by_name( iflow,    route        )
  g.connect_by_name( iflow,    postroute    )
  g.connect_by_name( iflow,    signoff      )

  g.connect_by_name( custom_init,  init     )
  g.connect_by_name( custom_power, power    )

  g.connect_by_name( init,         power        )
  g.connect_by_name( power,        place        )
  g.connect_by_name( place,        cts          )
  g.connect_by_name( cts,          postcts_hold )
  g.connect_by_name( postcts_hold, route        )
  g.connect_by_name( route,        postroute    )
  g.connect_by_name( postroute,    signoff      )
  g.connect_by_name( signoff,      gdsmerge     )
  g.connect_by_name( signoff,      drc          )
  g.connect_by_name( signoff,      lvs          )
  g.connect_by_name( gdsmerge,     drc          )
  g.connect_by_name( gdsmerge,     lvs          )

  g.connect_by_name( signoff,              genlibdb )
  g.connect_by_name( adk,                  genlibdb )
  g.connect_by_name( genlibdb_constraints, genlibdb )

  g.connect_by_name( adk,          pt_signoff   )
  g.connect_by_name( signoff,      pt_signoff   )

  g.connect_by_name( signoff,      pt_power_gl  )
  g.connect_by_name( gl_sim,       pt_power_gl  ) # run.saif

  g.connect_by_name( adk,          gl_sim       )
  g.connect_by_name( signoff,      gl_sim       ) # design.vcs.v, design.spef.gz, design.pt.sdc
  g.connect_by_name( pt_signoff,   gl_sim       ) # design.sdf
  g.connect_by_name( testbench,    gl_sim       ) # testbench.sv
  g.connect_by_name( pt_power_gl,  parse_power_gl ) # power.hier

  g.connect_by_name( adk,      debugcalibre )
  g.connect_by_name( dc,       debugcalibre )
  g.connect_by_name( iflow,    debugcalibre )
  g.connect_by_name( signoff,  debugcalibre )
  g.connect_by_name( drc,      debugcalibre )
  g.connect_by_name( lvs,      debugcalibre )

  # Pwr aware steps:
  if pwr_aware: 
      g.connect_by_name( power_domains,        dc           )
      g.connect_by_name( power_domains,        init         ) 
      g.connect_by_name( power_domains,        power        )
      g.connect_by_name( power_domains,        place        )
      g.connect_by_name( power_domains,        cts          )
      g.connect_by_name( power_domains,        postcts_hold )
      g.connect_by_name( power_domains,        route        )
      g.connect_by_name( power_domains,        postroute    )
      g.connect_by_name( power_domains,        signoff      )
      #g.connect_by_name( adk,                  pwr_aware_gls)
      #g.connect_by_name( signoff,              pwr_aware_gls)
      #g.connect(power_domains.o('pd-globalnetconnect.tcl'), power.i('globalnetconnect.tcl'))
  
  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  # Update PWR_AWARE variable
  dc.update_params( { 'PWR_AWARE': parameters['PWR_AWARE'] }, True )
  init.update_params( { 'PWR_AWARE': parameters['PWR_AWARE'] }, True )
  power.update_params( { 'PWR_AWARE': parameters['PWR_AWARE'] }, True )
 
  if pwr_aware:
      init.update_params( { 'flatten_effort': parameters['flatten_effort'] }, True )
   
  # Since we are adding an additional input script to the generic Innovus
  # steps, we modify the order parameter for that node which determines
  # which scripts get run and when they get run.

  # init -- Add 'edge-blockages.tcl' after 'pin-assignments.tcl'

  order = init.get_param('order') # get the default script run order
  pin_idx = order.index( 'pin-assignments.tcl' ) # find pin-assignments.tcl
  order.insert( pin_idx + 1, 'edge-blockages.tcl' ) # add here
  init.update_params( { 'order': order } )

  # Adding new input for genlibdb node to run
  order = genlibdb.get_param('order') # get the default script run order
  read_idx = order.index( 'read_design.tcl' ) # find read_design.tcl
  order.insert( read_idx + 1, 'genlibdb-constraints.tcl' ) # add here
  genlibdb.update_params( { 'order': order } )


  # Pwr aware steps:
  if pwr_aware:
      # init node
      order = init.get_param('order') 
      read_idx = order.index( 'floorplan.tcl' ) # find floorplan.tcl  
      order.insert( read_idx + 1, 'pe-load-upf.tcl' ) # add here
      order.insert( read_idx + 2, 'pd-pe-floorplan.tcl' ) # add here
      order.insert( read_idx + 3, 'pe-add-endcaps-welltaps-setup.tcl' ) # add here
      order.insert( read_idx + 4, 'pd-add-endcaps-welltaps.tcl' ) # add here
      order.insert( read_idx + 5, 'pe-power-switches-setup.tcl') # add here
      order.insert( read_idx + 6, 'add-power-switches.tcl' ) # add here
      order.remove('add-endcaps-welltaps.tcl')
      init.update_params( { 'order': order } )

      # power node
      order = power.get_param('order')
      order.insert( 0, 'pd-globalnetconnect.tcl' ) # add here
      order.remove('globalnetconnect.tcl')
      power.update_params( { 'order': order } )

      # place node
      order = place.get_param('order')
      read_idx = order.index( 'main.tcl' ) # find main.tcl  
      order.insert(read_idx - 1, 'place-dont-use-constraints.tcl')
      place.update_params( { 'order': order } )

      # cts node
      order = cts.get_param('order')
      order.insert( 0, 'conn-aon-cells-vdd.tcl' ) # add here 
      cts.update_params( { 'order': order } )

      # postcts_hold node
      order = postcts_hold.get_param('order')
      order.insert( 0, 'conn-aon-cells-vdd.tcl' ) # add here 
      postcts_hold.update_params( { 'order': order } )

      # route node
      order = route.get_param('order')
      order.insert( 0, 'conn-aon-cells-vdd.tcl' ) # add here 
      route.update_params( { 'order': order } )

      # postroute node
      order = postroute.get_param('order')
      order.insert( 0, 'conn-aon-cells-vdd.tcl' ) # add here 
      postroute.update_params( { 'order': order } )

      # signoff node
      order = signoff.get_param('order')
      order.insert( 0, 'conn-aon-cells-vdd.tcl' ) # add here 
      read_idx = order.index( 'generate-results.tcl' ) # find generate_results.tcl 
      order.insert(read_idx + 1, 'pd-generate-lvs-netlist.tcl')
      signoff.update_params( { 'order': order } )

  return g




if __name__ == '__main__':
  g = construct()
#  g.plot()


