from kratos import *
from axil_if import Axil

class GlcCfgArbiter(Generator):
    def __init__(self, axil_awidth, axil_dwidth):
        super().__init__("cfg_arbiter")

        # Parameters
        self.axil_awidth = axil_awidth
        self.axil_dwidth = axil_dwidth

        # Axi-lite interface
        self.axil_if = Axil(self.axil_awidth, self.axil_dwidth)

        self.axil_m = self.port_bundle("axil_m", self.axil_if.master())
        self.axil_s = self.port_bundle("axil_s", self.axil_if.slave())

        self.axil_wiring()

    def axil_wiring(self):
        self.wire(self.axil_s, self.axil_m)
