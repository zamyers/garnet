from kratos import *
from axil_if import Axil
from glc_axil_controller import GlcAxilController

class GlobalController(Generator):
    def __init__(self, p_axil_awidth, p_axil_dwidth):
        super().__init__("global_controller")
        # Parameters
        self.p_axil_awidth = p_axil_awidth
        self.p_axil_dwidth = p_axil_dwidth

        # Axi-lite interface
        self.axil_if = Axil(self.p_axil_awidth, self.p_axil_dwidth)

        # Port declaration
        self.clk = self.clock("clk")
        self.rst_n = self.reset("rst_n")

        self.axil_s = self.port_bundle("axil_s", self.axil_if.slave())

        self.inst_config_arbiter()

    def inst_config_arbiter(self):
        '''
        This function instantiates configuration arbiter
        '''
        self.add_child("axil_controller",
                GlcAxilController(self.p_axil_awidth, self.p_axil_dwidth),
                comment="axi-lite controller")
        self.wire(self.clk, self["axil_controller"].clk)
        self.wire(self.rst_n, self["axil_controller"].rst_n)
        self.wire(self.axil_s, self["axil_controller"].axil_s)

if __name__ == "__main__":
    glc = GlobalController(16, 16)
    verilog(glc, filename="glc.sv", optimize_passthrough=False)
