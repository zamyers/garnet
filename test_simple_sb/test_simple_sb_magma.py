import pytest
import tempfile
import random
from bit_vector import BitVector
import magma
import fault
import fault.random
from common.core import Core
from simple_sb.simple_sb_magma import SB
from simple_sb.simple_sb_model import SimpleSBModel, SimpleSBTester, SideModel


class DummyCore(Core):
    def __init__(self):
        super().__init__()

        TData = magma.Bits(16)
        TBit = magma.Bits(1)

        self.add_ports(
            data_in=magma.In(TData),
            bit_in=magma.In(TBit),
            data_out=magma.Out(TData),
            bit_out=magma.Out(TBit),
        )

        self.wire(self.ports.data_in, self.ports.data_out)
        self.wire(self.ports.bit_in, self.ports.bit_out)

    def inputs(self):
        return (self.ports.data_in, self.ports.bit_in)

    def outputs(self):
        return (self.ports.data_out, self.ports.bit_out)

    def name(self):
        return "DummyCore"


def test_regression():
    # Create magma circuit.
    dummy_core = DummyCore()
    simple_sb = SB(dummy_core.outputs())

    for output in dummy_core.outputs():
        port_name = output._name
        port = simple_sb.ports.get(port_name, None)
        assert port is not None
        assert port.type() == output.type().flip()

    NUM_TRACKS = 5
    LAYERS = (1, 16)
    SIDES = ("north", "west", "south", "east")
    num_core_outputs = len(dummy_core.outputs())

    simple_sb_circuit = simple_sb.circuit()
    tester = fault.Tester(simple_sb_circuit, simple_sb_circuit.clk)
    model = SimpleSBModel(NUM_TRACKS, LAYERS, num_core_outputs)
    simple_sb_tester = SimpleSBTester(
        NUM_TRACKS, LAYERS, num_core_outputs, model, tester)

    config = {side: SideModel(NUM_TRACKS, LAYERS) for side in SIDES}
    in_ = {side: SideModel(NUM_TRACKS, LAYERS) for side in SIDES}

    for side in SIDES:
        for layer in LAYERS:
            for track in range(NUM_TRACKS):
                config[side].values[layer][track] = random.randint(0, 3)
                in_[side].values[layer][track] = fault.random.random_bv(layer)

    core_outputs = {
        "data_out": fault.random.random_bv(16),
        "bit_out": fault.random.random_bv(1),
    }

    simple_sb_tester.reset()
    simple_sb_tester.configure(config)
    simple_sb_tester(in_, core_outputs)

    with tempfile.TemporaryDirectory() as tempdir:
        simple_sb_tester.tester.compile_and_run(target="verilator",
                                                magma_output="coreir-verilog",
                                                directory=tempdir,
                                                flags=["-Wno-fatal"])