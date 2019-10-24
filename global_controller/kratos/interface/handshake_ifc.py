from kratos import *

class Handshake:
    def __init__(self, p_hs_awidth, p_hs_dwidth):
        self.p_hs_awidth = p_hs_awidth
        self.p_hs_dwidth = p_hs_dwidth

    def master(self):
        class HsMaster(PortBundle):
            def __init__(self, p_hs_awidth, p_hs_dwidth):
                super().__init__()

                # W ports
                self.output("wr_data", p_hs_dwidth)
                self.output("wr_addr", p_hs_awidth)
                self.output("wr_req", 1)
                self.input("wr_ack", 1)

                # R ports
                self.input("rd_data", p_hs_dwidth)
                self.output("rd_addr", p_hs_awidth)
                self.output("rd_req", 1)
                self.input("rd_ack", 1)

        return HsMaster(self.p_hs_awidth, self.p_hs_dwidth)

    def slave(self):
        class HsSlave(PortBundle):
            def __init__(self, p_hs_awidth, p_hs_dwidth):
                super().__init__()

                # W ports
                self.input("wr_data", p_hs_dwidth)
                self.input("wr_addr", p_hs_awidth)
                self.input("wr_req", 1)
                self.output("wr_ack", 1)

                # R ports
                self.output("rd_data", p_hs_dwidth)
                self.input("rd_addr", p_hs_awidth)
                self.input("rd_req", 1)
                self.output("rd_ack", 1)

        return HsSlave(self.p_hs_awidth, self.p_hs_dwidth)
