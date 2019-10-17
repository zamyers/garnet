from kratos import *
from axil_if import Axil
from glc_cfg_arbiter import GlcCfgArbiter

class GlobalController(Generator):
    def __init__(self, p_axil_awidth, p_axil_dwidth):
        super().__init__("global_controller")
        # Parameters
        self.p_axil_awidth = p_axil_awidth
        self.p_axil_dwidth = p_axil_dwidth

        # Axi-lite interface
        self.axil_if = Axil(self.p_axil_awidth, self.p_axil_dwidth)

        # Port declaration
        self.axil_in = self.port_bundle("axil_in", self.axil_if.input())
        self._clk = self.axil_in.ports.clk
        self._rst_n = self.axil_in.ports.resetn

        self.axil_s = self.port_bundle("axil_s", self.axil_if.slave())

        self.inst_config_arbiter()

    def inst_config_arbiter(self):
        '''
        This function instantiates configuration arbiter
        '''
        self.add_child("cfg_arbiter",
                GlcCfgArbiter(self.p_axil_awidth, self.p_axil_dwidth),
                comment="configuration arbiter")
        self.wire(self._clk, self["cfg_arbiter"]._clk)
        self.wire(self._rst_n, self["cfg_arbiter"]._rst_n)
        self.wire(self.axil_s, self["cfg_arbiter"].axil_s)

if __name__ == "__main__":
    glc = GlobalController(16, 16)
    verilog(glc, filename="glc.sv", optimize_passthrough=False)
