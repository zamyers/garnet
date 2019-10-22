from kratos import *
from axil_if import Axil
from cfg_if import Cfg
from enum import Enum
from math import log2, ceil

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

class GlcAxilController(Generator):
    def __init__(self, p_axil_awidth, p_axil_dwidth):
        super().__init__("glc_axil_controller")

        # Parameters
        self.p_axil_awidth = p_axil_awidth
        self.p_axil_dwidth = p_axil_dwidth
        self.p_glc_cfg_awidth = p_axil_awidth
        self.p_glc_cfg_dwidth = p_axil_dwidth

        self.clk = self.clock("clk")
        self.rst_n = self.reset("rst_n")

        # Axi-lite interface
        self.axil_if = Axil(self.p_axil_awidth, self.p_axil_dwidth)
        self.axil_s = self.port_bundle("axil_s", self.axil_if.slave())

        # Global Controller internal interface
        self.glc_cfg_if = GlcCfg(self.p_glc_cfg_awidth, self.p_glc_cfg_dwidth)
        self.glc_cfg_m = self.port_bundle("glc_cfg_m", self.glc_cfg_if.master())

        # Declare internavl variables
        self.declare_internal_vars()

        # Add Axi-lite control logic
        self.add_code(self.seq_axi_wr_fsm)
        self.add_code(self.seq_axi_rd_fsm)

        # Output wiring
        self.output_wiring()

    def declare_internal_vars(self):
        self._rd_state = self.var("_rd_state", ceil(log2(len(RdState))))
        self._wr_state = self.var("_wr_state", ceil(log2(len(WrState))))

        self._arready = self.var("_arready", 1)
        self._awready = self.var("_awready", 1)
        self._wready = self.var("_wready", 1)

        self._rvalid = self.var("_rvalid", 1)
        self._rdata = self.var("_rdata", self.p_axil_dwidth)
        self._rresp = self.var("_rresp", 2)
        self._bresp = self.var("_bresp", 2)
        self._bvalid = self.var("_bvalid", 1)

    @always((posedge, "clk"), (negedge, "rst_n"))
    def seq_axi_wr_fsm(self):
        if ~self.rst_n:
            self._wr_state = WrState.IDLE.value

            self._awready = 0
            self._wready = 0
            self._bresp = 0b00
            self._bvalid = 0

            self.glc_cfg_m.wr_req = 0
            self.glc_cfg_m.wr_addr = 0
            self.glc_cfg_m.wr_data = 0
        else:
            # IDLE state
            if self._wr_state == WrState.IDLE.value:
                self._awready = 0
                self._wready = 0
                self._bresp = 0b00
                self._bvalid = 0

                self.glc_cfg_m.wr_req = 0
                self.glc_cfg_m.wr_data = 0
                self.glc_cfg_m.wr_addr = 0

                if self.axil_s.awvalid and self._awready:
                    self._awready = 0
                    self._wready = 1
                    self._wr_state = WrState.REQ.value
                    self.glc_cfg_m.wr_addr = self.axil_s.awaddr
                elif self.axil_s.awvalid:
                    self._awready = 1
            # REQ state
            elif self._wr_state == WrState.REQ.value:
                if self.axil_s.wvalid and self._wready:
                    self._wready = 0
                    self.glc_cfg_m.wr_req = 1
                    self.glc_cfg_m.wr_data = self.axil_s.wdata
                    self._wr_state = WrState.WAIT.value
            # WAIT state
            elif self._wr_state == WrState.WAIT.value:
                if self.glc_cfg_m.wr_resp:
                    self.glc_cfg_m.wr_req = 0
                    self._bresp = 0b00
                    self._bvalid = 1
                    self._wr_state = WrState.RESP.value
            # RESP state
            elif self._wr_state == WrState.RESP.value:
                if self.axil_s.bready and self._bvalid:
                    self._bvalid = 0
                    self._wr_state = WrState.IDLE.value

    @always((posedge, "clk"), (negedge, "rst_n"))
    def seq_axi_rd_fsm(self):
        if ~self.rst_n:
            self._rd_state = RdState.IDLE.value

            self._arready = 0
            self._rresp = 0b00
            self._rdata = 0

            self.glc_cfg_m.rd_req = 0
            self.glc_cfg_m.rd_addr = 0
        else:
            # IDLE state
            if self._rd_state == RdState.IDLE.value:
                self._arready = 0
                self._rresp = 0b00
                self._bvalid = 0

                self.glc_cfg_m.rd_req = 0
                self.glc_cfg_m.rd_addr = 0

                if self.axil_s.arvalid and self._arready:
                    self._arready = 0
                    self._rd_state = RdState.REQ.value
                    self.glc_cfg_m.rd_addr = self.axil_s.araddr
                # global controller can only handlee read or write at one time
                elif self.axil_s.arvalid and ~self.axil_s.awvalid:
                    self._arready = 1
            # REQ state
            elif self._rd_state == RdState.REQ.value:
                self.glc_cfg_m.rd_req = 1
                self._rd_state = RdState.WAIT.value
            # WAIT state
            elif self._rd_state == RdState.WAIT.value:
                if self.glc_cfg_m.rd_resp:
                    self.glc_cfg_m.rd_req = 0
                    self._rresp = 0b00
                    self._rvalid = 1
                    self._rdata = self.glc_cfg_m.rd_data
                    self._rd_state = RdState.RESP.value
            # RESP state
            elif self._rd_state == RdState.RESP.value:
                if self.axil_s.rready and self._rvalid:
                    self._rvalid = 0
                    self._rd_state = RdState.IDLE.value

    def output_wiring(self):
        self.wire(self.axil_s.awready, self._awready)
        self.wire(self.axil_s.wready, self._wready)
        self.wire(self.axil_s.bresp, self._bresp)
        self.wire(self.axil_s.bvalid, self._bvalid)
        self.wire(self.axil_s.arready, self._arready)
        self.wire(self.axil_s.rresp, self._rresp)
        self.wire(self.axil_s.rdata, self._rdata)
        self.wire(self.axil_s.rvalid, self._rvalid)
