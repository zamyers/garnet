from kratos import *
from interface.axil_ifc import Axil
from interface.handshake_ifc import Handshake
from enum import Enum

class GlcAxilController(Generator):
    def __init__(self, p_axil_awidth, p_axil_dwidth):
        super().__init__("glc_axil_controller", True)

        # Parameters
        self.p_axil_awidth = p_axil_awidth
        self.p_axil_dwidth = p_axil_dwidth
        self.p_glc_hs_awidth = p_axil_awidth
        self.p_glc_hs_dwidth = p_axil_dwidth

        self.clk = self.clock("clk")
        self.rst_n = self.reset("rst_n")

        # read state
        self.RdState = self.enum("RdState", {"RD_IDLE": 0, "RD_REQ": 1, "RD_WAIT": 2, "RD_RESP": 3})
        # write state
        self.WrState = self.enum("WrState", {"WR_IDLE": 0, "WR_REQ": 1, "WR_WAIT": 2, "WR_RESP": 3})

        # Axi-lite interface
        self.axil_ifc = Axil(self.p_axil_awidth, self.p_axil_dwidth)
        self.axil_s = self.port_bundle("axil_s", self.axil_ifc.slave())

        # Global Controller internal interface
        self.glc_hs_ifc = Handshake(self.p_glc_hs_awidth, self.p_glc_hs_dwidth)
        self.glc_hs_m = self.port_bundle("glc_hs_m", self.glc_hs_ifc.master())

        # Declare internavl variables
        self.declare_internal_vars()

        # Add Axi-lite control logic
        self.add_code(self.seq_axi_wr_fsm)
        self.add_code(self.seq_axi_rd_fsm)

        # Output wiring
        self.output_wiring()

    def declare_internal_vars(self):
        self._rd_state = self.enum_var("rd_state", self.RdState)
        self._wr_state = self.enum_var("wr_state", self.WrState)

        self._arready = self.var("arready", 1)
        self._awready = self.var("awready", 1)
        self._wready = self.var("wready", 1)

        self._rvalid = self.var("rvalid", 1)
        self._rdata = self.var("rdata", self.p_axil_dwidth)
        self._rresp = self.var("rresp", 2)
        self._bresp = self.var("bresp", 2)
        self._bvalid = self.var("bvalid", 1)

    @always((posedge, "clk"), (negedge, "rst_n"))
    def seq_axi_wr_fsm(self):
        if ~self.rst_n:
            self._wr_state = self.WrState.WR_IDLE

            self._awready = 0
            self._wready = 0
            self._bresp = 0b00
            self._bvalid = 0

            self.glc_hs_m.wr_req = 0
            self.glc_hs_m.wr_addr = 0
            self.glc_hs_m.wr_data = 0
        else:
            # IDLE state
            if self._wr_state == self.WrState.WR_IDLE:
                self._awready = 0
                self._wready = 0
                self._bresp = 0b00
                self._bvalid = 0

                self.glc_hs_m.wr_req = 0
                self.glc_hs_m.wr_data = 0
                self.glc_hs_m.wr_addr = 0

                if self.axil_s.awvalid & self._awready:
                    self._awready = 0
                    self._wready = 1
                    self._wr_state = self.WrState.WR_REQ
                    self.glc_hs_m.wr_addr = self.axil_s.awaddr
                elif self.axil_s.awvalid:
                    self._awready = 1
            # REQ state
            elif self._wr_state == self.WrState.WR_REQ:
                if self.axil_s.wvalid & self._wready:
                    self._wready = 0
                    self.glc_hs_m.wr_req = 1
                    self.glc_hs_m.wr_data = self.axil_s.wdata
                    self._wr_state = self.WrState.WR_WAIT
            # WAIT state
            elif self._wr_state == self.WrState.WR_WAIT:
                if self.glc_hs_m.wr_ack:
                    self.glc_hs_m.wr_req = 0
                    self._bresp = 0b00
                    self._bvalid = 1
                    self._wr_state = self.WrState.WR_RESP
            # RESP state
            elif self._wr_state == self.WrState.WR_RESP:
                if self.axil_s.bready & self._bvalid:
                    self._bvalid = 0
                    self._wr_state = self.WrState.WR_IDLE

    @always((posedge, "clk"), (negedge, "rst_n"))
    def seq_axi_rd_fsm(self):
        if ~self.rst_n:
            self._rd_state = self.RdState.RD_IDLE

            self._arready = 0
            self._rresp = 0b00
            self._rdata = 0

            self.glc_hs_m.rd_req = 0
            self.glc_hs_m.rd_addr = 0
        else:
            # IDLE state
            if self._rd_state == self.RdState.RD_IDLE:
                self._arready = 0
                self._rresp = 0b00
                self._bvalid = 0

                self.glc_hs_m.rd_req = 0
                self.glc_hs_m.rd_addr = 0

                if self.axil_s.arvalid & self._arready:
                    self._arready = 0
                    self._rd_state = self.RdState.RD_REQ
                    self.glc_hs_m.rd_addr = self.axil_s.araddr
                # global controller can only handlee read or write at one time
                elif self.axil_s.arvalid & ~self.axil_s.awvalid:
                    self._arready = 1
            # REQ state
            elif self._rd_state == self.RdState.RD_REQ:
                self.glc_hs_m.rd_req = 1
                self._rd_state = self.RdState.RD_WAIT
            # WAIT state
            elif self._rd_state == self.RdState.RD_WAIT:
                if self.glc_hs_m.rd_ack:
                    self.glc_hs_m.rd_req = 0
                    self._rresp = 0b00
                    self._rvalid = 1
                    self._rdata = self.glc_hs_m.rd_data
                    self._rd_state = self.RdState.RD_RESP
            # RESP state
            elif self._rd_state == self.RdState.RD_RESP:
                if self.axil_s.rready & self._rvalid:
                    self._rvalid = 0
                    self._rd_state = self.RdState.RD_IDLE

    def output_wiring(self):
        self.wire(self.axil_s.awready, self._awready)
        self.wire(self.axil_s.wready, self._wready)
        self.wire(self.axil_s.bresp, self._bresp)
        self.wire(self.axil_s.bvalid, self._bvalid)
        self.wire(self.axil_s.arready, self._arready)
        self.wire(self.axil_s.rresp, self._rresp)
        self.wire(self.axil_s.rdata, self._rdata)
        self.wire(self.axil_s.rvalid, self._rvalid)
