from kratos import *

class GlcCfg:
    def __init__(self, p_glc_cfg_awidth, p_glc_cfg_dwidth):
        self.p_glc_cfg_awidth = p_glc_cfg_awidth
        self.p_glc_cfg_dwidth = p_glc_cfg_dwidth

    def master(self):
        class _GlcCfgMaster(PortBundle):
            def __init__(self, p_glc_cfg_awidth, p_glc_cfg_dwidth):
                super().__init__()

                # W ports
                self.output("wr_data", p_glc_cfg_dwidth)
                self.output("wr_addr", p_glc_cfg_awidth)
                self.output("wr_req", 1)
                self.input("wr_resp", 1)

                # R ports
                self.input("rd_data", p_glc_cfg_dwidth)
                self.output("rd_addr", p_glc_cfg_awidth)
                self.output("rd_req", 1)
                self.input("rd_resp", 1)

        return _GlcCfgMaster(self.p_glc_cfg_awidth, self.p_glc_cfg_dwidth)

    def slave(self):
        class _GlcCfgSlave(PortBundle):
            def __init__(self, p_glc_cfg_awidth, p_glc_cfg_dwidth):
                super().__init__()

                # W ports
                self.input("wr_data", p_glc_cfg_dwidth)
                self.input("wr_addr", p_glc_cfg_awidth)
                self.input("wr_req", 1)
                self.output("wr_resp", 1)

                # R ports
                self.output("rd_data", p_glc_cfg_dwidth)
                self.input("rd_addr", p_glc_cfg_awidth)
                self.input("rd_req", 1)
                self.output("rd_resp", 1)

        return _GlcCfgSlave(self.p_glc_cfg_awidth, self.p_glc_cfg_dwidth)
