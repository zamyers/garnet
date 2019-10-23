
#!/bin/bash

DESIGN=top

DIR=`pwd`

Genesis2.pl                                        \
    -parse                                                                                          \
    -generate                                                                                       \
    -top ${DESIGN}                                                                                    \
    -input axi_driver.svp \
    cfg_ifc.svp \
    clocker.svp \
    JTAGDriver.svp \
    template_ifc.svp \
    axi_ctrl.svp \
    cfg_and_dbg.svp \
    flop.svp \
    global_controller.svp \
    jtag.svp \
    tap.svp \
    test.svp \
    top.svp
