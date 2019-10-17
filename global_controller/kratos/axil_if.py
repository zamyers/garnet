from kratos import *

class Axil:
    def __init__(self, p_axil_awidth, p_axil_dwidth):
        self.p_axil_awidth = p_axil_awidth
        self.p_axil_dwidth = p_axil_dwidth

    def input(self):
        class _AxilInput(PortBundle):
            def __init__(self):
                super().__init__()

                # clk
                self.clock("clk", 1)
                # reset
                self.reset("resetn", 1)

        return _AxilInput()

    def master(self):
        class _AxilMaster(PortBundle):
            def __init__(self, p_axil_awidth, p_axil_dwidth):
                super().__init__()

                # AW ports
                self.output("awaddr", p_axil_awidth)
                self.output("awprot", 3)
                self.output("awvalid", 1)
                self.input("awready", 1)

                # W ports
                self.output("wdata", p_axil_dwidth)
                self.output("wstrb", int(p_axil_dwidth/8))
                self.output("wvalid", 1)
                self.input("wready", 1)

                # B ports
                self.input("bresp", 2)
                self.output("bready", 1)
                self.input("bvalid", 1)

                # AR ports
                self.output("araddr", p_axil_awidth)
                self.output("arprot", 3)
                self.output("arvalid", 1)
                self.input("arready", 1)

                # R ports
                self.input("rdata", p_axil_dwidth)
                self.input("rresp", 2)
                self.input("rvalid", 1)
                self.output("rready", 1)

        return _AxilMaster(self.p_axil_awidth, self.p_axil_dwidth)

    def slave(self):
        class _AxilSlave(PortBundle):
            def __init__(self, p_axil_awidth, p_axil_dwidth):
                super().__init__()

                # AW ports
                self.input("awaddr", p_axil_awidth)
                self.input("awprot", 3)
                self.input("awvalid", 1)
                self.output("awready", 1)

                # W ports
                self.input("wdata", p_axil_dwidth)
                self.input("wstrb", int(p_axil_dwidth/8))
                self.input("wvalid", 1)
                self.output("wready", 1)

                # B ports
                self.output("bresp", 2)
                self.input("bready", 1)
                self.output("bvalid", 1)

                # AR ports
                self.input("araddr", p_axil_awidth)
                self.input("arprot", 3)
                self.input("arvalid", 1)
                self.output("arready", 1)

                # R ports
                self.output("rdata", p_axil_dwidth)
                self.output("rresp", 2)
                self.output("rvalid", 1)
                self.input("rready", 1)

        return _AxilSlave(self.p_axil_awidth, self.p_axil_dwidth)
