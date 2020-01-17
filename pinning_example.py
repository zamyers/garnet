import magma
import mantle
from gemstone.generator.generator import Generator
from gemstone.generator.from_magma import FromMagma
from gemstone.common.mux_wrapper import MuxWrapper
from pinning_pass.abutted_pins import assign_abutted_pins


class SomeFunctionalCell(Generator):
    def __init__(self, width):
        super().__init__()

        self.width = width
        T = magma.Bits[self.width]

        self.add_ports(
            I1=magma.In(T),
            I2=magma.In(T),
            I3=magma.In(T),
            O3=magma.Out(T),
            O1=magma.Out(T),
            O2=magma.Out(T),
        )
        assert(self.width > 1)
        self.wire(self.ports.I1, self.ports.O1)
        self.wire(self.ports.I2, self.ports.O2)
        self.wire(self.ports.I3, self.ports.O3)

    def name(self):
        return f"Cell{self.width}"


class ChainOfCells(Generator):
    def __init__(self):
        super().__init__()

        self.width = 2
        self.length = 8

        T = magma.Bits[self.width]

        self.add_ports(
            I1=magma.In(T),
            I2=magma.In(T),
            I3=magma.In(T),
            O1=magma.Out(T),
            O2=magma.Out(T),
            O3=magma.Out(T),
        )

        self.cells = [SomeFunctionalCell(self.width) for _ in range(self.length)]

        self.wire(self.ports.I1, self.cells[0].ports.I1)
        self.wire(self.ports.I2, self.cells[0].ports.I2)
        self.wire(self.ports.I3, self.cells[0].ports.I3)
        for i, cell in enumerate(self.cells):
            if i == (len(self.cells) - 1):
                self.wire(cell.ports.O1, self.ports.O1)
                self.wire(cell.ports.O2, self.ports.O2)
                self.wire(cell.ports.O3, self.ports.O3)
                continue
            self.wire(cell.ports.O1, self.cells[i + 1].ports.I1)
            self.wire(cell.ports.O2, self.cells[i + 1].ports.I2)
            self.wire(cell.ports.O3, self.cells[i + 1].ports.I3)

    def name(self):
        return "ChainOfCells"


gen = ChainOfCells()
assign_abutted_pins(gen.cells[1], left=gen.cells[0], right=gen.cells[2])
#circ = gen.circuit()
#print (repr(circ))
#magma.compile(circ.name, circ, output="coreir-verilog")

#inst = circ.instances[0]
#print (inst.name)
#print (type(inst).name)
#print (type(inst)().name)

#print ([inst.name for inst in circ.instances])
#print (ChainOfCells().name())
#print (repr(ChainOfCells().circuit()))
