from kratos import *
from interface.handshake_ifc import Handshake
from math import log2, ceil
from collections import namedtuple

class GlcCore(Generator):
    def __init__(self, p_glc_hs_awidth, p_glc_hs_dwidth):
        super().__init__("glc_core", True)

        # register list
        self._Reg = namedtuple('Reg', 'name reg addr width')
        self._regs = []

        # Parameters
        self.p_glc_hs_awidth = p_glc_hs_awidth
        self.p_glc_hs_dwidth = p_glc_hs_dwidth
        self.p_glc_hs_byte_offset = ceil(log2(p_glc_hs_dwidth/8))

        # Global Controller internal interface
        self.glc_hs_ifc = Handshake(self.p_glc_hs_awidth, self.p_glc_hs_dwidth)

        # declare ports
        self.clk = self.clock("clk")
        self.rst_n = self.reset("rst_n")

        # glc handshake slave ports
        self.glc_hs_s = self.port_bundle("glc_hs_s", self.glc_hs_ifc.slave())

        self.declare_internal_vars()
        self.define_reg()
        self.add_code(self.seq_reg_write)
        self.add_code(self.seq_reg_read)

    def add_regs(self, _name, _addr, _width):
        _reg = self._Reg(name=_name, reg=self.var(_name, _width),
                         addr=_addr, width=_width)
        self._regs.append(_reg)

    def define_reg(self):
        self._ier = self.add_reg("ier", 0, 2)
        self._isr = self.add_reg("isr", 1, 2)
        self._cgra_wr_en = self.add_reg("cgra_wr_en", 2, 1)
        self._cgra_rd_en = self.add_reg("cgra_rd_en", 3, 1)
        self._cgra_addr = self.add_reg("cgra_addr", 4, 32)
        self._cgra_wr_data = self.add_reg("cgra_wr_data", 5, 32)
        self._cgra_rd_data = self.add_reg("cgra_rd_data", 6, 32)

    def declare_internal_vars(self):
        self._rd_addr = self.var("rd_addr",
                self.p_glc_hs_awidth - self.p_glc_hs_byte_offset)
        self.wire(self._rd_addr,
                  self.glc_hs_s.rd_addr[self.p_glc_hs_awidth - 1,
                                        self.p_glc_hs_byte_offset])

        self._wr_addr = self.var("wr_addr",
                self.p_glc_hs_awidth - self.p_glc_hs_byte_offset)
        self.wire(self._wr_addr,
                  self.glc_hs_s.wr_addr[self.p_glc_hs_awidth - 1,
                                        self.p_glc_hs_byte_offset])

        self._rd_data = self.var("rd_data", self.p_glc_hs_dwidth)
        self.wire(self.glc_hs_s.rd_data, self._rd_data)

    @always((posedge, "clk"), (negedge, "rst_n"))
    def seq_reg_write(self):
        if ~self.rst_n:
            for idx in range(len(self._regs)):
                self._regs[idx].reg = 0
            self.glc_hs_s.wr_ack = 0
        elif (self.glc_hs_s.wr_req):
            self.glc_hs_s.wr_ack = 1
            for idx in range(len(self._regs)):
                if self._wr_addr == self._regs[idx].addr:
                    self._regs[idx].reg = self.glc_hs_s.wr_data[self._regs[idx].width-1, 0]
        else:
            self.glc_hs_s.wr_ack = 0

    @always((posedge, "clk"), (negedge, "rst_n"))
    def seq_reg_read(self):
        if ~self.rst_n:
            self._rd_data = 0
            self.glc_hs_s.rd_ack = 0
        elif (self.glc_hs_s.rd_req):
            self.glc_hs_s.rd_ack = 1
            for idx in range(len(self._regs)):
                if self._rd_addr == self._regs[idx].addr:
                    self._rd_data = ext(self._regs[idx].reg, self._rd_data.width)
        else:
            self.glc_hs_s.rd_ack = 0
