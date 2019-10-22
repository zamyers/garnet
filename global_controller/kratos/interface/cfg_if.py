from kratos import *

class Cfg:
    def __init__(self, p_cfg_awidth, p_cfg_dwidth):
        self.p_cfg_awidth = p_cfg_awidth
        self.p_cfg_dwidth = p_cfg_dwidth

    def master(self):
        class CfgMaster(PortBundle):
            def __init__(self, p_cfg_awidth, p_cfg_dwidth):
                super().__init__()

                self.output("rd_en", 1)
                self.output("wr_en", 1)
                self.output("addr", p_cfg_awidth)
                self.output("wr_data", p_cfg_dwidth)
                self.input("rd_data", p_cfg_dwidth)

        return CfgMaster(self.p_cfg_awidth, self.p_cfg_dwidth)

    def slave(self):
        class CfgSlave(PortBundle):
            def __init__(self, p_cfg_awidth, p_cfg_dwidth):
                super().__init__()

                self.input("wr_en", 1)
                self.input("rd_en", 1)
                self.input("addr", p_cfg_awidth)
                self.input("wr_data", p_cfg_dwidth)
                self.output("rd_data", p_cfg_dwidth)

        return CfgSlave(self.p_cfg_awidth, self.p_cfg_dwidth)
