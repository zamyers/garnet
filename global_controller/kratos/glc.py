from kratos import *
from axil_if import Axil

class GlobalController(Generator):
    def __init__(self, axil_awidth, axil_dwidth):
        super().__init__("global_controller")
        # Parameters
        self.axil_awidth = axil_awidth
        self.axil_dwidth = axil_dwidth

        # Axi-lite interface
        self.axil_if = Axil(self.axil_awidth, self.axil_dwidth)

        # Port declaration
        self._clk = self.clock("clk")
        self._rst_n = self.reset("rst_n")

        self.axil_m = self.port_bundle("axil_m", self.axil_if.master())
        self.axil_s = self.port_bundle("axil_s", self.axil_if.slave())

        self.inst_config_arbiter()
        self.axil_wiring()

    def config_arbiter(self):
        '''
        This function adds configuration arbiter between jtag and axi_lite
        '''
        self.add_child("config_arbiter_inst", ConfigArbiter

    def axil_wiring(self):
        self.wire(self.axil_s, self.axil_m)

if __name__ == "__main__":
    glc = GlobalController(16, 16)
    verilog(glc, filename="glc.sv")

