from kratos import *
from axil_if import Axil
from enum import Enum
from math import log2, ceil

class GlcCfgArbiter(Generator):
    def __init__(self, p_axil_awidth, p_axil_dwidth):
        super().__init__("cfg_arbiter")

        # Parameters
        self.p_axil_awidth = p_axil_awidth
        self.p_axil_dwidth = p_axil_dwidth

        # read state
        class RdState(Enum):
            IDLE = 0
            REQ = 1
            WAIT = 2
            RESP = 3

        # write state
        class WrState(Enum):
            IDLE = 0
            REQ = 1
            WAIT = 2
            RESP = 3

        self.clk = self.clock("clk")
        self.rst_n = self.reset("rst_n")

        # Axi-lite interface
        self.axil_if = Axil(self.p_axil_awidth, self.p_axil_dwidth)
        self.axil_s = self.port_bundle("axil_s", self.axil_if.slave())

        # add configuration ports
        self.add_cfg_ports()

        # Declare internavl variables
        self.declare_internal_var()

        # Add Axi-lite control logic
        self.add_code(self.seq_axi_wr_fsm)
        self.add_code(self.seq_axi_rd_fsm)

    def add_cfg_ports(self):
        self._cfg_wr_req = self.output("_cfg_wr_req", 1)
        self._cfg_wr_addr = self.output("_cfg_wr_addr", self.p_axil_awidth)
        self._cfg_wr_data = self.output("_cfg_wr_data", self.p_axil_dwidth)
        self._cfg_wr_resp = self.intput("_cfg_wr_resp", 1)
        self._cfg_rd_req = self.output("_cfg_rd_req", 1)
        self._cfg_rd_addr = self.output("_cfg_rd_addr", self.p_axil_awidth)
        self._cfg_rd_data = self.output("_cfg_rd_data", self.p_axil_dwidth)
        self._cfg_rd_resp = self.var("_cfg_rd_resp", 1)

    def declare_internal_vars(self):
        self._rd_state = self.var("_rd_state", ceil(log2(len(RdState))))
        self._wr_state = self.var("_wr_state", ceil(log2(len(WrState))))

        self._arready = self.var("_arready", 1)
        self._wready = self.var("_wready", 1)

        self._rvalid = self.var("_rvalid", 1)
        self._rdata = self.var("_rdata", self.p_axil_dwidth)
        self._rresp = self.var("_rresp", 2)
        self._bresp = self.var("_bresp", 2)
        self._bvalid = self.var("_bvalid", 1)

    @always((posedge, "clk"), (negedge, "rst_n"))
    def seq_axi_wr_fsm(self):
        if ~self.rst_n:
            self._wr_state = WrState.IDLE

            self._awready = 0
            self._wready = 0
            self._bresp = 0b00
            self._bvalid = 0

            self._cfg_wr_req = 0
            self._cfg_wr_addr = 0
            self._cfg_wr_data = 0
        else:
            # IDLE state
            if self._wr_state == WrState.IDLE:
                self._awready = 0
                self._wready = 0
                self._bresp = 0b00
                self._bvalid = 0

                self._cfg_wr_req = 0
                self._cfg_wr_data = 0
                self._cfg_wr_addr = 0

                if self.axil_s.awvalid and self._awready:
                    self._awready = 0
                    self._wready = 1
                    self._wr_state == WrState.REQ
                    self._cfg_wr_addr = self.axil_s.awaddr
                elif self.axil_s.awvalid:
                    self._awready = 1
            # REQ state
            elif self._wr_state == WrState.REQ:
                if self.axil_s.wvalid and self._wready:
                    self._wready = 0
                    self._cfg_wr_req = 1
                    self._cfg_wr_data = self.axil_s.wdata
                    self._wr_state = WrState.WAIT
            # WAIT state
            elif self._wr_state == WrState.WAIT:
                if self._cfg_wr_resp:
                    self._cfg_wr_req = 0
                    self._bresp = 0b00
                    self._bvalid = 1
                    self._wr_state = WrState.RESP
            # RESP state
            elif self._wr_state == WrState.RESP:
                if self.axil_s.bready and self._bvalid:
                    self._bvalid = 0
                    self._wr_state = WrState.IDLE

    @always((posedge, "clk"), (negedge, "rst_n"))
    def seq_axi_rd_fsm(self):
        if ~self.rst_n:
            self._rd_state = RdState.IDLE

            self._arready = 0
            self._rready = 0
            self._rresp = 0b00
            self._rdata = 0

            self._cfg_rd_req = 0
            self._cfg_rd_addr = 0
        else:
            # IDLE state
            if self._rd_state == RdState.IDLE:
                self._arready = 0
                self._rresp = 0b00
                self._bvalid = 0

                self._cfg_rd_req = 0
                self._cfg_rd_addr = 0

                if self.axil_s.arvalid and self._arready:
                    self._arready = 0
                    self._rd_state == RdState.REQ
                    self._cfg_rd_addr = self.axil_s.araddr
                # global controller can only handlee read or write at one time
                elif self.axil_s.arvalid and ~self.axil_s.awvalid:
                    self._arready = 1
            # REQ state
            elif self._rd_state == RdState.REQ:
                if self.axil_s.wvalid and self._rready:
                    self._rready = 0
                    self._cfg_rd_req = 1
                    self._cfg_rd_data = self.axil_s.wdata
                    self._rd_state = RdState.WAIT
            # WAIT state
            elif self._rd_state == RdState.WAIT:
                if self._cfg_rd_resp:
                    self._cfg_rd_req = 0
                    self._rresp = 0b00
                    self._bvalid = 1
                    self._rd_state = RdState.RESP
            # RESP state
            elif self._rd_state == RdState.RESP:
                if self.axil_s.rready and self._bvalid:
                    self._bvalid = 0
                    self._rd_state = RdState.IDLE
