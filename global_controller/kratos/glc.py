from kratos import *
from interface.axil_if import Axil
from interface.handshake_if import Handshake
from interface.cfg_if import Cfg
from glc_axil_controller import GlcAxilController

class GlobalController(Generator):
    def __init__(self, p_axil_awidth, p_axil_dwidth):
        super().__init__("global_controller")

        # Parameters
        self.p_axil_awidth = p_axil_awidth
        self.p_axil_dwidth = p_axil_dwidth

        self.p_cgra_cfg_awidth = 32
        self.p_cgra_cfg_dwidth = 32

        self.p_glb_cfg_awidth = self.p_axil_awidth
        self.p_glb_cfg_dwidth = self.p_axil_dwidth

        self.p_glc_hs_awidth = self.p_axil_awidth
        self.p_glc_hs_dwidth = self.p_axil_dwidth

        self.p_glb_hs_awidth = self.p_axil_awidth
        self.p_glb_hs_dwidth = self.p_axil_dwidth

        # Axi-lite interface
        self.axil_if = Axil(self.p_axil_awidth, self.p_axil_dwidth)

        # Config interface
        self.cgra_cfg_if = Cfg(self.p_cgra_cfg_awidth, self.p_cgra_cfg_dwidth)
        self.glb_cfg_if = Cfg(self.p_glb_cfg_awidth, self.p_glb_cfg_dwidth)

        # Global controller internal handshake interface
        self.glc_hs_if = Handshake(self.p_glc_hs_awidth, self.p_glc_hs_dwidth)
        self.glb_hs_if = Handshake(self.p_glb_hs_awidth, self.p_glb_hs_dwidth)

        # Port declaration
        self.clk = self.clock("clk")
        self.rst_n = self.reset("rst_n")
        self.axil_s = self.port_bundle("axil_s", self.axil_if.slave())
        self.glb_cfg_m = self.port_bundle("glb_cfg_m", self.glb_cfg_if.master())

        self.inst_axil_controller()
        self.inst_cfg_arbiter()
        self.inst_glc_core()

    def inst_axil_controller(self):
        '''
        This function instantiates configuration arbiter
        '''
        self.add_child("glc_axil_controller",
                GlcAxilController(self.p_axil_awidth, self.p_axil_dwidth),
                comment="axi-lite controller")
        self.wire(self.clk, self["glc_axil_controller"].clk)
        self.wire(self.rst_n, self["glc_axil_controller"].rst_n)
        self.wire(self.axil_s, self["glc_axil_controller"].axil_s)

    def inst_cfg_arbiter(self):
        pass

    def inst_glc_core(self):
        pass

if __name__ == "__main__":
    glc = GlobalController(16, 16)
    verilog(glc, filename="glc.sv",
            output_dir = "src",
            optimize_passthrough=False)
