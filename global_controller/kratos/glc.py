from kratos import *
from axil_if import Axil
from glc_cfg_arbiter import GlcCfgArbiter

class GlobalController(Generator):
    def __init__(self, axil_awidth, axil_dwidth):
        super().__init__("global_controller")
        # Parameters
        self.axil_awidth = axil_awidth
        self.axil_dwidth = axil_dwidth

        # Axi-lite interface
        self.axil_if = Axil(self.axil_awidth, self.axil_dwidth)

        # Port declaration
        self.axil_in = self.port_bundle("axil_in", self.axil_if.input())
        self._clk = self.axil_in.ports.clk
        self._rst_n = self.axil_in.ports.resetn

        self.axil_m = self.port_bundle("axil_m", self.axil_if.master())
        self.axil_s = self.port_bundle("axil_s", self.axil_if.slave())

        self.inst_config_arbiter()

    def inst_config_arbiter(self):
        '''
        This function instantiates configuration arbiter
        '''
        self.add_child("cfg_arbiter",
                GlcCfgArbiter(self.axil_awidth, self.axil_dwidth),
                comment="configuration arbiter")
        self.wire(self.axil_m, self["cfg_arbiter"].axil_m)
        self.wire(self.axil_s, self["cfg_arbiter"].axil_s)

if __name__ == "__main__":
    glc = GlobalController(16, 16)
    verilog(glc, filename="glc.sv", optimize_passthrough=False)
